Return-Path: <live-patching+bounces-1846-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB89C54D6B
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 06EEF4E2148
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19DD2E975E;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlN4ilIo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAB92E2EEE;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762991279; cv=none; b=ZSUFzGqYh4cxOLTA/8PH96RRyr1y+kc7q2NnE+/uYoQvxr7vvDk13suJ2vaaHKTHJHjJSK1AlHsKunbtXa9O8ejz7EyRVV3TCNC+yta9Jw/GcM2kNCoEMVoss+YHrcsitcXaG0s/dnB3Vnh/rQZucrdmKEhP8pJ3/sOHdSsLIe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762991279; c=relaxed/simple;
	bh=fZMNYLKw/ZIEvpddN2qoyiEVLFxO+JC5Rp24YJvJXx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYxWTgXov7XmCygVMsnbaF7Fxu69Vz8AKtu3vK4RAZV4vIxjZvqkPPe8uhlBexSBi6dpYLpVpuRCXKjkt2OhVx4WawhPH7O+C/gr89LFU4jfzLP+7KtJG299jfnJwFzdhJaf0NC9Z/3o/cNTaYy+qChVT9+h+qhPlYoqdUoHlZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlN4ilIo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18240C4CEF8;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762991279;
	bh=fZMNYLKw/ZIEvpddN2qoyiEVLFxO+JC5Rp24YJvJXx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlN4ilIoK2f1x4X5ScugHz9euMIL/gdGCYIKpbz1p0+XykN2t01HFvOUfvmZ7SDVE
	 cE6qWt+dL98jG7xvz8t1Q2Jo3sCbRvfzbhxQ4lkZLPUBxEbHMPFp4aI4REtGDA+vq7
	 H/V25E+b1Ft3r6kMSUOuzJWcNfFH2kZ3wSQ2mdDWCk/lpqY1Mibqqv0Kv4tqFeShq3
	 uM1ADcX7+5QIJdQiF2bJzyrHF0tBomxnRUhitLrTvmwjGydpXlv8NimqcaNQoup7c6
	 Hwp0/ukunvMkMj0K3S+D6jyKSA9up5OOq5fnXCN9Or5wBEEMINCMBwCcoih4yQ+mcs
	 GvHAQlwuNVvyA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/4] media: atomisp: Fix startup() section placement with -ffunction-sections
Date: Wed, 12 Nov 2025 15:47:49 -0800
Message-ID: <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1762991150.git.jpoimboe@kernel.org>
References: <cover.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling the kernel with -ffunction-sections (e.g., for LTO,
livepatch, dead code elimination, AutoFDO, or Propeller), the startup()
function gets compiled into the .text.startup section.  In some cases it
can even be cloned into .text.startup.constprop.0 or
.text.startup.isra.0.

However, the .text.startup and .text.startup.* section names are already
reserved for use by the compiler for __attribute__((constructor)) code.

This naming conflict causes the vmlinux linker script to wrongly place
startup() function code in .init.text, which gets freed during boot.

Fix that by renaming startup() to ov2722_startup().

Cc: Hans de Goede <hansg@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from TEXT_MAIN")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index c7de7800799a..a4519babf37d 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -600,7 +600,7 @@ static int ov2722_s_power(struct v4l2_subdev *sd, int on)
 }
 
 /* TODO: remove it. */
-static int startup(struct v4l2_subdev *sd)
+static int ov2722_startup(struct v4l2_subdev *sd)
 {
 	struct ov2722_device *dev = to_ov2722_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -662,7 +662,7 @@ static int ov2722_set_fmt(struct v4l2_subdev *sd,
 	dev->pixels_per_line = dev->res->pixels_per_line;
 	dev->lines_per_frame = dev->res->lines_per_frame;
 
-	ret = startup(sd);
+	ret = ov2722_startup(sd);
 	if (ret) {
 		int i = 0;
 
@@ -677,7 +677,7 @@ static int ov2722_set_fmt(struct v4l2_subdev *sd,
 				dev_err(&client->dev, "power up failed, continue\n");
 				continue;
 			}
-			ret = startup(sd);
+			ret = ov2722_startup(sd);
 			if (ret) {
 				dev_err(&client->dev, " startup FAILED!\n");
 			} else {
-- 
2.51.1


