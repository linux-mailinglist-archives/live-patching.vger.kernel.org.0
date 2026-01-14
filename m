Return-Path: <live-patching+bounces-1907-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5A0D1EC61
	for <lists+live-patching@lfdr.de>; Wed, 14 Jan 2026 13:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2E9BC30022CE
	for <lists+live-patching@lfdr.de>; Wed, 14 Jan 2026 12:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BF9396B88;
	Wed, 14 Jan 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VuU3Vwqq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC15395242
	for <live-patching@vger.kernel.org>; Wed, 14 Jan 2026 12:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393913; cv=none; b=RHqKt2WZTv9sR+hK/GFaV5i3XSbS/GSplEcZmxjnyxk1Vi9dy0gruv/tlBsK2NKgYGCj4v7/Q2tTK52mnadWjMuLt+FnXDKQlwNWpZ8dIOVTE7d0FfR6/8mO19UHr0ogznMvmOuUmDGq8du2HL5JKvcwmKND4XPc6NP09AwXTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393913; c=relaxed/simple;
	bh=4cEsjI6qmluXc03y+Xik1t3t8Tu9eac4951kHHMMRrs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kYD0MrILAcXxRTV8StmrYFspbbvJK7iw3mzwsbT/7wsI1OJ7iuJT8pfHDTMH9O3rvlEoG9p/y4Q2zJyIQWqGaJ90YKrQNT8yDvSHnKR1KTLuY0Sg2FUVIXk3Eqkq1pOeG5Of9vYTcx/cJmYAiPY7fZU7PaCUyB76O+wpI8nq6Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VuU3Vwqq; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so4683544f8f.2
        for <live-patching@vger.kernel.org>; Wed, 14 Jan 2026 04:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768393908; x=1768998708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MDpgMwk1BHGoscfxwj/PsMCXAuQ0lRGKa6CrVf+sfjA=;
        b=VuU3VwqqVwarBAP0ycg2bJeosFiePVcbzgGObILJMDGoKkegIUBKEmQrVB7e8jw3ZJ
         cKgP8xyI4evX84RK/CGS+9vzEsAkziFJf6bgOoQa+V5PNeLCQyiUB4Ty6L4XblbUmf95
         LtSQcJ48FIa9hPd8FHV4uk9t0OZyaHtbhdykq7Fjud6n6OVuPSPJWjjm+zXjrZzInviq
         dJEL1xqnt0IHGQQ1BkHj/jZqSbP2WkszLC3W4QlMWRJHjwiuItEySpFNXzC5A4985Ui4
         hs2EAJses/tsXl1QpRjk6OBPOl+x3i0H69AilTcK67mmfH1M/jBB8PXHBqNPPQDsz6/8
         YbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393908; x=1768998708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDpgMwk1BHGoscfxwj/PsMCXAuQ0lRGKa6CrVf+sfjA=;
        b=myNbgxqiR6u5Zdtr2ITlHeJe9/aqEQVPjop6YbLO0dvIKOCXt6YqvphbZWGnH7xb9J
         NdRTuBujUhPyY/0qyGrc7NnBrSW3HxlJO+XIPMtij2ZY+t5faSFz8Qb2W2ntHSgW0fyE
         RGNEvoywZs9QotpGdRNOFbsYcQiCYlvItVhFQT1momHA9D7B9zz32rVBtTllIp3PZapb
         +KJ74oUUgFBXtXCUXAxF5l8SNRJMLmlMbpAtySpTPXcjYvzMDVdly+019fsWMCycQM3P
         o7+0rAIj6tCXfqgADoNc42gV26HeLdgYbIJ2U6CVbUC76mfSo3q4CUucITf/seN1XkTT
         Cqfg==
X-Forwarded-Encrypted: i=1; AJvYcCVbGt324fp8lgQERV7+pLjtrHavG52Zt2iUR7sFjrzgBfR0muL7TGf6NNMF8i6LCRLWrORXjT9/Yeew73iq@vger.kernel.org
X-Gm-Message-State: AOJu0YxfR7dAF3N0XK8grA0pWRF7jy5VgLJBsisrChkugcdm5Lb+hEhU
	+TLvNToz9TXgsJ3hLIuRV/3tINAb5W4mLYi22VpvUqfR2/WwVvA8YxZiJ0ft/LSvRz0=
X-Gm-Gg: AY/fxX4psiet/QJXGqns14bcDToTZqrYvBoxPAtgVx0da7I8dMWPG89kcMvUBN95rkZ
	M+znFoioPy12TvwFaMWlk3tIptnla8jpz32pwxGSr6s/xJdMsmdpGz0VWjbEK5O2+nlQGls6jZV
	K4DoSvcYGrNUyC2y3Nl5xzmYagBjDaVEvLKUA7WubNXbXGeIJhqZVvlCEq3a6nedjDLajSadUQw
	e4cthuIdl5ocBTvrN+Ul3i+OLtVm6Ufpae9o67Gcr9n9vlRjUrO7iuRyFwald5EVnUWlkAZ9t2j
	/bNTtV74txA0CXcsqxB2poSajMuFSANQAPNnOrBiTcIRRTFCvc0L8B6XELo+/O5+Q6KgGISD9Lr
	fhIw6pv1OQkRftRKEHr/s9rKu41ikuWPcBJ3UQIj7sgBWkXxmMZwKX2q6r5oKGdBI/2Sf5mR+yp
	o9VbPYqGuBx0FPS5gP02XqlQdPwBiuDJA=
X-Received: by 2002:a05:6000:2887:b0:430:f7ae:af3e with SMTP id ffacd0b85a97d-4342c54ac52mr2565147f8f.32.1768393907979;
        Wed, 14 Jan 2026 04:31:47 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee243sm50097772f8f.31.2026.01.14.04.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 04:31:47 -0800 (PST)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Improve handling of the __klp_{objects,funcs} sections in modules
Date: Wed, 14 Jan 2026 13:29:52 +0100
Message-ID: <20260114123056.2045816-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Petr Pavlu (2):
  livepatch: Fix having __klp_objects relics in non-livepatch modules
  livepatch: Free klp_{object,func}_ext data after initialization

 include/linux/livepatch.h           |  3 +++
 kernel/livepatch/core.c             | 21 +++++++++++++++++++++
 scripts/livepatch/init.c            | 17 ++++++-----------
 scripts/module.lds.S                |  9 ++-------
 tools/objtool/check.c               |  2 +-
 tools/objtool/include/objtool/klp.h | 10 +++++-----
 tools/objtool/klp-diff.c            |  2 +-
 7 files changed, 39 insertions(+), 25 deletions(-)


base-commit: f0b9d8eb98dfee8d00419aa07543bdc2c1a44fb1
-- 
2.52.0


