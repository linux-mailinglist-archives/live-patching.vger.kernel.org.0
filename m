Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D978538CDCF
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 20:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhEUTAm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 15:00:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43496 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhEUTAl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 15:00:41 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id A2E5920B7188;
        Fri, 21 May 2021 11:59:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2E5920B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621623558;
        bh=s5fPPm7/cgoV4/kCfN3NJ1VijEprrtU3LGotGcg2ExM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=s+Xm95umlPDQltd3npd8+AG2+Ec9OFKHWzKtF0vsQBp1dbpksxO65Q0dJhiz91Z4r
         1e6zH1/3pKKCrCzwkrpf1KFS+wwEcW43/YBJdphKf/5ZY3+eJSQ5JiRouVZvsjTlJe
         Wcbye1F4bG/A4sd0NBJJ9T7bJBg9+ux4MA3mkgEE=
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, ardb@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
 <20210521184817.envdg232b2aeyprt@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <74d12457-7590-bca2-d1ce-5ff82d7ab0d8@linux.microsoft.com>
Date:   Fri, 21 May 2021 13:59:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521184817.envdg232b2aeyprt@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 1:48 PM, Josh Poimboeuf wrote:
> On Fri, May 21, 2021 at 06:53:18PM +0100, Mark Brown wrote:
>> On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
>>> On 5/21/21 12:42 PM, Mark Brown wrote:
>>
>>>> Like I say we may come up with some use for the flag in error cases in
>>>> future so I'm not opposed to keeping the accounting there.
>>
>>> So, should I leave it the way it is now? Or should I not set reliable = false
>>> for errors? Which one do you prefer?
>>
>>> Josh,
>>
>>> Are you OK with not flagging reliable = false for errors in unwind_frame()?
>>
>> I think it's fine to leave it as it is.
> 
> Either way works for me, but if you remove those 'reliable = false'
> statements for stack corruption then, IIRC, the caller would still have
> some confusion between the end of stack error (-ENOENT) and the other
> errors (-EINVAL).
> 

I will leave it the way it is. That is, I will do reliable = false on errors
like you suggested.

> So the caller would have to know that -ENOENT really means success.
> Which, to me, seems kind of flaky.
> 

Actually, that is why -ENOENT was introduced - to indicate successful
stack trace termination. A return value of 0 is for continuing with
the stack trace. A non-zero value is for terminating the stack trace.

So, either we return a positive value (say 1) to indicate successful
termination. Or, we return -ENOENT to say no more stack frames left.
I guess -ENOENT was chosen.

> BTW, not sure if you've seen what we do in x86, but we have a
> 'frame->error' which gets set for an error, and which is cumulative
> across frames.  So non-fatal reliable-type errors don't necessarily have
> to stop the unwind.  The end result is the same as your patch, but it
> seems less confusing to me because the 'error' is cumulative.  But that
> might be personal preference and I'd defer to the arm64 folks.
> 

OK. I will wait to see if any arm64 folks have an opinion on this.
I am fine with any approach.

Madhavan
