Return-Path: <live-patching+bounces-778-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 499759CF76F
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 22:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD10B1F22E12
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 21:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9C51FB73D;
	Fri, 15 Nov 2024 21:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="I95I66Jg"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7971F80C4;
	Fri, 15 Nov 2024 21:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705769; cv=none; b=kZNJn1KzDIROV3JlcQWRbUS1OMMhRB7WA34sQ9fQ8oOHEahp5Ih0ljxBLru9R6W64dxXhwDIvZ+4tPU/nmagncQNM6IXYlNi5XuLpNjvx+gaJfzXusYO5bIIU6lb5O1paGu/W43wUQNkkynkeSSauhdhpZD3xBnoRSqirWAYYtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705769; c=relaxed/simple;
	bh=gIIQWvXHtLzUIAAb3OIDcfqhrcTMRRZKrU+eLUg68VA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mWIet6QzZQ7UzG3eY+mjl5ZcRmRMkWH2FB5Ulh19eeZTZvacRJDMA4vaQGJ6eudFziV9LGrNz2kiUpeqb8n/nNfxznTPPIG1n8rM9l/7MhfmIXYgeHEDPEcQkKpFVSlpKp10eVIhf+3lJlYFDI6i0QCmbPwTqyCyDNb7RZvq7GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=I95I66Jg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5C04E206BCEA;
	Fri, 15 Nov 2024 13:22:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5C04E206BCEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731705763;
	bh=QYs6jKNkSqRMwxas8zTGS0f9EDen03tWxmE1GsbmPvQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=I95I66JgO1E7XQYaEm7ineOx+2MkduTJSN9e4D1cu0/NE7dcCwPndmzh7i/cNGesc
	 2yzIBCvlbGPZzvMpNA+k96a1ZOGXJ+A0bPOMF6Lmuw/xKRtew/BB44Qgm554Xu3M7K
	 XgYk3aN7aTdB7omQICy4E1708sGRqDk4h4Xf8u4c=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Fri, 15 Nov 2024 21:22:37 +0000
Subject: [PATCH 07/22] accel/habanalabs: Convert timeouts to
 secs_to_jiffies()
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-converge-secs-to-jiffies-v1-7-19aadc34941b@linux.microsoft.com>
References: <20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com>
In-Reply-To: <20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, 
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
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
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
 =?utf-8?q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
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
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>
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
 linuxppc-dev@lists.ozlabs.org, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Easwar Hariharan <eahariha@linux.microsoft.com>
X-Mailer: b4 0.14.2

Changes made with the following Coccinelle rules:

@@ constant C; @@

- msecs_to_jiffies(C * 1000)
+ secs_to_jiffies(C)

@@ constant C; @@

- msecs_to_jiffies(C * MSEC_PER_SEC)
+ secs_to_jiffies(C)

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 drivers/accel/habanalabs/common/device.c         | 2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/habanalabs/common/device.c b/drivers/accel/habanalabs/common/device.c
index e0cf3b4343bb081638430f2552ed27431b488ff9..30277ae410d4b742ffb7bddc35498564ff96fe62 100644
--- a/drivers/accel/habanalabs/common/device.c
+++ b/drivers/accel/habanalabs/common/device.c
@@ -817,7 +817,7 @@ static void device_hard_reset_pending(struct work_struct *work)
 		}
 
 		queue_delayed_work(hdev->reset_wq, &device_reset_work->reset_work,
-					msecs_to_jiffies(HL_PENDING_RESET_PER_SEC * 1000));
+					secs_to_jiffies(HL_PENDING_RESET_PER_SEC));
 	}
 }
 
diff --git a/drivers/accel/habanalabs/common/habanalabs_drv.c b/drivers/accel/habanalabs/common/habanalabs_drv.c
index 708dfd10f39c584a6221c29015f4b0323574145a..5ec13f3a46f915e75b04582b28d51ba8bb50be78 100644
--- a/drivers/accel/habanalabs/common/habanalabs_drv.c
+++ b/drivers/accel/habanalabs/common/habanalabs_drv.c
@@ -362,8 +362,7 @@ static void fixup_device_params_per_asic(struct hl_device *hdev, int timeout)
 		 * a different default timeout for Gaudi
 		 */
 		if (timeout == HL_DEFAULT_TIMEOUT_LOCKED)
-			hdev->timeout_jiffies = msecs_to_jiffies(GAUDI_DEFAULT_TIMEOUT_LOCKED *
-										MSEC_PER_SEC);
+			hdev->timeout_jiffies = secs_to_jiffies(GAUDI_DEFAULT_TIMEOUT_LOCKED);
 
 		hdev->reset_upon_device_release = 0;
 		break;

-- 
2.34.1


