Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BE3346637
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCWRXx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 13:23:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59598 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhCWRXg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 13:23:36 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9AA3420B5680;
        Tue, 23 Mar 2021 10:23:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9AA3420B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616520216;
        bh=PM8Qdk/WCeDqXgn2AoeUQIp08lqJPb7gu6b/rTGuz04=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kfMcJ+ODNE5qV9jvFnYJ3dJ/ETBOczzAvacZidoHoy+GVzwWx1JZJBiJ9WbzM0W30
         hvxQh5nxs5vzlUEKkbgXeAuaX6JWGY2q8v9wHxWbLHk4zK4kFQn1WtcblT+a0vnxJU
         CfESZ5owUbNogh0XCVbRZBzVLOXjNQl4LrFY8HV8=
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack
 trace unreliable
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
 <20210323170236.GF98545@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bc450f09-1881-9a9c-bfbc-5bb31c01d8ce@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 12:23:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323170236.GF98545@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 12:02 PM, Mark Rutland wrote:
> On Tue, Mar 23, 2021 at 11:20:44AM -0500, Madhavan T. Venkataraman wrote:
>> On 3/23/21 10:26 AM, Madhavan T. Venkataraman wrote:
>>> On 3/23/21 9:57 AM, Mark Rutland wrote:
>>>> On Tue, Mar 23, 2021 at 09:15:36AM -0500, Madhavan T. Venkataraman wrote:
>>> So, my next question is - can we define a practical limit for the
>>> nesting so that any nesting beyond that is fatal? The reason I ask
>>> is - if there is a max, then we can allocate an array of stack
>>> frames out of band for the special frames so they are not part of
>>> the stack and will not likely get corrupted.
>>>
>>> Also, we don't have to do any special detection. If the number of
>>> out of band frames used is one or more then we have exceptions and
>>> the stack trace is unreliable.
>>
>> Alternatively, if we can just increment a counter in the task
>> structure when an exception is entered and decrement it when an
>> exception returns, that counter will tell us that the stack trace is
>> unreliable.
> 
> As I noted earlier, we must treat *any* EL1 exception boundary needs to
> be treated as unreliable for unwinding, and per my other comments w.r.t.
> corrupting the call chain I don't think we need additional protection on
> exception boundaries specifically.
> 
>> Is this feasible?
>>
>> I think I have enough for v3 at this point. If you think that the
>> counter idea is OK, I can implement it in v3. Once you confirm, I will
>> start working on v3.
> 
> Currently, I don't see a compelling reason to need this, and would
> prefer to avoid it.
> 

I think that I did a bad job of explaining what I wanted to do. It is not
for any additional protection at all.

So, let us say we create a field in the task structure:

	u64		unreliable_stack;

Whenever an EL1 exception is entered or FTRACE is entered and pt_regs get
set up and pt_regs->stackframe gets chained, increment unreliable_stack.
On exiting the above, decrement unreliable_stack.

In arch_stack_walk_reliable(), simply do this check upfront:

	if (task->unreliable_stack)
		return -EINVAL;

This way, the function does not even bother unwinding the stack to find
exception frames or checking for different return addresses or anything.
We also don't have to worry about code being reorganized, functions
being renamed, etc. It also may help in debugging to know if a task is
experiencing an exception and the level of nesting, etc.

> More generally, could we please break this work into smaller steps? I
> reckon we can break this down into the following chunks:
> 
> 1. Add the explicit final frame and associated handling. I suspect that
>    this is complicated enough on its own to be an independent series,
>    and it's something that we can merge without all the bits and pieces
>    necessary for truly reliable stacktracing.
> 

OK. I can do that.

> 2. Figure out how we must handle kprobes and ftrace. That probably means
>    rejecting unwinds from specific places, but we might also want to
>    adjust the trampolines if that makes this easier.
> 

I think I am already doing all the checks except the one you mentioned
earlier. Yes, I can do this separately.

> 3. Figure out exception boundary handling. I'm currently working to
>    simplify the entry assembly down to a uniform set of stubs, and I'd
>    prefer to get that sorted before we teach the unwinder about
>    exception boundaries, as it'll be significantly simpler to reason
>    about and won't end up clashing with the rework.
> 

So, here is where I still have a question. Is it necessary for the unwinder
to know the exception boundaries? Is it not enough if it knows if there are
exceptions present? For instance, using something like num_special_frames
I suggested above?

Thanks,

Madhavan
