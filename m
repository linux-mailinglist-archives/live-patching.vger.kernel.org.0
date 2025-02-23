Return-Path: <live-patching+bounces-1222-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B21A40CEF
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 07:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68B1D1781EC
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 06:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C6B1DC198;
	Sun, 23 Feb 2025 06:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zdis9ZSC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F279F5;
	Sun, 23 Feb 2025 06:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740291663; cv=none; b=trc9bqSKXJV2YXgXtRA+3Y+SYTN9B8qWSzJtzdauPxh5EK/NJBIkHfErMKI9jDThVRZ44oZm2+/VgcUqFl3LhKdhHCUUYE8FHIkMzG2ai1PEWwE5uwT0P/cIRZ4zlC4H9H1QeASuDjMktsU1RYNSx37AbOoea+iNzwfft6qM4N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740291663; c=relaxed/simple;
	bh=z4WeWec5onOz0GyULUxJn8ppLCWKgFwNc0r+lEcc0pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SgKVyvOTxqjFGLxuVpus4CaXdvwZudYJfNjIUlpieKwYN/pYxEHdXN1aeWn2zIWaPpe4bjmHqzbgSjnTRkOi8SLEV2qfZkXf5cNp6AZkMfF9AVubgB0T1PNP9oDBR/v9m7qOWT6SnnkCU3g/5NdtXYsne2cScfVsk2S0yG2cr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zdis9ZSC; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2210d92292eso103182985ad.1;
        Sat, 22 Feb 2025 22:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740291662; x=1740896462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufyJpXRplLa9hm9rmTP3gRUIzS6V2cY3a3pc+z2Os5c=;
        b=Zdis9ZSCZZfozzSdwHdmXrHbYav1Tog0vxMY2QcBmyCUNXIJuJEXi0n2Z9O7TVnvfn
         K8J4GPQ6KysL9C3G2evNyFP+VQjEda2pdJ3ivCDEp3TwK9YPVmfobiwgHyKMAbDvXgkR
         pYy8oyr906ebZkdspN5dhjO1pe+6BYP+bh9BRKKYNhEdLu+gKGlsYL6jMS248JCorqKT
         Z/5Kmd6aFPvR5w89Z7bkGgti4BEoa4O08ZFQXuvIevaRXLJ5Ot9yLXa5n5qo1wE4H9cn
         tO32Lal6qEftLm2uLfnbhGw28tRyR0oCV+M1u0hE4OybjxH1xphqREiFvjC4Wgi/akHz
         gxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740291662; x=1740896462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ufyJpXRplLa9hm9rmTP3gRUIzS6V2cY3a3pc+z2Os5c=;
        b=hHLz2Dpt++Kg/bzQEBTvjrH5+PVAqwtuGE4UgS6RftV0kHYnGhVqCqOvpZuW9E6cl5
         m+oIY6Nt/LI5Q3InFVM63IM4xrJ/HHlRnNduWdKxaueJd4uxpgpl9Zaa82xmZtnhrKW6
         C+i60M2mhG9iW5nFBzcsZZR6g9/RcUa71dH4IBOJbT8Y+E0Qh/bzIpVrFMeZX4Z2/Cag
         6iNdYLpD6D8tYC7nPOzY4ny19ahLQKOJWHrq21JiZng+DfEak1Hd5sW5z6/pzHcHa5RB
         ZdCOpAC6SoeK0NXcsoRUP5cWtO77Ld78jZwwqVQX59CkXHPUkmcH3dlfH0hEwQ3sBYgi
         5jGA==
X-Forwarded-Encrypted: i=1; AJvYcCV9gpIoVZQwoPOCeiERyVVD4xF7VWPQwb+GgACpZtHi6j1DlGSFO3W6FHR7Q57ZW9wyxY8nwZZoCfcjzio=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuxjTL6Ju0frwjUbhJYLg/zb0Q5MQ9Zi2hvpVszz+axHMgjp89
	TO6f5SxYnirLwD8JgvjBC3fAgGzp0EA7y6GGXIlG5bXPbwP3c2Qn
X-Gm-Gg: ASbGncvMK8FJrHHnZKUjjvwddU/kcjx6L0vGTh+z0GtSY21jfcSCgOHfRj0wBw41h9u
	/EEpCSJ2YaOg8os3RzsoE/EzhXXVDLO9mUTEcAUOG8XE2AS6NPcz1mS+a193eRiBDM+Wi27tKmW
	h+tmyJgYCrDTPgjVm8kdVuLqoE6AkuvaQyy58q2YG2g/FbgRUN8iqTALiEaeawWMJI60iEtAMcH
	L51fvcrQnwIG6PphxLq72itQ+z3AlSnga6hObEIfLqP4GSDdCPYjTayd3aoDw9Im0osB3sQ7jft
	ShH+yxXXrSJSrqjGt4fIAn5Osi8Me7531cZ4jgzrCm4+ouDlwKc=
X-Google-Smtp-Source: AGHT+IEPNl9mM5zcIK3tf/4Yv4mHNQs8Tdk1SzRidSAdXg+GHtAgaKb84FRZPdA4JmQKeKxO311M9Q==
X-Received: by 2002:a17:903:41d0:b0:221:337:4862 with SMTP id d9443c01a7336-2219ff50e97mr142473265ad.15.1740291661607;
        Sat, 22 Feb 2025 22:21:01 -0800 (PST)
Received: from localhost.localdomain ([39.144.244.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d558ed3fsm160750795ad.232.2025.02.22.22.20.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Feb 2025 22:21:01 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 1/2] livepatch: Add comment to clarify klp_add_nops()
Date: Sun, 23 Feb 2025 14:20:45 +0800
Message-Id: <20250223062046.2943-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250223062046.2943-1-laoar.shao@gmail.com>
References: <20250223062046.2943-1-laoar.shao@gmail.com>
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


