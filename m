Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B281345FB6
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 14:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhCWNcK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 09:32:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58040 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhCWNbw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 09:31:52 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 904DB20B5680;
        Tue, 23 Mar 2021 06:31:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 904DB20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616506312;
        bh=zTgAWOmTDytEWgg0S9UVRUvjjshGWZHqXHkFUdI/tlc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fJzyyAtxq0/rAGu5iEb09kI1bPZFJsrn28F23WUPI6jLZjxPACknquImACEHVmn36
         fNbslhEl4N8SaUdnttXIQ90bXftKW8G3dlWXhKRYVD72IiK2QZfZVV/NIlUbT42lYC
         hyCbpaAsVOx+v/YWtJiMQiT+hUdk19mObgYVMXt4=
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f5dd48d3-c0ea-a719-c10d-83e62db3e7c0@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 08:31:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323130425.GA98545@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 8:04 AM, Mark Rutland wrote:
> On Tue, Mar 23, 2021 at 07:46:10AM -0500, Madhavan T. Venkataraman wrote:
>> On 3/23/21 5:42 AM, Mark Rutland wrote:
>>> On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
>>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>
>>>> EL1 exceptions can happen on any instruction including instructions in
>>>> the frame pointer prolog or epilog. Depending on where exactly they happen,
>>>> they could render the stack trace unreliable.
>>>>
>>>> If an EL1 exception frame is found on the stack, mark the stack trace as
>>>> unreliable.
>>>>
>>>> Now, the EL1 exception frame is not at any well-known offset on the stack.
>>>> It can be anywhere on the stack. In order to properly detect an EL1
>>>> exception frame the following checks must be done:
>>>>
>>>> 	- The frame type must be EL1_FRAME.
>>>>
>>>> 	- When the register state is saved in the EL1 pt_regs, the frame
>>>> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
>>>> 	  is saved in pt_regs->pc. These must match with the current
>>>> 	  frame.
>>>
>>> Before you can do this, you need to reliably identify that you have a
>>> pt_regs on the stack, but this patch uses a heuristic, which is not
>>> reliable.
>>>
>>> However, instead you can identify whether you're trying to unwind
>>> through one of the EL1 entry functions, which tells you the same thing
>>> without even having to look at the pt_regs.
>>>
>>> We can do that based on the entry functions all being in .entry.text,
>>> which we could further sub-divide to split the EL0 and EL1 entry
>>> functions.
>>
>> Yes. I will check the entry functions. But I still think that we should
>> not rely on just one check. The additional checks will make it robust.
>> So, I suggest that the return address be checked first. If that passes,
>> then we can be reasonably sure that there are pt_regs. Then, check
>> the other things in pt_regs.
> 
> What do you think this will catch?
> 

I am not sure that I have an exact example to mention here. But I will attempt
one. Let us say that a task has called arch_stack_walk() in the recent past.
The unwinder may have copied a stack frame onto some location in the stack
with one of the return addresses we check. Let us assume that there is some
stack corruption that makes a frame pointer point to that exact record. Now,
we will get a match on the return address on the next unwind.

Pardon me if the example is somewhat crude. My point is that it is highly unlikely
but not impossible for the return address to be on the stack and for the unwinder to
get an unfortunate match.

> The only way to correctly identify whether or not we have a pt_regs is
> to check whether we're in specific portions of the EL1 entry assembly
> where the regs exist. However, as any EL1<->EL1 transition cannot be
> safely unwound, we'd mark any trace going through the EL1 entry assembly
> as unreliable.
> 
> Given that, I don't think it's useful to check the regs, and I'd prefer
> to avoid the subtlteties involved in attempting to do so.
> 

I agree that the return address check is a good check. I would like to add
extra checks to be absolutely sure.

> [...]
> 
>>>> +static void check_if_reliable(unsigned long fp, struct stackframe *frame,
>>>> +			      struct stack_info *info)
>>>> +{
>>>> +	struct pt_regs *regs;
>>>> +	unsigned long regs_start, regs_end;
>>>> +
>>>> +	/*
>>>> +	 * If the stack trace has already been marked unreliable, just
>>>> +	 * return.
>>>> +	 */
>>>> +	if (!frame->reliable)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * Assume that this is an intermediate marker frame inside a pt_regs
>>>> +	 * structure created on the stack and get the pt_regs pointer. Other
>>>> +	 * checks will be done below to make sure that this is a marker
>>>> +	 * frame.
>>>> +	 */
>>>
>>> Sorry, but NAK to this approach specifically. This isn't reliable (since
>>> it can be influenced by arbitrary data on the stack), and it's far more
>>> complicated than identifying the entry functions specifically.
>>
>> As I mentioned above, I agree that we should check the return address. But
>> just as a precaution, I think we should double check the pt_regs.
>>
>> Is that OK with you? It does not take away anything or increase the risk in
>> anyway. I think it makes it more robust.
> 
> As above, I think that the work necessary to correctly access the regs
> means that it's not helpful to check the regs themselves. If you have
> something in mind where checking the regs is helpful I'm happy to
> consider that, but my general preference would be to stay away from the
> regs for now.
> 

I have mentioned a possibility above. Please take a look and let me know.

Thanks.

Madhavan
