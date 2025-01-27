Return-Path: <live-patching+bounces-1059-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D8AA1D0F3
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 07:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEBB63A33E8
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 06:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA2D1FC7ED;
	Mon, 27 Jan 2025 06:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGSaS00/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6E1FC7DA;
	Mon, 27 Jan 2025 06:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737959746; cv=none; b=ehnLnodt8eLuJgwv4wjGZzbAJtLdEMH1TqAiZZbRIKI6k3tn++FxALNLaDHdYh7hHY+gIB9PijHv3tRroh5Wb4W+wwHq+TRN87BF5jvLKR+721gRxQKHSJnB/6DdHQoFkEGRfHyhmj8sNh/zJXS3//mWvlY9Z5cQ/ZysfmETcK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737959746; c=relaxed/simple;
	bh=ngOmQ6OzWMqsTu+rZtKE4hNWrY+antlw+4RCpkNIXqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iqrG0Jg8xuSyXboh6m9eSnIvjFjPqxpUJiiyLCDeRf+xHWAq9tl7A7lXEqDy8jB5ZZFlvCWI35OYMwi+g3uGnZxVWW4x4hMxKzd5//4nBpgMFsUD47clGNG98Iw3EPSYVsmj1Qw3apCyQdBUNIwj5zOSg80Onjo1CIxOqP98R7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGSaS00/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21661be2c2dso67213165ad.1;
        Sun, 26 Jan 2025 22:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737959744; x=1738564544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXXs8kEF0fkqJQxTj5/JRMeBNEwSNU94DwPc2H43KG0=;
        b=MGSaS00/vc6QfDeqiaG/7Box33TBIf0EeHUYQ1Be0uA+2z7YadxIzUWglpDE9zsB9G
         Ua7u95/jKV7bS18g9sYeDnKpRp+F6bhqTQhHkRC9HYhop4qyUB+ZLEnlmecAWJvpnO2s
         GGLuxUlHyOvD4lHvDUiG16zzoXZANf0UlyKS+tr81eB2padaUfRe76aM25lZeBHBh2kd
         wUVI/f/OF79OCeOXgIcLk/fZCZnQF6FLlXSLNRFpDxf2TbO1CO0tto9T6IDjMsnD6nok
         ZUL9QBXaB6/lpapeWIxVy0L2nGaxwC2CdNxYniEwjTfu1SxW1xjOvfr/nJnJ/PsXJX66
         y9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737959744; x=1738564544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXXs8kEF0fkqJQxTj5/JRMeBNEwSNU94DwPc2H43KG0=;
        b=e4TrlnHHC41BDL6YXsBRTQVIHlIQO80kLWkIQL2z2aI5Lp/qaAFEhvCSRf2Fk+0LqC
         Eh++M42xbrRC63Nb2indj5nDrQn4zGgjFLTHOTujOcFcoc5mF9ZeVa4Wln/B09vMrdTb
         EHvlUndv0LIuRuqRvWLr3UqTjWxP4ddtJUysWrpS4Nv3HvDDNwhTFSkFkbxYE6TmpjO5
         1cPywVhV2Y/5wCQ8ZiN6N0y/nNb7ls2fj0pxKyfaDNoCmuT/nOBXPby5LQhcM65QipJC
         gVjg8DtEYLGQIH6/utM0LtHXQ9pNL7qsgzFCOEg/feWNKJHkc+r6dfS3tLKdAACEP903
         ceVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVFwHWDN8p/e38m8NnWYc/QZOnWFAkaKF/wH/Y7QB604IcYSPTCV8YFbTBe2/oUvhOj4kyTGFqGdKnE0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9VzcHozkYSYurJW8BYObyBeVnP3aBy/D4BrU0J3KzR/cP1bmp
	B776iTUiFSRRw2dN6SNsCkISuhe+Tz77xV0kv0yhUCkANNtBBxpt
X-Gm-Gg: ASbGncs5XSuVfPBNMHi2Yqp5DunBO6x1/QOgOdEieY+j5j/huqGO78PCcSfKjVlGaGm
	WG4wvXhh60PaukQ/j230m6Ie/HHOJtIcOSZ+tRVBmJVJUb91TVN9lJiWkxnuD44tRzdFfVLc4NC
	2vcWVVS/XcTpQJtq73Siz773UaUI3PvjP9bEjXvSgJB5lRpQLJFj/j292mgbXGlMi5lpE5Dqn1J
	KTyhLzcwG8VQLqAQ8YIsxzCYq6bTrPw/V03tIXkk/FTDGcHzTSIgRi018Lo3ka9FfNyO9t+0aZ/
	XhvETt94t827RVCHUHCNfDf4c8o=
X-Google-Smtp-Source: AGHT+IFcPnY3LHAjmFFF9hCaa+XhfDpLzY2CeqssfCQdd5kJbg2y/JLEdWbtRHo35qsTK2MLGvbFmw==
X-Received: by 2002:a17:903:947:b0:216:5b64:90f6 with SMTP id d9443c01a7336-21c355fa2eamr556259435ad.45.1737959744546;
        Sun, 26 Jan 2025 22:35:44 -0800 (PST)
Received: from localhost.localdomain ([58.38.78.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3076sm55875605ad.68.2025.01.26.22.35.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jan 2025 22:35:44 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Date: Mon, 27 Jan 2025 14:35:26 +0800
Message-Id: <20250127063526.76687-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250127063526.76687-1-laoar.shao@gmail.com>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The atomic replace livepatch mechanism was introduced to handle scenarios
where we want to unload a specific livepatch without unloading others.
However, its current implementation has significant shortcomings, making
it less than ideal in practice. Below are the key downsides:

- It is expensive

  During testing with frequent replacements of an old livepatch, random RCU
  warnings were observed:

  [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is 10024 jiffies old.
  [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is 10185 jiffies old.
  [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is 10150 jiffies old.
  [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is 10174 jiffies old.
  [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is 10168 jiffies old.
  [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is 10167 jiffies old.
  [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 10215 jiffies old.
  [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 40415 jiffies old.
  [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is 10174 jiffies old.
  [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is 10143 jiffies old.
  [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is 10188 jiffies old.
  
  This indicates that atomic replacement can cause performance issues,
  particularly with RCU synchronization under frequent use.

- Potential Risks During Replacement 

  One known issue involves replacing livepatched versions of critical
  functions such as do_exit(). During the replacement process, a panic
  might occur, as highlighted in [0]. Other potential risks may also arise
  due to inconsistencies or race conditions during transitions.

- Temporary Loss of Patching 

  During the replacement process, the old patch is set to a NOP (no-operation)
  before the new patch is fully applied. This creates a window where the
  function temporarily reverts to its original, unpatched state. If the old
  patch fixed a critical issue (e.g., one that prevented a system panic), the
  system could become vulnerable to that issue during the transition.

The current atomic replacement approach replaces all old livepatches,
even when such a sweeping change is unnecessary. This can be improved
by introducing a hybrid mode, which allows the coexistence of both
atomic replace and non atomic replace livepatches.

In the hybrid mode:

- Specific livepatches can be marked as "non-replaceable" to ensure they
  remain active and unaffected during replacements.

- Other livepatches can be marked as "replaceable," allowing targeted
  replacements of only those patches.

This selective approach would reduce unnecessary transitions, lower the
risk of temporary patch loss, and mitigate performance issues during
livepatch replacement.

Link: https://lore.kernel.org/live-patching/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com/ [0]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 5e0c2caa0af8..f820b50c1b26 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch)
 		klp_for_each_object(old_patch, old_obj) {
 			int err;
 
+			if (!old_patch->replaceable)
+				continue;
 			err = klp_add_object_nops(patch, old_obj);
 			if (err)
 				return err;
@@ -830,6 +832,8 @@ void klp_free_replaced_patches_async(struct klp_patch *new_patch)
 	klp_for_each_patch_safe(old_patch, tmp_patch) {
 		if (old_patch == new_patch)
 			return;
+		if (!old_patch->replaceable)
+			continue;
 		klp_free_patch_async(old_patch);
 	}
 }
@@ -1232,6 +1236,8 @@ void klp_unpatch_replaced_patches(struct klp_patch *new_patch)
 		if (old_patch == new_patch)
 			return;
 
+		if (!old_patch->replaceable)
+			continue;
 		old_patch->enabled = false;
 		klp_unpatch_objects(old_patch);
 	}
-- 
2.43.5


