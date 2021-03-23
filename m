Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C8E3462B0
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhCWPWz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 11:22:55 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43954 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhCWPWl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 11:22:41 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 99E9120B5680;
        Tue, 23 Mar 2021 08:22:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99E9120B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616512961;
        bh=EI1uKbfraV1cG4bEEEQBV8q/N2mbFDxBXYmbzNTRNhU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YjkHvocvBFcfhWo2dnhR2Sg8VXZPlSInO814iKW9ptxTWzZH2AvuzS3rdBcHdW43A
         6XdYqagXUzlT1Lb8pitoPi+cS+65my457qgifj11SKajo0y6+sJsjegl4KIuU0b/Mg
         MsTCpsG2qw8FZ+gc7ax1b1YD3iBD1xO3bQzwJF0Q=
Subject: Re: [RFC PATCH v2 4/8] arm64: Detect an EL1 exception frame and mark
 a stack trace unreliable
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-5-madvenka@linux.microsoft.com>
 <20210323104251.GD95840@C02TD0UTHF1T.local>
 <c4a36a6f-c84f-1ad9-cd03-974f6a39c37b@linux.microsoft.com>
 <20210323130425.GA98545@C02TD0UTHF1T.local>
 <f5dd48d3-c0ea-a719-c10d-83e62db3e7c0@linux.microsoft.com>
 <20210323143345.GC98545@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <efaf82d9-8f66-7e0e-0cac-cee38450a224@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 10:22:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323143345.GC98545@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 9:33 AM, Mark Rutland wrote:
> On Tue, Mar 23, 2021 at 08:31:50AM -0500, Madhavan T. Venkataraman wrote:
>> On 3/23/21 8:04 AM, Mark Rutland wrote:
>>> On Tue, Mar 23, 2021 at 07:46:10AM -0500, Madhavan T. Venkataraman wrote:
>>>> On 3/23/21 5:42 AM, Mark Rutland wrote:
>>>>> On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
>>>>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>>>
>>>>>> EL1 exceptions can happen on any instruction including instructions in
>>>>>> the frame pointer prolog or epilog. Depending on where exactly they happen,
>>>>>> they could render the stack trace unreliable.
>>>>>>
>>>>>> If an EL1 exception frame is found on the stack, mark the stack trace as
>>>>>> unreliable.
>>>>>>
>>>>>> Now, the EL1 exception frame is not at any well-known offset on the stack.
>>>>>> It can be anywhere on the stack. In order to properly detect an EL1
>>>>>> exception frame the following checks must be done:
>>>>>>
>>>>>> 	- The frame type must be EL1_FRAME.
>>>>>>
>>>>>> 	- When the register state is saved in the EL1 pt_regs, the frame
>>>>>> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
>>>>>> 	  is saved in pt_regs->pc. These must match with the current
>>>>>> 	  frame.
>>>>>
>>>>> Before you can do this, you need to reliably identify that you have a
>>>>> pt_regs on the stack, but this patch uses a heuristic, which is not
>>>>> reliable.
>>>>>
>>>>> However, instead you can identify whether you're trying to unwind
>>>>> through one of the EL1 entry functions, which tells you the same thing
>>>>> without even having to look at the pt_regs.
>>>>>
>>>>> We can do that based on the entry functions all being in .entry.text,
>>>>> which we could further sub-divide to split the EL0 and EL1 entry
>>>>> functions.
>>>>
>>>> Yes. I will check the entry functions. But I still think that we should
>>>> not rely on just one check. The additional checks will make it robust.
>>>> So, I suggest that the return address be checked first. If that passes,
>>>> then we can be reasonably sure that there are pt_regs. Then, check
>>>> the other things in pt_regs.
>>>
>>> What do you think this will catch?
>>
>> I am not sure that I have an exact example to mention here. But I will attempt
>> one. Let us say that a task has called arch_stack_walk() in the recent past.
>> The unwinder may have copied a stack frame onto some location in the stack
>> with one of the return addresses we check. Let us assume that there is some
>> stack corruption that makes a frame pointer point to that exact record. Now,
>> we will get a match on the return address on the next unwind.
> 
> I don't see how this is material to the pt_regs case, as either:
> 
> * When the unwinder considers this frame, it appears to be in the middle
>   of an EL1 entry function, and the unwinder must mark the unwinding as
>   unreliable regardless of the contents of any regs (so there's no need
>   to look at the regs).
> 
> * When the unwinder considers this frame, it does not appear to be in
>   the middle of an EL1 entry function, so the unwinder does not think
>   there are any regs to consider, and so we cannot detect this case.
> 
> ... unless I've misunderstood the example?
> 
> There's a general problem that it's possible to corrupt any portion of
> the chain to skip records, e.g.
> 
>   A -> B -> C -> D -> E -> F -> G -> H -> [final]
> 
> ... could get corrupted to:
> 
>   A -> B -> D -> H -> [final]
> 
> ... regardless of whether C/E/F/G had associated pt_regs. AFAICT there's
> no good way to catch this generally unless we have additional metadata
> to check the unwinding against.
> 
> The likelihood of this happening without triggering other checks is
> vanishingly low, and as we don't have a reliable mechanism for detecting
> this, I don't think it's worthwhile attempting to do so.
> 
> If and when we try to unwind across EL1 exception boundaries, the
> potential mismatch between the frame record and regs will be more
> significant, and I agree at that point thisd will need more thought.
> 
>> Pardon me if the example is somewhat crude. My point is that it is
>> highly unlikely but not impossible for the return address to be on the
>> stack and for the unwinder to get an unfortunate match.
> 
> I agree that this is possible in theory, but as above I don't think this
> is a practical concern.
> 

OK. What you say makes sense.

Thanks.

Madhavan
