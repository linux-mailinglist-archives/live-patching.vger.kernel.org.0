Return-Path: <live-patching+bounces-847-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1B59D17A8
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 19:09:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64A211F224BE
	for <lists+live-patching@lfdr.de>; Mon, 18 Nov 2024 18:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F201DE4F1;
	Mon, 18 Nov 2024 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QcXvfQn3"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E362137750;
	Mon, 18 Nov 2024 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731953362; cv=none; b=OMkZkwPe9DCQ9/Ej0PCNXa/Y6wD6u7WY8BpXRhsWnAnKp7MUDNFKZL2G9oovsd31Ki4qmjiNaYQRMEfFElJxDrIF9YRQ6QGm30YRNgbIdkRZ9QY1lRep8u3f7197vKbE+oWpEnSOJhl9aaDNZG2/PqwQpvO/HT4lYTbGQ28tW/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731953362; c=relaxed/simple;
	bh=KNny0K86sMbqQg45dYymrypgDYEKIlErAgM2ScSFLMo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FZGH9txiPnCDkU4hsy8ECzTXo5Z/B56cRIUihOYEtrUYSCyzvcWq1rPHCTT9uN/AipFjQ7SAJJ1tNGOrP8l3W/6hvsF+yNgNmeW/RFZfPWLEbjPBXmJIrBdlx30gzOe6GwN2iUei5OGsQw2CD6p1jGJoYcpnF2l8peQ07Wzh26I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=QcXvfQn3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.35.166] (c-73-118-245-227.hsd1.wa.comcast.net [73.118.245.227])
	by linux.microsoft.com (Postfix) with ESMTPSA id B3D1220BEBD0;
	Mon, 18 Nov 2024 10:09:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3D1220BEBD0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731953360;
	bh=wR2vAxb4KjC7bChWhYgHEm7VYOkoUSKJ2zrGmmUQgeU=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=QcXvfQn32bbEJk/CliGqPjJlSoPmzpqy39Cb7yWbUp/UMAorBMUaWUr/NKZ9e69DC
	 EuA6BiEwniO9Hz9jAZdoaPATG/Z4etAtwQMMCiIdSJ0wltRFnatVskzJPAClKWSWJ2
	 IoOFaRlq/Uc2MlJVJm0M77F7OwMbRuycEwh39LjI=
Message-ID: <52cc0733-49fc-4452-99c6-8c18bf20dde7@linux.microsoft.com>
Date: Mon, 18 Nov 2024 10:09:17 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, James.Bottomley@HansenPartnership.com,
 Julia.Lawall@inria.fr, agordeev@linux.ibm.com, airlied@gmail.com,
 akpm@linux-foundation.org, andrew+netdev@lunn.ch, anna-maria@linutronix.de,
 ath11k@lists.infradead.org, axboe@kernel.dk,
 bcm-kernel-feedback-list@broadcom.com, borntraeger@linux.ibm.com,
 catalin.marinas@arm.com, ceph-devel@vger.kernel.org,
 christian.gmeiner@gmail.com, christophe.leroy@csgroup.eu, cocci@inria.fr,
 coreteam@netfilter.org, daniel@zonque.org, davem@davemloft.net,
 dick.kennedy@broadcom.com, dri-devel@lists.freedesktop.org,
 edumazet@google.com, etnaviv@lists.freedesktop.org,
 florian.fainelli@broadcom.com, gor@linux.ibm.com,
 gregkh@linuxfoundation.org, haojian.zhuang@gmail.com, hca@linux.ibm.com,
 horms@kernel.org, idryomov@gmail.com, intel-xe@lists.freedesktop.org,
 james.smart@broadcom.com, jeroendb@google.com, jikos@kernel.org,
 jinpu.wang@cloud.ionos.com, jjohnson@kernel.org, joe.lawrence@redhat.com,
 johan.hedberg@gmail.com, jpoimboe@kernel.org, kadlec@netfilter.org,
 kuba@kernel.org, kvalo@kernel.org, l.stach@pengutronix.de,
 linux+etnaviv@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rpi-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
 linux@armlinux.org.uk, linuxppc-dev@lists.ozlabs.org,
 live-patching@vger.kernel.org, louis.peens@corigine.com,
 lucas.demarchi@intel.com, luiz.dentz@gmail.com,
 maarten.lankhorst@linux.intel.com, maddy@linux.ibm.com, marcel@holtmann.org,
 martin.petersen@oracle.com, mbenes@suse.cz, mpe@ellerman.id.au,
 mripard@kernel.org, naveen@kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, nicolas.palix@imag.fr, npiggin@gmail.com,
 obitton@habana.ai, ogabbay@kernel.org, oss-drivers@corigine.com,
 pabeni@redhat.com, pablo@netfilter.org, perex@perex.cz,
 pkaligineedi@google.com, pmladek@suse.com, rjui@broadcom.com,
 robert.jarzmik@free.fr, rodrigo.vivi@intel.com, roger.pau@citrix.com,
 sbranden@broadcom.com, shailend@google.com, simona@ffwll.ch,
 svens@linux.ibm.com, thomas.hellstrom@linux.intel.com, tiwai@suse.com,
 tzimmermann@suse.de, xen-devel@lists.xenproject.org, xiubli@redhat.com
Subject: Re: [PATCH v2 02/21] coccinelle: misc: Add secs_to_jiffies script
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
References: <20241115-converge-secs-to-jiffies-v2-2-911fb7595e79@linux.microsoft.com>
 <20241116060541.5798-1-christophe.jaillet@wanadoo.fr>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <20241116060541.5798-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/15/2024 10:05 PM, Christophe JAILLET wrote:
> Le 15/11/2024 à 22:26, Easwar Hariharan a écrit :
>> Suggested-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
>> ---
>>   scripts/coccinelle/misc/secs_to_jiffies.cocci | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/scripts/coccinelle/misc/secs_to_jiffies.cocci b/scripts/coccinelle/misc/secs_to_jiffies.cocci
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..af762b1c0aac8f044f21150bfaafd9efc834ee87
>> --- /dev/null
>> +++ b/scripts/coccinelle/misc/secs_to_jiffies.cocci
>> @@ -0,0 +1,21 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +///
>> +/// Find usages of:
>> +/// - msecs_to_jiffies(value*1000)
>> +/// - msecs_to_jiffies(value*MSEC_PER_SEC)
>> +///
>> +// Confidence: High
>> +// Copyright: (C) 2024 Easwar Hariharan Microsoft
>> +//
>> +// Keywords: secs, seconds, jiffies
>> +//
>> +
>> +@@ constant C; @@
>> +
>> +- msecs_to_jiffies(C * 1000)
>> ++ secs_to_jiffies(C)
>> +
>> +@@ constant C; @@
>> +
>> +- msecs_to_jiffies(C * MSEC_PER_SEC)
>> ++ secs_to_jiffies(C)
>>
> Hi,
> 
> 	@@ constant C =~ "000"; @@
> 
> 	* msecs_to_jiffies(C)
> 
> also spots things like msecs_to_jiffies(1000)
> 
> I'm not sure that coccinelle is enable to capture part of the regex to automate the removal of the 000 when converting from ms to s.
> 
> Just my 2c,
> 
> CJ

Thank you, I'll try that rule for the later parts. Thank you all for
helping with writing Coccinelle rules, I'm not familiar with
metaprogramming in general and Coccinelle in particular, so these are
super helpful.

- Easwar

