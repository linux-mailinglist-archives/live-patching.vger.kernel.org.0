Return-Path: <live-patching+bounces-211-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CCB8949D9
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 05:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21BDD1F232F8
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 03:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1DE14286;
	Tue,  2 Apr 2024 03:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYVTBiqJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C601DDC5;
	Tue,  2 Apr 2024 03:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712027403; cv=none; b=kgKzptd/7LjhRhVc+YNHolZdp51L1PppHQrIj1hlK9dkCe69CDxjddVfq90Vwpb9cljobnGzibZRzuk3pfZKO/iYAngCMNHpVtQWeULJMFhPNYMOEmrgli1I0CmbCl6C5FY8KFwZ3a7wR6rjjZ4NYu250oyblfZzUyQOvmfK9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712027403; c=relaxed/simple;
	bh=mnqRukvCdTyAPFCDyHkZSYowon2cIHEa1QBPg54U3BI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nqijDdYNGztrKMoUa57bl3l0Tg2Iw0nz58jIDdgj97yvkLkQJlChjlXegGejsOaO9PgQym9Pff/A1AcszqwqUvgujz+b5agkcoxAstkZ6NoUQuPCsCJ/mnUGAFco3dqJmHGq4ThFGPQpXUP3ekEm/dHAn6OEE5FKqS+/owtwZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYVTBiqJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e0d8403257so35532615ad.1;
        Mon, 01 Apr 2024 20:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712027401; x=1712632201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I1DlfPpotoso/pak1GexITqKw1uQHI/IrjYhTJCiO68=;
        b=nYVTBiqJOWTvAZMOugZDRIVpCEliXK6iE0vNL98nTyRYud2oTjTQMmDXimn7Er9/pH
         qIBD6YE2JxUD/E1bf0NWkCLBh0/Zv2Ju4t+DJrlII8+WkNav1tey7ScImwWTd171sQQg
         2FhoMYxyxZwx2ETGEu+SPd8MaKVLCbDUBifa/ZJkRCuslijQLreXuaGiu5nTLc9zDhQJ
         OHcdCw6XXm7nxE7Xswp5tstP4nWVUoEsZRwi+W0gN9FpS76qcE3UwEn//ZEt5HgdPvRh
         nxedblJjHrIgCuVma4Q0vzQYZRGSZjVmR8WkdnJzoR7hcXuoz2a9mPfvmVEMmGwP7O9m
         mWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712027401; x=1712632201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I1DlfPpotoso/pak1GexITqKw1uQHI/IrjYhTJCiO68=;
        b=o2OjWHDTpL82FKpj49Ugdhkrj5eawCE7UBJ6Knt5YHr0toTvBPVtA/FWAOn95Ef0w0
         yP+1Ib4aVSsTxrOQAsdrua6yfWKn6wF3usZMKr5so2IVZRE/AMIx9CG/VPrzcf4Ei288
         hiTRXjbicuacfWr6+J5XfQqzIc6fxA+SUrnInJFi/6mS8bFFSH64ij7CWVAzWq0Mvs2G
         9LRD5Xadj7SH2ks+X1V2l583o+1e5/7UpyAUXvXI9TG4yGDA/W8l8bkLqcYJtQTqGLz4
         UpKwsR7iQpO6b8qJS4vGoK1vKF030UANQF8gSO53XzouybqqCRjSrfkA4mkHyVukikZS
         oG4g==
X-Forwarded-Encrypted: i=1; AJvYcCUKR14ORqxZA20LYQ74I1caIsYzwqLW/sY/+WSGD+5+5aKo0+bzE0epL1pH3xG3IRNbAs1/fDoTimpnjvGskMrD+GALb4Hh2aV4nLaS
X-Gm-Message-State: AOJu0YxOLBWpKQAEOTrbZZS9US0uUei8qDjCsqhPFtaoSAk+FFV7qdbM
	jL05d/WUtfq0fbrByG6tfBJpXVf1j8Xlud50zJVeog6VaK00efSB
X-Google-Smtp-Source: AGHT+IFTapLU64q74n2xBF2kkX76s6m9g+faEqumMU+8AdyVoLW6gh2WCL4/RYBOhO/mXyyppL4xDw==
X-Received: by 2002:a17:902:7881:b0:1e0:cd01:9fd with SMTP id q1-20020a170902788100b001e0cd0109fdmr8960191pll.26.1712027401310;
        Mon, 01 Apr 2024 20:10:01 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b001e0a61cb886sm9747841plh.120.2024.04.01.20.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 20:10:00 -0700 (PDT)
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
Date: Tue,  2 Apr 2024 11:09:54 +0800
Message-Id: <20240402030954.97262-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

In livepatch, using KLP_UNDEFINED is seems to be confused.
When kernel is ready, livepatch is ready too, which state is
idle but not undefined. What's more, if one livepatch process
is finished, the klp state should be idle rather than undefined.

Therefore, using KLP_IDLE to replace KLP_UNDEFINED is much better
in reading and understanding.
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


