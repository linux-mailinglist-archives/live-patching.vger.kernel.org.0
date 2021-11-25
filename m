Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D84945DF4E
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 18:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbhKYREU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 12:04:20 -0500
Received: from linux.microsoft.com ([13.77.154.182]:40454 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242492AbhKYRCk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 12:02:40 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4E30520D5F07;
        Thu, 25 Nov 2021 08:59:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4E30520D5F07
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637859569;
        bh=TK9fBWTDWdM94LF77A1vdyDGRvknSDniYv7TXuc127c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Rhn5EK5t0M7KWzHGjKEdMVlmhmTlQ0uPmUZUBO9pCEQ2gXLPHjx9BJWvQQcDhF/tN
         8SolBnYz2crDiWXl1KiqgxcerWl/YaBQ2LUebIXsqaHUS0EHxhvJM47yssPlBZ5fs/
         jc5ljfGQOtpqwjJwZDFEHdJq505EKEo9TFjjGvgw=
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <704d73f6-30e2-08e0-3a5c-d3639d8b2da1@linux.microsoft.com>
Date:   Thu, 25 Nov 2021 10:59:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZ+kLPT+h6ZGw20p@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 11/25/21 8:56 AM, Mark Brown wrote:
> On Tue, Nov 23, 2021 at 01:37:22PM -0600, madvenka@linux.microsoft.com wrote:
> 
>> Introduce arch_stack_walk_reliable() for ARM64. This works like
>> arch_stack_walk() except that it returns -EINVAL if the stack trace is not
>> reliable.
> 
>> Until all the reliability checks are in place, arch_stack_walk_reliable()
>> may not be used by livepatch. But it may be used by debug and test code.
> 
> Probably also worth noting that this doesn't select
> HAVE_RELIABLE_STACKTRACE which is what any actual users are going to use
> to identify if the architecture has the feature.  I would have been
> tempted to add arch_stack_walk() as a separate patch but equally having
> the user code there (even if it itself can't yet be used...) helps with
> reviewing the actual unwinder so I don't mind.
> 

I did not select HAVE_RELIABLE_STACKTRACE just in case we think that some
more reliability checks need to be added. But if reviewers agree
that this patch series contains all the reliability checks we need, I
will add a patch to select HAVE_RELIABLE_STACKTRACE to the series.

>> +static void unwind_check_reliability(struct task_struct *task,
>> +				     struct stackframe *frame)
>> +{
>> +	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
>> +		/* Final frame; no more unwind, no need to check reliability */
>> +		return;
>> +	}
> 
> If the unwinder carries on for some reason (the code for that is
> elsewhere and may be updated separately...) then this will start
> checking again.  I'm not sure if this is a *problem* as such but the
> thing about this being the final frame coupled with not actually
> explicitly stopping the unwind here makes me think this should at least
> be clearer, the comment begs the question about what happens if
> something decides it is not in fact the final frame.
> 

I can address this by adding an explicit comment to that effect.
For example, define a separate function to check for the final frame:

/*
 * Check if this is the final frame. Unwind must stop at the final
 * frame.
 */
static inline bool unwind_is_final_frame(struct task_struct *task,
                                         struct stackframe *frame)
{
	return frame->fp == (unsigned long)task_pt_regs(task)->stackframe;
}

Then, use this function in unwind_check_reliability() and unwind_continue().

Is this acceptable?

Madhavan
