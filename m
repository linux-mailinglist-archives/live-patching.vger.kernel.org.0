Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEE486AEE
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 21:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbiAFUNd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 15:13:33 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43084 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243606AbiAFUN3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 15:13:29 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 43ADE20B7179;
        Thu,  6 Jan 2022 12:13:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 43ADE20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641500009;
        bh=ekYj3DAX7k1otTJH+CiC8/gklCIU2B9Xe1JBuVI/sBw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Oiu2my5rBcJoSQH5pZo+oeVgXcfU6fE1kjfMtvHqiQErYDow6cHMNYuCHZ9sVEBoh
         umkUgGZAAIG8LVQx6IaLpywvNxfl5C0u0hs5U+Inz6BCHNIUzt0SSi5FmPvBurdaKp
         jwDotueSyJv9cjmoRpbJ2orrSTgOIdtIKLPbpnPE=
Subject: Re: [PATCH v12 04/10] arm64: Split unwind_init()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-5-madvenka@linux.microsoft.com>
 <YdcZYGI42h7zybqo@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <5e527aab-955f-00f6-c326-3a1e3ed6fcff@linux.microsoft.com>
Date:   Thu, 6 Jan 2022 14:13:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YdcZYGI42h7zybqo@FVFF77S0Q05N>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 1/6/22 10:31 AM, Mark Rutland wrote:
> On Mon, Jan 03, 2022 at 10:52:06AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> unwind_init() is currently a single function that initializes all of the
>> unwind state. Split it into the following functions and call them
>> appropriately:
>>
>> 	- unwind_init_regs() - initialize from regs passed by caller.
>>
>> 	- unwind_init_current() - initialize for the current task from the
>> 	  caller of arch_stack_walk().
>>
>> 	- unwind_init_from_task() - initialize from the saved state of a
>> 	  task other than the current task. In this case, the other
>> 	  task must not be running.
>>
>> 	- unwind_init_common() - initialize fields that are common across
>> 	  the above 3 cases.
>>
>> This is done so that specialized initialization can be added to each case
>> in the future.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/stacktrace.c | 50 +++++++++++++++++++++++++++-------
>>  1 file changed, 40 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index a1a7ff93b84f..bd797e3f7789 100644
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
>> @@ -56,6 +53,40 @@ static void unwind_init(struct unwind_state *state, unsigned long fp,
>>  	state->prev_type = STACK_TYPE_UNKNOWN;
>>  }
>>  
>> +/*
>> + * TODO: document requirements here.
>> + */
>> +static inline void unwind_init_regs(struct unwind_state *state,
>> +				    struct pt_regs *regs)
>> +{
>> +	state->fp = regs->regs[29];
>> +	state->pc = regs->pc;
>> +}
> 
> When I suggested this back in:
> 
>   https://lore.kernel.org/linux-arm-kernel/20211123193723.12112-1-madvenka@linux.microsoft.com/T/#md91fbfe08ceab2a02d9f5c326e17997786e53208
> 
> ... my intent was that each unwind_init_from_*() helpers was the sole
> initializer of the structure, and the caller only had to call one function.
> That way it's not possible to construct an object with an erroneous combination
> of arguments because the prototype enforces the set of arguments, and the
> helper function can operate on a consistent snapshot of those arguments.
> 
> So I'd much prefer that each of these helpers called unwind_init_common(),
> rather than leaving that to the caller to do. I don't mind if those pass
> arguments to unwind_init_common(), or explciitly initialize their respective
> fields, but I don' think the caller should have to care about unwind_init_common().
> 
> I'd also prefer the unwind_init_from*() naming I'd previously suggested, so
> that it's clear which direction information is flowing.
> 

OK. No problem.

>>
>> +
>> +/*
>> + * TODO: document requirements here.
>> + *
>> + * Note: this is always inlined, and we expect our caller to be a noinline
>> + * function, such that this starts from our caller's caller.
>> + */
>> +static __always_inline void unwind_init_current(struct unwind_state *state)
>> +{
>> +	state->fp = (unsigned long)__builtin_frame_address(1);
>> +	state->pc = (unsigned long)__builtin_return_address(0);
>> +}
>> +
>> +/*
>> + * TODO: document requirements here.
>> + *
>> + * The caller guarantees that the task is not running.
>> + */
>> +static inline void unwind_init_task(struct unwind_state *state,
>> +				    struct task_struct *task)
>> +{
>> +	state->fp = thread_saved_fp(task);
>> +	state->pc = thread_saved_pc(task);
>> +}
>> +
>>  /*
>>   * Unwind from one frame record (A) to the next frame record (B).
>>   *
>> @@ -194,15 +225,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  {
>>  	struct unwind_state state;
>>  
>> +	unwind_init_common(&state);
> 
> As above, I really don't like that the caller has to call both the common
> initializer and a specialized initializer here.
> 

OK. Will change this.

Thanks.

Madhavan
