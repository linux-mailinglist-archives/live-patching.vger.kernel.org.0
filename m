Return-Path: <live-patching+bounces-1235-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07BEA4732D
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 03:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D85F23B28D0
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 02:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A6413AA31;
	Thu, 27 Feb 2025 02:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OrHM7GJD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAE3137742
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 02:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740624474; cv=none; b=M7hzyGSfRUvHX7/GI/CqZ89r5I/vrNHmVzJulf1NPtviZbRyN9hWj9g8TzyAu2DpN/8EhjKjWUs/IUg6a1ocsCl0CSP+TYTuKUOATZcy9kwuSnvKJ9KKyC3CcghdJ++ODAcV7IhyWZzmVUTOmEGT45HDBoj0mENCxc5u3U4ItZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740624474; c=relaxed/simple;
	bh=z4WeWec5onOz0GyULUxJn8ppLCWKgFwNc0r+lEcc0pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f0afWC0wMkNPfv1M7oNwcH8X0pv3WxlRyracOkXozTJ12zXEUBKbWm7TCyUH3jsET4i2EIrjuzK5p/xO7O6WDtfse6TwWJGIy2cG2zWS2vGOuDowohHYgymAoIqA7z+CCiKbWA4UOADVaIOmItcF2DFtQ3mKKvS8UAPocT1lPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OrHM7GJD; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22334203781so19802185ad.0
        for <live-patching@vger.kernel.org>; Wed, 26 Feb 2025 18:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740624472; x=1741229272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufyJpXRplLa9hm9rmTP3gRUIzS6V2cY3a3pc+z2Os5c=;
        b=OrHM7GJDJVVW4nYEEnQobghEFHWieIUMoEJNyI5Pbgo9qfflpswHS0J0m77AesoJR6
         QW0Gn4b9iuAD0ldUKyR9TNiIeiDZSzC2JCFTBiOYgPzIriCxuyB+xUytJU2FwsKirci1
         2hMIJ+0msgQ6jigXkXb1FudbQs6l95xlk8yNaiJUALhlHcpGX4dA+z9W5BPUjEk6kcpk
         LLRDlPrlyVYPmcIQ5v0qTzd0Uwjn+k6H4dg9EpLh64zWGME9ag973v3wf95sa4mFbBQ5
         E77xDmoauUTJ0iinu9FruB1N6oaQMU5x/1/2ipK4KvcPQN/YH42/5ELIRt8hndZl6XmR
         gSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740624472; x=1741229272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ufyJpXRplLa9hm9rmTP3gRUIzS6V2cY3a3pc+z2Os5c=;
        b=RXxq4x+hwcm6EbXgxsMId4it/cbFdhAddmbi261gdc9Fp/XdZ2QNIAPFxtGZypzFjw
         fHpvhgtMXde51uzB0xsIRs7rB3UBvQ6haE7h8UFnDHj9Y90uBhN3cJ48t4/FSe3bJ30M
         9dbDHCsK3bI+qgmVmN1O4ePdJLp1usI04APUszr1bXTxHA37aQ2aH1To+OJgsjaV8Hjv
         BTmIMvHC+kJGb9QbUuZHNh0fTllLYcykToH0qepS8ce5y9vXuwus3h5fPuJWX13544cF
         Naz/3M0O1a+Ge/NFq/Hn2Nbhtp+q7upQBT9rYIJuNlReZFWqd8k8CKopEhgQoeJg2wdI
         I+Fg==
X-Gm-Message-State: AOJu0YzlczwUS8HGN9WEYVT+GKgXqo1Cz+VHQbnJg7M7/TyDyO5UOrzQ
	AKc6s6BYBy6q0tTFsNbqYCWMeBlv5G9TDyL5Y4NmvSCrg3aimITRfPr753qWh70AXA==
X-Gm-Gg: ASbGncuvck39TB2VzEYjnPvNUThkEaIN/ePnwES8EjESoobbT+PCj3NVo4Eq5uOQi9v
	lI9+NP2mAtnouUTYhH07fNncG8XEGkGSY2V99u31c8kn/8fpcJVMfCUa8gTdswieq1IkiUHzgdF
	VL/jQeRAMYZG5eomOC5QSUR88I2b0oiETjCc5nX0a9jU6b3WkBQoC98NZztpHIlMtHoNpI8smcI
	eofTvoeUFE4HYG/nivJ6iYZUjEee8Ny3asFft69MB/Uh+Bbd6mhW4Rg2jfmCboAHFbrVA82eI1+
	Pgcog4dWTgSb89g5oiq2WPbJtcoDNNPY8YYNNSK3ydqOAfAFRw==
X-Google-Smtp-Source: AGHT+IFWdrm7l97Bu0Qz+4B6B/qfnpH5W43g0aTdtJ8B004MTN8tQcbEUn8y/Q6xqgz04t5QgIXJGA==
X-Received: by 2002:a17:903:3b86:b0:223:517a:d4ed with SMTP id d9443c01a7336-223517ad6e1mr11089125ad.15.1740624472015;
        Wed, 26 Feb 2025 18:47:52 -0800 (PST)
Received: from localhost.localdomain ([61.173.25.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050fdafsm3681905ad.214.2025.02.26.18.47.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Feb 2025 18:47:51 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 1/2] livepatch: Add comment to clarify klp_add_nops()
Date: Thu, 27 Feb 2025 10:47:32 +0800
Message-Id: <20250227024733.16989-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250227024733.16989-1-laoar.shao@gmail.com>
References: <20250227024733.16989-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add detailed comments to clarify the purpose of klp_add_nops() function.
These comments are based on Petr's explanation[0].

Link: https://lore.kernel.org/all/Z6XUA7D0eU_YDMVp@pathway.suse.cz/ [0]
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0cd39954d5a1..4a0fb7978d0d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -601,9 +601,12 @@ static int klp_add_object_nops(struct klp_patch *patch,
 }
 
 /*
- * Add 'nop' functions which simply return to the caller to run
- * the original function. The 'nop' functions are added to a
- * patch to facilitate a 'replace' mode.
+ * Add 'nop' functions which simply return to the caller to run the
+ * original function.
+ *
+ * They are added only when the atomic replace mode is used and only for
+ * functions which are currently livepatched but are no longer included
+ * in the new livepatch.
  */
 static int klp_add_nops(struct klp_patch *patch)
 {
-- 
2.43.5


