Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEFE45F2D7
	for <lists+live-patching@lfdr.de>; Fri, 26 Nov 2021 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhKZR3C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Nov 2021 12:29:02 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46462 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhKZR1C (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Nov 2021 12:27:02 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 38CFF20DDB25;
        Fri, 26 Nov 2021 09:23:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 38CFF20DDB25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637947428;
        bh=Bx3d3zMNN9opMfI8ccUCld6l8vmlXB9FpQqjEIZCNGQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YMzn+Y2fMDQGBTbGr8MpBVnYtUAEgudxg+aBvzJajQ74b9fCe/vLrFHE6C7W0QeKe
         h8xsykLKf2MS5s4hjuFDBD6WO5Rcai1StFRl0Hxhu1PwTATGmER4146uFqKBSpz3y7
         FtRji+hNiiyO0WRvCLWv03U5oDbLjl1xiFUFPP+Q=
Subject: Re: [PATCH v11 4/5] arm64: Introduce stack trace reliability checks
 in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-5-madvenka@linux.microsoft.com>
 <YZ+kLPT+h6ZGw20p@sirena.org.uk>
 <704d73f6-30e2-08e0-3a5c-d3639d8b2da1@linux.microsoft.com>
 <YaDhThxyGhCTkJx9@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <1529ea6e-f4dd-b821-a2aa-0d6ff46cd691@linux.microsoft.com>
Date:   Fri, 26 Nov 2021 11:23:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaDhThxyGhCTkJx9@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 11/26/21 7:29 AM, Mark Brown wrote:
> On Thu, Nov 25, 2021 at 10:59:27AM -0600, Madhavan T. Venkataraman wrote:
>> On 11/25/21 8:56 AM, Mark Brown wrote:
>>> On Tue, Nov 23, 2021 at 01:37:22PM -0600, madvenka@linux.microsoft.com wrote:
> 
>>> Probably also worth noting that this doesn't select
>>> HAVE_RELIABLE_STACKTRACE which is what any actual users are going to use
>>> to identify if the architecture has the feature.  I would have been
>>> tempted to add arch_stack_walk() as a separate patch but equally having
>>> the user code there (even if it itself can't yet be used...) helps with
>>> reviewing the actual unwinder so I don't mind.
> 
>> I did not select HAVE_RELIABLE_STACKTRACE just in case we think that some
>> more reliability checks need to be added. But if reviewers agree
>> that this patch series contains all the reliability checks we need, I
>> will add a patch to select HAVE_RELIABLE_STACKTRACE to the series.
> 
> I agree that more checks probably need to be added, might be worth
> throwing that patch into the end of the series though to provide a place
> to discuss what exactly we need.  My main thought here was that it's
> worth explicitly highlighting in this change that the Kconfig bit isn't
> glued up here so reviewers notice that's what's happening.
> 

OK. I will add the patch to the next version.

>>>> +static void unwind_check_reliability(struct task_struct *task,
>>>> +				     struct stackframe *frame)
>>>> +{
>>>> +	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
>>>> +		/* Final frame; no more unwind, no need to check reliability */
>>>> +		return;
>>>> +	}
> 
>>> If the unwinder carries on for some reason (the code for that is
>>> elsewhere and may be updated separately...) then this will start
>>> checking again.  I'm not sure if this is a *problem* as such but the
>>> thing about this being the final frame coupled with not actually
>>> explicitly stopping the unwind here makes me think this should at least
>>> be clearer, the comment begs the question about what happens if
>>> something decides it is not in fact the final frame.
> 
>> I can address this by adding an explicit comment to that effect.
>> For example, define a separate function to check for the final frame:
> 
>> /*
>>  * Check if this is the final frame. Unwind must stop at the final
>>  * frame.
>>  */
>> static inline bool unwind_is_final_frame(struct task_struct *task,
>>                                          struct stackframe *frame)
>> {
>> 	return frame->fp == (unsigned long)task_pt_regs(task)->stackframe;
>> }
> 
>> Then, use this function in unwind_check_reliability() and unwind_continue().
> 
>> Is this acceptable?
> 
> Yes, I think that should address the issue - I'd have to see it in
> context to be sure but it does make it clear that the same check is
> being done which was the main thing.
> 

OK. I will make the above changes in the next version.

Thanks.

Madhavan
