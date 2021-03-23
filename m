Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC893469C2
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 21:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhCWUYJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 16:24:09 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54304 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhCWUXe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 16:23:34 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id E42CE20998F8;
        Tue, 23 Mar 2021 13:23:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E42CE20998F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616531014;
        bh=JjMhfAuErMW36lgVhx3H4MQDgdQX42JDmJ+wbfafBrk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=J74QiSmujl5ynjnRyXDK7cZXmxn0SAPaey2YrAx07mz2PI9b5kcM18wMnfKs8nhR2
         iq3y6osQuUJWa6m+wYfeOOTYr4F4ZvxP6Qlw6l27dkVfK5WAnP1b1hAHX7ZSffi2ve
         Y5o3FbOy/3sdiA6v+ssCbAnXWyFpeqYOjJD/L6mE=
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack
 trace unreliable
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
 <20210323170236.GF98545@C02TD0UTHF1T.local>
 <bc450f09-1881-9a9c-bfbc-5bb31c01d8ce@linux.microsoft.com>
 <20210323182753.GE5490@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <78329592-1992-4560-72f2-b0ab4eb088c6@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 15:23:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323182753.GE5490@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 1:27 PM, Mark Brown wrote:
> On Tue, Mar 23, 2021 at 12:23:34PM -0500, Madhavan T. Venkataraman wrote:
>> On 3/23/21 12:02 PM, Mark Rutland wrote:
> 
>>> 3. Figure out exception boundary handling. I'm currently working to
>>>    simplify the entry assembly down to a uniform set of stubs, and I'd
>>>    prefer to get that sorted before we teach the unwinder about
>>>    exception boundaries, as it'll be significantly simpler to reason
>>>    about and won't end up clashing with the rework.
> 
>> So, here is where I still have a question. Is it necessary for the unwinder
>> to know the exception boundaries? Is it not enough if it knows if there are
>> exceptions present? For instance, using something like num_special_frames
>> I suggested above?
> 
> For reliable stack trace we can live with just flagging things as
> unreliable when we know there's an exception boundary somewhere but (as
> Mark mentioned elsewhere) being able to actually go through a subset of
> exception boundaries safely is likely to help usefully improve the
> performance of live patching, and for defensiveness we want to try to
> detect during an actual unwind anyway so it ends up being a performance
> improvment and double check rather than saving us code.  Better
> understanding of what's going on in the presence of exceptions may also
> help other users of the unwinder which can use stacks which aren't
> reliable get better results.
> 

Actually, I was not suggesting that the counter replace the unwinder
intelligence to recognize exception boundaries. I was only suggesting
the use of the counter for arch_stack_walk_reliable().

But I am fine with not implementing the counter for now.

Madhavan
