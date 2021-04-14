Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13A35F171
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 12:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhDNKYW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 06:24:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57078 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbhDNKYB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 06:24:01 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3F73C20B8001;
        Wed, 14 Apr 2021 03:23:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F73C20B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618395819;
        bh=2n6Wi06DNnYRuQsmoByjue4YZC4V5R1VyHGjGFvafeY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AiwclcPJYgn9yz4/zHbxTLy+p3zOAnrKUgTSJPCmdzwMYqpe+R/E5IMD0FBPnOpDF
         J3WOuA3LVCdN/WWWuzJ1PnpK0DYtXYsmnQFMwRD0jWovmfqs7ilFA0xi2w4ggemzmt
         zqxVwuYj2jZ7mmc4LDmEVgTag0Kfphwzo1MFT6QA=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
To:     Mark Brown <broonie@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
 <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
 <20210413110255.GB5586@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
Date:   Wed, 14 Apr 2021 05:23:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210413110255.GB5586@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/13/21 6:02 AM, Mark Brown wrote:
> On Mon, Apr 12, 2021 at 02:55:35PM -0500, Madhavan T. Venkataraman wrote:
> 
>>
>> OK. Just so I am clear on the whole picture, let me state my understanding so far.
>> Correct me if I am wrong.
> 
>> 1. We are hoping that we can convert a significant number of SYM_CODE functions to
>>    SYM_FUNC functions by providing them with a proper FP prolog and epilog so that
>>    we can get objtool coverage for them. These don't need any blacklisting.
> 
> I wouldn't expect to be converting lots of SYM_CODE to SYM_FUNC.  I'd
> expect the overwhelming majority of SYM_CODE to be SYM_CODE because it's
> required to be non standard due to some external interface - things like
> the exception vectors, ftrace, and stuff around suspend/hibernate.  A
> quick grep seems to confirm this.
> 

OK. Fair enough.

>> 3. We are going to assume that the reliable unwinder is only for livepatch purposes
>>    and will only be invoked on a task that is not currently running. The task either
> 
> The reliable unwinder can also be invoked on itself.
> 

I have not called out the self-directed case because I am assuming that the reliable unwinder
is only used for livepatch. So, AFAICT, this is applicable to the task that performs the
livepatch operation itself. In this case, there should be no unreliable functions on the
self-directed stack trace (otherwise, livepatching would always fail).

>> 4. So, the only functions that will need blacklisting are the remaining SYM_CODE functions
>>    that might give up the CPU voluntarily. At this point, I am not even sure how
>>    many of these will exist. One hopes that all of these would have ended up as
>>    SYM_FUNC functions in (1).
> 
> There's stuff like ret_from_fork there.
> 

OK. There would be a few functions that fit this category. I agree.

>> I suggest we do (3) first. Then, review the assembly functions to do (1). Then, review the
>> remaining ones to see which ones must be blacklisted, if any.
> 
> I'm not clear what the concrete steps you're planning to do first are
> there - your 3 seems like a statement of assumptions.  For flagging
> functions I do think it'd be safer to default to assuming that all
> SYM_CODE functions can't be unwound reliably rather than only explicitly
> listing ones that cause problems.
> 

They are not assumptions. They are true statements. But I probably did not do a good
job of explaining. But Josh sent out a patch that updates the documentation that
explains what I said a lot better.

In any case, I have absolutely no problems in implementing your section idea. I will
make an attempt to do that in version 3 of my patch series.

Stay tuned.

And, thanks for all the input. It is very helpful.

Madhavan
