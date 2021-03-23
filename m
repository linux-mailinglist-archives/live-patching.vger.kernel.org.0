Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493043464D9
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 17:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhCWQU7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 12:20:59 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51212 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbhCWQUq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 12:20:46 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 89EF120998E9;
        Tue, 23 Mar 2021 09:20:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89EF120998E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616516446;
        bh=9lkpxE550xTwlq3tgLOuGqX4K8vkcDSwvEuMDKec0lg=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=nlrbMBrlkzQjaCHqAXXY6ZUeIJ7EeMzTQvHILIptaiXzwFf+vwg2Hv2qKpAX2no8e
         UIPBqDeiH321Itu9YwdNrMU/0YX8rua1Pw+kWgiAQjuow0sHUFRcLq+VPtffnE+kfO
         Hs1HZuiC6raE+Fgbm7DwF3VgnTL0xX8c63+XP0HE=
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack
 trace unreliable
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
Message-ID: <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 11:20:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 10:26 AM, Madhavan T. Venkataraman wrote:
> 
> 
> On 3/23/21 9:57 AM, Mark Rutland wrote:
>> On Tue, Mar 23, 2021 at 09:15:36AM -0500, Madhavan T. Venkataraman wrote:
>>> Hi Mark,
>>>
>>> I have a general question. When exceptions are nested, how does it work? Let us consider 2 cases:
>>>
>>> 1. Exception in a page fault handler itself. In this case, I guess one more pt_regs will get
>>>    established in the task stack for the second exception.
>>
>> Generally (ignoring SDEI and stack overflow exceptions) the regs will be
>> placed on the stack that was in use when the exception occurred, e.g.
>>
>>   task -> task
>>   irq -> irq
>>   overflow -> overflow
>>
>> For SDEI and stack overflow, we'll place the regs on the relevant SDEI
>> or overflow stack, e.g.
>>
>>   task -> overflow
>>   irq -> overflow
>>
>>   task -> sdei
>>   irq -> sdei
>>
>> I tried to explain the nesting rules in:
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kernel/stacktrace.c?h=v5.11#n59
>>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64/kernel/stacktrace.c?h=v5.11&id=592700f094be229b5c9cc1192d5cea46eb4c7afc
>>
>>> 2. Exception in an interrupt handler. Here the interrupt handler is running on the IRQ stack.
>>>    Will the pt_regs get created on the IRQ stack?
>>
>> For an interrupt the regs will be placed on the stack that was in use
>> when the interrupt was taken. The kernel switches to the IRQ stack
>> *after* stacking the registers. e.g.
>>
>>   task -> task // subsequently switches to IRQ stack
>>   irq -> irq
>>
>>> Also, is there a maximum nesting for exceptions?
>>
>> In practice, yes, but the specific number isn't a constant, so in the
>> unwind code we have to act as if there is no limit other than stack
>> sizing.
>>
>> We try to prevent cerain exceptions from nesting (e.g. debug exceptions
>> cannot nest), but there are still several level sof nesting, and some
>> exceptions which can be nested safely (like faults). For example, it's
>> possible to have a chain:
>>
>>  syscall -> fault -> interrupt -> fault -> pNMI -> fault -> SError -> fault -> watchpoint -> fault -> overflow -> fault -> BRK
>>
>> ... and potentially longer than that.
>>
>> The practical limit is the size of all the stacks, and the unwinder's 
>> stack monotonicity checks ensure that an unwind will terminate.
>>
> 
> Thanks for explaining the nesting. It is now clear to me.
> 
> So, my next question is - can we define a practical limit for the nesting so that any nesting beyond that
> is fatal? The reason I ask is - if there is a max, then we can allocate an array of stack frames out of
> band for the special frames so they are not part of the stack and will not likely get corrupted.
> 
> Also, we don't have to do any special detection. If the number of out of band frames used is one or more
> then we have exceptions and the stack trace is unreliable.
> 

Alternatively, if we can just increment a counter in the task structure when an exception is entered
and decrement it when an exception returns, that counter will tell us that the stack trace is
unreliable.

Is this feasible?

I think I have enough for v3 at this point. If you think that the counter idea is OK, I can
implement it in v3. Once you confirm, I will start working on v3.

Thanks for all the input.

Madhavan
