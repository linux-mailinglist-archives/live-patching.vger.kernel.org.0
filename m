Return-Path: <live-patching+bounces-1853-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD0DC5600A
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 08:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 37F29349DB2
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 07:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A929320A24;
	Thu, 13 Nov 2025 07:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pK8oghal";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8OgYPKFo"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB33164B1;
	Thu, 13 Nov 2025 07:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763017739; cv=none; b=WIVUWaSRlpMtvEaHas4CovOANWR6Jn9NNyp9ZbLzGIRzABEE4GB1ErUR3Tg+Kj1AWTng4miJGesWB94jbExZ+LYQ+oeBouJwDOIZouyogB0ExpqEGDKTdklLRTPLwae1+kGkP1ZeKLJaEoJxvg1H3W4jyZj5Ppdij3qgdf2CTmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763017739; c=relaxed/simple;
	bh=3ITqbNi6BIsjwY57TvFcHsoK2z0STnsD20KEehCjfJY=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=kAiYkL8ywv2I2UiUrCZO2iOIaPgQue6zIg6xKkfs5N63Co2YL2ibTvtsV+kuzsP0Vj54T1nD3umC0Gc+Wd6AAaTBmKBaLv0SN9c4DZwEzH3xj4rbtCp672YCyBg4/n+cmvvA4tRUqjfSJyFMYVLFFAOWELicPXxsbmL/EG51skQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=pK8oghal; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8OgYPKFo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 13 Nov 2025 07:08:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1763017736;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Te4R8eqe0t6nkVesxxcJnOXo+ibkHEErLLxCSyonxY0=;
	b=pK8oghalTccyr9VwYURoDayo19DgBhYEP0VWLWGLtea/c4SefHvENKhCCmsMbXLCZZE6uX
	ng0XTJZfs3xULuA26UeJeNVOA2LE4/y+oA8Yubxmq0e/Kml8doLrA2IAo9orQIEF4m8PHQ
	SXBXXBsypJPsxBUZkALxpjYIgfdPS4xBsfPw4G4XCYkjMVc+FaE1Nl+rXzeW4hJXCgBvjv
	8oE1+anj8Io7ysl5mQqI7zQGmLPsbbl0BFXXztLDUMJjP6ksjVZm6CnWGKI9rFhKxTRW2m
	CIIBkYzXYJ04We8yb7yLK4pjREjQEjWpa/9qTqekmPVBKZgFT6OMKtUwUgC1Lw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1763017736;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Te4R8eqe0t6nkVesxxcJnOXo+ibkHEErLLxCSyonxY0=;
	b=8OgYPKFoR9LOcByIMp1dAjjpZaPC6e3M7rbRi1tuUc7dTHlp9ZDRff3PZdXteMCfhXflcu
	8XsYS1gipFwF18Cw==
From: "tip-bot2 for Josh Poimboeuf" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] media: atomisp: Fix namespace collision and
 startup() section placement with -ffunction-sections
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
 Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To:
 <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
References:
 <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <176301773508.498.649743525159101504.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     56255fa96871d3bd0d924a53585cdf5594262891
Gitweb:        https://git.kernel.org/tip/56255fa96871d3bd0d924a53585cdf55942=
62891
Author:        Josh Poimboeuf <jpoimboe@kernel.org>
AuthorDate:    Wed, 12 Nov 2025 15:47:49 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 13 Nov 2025 08:03:09 +01:00

media: atomisp: Fix namespace collision and startup() section placement with =
-ffunction-sections

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

Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from =
TEXT_MAIN")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org
Cc: Hans de Goede <hansg@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/bf8cd823a3f11f64cc82167913be5013c72afa57.17629=
91150.git.jpoimboe@kernel.org
---
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/sta=
ging/media/atomisp/i2c/atomisp-ov2722.c
index c7de780..a4519ba 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -600,7 +600,7 @@ static int ov2722_s_power(struct v4l2_subdev *sd, int on)
 }
=20
 /* TODO: remove it. */
-static int startup(struct v4l2_subdev *sd)
+static int ov2722_startup(struct v4l2_subdev *sd)
 {
 	struct ov2722_device *dev =3D to_ov2722_sensor(sd);
 	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
@@ -662,7 +662,7 @@ static int ov2722_set_fmt(struct v4l2_subdev *sd,
 	dev->pixels_per_line =3D dev->res->pixels_per_line;
 	dev->lines_per_frame =3D dev->res->lines_per_frame;
=20
-	ret =3D startup(sd);
+	ret =3D ov2722_startup(sd);
 	if (ret) {
 		int i =3D 0;
=20
@@ -677,7 +677,7 @@ static int ov2722_set_fmt(struct v4l2_subdev *sd,
 				dev_err(&client->dev, "power up failed, continue\n");
 				continue;
 			}
-			ret =3D startup(sd);
+			ret =3D ov2722_startup(sd);
 			if (ret) {
 				dev_err(&client->dev, " startup FAILED!\n");
 			} else {

