Return-Path: <live-patching+bounces-916-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5899EC407
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 05:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91701168462
	for <lists+live-patching@lfdr.de>; Wed, 11 Dec 2024 04:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE501BFDE7;
	Wed, 11 Dec 2024 04:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="IJPud503"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F1D2451C1;
	Wed, 11 Dec 2024 04:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891688; cv=none; b=C/RT1NeRrsxI8j+7E82VjPWVfZzrZSZFLHa0IgU56Bo8P3SZ1ovI3qWiIdbV65+sQ+BpyyDE0vQTIp7O+aS4iomNcXVYjl2t1OFnT/VcRt1EQUsZjQtinBeE01DmOLyUiWQFgM6JmTilsXNB3FYBPvHFWYDGWAXfw/TFBnZRVeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891688; c=relaxed/simple;
	bh=+6iom3xS2EcNM1rvfQkOHsuFsgIrc5Jo/yPosMOw+8I=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OtnXlDmr7igFEUBRJuCxlaqmgfdxzQ578452dcmzngwKGPo7O9rVrs3nJveZIXhWD7Ccgn+2QdMy1GLtpi+swbYr9kqQ8W8notJT5v5pTpgc+wKNsKJcMFK5KiXS+PqUZ1oSJZar8/HNt8U8Rep4y3noWnG0rzNZrctz6OKbHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=IJPud503; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.208.14] (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id C44BD204722B;
	Tue, 10 Dec 2024 20:34:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C44BD204722B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1733891686;
	bh=SKADluaoUiTETH1UwG/V5DVCwgNdNCuMvx/YiXR3rAc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=IJPud503TZQ7qC+nAh33r29ZAguv/DZaDYDmYDAbJHqsXv7vFEisx4C+2Bx4/X0Ny
	 QNmGT6WWiLLDSDyIxMX24BlKcPvLa2DRjFmS0GhpoB9JmvKOYeEniEHPcKfYI5Rx3Y
	 UFvay1FmNXEMmTdeKu7+xEJKV27TsW4+ndYHIugA=
Message-ID: <d93e388c-ed18-400c-b6cf-ec00a5979457@linux.microsoft.com>
Date: Tue, 10 Dec 2024 20:34:43 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Andrew Morton <akpm@linux-foundation.org>, eahariha@linux.microsoft.com,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
 Robert Jarzmik <robert.jarzmik@free.fr>, Russell King
 <linux@armlinux.org.uk>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Ofir Bitton <obitton@habana.ai>,
 Oded Gabbay <ogabbay@kernel.org>, Lucas De Marchi
 <lucas.demarchi@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
 Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Florian Fainelli <florian.fainelli@broadcom.com>, Ray Jui
 <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Xiubo Li <xiubli@redhat.com>,
 Ilya Dryomov <idryomov@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Louis Peens <louis.peens@corigine.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@inria.fr,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, linux-mm@kvack.org,
 linux-bluetooth@vger.kernel.org, linux-staging@lists.linux.dev,
 linux-rpi-kernel@lists.infradead.org, ceph-devel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-sound@vger.kernel.org,
 oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org,
 Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: Re: [PATCH v3 00/19] Converge on using secs_to_jiffies()
To: Jakub Kicinski <kuba@kernel.org>
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
 <315e9178-5b10-4de0-bdcf-7243e0e355bb@oss.qualcomm.com>
 <20241210153604.cf99699f264f12740ffce5c7@linux-foundation.org>
 <20241210173548.5d32efe0@kernel.org>
 <20241210183130.81111d05148c41278a299aad@linux-foundation.org>
 <20241210184129.41aaf371@kernel.org>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <20241210184129.41aaf371@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/2024 6:41 PM, Jakub Kicinski wrote:
> On Tue, 10 Dec 2024 18:31:30 -0800 Andrew Morton wrote:
>>>> I'll just grab everything and see if anyone complains ;)  
>>>
>>> I may, if this leads to a conflict :(  
>>
>> Very unlikely, and any such conflict will be trivial.
> 
> Agreed, mainly I don't understand why we'd make an exception
> and take the patchset via a special tree.
> 
>>> Easwar, please break this up per subsystem.  
>>
>> The series is already one-patch-per-changed-file.
> 
> More confusingly still, they did send one standalone patch for 
> an Ethernet driver:
> https://lore.kernel.org/all/20241210-converge-secs-to-jiffies-v3-20-59479891e658@linux.microsoft.com/
> And yet another Ethernet driver (drivers/net/ethernet/google/gve/) 
> is converted in this series.

Sorry about the confusion, I missed pulling the gve patch from this
series. I'll send that (and ath11k) separately as well. I'll pull all
these together into a series so you can merge them together if you prefer.

Thanks,
Easwar

