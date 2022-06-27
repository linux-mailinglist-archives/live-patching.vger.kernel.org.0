Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C70F55B64D
	for <lists+live-patching@lfdr.de>; Mon, 27 Jun 2022 06:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiF0Ev0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 00:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF0EvZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 00:51:25 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EF712705;
        Sun, 26 Jun 2022 21:51:25 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 231E520CD15B;
        Sun, 26 Jun 2022 21:51:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 231E520CD15B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656305484;
        bh=zJFEWu/Ud5uhM7/kCBl+rRwn01K5hofR9WJ1WLBTFIs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cwWB26CikCmaS8BVl64CjxUO7fTwCGHagFWS8ri96VfThaXNyXza+foJ8VVL8jiWJ
         qQcABmATn0wp7cDxRZ7tSdw6piJdA4xnQYugd8CeQNryNabUOmgDOisWYUKATD9Z4G
         ojWZhIGksU+JBUDi0ZOybg73xYApOErwyYjK4Efg=
Message-ID: <0c31a02c-183e-cac6-8826-82330c6fd830@linux.microsoft.com>
Date:   Sun, 26 Jun 2022 23:51:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 3/6] arm64: Make the unwind loop in unwind() similar
 to other architectures
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-4-madvenka@linux.microsoft.com>
 <YrgXA/x6uw1z75R2@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YrgXA/x6uw1z75R2@FVFF77S0Q05N>
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



On 6/26/22 03:21, Mark Rutland wrote:
> On Fri, Jun 17, 2022 at 04:07:14PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Change the loop in unwind()
>> ===========================
>>
>> Change the unwind loop in unwind() to:
>>
>> 	while (unwind_continue(state, consume_entry, cookie))
>> 		unwind_next(state);
>>
>> This is easy to understand and maintain.
>> New function unwind_continue()
>> ==============================
>>
>> Define a new function unwind_continue() that is used in the unwind loop
>> to check for conditions that terminate a stack trace.
>>
>> The conditions checked are:
>>
>> 	- If the bottom of the stack (final frame) has been reached,
>> 	  terminate.
>>
>> 	- If the consume_entry() function returns false, the caller of
>> 	  unwind has asked to terminate the stack trace. So, terminate.
>>
>> 	- If unwind_next() failed for some reason (like stack corruption),
>> 	  terminate.
> 
> I'm a bit confused as to why this structure, since AFAICT this doesn't match
> other architectures (looking at x86, powerpc, and s390). I note that x86 has:
> 
> * In arch_stack_walk():
> 
>         for (unwind_start(&state, task, regs, NULL); !unwind_done(&state);
>              unwind_next_frame(&state)) {
> 		...
> 		if (!consume_entry(...))
> 			break;
> 		...
> 	}
> 
> * In arch_stack_walk_reliable():
> 
>         for (unwind_start(&state, task, NULL, NULL);
>              !unwind_done(&state) && !unwind_error(&state);
>              unwind_next_frame(&state)) {
> 		...
> 		if (!consume_entry(...)
> 			return -EINVAL;
> 	}
> 
> ... and back in v6 I suggeted exactly that shape:
> 
>   https://lore.kernel.org/linux-arm-kernel/20210728165635.GA47345@C02TD0UTHF1T.local/
> 

OK. I will take a look at your suggestion and resend this patch.

>>
>> Do not return an error value from unwind_next()
>> ===============================================
>>
>> We want to check for terminating conditions only in unwind_continue() from
>> the unwinder loop. So, do not return an error value from unwind_next().
>> Simply set a flag in unwind_state and check the flag in unwind_continue().
> 
> I'm fine with the concept of moving ghe return value out of unwind_next() (e.g.
> if we go with an x86-like structure), but I don't think that we should
> centralize the other checks *and* the consumption within unwind_continue(), as
> I think those are two separate things.
> 

OK. I will address this in the next version.

>>
>> Final FP
>> ========
>>
>> Introduce a new field "final_fp" in "struct unwind_state". Initialize this
>> to the final frame of the stack trace:
>>
>> 	task_pt_regs(task)->stackframe
>>
>> This is where the stacktrace must terminate if it is successful. Add an
>> explicit comment to that effect.
> 
> Can we please make this change as a preparatory step, as with the 'task' field?
> 
> We can wrap this in a helper like:
> 
> static bool is_final_frame(struct unwind state *state)
> {
> 	return state->fp == state->final_fp;
> }
> 
> ... and use that in the main loop.
> 

OK. I will make these changes.

Thanks.

Madhavan
