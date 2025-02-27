Return-Path: <live-patching+bounces-1237-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DEFA4732F
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 03:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20C1165CBB
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 02:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AD3161321;
	Thu, 27 Feb 2025 02:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHldYEM0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312332F30
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740624479; cv=none; b=n90fzuevi8h8UgqUHKFp9e18a/e8otHnIVn3si064xcW7Yt21hpaK/nPye0bLtt4LHEdLeHZbkx+H4S55wbEo05Nk767aUF8ReBD886SFPET7Z0VWe6wCV1KiqRTLj6iWCqfNJqygCzOGz4ZaNWOoUDXfM/sSYsqhFOK7DURaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740624479; c=relaxed/simple;
	bh=lFAmWhVshf9nFLUSX7hTW9ET7LdBAi3hgWF1ui25Hjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XZOSgqKofuwv9kMKLQFjv9B7JJiWiZS7LP6PbtTnv/tFsHwMxT0R9svTyOwr0LI73Z3U/0rTgVE+Iut21eocq9bNAuce2lOwBUKXx7Y/9VqrfRzkEMY03jep7aWQRQhwxoi0516B1wIFoz4PobIhR6srwXTpd4z6gku8JQys9KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHldYEM0; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2211cd4463cso6972545ad.2
        for <live-patching@vger.kernel.org>; Wed, 26 Feb 2025 18:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740624468; x=1741229268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PdpN76I6zy3AIY7lfmKso6k+ocCBw3OaBuhvfcrFlT4=;
        b=FHldYEM0J1esT9mpS9qQfj1Og6JWtYOp3JgZh+B3cDP5Z7PloLPeeyYtFh9CjtcOaW
         IGEql+dhbRDrhxezVKHSviSwcLcFDETIkSJZP0QEgBsmDg47yhRAFonWsNXvoMZdGndS
         hUDkC6qLOIrUl3HRdByD5cjhIuAwwy82JWFs/NeLF55AlNDMyaaYKlL6H3TjRVdt+WDS
         UfgdxJBdyx18FiXZ/ivGI1nvloL0RK6KANokzpIvmH2d14N0WV9Au8swsrHJQikSN0pK
         pstmGtdrerx5CekgyJeO63v8E/c1kAYzbIlK9WqFygoLIbThmEydXuwPLNNnctS3DOX8
         iDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740624468; x=1741229268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PdpN76I6zy3AIY7lfmKso6k+ocCBw3OaBuhvfcrFlT4=;
        b=aYGru7ju+gVC06cpr6XOgaLbjEvz7D3IIlBorqtOrheiE0ltPJLzIRoRPuv1Jv2Nzg
         5DKMZfm56EXtV0v+DtDMqDtI5i1vFBdIPosmtG0t/qptSdisZJXStSzUdb67JR1K5kbQ
         misxj4nBFo5LTt/A2PlpuVzoxC5rNiztIvBvESzQUY3BvuE86/+tnWlDSg1XNajw89wb
         z+ZEeu40d35PUbe8ro3tNs+gVcvQrhSzjWPwU608NvbFKyY/F1NY1fEpFLGKIjPf9Q20
         RFRUdn5blUr6QHjmw9BMziKvYzXOHamdbVjxrnDpIupSN2EL2iPJifzw+rAPwhRnYVN+
         yC4g==
X-Gm-Message-State: AOJu0Yxy83THtwuYbhAznaiZ1E00vXslokyUllpIK4n6n8dsnFY+j0C5
	joaH4uoXcFQylexzQwOaVKIqfIsgo8l4nKTrs365LQa4iYPrJLpI
X-Gm-Gg: ASbGncvO6QS6tdnlOG0E/ClDfhYOdhF20a4vxH+MfZmBDlSYeUR1TC91qFDLhD9CooO
	4KmYlDR38x9yIoxGgW/tNdU2NK0R925ZYvkFnUTtLYHZog4zL8uVLKybVvTccBlXUXFATVyI7W5
	Nuqcgla7+otNBGWcOroN7FM/Fl66uFDGPN+Zua2ykrCjSsofloxQnflu2xudM7ISly7I3vvWp9Z
	FhV4z+RbYcZktM/GldboJ/R9fkrG0T6V4IigRbY24q5MaVktvQm88bE7coXOE557J0LevBlUDLq
	c+FQY6sQVDkXEnPGymrRis1Fji0Ffdlz7jErVevZkRfVx7XpIg==
X-Google-Smtp-Source: AGHT+IElpmGAxJwPh1EljvUTd5KmEh5FAnfZ45iUDl6diq0utS751FVHoJGtVtda+ch6eYrx/gVG0w==
X-Received: by 2002:a17:902:da92:b0:216:794f:6d7d with SMTP id d9443c01a7336-22307e7274dmr151075845ad.48.1740624468337;
        Wed, 26 Feb 2025 18:47:48 -0800 (PST)
Received: from localhost.localdomain ([61.173.25.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050fdafsm3681905ad.214.2025.02.26.18.47.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Feb 2025 18:47:47 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 0/2] livepatch: some improvements
Date: Thu, 27 Feb 2025 10:47:31 +0800
Message-Id: <20250227024733.16989-1-laoar.shao@gmail.com>
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

v2->v3:
- Skip the newly fokred tasks during klp_check_and_switch_task() (Josh)
- Fix the local variable patch_state in the ftrace handler (Josh)

v1->v2: https://lore.kernel.org/live-patching/20250223062046.2943-1-laoar.shao@gmail.com/
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
 kernel/livepatch/patch.c      |  8 +++++++-
 kernel/livepatch/transition.c | 35 ++++++++++++++---------------------
 kernel/livepatch/transition.h |  1 +
 6 files changed, 31 insertions(+), 28 deletions(-)

-- 
2.43.5


