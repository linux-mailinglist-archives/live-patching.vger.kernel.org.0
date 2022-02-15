Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70B4B776B
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 21:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbiBOSEU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 13:04:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242827AbiBOSET (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 13:04:19 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C39EF11941B;
        Tue, 15 Feb 2022 10:04:08 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id AC11320B96F6;
        Tue, 15 Feb 2022 10:04:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC11320B96F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1644948248;
        bh=vVZ+5Lbbj8DQfAkNXRkrE1JK8DxJgGeBHRod9B2hhSs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HpTzZe3sFgGTGrUS6o/eIgCoiAU51ZC8SCfzeiFJvjzCUQ7kA8cRXo+Xs5B3rcu8b
         URICMndz+2iyoO+117gGqdUdYOtQ80happsUllKx/8X+AYu7qtIFHlmONRzIs7iLg6
         UVmnVAVwLKWlyGklqcPY0UD8v+hLmYOixfvf+yMY=
Message-ID: <dec185c2-305f-0d9a-6a2f-30cd1f4a6575@linux.microsoft.com>
Date:   Tue, 15 Feb 2022 12:04:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 04/11] arm64: Split unwind_init()
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-5-madvenka@linux.microsoft.com>
 <YgulrExdlfBcHoKP@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YgulrExdlfBcHoKP@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/15/22 07:07, Mark Rutland wrote:
> Hi Madhavan,
> 
> The diff itself largely looks good, but we need to actually write the comments.
> Can you pleaes pick up the wording I've written below for those?
> 
> That and renaming `unwind_init_from_current` to `unwind_init_from_caller`.
> 
> With those I think this is good, but I'd like to see the updated version before
> I provide Acked-by or Reviewed-by tags -- hopefully that's just a formality! :)
> 

Will do.

Madhavan

> On Mon, Jan 17, 2022 at 08:56:01AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> unwind_init() is currently a single function that initializes all of the
>> unwind state. Split it into the following functions and call them
>> appropriately:
>>
>> 	- unwind_init_from_regs() - initialize from regs passed by caller.
>>
>> 	- unwind_init_from_current() - initialize for the current task
>> 	  from the caller of arch_stack_walk().
>>
>> 	- unwind_init_from_task() - initialize from the saved state of a
>> 	  task other than the current task. In this case, the other
>> 	  task must not be running.
>>
>> This is done for two reasons:
>>
>> 	- the different ways of initializing are clear
>>
>> 	- specialized code can be added to each initializer in the future.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/stacktrace.c | 54 +++++++++++++++++++++++++++-------
>>  1 file changed, 44 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index a1a7ff93b84f..b2b568e5deba 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -33,11 +33,8 @@
>>   */
>>  
>>  
>> -static void unwind_init(struct unwind_state *state, unsigned long fp,
>> -			unsigned long pc)
>> +static void unwind_init_common(struct unwind_state *state)
>>  {
>> -	state->fp = fp;
>> -	state->pc = pc;
>>  #ifdef CONFIG_KRETPROBES
>>  	state->kr_cur = NULL;
>>  #endif
>> @@ -56,6 +53,46 @@ static void unwind_init(struct unwind_state *state, unsigned long fp,
>>  	state->prev_type = STACK_TYPE_UNKNOWN;
>>  }
>>  
>> +/*
>> + * TODO: document requirements here.
>> + */
> 
> Please make this:
> 
> /*
>  * Start an unwind from a pt_regs.
>  *
>  * The unwind will begin at the PC within the regs.
>  *
>  * The regs must be on a stack currently owned by the calling task.
>  */
> 
>> +static inline void unwind_init_from_regs(struct unwind_state *state,
>> +					 struct pt_regs *regs)
>> +{
> 
> In future we could add:
> 
> 	WARN_ON_ONCE(!on_accessible_stack(current, regs, sizeof(*regs), NULL));
> 
> ... to validate the requirements, but I'm happy to lave that for a future patch
> so this patch can be a pure refactoring.
> 
>> +	unwind_init_common(state);
>> +
>> +	state->fp = regs->regs[29];
>> +	state->pc = regs->pc;
>> +}
>> +
>> +/*
>> + * TODO: document requirements here.
>> + *
>> + * Note: this is always inlined, and we expect our caller to be a noinline
>> + * function, such that this starts from our caller's caller.
>> + */
> 
> Please make this:
> 
> /*
>  * Start an unwind from a caller.
>  *
>  * The unwind will begin at the caller of whichever function this is inlined
>  * into.
>  *
>  * The function which invokes this must be noinline.
>  */
> 
>> +static __always_inline void unwind_init_from_current(struct unwind_state *state)
> 
> Can we please rename s/current/caller/ here? That way it's clear *where* in
> current we're unwinding from, and the fact that it's current is implicit but
> obvious.
> 
>> +{
> 
> Similarly to unwind_init_from_regs(), in a future patch we could add:
> 
> 	WARN_ON_ONCE(task == current);
> 
> ... but for now we can omit that so this patch can be a pure refactoring.
> 
>> +	unwind_init_common(state);
>> +
>> +	state->fp = (unsigned long)__builtin_frame_address(1);
>> +	state->pc = (unsigned long)__builtin_return_address(0);
>> +}
>> +
>> +/*
>> + * TODO: document requirements here.
>> + *
>> + * The caller guarantees that the task is not running.
>> + */
> 
> Please make this:
> 
> /*
>  * Start an unwind from a blocked task.
>  *
>  * The unwind will begin at the blocked tasks saved PC (i.e. the caller of
>  * cpu_switch_to()).
>  *
>  * The caller should ensure the task is blocked in cpu_switch_to() for the
>  * duration of the unwind, or the unwind will be bogus. It is never valid to
>  * call this for the current task.
>  */
> 
> Thanks,
> Mark.
> 
>> +static inline void unwind_init_from_task(struct unwind_state *state,
>> +					 struct task_struct *task)
>> +{
>> +	unwind_init_common(state);
>> +
>> +	state->fp = thread_saved_fp(task);
>> +	state->pc = thread_saved_pc(task);
>> +}
>> +
>>  /*
>>   * Unwind from one frame record (A) to the next frame record (B).
>>   *
>> @@ -195,14 +232,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  	struct unwind_state state;
>>  
>>  	if (regs)
>> -		unwind_init(&state, regs->regs[29], regs->pc);
>> +		unwind_init_from_regs(&state, regs);
>>  	else if (task == current)
>> -		unwind_init(&state,
>> -				(unsigned long)__builtin_frame_address(1),
>> -				(unsigned long)__builtin_return_address(0));
>> +		unwind_init_from_current(&state);
>>  	else
>> -		unwind_init(&state, thread_saved_fp(task),
>> -				thread_saved_pc(task));
>> +		unwind_init_from_task(&state, task);
>>  
>>  	unwind(task, &state, consume_entry, cookie);
>>  }
>> -- 
>> 2.25.1
>>
