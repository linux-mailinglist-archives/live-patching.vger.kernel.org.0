Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD643DA4C6
	for <lists+live-patching@lfdr.de>; Thu, 29 Jul 2021 15:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhG2NzD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Jul 2021 09:55:03 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36586 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237656AbhG2NzD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Jul 2021 09:55:03 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2FA3620B36E8;
        Thu, 29 Jul 2021 06:54:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2FA3620B36E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627566900;
        bh=0nVaqk7iajeUlBqRCzVPHIC889cPZdErmHJQuZLPtCA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PTI2c75KrM3L7fDS7rcylvLg2/9jOmXv9PVjoeE87Ro90eckniXpVrMm49gQ2a/9z
         J7xxBieYPorZTO22QX3A7SxCQ8Ob4hptli1yxhMn0raRRcWgpYOhX0nZh6TvxKdDjX
         oBh6YJo7HZ+Mimo/QsDbLR1InQhGmm3fbv5pZJvE=
Subject: Re: [RFC PATCH v6 1/3] arm64: Improve the unwinder return value
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-2-madvenka@linux.microsoft.com>
 <20210728165635.GA47345@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <52686cb6-573c-03ca-06c2-67ae07c91243@linux.microsoft.com>
Date:   Thu, 29 Jul 2021 08:54:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728165635.GA47345@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks for the review. Responses inline...

On 7/28/21 11:56 AM, Mark Rutland wrote:
> On Wed, Jun 30, 2021 at 05:33:54PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, the unwinder returns a tri-state return value:
>>
>> 	0		means "continue with the unwind"
>> 	-ENOENT		means "successful termination of the stack trace"
>> 	-EINVAL		means "fatal error, abort the stack trace"
>>
>> This is confusing. To fix this, define an enumeration of different return
>> codes to make it clear. Handle the return codes in all of the unwind
>> consumers.
> 
> I agree the tri-state is confusing, and I also generally agree that
> enums are preferabel to a set of error codes. However, I don't think
> this is quite the right abstraction; more on that below.
> 

OK.

>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/include/asm/stacktrace.h | 14 ++++++--
>>  arch/arm64/kernel/perf_callchain.c  |  5 ++-
>>  arch/arm64/kernel/process.c         |  8 +++--
>>  arch/arm64/kernel/return_address.c  | 10 ++++--
>>  arch/arm64/kernel/stacktrace.c      | 53 ++++++++++++++++-------------
>>  arch/arm64/kernel/time.c            |  9 +++--
>>  6 files changed, 64 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index eb29b1fe8255..6fcd58553fb1 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -30,6 +30,12 @@ struct stack_info {
>>  	enum stack_type type;
>>  };
>>  
>> +enum unwind_rc {
>> +	UNWIND_CONTINUE,		/* No errors encountered */
>> +	UNWIND_ABORT,			/* Fatal errors encountered */
>> +	UNWIND_FINISH,			/* End of stack reached successfully */
>> +};
> 
> Generally, there are a bunch of properties we might need to check for an
> unwind step relating to reliabiltiy (e.g. as you add
> UNWIND_CONTINUE_WITH_RISK in the next patch), and I'd prefer that we
> check those properties on the struct stackframe, and simplify
> unwind_frame() to return a bool.
> 
> Something akin to the x86 unwinders, where the main loop looks like:
> 
> for (unwind_start(&state, ...);
>      !unwind_done(&state) && !unwind_error(&state);
>      unwind_next_frame(&state) {
> 	...
> }
> 
> That way we don't have to grow the enum to handle every variation that
> we can think of, and it's simple enough for users to check the
> properties with the helpers.
> 

I can do that.

>> +
>>  /*
>>   * A snapshot of a frame record or fp/lr register values, along with some
>>   * accounting information necessary for robust unwinding.
>> @@ -61,7 +67,8 @@ struct stackframe {
>>  #endif
>>  };
>>  
>> -extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
>> +extern enum unwind_rc unwind_frame(struct task_struct *tsk,
>> +				   struct stackframe *frame);
>>  extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
>>  			    bool (*fn)(void *, unsigned long), void *data);
>>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>> @@ -148,8 +155,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>>  	return false;
>>  }
>>  
>> -static inline void start_backtrace(struct stackframe *frame,
>> -				   unsigned long fp, unsigned long pc)
>> +static inline enum unwind_rc start_backtrace(struct stackframe *frame,
>> +					     unsigned long fp, unsigned long pc)
>>  {
>>  	frame->fp = fp;
>>  	frame->pc = pc;
>> @@ -169,6 +176,7 @@ static inline void start_backtrace(struct stackframe *frame,
>>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>>  	frame->prev_fp = 0;
>>  	frame->prev_type = STACK_TYPE_UNKNOWN;
>> +	return UNWIND_CONTINUE;
>>  }
>>  
>>  #endif	/* __ASM_STACKTRACE_H */
>> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
>> index 88ff471b0bce..f459208149ae 100644
>> --- a/arch/arm64/kernel/perf_callchain.c
>> +++ b/arch/arm64/kernel/perf_callchain.c
>> @@ -148,13 +148,16 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>>  			   struct pt_regs *regs)
>>  {
>>  	struct stackframe frame;
>> +	enum unwind_rc rc;
>>  
>>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
>>  		/* We don't support guest os callchain now */
>>  		return;
>>  	}
>>  
>> -	start_backtrace(&frame, regs->regs[29], regs->pc);
>> +	rc = start_backtrace(&frame, regs->regs[29], regs->pc);
>> +	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
>> +		return;
>>  	walk_stackframe(current, &frame, callchain_trace, entry);
> 
> As a first step, could we convert this over to arch_stack_walk()?
> 

OK.

>>  }
>>  
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 6e60aa3b5ea9..e9c763b44fd4 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -573,6 +573,7 @@ unsigned long get_wchan(struct task_struct *p)
>>  	struct stackframe frame;
>>  	unsigned long stack_page, ret = 0;
>>  	int count = 0;
>> +	enum unwind_rc rc;
>>  	if (!p || p == current || p->state == TASK_RUNNING)
>>  		return 0;
>>  
>> @@ -580,10 +581,13 @@ unsigned long get_wchan(struct task_struct *p)
>>  	if (!stack_page)
>>  		return 0;
>>  
>> -	start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
>> +	rc = start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
>> +	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
>> +		return 0;
>>  
>>  	do {
>> -		if (unwind_frame(p, &frame))
>> +		rc = unwind_frame(p, &frame);
>> +		if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
>>  			goto out;
>>  		if (!in_sched_functions(frame.pc)) {
>>  			ret = frame.pc;
> 
> Likewise, can we convert this to use arch_stack_walk()?
> 

OK.

>> diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
>> index a6d18755652f..1224e043e98f 100644
>> --- a/arch/arm64/kernel/return_address.c
>> +++ b/arch/arm64/kernel/return_address.c
>> @@ -36,13 +36,17 @@ void *return_address(unsigned int level)
>>  {
>>  	struct return_address_data data;
>>  	struct stackframe frame;
>> +	enum unwind_rc rc;
>>  
>>  	data.level = level + 2;
>>  	data.addr = NULL;
>>  
>> -	start_backtrace(&frame,
>> -			(unsigned long)__builtin_frame_address(0),
>> -			(unsigned long)return_address);
>> +	rc = start_backtrace(&frame,
>> +			     (unsigned long)__builtin_frame_address(0),
>> +			     (unsigned long)return_address);
>> +	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
>> +		return NULL;
>> +
>>  	walk_stackframe(current, &frame, save_return_addr, &data);
> 
> Likewise, can we convert this to use arch_stack_walk()?
> 

OK.

Thanks.

Madhavan
