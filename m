Return-Path: <live-patching+bounces-210-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A6B8949D4
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 05:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BF441F232DB
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 03:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9651C14267;
	Tue,  2 Apr 2024 03:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vinspx8H"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0859A171A2;
	Tue,  2 Apr 2024 03:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712027335; cv=none; b=WYF2BeTunVEBqGv0rYyuymBkRKDlRHz4FJ/d/ynkGWD2Az6f3iWZrBccnX3Qz9kVDH1x+xWGGF9ppPeVUtONWKxBCC3EGKLHpWZvxvkC8Sr5UtpUidhl5boaa3pMOsRSwEHuQmOI3ZzQkNWWuZPSiE46DlyIj2rQcQPwq3Eq2Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712027335; c=relaxed/simple;
	bh=q5epvprd28QPR0xJUM6qddThlODsgRH89kRI2H4s5Y4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J1I5CcdcUOTQWlyxmuO6I8Y50Mz8XegiGwCdDsKS5hP82JdjagJzCPS7Kbledy2Qwm2Lja6xcXXtePvrMJg2KU7gHIW0n7E6HGJSA6UCa0aFoQCrZnY7YS+QuC5SPSV/ASy4z708Pt5D34jIQWZA77OTbEN3pOx/AkPPp78aGps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vinspx8H; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e709e0c123so4057473b3a.1;
        Mon, 01 Apr 2024 20:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712027333; x=1712632133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JE97ZYfRuDOWmSKGC8QdajHr833+yDVg9himjtwMges=;
        b=Vinspx8HHSrVTVBj3G8osS87jT6vH2yStnkP0/0oZYF+ag9uJVGtYXbPFpNo1JHk37
         ySWmimBKWwNkw9EVwIphYe6bIBj4TWaLJrKxtCnH67D3WmLOquU/PnxJz090yFdA+roL
         az1D15rCcKQhMXkYiGVrsOM8FfQX0INPHTPoki9+gRZfhqZ5UhNnuJCaDqxJBKXC+nbV
         PiOafMXTSqy3Q1LcNCiOBj6G6SAUyz4uVwt2bfyiwbufpeVZgvvp8qOHH68tJsEDpOaJ
         Hi2DfxqL3/g05+oCmSy6UfaI9yKPNO5l7LBBkF11BEb5JaHgk87Ko2xUBRHdtBnTFjp5
         0qPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712027333; x=1712632133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JE97ZYfRuDOWmSKGC8QdajHr833+yDVg9himjtwMges=;
        b=TneWwXSazPE4ueFe/zE9DGmhynl42G1gBFMOlhG0C4WGhqoHfgsfAB+fTMNO5F0Q0D
         q+EpoPGcWlG4MLzzS+Z5fRL6FccxOLS71bKWDKj7j1LtGdszqa7NSZSA9LgqLftwxoji
         IZbsU3p27yaS4lgoUQ7bFbPEzHGTL3OYBQaFtsly1dDZzbk0srCOcdPm3Ybct7jOjCxc
         wnurYymrLbwdWqdX20st9rS8dMc+B6lJK3vAkOycfSQKUhT0/RxCCoOMdIbniBmax2EI
         5+ZbN7KNUcSvzMewj+jAHmCae3Vyvq5bYPuZIK6C+6UYukegj0jdA7aD2c2D30cKXYGK
         /Igg==
X-Forwarded-Encrypted: i=1; AJvYcCXCDp/cOnuMadxD8enn8fRhB6NixuN2EjrO8J0ZMc931D/QiS5EH5rBl31g4t6386PyhO4nVx+UD8yqa+MXfin2SqINjhILa9IRFvDG
X-Gm-Message-State: AOJu0YwtjFz3CW/t3KgV4410wF/8jXcp8EUhahxYU+zGCahiuPK415m9
	xQt6SpiQYOpfpnkRtQR+nfemDYTtverDxRpoPgpM9HiWSeg/CvMm
X-Google-Smtp-Source: AGHT+IHOPgNefQC8eWIeNd41hMq3I8N7rZGCMXj8ytAEOFswc4ifwjelrPzEV5Xi/6vX3HNUbwK2cw==
X-Received: by 2002:a05:6a00:194a:b0:6ea:8eed:d369 with SMTP id s10-20020a056a00194a00b006ea8eedd369mr12305298pfk.20.1712027333239;
        Mon, 01 Apr 2024 20:08:53 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00000200b006e6b4c637b6sm8591528pfk.116.2024.04.01.20.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 20:08:52 -0700 (PDT)
From: zhangwarden@gmail.com
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] livepatch: Add KLP_IDLE state
Date: Tue,  2 Apr 2024 11:08:27 +0800
Message-Id: <20240402030827.97207-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

---
 include/linux/livepatch.h     |  1 +
 kernel/livepatch/patch.c      |  2 +-
 kernel/livepatch/transition.c | 24 ++++++++++++------------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9b9b38e89563..c1c53cd5b227 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -19,6 +19,7 @@
 
 /* task patch states */
 #define KLP_UNDEFINED	-1
+#define KLP_IDLE       -1
 #define KLP_UNPATCHED	 0
 #define KLP_PATCHED	 1
 
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 4152c71507e2..01d3219289ee 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -95,7 +95,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 		patch_state = current->patch_state;
 
-		WARN_ON_ONCE(patch_state == KLP_UNDEFINED);
+		WARN_ON_ONCE(patch_state == KLP_IDLE);
 
 		if (patch_state == KLP_UNPATCHED) {
 			/*
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index e54c3d60a904..73f8f98dba84 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
 
 struct klp_patch *klp_transition_patch;
 
-static int klp_target_state = KLP_UNDEFINED;
+static int klp_target_state = KLP_IDLE;
 
 static unsigned int klp_signals_cnt;
 
@@ -123,21 +123,21 @@ static void klp_complete_transition(void)
 		klp_for_each_func(obj, func)
 			func->transition = false;
 
-	/* Prevent klp_ftrace_handler() from seeing KLP_UNDEFINED state */
+	/* Prevent klp_ftrace_handler() from seeing KLP_IDLE state */
 	if (klp_target_state == KLP_PATCHED)
 		klp_synchronize_transition();
 
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task) {
 		WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
-		task->patch_state = KLP_UNDEFINED;
+		task->patch_state = KLP_IDLE;
 	}
 	read_unlock(&tasklist_lock);
 
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
 		WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
-		task->patch_state = KLP_UNDEFINED;
+		task->patch_state = KLP_IDLE;
 	}
 
 	klp_for_each_object(klp_transition_patch, obj) {
@@ -152,7 +152,7 @@ static void klp_complete_transition(void)
 	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
 		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
-	klp_target_state = KLP_UNDEFINED;
+	klp_target_state = KLP_IDLE;
 	klp_transition_patch = NULL;
 }
 
@@ -455,7 +455,7 @@ void klp_try_complete_transition(void)
 	struct klp_patch *patch;
 	bool complete = true;
 
-	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state == KLP_IDLE);
 
 	/*
 	 * Try to switch the tasks to the target patch state by walking their
@@ -532,7 +532,7 @@ void klp_start_transition(void)
 	struct task_struct *g, *task;
 	unsigned int cpu;
 
-	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state == KLP_IDLE);
 
 	pr_notice("'%s': starting %s transition\n",
 		  klp_transition_patch->mod->name,
@@ -578,7 +578,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	struct klp_func *func;
 	int initial_state = !state;
 
-	WARN_ON_ONCE(klp_target_state != KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state != KLP_IDLE);
 
 	klp_transition_patch = patch;
 
@@ -597,7 +597,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task) {
-		WARN_ON_ONCE(task->patch_state != KLP_UNDEFINED);
+		WARN_ON_ONCE(task->patch_state != KLP_IDLE);
 		task->patch_state = initial_state;
 	}
 	read_unlock(&tasklist_lock);
@@ -607,19 +607,19 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 */
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
-		WARN_ON_ONCE(task->patch_state != KLP_UNDEFINED);
+		WARN_ON_ONCE(task->patch_state != KLP_DILE);
 		task->patch_state = initial_state;
 	}
 
 	/*
 	 * Enforce the order of the task->patch_state initializations and the
 	 * func->transition updates to ensure that klp_ftrace_handler() doesn't
-	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
+	 * see a func in transition with a task->patch_state of KLP_IDLE.
 	 *
 	 * Also enforce the order of the klp_target_state write and future
 	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
 	 * __klp_sched_try_switch() don't set a task->patch_state to
-	 * KLP_UNDEFINED.
+	 * KLP_IDLE.
 	 */
 	smp_wmb();
 
-- 
2.37.3


