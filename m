Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1972651A22B
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 16:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbiEDObs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 10:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiEDObs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 10:31:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04E32657C;
        Wed,  4 May 2022 07:28:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6C8D61F749;
        Wed,  4 May 2022 14:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651674489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3g1j3ZthgaSbI7zD1E9qRZ1n5VhVzKEfstIXFFqb5qc=;
        b=Y767kQR13YyJNpe10xDJZtwLo4yEzDC3QsGJmqg4EyErLUU+m+bqr6u+j9ciG5LyhINlm/
        nZ5VHAoLbHUliEXCUG9oPCPvEyLlvV6SY3siICcbwsamupo1nhKum2E7HZequxLYxYoTfw
        dfZR7zXbUhK/N6sc+1Yfl936fRQZhRw=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 463922C145;
        Wed,  4 May 2022 14:28:09 +0000 (UTC)
Date:   Wed, 4 May 2022 16:28:09 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <20220504142809.GC8069@pathway.suse.cz>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
 <20220504130753.GB8069@pathway.suse.cz>
 <YnKEnqfxSyVmSGYx@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnKEnqfxSyVmSGYx@do-x1extreme>
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

On Wed 2022-05-04 08:50:22, Seth Forshee wrote:
> On Wed, May 04, 2022 at 03:07:53PM +0200, Petr Mladek wrote:
> > On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> > > A task can be livepatched only when it is sleeping or it exits to
> > > userspace. This may happen infrequently for a heavily loaded vCPU task,
> > > leading to livepatch transition failures.
> > 
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
> 
> > > --- a/kernel/entry/kvm.c
> > > +++ b/kernel/entry/kvm.c
> > > @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> > >  				task_work_run();
> > >  		}
> > >  
> > > -		if (ti_work & _TIF_SIGPENDING) {
> > > +		/*
> > > +		 * When a livepatch is pending, force an exit to userspace
> > > +		 * as though a signal is pending to allow the task to be
> > > +		 * patched.
> > > +		 */
> > > +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> > >  			kvm_handle_signal_exit(vcpu);

Another problem. Is it safe to call kvm_handle_signal_exit(vcpu)
for kthreads?

kthreads have _TIF_PATCH_PENDING when they need the livepatch transition.
But kthreads never leave kernel so we do not send the fake signal
signals to them.


> > >  			return -EINTR;
> > >  		}
> > 
> > Does xfer_to_guest_mode_work() interrupts the syscall running
> > on the guest?
> 
> xfer_to_guest_mode_work() is called as part of a loop to execute kvm
> guests (for example, on x86 see vcpu_run() in arch/x86/kvm/x86.c). When
> guest execution is interrupted (in the livepatch case it is interrupted
> when set_notify_signal() is called for the vCPU task)
> xfer_to_guest_mode_work() is called if there is pending work, and if it
> returns non-zero the loop does not immediately re-enter guest execution
> but instead returns to userspace.

Thanks for the detailed explanation.


> > If "yes" then we do not need to call kvm_handle_signal_exit(vcpu).
> > It will be enough to call:
> > 
> > 		if (ti_work & _TIF_PATCH_PENDING)
> > 			klp_update_patch_state(current);
> 
> What if the task's call stack contains a function being patched?

We do not need to check the stack when the syscall gets restarted.
The task might be transitioned only when the syscall gets restarted.


> > If "no" then I do not understand why TIF_NOTIFY_SIGNAL interrupts
> > the syscall on the real hardware and not in kvm.
> 
> It does interrupt, but xfer_to_guest_mode_handle_work() concludes it's
> not necessary to return to userspace and resumes guest execution.

In this case, we should revert the commit 8df1947c71ee53c7e21
("livepatch: Replace the fake signal sending with TIF_NOTIFY_SIGNAL
infrastructure"). The flag TIF_NOTIFY_SIGNAL clearly does not guarantee
restarting the syscall or exiting to the user space with -EINTR.

It should solve this problem. And it looks like a cleaner solution
to me.

Best Regards,
Petr
