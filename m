Return-Path: <live-patching+bounces-1221-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA280A40CED
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 07:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C02EE177F87
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 06:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513F513AA38;
	Sun, 23 Feb 2025 06:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2lbDh26"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF8179F5;
	Sun, 23 Feb 2025 06:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740291659; cv=none; b=or8CWnLVP9Ks5qFbaEy/Rqb/4quHiqYv/zXnjpr4Q/h842rq/whAKoX4XpyV8X8cfRKW07XKS4zWuo+HO+0JKHPfwyVJNiO/rrfFDZnJxGqWll71LYzjb+DiizDqLmRs+o2ctTv9CZPhgcVYuBdMmtd9h9O11FURQB5XNu7OB1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740291659; c=relaxed/simple;
	bh=deepsJFQqeO/kAtmpl1R1kFYEFd1rXztHvrX8kzjO0E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LEjAZRGijNPMafQmPNsHsbzdJRQISuEqYOl8RjSyTKM7eLUafsmINftm0VIRsCC12AjwOkitFunmewnUMqYY8R//CQPL3MHn6ylMz/2nt5lUj8qtyPAyxrTwTmD/nW0OqyH/F4Eh8lqamplkOe72rX0i6fB19s2Vq7hYy9q3P3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2lbDh26; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2210d92292eso103182295ad.1;
        Sat, 22 Feb 2025 22:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740291657; x=1740896457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yqa+nvgEGq1vfj9EP9N7haUWlaqwP/PXcvHluz8XdQ8=;
        b=H2lbDh267XBrbQmQA0Z/UcitAWm098LCG7Hef/7gFpErcWpRQAd4Ar3m9E8s7ldFck
         mLZEaOY6RY6yibanaMV/790ZwWA7ogzcYhzxT5qQrGIyLSQvliEbpaP75pQ6bcD80IfE
         8YAKebjUOjH0u+hulONpGQ0szZkztv6X9zOwcCaBZnoFM1e//dUGBeKguXm2p0QhU7jk
         PFFlmiUVxR4bKWBBaKpEM+8R4hRzvzfA6gH5uXotNMAqhcipnMN/0WCJ9oKypmFULxJD
         xoBABKi7PLtz+LR2G/pu6bL3yW92PuSBN/zBKhSWFoCyXpBgvO165zI2wEDrEkjBI0jL
         hooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740291657; x=1740896457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqa+nvgEGq1vfj9EP9N7haUWlaqwP/PXcvHluz8XdQ8=;
        b=YOvnn4ZL0B6NeQHoxVLO4Ui+bNzUYkB4Cp5YFG8YLVsFnpW0YFSYhj/JzoEb3YNEdc
         Lx0yH3dKjGdT/tKcIOfwfMHss9etF/x0qlbwyzjYvw/PZKurtW5SE7/kzFviZSJOy3HR
         jrOL5tUqti5GXzBtgP8TRayF2FuBi3oXQa+OeF6t0TI8cSNC8D5skVBhAumucug7K7Du
         2I3mFayDKo3AoQMlAg+FOS0dxFgOjCSTr6a/LrmmFuy/zYEDYzVrgNfG19J2vIb+Ac1X
         wj/X+3VhTczoBcjJk24jCISOLSInTWYMTh//ApG9jGWld+pM3q1CHoOui8hr2aB/rW+2
         IS5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhJW9OWypdY3Fq6wodKy7H7CyaHpD/bnJQ2Y51nrGe6bpUkEsJYfTJluvIjDjlQuKEaueLq0ykzl6CjFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEoiD+P+NhQ2MXQatwH4/R3+A+mslvo90FGKL7io5K3Z34Y4UY
	5OnuI2XRKOLucNxEHR7U/91/8PkCVmQDQKYEYe88Q55CLtXqvSxL
X-Gm-Gg: ASbGncuQFxhT8oTQyxtvJn2Luo4rP0DWxoD64ZiwIPtGxbgSyWgs99N4pCrXex4NKaJ
	R1A7wM21xak7g6Oq3TaoTi+JCE2rRI4BRHugAGgn3rGv9v9GmeMW7RW85yyM5kUbZplWzMuW0Ez
	xmqZqCy5MGUbIPPiupC161Dfpujn+9O2RK3gQlT95RsBkXoQ1wikgLXt6msvvJRBJLh5xdRvxsk
	H9Z8Pa0bKlmqVXrr9AE8jabdqxBWCnkKRDsfD/Xb918jwFJ28lIeHBomj6lIwvNJyW3SaQ4SqQR
	62AY9KWnElO40qA1pHdzVjrL+sD77jDYGbCUkVYFgnoksY2zpYo=
X-Google-Smtp-Source: AGHT+IGAvVJwSCmYtbIMvhpNyf2jkLK6klihg3yH8xJSKRkVQ7yrBLU6VV8IYdDPrglM0vEgEm4uAg==
X-Received: by 2002:a17:903:191:b0:216:4853:4c0b with SMTP id d9443c01a7336-2219ffc491dmr148379275ad.33.1740291657075;
        Sat, 22 Feb 2025 22:20:57 -0800 (PST)
Received: from localhost.localdomain ([39.144.244.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d558ed3fsm160750795ad.232.2025.02.22.22.20.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Feb 2025 22:20:56 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 0/2] livepatch: some improvements 
Date: Sun, 23 Feb 2025 14:20:44 +0800
Message-Id: <20250223062046.2943-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  #1: Clarify klp_add_nops()
  #2: Replace the tasklist_lock with RCU in the KLP transition

v1->v2:
- Enhance the comment in #1 for better clarity and detail. (Petr)
- Replace the tasklist_lock with RCU (Josh)
- Remove the fix for RCU warnings as the root cause is currently unclear.
  Once the root cause is identified, I will submit the fix separately.

v1: https://lore.kernel.org/live-patching/20250211062437.46811-1-laoar.shao@gmail.com/

Yafang Shao (2):
  livepatch: Add comment to clarify klp_add_nops()
  livepatch: Replace tasklist_lock with RCU

 include/linux/livepatch.h     |  4 ++--
 kernel/fork.c                 |  2 +-
 kernel/livepatch/core.c       |  9 ++++++---
 kernel/livepatch/patch.c      |  7 ++++++-
 kernel/livepatch/transition.c | 35 ++++++++++++++---------------------
 kernel/livepatch/transition.h |  1 +
 6 files changed, 30 insertions(+), 28 deletions(-)

-- 
2.43.5


