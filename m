Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B104057E05
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2019 10:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfF0IOC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 04:14:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:47820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfF0IOC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 04:14:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0C91FABC7;
        Thu, 27 Jun 2019 08:13:59 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH] ftrace: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()
Date:   Thu, 27 Jun 2019 10:13:34 +0200
Message-Id: <20190627081334.12793-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The commit 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module text
permissions race") causes a possible deadlock between register_kprobe()
and ftrace_run_update_code() when ftrace is using stop_machine().

The existing dependency chain (in reverse order) is:

-> #1 (text_mutex){+.+.}:
       validate_chain.isra.21+0xb32/0xd70
       __lock_acquire+0x4b8/0x928
       lock_acquire+0x102/0x230
       __mutex_lock+0x88/0x908
       mutex_lock_nested+0x32/0x40
       register_kprobe+0x254/0x658
       init_kprobes+0x11a/0x168
       do_one_initcall+0x70/0x318
       kernel_init_freeable+0x456/0x508
       kernel_init+0x22/0x150
       ret_from_fork+0x30/0x34
       kernel_thread_starter+0x0/0xc

-> #0 (cpu_hotplug_lock.rw_sem){++++}:
       check_prev_add+0x90c/0xde0
       validate_chain.isra.21+0xb32/0xd70
       __lock_acquire+0x4b8/0x928
       lock_acquire+0x102/0x230
       cpus_read_lock+0x62/0xd0
       stop_machine+0x2e/0x60
       arch_ftrace_update_code+0x2e/0x40
       ftrace_run_update_code+0x40/0xa0
       ftrace_startup+0xb2/0x168
       register_ftrace_function+0x64/0x88
       klp_patch_object+0x1a2/0x290
       klp_enable_patch+0x554/0x980
       do_one_initcall+0x70/0x318
       do_init_module+0x6e/0x250
       load_module+0x1782/0x1990
       __s390x_sys_finit_module+0xaa/0xf0
       system_call+0xd8/0x2d0

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(text_mutex);
                               lock(cpu_hotplug_lock.rw_sem);
                               lock(text_mutex);
  lock(cpu_hotplug_lock.rw_sem);

It is similar problem that has been solved by the commit 2d1e38f56622b9b
("kprobes: Cure hotplug lock ordering issues"). Many locks are involved.
To be on the safe side, text_mutex must become a low level lock taken
after cpu_hotplug_lock.rw_sem.

This can't be achieved easily with the current ftrace design.
For example, arm calls set_all_modules_text_rw() already in
ftrace_arch_code_modify_prepare(), see arch/arm/kernel/ftrace.c.
This functions is called:

  + outside stop_machine() from ftrace_run_update_code()
  + without stop_machine() from ftrace_module_enable()

Fortunately, the problematic fix is needed only on x86_64. It is
the only architecture that calls set_all_modules_text_rw()
in ftrace path and supports livepatching at the same time.

Therefore it is enough to move text_mutex handling from the generic
kernel/trace/ftrace.c into arch/x86/kernel/ftrace.c:

   ftrace_arch_code_modify_prepare()
   ftrace_arch_code_modify_post_process()

This patch basically reverts the ftrace part of the problematic
commit 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module
text permissions race"). And provides x86_64 specific-fix.

Some refactoring of the ftrace code will be needed when livepatching
is implemented for arm or nds32. These architectures call
set_all_modules_text_rw() and use stop_machine() at the same time.

Fixes: 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module text permissions race")
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 arch/x86/kernel/ftrace.c |  3 +++
 kernel/trace/ftrace.c    | 10 +---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0927bb158ffc..33786044d5ac 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/memory.h>
 
 #include <trace/syscall.h>
 
@@ -35,6 +36,7 @@
 
 int ftrace_arch_code_modify_prepare(void)
 {
+	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
 	return 0;
@@ -44,6 +46,7 @@ int ftrace_arch_code_modify_post_process(void)
 {
 	set_all_modules_text_ro();
 	set_kernel_text_ro();
+	mutex_unlock(&text_mutex);
 	return 0;
 }
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 38277af44f5c..d3034a4a3fcc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -34,7 +34,6 @@
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
-#include <linux/memory.h>
 
 #include <trace/events/sched.h>
 
@@ -2611,12 +2610,10 @@ static void ftrace_run_update_code(int command)
 {
 	int ret;
 
-	mutex_lock(&text_mutex);
-
 	ret = ftrace_arch_code_modify_prepare();
 	FTRACE_WARN_ON(ret);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2628,9 +2625,6 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
-
-out_unlock:
-	mutex_unlock(&text_mutex);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
@@ -5784,7 +5778,6 @@ void ftrace_module_enable(struct module *mod)
 	struct ftrace_page *pg;
 
 	mutex_lock(&ftrace_lock);
-	mutex_lock(&text_mutex);
 
 	if (ftrace_disabled)
 		goto out_unlock;
@@ -5846,7 +5839,6 @@ void ftrace_module_enable(struct module *mod)
 		ftrace_arch_code_modify_post_process();
 
  out_unlock:
-	mutex_unlock(&text_mutex);
 	mutex_unlock(&ftrace_lock);
 
 	process_cached_mods(mod->name);
-- 
2.16.4

