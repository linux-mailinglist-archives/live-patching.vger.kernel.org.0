Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803AF255DB
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEUQmj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 12:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEUQmi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 12:42:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1BF6F3082B43;
        Tue, 21 May 2019 16:42:33 +0000 (UTC)
Received: from treble (ovpn-125-173.rdu2.redhat.com [10.10.125.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 904EF59150;
        Tue, 21 May 2019 16:42:29 +0000 (UTC)
Date:   Tue, 21 May 2019 11:42:27 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190521164227.bxdff77kq7fgl5lp@treble>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
 <20190520211931.vokbqxkx5kb6k2bz@treble>
 <20190520173910.6da9ddaf@gandalf.local.home>
 <20190521141629.bmk5onsaab26qoaw@treble>
 <20190521104204.47d4e175@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190521104204.47d4e175@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 21 May 2019 16:42:38 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 21, 2019 at 10:42:04AM -0400, Steven Rostedt wrote:
> On Tue, 21 May 2019 09:16:29 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > > Hmm, this may blow up with lockdep, as I believe we already have a
> > > locking dependency of:
> > > 
> > >  text_mutex -> ftrace_lock
> > > 
> > > And this will reverses it. (kprobes appears to take the locks in this
> > > order).
> > > 
> > > Perhaps have live kernel patching grab ftrace_lock?  
> > 
> > Where does kprobes call into ftrace with the text_mutex?  I couldn't
> > find it.
> 
> Hmm, maybe it doesn't. I was looking at the arm_kprobe_ftrace() but
> it doesn't call it with text_mutex().
> 
> Maybe it is fine, but we had better perform a lot of testing with
> lockdep on to make sure.

Hm.  I suppose using ftrace_lock might be less risky since that lock is
only used internally by ftrace (up until now).  But I think it would
also make less sense because the text_mutex is supposed to protect code
patching.  And presumably ftrace_lock is supposed to be ftrace-specific.

Here's the latest patch, still using text_mutex.  I added some lockdep
assertions to ensure the permissions toggling functions are always
called with text_mutex.  It's running through 0-day right now.  I can
try to run it through various tests with CONFIG_LOCKDEP.


From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] livepatch: Fix ftrace module text permissions race

It's possible for livepatch and ftrace to be toggling a module's text
permissions at the same time, resulting in the following panic:

  BUG: unable to handle page fault for address: ffffffffc005b1d9
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  PGD 3ea0c067 P4D 3ea0c067 PUD 3ea0e067 PMD 3cc13067 PTE 3b8a1061
  Oops: 0003 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 453 Comm: insmod Tainted: G           O  K   5.2.0-rc1-a188339ca5 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
  RIP: 0010:apply_relocate_add+0xbe/0x14c
  Code: fa 0b 74 21 48 83 fa 18 74 38 48 83 fa 0a 75 40 eb 08 48 83 38 00 74 33 eb 53 83 38 00 75 4e 89 08 89 c8 eb 0a 83 38 00 75 43 <89> 08 48 63 c1 48 39 c8 74 2e eb 48 83 38 00 75 32 48 29 c1 89 08
  RSP: 0018:ffffb223c00dbb10 EFLAGS: 00010246
  RAX: ffffffffc005b1d9 RBX: 0000000000000000 RCX: ffffffff8b200060
  RDX: 000000000000000b RSI: 0000004b0000000b RDI: ffff96bdfcd33000
  RBP: ffffb223c00dbb38 R08: ffffffffc005d040 R09: ffffffffc005c1f0
  R10: ffff96bdfcd33c40 R11: ffff96bdfcd33b80 R12: 0000000000000018
  R13: ffffffffc005c1f0 R14: ffffffffc005e708 R15: ffffffff8b2fbc74
  FS:  00007f5f447beba8(0000) GS:ffff96bdff900000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffffffc005b1d9 CR3: 000000003cedc002 CR4: 0000000000360ea0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   klp_init_object_loaded+0x10f/0x219
   ? preempt_latency_start+0x21/0x57
   klp_enable_patch+0x662/0x809
   ? virt_to_head_page+0x3a/0x3c
   ? kfree+0x8c/0x126
   patch_init+0x2ed/0x1000 [livepatch_test02]
   ? 0xffffffffc0060000
   do_one_initcall+0x9f/0x1c5
   ? kmem_cache_alloc_trace+0xc4/0xd4
   ? do_init_module+0x27/0x210
   do_init_module+0x5f/0x210
   load_module+0x1c41/0x2290
   ? fsnotify_path+0x3b/0x42
   ? strstarts+0x2b/0x2b
   ? kernel_read+0x58/0x65
   __do_sys_finit_module+0x9f/0xc3
   ? __do_sys_finit_module+0x9f/0xc3
   __x64_sys_finit_module+0x1a/0x1c
   do_syscall_64+0x52/0x61
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The above panic occurs when loading two modules at the same time with
ftrace enabled, where at least one of the modules is a livepatch module:

CPU0					CPU1
klp_enable_patch()
  klp_init_object_loaded()
    module_disable_ro()
    					ftrace_module_enable()
					  ftrace_arch_code_modify_post_process()
				    	    set_all_modules_text_ro()
      klp_write_object_relocations()
        apply_relocate_add()
	  *patches read-only code* - BOOM

A similar race exists when toggling ftrace while loading a livepatch
module.

Fix it by ensuring that the livepatch and ftrace code patching
operations -- and their respective permissions changes -- are protected
by the text_mutex.

Reported-by: Johannes Erdfelt <johannes@erdfelt.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/livepatch/core.c |  6 ++++++
 kernel/module.c         |  9 +++++++++
 kernel/trace/ftrace.c   | 10 +++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 91cd519756d3..2d17e6e364b5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -30,6 +30,7 @@
 #include <linux/elf.h>
 #include <linux/moduleloader.h>
 #include <linux/completion.h>
+#include <linux/memory.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -730,16 +731,21 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	struct klp_func *func;
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	module_disable_ro(patch->mod);
 	ret = klp_write_object_relocations(patch->mod, obj);
 	if (ret) {
 		module_enable_ro(patch->mod, true);
+		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
 	arch_klp_init_object_loaded(patch, obj);
 	module_enable_ro(patch->mod, true);
 
+	mutex_unlock(&text_mutex);
+
 	klp_for_each_func(obj, func) {
 		ret = klp_find_object_symbol(obj->name, func->old_name,
 					     func->old_sympos,
diff --git a/kernel/module.c b/kernel/module.c
index 6e6712b3aaf5..4d9f3281c0c5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -64,6 +64,7 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/memory.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -1943,6 +1944,8 @@ static void frob_writable_data(const struct module_layout *layout,
 /* livepatching wants to disable read-only so it can frob module. */
 void module_disable_ro(const struct module *mod)
 {
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -1955,6 +1958,8 @@ void module_disable_ro(const struct module *mod)
 
 void module_enable_ro(const struct module *mod, bool after_init)
 {
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -1988,6 +1993,8 @@ void set_all_modules_text_rw(void)
 {
 	struct module *mod;
 
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -2007,6 +2014,8 @@ void set_all_modules_text_ro(void)
 {
 	struct module *mod;
 
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a12aff849c04..8259d4ba8b00 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -34,6 +34,7 @@
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
+#include <linux/memory.h>
 
 #include <trace/events/sched.h>
 
@@ -2610,10 +2611,12 @@ static void ftrace_run_update_code(int command)
 {
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	ret = ftrace_arch_code_modify_prepare();
 	FTRACE_WARN_ON(ret);
 	if (ret)
-		return;
+		goto out_unlock;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2625,6 +2628,9 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
+
+out_unlock:
+	mutex_unlock(&text_mutex);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
@@ -5776,6 +5782,7 @@ void ftrace_module_enable(struct module *mod)
 	struct ftrace_page *pg;
 
 	mutex_lock(&ftrace_lock);
+	mutex_lock(&text_mutex);
 
 	if (ftrace_disabled)
 		goto out_unlock;
@@ -5837,6 +5844,7 @@ void ftrace_module_enable(struct module *mod)
 		ftrace_arch_code_modify_post_process();
 
  out_unlock:
+	mutex_unlock(&text_mutex);
 	mutex_unlock(&ftrace_lock);
 
 	process_cached_mods(mod->name);
-- 
2.20.1

