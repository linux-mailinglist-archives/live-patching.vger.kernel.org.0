Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAA38CE52
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 21:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbhEUTnW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 15:43:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48848 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhEUTnV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 15:43:21 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 81D2120B7188;
        Fri, 21 May 2021 12:41:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81D2120B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621626118;
        bh=sVvcxbQSfAemZf/h/BWHu58ipxMHsNFFKvAp7FMao3I=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NI/hYFDEvvsCn23V5INEa9b8dTn2BppIDjflkBxVCslto7/I7DbLEs2m9XN5og4yC
         oHP5is8Jke0hB6M2MISMT2cjSTuef18UEjo+FwH+/YQU1DLlSOTA032lcn4cZ4uoBC
         FBpmEg7f1Xy2eFtvPKyJiYl6l5sDLEOC0CYv3TPg=
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, mark.rutland@arm.com,
        ardb@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
 <20210521184817.envdg232b2aeyprt@treble>
 <74d12457-7590-bca2-d1ce-5ff82d7ab0d8@linux.microsoft.com>
 <20210521191140.4aezpvm2kruztufi@treble>
 <20210521191608.f24sldzhpg3hyq32@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bf3a5289-8199-b665-0327-ed8240dd7827@linux.microsoft.com>
Date:   Fri, 21 May 2021 14:41:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521191608.f24sldzhpg3hyq32@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 2:16 PM, Josh Poimboeuf wrote:
> On Fri, May 21, 2021 at 02:11:45PM -0500, Josh Poimboeuf wrote:
>> On Fri, May 21, 2021 at 01:59:16PM -0500, Madhavan T. Venkataraman wrote:
>>>
>>>
>>> On 5/21/21 1:48 PM, Josh Poimboeuf wrote:
>>>> On Fri, May 21, 2021 at 06:53:18PM +0100, Mark Brown wrote:
>>>>> On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
>>>>>> On 5/21/21 12:42 PM, Mark Brown wrote:
>>>>>
>>>>>>> Like I say we may come up with some use for the flag in error cases in
>>>>>>> future so I'm not opposed to keeping the accounting there.
>>>>>
>>>>>> So, should I leave it the way it is now? Or should I not set reliable = false
>>>>>> for errors? Which one do you prefer?
>>>>>
>>>>>> Josh,
>>>>>
>>>>>> Are you OK with not flagging reliable = false for errors in unwind_frame()?
>>>>>
>>>>> I think it's fine to leave it as it is.
>>>>
>>>> Either way works for me, but if you remove those 'reliable = false'
>>>> statements for stack corruption then, IIRC, the caller would still have
>>>> some confusion between the end of stack error (-ENOENT) and the other
>>>> errors (-EINVAL).
>>>>
>>>
>>> I will leave it the way it is. That is, I will do reliable = false on errors
>>> like you suggested.
>>>
>>>> So the caller would have to know that -ENOENT really means success.
>>>> Which, to me, seems kind of flaky.
>>>>
>>>
>>> Actually, that is why -ENOENT was introduced - to indicate successful
>>> stack trace termination. A return value of 0 is for continuing with
>>> the stack trace. A non-zero value is for terminating the stack trace.
>>>
>>> So, either we return a positive value (say 1) to indicate successful
>>> termination. Or, we return -ENOENT to say no more stack frames left.
>>> I guess -ENOENT was chosen.
>>
>> I see.  So it's a tri-state return value, and frame->reliable is
>> intended to be a private interface not checked by the callers.
> 
> Or is frame->reliable supposed to be checked after all?  Looking at the
> code again, I'm not sure.
> 
> Either way it would be good to document the interface more clearly in a
> comment above the function.
> 

So, arch_stack_walk_reliable() would do this:

	start_backtrace(frame);

	while (...) {
		if (!frame->reliable)
			return error;

		consume_entry(...);

		ret = unwind_frame(...);

		if (ret)
			break;
	}

	if (ret == -ENOENT)
		return success;
	return error;


Something like that.

I will add a comment about all of this in the unwinder.

Thanks!

Madhavan



