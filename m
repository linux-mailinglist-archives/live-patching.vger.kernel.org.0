Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28D56AC6
	for <lists+live-patching@lfdr.de>; Wed, 26 Jun 2019 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFZNhZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jun 2019 09:37:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:45086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727443AbfFZNhZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jun 2019 09:37:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F19D7AF7B;
        Wed, 26 Jun 2019 13:37:22 +0000 (UTC)
Date:   Wed, 26 Jun 2019 15:37:21 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] module: Fix livepatch/ftrace module text permissions
 race
Message-ID: <20190626133721.ea2iuqqu4to2jpbv@pathway.suse.cz>
References: <cover.1560474114.git.jpoimboe@redhat.com>
 <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com>
 <20190614170408.1b1162dc@gandalf.local.home>
 <alpine.LSU.2.21.1906260908170.22069@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1906260908170.22069@pobox.suse.cz>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-06-26 10:22:45, Miroslav Benes wrote:
> On Fri, 14 Jun 2019, Steven Rostedt wrote:
> 
> > On Thu, 13 Jun 2019 20:07:22 -0500
> > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > It's possible for livepatch and ftrace to be toggling a module's text
> > > permissions at the same time, resulting in the following panic:
> > > 
> > 
> > [..]
> > 
> > > The above panic occurs when loading two modules at the same time with
> > > ftrace enabled, where at least one of the modules is a livepatch module:
> > > 
> > > CPU0					CPU1
> > > klp_enable_patch()
> > >   klp_init_object_loaded()
> > >     module_disable_ro()
> > >     					ftrace_module_enable()
> > > 					  ftrace_arch_code_modify_post_process()
> > > 				    	    set_all_modules_text_ro()
> > >       klp_write_object_relocations()
> > >         apply_relocate_add()
> > > 	  *patches read-only code* - BOOM
> > > 
> > > A similar race exists when toggling ftrace while loading a livepatch
> > > module.
> > > 
> > > Fix it by ensuring that the livepatch and ftrace code patching
> > > operations -- and their respective permissions changes -- are protected
> > > by the text_mutex.
> > > 
> > > Reported-by: Johannes Erdfelt <johannes@erdfelt.com>
> > > Fixes: 444d13ff10fb ("modules: add ro_after_init support")
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Acked-by: Jessica Yu <jeyu@kernel.org>
> > > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > > Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> > 
> > This patch looks uncontroversial. I'm going to pull this one in and
> > start testing it. And if it works, I'll push to Linus.
> 
> Triggered this on s390x. Masami CCed and Linus as well, because the patch 
> is in master branch and we are after -rc6. Thomas CCed because of commit 
> 2d1e38f56622 ("kprobes: Cure hotplug lock ordering issues").
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.2.0-rc6 #1 Tainted: G           O  K  
> ------------------------------------------------------
> insmod/1393 is trying to acquire lock:
> 000000002fdee887 (cpu_hotplug_lock.rw_sem){++++}, at: stop_machine+0x2e/0x60
> 
> but task is already holding lock:
> 000000005b22fb82 (text_mutex){+.+.}, at: ftrace_run_update_code+0x2a/0xa0
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (text_mutex){+.+.}:
>        validate_chain.isra.21+0xb32/0xd70
>        __lock_acquire+0x4b8/0x928
>        lock_acquire+0x102/0x230
>        __mutex_lock+0x88/0x908
>        mutex_lock_nested+0x32/0x40
>        register_kprobe+0x254/0x658
>        init_kprobes+0x11a/0x168
>        do_one_initcall+0x70/0x318
>        kernel_init_freeable+0x456/0x508
>        kernel_init+0x22/0x150
>        ret_from_fork+0x30/0x34
>        kernel_thread_starter+0x0/0xc
> 
> -> #0 (cpu_hotplug_lock.rw_sem){++++}:
>        check_prev_add+0x90c/0xde0
>        validate_chain.isra.21+0xb32/0xd70
>        __lock_acquire+0x4b8/0x928
>        lock_acquire+0x102/0x230
>        cpus_read_lock+0x62/0xd0
>        stop_machine+0x2e/0x60
>        arch_ftrace_update_code+0x2e/0x40
>        ftrace_run_update_code+0x40/0xa0
>        ftrace_startup+0xb2/0x168
>        register_ftrace_function+0x64/0x88
>        klp_patch_object+0x1a2/0x290
>        klp_enable_patch+0x554/0x980
>        do_one_initcall+0x70/0x318
>        do_init_module+0x6e/0x250
>        load_module+0x1782/0x1990
>        __s390x_sys_finit_module+0xaa/0xf0
>        system_call+0xd8/0x2d0
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(text_mutex);
>                                lock(cpu_hotplug_lock.rw_sem);
>                                lock(text_mutex);
>   lock(cpu_hotplug_lock.rw_sem);

It is similar problem that has been solved by 2d1e38f56622b9bb5af8
("kprobes: Cure hotplug lock ordering issues"). This commit solved
it by always taking cpu_hotplug_lock.rw_sem before text_mutex inside.

If we follow the lock ordering then ftrace has to take text_mutex
only when stop_machine() is not called or from code called via
stop_machine() parameter.

This is not easy with the current design. For example, arm calls
set_all_modules_text_rw() already in ftrace_arch_code_modify_prepare(),
see arch/arm/kernel/ftrace.c. And it is called:

  + outside stop_machine() from ftrace_run_update_code()
  + without stop_machine() from ftrace_module_enable()

A conservative solution for 5.2 release would be to move text_mutex
locking from the generic kernel/trace/ftrace.c into
arch/x86/kernel/ftrace.c:

   ftrace_arch_code_modify_prepare()
   ftrace_arch_code_modify_post_process()

It should be enough to fix the original problem because
x86 is the only architecture that calls set_all_modules_text_rw()
in ftrace path and supports livepatching at the same time.

We would need to do some refactoring when livepatching is enabled
for arm or nds32.

The conservative solution:

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
