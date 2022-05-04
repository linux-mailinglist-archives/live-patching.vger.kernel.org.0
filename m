Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3239651A2CE
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiEDPC0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 11:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiEDPCZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 11:02:25 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33B71A816;
        Wed,  4 May 2022 07:58:48 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:52804)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmFoX-003bD1-UG; Wed, 04 May 2022 08:17:13 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:36906 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmFoW-00DS5o-Ew; Wed, 04 May 2022 08:17:13 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Petr Mladek <pmladek@suse.com>
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
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
        <20220504130753.GB8069@pathway.suse.cz>
Date:   Wed, 04 May 2022 09:16:46 -0500
In-Reply-To: <20220504130753.GB8069@pathway.suse.cz> (Petr Mladek's message of
        "Wed, 4 May 2022 15:07:53 +0200")
Message-ID: <87r159fkmp.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nmFoW-00DS5o-Ew;;;mid=<87r159fkmp.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/PsYWhFWPq0Ll6mfLUge9ag9Wd5++oPJw=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Petr Mladek <pmladek@suse.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 858 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 10 (1.2%), b_tie_ro: 9 (1.0%), parse: 1.68 (0.2%),
         extract_message_metadata: 20 (2.4%), get_uri_detail_list: 4.5 (0.5%),
        tests_pri_-1000: 34 (4.0%), tests_pri_-950: 1.40 (0.2%),
        tests_pri_-900: 1.15 (0.1%), tests_pri_-90: 161 (18.8%), check_bayes:
        159 (18.6%), b_tokenize: 28 (3.3%), b_tok_get_all: 15 (1.8%),
        b_comp_prob: 15 (1.7%), b_tok_touch_all: 96 (11.2%), b_finish: 1.21
        (0.1%), tests_pri_0: 609 (70.9%), check_dkim_signature: 0.79 (0.1%),
        check_dkim_adsp: 3.3 (0.4%), poll_dns_idle: 1.08 (0.1%), tests_pri_10:
        2.3 (0.3%), tests_pri_500: 12 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> writes:

> On Tue 2022-05-03 12:49:34, Seth Forshee wrote:
>> A task can be livepatched only when it is sleeping or it exits to
>> userspace. This may happen infrequently for a heavily loaded vCPU task,
>> leading to livepatch transition failures.
>
> This is misleading.
>
> First, the problem is not a loaded CPU. The problem is that the
> task might spend very long time in the kernel when handling
> some syscall.
>
> Second, there is no timeout for the transition in the kernel code.
> It might take very long time but it will not fail.
>
>> Fake signals will be sent to tasks which fail patching via stack
>> checking. This will cause running vCPU tasks to exit guest mode, but
>> since no signal is pending they return to guest execution without
>> exiting to userspace. Fix this by treating a pending livepatch migration
>> like a pending signal, exiting to userspace with EINTR. This allows the
>> task to be patched, and userspace should re-excecute KVM_RUN to resume
>> guest execution.
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
>
> The solution provided by this patch is a bit weird, see below.
>
>
>> In my testing, systems where livepatching would timeout after 60 seconds
>> were able to load livepatches within a couple of seconds with this
>> change.
>> 
>> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
>> ---
>> Changes in v2:
>>  - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
>>  - Reworded commit message and comments to avoid confusion around the
>>    term "migrate"
>> 
>>  include/linux/entry-kvm.h | 4 ++--
>>  kernel/entry/kvm.c        | 7 ++++++-
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
>> index 6813171afccb..bf79e4cbb5a2 100644
>> --- a/include/linux/entry-kvm.h
>> +++ b/include/linux/entry-kvm.h
>> @@ -17,8 +17,8 @@
>>  #endif
>>  
>>  #define XFER_TO_GUEST_MODE_WORK						\
>> -	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
>> -	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
>> +	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
>> +	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
>>  
>>  struct kvm_vcpu;
>>  
>> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
>> index 9d09f489b60e..98439dfaa1a0 100644
>> --- a/kernel/entry/kvm.c
>> +++ b/kernel/entry/kvm.c
>> @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>>  				task_work_run();
>>  		}
>>  
>> -		if (ti_work & _TIF_SIGPENDING) {
>> +		/*
>> +		 * When a livepatch is pending, force an exit to userspace
>> +		 * as though a signal is pending to allow the task to be
>> +		 * patched.
>> +		 */
>> +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
>>  			kvm_handle_signal_exit(vcpu);
>>  			return -EINTR;
>>  		}
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

It looks like xfer_to_guest_mode_work runs like exit_to_user_mode_loop,
just before guest mode is invoked.

> If "yes" then we do not need to call kvm_handle_signal_exit(vcpu).
> It will be enough to call:
>
> 		if (ti_work & _TIF_PATCH_PENDING)
> 			klp_update_patch_state(current);
>
> If "no" then I do not understand why TIF_NOTIFY_SIGNAL interrupts
> the syscall on the real hardware and not in kvm.
>
> Anyway, we either should make sure that TIF_NOTIFY_SIGNAL has the same
> effect on the real hardware and in kvm. Or we need another interface
> for the fake signal used by livepatching.

The point of TIF_NOTIFY_SIGNAL is to break out of interruptible kernel
loops.  Once out of the interruptible kernel loop the expectation is the
returns to user space and on it's way runs the exit_to_user_mode_loop or
is architecture specific equivalent.


> Adding Jens Axboe and Eric into Cc.


Yes.  This is interesting.

Reading through the history of kernel/entry/kvm.c I believe
I made ``conservative'' changes that has not helped this situation.

Long story short at one point it was thought that _TIF_SIGPENDING
and _TIF_NOTIFY_SIGNAL could be separated and they could not.
Unfortunately the work to separate their handling has not been
completely undone.

In this case it appears that the only reason xfer_to_guest_mode_work
touches task_work_run is because of the separation work done by Jens
Axboe.  I don't see any kvm specific reason for _TIF_NOTIFY_SIGNAL
and _TIF_SIGPENDING to be treated differently.  Meanwhile my cleanups
elsewhere have made the unnecessary _TIF_NOTIFY_SIGNAL special case
bigger in xfer_to_guest_mode_work.

I suspect the first step in fixing things really should be just handling
_TIF_SIGPENDING and _TIF_NOTIFY_SIGNAL the same.

static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
{
	do {
		int ret;

		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
			kvm_handle_signal_exit(vcpu);
			return -EINTR;
		}

		if (ti_work & _TIF_NEED_RESCHED)
			schedule();

		if (ti_work & _TIF_NOTIFY_RESUME)
			resume_user_mode_work(NULL);

		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
		if (ret)
			return ret;

		ti_work = read_thread_flags();
	} while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
	return 0;
}

That said I do expect adding support for the live patching into
xfer_to_guest_mode_work, like there is in exit_to_user_mode_loop, is
probably a good idea.  That should prevent the live patching code from
needing to set TIF_NOTIFY_SIGNAL.

Something like:

Thomas Gleixner's patch to make _TIF_PATCH_PENDING always available.

#define XFER_TO_GUEST_MODE_WORK						\
	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)


static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
{
	do {
		int ret;

		if (ti_work & _TIF_PATCH_PENDING)
			klp_update_patch_state(current);

		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
			kvm_handle_signal_exit(vcpu);
			return -EINTR;
		}

		if (ti_work & _TIF_NEED_RESCHED)
			schedule();

		if (ti_work & _TIF_NOTIFY_RESUME)
			resume_user_mode_work(NULL);

		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
		if (ret)
			return ret;

		ti_work = read_thread_flags();
	} while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
	return 0;
}

If the kvm and the live patching folks could check my thinking that
would be great.

Eric
