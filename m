Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B24451A2CB
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351481AbiEDPBL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 11:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiEDPBK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 11:01:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585771A816;
        Wed,  4 May 2022 07:57:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 13BC91F745;
        Wed,  4 May 2022 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651676253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qyasICj/5JSCOXA5cYimIBnYtjDZxXjrA99Ky5I1g2E=;
        b=r4k5ERPAeu7SFF3HNQ31NTb2paZ2Ea6oMcWqgL/xYLEoeC+sEQ4K64/T2QaipXscit25Fc
        XnTLKhq3umhrtDFP5ZOZp7VU7/hNtppJEbMvhtXNfeTdj0EijNEoHHIWN+ccIJ0KrTM638
        biVIblYdc1vQeTBbSrkqQZj6s+yfiWg=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E8CED2C141;
        Wed,  4 May 2022 14:57:32 +0000 (UTC)
Date:   Wed, 4 May 2022 16:57:32 +0200
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
Message-ID: <20220504145732.GD8069@pathway.suse.cz>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
 <20220504130753.GB8069@pathway.suse.cz>
 <YnKEnqfxSyVmSGYx@do-x1extreme>
 <20220504142809.GC8069@pathway.suse.cz>
 <YnKRN1zXKuh/gIMl@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnKRN1zXKuh/gIMl@do-x1extreme>
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

On Wed 2022-05-04 09:44:07, Seth Forshee wrote:
> On Wed, May 04, 2022 at 04:28:09PM +0200, Petr Mladek wrote:
> > On Wed 2022-05-04 08:50:22, Seth Forshee wrote:
> > > On Wed, May 04, 2022 at 03:07:53PM +0200, Petr Mladek wrote:
> > > > On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
> > > > > A task can be livepatched only when it is sleeping or it exits to
> > > > > userspace. This may happen infrequently for a heavily loaded vCPU task,
> > > > > leading to livepatch transition failures.
> > > > 
> > > > The problem was solved by sending a fake signal, see the commit
> > > > 0b3d52790e1cfd6b80b826 ("livepatch: Remove signal sysfs attribute").
> > > > It was achieved by calling signal_wake_up(). It set TIF_SIGPENDING
> > > > and woke the task. It interrupted the syscall and the task was
> > > > transitioned when leaving to the userspace.
> > > > 
> > > > signal_wake_up() was later replaced by set_notify_signal(),
> > > > see the commit 8df1947c71ee53c7e21 ("livepatch: Replace
> > > > the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure").
> > > > The difference is that set_notify_signal() uses TIF_NOTIFY_SIGNAL
> > > > instead of TIF_SIGPENDING.
> > > > 
> > > > The effect is the same when running on a real hardware. The syscall
> > > > gets interrupted and exit_to_user_mode_loop() is called where
> > > > the livepatch state is updated (task migrated).
> > > > 
> > > > But it works a different way in kvm where the task works are
> > > > called in the guest mode and the task does not return into
> > > > the user space in the host mode.
> > > 
> > > > > --- a/kernel/entry/kvm.c
> > > > > +++ b/kernel/entry/kvm.c
> > > > > @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> > > > >  				task_work_run();
> > > > >  		}
> > > > >  
> > > > > -		if (ti_work & _TIF_SIGPENDING) {
> > > > > +		/*
> > > > > +		 * When a livepatch is pending, force an exit to userspace
> > > > > +		 * as though a signal is pending to allow the task to be
> > > > > +		 * patched.
> > > > > +		 */
> > > > > +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> > > > >  			kvm_handle_signal_exit(vcpu);
> > 
> > Another problem. Is it safe to call kvm_handle_signal_exit(vcpu)
> > for kthreads?
> > 
> > kthreads have _TIF_PATCH_PENDING when they need the livepatch transition.
> > But kthreads never leave kernel so we do not send the fake signal
> > signals to them.
> 
> xfer_to_guest_mode_handle_work() should only be getting called on user
> threads running ioctl(KVM_RUN).

Great!

> > In this case, we should revert the commit 8df1947c71ee53c7e21
> > ("livepatch: Replace the fake signal sending with TIF_NOTIFY_SIGNAL
> > infrastructure"). The flag TIF_NOTIFY_SIGNAL clearly does not guarantee
> > restarting the syscall or exiting to the user space with -EINTR.
> > 
> > It should solve this problem. And it looks like a cleaner solution
> > to me.
> 
> It looks like that should fix the issue. I'll test to confirm.

Even better solution would be what Eric suggested, see
https://lore.kernel.org/r/87r159fkmp.fsf@email.froward.int.ebiederm.org

But we need to make sure that the syscall really gets restarted
when the livepatch state is updated.

Best Regards,
Petr
