Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8BE6AC962
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCFRJi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 12:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCFRJU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 12:09:20 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 331783B673;
        Mon,  6 Mar 2023 09:08:27 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.203.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id E36D620BBF92;
        Mon,  6 Mar 2023 08:52:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E36D620BBF92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678121530;
        bh=sVOn/vcPfOqwuN4KZzT/D2YzwVerqFmDVpeOIxrv9dc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fU0wypCRqWz3wIXknA/RYCcVWWyzaHutzCMOyjyl+CX4nLXJLAjZV7We+/G0FncMR
         dOOdjrkBO9SWpF/ul4tBjl1vhIrkHZ9ycS5sL8vTGl3bCkNZkG3mR2FJyp6/Ju3qEE
         xbMut7amOsTsiytyHR+OeQ6kkxWjTY1oAJMeAvrY=
Message-ID: <56308235-3893-75ac-a19f-497cc203c520@linux.microsoft.com>
Date:   Mon, 6 Mar 2023 10:52:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 19/22] arm64: unwinder: Add a reliability check in
 the unwinder based on ORC
Content-Language: en-US
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     poimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <20230202074036.507249-20-madvenka@linux.microsoft.com>
 <88ab8c8348373e5c7c90c985dd92b5e06f32b16b.camel@gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <88ab8c8348373e5c7c90c985dd92b5e06f32b16b.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/22/23 22:07, Suraj Jitindar Singh wrote:
> On Thu, 2023-02-02 at 01:40 -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Introduce a reliability flag in struct unwind_state. This will be set
>> to
>> false if the PC does not have a valid ORC or if the frame pointer
>> computed
>> from the ORC does not match the actual frame pointer.
>>
>> Now that the unwinder can validate the frame pointer, introduce
>> arch_stack_walk_reliable().
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com
>>>
>> ---
>>  arch/arm64/include/asm/stacktrace/common.h |  15 ++
>>  arch/arm64/kernel/stacktrace.c             | 167
>> ++++++++++++++++++++-
>>  2 files changed, 175 insertions(+), 7 deletions(-)
>>
> 
> [snip]
>  
>> -static void notrace unwind(struct unwind_state *state,
>> +static int notrace unwind(struct unwind_state *state, bool
>> need_reliable,
>>  			   stack_trace_consume_fn consume_entry, void
>> *cookie)
>>  {
>> -	while (1) {
>> -		int ret;
>> +	int ret = 0;
>>  
>> +	while (1) {
>> +		if (need_reliable && !state->reliable)
>> +			return -EINVAL;
>>  		if (!consume_entry(cookie, state->pc))
>>  			break;
>>  		ret = unwind_next(state);
>> +		if (need_reliable && !ret)
>> +			unwind_check_reliable(state);
>>  		if (ret < 0)
>>  			break;
>>  	}
>> +	return ret;
> 
> nit:
> 
> I think you're looking more for comments on the approach and the
> correctness of these patches, but from an initial read I'm still
> putting it all together in my head. So this comment is on the coding
> style.
> 
> The above loop seems to check the current reliability state, then
> unwind a frame then check the reliability, and then break based of
> something which couldn't have been updated by the line immediately
> above. I propose something like:
> 
> unwind(...) {
> 	ret = 0;
> 
> 	while (!ret) {
> 		if (need_reliable) {
> 			unwind_check_reliable(state);
> 			if (!state->reliable)
> 				return -EINVAL;
> 		}
> 		if (!consume_entry(cookie, state->pc))
> 			return -EINVAL;
> 		ret = unwind_next(state);
> 	}
> 
> 	return ret;
> }
> 
> This also removes the need for the call to unwind_check_reliable()
> before the first unwind() below in arch_stack_walk_reliable().
> 

OK. Suggestion sounds reasonable. Will do.

Madhavan

> - Suraj
> 
>>  }
>>  NOKPROBE_SYMBOL(unwind);
>>  
>> @@ -216,5 +337,37 @@ noinline notrace void
>> arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  		unwind_init_from_task(&state, task);
>>  	}
>>  
>> -	unwind(&state, consume_entry, cookie);
>> +	unwind(&state, false, consume_entry, cookie);
>> +}
>> +
>> +noinline notrace int arch_stack_walk_reliable(
>> +				stack_trace_consume_fn consume_entry,
>> +				void *cookie, struct task_struct *task)
>> +{
>> +	struct stack_info stacks[] = {
>> +		stackinfo_get_task(task),
>> +		STACKINFO_CPU(irq),
>> +#if defined(CONFIG_VMAP_STACK)
>> +		STACKINFO_CPU(overflow),
>> +#endif
>> +#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_ARM_SDE_INTERFACE)
>> +		STACKINFO_SDEI(normal),
>> +		STACKINFO_SDEI(critical),
>> +#endif
>> +	};
>> +	struct unwind_state state = {
>> +		.stacks = stacks,
>> +		.nr_stacks = ARRAY_SIZE(stacks),
>> +	};
>> +	int ret;
>> +
>> +	if (task == current)
>> +		unwind_init_from_caller(&state);
>> +	else
>> +		unwind_init_from_task(&state, task);
>> +	unwind_check_reliable(&state);
>> +
>> +	ret = unwind(&state, true, consume_entry, cookie);
>> +
>> +	return ret == -ENOENT ? 0 : -EINVAL;
>>  }
