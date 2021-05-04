Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0F93730D3
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 21:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhEDTdc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 15:33:32 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60638 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhEDTdb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 15:33:31 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id EB8FB20B7178;
        Tue,  4 May 2021 12:32:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EB8FB20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620156756;
        bh=VpUXm1vXYJ2pKfbkpAPbT9u9hdyCkuFseoK05J0qTvU=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=AGyabpQ4bzjD9q9q5KY4O0oiMDlhuSgKE1Y+Id9nXundCbzdr1GJFOTVrlskzId14
         n1N9tdINtjeMLpICrIPY6UiqB2bISeJiB7ndZIEP0IhLrt8Rc8LsXDW+t/wrMT5bKQ
         6N6RE6nbJBOuJxgCzZ9OhmpwvzQ6qc8XaiuL/tYU=
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
Message-ID: <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
Date:   Tue, 4 May 2021 14:32:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/4/21 2:03 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/4/21 11:05 AM, Mark Brown wrote:
>> On Mon, May 03, 2021 at 12:36:13PM -0500, madvenka@linux.microsoft.com wrote:
>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>
>>> Create a sym_code_ranges[] array to cover the following text sections that
>>> contain functions defined as SYM_CODE_*(). These functions are low-level
>>
>> This makes sense to me - a few of bikesheddy comments below but nothing
>> really substantive.
>>
> 
> OK.
> 
>>> +static struct code_range *lookup_range(unsigned long pc)
>>
>> This feels like it should have a prefix on the name (eg, unwinder_)
>> since it looks collision prone.  Or lookup_code_range() rather than just
>> plain lookup_range().
>>
> 
> I will add the prefix.
> 
>>> +{
>> +       struct code_range *range;
>> +         
>> +       for (range = sym_code_ranges; range->start; range++) {
>>
>> It seems more idiomatic to use ARRAY_SIZE() rather than a sentinel here,
>> the array can't be empty.
>>
> 
> If there is a match, I return the matched range. Else, I return the sentinel.
> This is just so I don't have to check for range == NULL after calling
> lookup_range().
> 
> I will change it to what you have suggested and check for NULL explicitly.
> It is not a problem.
> 
>>> +	range = lookup_range(frame->pc);
>>> +
>>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>>  	if (tsk->ret_stack &&
>>>  		frame->pc == (unsigned long)return_to_handler) {
>>> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>>  			return -EINVAL;
>>>  		frame->pc = ret_stack->ret;
>>>  		frame->pc = ptrauth_strip_insn_pac(frame->pc);
>>> +		return 0;
>>>  	}
>>
>> Do we not need to look up the range of the restored pc and validate
>> what's being pointed to here?  It's not immediately obvious why we do
>> the lookup before handling the function graph tracer, especially given
>> that we never look at the result and there's now a return added skipping
>> further reliability checks.  At the very least I think this needs some
>> additional comments so the code is more obvious.
> I want sym_code_ranges[] to contain both unwindable and non-unwindable ranges.
> Unwindable ranges will be special ranges such as the return_to_handler() and
> kretprobe_trampoline() functions for which the unwinder has (or will have)
> special code to unwind. So, the lookup_range() has to happen before the
> function graph code. Please look at the last patch in the series for
> the fix for the above function graph code.
> 
> On the question of "should the original return address be checked against
> sym_code_ranges[]?" - I assumed that if there is a function graph trace on a
> function, it had to be an ftraceable function. It would not be a part
> of sym_code_ranges[]. Is that a wrong assumption on my part?
> 

If you prefer, I could do something like this:

check_pc:
	if (!__kernel_text_address(frame->pc))
		frame->reliable = false;

	range = lookup_range(frame->pc);

#ifdef CONFIG_FUNCTION_GRAPH_TRACER
	if (tsk->ret_stack &&
		frame->pc == (unsigned long)return_to_handler) {
		...
		frame->pc = ret_stack->ret;
		frame->pc = ptrauth_strip_insn_pac(frame->pc);
		goto check_pc;
	}
#endif /* CONFIG_FUNCTION_GRAPH_TRACER */

Is that acceptable?

Madhavan
