Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE7351A364
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 17:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiEDPQk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352006AbiEDPQb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 11:16:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3165342ECD;
        Wed,  4 May 2022 08:12:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DA7391F745;
        Wed,  4 May 2022 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651677172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8NXmMHFcukkcOXO01Wu1Svm9aGsv7CwF07krsoXa4/4=;
        b=LMhZcgVMzLvSSg5vzagkKYgNwEcCF8p/KZGfmFP9HTqEukoK1dkwTYjZYzpt7pA9n/v+5j
        fZfarlnU+PuUBJHmjdQykzcqlx7oEWDqyGxArWmtrkHHIIxWHJRbD2rnxwo9DoO4kVT2kn
        mvLuoRLcUP3Cgu8OfqqQeexQsEEqDTE=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A84032C142;
        Wed,  4 May 2022 15:12:52 +0000 (UTC)
Date:   Wed, 4 May 2022 17:12:52 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <20220504151252.GA13574@pathway.suse.cz>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
 <20220504130753.GB8069@pathway.suse.cz>
 <87r159fkmp.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r159fkmp.fsf@email.froward.int.ebiederm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-05-04 09:16:46, Eric W. Biederman wrote:
> Petr Mladek <pmladek@suse.com> writes:
> 
> > On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> >> A task can be livepatched only when it is sleeping or it exits to
> >> userspace. This may happen infrequently for a heavily loaded vCPU task,
> >> leading to livepatch transition failures.
> >
> > This is misleading.
> >
> > First, the problem is not a loaded CPU. The problem is that the
> > task might spend very long time in the kernel when handling
> > some syscall.
> >
> > Second, there is no timeout for the transition in the kernel code.
> > It might take very long time but it will not fail.
> >
> >> Fake signals will be sent to tasks which fail patching via stack
> >> checking. This will cause running vCPU tasks to exit guest mode, but
> >> since no signal is pending they return to guest execution without
> >> exiting to userspace. Fix this by treating a pending livepatch migration
> >> like a pending signal, exiting to userspace with EINTR. This allows the
> >> task to be patched, and userspace should re-excecute KVM_RUN to resume
> >> guest execution.
> >
> > It seems that the patch works as expected but it is far from clear.
> > And the above description helps only partially. Let me try to
> > explain it for dummies like me ;-)
> >
> > <explanation>
> > The problem was solved by sending a fake signal, see the commit
> > 0b3d52790e1cfd6b80b826 ("livepatch: Remove signal sysfs attribute").
> > It was achieved by calling signal_wake_up(). It set TIF_SIGPENDING
> > and woke the task. It interrupted the syscall and the task was
> > transitioned when leaving to the userspace.
> >
> > signal_wake_up() was later replaced by set_notify_signal(),
> > see the commit 8df1947c71ee53c7e21 ("livepatch: Replace
> > the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure").
> > The difference is that set_notify_signal() uses TIF_NOTIFY_SIGNAL
> > instead of TIF_SIGPENDING.
> >
> > The effect is the same when running on a real hardware. The syscall
> > gets interrupted and exit_to_user_mode_loop() is called where
> > the livepatch state is updated (task migrated).
> >
> > But it works a different way in kvm where the task works are
> > called in the guest mode and the task does not return into
> > the user space in the host mode.
> > </explanation>
> >
> > The solution provided by this patch is a bit weird, see below.
> >
> >
> >> In my testing, systems where livepatching would timeout after 60 seconds
> >> were able to load livepatches within a couple of seconds with this
> >> change.
> >> 
> >> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> >> ---
> >> Changes in v2:
> >>  - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
> >>  - Reworded commit message and comments to avoid confusion around the
> >>    term "migrate"
> >> 
> >>  include/linux/entry-kvm.h | 4 ++--
> >>  kernel/entry/kvm.c        | 7 ++++++-
> >>  2 files changed, 8 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> >> index 6813171afccb..bf79e4cbb5a2 100644
> >> --- a/include/linux/entry-kvm.h
> >> +++ b/include/linux/entry-kvm.h
> >> @@ -17,8 +17,8 @@
> >>  #endif
> >>  
> >>  #define XFER_TO_GUEST_MODE_WORK						\
> >> -	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
> >> -	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> >> +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
> >> +	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> >>  
> >>  struct kvm_vcpu;
> >>  
> >> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> >> index 9d09f489b60e..98439dfaa1a0 100644
> >> --- a/kernel/entry/kvm.c
> >> +++ b/kernel/entry/kvm.c
> >> @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> >>  				task_work_run();
> >>  		}
> >>  
> >> -		if (ti_work & _TIF_SIGPENDING) {
> >> +		/*
> >> +		 * When a livepatch is pending, force an exit to userspace
> >> +		 * as though a signal is pending to allow the task to be
> >> +		 * patched.
> >> +		 */
> >> +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> >>  			kvm_handle_signal_exit(vcpu);
> >>  			return -EINTR;
> >>  		}
> >
> > Anyway, we either should make sure that TIF_NOTIFY_SIGNAL has the same
> > effect on the real hardware and in kvm. Or we need another interface
> > for the fake signal used by livepatching.
> 
> The point of TIF_NOTIFY_SIGNAL is to break out of interruptible kernel
> loops.  Once out of the interruptible kernel loop the expectation is the
> returns to user space and on it's way runs the exit_to_user_mode_loop or
> is architecture specific equivalent.

That would make sense. Thanks for explanation.

> Reading through the history of kernel/entry/kvm.c I believe
> I made ``conservative'' changes that has not helped this situation.
> 
> Long story short at one point it was thought that _TIF_SIGPENDING
> and _TIF_NOTIFY_SIGNAL could be separated and they could not.
> Unfortunately the work to separate their handling has not been
> completely undone.
> 
> In this case it appears that the only reason xfer_to_guest_mode_work
> touches task_work_run is because of the separation work done by Jens
> Axboe.  I don't see any kvm specific reason for _TIF_NOTIFY_SIGNAL
> and _TIF_SIGPENDING to be treated differently.  Meanwhile my cleanups
> elsewhere have made the unnecessary _TIF_NOTIFY_SIGNAL special case
> bigger in xfer_to_guest_mode_work.
> 
> I suspect the first step in fixing things really should be just handling
> _TIF_SIGPENDING and _TIF_NOTIFY_SIGNAL the same.
> 
> static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> {
> 	do {
> 		int ret;
> 
> 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
> 			kvm_handle_signal_exit(vcpu);
> 			return -EINTR;
> 		}

This has the advantage that we will exit only when _TIF_NOTIFY_SIGNAL
is explicitly set by the livepatch code. It happens when
_TIF_PATCH_PENDING is not handled for few seconds.

_TIF_PATCH_PENDING is cleared when the task is transitioned.
It might happen when it is not running and there is no livepatched
function on the stack.


> 		if (ti_work & _TIF_NEED_RESCHED)
> 			schedule();
> 
> 		if (ti_work & _TIF_NOTIFY_RESUME)
> 			resume_user_mode_work(NULL);
> 
> 		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
> 		if (ret)
> 			return ret;
> 
> 		ti_work = read_thread_flags();
> 	} while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
> 	return 0;
> }
> 
> That said I do expect adding support for the live patching into
> xfer_to_guest_mode_work, like there is in exit_to_user_mode_loop, is
> probably a good idea.  That should prevent the live patching code from
> needing to set TIF_NOTIFY_SIGNAL.
> 
> Something like:
> 
> Thomas Gleixner's patch to make _TIF_PATCH_PENDING always available.
> 
> #define XFER_TO_GUEST_MODE_WORK						\
> 	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
> 	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> 
> 
> static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> {
> 	do {
> 		int ret;
> 
> 		if (ti_work & _TIF_PATCH_PENDING)
> 			klp_update_patch_state(current);

We need to make sure that the syscall really gets restarted.
My understanding is that it will happen only when this function
returns a non-zero value.

We might need to do:

		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)) {
			kvm_handle_signal_exit(vcpu);
			return -EINTR;
		}

But it might be better to do not check _TIF_PATCH_PENDING here at all.
It will allow to apply the livepatch without restarting the syscall.
The syscall will get restarted only by the fake signal when the
transition is blocked for too long.

> 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
> 			kvm_handle_signal_exit(vcpu);
> 			return -EINTR;
> 		}
> 
> 		if (ti_work & _TIF_NEED_RESCHED)
> 			schedule();
> 
> 		if (ti_work & _TIF_NOTIFY_RESUME)
> 			resume_user_mode_work(NULL);
> 
> 		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
> 		if (ret)
> 			return ret;
> 
> 		ti_work = read_thread_flags();
> 	} while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
> 	return 0;
> }
> 
> If the kvm and the live patching folks could check my thinking that
> would be great.

Yeah, I am not sure about the kvm behavior either.

Best Regards,
Petr
