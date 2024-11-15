Return-Path: <live-patching+bounces-822-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3351A9CFADA
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 00:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ECFCB39A5C
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 22:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC827192B6D;
	Fri, 15 Nov 2024 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="dvqBU9n8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64561922F2;
	Fri, 15 Nov 2024 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731710303; cv=none; b=HhfHsmArJNanRAUmijSLAIvEcCP1HFP59q11rn84rq5oasfJItCfWUJjilMH8AaGzz1aYIAfHgTC5Y77UKbzZlVsGy1F6PD709TbzpyGHkQbdLCfzOhiF02SsHyipazFmf+IqGGVYmYor6Wi5tEuC6nYhLcbtNkBrXNVNL9Lm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731710303; c=relaxed/simple;
	bh=RIiFqJrXkrJVjomDZYuASdyvOtyrcrIuEW8LyVF0TSA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kzuta5QUxcyt4z5kO5d3RniH9lqVO4O34pKdRr+VMtDDY9jFnus1j+L8Sbrkxf6NoPp8gXlV0EDBTJ1hspXBp46tyededWFk0tnmIN1MiFWvmLwPTefZYfUXMQEJgS33zzyb+z952z8RSPgygJkJlN2iyiy4gudz2L31v+8soQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=dvqBU9n8; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1731710297;
	bh=2Oo8tuThL69UywoHNtNWphGeN1l/Ks7ZdfhLn6nu8Ts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dvqBU9n8wyesGOM7wAJUVL4V50umalSR9AGyHvO50R9rHL4dRlvqV2fKiGIxclon7
	 dHEpXPpW9NVhcbFtMBHzRNkcGVSkeVB/y2szbGMNYINCZkHzmLDf1115Jxe24OTeOk
	 GNv8daj8Y6W/lBqt6k/toExNrcSvGF2/nzg0QTmOQX9jzDpl13KzERpvnsypqwk14l
	 Jr2Y6hhhHGQcduaub5tIB8ldj0pYnhXmYJw4zK368Q9lExm0iQorTgylYyIdDuEGMp
	 WagrfQz4Kwg8LTMJpR3GyN8L1t3g91kYKCDixQ+vf1WORv4sLKKi8JfCCFjRz+Eeni
	 +eMZUx+2BK6mA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XqsP22nY1z4x8v;
	Sat, 16 Nov 2024 09:38:14 +1100 (AEDT)
Date: Sat, 16 Nov 2024 09:38:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
 <kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Julia Lawall
 <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, Daniel Mack
 <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert
 Jarzmik <robert.jarzmik@free.fr>, Russell King <linux@armlinux.org.uk>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Ofir
 Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>, Lucas De
 Marchi <lucas.demarchi@intel.com>, Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=
 <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jeroen de Borst
 <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 James Smart <james.smart@broadcom.com>, Dick Kennedy
 <dick.kennedy@broadcom.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Roger Pau =?UTF-8?B?TW9ubsOp?=
 <roger.pau@citrix.com>, Jens Axboe <axboe@kernel.dk>, Kalle Valo
 <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jack
 Wang <jinpu.wang@cloud.ionos.com>, Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz
 <luiz.dentz@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Florian Fainelli <florian.fainelli@broadcom.com>, Ray Jui
 <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, Broadcom
 internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Xiubo
 Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, Lucas Stach <l.stach@pengutronix.de>, Russell King
 <linux+etnaviv@armlinux.org.uk>, Christian Gmeiner
 <christian.gmeiner@gmail.com>, Louis Peens <louis.peens@corigine.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao
 <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
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
 linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen
 <anna-maria@linutronix.de>
Subject: Re: [PATCH 03/22] arm: pxa: Convert timeouts to use
 secs_to_jiffies()
Message-ID: <20241116093815.5d37eb43@canb.auug.org.au>
In-Reply-To: <20241115-converge-secs-to-jiffies-v1-3-19aadc34941b@linux.microsoft.com>
References: <20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com>
	<20241115-converge-secs-to-jiffies-v1-3-19aadc34941b@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4rVE82Kt6y+3_PbwMmwogMj";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/4rVE82Kt6y+3_PbwMmwogMj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Easwar,

On Fri, 15 Nov 2024 21:22:33 +0000 Easwar Hariharan <eahariha@linux.microso=
ft.com> wrote:
>
> -#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (msecs_to_jiffies(1*60*10=
00))  /* 1 min */
> -#define SHARPSL_CHARGE_FINISH_TIME             (msecs_to_jiffies(10*60*1=
000)) /* 10 min */
> -#define SHARPSL_BATCHK_TIME                    (msecs_to_jiffies(15*1000=
))    /* 15 sec */
> +#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (secs_to_jiffies(60))  /*=
 1 min */
> +#define SHARPSL_CHARGE_FINISH_TIME             (secs_to_jiffies(10*60)) =
/* 10 min */
> +#define SHARPSL_BATCHK_TIME                    (secs_to_jiffies(15))    =
/* 15 sec */

It might be nice to keep the alignment of the comments here.

--=20
Cheers,
Stephen Rothwell

--Sig_/4rVE82Kt6y+3_PbwMmwogMj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmc3zVcACgkQAVBC80lX
0GyUXgf+Ii9yOHf1vRadjfzExIFyJR4I0mG1VXDEBH24ASdL/jVIFlfW31h/JIe9
7JJFAL5Aa+C8Xw22mmq/8e0wbWCe+DqEq+SLtggkTN8kHtwf7Glda0a/aIix0pNM
s9nQXwrTFFvaCt2ocRmPUcm7K/jwiG3YxWawYBvIoSF9l/TfQXwD4LBbP2glFEL2
BkTvGG0/asLCHZK2LHwDsWsZ5XskgJmmQfbYEdygcm9C3bP40tFYUM22B6iEYNez
WKquyY7lAmwUJQsIAWZig/PKPz8e6uux6ghIdGbwFC0ezQqIOAz8ZqllWy1Dpa87
vCjZSu4lRCFBg5npBBL5wIOagKFSCw==
=vmyn
-----END PGP SIGNATURE-----

--Sig_/4rVE82Kt6y+3_PbwMmwogMj--

