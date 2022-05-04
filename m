Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B228A51A077
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350363AbiEDNLw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 09:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350407AbiEDNLq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 09:11:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE10403D6;
        Wed,  4 May 2022 06:07:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3D4C81F38D;
        Wed,  4 May 2022 13:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651669674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHBzjUbutvfWVjzQ6Q8d5vmhuWoPHH5ZuOIWJMc8g9E=;
        b=VPQ1b+wAHZNaVD7IjQQM+Gsadlf1zX6y7DMNcdE38056VBFV5jZO0D52OfjhxhZBSmIiot
        Zc/EczGYQMkAua+Q5HVnLjPFJa8OL7XuVnRxrRHd5SwLwROFVEUCPfFNE+KpCTI40O9pcw
        dWCogcG6NNaar62vrPOougYo+eWQE/g=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 15FD82C142;
        Wed,  4 May 2022 13:07:54 +0000 (UTC)
Date:   Wed, 4 May 2022 15:07:53 +0200
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
Message-ID: <20220504130753.GB8069@pathway.suse.cz>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503174934.2641605-1-sforshee@digitalocean.com>
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

On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> A task can be livepatched only when it is sleeping or it exits to
> userspace. This may happen infrequently for a heavily loaded vCPU task,
> leading to livepatch transition failures.

This is misleading.

First, the problem is not a loaded CPU. The problem is that the
task might spend very long time in the kernel when handling
some syscall.

Second, there is no timeout for the transition in the kernel code.
It might take very long time but it will not fail.

> Fake signals will be sent to tasks which fail patching via stack
> checking. This will cause running vCPU tasks to exit guest mode, but
> since no signal is pending they return to guest execution without
> exiting to userspace. Fix this by treating a pending livepatch migration
> like a pending signal, exiting to userspace with EINTR. This allows the
> task to be patched, and userspace should re-excecute KVM_RUN to resume
> guest execution.

It seems that the patch works as expected but it is far from clear.
And the above description helps only partially. Let me try to
explain it for dummies like me ;-)

<explanation>
The problem was solved by sending a fake signal, see the commit
0b3d52790e1cfd6b80b826 ("livepatch: Remove signal sysfs attribute").
It was achieved by calling signal_wake_up(). It set TIF_SIGPENDING
and woke the task. It interrupted the syscall and the task was
transitioned when leaving to the userspace.

signal_wake_up() was later replaced by set_notify_signal(),
see the commit 8df1947c71ee53c7e21 ("livepatch: Replace
the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure").
The difference is that set_notify_signal() uses TIF_NOTIFY_SIGNAL
instead of TIF_SIGPENDING.

The effect is the same when running on a real hardware. The syscall
gets interrupted and exit_to_user_mode_loop() is called where
the livepatch state is updated (task migrated).

But it works a different way in kvm where the task works are
called in the guest mode and the task does not return into
the user space in the host mode.
</explanation>

The solution provided by this patch is a bit weird, see below.


> In my testing, systems where livepatching would timeout after 60 seconds
> were able to load livepatches within a couple of seconds with this
> change.
> 
> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> ---
> Changes in v2:
>  - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
>  - Reworded commit message and comments to avoid confusion around the
>    term "migrate"
> 
>  include/linux/entry-kvm.h | 4 ++--
>  kernel/entry/kvm.c        | 7 ++++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> index 6813171afccb..bf79e4cbb5a2 100644
> --- a/include/linux/entry-kvm.h
> +++ b/include/linux/entry-kvm.h
> @@ -17,8 +17,8 @@
>  #endif
>  
>  #define XFER_TO_GUEST_MODE_WORK						\
> -	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
> -	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
> +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
> +	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
>  
>  struct kvm_vcpu;
>  
> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> index 9d09f489b60e..98439dfaa1a0 100644
> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/kvm.c
> @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>  				task_work_run();
>  		}
>  
> -		if (ti_work & _TIF_SIGPENDING) {
> +		/*
> +		 * When a livepatch is pending, force an exit to userspace
> +		 * as though a signal is pending to allow the task to be
> +		 * patched.
> +		 */
> +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
>  			kvm_handle_signal_exit(vcpu);
>  			return -EINTR;
>  		}

This looks strange:

  + klp_send_signals() calls set_notify_signal(task) that sets
    TIF_NOTIFY_SIGNAL

  + xfer_to_guest_mode_work() handles TIF_NOTIFY_SIGNAL by calling
    task_work_run().

  + This patch calls kvm_handle_signal_exit(vcpu) when
    _TIF_PATCH_PENDING is set. It probably causes the guest
    to call exit_to_user_mode_loop() because TIF_PATCH_PENDING
    bit is set. But neither TIF_NOTIFY_SIGNAL not TIF_NOTIFY_SIGNAL
    is set so that it works different way than on the real hardware.


Question:

Does xfer_to_guest_mode_work() interrupts the syscall running
on the guest?

If "yes" then we do not need to call kvm_handle_signal_exit(vcpu).
It will be enough to call:

		if (ti_work & _TIF_PATCH_PENDING)
			klp_update_patch_state(current);

If "no" then I do not understand why TIF_NOTIFY_SIGNAL interrupts
the syscall on the real hardware and not in kvm.

Anyway, we either should make sure that TIF_NOTIFY_SIGNAL has the same
effect on the real hardware and in kvm. Or we need another interface
for the fake signal used by livepatching.

Adding Jens Axboe and Eric into Cc.

Best Regards,
Petr
