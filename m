Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195E251ACDE
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 20:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377194AbiEDSfh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 14:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376981AbiEDSf2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 14:35:28 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A7653B71;
        Wed,  4 May 2022 11:16:12 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:60554)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmJXm-00DeTi-SS; Wed, 04 May 2022 12:16:10 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:36950 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmJXl-00F03n-L3; Wed, 04 May 2022 12:16:10 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kvm@vger.kernel.org
References: <20220504180840.2907296-1-sforshee@digitalocean.com>
Date:   Wed, 04 May 2022 13:16:02 -0500
In-Reply-To: <20220504180840.2907296-1-sforshee@digitalocean.com> (Seth
        Forshee's message of "Wed, 4 May 2022 13:08:40 -0500")
Message-ID: <878rrhcgf1.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nmJXl-00F03n-L3;;;mid=<878rrhcgf1.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19xSYDYzW0+xU2ATA3vhYA4gZqv0as7Rxc=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Seth Forshee <sforshee@digitalocean.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 627 ms - load_scoreonly_sql: 0.10 (0.0%),
        signal_user_changed: 13 (2.0%), b_tie_ro: 11 (1.7%), parse: 1.21
        (0.2%), extract_message_metadata: 22 (3.4%), get_uri_detail_list: 1.97
        (0.3%), tests_pri_-1000: 34 (5.4%), tests_pri_-950: 1.52 (0.2%),
        tests_pri_-900: 1.27 (0.2%), tests_pri_-90: 223 (35.6%), check_bayes:
        214 (34.1%), b_tokenize: 10 (1.7%), b_tok_get_all: 9 (1.4%),
        b_comp_prob: 2.6 (0.4%), b_tok_touch_all: 186 (29.7%), b_finish: 1.47
        (0.2%), tests_pri_0: 314 (50.0%), check_dkim_signature: 0.52 (0.1%),
        check_dkim_adsp: 2.9 (0.5%), poll_dns_idle: 0.98 (0.2%), tests_pri_10:
        3.0 (0.5%), tests_pri_500: 11 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Seth Forshee <sforshee@digitalocean.com> writes:

> A livepatch transition may stall indefinitely when a kvm vCPU is heavily
> loaded. To the host, the vCPU task is a user thread which is spending a
> very long time in the ioctl(KVM_RUN) syscall. During livepatch
> transition, set_notify_signal() will be called on such tasks to
> interrupt the syscall so that the task can be transitioned. This
> interrupts guest execution, but when xfer_to_guest_mode_work() sees that
> TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
> exit to user mode is unnecessary, and guest execution is resumed without
> transitioning the task for the livepatch.
>
> This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
> is expected to break tasks out of interruptible kernel loops and cause
> them to return to userspace. Change xfer_to_guest_mode_work() to handle
> TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
> loop that an exit to userpsace is needed. Any pending task_work will be
> run when get_signal() is called from exit_to_user_mode_loop(), so there
> is no longer any need to run task work from xfer_to_guest_mode_work().
>
> Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  kernel/entry/kvm.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> index 9d09f489b60e..2e0f75bcb7fd 100644
> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/kvm.c
> @@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>  		int ret;
>  
>  		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
> -			clear_notify_signal();
> -			if (task_work_pending(current))
> -				task_work_run();
> -		}
> -
> -		if (ti_work & _TIF_SIGPENDING) {
>  			kvm_handle_signal_exit(vcpu);
>  			return -EINTR;
>  		}
