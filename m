Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D9951A271
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351437AbiEDOrr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 10:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiEDOrq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 10:47:46 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612BEDF88
        for <live-patching@vger.kernel.org>; Wed,  4 May 2022 07:44:09 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-edeb6c3642so1386969fac.3
        for <live-patching@vger.kernel.org>; Wed, 04 May 2022 07:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hzXxKtcQps0ZAgRhahbmep1urQpR9Cgb4jllU0BGEjo=;
        b=AaRIzJr666XG5+EfWEqXud0jEDdbtOXM3arp9tH/ET8Mu61UpwavXLlLZgQxIODP2d
         4DshXJXHjPS28WuTdLfDzanffOSPGmzwsLqHAeWqGxfPYGzrxvrxuBcvBmiJmcvkQTSF
         R3+3lAqSD3p+J4kIUAOaWa6OJlMzCRsSFoqpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hzXxKtcQps0ZAgRhahbmep1urQpR9Cgb4jllU0BGEjo=;
        b=LR8dW5cC+CU0ZAy0QtPmkB0tvCG/11pzS4qboAcYML748sTHFWhkLuiNf8IySU+myu
         sqf+37dj3IYn9/zzxYwZovcqDP56zPJ+2IrKtQUs5eJDnS2Q6auMtzr9TSNlayYU+IaB
         EEvIY2fnZ3/krzN4DDmOddUD2dEqsR44pctClog97ubaTm5B7yFOIaxbN/+9304Se5sX
         cPV26kyOb/MUEGyQEoA1dVS697JqmIaLzZRj0WvahkitMfMVachWEv7L1zKttOZ4FLct
         wwqXfedAg4tRs9mJdruRpmb7My0YWSAk1PBMv2AMzF/9RSX6U70/x5KTMnxNXATnN+BW
         r1BQ==
X-Gm-Message-State: AOAM533d+gDcTPdUH+73Ok7aIAgr9UzPBmBkHUS578CsVPjWvdQTEiVN
        EdacH1T7TemdRow79U9XikZhhA==
X-Google-Smtp-Source: ABdhPJx3/UeuBZsluNWODA4kiKaqDvbK5qLaNKbUKByLbstg23zONbpgcCwRsLd3dXF4WjHRvUdLqw==
X-Received: by 2002:a05:6870:eaa5:b0:da:b3f:2b45 with SMTP id s37-20020a056870eaa500b000da0b3f2b45mr3979241oap.228.1651675448541;
        Wed, 04 May 2022 07:44:08 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:373b:a889:93d6:e756])
        by smtp.gmail.com with ESMTPSA id h3-20020a056870d24300b000e686d1386fsm8064357oac.9.2022.05.04.07.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 07:44:08 -0700 (PDT)
Date:   Wed, 4 May 2022 09:44:07 -0500
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
Message-ID: <YnKRN1zXKuh/gIMl@do-x1extreme>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
 <20220504130753.GB8069@pathway.suse.cz>
 <YnKEnqfxSyVmSGYx@do-x1extreme>
 <20220504142809.GC8069@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504142809.GC8069@pathway.suse.cz>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 04, 2022 at 04:28:09PM +0200, Petr Mladek wrote:
> On Wed 2022-05-04 08:50:22, Seth Forshee wrote:
> > On Wed, May 04, 2022 at 03:07:53PM +0200, Petr Mladek wrote:
> > > On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> > > > A task can be livepatched only when it is sleeping or it exits to
> > > > userspace. This may happen infrequently for a heavily loaded vCPU task,
> > > > leading to livepatch transition failures.
> > > 
> > > The problem was solved by sending a fake signal, see the commit
> > > 0b3d52790e1cfd6b80b826 ("livepatch: Remove signal sysfs attribute").
> > > It was achieved by calling signal_wake_up(). It set TIF_SIGPENDING
> > > and woke the task. It interrupted the syscall and the task was
> > > transitioned when leaving to the userspace.
> > > 
> > > signal_wake_up() was later replaced by set_notify_signal(),
> > > see the commit 8df1947c71ee53c7e21 ("livepatch: Replace
> > > the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure").
> > > The difference is that set_notify_signal() uses TIF_NOTIFY_SIGNAL
> > > instead of TIF_SIGPENDING.
> > > 
> > > The effect is the same when running on a real hardware. The syscall
> > > gets interrupted and exit_to_user_mode_loop() is called where
> > > the livepatch state is updated (task migrated).
> > > 
> > > But it works a different way in kvm where the task works are
> > > called in the guest mode and the task does not return into
> > > the user space in the host mode.
> > 
> > > > --- a/kernel/entry/kvm.c
> > > > +++ b/kernel/entry/kvm.c
> > > > @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> > > >  				task_work_run();
> > > >  		}
> > > >  
> > > > -		if (ti_work & _TIF_SIGPENDING) {
> > > > +		/*
> > > > +		 * When a livepatch is pending, force an exit to userspace
> > > > +		 * as though a signal is pending to allow the task to be
> > > > +		 * patched.
> > > > +		 */
> > > > +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> > > >  			kvm_handle_signal_exit(vcpu);
> 
> Another problem. Is it safe to call kvm_handle_signal_exit(vcpu)
> for kthreads?
> 
> kthreads have _TIF_PATCH_PENDING when they need the livepatch transition.
> But kthreads never leave kernel so we do not send the fake signal
> signals to them.

xfer_to_guest_mode_handle_work() should only be getting called on user
threads running ioctl(KVM_RUN).

> 
> > > >  			return -EINTR;
> > > >  		}
> > > 
> > > Does xfer_to_guest_mode_work() interrupts the syscall running
> > > on the guest?
> > 
> > xfer_to_guest_mode_work() is called as part of a loop to execute kvm
> > guests (for example, on x86 see vcpu_run() in arch/x86/kvm/x86.c). When
> > guest execution is interrupted (in the livepatch case it is interrupted
> > when set_notify_signal() is called for the vCPU task)
> > xfer_to_guest_mode_work() is called if there is pending work, and if it
> > returns non-zero the loop does not immediately re-enter guest execution
> > but instead returns to userspace.
> 
> Thanks for the detailed explanation.
> 
> 
> > > If "yes" then we do not need to call kvm_handle_signal_exit(vcpu).
> > > It will be enough to call:
> > > 
> > > 		if (ti_work & _TIF_PATCH_PENDING)
> > > 			klp_update_patch_state(current);
> > 
> > What if the task's call stack contains a function being patched?
> 
> We do not need to check the stack when the syscall gets restarted.
> The task might be transitioned only when the syscall gets restarted.

I see. Thanks!

> > > If "no" then I do not understand why TIF_NOTIFY_SIGNAL interrupts
> > > the syscall on the real hardware and not in kvm.
> > 
> > It does interrupt, but xfer_to_guest_mode_handle_work() concludes it's
> > not necessary to return to userspace and resumes guest execution.
> 
> In this case, we should revert the commit 8df1947c71ee53c7e21
> ("livepatch: Replace the fake signal sending with TIF_NOTIFY_SIGNAL
> infrastructure"). The flag TIF_NOTIFY_SIGNAL clearly does not guarantee
> restarting the syscall or exiting to the user space with -EINTR.
> 
> It should solve this problem. And it looks like a cleaner solution
> to me.

It looks like that should fix the issue. I'll test to confirm.

Thanks,
Seth
