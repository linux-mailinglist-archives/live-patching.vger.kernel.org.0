Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6961486AF8
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 21:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243642AbiAFURd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 15:17:33 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43578 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243582AbiAFURc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 15:17:32 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 75A7B20B7179;
        Thu,  6 Jan 2022 12:17:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 75A7B20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641500252;
        bh=Hh0ZW8EfXcZcHkCAjia0bYshL301LrZuYH2kh2Opuv0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=P5EypePoLb/EQ/hWUmzTdmQ10elVlRKQ4nJDP8rp15UUW/IYDaGZzF+TfBN7tUKn6
         KYIyVpFHZJn4qzA+2oaWffU7HDILuzyN7wklK5CzF6kIZczInrF+LEK4dQUjzNE9qb
         lS4aIl5BTRtupLc1iqy0UVhZa3SchawkJHKkJrQA=
Subject: Re: [PATCH v12 05/10] arm64: Copy unwind arguments to unwind_state
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-6-madvenka@linux.microsoft.com>
 <Ydcax2E9u4D4/3Q9@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <6fce7dd5-2f45-5034-bdf8-6c3a3499e9e7@linux.microsoft.com>
Date:   Thu, 6 Jan 2022 14:17:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Ydcax2E9u4D4/3Q9@FVFF77S0Q05N>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 1/6/22 10:37 AM, Mark Rutland wrote:
> On Mon, Jan 03, 2022 at 10:52:07AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Copy the following arguments passed to arch_stack_walk() to unwind_state
>> so that they can be passed to unwind functions via unwind_state rather
>> than as separate arguments:
>>
>> 	- task
> 
> I agree the task should be placed in the unwind state, since it's a key part of
> the environment for the unwind.
> 
>> 	- regs
> 
> This isn't relevant in all cases, and so for now I'd strongly prefer *not* to
> have this in the unwind state as it's liable to lead to confusion and get
> misused.
> 
>> 	- consume_entry
>> 	- cookie
> 
> These are only relevant for the invocation of the consume_entry() function, and
> so similarly I do not think they should be part of the state. It's simpler for
> these to be local variables.
> 

OK.

>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/include/asm/stacktrace.h | 12 ++++++++
>>  arch/arm64/kernel/stacktrace.c      | 45 ++++++++++++++++-------------
>>  2 files changed, 37 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index fc828c3c5dfd..322817d40a75 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -51,6 +51,14 @@ struct stack_info {
>>   * @kr_cur:      When KRETPOLINES is selected, holds the kretprobe instance
>>   *               associated with the most recently encountered replacement lr
>>   *               value.
>> + *
>> + * @task:        Pointer to the task structure.
>> + *
>> + * @regs:        Registers, if any.
>> + *
>> + * @consume_pc   Consume PC function pointer.
>> + *
>> + * @cookie       Argument to consume_pc().
>>   */
>>  struct unwind_state {
>>  	unsigned long fp;
>> @@ -61,6 +69,10 @@ struct unwind_state {
>>  #ifdef CONFIG_KRETPROBES
>>  	struct llist_node *kr_cur;
>>  #endif
>> +	struct task_struct *task;
>> +	struct pt_regs *regs;
>> +	stack_trace_consume_fn consume_pc;
>> +	void *cookie;
>>  };
>>  
>>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index bd797e3f7789..3ecb8242caa5 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -33,8 +33,17 @@
>>   */
>>  
>>  
>> -static void unwind_init_common(struct unwind_state *state)
>> +static void unwind_init_common(struct unwind_state *state,
>> +			       struct task_struct *task,
>> +			       struct pt_regs *regs,
>> +			       stack_trace_consume_fn consume_pc,
>> +			       void *cookie)
>>  {
>> +	state->task = task;
>> +	state->regs = regs;
>> +	state->consume_pc = consume_pc;
>> +	state->cookie = cookie;
>> +
>>  #ifdef CONFIG_KRETPROBES
>>  	state->kr_cur = NULL;
>>  #endif
>> @@ -56,11 +65,10 @@ static void unwind_init_common(struct unwind_state *state)
>>  /*
>>   * TODO: document requirements here.
>>   */
>> -static inline void unwind_init_regs(struct unwind_state *state,
>> -				    struct pt_regs *regs)
>> +static inline void unwind_init_regs(struct unwind_state *state)
>>  {
>> -	state->fp = regs->regs[29];
>> -	state->pc = regs->pc;
>> +	state->fp = state->regs->regs[29];
>> +	state->pc = state->regs->pc;
>>  }
>>  
>>  /*
>> @@ -80,11 +88,10 @@ static __always_inline void unwind_init_current(struct unwind_state *state)
>>   *
>>   * The caller guarantees that the task is not running.
>>   */
>> -static inline void unwind_init_task(struct unwind_state *state,
>> -				    struct task_struct *task)
>> +static inline void unwind_init_task(struct unwind_state *state)
>>  {
>> -	state->fp = thread_saved_fp(task);
>> -	state->pc = thread_saved_pc(task);
>> +	state->fp = thread_saved_fp(state->task);
>> +	state->pc = thread_saved_pc(state->task);
>>  }
>>  
>>  /*
>> @@ -94,9 +101,9 @@ static inline void unwind_init_task(struct unwind_state *state,
>>   * records (e.g. a cycle), determined based on the location and fp value of A
>>   * and the location (but not the fp value) of B.
>>   */
>> -static int notrace unwind_next(struct task_struct *tsk,
>> -			       struct unwind_state *state)
>> +static int notrace unwind_next(struct unwind_state *state)
>>  {
>> +	struct task_struct *tsk = state->task;
>>  	unsigned long fp = state->fp;
>>  	struct stack_info info;
>>  
>> @@ -170,16 +177,14 @@ static int notrace unwind_next(struct task_struct *tsk,
>>  }
>>  NOKPROBE_SYMBOL(unwind_next);
>>  
>> -static void notrace unwind(struct task_struct *tsk,
>> -			   struct unwind_state *state,
>> -			   bool (*fn)(void *, unsigned long), void *data)
>> +static void notrace unwind(struct unwind_state *state)
>>  {
>>  	while (1) {
>>  		int ret;
>>  
>> -		if (!fn(data, state->pc))
>> +		if (!state->consume_pc(state->cookie, state->pc))
>>  			break;
>> -		ret = unwind_next(tsk, state);
>> +		ret = unwind_next(state);
>>  		if (ret < 0)
>>  			break;
>>  	}
>> @@ -225,14 +230,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  {
>>  	struct unwind_state state;
>>  
>> -	unwind_init_common(&state);
>> +	unwind_init_common(&state, task, regs, consume_entry, cookie);
>>  
>>  	if (regs)
>> -		unwind_init_regs(&state, regs);
>> +		unwind_init_regs(&state);
>>  	else if (task == current)
>>  		unwind_init_current(&state);
>>  	else
>> -		unwind_init_task(&state, task);
>> +		unwind_init_task(&state);
>>  
>> -	unwind(task, &state, consume_entry, cookie);
>> +	unwind(&state);
> 
> I don't like the changes here in particular since they hide the information
> flow relevant to each case.
> 

Per previous comment I agreed to, I will pass all the arguments other than task
directly.

Thanks.

Madhavan
