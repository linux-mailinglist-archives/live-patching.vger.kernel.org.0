Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91B235A899
	for <lists+live-patching@lfdr.de>; Sat, 10 Apr 2021 00:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhDIWGO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 18:06:14 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60370 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbhDIWGO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 18:06:14 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id EC01320B5680;
        Fri,  9 Apr 2021 15:05:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC01320B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618005960;
        bh=spfLG4CRI0dn3PRsgWrh4XhD+thcZm6msznf8nIF6Og=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Mm1eTLEXTUFLM4e69WKNE111YShX5TdHZPm+Enoy1FHmGSpVkWABvUKqaVnOyTSTk
         Wxt06yfbx2wiFLrIFb5jlBYJmWAFGbYnnppmj/1aR8Mm4p205+H1oqyAcFysECFfEK
         bC1aqnlcp5QsglyVNZXSadpTW6rUj/l3RYZ5j37A=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 17:05:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409213741.kqmwyajoppuqrkge@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/9/21 4:37 PM, Josh Poimboeuf wrote:
> On Fri, Apr 09, 2021 at 01:09:09PM +0100, Mark Rutland wrote:
>> On Mon, Apr 05, 2021 at 03:43:09PM -0500, madvenka@linux.microsoft.com wrote:
>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>
>>> There are a number of places in kernel code where the stack trace is not
>>> reliable. Enhance the unwinder to check for those cases and mark the
>>> stack trace as unreliable. Once all of the checks are in place, the unwinder
>>> can provide a reliable stack trace. But before this can be used for livepatch,
>>> some other entity needs to guarantee that the frame pointers are all set up
>>> correctly in kernel functions. objtool is currently being worked on to
>>> fill that gap.
>>>
>>> Except for the return address check, all the other checks involve checking
>>> the return PC of every frame against certain kernel functions. To do this,
>>> implement some infrastructure code:
>>>
>>> 	- Define a special_functions[] array and populate the array with
>>> 	  the special functions
>>
>> I'm not too keen on having to manually collate this within the unwinder,
>> as it's very painful from a maintenance perspective.
> 
> Agreed.
> 
>> I'd much rather we could associate this information with the
>> implementations of these functions, so that they're more likely to
>> stay in sync.
>>
>> Further, I believe all the special cases are assembly functions, and
>> most of those are already in special sections to begin with. I reckon
>> it'd be simpler and more robust to reject unwinding based on the
>> section. If we need to unwind across specific functions in those
>> sections, we could opt-in with some metadata. So e.g. we could reject
>> all functions in ".entry.text", special casing the EL0 entry functions
>> if necessary.
> 
> Couldn't this also end up being somewhat fragile?  Saying "certain
> sections are deemed unreliable" isn't necessarily obvious to somebody
> who doesn't already know about it, and it could be overlooked or
> forgotten over time.  And there's no way to enforce it stays that way.
> 

Good point!

> FWIW, over the years we've had zero issues with encoding the frame
> pointer on x86.  After you save pt_regs, you encode the frame pointer to
> point to it.  Ideally in the same macro so it's hard to overlook.
> 

I had the same opinion. In fact, in my encoding scheme, I have additional
checks to make absolutely sure that it is a true encoding and not stack
corruption. The chances of all of those values accidentally matching are,
well, null.

> If you're concerned about debuggers getting confused by the encoding -
> which debuggers specifically?  In my experience, if vmlinux has
> debuginfo, gdb and most other debuggers will use DWARF (which is already
> broken in asm code) and completely ignore frame pointers.
> 

Yes. I checked gdb actually. It did not show a problem.

>> I think there's a lot more code that we cannot unwind, e.g. KVM
>> exception code, or almost anything marked with SYM_CODE_END().
> 
> Just a reminder that livepatch only unwinds blocked tasks (plus the
> 'current' task which calls into livepatch).  So practically speaking, it
> doesn't matter whether the 'unreliable' detection has full coverage.
> The only exceptions which really matter are those which end up calling
> schedule(), e.g. preemption or page faults.
> 
> Being able to consistently detect *all* possible unreliable paths would
> be nice in theory, but it's unnecessary and may not be worth the extra
> complexity.
> 

You do have a point. I tried to think of arch_stack_walk_reliable() as
something that should be implemented independent of livepatching. But
I could not really come up with a single example of where else it would
really be useful.

So, if we assume that the reliable stack trace is solely for the purpose
of livepatching, I agree with your earlier comments as well.

Thanks!

Madhavan
