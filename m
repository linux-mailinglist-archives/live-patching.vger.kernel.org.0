Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF18346ABA
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 22:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhCWVFO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 17:05:14 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59476 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhCWVEs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 17:04:48 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id E873920B5680;
        Tue, 23 Mar 2021 14:04:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E873920B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616533488;
        bh=OXR8yOga0/h10z0/w8+nlFHgpqAPODs3PDqE1WL4q1A=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=BMkCtQ1v6P65n3C3S1DgHgChYKUAfW4cYWty31O2g0bDdyAg4gD9pHKXgc3W/qPPR
         whSduVPY89bFxr43JQOEoIh2zIZ3a+YOgBV4hfOe6wRECTEhAz5BZoGFHQBWRBIKu4
         GlHbadEgBZjgG9iBRvnhP3sweuceSHCPBimchckk=
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack
 trace unreliable
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
 <20210323170236.GF98545@C02TD0UTHF1T.local>
 <bc450f09-1881-9a9c-bfbc-5bb31c01d8ce@linux.microsoft.com>
 <20210323183053.GH98545@C02TD0UTHF1T.local>
 <8aa50127-3f00-818d-d58c-4b3ff7235c74@linux.microsoft.com>
Message-ID: <5f32abc2-5759-5fb9-a626-cce962ac275a@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 16:04:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8aa50127-3f00-818d-d58c-4b3ff7235c74@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks for all the input - Mark Rutland and Mark Brown.

I will send out the stack termination patch next. Since I am splitting
the original series into 3 separate series, I will change the titles and
start with version 1 in each case, if there is no objection.

Again, Thanks.

Madhavan

On 3/23/21 3:24 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 3/23/21 1:30 PM, Mark Rutland wrote:
>> On Tue, Mar 23, 2021 at 12:23:34PM -0500, Madhavan T. Venkataraman wrote:
>>> On 3/23/21 12:02 PM, Mark Rutland wrote:
>>
>> [...]
>>
>>> I think that I did a bad job of explaining what I wanted to do. It is not
>>> for any additional protection at all.
>>>
>>> So, let us say we create a field in the task structure:
>>>
>>> 	u64		unreliable_stack;
>>>
>>> Whenever an EL1 exception is entered or FTRACE is entered and pt_regs get
>>> set up and pt_regs->stackframe gets chained, increment unreliable_stack.
>>> On exiting the above, decrement unreliable_stack.
>>>
>>> In arch_stack_walk_reliable(), simply do this check upfront:
>>>
>>> 	if (task->unreliable_stack)
>>> 		return -EINVAL;
>>>
>>> This way, the function does not even bother unwinding the stack to find
>>> exception frames or checking for different return addresses or anything.
>>> We also don't have to worry about code being reorganized, functions
>>> being renamed, etc. It also may help in debugging to know if a task is
>>> experiencing an exception and the level of nesting, etc.
>>
>> As in my other reply, since this is an optimization that is not
>> necessary for functional correctness, I would prefer to avoid this for
>> now. We can reconsider that in future if we encounter performance
>> problems.
>>
>> Even with this there will be cases where we have to identify
>> non-unwindable functions explicitly (e.g. the patchable-function-entry
>> trampolines, where the real return address is in x9), and I'd prefer
>> that we use one mechanism consistently.
>>
>> I suspect that in the future we'll need to unwind across exception
>> boundaries using metadata, and we can treat the non-unwindable metadata
>> in the same way.
>>
>> [...]
>>
>>>> 3. Figure out exception boundary handling. I'm currently working to
>>>>    simplify the entry assembly down to a uniform set of stubs, and I'd
>>>>    prefer to get that sorted before we teach the unwinder about
>>>>    exception boundaries, as it'll be significantly simpler to reason
>>>>    about and won't end up clashing with the rework.
>>>
>>> So, here is where I still have a question. Is it necessary for the unwinder
>>> to know the exception boundaries? Is it not enough if it knows if there are
>>> exceptions present? For instance, using something like num_special_frames
>>> I suggested above?
>>
>> I agree that it would be legitimate to bail out early if we knew there
>> was going to be an exception somewhere in the trace. Regardless, I think
>> it's simpler overall to identify non-unwindability during the trace, and
>> doing that during the trace aligns more closely with the structure that
>> we'll need to permit unwinding across these boundaries in future, so I'd
>> prefer we do that rather than trying to optimize for early returns
>> today.
>>
> 
> OK. Fair enough.
> 
> Thanks.
> 
> Madhavan
> 
