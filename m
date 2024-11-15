Return-Path: <live-patching+bounces-820-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7E89CFA7B
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 23:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8241CB2E286
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 22:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3DA18FDC8;
	Fri, 15 Nov 2024 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="N1g55SdN"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95D418801A;
	Fri, 15 Nov 2024 22:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731708913; cv=none; b=d5mwFry7xPy638MBJ6WFHmDGtUXbpSdbU6j90rcI9eX98LiErim7E8z77mrSC+ggVHkToyzixVAUIozfnITIuDCvvANRRwDCC1lUAwCJVqeg4xRuV+eb4a3xBTj/XlZt4Fx5OirNPVRoDG9OGWvuXe3Pc3w3XW8Dnu7hebmk+o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731708913; c=relaxed/simple;
	bh=/gM5S2JpghDM0ugec1ktyfCAqRVYpBpjvyLdIODChSQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DCi0vMXQQNvWBwWPqW5lylvzY1Y5mijf6PaVmTesdKttTR4QwDaNvyQqyIdgqT35CzJ7uKHkhlV8p1cRaDaIGNSzRQY7bQWAEFPIoDo+SBUFqbp9mi7yUWqhXzIZLRMeSUtpld0m+Mi51PwZV21lQcijDUI2UhYJY+eRTexUNp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=N1g55SdN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.35.166] (c-73-118-245-227.hsd1.wa.comcast.net [73.118.245.227])
	by linux.microsoft.com (Postfix) with ESMTPSA id C2E092064AEB;
	Fri, 15 Nov 2024 14:15:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C2E092064AEB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731708911;
	bh=3z7ywabUJ27i2rb14B4LEGDccer8KYu9+MGXqf4uX30=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=N1g55SdNOAVrXtoAUWPnvUkB3x2fHI9b6jafO92eRdbbD4Gte6s/kvOokfmkgYHJe
	 Frz5kbgdiLksPpFFaWRXGFZ7VcwJJIP77+3HbEyB4bGSyYhL140G+m7AP2fdg7ax7k
	 BFhXHlM0RPRrW6JGtgd18IntrfjEtsdFiu0GVoGc=
Message-ID: <8127a2e6-fa62-4c85-b7ed-24748cc9e285@linux.microsoft.com>
Date: Fri, 15 Nov 2024 14:15:08 -0800
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
 linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Naveen N Rao <naveen@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Louis Peens <louis.peens@corigine.com>, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Lucas Stach <l.stach@pengutronix.de>, Takashi Iwai <tiwai@suse.com>,
 Jaroslav Kysela <perex@perex.cz>, Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Johan Hedberg <johan.hedberg@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Marcel Holtmann <marcel@holtmann.org>, Kalle Valo <kvalo@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?=
 <roger.pau@citrix.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jeroen de Borst <jeroendb@google.com>,
 Shailend Chand <shailend@google.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>, Oded Gabbay
 <ogabbay@kernel.org>, Ofir Bitton <obitton@habana.ai>,
 Sven Schnelle <svens@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Russell King <linux@armlinux.org.uk>, Robert Jarzmik
 <robert.jarzmik@free.fr>, Haojian Zhuang <haojian.zhuang@gmail.com>,
 Daniel Mack <daniel@zonque.org>, Nicolas Palix <nicolas.palix@imag.fr>,
 Julia Lawall <Julia.Lawall@inria.fr>, Simon Horman <horms@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 00/21] Converge on using secs_to_jiffies()
To: Jeff Johnson <quic_jjohnson@quicinc.com>,
 Thomas Gleixner <tglx@linutronix.de>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <10ee4e8f-d8b4-4502-a5e2-0657802aeb11@linux.microsoft.com>
 <3ac480f5-549b-4449-baa9-f766e074c409@quicinc.com>
Content-Language: en-US
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <3ac480f5-549b-4449-baa9-f766e074c409@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/2024 1:41 PM, Jeff Johnson wrote:
> On 11/15/2024 1:29 PM, Easwar Hariharan wrote:
>> On 11/15/2024 1:26 PM, Easwar Hariharan wrote:
>>> This is a series that follows up on my previous series to introduce
>>> secs_to_jiffies() and convert a few initial users.[1] In the review for
>>> that series, Anna-Maria requested converting other users with
>>> Coccinelle. This is part 1 that converts users of msecs_to_jiffies()
>>> that use the multiply pattern of either of:
>>> - msecs_to_jiffies(N*1000), or
>>> - msecs_to_jiffies(N*MSEC_PER_SEC)
>>>
>>> The entire conversion is made with Coccinelle in the script added in
>>> patch 2. Some changes suggested by Coccinelle have been deferred to
>>> later parts that will address other possible variant patterns.
>>>
>>> CC: Anna-Maria Behnsen <anna-maria@linutronix.de>
>>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
>>>
>>> [1] https://lore.kernel.org/all/20241030-open-coded-timeouts-v3-0-9ba123facf88@linux.microsoft.com/
>>> [2] https://lore.kernel.org/all/8734kngfni.fsf@somnus/
>>>
>>> ---
>>> Changes in v2:
>>> - EDITME: describe what is new in this series revision.
>>> - EDITME: use bulletpoints and terse descriptions.
>>> - Link to v1: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com
>>>
>>
>> Apologies, I missed out on editing the changelog here. v1 included a
>> patch that's already been accepted, there are no other changes in v2.
>>
>> Thanks,
>> Easwar
> 
> How do you expect this series to land since it overlaps a large number of
> maintainer trees? Do you have a maintainer who has volunteered to take the
> series and the maintainers should just ack? Or do you want the maintainers to
> take the individual patches that are applicable to them?
> 
> /jeff

I am hoping for tglx to take it through his tree since the patch
introducing secs_to_jiffies() is in his tree, so sequencing of
dependencies would not be an issue.

But if tglx won't, we could push it out another cycle and individual
maintainers can take the patches that are applicable to their tree for
the series.

Thanks,
Easwar

