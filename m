Return-Path: <live-patching+bounces-840-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C1D9CFE74
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 12:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49ED62861E7
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 11:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC487199FD0;
	Sat, 16 Nov 2024 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="e6HMrvPi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A986D74E09;
	Sat, 16 Nov 2024 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731756370; cv=none; b=mCA2+79yaTCe8jqTba2wBQK9qzEkdsLHkPc3W2Lpsidk4c0MrW+vRcs0rHdCPC1YiXjI9jqrQyzjrXklVWUjYMW15zln5a4paxsNqHUILEWCEGYpky1Hi5Vh6wHolQznk3OrmUhCIVDYdxxLmXBuV00zWoBmTrl+eCYVLVMr6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731756370; c=relaxed/simple;
	bh=sHo8qF+AvE8oVJvwFjFrtdRWHM4ZdMC/331/xYQY13M=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=Y3VriLnM/AXjiNMpHe2hEinCnXV/BaqfqfZ8j9b/yQeTrzE3GoNBl/ICJbWah4edlQugzrEbZ9dQIfZLSAdWIGJEnc9xRU3GAdtd9g9S9Rye86YDUJxKtbH9P7ZEnBAgHUZVO4OQsBODXCbxNcZkTJNDCzFbl9o+yd+tDFn4h4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=e6HMrvPi; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=content-transfer-encoding:from:mime-version:subject:date:
   message-id:references:cc:in-reply-to:to;
  bh=anlUiHWGDGyJ8xswjmMdLXKoB6PZ+VXioMuGFa77dbg=;
  b=e6HMrvPibM0Fbpr/ONm0hFVcMKT8wC0+mQJzKmTLL/6XVEyPLKe8HZWV
   9C9LRPkcO6Hd6rCjzjqag+sCK6WeODO+KGVznFmYkAs5A6UnqgiSZB6Nc
   xXNWMuA+9KGLx3MmUi1yOamiphAXkkAK5LOz38Lay2oYzEJOtPfPHDOwT
   E=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.12,159,1728943200"; 
   d="scan'208";a="101793166"
Received: from 105.39.22.93.rev.sfr.net (HELO smtpclient.apple) ([93.22.39.105])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2024 12:24:33 +0100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Julia Lawall <Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 05/21] powerpc/papr_scm: Convert timeouts to secs_to_jiffies()
Date: Sat, 16 Nov 2024 06:24:20 -0500
Message-Id: <272B86FC-5CC9-4A3A-ACE0-F268E4E61C3D@inria.fr>
References: <e4872a15-ff3d-4619-9b03-c7f0b6230934@stanley.mountain>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
 Easwar Hariharan <eahariha@linux.microsoft.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Nicolas Palix <nicolas.palix@imag.fr>, Daniel Mack <daniel@zonque.org>,
 Haojian Zhuang <haojian.zhuang@gmail.com>,
 Robert Jarzmik <robert.jarzmik@free.fr>,
 Russell King <linux@armlinux.org.uk>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Ofir Bitton <obitton@habana.ai>,
 Oded Gabbay <ogabbay@kernel.org>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?utf-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jeroen de Borst <jeroendb@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Louis Peens <louis.peens@corigine.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-scsi@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 linux-mm@kvack.org, linux-bluetooth@vger.kernel.org,
 linux-staging@lists.linux.dev, linux-rpi-kernel@lists.infradead.org,
 ceph-devel@vger.kernel.org, live-patching@vger.kernel.org,
 linux-sound@vger.kernel.org, etnaviv@lists.freedesktop.org,
 oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org,
 Anna-Maria Behnsen <anna-maria@linutronix.de>
In-Reply-To: <e4872a15-ff3d-4619-9b03-c7f0b6230934@stanley.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
X-Mailer: iPhone Mail (21E236)


Sent from my iPhone

> On 16 Nov 2024, at 05:40, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>=20
> =EF=BB=BFOn Sat, Nov 16, 2024 at 11:06:55AM +0100, Christophe Leroy wrote:=

>>> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/pl=
atforms/pseries/papr_scm.c
>>> index 9e297f88adc5d97d4dc7b267b0bfebd58e5cf193..9e8086ec66e0f0e555ac2793=
3854c06cfcf91a04 100644
>>> --- a/arch/powerpc/platforms/pseries/papr_scm.c
>>> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
>>> @@ -543,7 +543,7 @@ static int drc_pmem_query_health(struct papr_scm_pri=
v *p)
>>>=20
>>>         /* Jiffies offset for which the health data is assumed to be sam=
e */
>>>         cache_timeout =3D p->lasthealth_jiffies +
>>> -               msecs_to_jiffies(MIN_HEALTH_QUERY_INTERVAL * 1000);
>>> +               secs_to_jiffies(MIN_HEALTH_QUERY_INTERVAL);
>>=20
>> Wouldn't it now fit on a single line ?
>>=20
>=20
> Some maintainers still prefer to put a line break at 80 characters. =20

Coccinelle tries for 80 chars. It may have a command line option to specify s=
omething else.

Julia

> It's kind
> of a nightmare for an automated script like this to figure out everyone's
> preferences.  In this particular
> file, there are some lines which go over 80
> characters so sure.  Earlier in the patchset one of these introduced a lin=
e
> break that wasn't there before so I think maybe Coccinelle is applying the=
 80
> character line break rule?
>=20
> There are sometimes where the 80 character rule really hurts readability, b=
ut
> here it doesn't make any difference.
>=20
> regards,
> dan carpenter
>=20


