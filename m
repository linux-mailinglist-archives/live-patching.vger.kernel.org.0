Return-Path: <live-patching+bounces-1148-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA28A3038D
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 07:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2CBB167668
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 06:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BBC1E98E1;
	Tue, 11 Feb 2025 06:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvHwrvxD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E1F1E5B9D
	for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739255091; cv=none; b=orSp1IYk9J+DkVavZgi0LvTw2mbak5Azy33TSJhRKf1xtPjHg6G+k/8c5EQk3mR4t7nHHrcjZNRGr2xtQsMJrS0zTHS2hHwczI92Z/2M8tBPfbcgLpYSBkgxbrkMcLsIklU0JjEjqx/VQGse8FOGzQBO+6zFpEMP9ze21x3VUXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739255091; c=relaxed/simple;
	bh=d7tdJFu6vljhqjQ0b+udCNn7d1QrWHp2zH4341WqO5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RmAval+Db4wOGGbKKxNRZeZe/rQcJP5pztc5vSfFP3BUWpIRU3JoB5hJYGZKCFOYzS/YLGobSF6qY+sOw1UkIpmyv8hFTNNt8SU6eSpB0YKIZc2+xes4x8E1maO5aSMPXOjd/fS7THzynWCT5pcQrTcjSpLUAcffQgwwME7fSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvHwrvxD; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa2c456816so5435363a91.1
        for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 22:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739255089; x=1739859889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPFkZvmBN9WOX+3uZ0vZAGEZvnu7RtpabEIqudut324=;
        b=XvHwrvxDTk/DgIR6y24Y53Jjd7dyZQk6fukMq28/qMfKZa18PlYRHvl6JfnwEyUI1C
         Fm3nvcQFWg1x3AdamyvzSjDSQ/o7hFYtnneycaKE0M+HxNHMIFs3U88fo+MI3zVmENIE
         fJ3RWEyJZXKMLIz7dRNQVyuyjmYq0+89kJ9Hk5ST1lWCM2zjfkbyS1LSOh7FPgxZZtVm
         n37DXS++jv1ldXVBhnJJDvysZs1BZ5++qBihc2ZW1crZfygZ75t/tmFVoYM8LjDxPVvZ
         bgbbuun6X0BIDj03einWitu9j2pgiJD1B5+V3Th2n2RA+SxqbVIEfAj3v3ejzWW0iXgo
         c12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739255089; x=1739859889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPFkZvmBN9WOX+3uZ0vZAGEZvnu7RtpabEIqudut324=;
        b=wRyIRMGDwK0CGbn2+1k8NSufsmVAEd5CZdYidZ8TLKc3b3P6dPAZfaSHmztQYNbyJt
         //YZtHrLJK8TQkT8EwwvnHvjrR+hXdzjARD4ssZjWnOAFYA5Ic1Y56OqDr9yb/3sCp9C
         CGx/+Vy70OBiEnjAiiFSLhZookHfPvfLQpKvpKJcD1N//kApqvIhbPCPVSnGvGMtXkNc
         FirKkM5GCxeD8caoI5IEvy8VFl3X5NKWcyvukzmQ8HUDDmNpYrzZvSkloJwhM47frsdk
         pQ5iJ20/5GLK0597JGWZlSSJ43gwfI72rnuiUulEvKjqbhBsqQJgE9NVJezFyVu+HmMJ
         JWTw==
X-Gm-Message-State: AOJu0Ywegz1byVfHU8qpuXDvVGF6ZXmw5we7/AK7weRt9saIUp4Cz0Ss
	qnNb3Smb1DSqQGlTR3B52skRLsdDCG5qZcBF59FpVzbrntVZDPNpb92AYI3sq48=
X-Gm-Gg: ASbGncsQGjb8D4/t9cNn+bxhEPo4smNnFp1M9SYUX7AC/jMExuMuSxWtM/4e6XqOgF8
	4DKmj63uPiUDO6pADyQ2qsjIFQrwKvKvvZm90pU+BeDlEh7KYN4kVitAQv1ns68TvOmHRHlDQcM
	XX4GsgNKzYPzspl6ezdVxb7P1rqF/R5RS+YMWUio54qTZNpg4beq4BhMnsMOCvp8fnb9VIVp+NB
	BUcx4vmwPE+0t7IBooESVhWPTjwC6E4I7YHDO2ik97Kr0wU/bEU6P5iarwb63kwYZmqtP7OWpd0
	vPKQVZ2yVVF7poUtPbtxiiB77ICTyH7fjBdu+ZI=
X-Google-Smtp-Source: AGHT+IEABh/SzimoZhaTuN4thlgDZflMgEg9wWJzlztunJ8JE2Vmgoc4d+2AsnaMshfIrLg+lh4zgg==
X-Received: by 2002:a17:90b:4b0b:b0:2f4:49d8:e718 with SMTP id 98e67ed59e1d1-2fa23f6d51cmr25546500a91.9.1739255088963;
        Mon, 10 Feb 2025 22:24:48 -0800 (PST)
Received: from localhost.localdomain ([58.37.132.225])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f363df2b4sm89016985ad.0.2025.02.10.22.24.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Feb 2025 22:24:48 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 1/3] livepatch: Add comment to clarify klp_add_nops()
Date: Tue, 11 Feb 2025 14:24:35 +0800
Message-Id: <20250211062437.46811-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250211062437.46811-1-laoar.shao@gmail.com>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
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
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0cd39954d5a1..5b2a52e7c2f6 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -604,6 +604,9 @@ static int klp_add_object_nops(struct klp_patch *patch,
  * Add 'nop' functions which simply return to the caller to run
  * the original function. The 'nop' functions are added to a
  * patch to facilitate a 'replace' mode.
+ *
+ * The 'nop' entries are added only for functions which are currently
+ * livepatched but are no longer included in the new livepatch.
  */
 static int klp_add_nops(struct klp_patch *patch)
 {
-- 
2.43.5


