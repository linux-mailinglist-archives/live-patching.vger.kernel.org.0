Return-Path: <live-patching+bounces-248-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3388BDA75
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 07:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB5BC1C20FF4
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 05:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7A54EB5F;
	Tue,  7 May 2024 05:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3lDdNpL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3459A4A12;
	Tue,  7 May 2024 05:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715058090; cv=none; b=rM8bIW0TIH04C/5eHDY7SbCCh/GKDTLwvxsGhsDqbFS1nlvBzwGOIFfo2YPtiZ866rsNeMz5R+Q44TJGQ/XlSeJYx4nBGbz4gs5/17ugLZZSV+n8NaYPL3d3bfIPjiqkxm9VFuyEnikLWchHlLK4/t5Og5fHB5+wDXrO8nZww28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715058090; c=relaxed/simple;
	bh=SIZ4RUFpeEy6dUng6YTjlC6V/F+L/k9rZ8iSxv56ZBM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FQ+e/6Fu7MdITtMat88o7tqKNxCQIsAJLuvGL2qsJ13SubxsDnMc4sT334KO3N9S1NWdZ9k6xU5tRrTEUKoaV1MgFZtOh/rmW9GG2YCdc57e6gQEc7NgJ2MZyElmdPGaJ0dQeUTnHOcbTsVyt8HOoX5n2POx+hfQGfN+yWD5lbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E3lDdNpL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2b4952a1aecso1788782a91.3;
        Mon, 06 May 2024 22:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715058088; x=1715662888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qJoeyqTnvdZcycQDt8RgILBB3Kj0RpbWdZGFFslKSiE=;
        b=E3lDdNpLNX3xsR+qV6YfolNFnHfi2VEs43ulucBAoTHdyg/rOi2dRw2ouz/RBG3lsf
         4qBvyZbAYYHiWFg/YP3rVoGL8hjVQU73X5CpFxRkO8q2kCsQBJk7sp2+6qriH8Xa8CWX
         RJqpzrvbOuAqQIuHWbLxzRBN2vhBWCjy42PixaKgewJfpqQYKbp+w7uDIiskPZSMbOnP
         lSn7FFFYZNjRFdrFMcs0yqeNc1UwIfW/S/7XYOuqe3QhY5gMtlSfGW3lLdsAftJEFwDb
         ySHEzTc2MEe3SxzSa0RvWJlM/z+1/bzWzPyF7rx3D2Qi7XjeCXlvgXksyDu0pHvxEJk3
         U5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715058088; x=1715662888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJoeyqTnvdZcycQDt8RgILBB3Kj0RpbWdZGFFslKSiE=;
        b=RMbvmHpiSduCzz6z56/1MxwJFbe8QALGR1HCqzN6A9vG6l0CSTkvmCB7dO9/mYDxcC
         JwYKO/C+vWTS2WvbyVdZvAhjQ0+UWE8c337QUGVymYM1Ze4tsJuRPu508cfDoWzDB1MO
         BGee/gHHbgltBfCOFPNUPLFLYCLk7W4Q18LXHkqqxfwrgZSW2mL9abrPhWWYHu5bAEvi
         Z1TMe44H5s+RPs8+5udH7WCYuE09NmWduIlt1dzqcfPW0bBcKFwtvM6B2B6M1QV7r9Yt
         4HOETtKUq2P2vS/DnQWn1d15AS4v/p/AS/X9361mQsDLm7NhHdm8KKnnRRr6ANfWIp66
         mNDA==
X-Forwarded-Encrypted: i=1; AJvYcCVpATawY3VPsKTBZrB58p+tQrkueWs5Po0HuHuYSZXp31i6jNSeTWDflUBhQeFr6FaJMRw3DgG+CURZqaRuhJtKnfOW3IP+gv34mae4
X-Gm-Message-State: AOJu0Ywg3OvtfKdMVEXfol5crnts35+yDmV0Ks58T9siGUI95iWH62nu
	QvM/7t7vZ62Gq36UPS0FsX6DNx4JyYB/xyLCPNkLRiDoSw8hyodk
X-Google-Smtp-Source: AGHT+IFPuQJRD3mk58U1X23VC60LAi5Iv86kv4NFnad8anRF3g+lJmfohzkrzEqT8WuWE6TissPNYA==
X-Received: by 2002:a17:90b:2396:b0:2b1:fce5:f308 with SMTP id mr22-20020a17090b239600b002b1fce5f308mr9456597pjb.49.1715058086943;
        Mon, 06 May 2024 22:01:26 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id nc15-20020a17090b37cf00b002b115be650bsm10894236pjb.10.2024.05.06.22.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 22:01:26 -0700 (PDT)
From: zhangwarden@gmail.com
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 0/1] *** Rename KLP_* to KLP_TRANSITION_* ***
Date: Tue,  7 May 2024 13:01:10 +0800
Message-Id: <20240507050111.38195-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

This is the v3 of commit " livepatch: Rename KLP_* to KLP_TRANSITION_* "
with the suggestion of @Josh

v1 -> v2 : 
Use KLP_TRANSITION_* to replace marcos KLP_*

v2 -> v3 :
Remove the unnecessary comment and fix one typo in the code.

Wardenjohn (1):
  livepatch: Rename KLP_* to KLP_TRANSITION_*

 include/linux/livepatch.h     |  6 ++--
 init/init_task.c              |  2 +-
 kernel/livepatch/core.c       |  4 +--
 kernel/livepatch/patch.c      |  4 +--
 kernel/livepatch/transition.c | 54 +++++++++++++++++------------------
 5 files changed, 35 insertions(+), 35 deletions(-)

-- 
2.37.3


