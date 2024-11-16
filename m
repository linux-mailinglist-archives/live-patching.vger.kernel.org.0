Return-Path: <live-patching+bounces-826-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D53729CFB99
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 01:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25D70B2CEDF
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 00:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258E8376;
	Sat, 16 Nov 2024 00:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="juHtZTV0"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9962836D;
	Sat, 16 Nov 2024 00:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715999; cv=none; b=RhCX1PeVwrCViUIDajk9kPIMn5HC9HgFJAYKZ+XyS3/lLxsf1zR5j0QmrvQaueNrBMFTWPpLQS5HV7hvyYN1dEDSRrz7VdJcspOcd3nQ3YQ8f5pragxzjIHnPGgr8mtPBwkQMUB3/skcnkL409izGUKZ1mJjfC0opobK7wG1xjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715999; c=relaxed/simple;
	bh=1QhmnzTq6YPc5SN9QYasNPOs7nsv4yjri266rgw+pOw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C/JuprPMQg8Nez/QxlmQdyUVWgptTZFjtxUDIlkLzC9DjXKM6XNdyiAuaCHC3JLFmZcPNjhP9sPorh5VoQi5UoxoiPPUa2Un+j4e8KvllWmJ8eBYfHp4Wt4LVLvjNtnum2LOGXv6UJaciR9WBOcf6BzcF/whRlUSMCJegR8vDfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=juHtZTV0; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.35.166] (c-73-118-245-227.hsd1.wa.comcast.net [73.118.245.227])
	by linux.microsoft.com (Postfix) with ESMTPSA id 95E342064AF0;
	Fri, 15 Nov 2024 16:13:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 95E342064AF0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731715997;
	bh=8aWsE6KsHqgZAR/UTPX2BOaIFAyMPoSLG9xpC4Hm8PA=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=juHtZTV0RDh+wTFwjvF/I5Cbue56gEXjd0kD3znUPuWXx2wtRwF3SiJZ6HWwI5inJ
	 TBVBD9vnbAv41iOqcNYfHcjXy0Jo4vpPQnYC829Cp+vZARPfhAL4M9phLDROf5akb8
	 KGqyHrYITaajwfOdtt56+uCdzgps3Ezs57MjrN0w=
Message-ID: <0b4bbd38-f6aa-4091-b7db-8b87572ad83a@linux.microsoft.com>
Date: Fri, 15 Nov 2024 16:13:13 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>, Daniel Mack <daniel@zonque.org>,
 Haojian Zhuang <haojian.zhuang@gmail.com>,
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
 <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Marcel Holtmann
 <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>,
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
 Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
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
 etnaviv@lists.freedesktop.org, oss-drivers@corigine.com,
 linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: Re: [PATCH v2 01/21] netfilter: conntrack: Cleanup timeout
 definitions
To: Stephen Rothwell <sfr@canb.auug.org.au>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-1-911fb7595e79@linux.microsoft.com>
 <20241116093458.4aa19a0e@canb.auug.org.au>
Content-Language: en-US
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20241116093458.4aa19a0e@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/2024 2:34 PM, Stephen Rothwell wrote:
> Hi Easwar,
> 
> On Fri, 15 Nov 2024 21:26:18 +0000 Easwar Hariharan <eahariha@linux.microsoft.com> wrote:
>>
>>  static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
>> -	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
>> -	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
>> -	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
>> -	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
>> -	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 3 SECS,
>> -	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 3 SECS,
>> -	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
>> -	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
>> +	[SCTP_CONNTRACK_CLOSED]			= secs_to_jiffies(10),
>> +	[SCTP_CONNTRACK_COOKIE_WAIT]		= secs_to_jiffies(3),
>> +	[SCTP_CONNTRACK_COOKIE_ECHOED]		= secs_to_jiffies(3),
>> +	[SCTP_CONNTRACK_ESTABLISHED]		= secs_to_jiffies(210),
>> +	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= secs_to_jiffies(3),
>> +	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= secs_to_jiffies(3),
>> +	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= secs_to_jiffies(3),
>> +	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= secs_to_jiffies(3),
> 
> You have changed this last timeout from 30 seconds to 3 (presumably
> just a copy and paste error).
> 

Will fix in v3.

