Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534E4374833
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 20:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhEESvY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 14:51:24 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48890 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhEESvV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 14:51:21 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 06D4B20B7178;
        Wed,  5 May 2021 11:50:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 06D4B20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620240624;
        bh=kdKkY7eSHYwD6hrRi/UdcXOQVSFRpccQtWXGd1J6oXY=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=TIEQxhBZ7/Q9tha6zkSmmrwMxBADv7Y0shGW4XfvQ0o+wVONt4tL3B8klFzpjz7PW
         w5QulVEGQoBaxDvkUYygJ5/bPH197esxuKPy01IudqOa3O1fOhIZuSYXp34R0CgCl3
         dZwQQmF67Jp7N/NF9qtsfjLaMNB9lX8uHxVJqpbM=
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
 <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
 <20210505164648.GC4541@sirena.org.uk>
 <9781011e-2d99-7f46-592c-621c66ea66c3@linux.microsoft.com>
Message-ID: <8ea6a81a-2e19-f752-408c-21dea1078f9b@linux.microsoft.com>
Date:   Wed, 5 May 2021 13:50:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9781011e-2d99-7f46-592c-621c66ea66c3@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/5/21 1:48 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/5/21 11:46 AM, Mark Brown wrote:
>> On Tue, May 04, 2021 at 02:32:35PM -0500, Madhavan T. Venkataraman wrote:
>>
>>> If you prefer, I could do something like this:
>>>
>>> check_pc:
>>> 	if (!__kernel_text_address(frame->pc))
>>> 		frame->reliable = false;
>>>
>>> 	range = lookup_range(frame->pc);
>>>
>>> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>> 	if (tsk->ret_stack &&
>>> 		frame->pc == (unsigned long)return_to_handler) {
>>> 		...
>>> 		frame->pc = ret_stack->ret;
>>> 		frame->pc = ptrauth_strip_insn_pac(frame->pc);
>>> 		goto check_pc;
>>> 	}
>>> #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>>
>>> Is that acceptable?
>>
>> I think that works even if it's hard to love the goto, might want some
>> defensiveness to ensure we can't somehow end up in an infinite loop with
>> a sufficiently badly formed stack.
>>
> 
> I could do something like this:
> 
> - Move all frame->pc checking code into a function called check_frame_pc().
> 
> 	bool	check_frame_pc(frame)
> 	{
> 		Do all the checks including function graph
> 		return frame->pc changed
> 	}
> 
> - Then, in unwind_frame()
> 
> unwind_frame()
> {
> 	int	i;
> 	...
> 
> 	for (i = 0; i < MAX_CHECKS; i++) {
> 		if (!check_frame(tsk, frame))

Small typo in the last statement - It should be check_frame_pc().

Sorry.

Madhavan

> 			break;
> 	}
> 
> 	if (i == MAX_CHECKS)
> 		frame->reliable = false;
> 	return 0;
> }
> 
> The above would take care of future cases like kretprobe_trampoline().
> 
> If this is acceptable, then the only question is - what should be the value of
> MAX_CHECKS (I will rename it to something more appropriate)?
> 
> Madhavan
> 
