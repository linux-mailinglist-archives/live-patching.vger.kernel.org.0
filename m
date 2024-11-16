Return-Path: <live-patching+bounces-827-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C509CFCD4
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 07:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6376F285093
	for <lists+live-patching@lfdr.de>; Sat, 16 Nov 2024 06:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8A01925B8;
	Sat, 16 Nov 2024 06:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="mL98MjzV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4802E18D625;
	Sat, 16 Nov 2024 06:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731737173; cv=none; b=MhxAwLJ2c1bpXvkXFyPUWLWbMk5H5y/haIGtdEYd4iQbAknb+GSEMQYasmbp78A3RjR1TsJS8jXUngAPyDURDY8Pk7ra7nm+Cs1Jz3ynDnGsIa5S5mYGkV7T2ivR44KEYdEB7TSMYVtTqMG0oQ2QpvNVj0t7nwxikF6VxcjDEl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731737173; c=relaxed/simple;
	bh=pH1vRRZ7ypbK8ig19ve8VTJ681CoPKnEt+e4Gii8zqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5Xy6Fwq6+crFGvk27H3N5sGM046RWmreh5emx+b7pPCAl9NcnhggLl1ZJYsnJ1/RX2LhebezU6rBNhL5H5fP1SKd7QcdIkgh92pGJWHDDXrb8SQMfX2dXOlvZI9bBre535hjVqQ7MomH0oCUDkGS+a8+FD6dG5vhxMEF8n5uZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=mL98MjzV; arc=none smtp.client-ip=80.12.242.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id CBwItlkEVyQmhCBwItrt0n; Sat, 16 Nov 2024 07:06:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731737162;
	bh=1GOO379j5kHelQgT13xeDCIW+pFPJCeiM7WSIuvag78=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=mL98MjzVZSShtzisX9zbjDjIb7KE72buAzIx9jorkgCEIlxacBGBiKDqnznYupede
	 vEhaEvssP8Otw+abSwd4UipThVl5qw3v6w8RixuAXgrl/p9FBRiYmldRfZZljgK0OD
	 FX0UB9px2S9OjhfpAHnQggpK1elWNH8UBNVIvO5x+AsAiYtyf4oGwInz8jFtqh7DDu
	 OMNwG4GURPpChqfcVzLVhpacwz+NEqWf9xIvmwF/gxmCGy7nRrRkaf4TeGrlu6c0Ll
	 o9NHONgP90fIf7c6ZsyFFLJ/v2i9NFywx5+jxHfxBiA3eBfpU5DKAu5obNXbrUQywu
	 rI95zY+eQlUcg==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 16 Nov 2024 07:06:02 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: eahariha@linux.microsoft.com
Cc: James.Bottomley@HansenPartnership.com,
	Julia.Lawall@inria.fr,
	agordeev@linux.ibm.com,
	airlied@gmail.com,
	akpm@linux-foundation.org,
	andrew+netdev@lunn.ch,
	anna-maria@linutronix.de,
	ath11k@lists.infradead.org,
	axboe@kernel.dk,
	bcm-kernel-feedback-list@broadcom.com,
	borntraeger@linux.ibm.com,
	catalin.marinas@arm.com,
	ceph-devel@vger.kernel.org,
	christian.gmeiner@gmail.com,
	christophe.leroy@csgroup.eu,
	cocci@inria.fr,
	coreteam@netfilter.org,
	daniel@zonque.org,
	davem@davemloft.net,
	dick.kennedy@broadcom.com,
	dri-devel@lists.freedesktop.org,
	edumazet@google.com,
	etnaviv@lists.freedesktop.org,
	florian.fainelli@broadcom.com,
	gor@linux.ibm.com,
	gregkh@linuxfoundation.org,
	haojian.zhuang@gmail.com,
	hca@linux.ibm.com,
	horms@kernel.org,
	idryomov@gmail.com,
	intel-xe@lists.freedesktop.org,
	james.smart@broadcom.com,
	jeroendb@google.com,
	jikos@kernel.org,
	jinpu.wang@cloud.ionos.com,
	jjohnson@kernel.org,
	joe.lawrence@redhat.com,
	johan.hedberg@gmail.com,
	jpoimboe@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	kvalo@kernel.org,
	l.stach@pengutronix.de,
	linux+etnaviv@armlinux.org.uk,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rpi-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux@armlinux.org.uk,
	linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org,
	louis.peens@corigine.com,
	lucas.demarchi@intel.com,
	luiz.dentz@gmail.com,
	maarten.lankhorst@linux.intel.com,
	maddy@linux.ibm.com,
	marcel@holtmann.org,
	martin.petersen@oracle.com,
	mbenes@suse.cz,
	mpe@ellerman.id.au,
	mripard@kernel.org,
	naveen@kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	nicolas.palix@imag.fr,
	npiggin@gmail.com,
	obitton@habana.ai,
	ogabbay@kernel.org,
	oss-drivers@corigine.com,
	pabeni@redhat.com,
	pablo@netfilter.org,
	perex@perex.cz,
	pkaligineedi@google.com,
	pmladek@suse.com,
	rjui@broadcom.com,
	robert.jarzmik@free.fr,
	rodrigo.vivi@intel.com,
	roger.pau@citrix.com,
	sbranden@broadcom.com,
	shailend@google.com,
	simona@ffwll.ch,
	svens@linux.ibm.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.com,
	tzimmermann@suse.de,
	xen-devel@lists.xenproject.org,
	xiubli@redhat.com
Subject: Re: [PATCH v2 02/21] coccinelle: misc: Add secs_to_jiffies script
Date: Sat, 16 Nov 2024 07:05:40 +0100
Message-ID: <20241116060541.5798-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115-converge-secs-to-jiffies-v2-2-911fb7595e79@linux.microsoft.com>
References: <20241115-converge-secs-to-jiffies-v2-2-911fb7595e79@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 15/11/2024 à 22:26, Easwar Hariharan a écrit :
> Suggested-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> ---
>   scripts/coccinelle/misc/secs_to_jiffies.cocci | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/scripts/coccinelle/misc/secs_to_jiffies.cocci b/scripts/coccinelle/misc/secs_to_jiffies.cocci
> new file mode 100644
> index 0000000000000000000000000000000000000000..af762b1c0aac8f044f21150bfaafd9efc834ee87
> --- /dev/null
> +++ b/scripts/coccinelle/misc/secs_to_jiffies.cocci
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +///
> +/// Find usages of:
> +/// - msecs_to_jiffies(value*1000)
> +/// - msecs_to_jiffies(value*MSEC_PER_SEC)
> +///
> +// Confidence: High
> +// Copyright: (C) 2024 Easwar Hariharan Microsoft
> +//
> +// Keywords: secs, seconds, jiffies
> +//
> +
> +@@ constant C; @@
> +
> +- msecs_to_jiffies(C * 1000)
> ++ secs_to_jiffies(C)
> +
> +@@ constant C; @@
> +
> +- msecs_to_jiffies(C * MSEC_PER_SEC)
> ++ secs_to_jiffies(C)
> 
Hi,

	@@ constant C =~ "000"; @@

	* msecs_to_jiffies(C)

also spots things like msecs_to_jiffies(1000)

I'm not sure that coccinelle is enable to capture part of the regex to automate the removal of the 000 when converting from ms to s.

Just my 2c,

CJ

