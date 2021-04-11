Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35835B669
	for <lists+live-patching@lfdr.de>; Sun, 11 Apr 2021 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbhDKRye (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 11 Apr 2021 13:54:34 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59662 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKRyd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 11 Apr 2021 13:54:33 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3744A20BCFB3;
        Sun, 11 Apr 2021 10:54:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3744A20BCFB3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618163656;
        bh=MLtBefkHmjSmdpfbhYpvt4YGwNCxEie/Zvb95gWk5ZE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fujDV8OeM1T22IT97/wOcNnL1wdw/Nw2777lmGyZsnTrOqwx8PoSG7U1cVCZh+/bn
         Au7ugxlJ/Dtl6Q4ax/hesnnUSBn4RB1jjp4rNQTwWIEzzfdsNudvnl/ISWCQ4bUINk
         0O+skF0BuBp2lmR/elC8XNenrzRFlJRmJ2nRqQj4=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, broonie@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
 <20210409223227.rvf6tfhvgnpzmabn@treble>
 <20210409225321.2czbawz6p2aquf5m@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <1be20ada-6b52-c6e8-508c-7572c438d2b7@linux.microsoft.com>
Date:   Sun, 11 Apr 2021 12:54:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409225321.2czbawz6p2aquf5m@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/9/21 5:53 PM, Josh Poimboeuf wrote:
> On Fri, Apr 09, 2021 at 05:32:27PM -0500, Josh Poimboeuf wrote:
>> On Fri, Apr 09, 2021 at 05:05:58PM -0500, Madhavan T. Venkataraman wrote:
>>>> FWIW, over the years we've had zero issues with encoding the frame
>>>> pointer on x86.  After you save pt_regs, you encode the frame pointer to
>>>> point to it.  Ideally in the same macro so it's hard to overlook.
>>>>
>>>
>>> I had the same opinion. In fact, in my encoding scheme, I have additional
>>> checks to make absolutely sure that it is a true encoding and not stack
>>> corruption. The chances of all of those values accidentally matching are,
>>> well, null.
>>
>> Right, stack corruption -- which is already exceedingly rare -- would
>> have to be combined with a miracle or two in order to come out of the
>> whole thing marked as 'reliable' :-)
>>
>> And really, we already take a similar risk today by "trusting" the frame
>> pointer value on the stack to a certain extent.
> 
> Oh yeah, I forgot to mention some more benefits of encoding the frame
> pointer (or marking pt_regs in some other way):
> 
> a) Stack addresses can be printed properly: '%pS' for printing regs->pc
>    and '%pB' for printing call returns.
> 
>    Using '%pS' for call returns (as arm64 seems to do today) will result
>    in printing the wrong function when you have tail calls to noreturn
>    functions on the stack (which is actually quite common for calls to
>    panic(), die(), etc).
> 
>    More details:
> 
>    https://lkml.kernel.org/r/20210403155948.ubbgtwmlsdyar7yp@treble
> 
> b) Stack dumps to the console can dump the exception registers they find
>    along the way.  This is actually quite nice for debugging.
> 
> 

Great.

I am preparing version 3 taking into account comments from yourself,
Mark Rutland and Mark Brown.

Stay tuned.

Madhavan
