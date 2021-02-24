Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6C4324498
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 20:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhBXT1n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 14:27:43 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48140 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBXT1i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 14:27:38 -0500
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1851920B6C40;
        Wed, 24 Feb 2021 11:26:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1851920B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1614194817;
        bh=Qrxzv4fZytREq3iP5HW1b0UZZBB53F52KA2598ST9R8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VRHRBtm9VPjzWbAq4uOs1QpDm9d/UjC3CdBHUOHn1C1y7rpeMi63TaoP8Rb2gMy9e
         PI2lEkJa+R/ZxF4N9L7GHPmCLeSEFIklfBA60UtsZEGFtXzUySH3OG+FYt/gitQt3y
         LgneMV6NbEelIgk6MSBDYPShG1WdWa5bsGanhjNA=
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
 <08e8e02c-8ef0-26bb-1d0d-7dda54b5fefd@linux.microsoft.com>
 <20210224123336.GA4504@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <685d583b-f3c1-8cb3-aeca-78e2fbb3fd25@linux.microsoft.com>
Date:   Wed, 24 Feb 2021 13:26:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224123336.GA4504@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/24/21 6:33 AM, Mark Brown wrote:
> On Tue, Feb 23, 2021 at 01:20:49PM -0600, Madhavan T. Venkataraman wrote:
>> On 2/23/21 1:02 PM, Mark Brown wrote:
>>> On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:
> 
>>>> Reliable stack trace function
>>>> =============================
>>>>
>>>> Implement arch_stack_walk_reliable(). This function walks the stack like
>>>> the existing stack trace functions with a couple of additional checks:
> 
>>> Again, this should be at least one separate patch.  How does this ensure
>>> that we don't have any issues with any of the various probe mechanisms?
>>> If there's no need to explicitly check anything that should be called
>>> out in the changelog.
> 
>> I am trying to do this in an incremental fashion. I have to study the probe
>> mechanisms a little bit more before I can come up with a solution. But
>> if you want to see that addressed in this patch set, I could do that.
>> It will take a little bit of time. That is all.
> 
> Handling of the probes stuff seems like it's critical to reliable stack
> walk so we shouldn't claim to have support for reliable stack walk
> without it.  If it was a working implementation we could improve that'd
> be one thing but this would be buggy which is a different thing.
> 

OK. I will address the probe stuff in my resend.

>>>> +	(void) on_accessible_stack(task, stackframe, &info);
> 
>>> Shouldn't we return NULL if we are not on an accessible stack?
> 
>> The prev_fp has already been checked by the unwinder in the previous
>> frame. That is why I don't check the return value. If that is acceptable,
>> I will add a comment.
> 
> TBH if you're adding the comment it seems like you may as well add the
> check, it's not like it's expensive and it means there's no possibility
> that some future change could result in this assumption being broken.
> 

OK. I will add the check.

Thanks.

Madhavan
