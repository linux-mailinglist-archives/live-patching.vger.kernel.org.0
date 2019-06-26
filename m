Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218735646C
	for <lists+live-patching@lfdr.de>; Wed, 26 Jun 2019 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfFZIWt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jun 2019 04:22:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbfFZIWt (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jun 2019 04:22:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0B52AD12;
        Wed, 26 Jun 2019 08:22:46 +0000 (UTC)
Date:   Wed, 26 Jun 2019 10:22:45 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@kernel.org>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] module: Fix livepatch/ftrace module text permissions
 race
In-Reply-To: <20190614170408.1b1162dc@gandalf.local.home>
Message-ID: <alpine.LSU.2.21.1906260908170.22069@pobox.suse.cz>
References: <cover.1560474114.git.jpoimboe@redhat.com> <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com> <20190614170408.1b1162dc@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 14 Jun 2019, Steven Rostedt wrote:

> On Thu, 13 Jun 2019 20:07:22 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > It's possible for livepatch and ftrace to be toggling a module's text
> > permissions at the same time, resulting in the following panic:
> > 
> 
> [..]
> 
> > The above panic occurs when loading two modules at the same time with
> > ftrace enabled, where at least one of the modules is a livepatch module:
> > 
> > CPU0					CPU1
> > klp_enable_patch()
> >   klp_init_object_loaded()
> >     module_disable_ro()
> >     					ftrace_module_enable()
> > 					  ftrace_arch_code_modify_post_process()
> > 				    	    set_all_modules_text_ro()
> >       klp_write_object_relocations()
> >         apply_relocate_add()
> > 	  *patches read-only code* - BOOM
> > 
> > A similar race exists when toggling ftrace while loading a livepatch
> > module.
> > 
> > Fix it by ensuring that the livepatch and ftrace code patching
> > operations -- and their respective permissions changes -- are protected
> > by the text_mutex.
> > 
> > Reported-by: Johannes Erdfelt <johannes@erdfelt.com>
> > Fixes: 444d13ff10fb ("modules: add ro_after_init support")
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Acked-by: Jessica Yu <jeyu@kernel.org>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> 
> This patch looks uncontroversial. I'm going to pull this one in and
> start testing it. And if it works, I'll push to Linus.

Triggered this on s390x. Masami CCed and Linus as well, because the patch 
is in master branch and we are after -rc6. Thomas CCed because of commit 
2d1e38f56622 ("kprobes: Cure hotplug lock ordering issues").

======================================================
WARNING: possible circular locking dependency detected
5.2.0-rc6 #1 Tainted: G           O  K  
------------------------------------------------------
insmod/1393 is trying to acquire lock:
000000002fdee887 (cpu_hotplug_lock.rw_sem){++++}, at: stop_machine+0x2e/0x60

but task is already holding lock:
000000005b22fb82 (text_mutex){+.+.}, at: ftrace_run_update_code+0x2a/0xa0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

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

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(text_mutex);
                               lock(cpu_hotplug_lock.rw_sem);
                               lock(text_mutex);
  lock(cpu_hotplug_lock.rw_sem);

 *** DEADLOCK ***

3 locks held by insmod/1393:
 #0: 00000000a9723159 (klp_mutex){+.+.}, at: klp_enable_patch+0x62/0x980
 #1: 00000000bd173ffc (ftrace_lock){+.+.}, at: register_ftrace_function+0x56/0x88
 #2: 000000005b22fb82 (text_mutex){+.+.}, at: ftrace_run_update_code+0x2a/0xa0

stack backtrace:
CPU: 0 PID: 1393 Comm: insmod Tainted: G           O  K   5.2.0-rc6 #1
Hardware name: IBM 2827 H43 400 (KVM/Linux)
Call Trace:
([<00000000682100b4>] show_stack+0xb4/0x130)
 [<0000000068adeb8c>] dump_stack+0x94/0xd8 
 [<00000000682b563c>] print_circular_bug+0x1f4/0x328 
 [<00000000682b7264>] check_prev_add+0x90c/0xde0 
 [<00000000682b826a>] validate_chain.isra.21+0xb32/0xd70 
 [<00000000682ba018>] __lock_acquire+0x4b8/0x928 
 [<00000000682ba952>] lock_acquire+0x102/0x230 
 [<0000000068243c12>] cpus_read_lock+0x62/0xd0 
 [<0000000068336bf6>] stop_machine+0x2e/0x60 
 [<0000000068355b3e>] arch_ftrace_update_code+0x2e/0x40 
 [<0000000068355b90>] ftrace_run_update_code+0x40/0xa0 
 [<000000006835971a>] ftrace_startup+0xb2/0x168 
 [<0000000068359834>] register_ftrace_function+0x64/0x88 
 [<00000000682e8a9a>] klp_patch_object+0x1a2/0x290 
 [<00000000682e7d64>] klp_enable_patch+0x554/0x980 
 [<00000000681fcaa0>] do_one_initcall+0x70/0x318 
 [<000000006831449e>] do_init_module+0x6e/0x250 
 [<0000000068312b52>] load_module+0x1782/0x1990 
 [<0000000068313002>] __s390x_sys_finit_module+0xaa/0xf0 
 [<0000000068b03f30>] system_call+0xd8/0x2d0 
INFO: lockdep is turned off.

If I am reading the code correctly, ftrace_run_update_code() takes 
text_mutex now and then calls stop_machine(), which grabs 
cpu_hotplug_lock for reading. do_optimize_kprobes() (see the comment 
there) expects cpu_hotplug_lock to be held and takes text_mutex. Whoops.

Maybe there is a simple fix, but reverting the commit in this stage seems 
warranted.

Miroslav
