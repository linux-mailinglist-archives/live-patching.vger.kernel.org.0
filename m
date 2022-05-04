Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C4351A155
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 15:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbiEDNyM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 09:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350902AbiEDNyB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 09:54:01 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEB101EC
        for <live-patching@vger.kernel.org>; Wed,  4 May 2022 06:50:24 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k25-20020a056830169900b00605f215e55dso923828otr.13
        for <live-patching@vger.kernel.org>; Wed, 04 May 2022 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XTovCgkI7WQYcs4fLS6xIfFtD2h0peXWgmZW9ZWgM9c=;
        b=flt+V7uaIJ+YxK5IOF4TGv7uUZlvJNKb8RHlDGPj2YXYMGKQE+Mlfon7uJK7cbPsMP
         YEWEa9uogbpfQgI5ZYT5HhLmRnlhv2bIFi3hppkc080Wt1W6A6Otk7CKT9/6KAdivNzT
         BJBf8Otrn7TCDTqcQuZE2VK0k0Q38sASs+ieM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XTovCgkI7WQYcs4fLS6xIfFtD2h0peXWgmZW9ZWgM9c=;
        b=eF3vhea2gkhlL5fdH9Xih3A7qLOJ1uHZnWVAk+44GaqZfcIbFOMl2re91gTvOvtFMl
         h7kFtl3hNIgDMas3v9WltFcVw//BTroYaU5z+DjEVkq2l0ZAO+POnVLaOcSOz6VHPSlD
         9E4WJ7e3B5XZR0uQmzZbRM3sjZ1/HGrXhyXUIaiLovOpSadYj/qwWxl5QasjOKLpPN+o
         F7WS0UB1UtJsS+5wUrpz6wY/ssMYQLgupc2kAoAMyDHHsNbBBkHwNF4aKdRTaiFLrzWY
         pwxIXj+hewVesUVZKNhHFcwYfSMIqhzynAbOxFs9iRTpMV6ogKRF2qbwakJteEcA8Msl
         m53w==
X-Gm-Message-State: AOAM531K7rqXOYiRtGGdETaXsbxkZy7OjEMrZ3bJ0CPff6B0bwcobpjo
        5FtGUM7Ckjo5085G2f8ovYeDqw==
X-Google-Smtp-Source: ABdhPJyT5OX5yA19yATjCMLSUzSorq5bTuRHKqrZICyhSWRgYn3BomUvxWCq1zrZojng3tnvWVym2w==
X-Received: by 2002:a05:6830:1098:b0:605:4550:d51c with SMTP id y24-20020a056830109800b006054550d51cmr7120007oto.135.1651672223502;
        Wed, 04 May 2022 06:50:23 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:373b:a889:93d6:e756])
        by smtp.gmail.com with ESMTPSA id p4-20020a0568301d4400b0060603221248sm5184523oth.24.2022.05.04.06.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 06:50:23 -0700 (PDT)
Date:   Wed, 4 May 2022 08:50:22 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Petr Mladek <pmladek@suse.com>
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
Message-ID: <YnKEnqfxSyVmSGYx@do-x1extreme>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
 <20220504130753.GB8069@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504130753.GB8069@pathway.suse.cz>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 04, 2022 at 03:07:53PM +0200, Petr Mladek wrote:
> On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> > A task can be livepatched only when it is sleeping or it exits to
> > userspace. This may happen infrequently for a heavily loaded vCPU task,
> > leading to livepatch transition failures.
> 
> This is misleading.
> 
> First, the problem is not a loaded CPU. The problem is that the
> task might spend very long time in the kernel when handling
> some syscall.

It's a fully loaded vCPU, which yes to the host looks like spending a
very long time in the ioctl(KVM_RUN) syscall. I can reword to clarify.

> Second, there is no timeout for the transition in the kernel code.
> It might take very long time but it will not fail.

I suppose the timeout is in kpatch then. I didn't check what implemented
the timeout. I'll remove the statement about timing out.

> > Fake signals will be sent to tasks which fail patching via stack
> > checking. This will cause running vCPU tasks to exit guest mode, but
> > since no signal is pending they return to guest execution without
> > exiting to userspace. Fix this by treating a pending livepatch migration
> > like a pending signal, exiting to userspace with EINTR. This allows the
> > task to be patched, and userspace should re-excecute KVM_RUN to resume
> > guest execution.
> 
> It seems that the patch works as expected but it is far from clear.
> And the above description helps only partially. Let me try to
> explain it for dummies like me ;-)
> 
> <explanation>
> The problem was solved by sending a fake signal, see the commit
> 0b3d52790e1cfd6b80b826 ("livepatch: Remove signal sysfs attribute").
> It was achieved by calling signal_wake_up(). It set TIF_SIGPENDING
> and woke the task. It interrupted the syscall and the task was
> transitioned when leaving to the userspace.
> 
> signal_wake_up() was later replaced by set_notify_signal(),
> see the commit 8df1947c71ee53c7e21 ("livepatch: Replace
> the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure").
> The difference is that set_notify_signal() uses TIF_NOTIFY_SIGNAL
> instead of TIF_SIGPENDING.
> 
> The effect is the same when running on a real hardware. The syscall
> gets interrupted and exit_to_user_mode_loop() is called where
> the livepatch state is updated (task migrated).
> 
> But it works a different way in kvm where the task works are
> called in the guest mode and the task does not return into
> the user space in the host mode.
> </explanation>

Thanks, I can update the commit message to include more of this
background.

> 
> The solution provided by this patch is a bit weird, see below.
> 
> 
> > In my testing, systems where livepatching would timeout after 60 seconds
> > were able to load livepatches within a couple of seconds with this
> > change.
> > 
> > Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> > ---
> > Changes in v2:
> >  - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
> >  - Reworded commit message and comments to avoid confusion around the
> >    term "migrate"
> > 
> >  include/linux/entry-kvm.h | 4 ++--
> >  kernel/entry/kvm.c        | 7 ++++++-
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> > index 6813171afccb..bf79e4cbb5a2 100644
> > --- a/include/linux/entry-kvm.h
> > +++ b/include/linux/entry-kvm.h
> > @@ -17,8 +17,8 @@
> >  #endif
> >  
> >  #define XFER_TO_GUEST_MODE_WORK						\
> > -	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
> > -	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> > +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
> > +	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> >  
> >  struct kvm_vcpu;
> >  
> > diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> > index 9d09f489b60e..98439dfaa1a0 100644
> > --- a/kernel/entry/kvm.c
> > +++ b/kernel/entry/kvm.c
> > @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> >  				task_work_run();
> >  		}
> >  
> > -		if (ti_work & _TIF_SIGPENDING) {
> > +		/*
> > +		 * When a livepatch is pending, force an exit to userspace
> > +		 * as though a signal is pending to allow the task to be
> > +		 * patched.
> > +		 */
> > +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> >  			kvm_handle_signal_exit(vcpu);
> >  			return -EINTR;
> >  		}
> 
> This looks strange:
> 
>   + klp_send_signals() calls set_notify_signal(task) that sets
>     TIF_NOTIFY_SIGNAL
> 
>   + xfer_to_guest_mode_work() handles TIF_NOTIFY_SIGNAL by calling
>     task_work_run().
> 
>   + This patch calls kvm_handle_signal_exit(vcpu) when
>     _TIF_PATCH_PENDING is set. It probably causes the guest
>     to call exit_to_user_mode_loop() because TIF_PATCH_PENDING
>     bit is set. But neither TIF_NOTIFY_SIGNAL not TIF_NOTIFY_SIGNAL
>     is set so that it works different way than on the real hardware.
> 
> 
> Question:
> 
> Does xfer_to_guest_mode_work() interrupts the syscall running
> on the guest?

xfer_to_guest_mode_work() is called as part of a loop to execute kvm
guests (for example, on x86 see vcpu_run() in arch/x86/kvm/x86.c). When
guest execution is interrupted (in the livepatch case it is interrupted
when set_notify_signal() is called for the vCPU task)
xfer_to_guest_mode_work() is called if there is pending work, and if it
returns non-zero the loop does not immediately re-enter guest execution
but instead returns to userspace.

> If "yes" then we do not need to call kvm_handle_signal_exit(vcpu).
> It will be enough to call:
> 
> 		if (ti_work & _TIF_PATCH_PENDING)
> 			klp_update_patch_state(current);

What if the task's call stack contains a function being patched?

> 
> If "no" then I do not understand why TIF_NOTIFY_SIGNAL interrupts
> the syscall on the real hardware and not in kvm.

It does interrupt, but xfer_to_guest_mode_handle_work() concludes it's
not necessary to return to userspace and resumes guest execution.

Thanks,
Seth

> Anyway, we either should make sure that TIF_NOTIFY_SIGNAL has the same
> effect on the real hardware and in kvm. Or we need another interface
> for the fake signal used by livepatching.
> 
> Adding Jens Axboe and Eric into Cc.
> 
> Best Regards,
> Petr
