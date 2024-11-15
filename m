Return-Path: <live-patching+bounces-790-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 330169CF7DF
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 22:36:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6AB41F21745
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 21:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B54206509;
	Fri, 15 Nov 2024 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hyUr4x0S"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE71201103;
	Fri, 15 Nov 2024 21:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705777; cv=none; b=nWWz/u9THpWtyM6AqxLnFCVMSYXzjzfr8TU5KSG4fgZQixWCIp8OC5+LLwbK/AFSS29zCE/Snfz+87SpwJKCJowMTdGXYSuy8gnBb+Vn62XqKA/vSFlCiA8qTKvzHx0sSY1ZCzN/R2+Z+3CdOGz1lIlr9o5HQivD+r84ol2CJAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705777; c=relaxed/simple;
	bh=tmAYCWjhLkw5g/uSWwIrD4KksooU7OX7AbatcQXppIM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u06thyqKik7Zam3TBq7+4iM4OabbcbsxUqzEjoOnitEJ/lKux6xI+mfwLM8C2VYBPMmtuzgmj39Qobp/NIKZrks29wW9yOP4CjgUwz6wZua5D5gpXTpWC8JS2l7uQArabwjf97FMu5dTMIUj2AUXJ3MNktLhI/yOo6diIr4Nr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hyUr4x0S; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 06C52206BCEC;
	Fri, 15 Nov 2024 13:22:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 06C52206BCEC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731705766;
	bh=DChbJW+DaqGHGWE0sMF41tmxT4FReQ1FKA/KDyHL32Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hyUr4x0SmruhyF9c/vR8v3QoqKPaKNqXRHaN80CQA/ABgyerOHG1uC/FlE1BJG1ZJ
	 CRMPkjTTeOQg/xepSHO+SvOjz7TT6Fsw5oiwX3exTqn3S8Lu3Gz0gW082RgBKg6fy9
	 2WD2Rqjpa40SDuhEDGd3pTV1EDPYLPZRKnHzJ7/U=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Fri, 15 Nov 2024 21:22:49 +0000
Subject: [PATCH 19/22] livepatch: Convert timeouts to secs_to_jiffies()
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-converge-secs-to-jiffies-v1-19-19aadc34941b@linux.microsoft.com>
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
 samples/livepatch/livepatch-callbacks-busymod.c |  2 +-
 samples/livepatch/livepatch-shadow-fix1.c       |  2 +-
 samples/livepatch/livepatch-shadow-mod.c        | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
index 378e2d40271a9717d09eff51d3d3612c679736fc..d0fd801a7c21b7d7939c29d83f9d993badcc9aba 100644
--- a/samples/livepatch/livepatch-callbacks-busymod.c
+++ b/samples/livepatch/livepatch-callbacks-busymod.c
@@ -45,7 +45,7 @@ static int livepatch_callbacks_mod_init(void)
 {
 	pr_info("%s\n", __func__);
 	schedule_delayed_work(&work,
-		msecs_to_jiffies(1000 * 0));
+		secs_to_jiffies(0));
 	return 0;
 }
 
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 6701641bf12d454a770e49abeeb0dea92560e55e..948ea1f5760fed2fa27baf478c97cf98ad5c99a8 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -73,7 +73,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 		return NULL;
 
 	d->jiffies_expire = jiffies +
-		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
+		secs_to_jiffies(EXPIRE_PERIOD);
 
 	/*
 	 * Patch: save the extra memory location into a SV_LEAK shadow
diff --git a/samples/livepatch/livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-mod.c
index 7e753b0d2fa611524c9e2adbe02c8fa3e9b6015e..79296e6ccb119f521e86a121623855d841c9fc5e 100644
--- a/samples/livepatch/livepatch-shadow-mod.c
+++ b/samples/livepatch/livepatch-shadow-mod.c
@@ -102,7 +102,7 @@ static __used noinline struct dummy *dummy_alloc(void)
 		return NULL;
 
 	d->jiffies_expire = jiffies +
-		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
+		secs_to_jiffies(EXPIRE_PERIOD);
 
 	/* Oops, forgot to save leak! */
 	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
@@ -153,7 +153,7 @@ static void alloc_work_func(struct work_struct *work)
 	mutex_unlock(&dummy_list_mutex);
 
 	schedule_delayed_work(&alloc_dwork,
-		msecs_to_jiffies(1000 * ALLOC_PERIOD));
+		secs_to_jiffies(ALLOC_PERIOD));
 }
 
 /*
@@ -185,15 +185,15 @@ static void cleanup_work_func(struct work_struct *work)
 	mutex_unlock(&dummy_list_mutex);
 
 	schedule_delayed_work(&cleanup_dwork,
-		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
+		secs_to_jiffies(CLEANUP_PERIOD));
 }
 
 static int livepatch_shadow_mod_init(void)
 {
 	schedule_delayed_work(&alloc_dwork,
-		msecs_to_jiffies(1000 * ALLOC_PERIOD));
+		secs_to_jiffies(ALLOC_PERIOD));
 	schedule_delayed_work(&cleanup_dwork,
-		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
+		secs_to_jiffies(CLEANUP_PERIOD));
 
 	return 0;
 }

-- 
2.34.1


