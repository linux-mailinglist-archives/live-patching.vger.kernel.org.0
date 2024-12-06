Return-Path: <live-patching+bounces-879-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3764F9E7A43
	for <lists+live-patching@lfdr.de>; Fri,  6 Dec 2024 21:58:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23840163264
	for <lists+live-patching@lfdr.de>; Fri,  6 Dec 2024 20:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073391AAA27;
	Fri,  6 Dec 2024 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="opdIpAAC"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EADF1F236B;
	Fri,  6 Dec 2024 20:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733518706; cv=none; b=Y1RwqErzoq6ACEd300/kcYN3oX4EV5lZ9B8De2uIPS4LgjuYgwDRaFZnzklNFrK+KbfurHan5GJVEya2SDUSzvO2Cj6o3jbtAcrZAQP81ZPaXqc+BmjlIq7Z+pkJ5vfl+yMvH4PGkY6m+0W6qTSMCVFYiqXtslZa4KvuT/fso3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733518706; c=relaxed/simple;
	bh=AoYJEduDKAfmUXw66punVqpLvMHGpz/t+LVYPT/z7pE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PTE0LzgcEYhomE5+EfGy48xWLh+cLZxNq/uwTh6WHo6tb9XM1IEmlg6u+0XGOJLMFhShkwNNrnNwypY5CtJyUJCH1WfybwbICchqnIEwswWtdePDXwWQzRero4wKc5NeTVo0coPRFPDKgTxf35um/u/bVOhntIbNICecjFd5/s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=opdIpAAC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.128.154] (unknown [20.236.11.102])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8B63620ACD7A;
	Fri,  6 Dec 2024 12:58:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8B63620ACD7A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1733518699;
	bh=M9PuEUd7fHK0twjnpmT4sQ2WiGKSyXN5nPrU+06sRxI=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=opdIpAACnQeStJ33oACe6p52ZM8f0Sws7Fv8oVZEtnJ34oxYkj2Ifncn0UBE7+8VM
	 /Rer5IHWNKL+Om4cBhthsawIs+kQdevr3ykVw21CBvfVnNLhAZ1lcWLQbVr0aJDoH2
	 0Lv+tHrW7mbf2ysXMzyMfTT7x/zNVB+cEVkkvmJU=
Message-ID: <dab77729-682f-4182-9fb2-cd522ac29b5f@linux.microsoft.com>
Date: Fri, 6 Dec 2024 12:58:17 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, cocci@inria.fr,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, linux-mm@kvack.org,
 linux-bluetooth@vger.kernel.org, linux-staging@lists.linux.dev,
 linux-rpi-kernel@lists.infradead.org, ceph-devel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-sound@vger.kernel.org,
 etnaviv@lists.freedesktop.org, oss-drivers@corigine.com,
 linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: Re: [PATCH v2 00/21] Converge on using secs_to_jiffies()
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <b9fcb12a-b7a4-4c33-836e-67109ce07deb@intel.com>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <b9fcb12a-b7a4-4c33-836e-67109ce07deb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/2024 4:57 AM, Przemek Kitszel wrote:
> 
> [removed most non-list recipients, it's just too much]
> 
> On 11/15/24 10:26 PM, Easwar Hariharan wrote:
<snip>
>>
>> ---
>> Changes in v2:
>> - EDITME: describe what is new in this series revision.
>> - EDITME: use bulletpoints and terse descriptions.
>> - Link to v1: https://lore.kernel.org/r/20241115-converge-secs-to-
>> jiffies-v1-0-19aadc34941b@linux.microsoft.com
> 
> that is not a proper changelog, you were supposed to edit those
> placeholder entries; please look around for examples
> 
> There is also just too much recipients. Please split up your patches
> into smaller pieces. You will also learn the process on a smaller
> sample.
> 
> And definitively please wait for 48h before reposting such big series.

Yes, sorry, I sent out a v2 in a moment of panic on including the
already accepted patch in v1. I failed to edit the changelog in that
same panic. I'll try to not panic and do better in the future.

> 
> Regarding code - you could also convert msecs_to_jiffies(const * HZ),
> there are 10 that are greppable.
> 

Those seem to be mistakes. const*HZ is a seconds-denominated timeout,
being passed to msecs_to_jiffies() which will treat it as a
millisecond-denominated timeout resulting in an excessively long
timeout. I suppose that's better than a too-short timeout, and
apparently it's been working fine all along since hardware responds
before the too-long timeout expires. Half of them are in
drivers/scsi/arcmsr/arcmsr_hba.c and the pattern has apparently been
there since 2010.

Thanks,
Easwar

