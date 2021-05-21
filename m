Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C05138CC8E
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbhEURsj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:48:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33196 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbhEURsi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:48:38 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8CCFC20B7188;
        Fri, 21 May 2021 10:47:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8CCFC20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621619235;
        bh=vp4bh6cnn5xgTCxdBL3ssrfVr3lmhjwR6/PPJY0zW0U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kmWtd/Guj2sJubHEiCjGimSMNVPfPbv4AqUu1tPkdEd4CsxXoa90nrgVdPZjS/egp
         YC33iOhW803pF5G2/4Q1+dg2zaO9Xb/n7G/Fassb1CBWUTXpav3DKhQeXov2oKVFx9
         Isb1l0rFMw+VEm7kNqMo/GsWIH9O2llYHg3jzJkQ=
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
Date:   Fri, 21 May 2021 12:47:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521174242.GD5825@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 12:42 PM, Mark Brown wrote:
> On Fri, May 21, 2021 at 12:23:52PM -0500, Madhavan T. Venkataraman wrote:
>> On 5/21/21 11:11 AM, Mark Brown wrote:
>>> On Sat, May 15, 2021 at 11:00:17PM -0500, madvenka@linux.microsoft.com wrote:
> 
>>>> +	frame->reliable = true;
> 
>>> All these checks are good checks but as you say there's more stuff that
>>> we need to add (like your patch 2 here) so I'm slightly nervous about
> 
>> OK. So how about changing the field from a flag to an enum that says exactly
>> what happened with the frame?
> 
> TBH I think the code is fine, or rather will be fine when it gets as far
> as actually being used - this was more a comment about when we flip this
> switch.
> 

OK.

>> Also, the caller can get an exact idea of why the stack trace failed.
> 
> I'm not sure anything other than someone debugging things will care
> enough to get the code out and then decode it so it seems like it'd be
> more trouble than it's worth, we're unlikely to be logging the code as
> standard.
> 

OK.

>>> The other thing I guess is the question of if we want to bother flagging
>>> frames as unrelaible when we return an error; I don't see an issue with
>>> it and it may turn out to make it easier to do something in the future
>>> so I'm fine with that
> 
>> Initially, I thought that there is no need to flag it for errors. But Josh
>> had a comment that the stack trace is indeed unreliable on errors. Again, the
>> word unreliable is the one causing the problem.
> 
> My understanding there is that arch_stack_walk_reliable() should be
> returning an error if either the unwinder detected an error or if any
> frame in the stack is flagged as unreliable so from the point of view of
> users it's just looking at the error code, it's more that there's no
> need for arch_stack_walk_reliable() to consider the reliability
> information if an error has been detected and nothing else looks at the
> reliability information.
> 
> Like I say we may come up with some use for the flag in error cases in
> future so I'm not opposed to keeping the accounting there.
> 

So, should I leave it the way it is now? Or should I not set reliable = false
for errors? Which one do you prefer?

Josh,

Are you OK with not flagging reliable = false for errors in unwind_frame()?

Madhavan
