Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBD3B47F5
	for <lists+live-patching@lfdr.de>; Fri, 25 Jun 2021 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFYRHl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Jun 2021 13:07:41 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40074 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhFYRHk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Jun 2021 13:07:40 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id D7D1320B6C50;
        Fri, 25 Jun 2021 10:05:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7D1320B6C50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1624640719;
        bh=UD+BcbDrEM2gSB6paV5YXzW78vc08XXoCGTvEEINV80=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=X1zzO73pT7lIAH1H7ftc3htOKEyCYdRZg/ULZnydJNZyYzIw5egr9/DXNmILLHur1
         kpCC2DiQecmwU91SeljGYC8jawn/gCBMcY3cEk9CTm5uVEM+H7feWSI80BqWtjJh+M
         I7fJgV3KSIz0q2Cegvg8udOQ8vteE14TNmxlJoNc=
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
 <20210624144021.GA17937@C02TD0UTHF1T.local>
 <da0a2d95-a8cd-7b39-7bba-41cfa8782eaa@linux.microsoft.com>
 <20210625155127.GC4492@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <d9451984-d3fe-405f-f2e6-6571acd518e9@linux.microsoft.com>
Date:   Fri, 25 Jun 2021 12:05:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625155127.GC4492@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/25/21 10:51 AM, Mark Brown wrote:
> On Fri, Jun 25, 2021 at 10:39:57AM -0500, Madhavan T. Venkataraman wrote:
>> On 6/24/21 9:40 AM, Mark Rutland wrote:
> 
>>> At a high-level, I'm on-board with keeping track of this per unwind
>>> step, but if we do that then I want to be abel to use this during
>>> regular unwinds (e.g. so that we can have a backtrace idicate when a
>>> step is not reliable, like x86 does with '?'), and to do that we need to
>>> be a little more accurate.
> 
>> The only consumer of frame->reliable is livepatch. So, in retrospect, my
>> original per-frame reliability flag was an overkill. I was just trying to
>> provide extra per-frame debug information which is not really a requirement
>> for livepatch.
> 
> It's not a requirement for livepatch but if it's there a per frame
> reliability flag would have other uses - for example Mark has mentioned
> the way x86 prints a ? next to unreliable entries in oops output for
> example, that'd be handy for people debugging issues and would have the
> added bonus of ensuring that there's more constant and widespread
> exercising of the reliability stuff than if it's just used for livepatch
> which is a bit niche.
> 

I agree. That is why I introduced the per-frame flag.

So, let us try a different approach.

First, let us get rid of the frame->reliable flag from this patch series. That flag
can be implemented when all of the pieces are in place for per-frame debug and tracking.

For consumers such as livepatch that don't really care about per-frame stuff, let us
solve it more cleanly via the return value of unwind_frame().

Currently, the return value from unwind_frame() is a tri-state return value which is
somewhat confusing.

	0	means continue unwinding
	-error	means stop unwinding. However,
			-ENOENT means successful termination
			Other values mean an error has happened.

Instead, let unwind_frame() return one of 3 values:

enum {
	UNWIND_CONTINUE,
	UNWIND_CONTINUE_WITH_ERRORS,
	UNWIND_STOP,
};

All consumers will stop unwinding upon seeing UNWIND_STOP.

Livepatch type consumers will stop unwinding upon seeing anything other than UNWIND_CONTINUE.

Debug type consumers can choose to continue upon seeing UNWIND_CONTINUE_WITH_ERRORS.

When we eventually implement per-frame stuff, debug consumers can examine the
frame for more information when they see UNWIND_CONTINUE_WITH_ERRORS.

This way, my patch series does not have a dependency on the per-frame enhancements.

>> So, let us separate the two. I will rename frame->reliable to frame->livepatch_safe.
>> This will apply to the whole stacktrace and not to every frame.
> 
> I'd rather keep it as reliable, even with only the livepatch usage I
> think it's clearer.
> 

See suggestion above.

>> Finally, it might be a good idea to perform reliability checks even in
>> start_backtrace() so we don't assume that the starting frame is reliable even
>> if the caller passes livepatch_safe=true. What do you think?
> 
> That makes sense to me.
> 

Thanks.

Madhavan
