Return-Path: <live-patching+bounces-888-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 064019EBC84
	for <lists+live-patching@lfdr.de>; Tue, 10 Dec 2024 23:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A67162344
	for <lists+live-patching@lfdr.de>; Tue, 10 Dec 2024 22:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8F023D404;
	Tue, 10 Dec 2024 22:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Q4SOEP0Y"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F80D2397B1;
	Tue, 10 Dec 2024 22:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733868165; cv=none; b=G4lwQw8GS+PuCiH5F4GjjKYN/ISgtAp5mW6l8OGdDKenjRgLzP/UsCemQKd8K19PFr+mNuTnoRzmIb+OL0AVeWKWSAE72v8uZn+qsX6Phw9VLwgg5ydAhbwYi168Jt4x00B8FfiFfEtJ/gWRqGNSom1BAI+F2BDuPdJpMHS7n90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733868165; c=relaxed/simple;
	bh=rtcpjXD/4KgBXkXpOwbxWNhqWuEIw5iVzq1KknY15jU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jqwdW1jRGxhIT8Phhyjp9XEmuFnDHpIasPI2UMZRaGLwN+ZslJ5MAj63stb+OaZQYZRqxH7pRxo+u9rS3llnetVHdZxjfu+bvDlc3anMdhWRSkqSu5OmKao73YeBeNNcXLJUGHM8ld1MxKsnkyYhxXcJnffAZBlThD4lXbKEzp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Q4SOEP0Y; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5C8092047227;
	Tue, 10 Dec 2024 14:02:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5C8092047227
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1733868156;
	bh=3tkOAM1zqG9JeFOtral7Lfs9u46U15/2RBF6sWmMcg4=;
	h=From:Subject:Date:To:Cc:From;
	b=Q4SOEP0Y7h5zO78UBiHUhYnGicCTwnpmdGyeJ2NXra3aSgp4pliiNVajI48sltiC5
	 krxOdne8IbeYxRwBBWcjRMbkm4dRwXWKZALmzr8Eqfc6Ado8XqXrVleqMCFQbV/jTu
	 DEly4DyEWnbV/UU33Q7NVotbdGyJFxTE5SxdsOl8=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: [PATCH v3 00/19] Converge on using secs_to_jiffies()
Date: Tue, 10 Dec 2024 22:02:31 +0000
Message-Id: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAHe6WGcC/42NwQ6CMBAFf4X0bAlbQFJP/ofxAO1W1ijVFhoM4
 d8tGONFE49vkjczMY+O0LNdMjGHgTzZLo58kzDV1t0JOem4mchEAQCCK9sFdJF7VJ73lp/JmGj
 gWkoNGWwbDcDi/ebQ0LiqD8fXdngfYqH/wJZ8b91jzQdY6LtU/i4F4BkHWdda5YUsoNlfqBvG9
 ErKWW9Nnyp7ZYs+iH+VIiolgGmqUpZYye/KeZ6fTjplmTIBAAA=
X-Change-ID: 20241112-converge-secs-to-jiffies-d99d1016bd11
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
 Takashi Iwai <tiwai@suse.com>, Louis Peens <louis.peens@corigine.com>, 
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
 oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Easwar Hariharan <eahariha@linux.microsoft.com>, 
 Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.2

This is a series that follows up on my previous series to introduce
secs_to_jiffies() and convert a few initial users.[1] In the review for
that series, Anna-Maria requested converting other users with
Coccinelle. [2] This is part 1 that converts users of msecs_to_jiffies()
that use the multiply pattern of either of:
- msecs_to_jiffies(N*1000), or
- msecs_to_jiffies(N*MSEC_PER_SEC)

where N is a constant, to avoid the multiplication.

The entire conversion is made with Coccinelle in the script added in
patch 2. Some changes suggested by Coccinelle have been deferred to
later parts that will address other possible variant patterns.

CC: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

[1] https://lore.kernel.org/all/20241030-open-coded-timeouts-v3-0-9ba123facf88@linux.microsoft.com/
[2] https://lore.kernel.org/all/8734kngfni.fsf@somnus/

---
Changes in v3:
- Rebase on next-20241210
- Fix typo'ed timeout in net/netfilter/nf_conntrack_proto_sctp.c (Stephen Rothwell)
- Use Coccinelle operation modes for Coccinelle script (Markus Elfring)
- Remove redundant comments in arch/arm/mach-pxa/sharpsl_pm.c
  (Christophe Leroy)
- Remove excess line breaks (Heiko Carstens, Christophe Leroy)
- Add more detail into the commit messages throughout (Christophe Leroy)
- Pick up Reviewed-by Thomas Hellström for drm/xe
- Drop drm/etnaviv patch already queued into etnaviv/next
- Replace call to [m]secs_to_jiffies(0) with just 0 for livepatch (Dan
  Carpenter, Christophe Leroy)
- Split out nfp patch to send to net-next (Christophe Leroy)
- Pick up Acked-by from Jeff Johnson for ath11k
- Link to v2: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com
Changes in v2:
- Exclude already accepted patch adding secs_to_jiffies() https://git.kernel.org/tip/b35108a51cf7bab58d7eace1267d7965978bcdb8
- Link to v1: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com

---
Easwar Hariharan (19):
      netfilter: conntrack: Cleanup timeout definitions
      coccinelle: misc: Add secs_to_jiffies script
      arm: pxa: Convert timeouts to use secs_to_jiffies()
      s390: kernel: Convert timeouts to use secs_to_jiffies()
      powerpc/papr_scm: Convert timeouts to secs_to_jiffies()
      mm: kmemleak: Convert timeouts to secs_to_jiffies()
      accel/habanalabs: Convert timeouts to secs_to_jiffies()
      drm/xe: Convert timeout to secs_to_jiffies()
      scsi: lpfc: Convert timeouts to secs_to_jiffies()
      scsi: arcmsr: Convert timeouts to secs_to_jiffies()
      scsi: pm8001: Convert timeouts to secs_to_jiffies()
      xen/blkback: Convert timeouts to secs_to_jiffies()
      gve: Convert timeouts to secs_to_jiffies()
      wifi: ath11k: Convert timeouts to secs_to_jiffies()
      Bluetooth: MGMT: Convert timeouts to secs_to_jiffies()
      staging: vc04_services: Convert timeouts to secs_to_jiffies()
      ceph: Convert timeouts to secs_to_jiffies()
      livepatch: Convert timeouts to secs_to_jiffies()
      ALSA: line6: Convert timeouts to secs_to_jiffies()

 arch/arm/mach-pxa/sharpsl_pm.c                     |  8 ++++----
 arch/powerpc/platforms/pseries/papr_scm.c          |  2 +-
 arch/s390/kernel/lgr.c                             |  2 +-
 arch/s390/kernel/time.c                            |  4 ++--
 arch/s390/kernel/topology.c                        |  2 +-
 drivers/accel/habanalabs/common/device.c           |  2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c   |  3 +--
 drivers/block/xen-blkback/blkback.c                |  2 +-
 drivers/gpu/drm/xe/xe_device.c                     |  2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  6 ++----
 drivers/net/wireless/ath/ath11k/debugfs.c          |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |  2 +-
 drivers/scsi/lpfc/lpfc_init.c                      | 18 +++++++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  8 ++++----
 drivers/scsi/lpfc/lpfc_nvme.c                      |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  4 ++--
 drivers/scsi/lpfc/lpfc_vmid.c                      |  2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |  2 +-
 .../vc04_services/bcm2835-audio/bcm2835-vchiq.c    |  2 +-
 fs/ceph/quota.c                                    |  2 +-
 mm/kmemleak.c                                      |  4 ++--
 net/bluetooth/mgmt.c                               |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            | 21 ++++++++-------------
 samples/livepatch/livepatch-callbacks-busymod.c    |  3 +--
 samples/livepatch/livepatch-shadow-fix1.c          |  3 +--
 samples/livepatch/livepatch-shadow-mod.c           | 15 +++++----------
 scripts/coccinelle/misc/secs_to_jiffies.cocci      | 22 ++++++++++++++++++++++
 sound/usb/line6/toneport.c                         |  2 +-
 28 files changed, 78 insertions(+), 71 deletions(-)
---
base-commit: 1b2ab8149928c1cea2d7eca30cd35bb7fe014053
change-id: 20241112-converge-secs-to-jiffies-d99d1016bd11

Best regards,
-- 
Easwar Hariharan <eahariha@linux.microsoft.com>


