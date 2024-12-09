Return-Path: <live-patching+bounces-885-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 487829E94A5
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 13:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE9BE280C22
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 12:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8383A224B01;
	Mon,  9 Dec 2024 12:45:22 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB8E221D86;
	Mon,  9 Dec 2024 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748322; cv=none; b=TAHtoVwD4vAR5+UBe9t0NrBgiiBeB6T/W63ZzpT/MIBiA2dLXWHQtWP8VXtzN6RD64W6KXkp7K2feKndl2GK3QMTkoeE/rwkK4Ma/+6pqXRn/E3RQys5y+IKBL/2+ojqZjspO+L772nCFuzSwmiDxmu35DQzm/EIxoFTgL+Iruk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748322; c=relaxed/simple;
	bh=A5ejJ/BX/PS60+9iiR3WDF+uIu660h9qKllHzZGc5G4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aja6EPjtZHUpZZmSplvcLsW0eIEjuh1rJTC6a/b8nIUMdqAY/pAmZexUdHl+LDK+4rEX7PDTSn1KPfbY+5Jxnl3hi4nsl4AK4UMu9cjwAxR7BBGP/CY+6Jb/8MQbmEvKa5M2RlTWoTYIqLyfbw3UjdLwwzGu0HYYxyvOCdFKUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Y6M5p179vz9tBf;
	Mon,  9 Dec 2024 13:45:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ad8aC7rBW98b; Mon,  9 Dec 2024 13:45:18 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Y6M5p0DxHz9tBd;
	Mon,  9 Dec 2024 13:45:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id E8A068B766;
	Mon,  9 Dec 2024 13:45:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id OUa8UHFVNS_8; Mon,  9 Dec 2024 13:45:17 +0100 (CET)
Received: from [10.25.209.139] (unknown [10.25.209.139])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id A70C18B763;
	Mon,  9 Dec 2024 13:45:17 +0100 (CET)
Message-ID: <95a461ca-3ed6-4380-ad1a-da12e1109675@csgroup.eu>
Date: Mon, 9 Dec 2024 13:45:17 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/21] Converge on using secs_to_jiffies()
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@inria.fr,
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
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <b9fcb12a-b7a4-4c33-836e-67109ce07deb@intel.com>
 <dab77729-682f-4182-9fb2-cd522ac29b5f@linux.microsoft.com>
 <72c8eb66-eb67-4f8b-b0c0-13f1aa001698@intel.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <72c8eb66-eb67-4f8b-b0c0-13f1aa001698@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 09/12/2024 à 13:01, Przemek Kitszel a écrit :
> On 12/6/24 9:58 PM, Easwar Hariharan wrote:
>> On 11/29/2024 4:57 AM, Przemek Kitszel wrote:
>>>
>>> [removed most non-list recipients, it's just too much]
>>>
>>> On 11/15/24 10:26 PM, Easwar Hariharan wrote:
>> <snip>
> 
>>>
>>> Regarding code - you could also convert msecs_to_jiffies(const * HZ),
>>> there are 10 that are greppable.
>>>
>>
>> Those seem to be mistakes. const*HZ is a seconds-denominated timeout,
>> being passed to msecs_to_jiffies() which will treat it as a
>> millisecond-denominated timeout resulting in an excessively long
>> timeout. I suppose that's better than a too-short timeout, and
>> apparently it's been working fine all along since hardware responds
>> before the too-long timeout expires. Half of them are in
>> drivers/scsi/arcmsr/arcmsr_hba.c and the pattern has apparently been
>> there since 2010.
> 
> my point was that, the default value of HZ is 1000, and most of the code
> that is just `$value*HZ` was meant as "$value seconds, in ms unit".

I can't follow you here. The default value of HZ is 250 as far as I can see.

Regardless, HZ is the number of jiffies per second, nothing else.

> 
> Same for HZ/const, HZ/2 being 500ms.
> 
> HZ is awful in that it is not 1s but 1/s, but it was easy to abuse the
> value in simple context.

Why is that awful ?

HZ is a nice macro that gives you the number of ticks per second, so 
that you are able to easily calculate the number of ticks for a given 
duration, regardless of the configured number of ticks per second.

Christophe

