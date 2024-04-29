Return-Path: <live-patching+bounces-229-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB648B5252
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2024 09:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C5841F21ACB
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2024 07:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE09013AEE;
	Mon, 29 Apr 2024 07:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3d18lRD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662D134BE;
	Mon, 29 Apr 2024 07:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714375621; cv=none; b=gCfC6brGos7oKkhpsobll1OJC13iVU7tbB+LJXK+tjdES7acyBNsZ0Cs6bu4ZEFIJlp2RNRwRhSSLvmMLU5NidUHfTnOCSA47L0W0H9XFnxAPXdf3Gg3WqKkDu51IQz5M6j9f+ttaFlYmY0Qoxpen/aescNt9HwQetx1EDlWEnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714375621; c=relaxed/simple;
	bh=tUY7YOGv15eW67rwM1O0QPfv5E+4gJOUvH80Wpnfxu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bMSqELQR9Qod3gH27vEkM0KAOSngpmtzko5VnPhs49giFeZS20aR7h7zamUpPYwXFLhnPHCG6Z9OmGwJ+0UHaQg11y/8EOKTExU18hS3rB9dgPsA1l8j2oNzwEKHYBjz/KrOSxrhQyV+OAJzI7/Q5xS6LQ8H92WBO2iDgaBu1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3d18lRD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1eb24e3a2d9so20447405ad.1;
        Mon, 29 Apr 2024 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714375619; x=1714980419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=plE/4ftCE6lXuzJzPfSuImu38o2csfGGp934wr7ZOZQ=;
        b=l3d18lRDhwZJSX9Y5FZc2zV+HaMTg/IJa1wOiuYyUsSiLjbp4pEw9oxGjaLddVvfoZ
         NEqIckxUcCbaINhTFwtBW3ovHHVXy14Qfju0x9jhZB+AZ/RCtRLSnpx3nOMDyKMjwrab
         OCxxfsMCMkfKnif99MprBXnY+wa35EvCSjAEA4HQ2NcZyViY90FyN+rqqtLb2W1dOOz2
         yRQPNNFS8MdYYwMejUGoZB877K+DcyvAWhinCEyfbZBzcpRPpJ10fxKML6h8GcNkI6yF
         TSPKnayJU2QukDcvtd2KI61GoHM+CNQtPilMNSkU4abdsxAInHrT1oby12AM3llw/H5Q
         5WQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714375619; x=1714980419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=plE/4ftCE6lXuzJzPfSuImu38o2csfGGp934wr7ZOZQ=;
        b=kqQlPiQRzbfm8CNmh4ghzKFRM/zdin7JX/MAyJ5sg1XwhQUwSyEQMQWCWsrpgkehkJ
         TArIPmXjdR8P4RB9cRNPvO7ay8r7HQU3A5n+tmBvJcZ9IZ4TKSIgdOkCboMOPNNxIMvq
         ZI5xpa6RXVuCMUuCEyZMO/bkGSpMwqnvsf5AHCPCRE+BPWPoAFtC/EOfDMaoG5lzcEhp
         JbLSz2n1OtMvFelu2U2YHiiYE6qaJobfmTMdI6IGlT8Y7dVAhtRHryTNt6dpKfl9Dw0q
         DJcEWdHr58SnXbTflz84MeU3IJi5rqbZ/fdds/Fx0d6FaDtdlcu004TLG3v0NukbGYL3
         DJcg==
X-Forwarded-Encrypted: i=1; AJvYcCVLMyej410Xk1rQK+T7W7vUdpnXDbjlaNG+VrPGgs+HTAFwzC169XUaGKE0d8asfbEgqBsP1n7rzkHUt378GaeX4gyaf5FDw02tVETe
X-Gm-Message-State: AOJu0Yw92M8AbypQaMmAo0P2md9GiYTMsvHoEZOe2R8g4olNJMKGlDfu
	3qaFtd3xA5HxjtchewmDVikEVTaYTmlv5CeMnyI1LYV4sfdAghDh
X-Google-Smtp-Source: AGHT+IFiTLs7V33QGQDaRhhm84AqOkJ7ce+sgAj/vEOsSn7h1vOnU8/cr7FY+Qp7x9nr9JMzqGfKcg==
X-Received: by 2002:a17:902:7809:b0:1e4:19e3:56cb with SMTP id p9-20020a170902780900b001e419e356cbmr11933122pll.12.1714375619542;
        Mon, 29 Apr 2024 00:26:59 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b001eac9aa55edsm6928331plh.250.2024.04.29.00.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 00:26:59 -0700 (PDT)
From: zhangwarden@gmail.com
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] livepatch.h: Add comment to klp transition state
Date: Mon, 29 Apr 2024 15:26:28 +0800
Message-Id: <20240429072628.23841-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

livepatch.h use KLP_UNDEFINED\KLP_UNPATCHED\KLP_PATCHED for klp transition state.
When livepatch is ready but idle, using KLP_UNDEFINED seems very confusing.
In order not to introduce potential risks to kernel, just update comment
to these state.
---
 include/linux/livepatch.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9b9b38e89563..b6a214f2f8e3 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -18,9 +18,9 @@
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
 /* task patch states */
-#define KLP_UNDEFINED	-1
-#define KLP_UNPATCHED	 0
-#define KLP_PATCHED	 1
+#define KLP_UNDEFINED	-1 /* idle, no transition in progress */
+#define KLP_UNPATCHED	 0 /* transitioning to unpatched state */
+#define KLP_PATCHED	 1 /* transitioning to patched state */
 
 /**
  * struct klp_func - function structure for live patching
-- 
2.37.3


