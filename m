Return-Path: <live-patching+bounces-83-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B26814B89
	for <lists+live-patching@lfdr.de>; Fri, 15 Dec 2023 16:18:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FEE02871C8
	for <lists+live-patching@lfdr.de>; Fri, 15 Dec 2023 15:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7962936AE0;
	Fri, 15 Dec 2023 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZJmitctl"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DBA364D7;
	Fri, 15 Dec 2023 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.4.26] (unknown [47.186.13.91])
	by linux.microsoft.com (Postfix) with ESMTPSA id 31E8020B3CC2;
	Fri, 15 Dec 2023 07:15:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 31E8020B3CC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702653353;
	bh=TbbdfdN9F0xN9xrOOIN9kgjBMXwWRzLs8wobMZJ5G9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZJmitctlicMc0n358JdynVujyRx8KAn3uE9xYYk/edA5anFQwi7Mk1mnplEaW6Dxo
	 GyZNdp1Pqtq0FL20GrsS1CHIorRxueJdfaS7cPSyvY3nCdzlmkvZ4AKi74xlxMjrOP
	 DndtXFw70MDLSdjfvoYF6c8lpW2s5GVkz7yPjv58=
Message-ID: <8f3d6362-1513-45a9-9f56-f7ec4bff11a2@linux.microsoft.com>
Date: Fri, 15 Dec 2023 09:15:52 -0600
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ARM64 Livepatch based on SFrame
To: Mark Rutland <mark.rutland@arm.com>
Cc: jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
 broonie@kernel.org, nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, jamorris@linux.microsoft.com,
 linux-arm-kernel@lists.infradead.org, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <72364198-b031-4ecc-b337-d07db1b9d0c8@linux.microsoft.com>
 <ZXxO43Xwn5GHsrO8@FVFF77S0Q05N>
Content-Language: en-US
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ZXxO43Xwn5GHsrO8@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/15/23 07:04, Mark Rutland wrote:
> On Thu, Dec 14, 2023 at 02:49:29PM -0600, Madhavan T. Venkataraman wrote:
>> Hi Mark,
> 
> Hi Madhavan,
> 
>> I attended your presentation in the LPC. You mentioned that you could use
>> some help with some pre-requisites for the Livepatch feature.
>> I would like to lend a hand.
> 
> Cool!
> 
> I've been meaning to send a mail round with a summary of the current state of
> things, and what needs to be done going forward, but I haven't had the time
> since LPC to put that together (as e.g. that requires learning some more about
> SFrame).  I'll be disappearing for the holiday shortly, and I intend to pick
> that up in the new year.
> 
>> What would you like me to implement?
> 
> I'm not currently sure exactly what we need/want to implement, and as above I
> think that needs to wait until the new year.
> 

OK.

> However, one thing that you can do that would be very useful is to write up and
> report the GCC DWARF issues that you mentioned in:
> 
>   https://lore.kernel.org/linux-arm-kernel/20230202074036.507249-1-madvenka@linux.microsoft.com/
> 
> ... as (depending on exactly what those are) those could also affect SFrame
> generation (and thus we'll need to get those fixed in GCC), and regardless it
> would be useful information to know.
> 
> I understood that you planned to do that from:
> 
>   https://lore.kernel.org/linux-arm-kernel/054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com/
> 
> ... but I couldn't spot any relevant mails or issues in the GCC bugzilla, so
> either I'm failing to search hard enough, or did that get forgotten about?
> 

Yeah. I had notes on that. But I seem to have lost them. I need to reproduce the
problems and analyze them again which is not trivial. So, I have been procrastinating.

I am also disappearing for the rest of this year. I will try to look at it in the
new year.

>> I would also like to implement Unwind Hints for the feature. If you want a
>> specific format for the hints, let me know.
> 
> I will get back to you on that in the new year; I think the specifics we want
> are going to depend on other details above we need to analyse first.
> 

OK.

For now, I will implement something and send it out just for reference. We can revisit
this topic next year sometime.

Thanks.

Madhavan

