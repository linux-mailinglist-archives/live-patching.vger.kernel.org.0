Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84E43CE53
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 18:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242932AbhJ0QLl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 12:11:41 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52424 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhJ0QLk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 12:11:40 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4CAA32034CB7;
        Wed, 27 Oct 2021 09:09:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CAA32034CB7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635350955;
        bh=lRMHS3oUIFOH6oRjnTIYOSwO1nqeQHqP48OJr6TyQNw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jIc1Q0dgolV8PNZzp++zlwsk6NJtUXvM+gU1c0C197ejfOYt/mtYJbmFQPS6F3VP4
         ICabiJl/ce4G7d9SkRT8BtopMxxidoXzDkCnfuS4hvWWroEwmzUALgSF3c4YIKo0GZ
         REF0bHAvgbi5Hd+mo34KG7t7UosLRePcBawMssfU=
Subject: Re: [PATCH v10 05/11] arm64: Make dump_stacktrace() use
 arch_stack_walk()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-6-madvenka@linux.microsoft.com>
 <20211025164925.GB2001@C02TD0UTHF1T.local>
 <20211026120516.GA34073@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a6991ee4-835d-f8b8-84a5-00755bbfe56e@linux.microsoft.com>
Date:   Wed, 27 Oct 2021 11:09:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211026120516.GA34073@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/26/21 7:05 AM, Mark Rutland wrote:
> On Mon, Oct 25, 2021 at 05:49:25PM +0100, Mark Rutland wrote:
>> From f3e66ca75aff3474355839f72d123276028204e1 Mon Sep 17 00:00:00 2001
>> From: Mark Rutland <mark.rutland@arm.com>
>> Date: Mon, 25 Oct 2021 13:23:11 +0100
>> Subject: [PATCH] arm64: ftrace: use HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
>>
>> When CONFIG_FUNCTION_GRAPH_TRACER is selected, and the function graph:
>> tracer is in use, unwind_frame() may erroneously asscociate a traced
>> function with an incorrect return address. This can happen when starting
>> an unwind from a pt_regs, or when unwinding across an exception
>> boundary.
>>
>> The underlying problem is that ftrace_graph_get_ret_stack() takes an
>> index offset from the most recent entry added to the fgraph return
>> stack. We start an unwind at offset 0, and increment the offset each
>> time we encounter `return_to_handler`, which indicates a rewritten
>> return address. This is broken in two cases:
>>
>> * Between creating a pt_regs and starting the unwind, function calls may
>>   place entries on the stack, leaving an abitrary offset which we can
>>   only determine by performing a full unwind from the caller of the
>>   unwind code. While this initial unwind is open-coded in
>>   dump_backtrace(), this is not performed for other unwinders such as
>>   perf_callchain_kernel().
>>
>> * When unwinding across an exception boundary (whether continuing an
>>   unwind or starting a new unwind from regs), we always consume the LR
>>   of the interrupted context, though this may not have been live at the
>>   time of the exception. Where the LR was not live but happened to
>>   contain `return_to_handler`, we'll recover an address from the graph
>>   return stack and increment the current offset, leaving subsequent
>>   entries off-by-one.
>>
>>   Where the LR was not live and did not contain `return_to_handler`, we
>>   will still report an erroneous address, but subsequent entries will be
>>   unaffected.
> 
> It turns out I had this backwards, and we currently always *skip* the LR
> when unwinding across regs, because:
> 
> * The entry assembly creates a synthetic frame record with the original
>   FP and the ELR_EL1 value (i.e. the PC at the point of the exception),
>   skipping the LR.
> 
> * In arch_stack_walk() we start the walk from regs->pc, and continue
>   with the frame record, skipping the LR.
> 
> * In the existing dump_backtrace, we skip until we hit a frame record
>   whose FP value matches the FP in the regs (i.e. the synthetic frame
>   record created by the entry assembly). That'll dump the ELR_EL1 value,
>   then continue to the next frame record, skipping the LR.
> 
> So case two is bogus, and only case one can happen today. This cleanup
> shouldn't trigger the WARN_ON_ONCE() in unwind_frame(), and we can fix
> the missing LR entry in a subsequent cleanup.
> 

OK. Thanks.

Madhavan
