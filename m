Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CB13244AB
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 20:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhBXTex (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 14:34:53 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48998 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbhBXTew (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 14:34:52 -0500
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 121B720B6C40;
        Wed, 24 Feb 2021 11:34:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 121B720B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1614195250;
        bh=LCnleJ7I3FtvjkHqm7PYYtADtk9bSt509Ou3yQcfJK0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PPUCLhsYZvzXHL4PiGGDZM1YE3bvH4dCSCXPOK68RfEqUHCRY/IKYqydG9GEsLWaw
         Q5ukux9Hgy5pnDvJH0pAU0o1pGk7M4CdJ5IDmm6PyGSbRFHE5YfAd5NoH5x1Mdt+HE
         SRV2+vcOFV88na3O/XC0cKdoaY3W+UHkNTL11Gvc=
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
 <20210224121716.GE50741@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <4a96b31d-0d16-1f12-fa64-5fdae64cd2d1@linux.microsoft.com>
Date:   Wed, 24 Feb 2021 13:34:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224121716.GE50741@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/24/21 6:17 AM, Mark Rutland wrote:
> Hi Madhavan,
> 
> As Mark Brown says, I think this needs to be split into several
> patches. i have some comments on the general approach, but I'll save
> in-depth review until this has been split.
> 

OK.

> On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Unwinder changes
>> ================
>>
>> 	Termination
>> 	===========
>>
>> 	Currently, the unwinder terminates when both the FP (frame pointer)
>> 	and the PC (return address) of a frame are 0. But a frame could get
>> 	corrupted and zeroed. There needs to be a better check.
>>
>> 	The following special terminating frame and function have been
>> 	defined for this purpose:
>>
>> 	const u64    arm64_last_frame[2] __attribute__ ((aligned (16)));
>>
>> 	void arm64_last_func(void)
>> 	{
>> 	}
>>
>> 	So, set the FP to arm64_last_frame and the PC to arm64_last_func in
>> 	the bottom most frame.
> 
> My expectation was that we'd do this per-task, creating an empty frame
> record (i.e. with fp=NULL and lr=NULL) on the task's stack at the
> instant it was created, and chaining this into x29. That way the address
> is known (since it can be derived from the task), and the frame will
> also implicitly check that the callchain terminates on the task stack
> without loops. That also means that we can use it to detect the entry
> code going wrong (e.g. if the SP gets corrupted), since in that case the
> entry code would place the record at a different location.
> 

That is exactly what this is doing. arm64_last_frame[] is a marker frame
that contains fp=0 and pc=0.

>>
>> 	Exception/Interrupt detection
>> 	=============================
>>
>> 	An EL1 exception renders the stack trace unreliable as it can happen
>> 	anywhere including the frame pointer prolog and epilog. The
>> 	unwinder needs to be able to detect the exception on the stack.
>>
>> 	Currently, the EL1 exception handler sets up pt_regs on the stack
>> 	and chains pt_regs->stackframe with the other frames on the stack.
>> 	But, the unwinder does not know where this exception frame is in
>> 	the stack trace.
>>
>> 	Set the LSB of the exception frame FP to allow the unwinder to
>> 	detect the exception frame. When the unwinder detects the frame,
>> 	it needs to make sure that it is really an exception frame and
>> 	not the result of any stack corruption.
> 
> I'm not keen on messing with the encoding of the frame record as this
> will break external unwinders (e.g. using GDB on a kernel running under
> QEMU). I'd rather that we detected the exception boundary based on the
> LR, similar to what we did in commit:
> 

OK. I will take a look at the commit you mentioned.

>   7326749801396105 ("arm64: unwind: reference pt_regs via embedded stack frame")
> 
> ... I reckon once we've moved the last of the exception triage out to C
> this will be relatively simple, since all of the exception handlers will
> look like:
> 
> | SYM_CODE_START_LOCAL(elX_exception)
> | 	kernel_entry X
> | 	mov	x0, sp
> | 	bl	elX_exception_handler
> | 	kernel_exit X
> | SYM_CODE_END(elX_exception)
> 
> ... and so we just need to identify the set of elX_exception functions
> (which we'll never expect to take exceptions from directly). We could be
> strict and reject unwinding into arbitrary bits of the entry code (e.g.
> if we took an unexpected exception), and only permit unwinding to the
> BL.
> 
>> 	It can do this if the FP and PC are also recorded elsewhere in the
>> 	pt_regs for comparison. Currently, the FP is also stored in
>> 	regs->regs[29]. The PC is stored in regs->pc. However, regs->pc can
>> 	be changed by lower level functions.
>>
>> 	Create a new field, pt_regs->orig_pc, and record the return address
>> 	PC there. With this, the unwinder can validate the exception frame
>> 	and set a flag so that the caller of the unwinder can know when
>> 	an exception frame is encountered.
> 
> I don't understand the case you're trying to solve here. When is
> regs->pc changed in a way that's problematic?
> 

For instance, I used a test driver in which the driver calls a function
pointer which is NULL. The low level fault handler sends a signal to the
task. Looks like it changes regs->pc for this. When I dump the stack
from the low level handler, the comparison with regs->pc does not work.
But comparison with regs->orig_pc works.

>> 	Unwinder return value
>> 	=====================
>>
>> 	Currently, the unwinder returns -EINVAL for stack trace termination
>> 	as well as stack trace error. Return -ENOENT for stack trace
>> 	termination and -EINVAL for error to disambiguate. This idea has
>> 	been borrowed from Mark Brown.
> 
> IIRC Mark Brown already has a patch for this (and it could be queued on
> its own if it hasn't already been).
> 

I saw it. That is fine.

Thanks.

Madhavan
