Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D9375677
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhEFPWi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:22:38 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38388 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbhEFPWh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:22:37 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id A6B3720B7178;
        Thu,  6 May 2021 08:21:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6B3720B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620314499;
        bh=ij10eVnVpqugw2QLIP3ViHbRsGBsR6yzQN21JiOmf90=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mpdw5YkqKssIRCZojCamtXzac0zjvErli9rYCXTk1UNKI0RaGDYnJ6JXSuhZ5+Uwx
         S8GI7LbZ6tBrd6JaZd5l0bPymmvFpKTgtGNBopqZEOrn+f/e/pFzML74XW6XPUVuVG
         D9kOIHoPn6x+Nb4W6Uk2IoI2/vUZvZf81ECsGcfs=
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
 <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
 <20210505164648.GC4541@sirena.org.uk>
 <9781011e-2d99-7f46-592c-621c66ea66c3@linux.microsoft.com>
 <20210506134542.GD4642@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <67969f7f-1c2d-c287-dbdb-4ce21bd8ef23@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:21:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506134542.GD4642@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 8:45 AM, Mark Brown wrote:
> On Wed, May 05, 2021 at 01:48:21PM -0500, Madhavan T. Venkataraman wrote:
>> On 5/5/21 11:46 AM, Mark Brown wrote:
> 
>>> I think that works even if it's hard to love the goto, might want some
>>> defensiveness to ensure we can't somehow end up in an infinite loop with
>>> a sufficiently badly formed stack.
> 
>> I could do something like this:
> 
>> unwind_frame()
>> {
>> 	int	i;
>> 	...
>>
>> 	for (i = 0; i < MAX_CHECKS; i++) {
>> 		if (!check_frame(tsk, frame))
>> 			break;
>> 	}
> 
> I think that could work, yes.  Have to see the actual code (and other
> people's opinions!).
> 
>> If this is acceptable, then the only question is - what should be the value of
>> MAX_CHECKS (I will rename it to something more appropriate)?
> 
> I'd expect something like 10 to be way more than we'd ever need, or we
> could define it down to the 2 checks we expect to be possible ATM to be
> conservative.  I'm tempted to be permissive if we have sufficient other
> checks but I'm not 100% sure on that.
> 

OK. I will implement these changes for version 4 and send it out so this
whole thing can be reviewed again with the actual changes in front of us.

Madhavan
