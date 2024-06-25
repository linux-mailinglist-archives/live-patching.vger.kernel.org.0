Return-Path: <live-patching+bounces-367-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A4F916CB5
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 17:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3757B2308C
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 15:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E491D17106A;
	Tue, 25 Jun 2024 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuJ9CwL3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8060917084D
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328325; cv=none; b=AeWxRpns/UI467v3pCSE+gdEDQveDvNz1UwHy5SPAoVUld+YPXxNzCLYPGdq0U9Q7y+4WsERmOTbz5IJFa5AfsQ2Gz7CW6htgc6yvR/X3MNXVeUfe7KeEBuKyXbvUR3q5CYmS0kaXnL1Sq4GqDaFEKQgPKkosJXWvAB5rsGAB0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328325; c=relaxed/simple;
	bh=7ADjT1+FEgCZsfJFHUwMTa3ZPakKxFCzQuoDYG03GKE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lYpFfu24LER1Cw295OVOD8YLD3BPd8ZL1s+erGTVapT9suKqB0QE4x+5ZnZmpmWd8mDU2KxYqL+HASSwRrvC3l4xm7BynXPXvZWbOkq9edQWBtoT6D4Oi/WjH0t34+H+7Kaw6+QQyi874cAzEDIuf+43fI99wK/Y0/JDRUYmJoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuJ9CwL3; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70656b43fd4so3212465b3a.0
        for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 08:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719328324; x=1719933124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ujw+tgIQYWtT7qImY+LMstK5v3Zx0bIp8kvjwWvFa3s=;
        b=VuJ9CwL30R4pUa/QsZugnYauEEYlOgICpjA0hOLQisJf+IMu1gh3yvbt9EAntePTKy
         sISbFvwSnWueSGRwiMI8SYgOUv/SVd8MueslcBiBgke5CehIGa/QGhlZIe8HQk/uIdVI
         NQwLFVdvYDy/nMBd+l8dYuFnZKN3NxDULK2PNHEzRxPM9da/NFjDU19A3nBnkCjMOwrq
         Ela33mKk67RDSP3af4hTscAjCei0dKgxPWFGQKrym6ckbXaN32m9rm8PnK8QQ8wWOlwO
         1iWSlujYY/7KiRPQu3DKqQbhXSgmQCSXbRBSk5hSeMgT3x2Sr4peWz+WYrHHcJ6qSio6
         T+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719328324; x=1719933124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ujw+tgIQYWtT7qImY+LMstK5v3Zx0bIp8kvjwWvFa3s=;
        b=fUyku7vvLMr854bqDXvhcrdx/7RdGhuRONKnkn3kFGS4HxCAZjH218oks2Ww5QFzoZ
         xGrSRwP+eLtbHw5c/lGA5yjseTnvro7oeqle9cKC/yXAFCmhNzywHypo3UUI3mZRpzlE
         KZpcR34/aNAGnLgqF6jFEt1BmdPx0R8Zi0Kdvp9nCpQWvvDd0pKdTXYP5EZkDun7M31H
         ZCcQkTLKcYdGhHTz109bq2ePzOJAipITIPqf825FEFuTtykOt7FAPPtVpsMck3ebMbB/
         pmm394N8lXU9HSnk+pZL+3dg/Ye8ColgUPVyjP6Qxu1ki5ykZ2NBAqCTJd9MOGG7ilJm
         tTFQ==
X-Gm-Message-State: AOJu0YynasidD+tahIbka9aOsF1w5XBxmGNvGMwC2EkowqBNwoUnn8N3
	2riXV50KhiQQ7wXCa9YxWW1erfGdnqhsoQLQIfoDoGdAvPPhLKO0
X-Google-Smtp-Source: AGHT+IEoqtauRNVyLUc4QPzJdfjsTA9+qy0PiU9PH+QUu9ALoUrTTS1qonYmEeyvdC3wETlgrc8NpA==
X-Received: by 2002:a05:6a20:c127:b0:1b2:2e3e:42dd with SMTP id adf61e73a8af0-1bcf7ebcfb8mr6267881637.34.1719328323621;
        Tue, 25 Jun 2024 08:12:03 -0700 (PDT)
Received: from localhost.localdomain ([183.193.176.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb323636sm82008935ad.102.2024.06.25.08.12.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2024 08:12:03 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org,
	mpdesouza@suse.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 0/3] livepatch: Add "replace" sysfs attribute 
Date: Tue, 25 Jun 2024 23:11:20 +0800
Message-Id: <20240625151123.2750-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are situations when it might make sense to combine livepatches
with and without the atomic replace on the same system. For example,
the livepatch without the atomic replace might provide a hotfix
or extra tuning.

Managing livepatches on such systems might be challenging. And the
information which of the installed livepatches do not use the atomic
replace would be useful. Therefore, "replace" sysfs attribute is added
to show whether a livepatch supports atomic replace or not.

A minor cleanup is also included in this patchset.

v2->v3:
- Improve the commit log (Petr)

v1->v2: https://lore.kernel.org/live-patching/20240610013237.92646-1-laoar.shao@gmail.com/
- Refine the subject (Miroslav)
- Use sysfs_emit() instead and replace other snprintf() as well (Miroslav)
- Add selftests (Marcos) 

v1: https://lore.kernel.org/live-patching/20240607070157.33828-1-laoar.shao@gmail.com/

Yafang Shao (3):
  livepatch: Add "replace" sysfs attribute
  selftests/livepatch: Add selftests for "replace" sysfs attribute
  livepatch: Replace snprintf() with sysfs_emit()

 .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
 kernel/livepatch/core.c                       | 17 +++++--
 .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

-- 
2.39.1


