Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8332315E
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 20:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhBWTXL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 14:23:11 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41214 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhBWTVb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 14:21:31 -0500
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 451ED20B6C40;
        Tue, 23 Feb 2021 11:20:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 451ED20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1614108050;
        bh=bgVREtbThCXyyNVzI6besUKkeZ3w63oXLPzE3PrY3pg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ro2SNAFV/9dYuQbu/CjgaupoR8BXXeFbt/T1IF29ETKMMSFV5PUCPjxTQxgWVvWky
         EEhrkZ+OpfQ3TrkVrT2gd4x1EKYGbYxTJBWpd01fbhyNYGXxQzmzZReTHR6aqxpBdw
         7QIGdAHiLRcLUOHBX0I4UoCLFvpcm3ZUhGKOpbDU=
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
 <20210223190240.GK5116@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <08e8e02c-8ef0-26bb-1d0d-7dda54b5fefd@linux.microsoft.com>
Date:   Tue, 23 Feb 2021 13:20:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210223190240.GK5116@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/23/21 1:02 PM, Mark Brown wrote:
> On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Unwinder changes
>> ================
> 
> This is making several different changes so should be split into a patch
> series - for example the change to terminate on a specific function
> pointer rather than NULL and the changes to the exception/interupt
> detection should be split.  Please see submitting-patches.rst for some
> discussion about how to split things up.  In general if you've got a
> changelog enumerating a number of different changes in a patch that's a
> warning sign that it might be good split things up.
> 

Will do.

> You should also copy the architecture maintainers (Catalin and Will) on
> any arch/arm64 submissions.
> 

Will do when I resubmit.

>> 	Unwinder return value
>> 	=====================
>>
>> 	Currently, the unwinder returns -EINVAL for stack trace termination
>> 	as well as stack trace error. Return -ENOENT for stack trace
>> 	termination and -EINVAL for error to disambiguate. This idea has
>> 	been borrowed from Mark Brown.
> 
> You could just include my patch for this in your series.
> 

OK.

>> Reliable stack trace function
>> =============================
>>
>> Implement arch_stack_walk_reliable(). This function walks the stack like
>> the existing stack trace functions with a couple of additional checks:
>>
>> 	Return address check
>> 	--------------------
>>
>> 	For each frame, check the return address to see if it is a
>> 	proper kernel text address. If not, return -EINVAL.
>>
>> 	Exception frame check
>> 	---------------------
>>
>> 	Check each frame to see if it is an EL1 exception frame. If it is,
>> 	return -EINVAL.
> 
> Again, this should be at least one separate patch.  How does this ensure
> that we don't have any issues with any of the various probe mechanisms?
> If there's no need to explicitly check anything that should be called
> out in the changelog.
> 

I am trying to do this in an incremental fashion. I have to study the probe
mechanisms a little bit more before I can come up with a solution. But
if you want to see that addressed in this patch set, I could do that.
It will take a little bit of time. That is all.

> Since all these changes are mixed up this is a fairly superficial
> review of the actual code.
> 

Understood. I will split things up and we can take it from there.

>> +static notrace struct pt_regs *get_frame_regs(struct task_struct *task,
>> +					      struct stackframe *frame)
>> +{
>> +	unsigned long stackframe, regs_start, regs_end;
>> +	struct stack_info info;
>> +
>> +	stackframe = frame->prev_fp;
>> +	if (!stackframe)
>> +		return NULL;
>> +
>> +	(void) on_accessible_stack(task, stackframe, &info);
> 
> Shouldn't we return NULL if we are not on an accessible stack?
> 

The prev_fp has already been checked by the unwinder in the previous
frame. That is why I don't check the return value. If that is acceptable,
I will add a comment.

>> +static notrace int update_frame(struct task_struct *task,
>> +				struct stackframe *frame)
> 
> This function really needs some documentation, the function is just
> called update_frame() which doesn't say what sort of updates it's
> supposed to do and most of the checks aren't explained, not all of them
> are super obvious.
> 

I will add the documentation as well as try think of a better name.

>> +{
>> +	unsigned long lsb = frame->fp & 0xf;
>> +	unsigned long fp = frame->fp & ~lsb;
>> +	unsigned long pc = frame->pc;
>> +	struct pt_regs *regs;
>> +
>> +	frame->exception_frame = false;
>> +
>> +	if (fp == (unsigned long) arm64_last_frame &&
>> +	    pc == (unsigned long) arm64_last_func)
>> +		return -ENOENT;
>> +
>> +	if (!lsb)
>> +		return 0;
>> +	if (lsb != 1)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * This looks like an EL1 exception frame.
> 
> For clarity it would be good to spell out the properties of an EL1
> exception frame.  It is not clear to me why we don't reference the frame
> type information the unwinder already records as part of these checks.
> 
> In general, especially for the bits specific to reliable stack trace, I
> think we want to err on the side of verbosity here so that it is crystal
> clear what all the checks are supposed to be doing and it's that much
> easier to tie everything through to the requirements document.

OK. I will improve the documentation.

Madhavan
