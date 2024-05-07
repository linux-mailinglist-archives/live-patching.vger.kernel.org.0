Return-Path: <live-patching+bounces-242-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 442158BD956
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6589A1C2103E
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFB54A3D;
	Tue,  7 May 2024 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXpQ2fXn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022F8BFD;
	Tue,  7 May 2024 02:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715048260; cv=none; b=qyeC3YWgBJbYCF57o3xxfRs+rb3nj+lzZ2LV/5IY4DLJxljkCBRrol+TSLZy5AXYbBM7ocD5aZFX+BgZaxEQh/DQgmHhta1Z1W0WNrPQsn6vcJAMJ0640HtW46B3tYELOSRhi65f2PAtmpKWaPW+SHuI/BnehA/fW7fFPktzSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715048260; c=relaxed/simple;
	bh=Mctm1i3kSwzvwRAF1ZJudLXkCp/MaGcwYtc9PqloAeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SjjflI+DVG3feRDwr6p/3G4QzcPrWn4i7trQ/nu1W2tGlQbAE5X3iFg1zgGOhmOWIU7mc5D2hxYTo65GKMUrEYE1xcgrNusd/2uQqRTrjdK36t7IyIuIbF8aGo8QDE/qeFy1PJgBUFUtXchhHjrNNmK5eWO8x4RSRLV0GqgrY1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXpQ2fXn; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c963880aecso916033b6e.3;
        Mon, 06 May 2024 19:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715048258; x=1715653058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70YuHIQu2owelcfMBS1x27cnZb+rBx/kzqZGfjxYdVQ=;
        b=dXpQ2fXn1Rp/b0Iub9XrIR8G6VKEsnOou+diqmQdtu+ccGJwm2rFLkPR0DfhboGvIC
         sb8QzlLmKhMWKYzqnrT4Ton1zTz2Vb2SLLiTDA57dVsXfjQi0sEwV1GiwbHCU1hit1AD
         rP48OjfRkOpeGOMXabpwXdno3uhGF1YkdahTtdedJCgU6CJ01N0slf0/HSAnJxg8A/Xi
         3EfPR/hB5rn3+claG2xLElY/MWDVkk7R+KnPHVqBKaUB8aDsgsz1Dld2W66Anjd1pUog
         tMVrWUxuewmG4xEbjGjlNvxqefATxNGH9gNr45MjzpgX53gesWgTPwc+C2v+6pA55K5H
         lJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715048258; x=1715653058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=70YuHIQu2owelcfMBS1x27cnZb+rBx/kzqZGfjxYdVQ=;
        b=ON9puCsjOZURZewCoZja5II9RbNmYPUlvCC8hFVCao5sHV+HkECFw6aJo432NIFdUo
         6T5ncCG4jYMLAiIid7P3NYioOaEEU6Tiv40qK6FHqTnqw9PlFmMq6fCeHGsj9/4yjUyx
         UpDUDUb9NkgN1eUrkcOAGqvMpMH5xwRaUfRPAhB3+aJa4rGLK1eYhxI49bQb26IAUxKO
         O4hHj9ctLPIHyeLq3O0zsbWZy1smW8ej3Ni7KRYKipyq3tZ7iwmrRWgi4sZB3ifVqDh7
         4pKnzUMWsiamayq45WKzpmzmDb10+yeQxkrfcx5R5O9Szj3j5/z7MVOnRtKQmHCN9WcF
         dk9A==
X-Forwarded-Encrypted: i=1; AJvYcCXQz9RRNeWp2hm5dAUQ6FQ/deHJuDcohC87vmDtL0NQ8OXvnm7pISduild9fB/HtZ3dFr/90YUppD8F1CeUwpR3Kp4iYKIplJR+7WuD
X-Gm-Message-State: AOJu0YxYfnr+NGyoYPQqBxVJo6xxd26HOtMLK+108Oma4tpifvauMGVb
	6ZctztO8+PO7xeZEC9XzbrRE/sBFnunoHC6JK42CkmuH0swDQhpe
X-Google-Smtp-Source: AGHT+IH4rrjPkx0sVxEVDTJf5zMcJDJnRcIgJBeTpC74q7/zmfMtIODJeW8PkaxMEpSngur3ip3+4A==
X-Received: by 2002:aca:2408:0:b0:3c9:64c9:5a73 with SMTP id n8-20020aca2408000000b003c964c95a73mr7034868oic.30.1715048258250;
        Mon, 06 May 2024 19:17:38 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id u4-20020a056a00124400b006f3ea8a57edsm8357311pfi.133.2024.05.06.19.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 19:17:37 -0700 (PDT)
From: zhangwarden@gmail.com
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 1/1] livepatch: Rename KLP_* to KLP_TRANSITION_*
Date: Tue,  7 May 2024 10:17:14 +0800
Message-Id: <20240507021714.29689-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240507021714.29689-1-zhangwarden@gmail.com>
References: <20240507021714.29689-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

The original macros of KLP_* is about the state of the transition.
Rename macros of KLP_* to KLP_TRANSITION_* to fix the confusing
description of klp transition state.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 include/linux/livepatch.h     |  6 ++--
 init/init_task.c              |  2 +-
 kernel/livepatch/core.c       |  5 ++--
 kernel/livepatch/patch.c      |  4 +--
 kernel/livepatch/transition.c | 54 +++++++++++++++++------------------
 5 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9b9b38e89563..25db447367a3 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -18,9 +18,9 @@
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
 /* task patch states */
-#define KLP_UNDEFINED	-1
-#define KLP_UNPATCHED	 0
-#define KLP_PATCHED	 1
+#define KLP_TRANSITION_IDLE	        -1 /* idle, no transition in progress */
+#define KLP_TRANSITION_UNPATCHED	 0 /* transitioning to unpatched state */
+#define KLP_TRANSITION_PATCHED		 1 /* transitioning to patched state */
 
 /**
  * struct klp_func - function structure for live patching
diff --git a/init/init_task.c b/init/init_task.c
index 2558b719e053..eeb110c65fe2 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -199,7 +199,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	.trace_recursion = 0,
 #endif
 #ifdef CONFIG_LIVEPATCH
-	.patch_state	= KLP_UNDEFINED,
+	.patch_state	= KLP_TRANSITION_IDLE,
 #endif
 #ifdef CONFIG_SECURITY
 	.security	= NULL,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..39b767b22cd7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -40,6 +40,7 @@ DEFINE_MUTEX(klp_mutex);
 /*
  * Actively used patches: enabled or in transition. Note that replaced
  * or disabled patches are not listed even though the related kernel
+a
  * module still can be loaded.
  */
 LIST_HEAD(klp_patches);
@@ -973,7 +974,7 @@ static int __klp_disable_patch(struct klp_patch *patch)
 	if (klp_transition_patch)
 		return -EBUSY;
 
-	klp_init_transition(patch, KLP_UNPATCHED);
+	klp_init_transition(patch, KLP_TRANSITION_UNPATCHED);
 
 	klp_for_each_object(patch, obj)
 		if (obj->patched)
@@ -1008,7 +1009,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
 
-	klp_init_transition(patch, KLP_PATCHED);
+	klp_init_transition(patch, KLP_TRANSITION_PATCHED);
 
 	/*
 	 * Enforce the order of the func->transition writes in
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 4152c71507e2..90408500e5a3 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -95,9 +95,9 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 		patch_state = current->patch_state;
 
-		WARN_ON_ONCE(patch_state == KLP_UNDEFINED);
+		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
 
-		if (patch_state == KLP_UNPATCHED) {
+		if (patch_state == KLP_TRANSITION_UNPATCHED) {
 			/*
 			 * Use the previously patched version of the function.
 			 * If no previous patches exist, continue with the
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index e54c3d60a904..ba069459c101 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
 
 struct klp_patch *klp_transition_patch;
 
-static int klp_target_state = KLP_UNDEFINED;
+static int klp_target_state = KLP_TRANSITION_IDLE;
 
 static unsigned int klp_signals_cnt;
 
@@ -96,16 +96,16 @@ static void klp_complete_transition(void)
 
 	pr_debug("'%s': completing %s transition\n",
 		 klp_transition_patch->mod->name,
-		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
+		 klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
-	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
+	if (klp_transition_patch->replace && klp_target_state == KLP_TRANSITION_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
 	}
 
-	if (klp_target_state == KLP_UNPATCHED) {
+	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
 		/*
-		 * All tasks have transitioned to KLP_UNPATCHED so we can now
+		 * All tasks have transitioned to KLP_TRANSITION_UNPATCHED so we can now
 		 * remove the new functions from the func_stack.
 		 */
 		klp_unpatch_objects(klp_transition_patch);
@@ -123,36 +123,36 @@ static void klp_complete_transition(void)
 		klp_for_each_func(obj, func)
 			func->transition = false;
 
-	/* Prevent klp_ftrace_handler() from seeing KLP_UNDEFINED state */
-	if (klp_target_state == KLP_PATCHED)
+	/* Prevent klp_ftrace_handler() from seeing KLP_TRANSITION_IDLE state */
+	if (klp_target_state == KLP_TRANSITION_PATCHED)
 		klp_synchronize_transition();
 
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task) {
 		WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
-		task->patch_state = KLP_UNDEFINED;
+		task->patch_state = KLP_TRANSITION_IDLE;
 	}
 	read_unlock(&tasklist_lock);
 
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
 		WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
-		task->patch_state = KLP_UNDEFINED;
+		task->patch_state = KLP_TRANSITION_IDLE;
 	}
 
 	klp_for_each_object(klp_transition_patch, obj) {
 		if (!klp_is_object_loaded(obj))
 			continue;
-		if (klp_target_state == KLP_PATCHED)
+		if (klp_target_state == KLP_TRANSITION_PATCHED)
 			klp_post_patch_callback(obj);
-		else if (klp_target_state == KLP_UNPATCHED)
+		else if (klp_target_state == KLP_TRANSITION_UNPATCHED)
 			klp_post_unpatch_callback(obj);
 	}
 
 	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
-		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
+		  klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
-	klp_target_state = KLP_UNDEFINED;
+	klp_target_state = KLP_TRANSITION_IDLE;
 	klp_transition_patch = NULL;
 }
 
@@ -164,13 +164,13 @@ static void klp_complete_transition(void)
  */
 void klp_cancel_transition(void)
 {
-	if (WARN_ON_ONCE(klp_target_state != KLP_PATCHED))
+	if (WARN_ON_ONCE(klp_target_state != KLP_TRANSITION_PATCHED))
 		return;
 
 	pr_debug("'%s': canceling patching transition, going to unpatch\n",
 		 klp_transition_patch->mod->name);
 
-	klp_target_state = KLP_UNPATCHED;
+	klp_target_state = KLP_TRANSITION_UNPATCHED;
 	klp_complete_transition();
 }
 
@@ -218,7 +218,7 @@ static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
 	struct klp_ops *ops;
 	int i;
 
-	if (klp_target_state == KLP_UNPATCHED) {
+	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
 		 /*
 		  * Check for the to-be-unpatched function
 		  * (the func itself).
@@ -455,7 +455,7 @@ void klp_try_complete_transition(void)
 	struct klp_patch *patch;
 	bool complete = true;
 
-	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state == KLP_TRANSITION_IDLE);
 
 	/*
 	 * Try to switch the tasks to the target patch state by walking their
@@ -532,11 +532,11 @@ void klp_start_transition(void)
 	struct task_struct *g, *task;
 	unsigned int cpu;
 
-	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state == KLP_TRANSITION_IDLE);
 
 	pr_notice("'%s': starting %s transition\n",
 		  klp_transition_patch->mod->name,
-		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
+		  klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
 	/*
 	 * Mark all normal tasks as needing a patch state update.  They'll
@@ -578,7 +578,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	struct klp_func *func;
 	int initial_state = !state;
 
-	WARN_ON_ONCE(klp_target_state != KLP_UNDEFINED);
+	WARN_ON_ONCE(klp_target_state != KLP_TRANSITION_IDLE);
 
 	klp_transition_patch = patch;
 
@@ -589,7 +589,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	klp_target_state = state;
 
 	pr_debug("'%s': initializing %s transition\n", patch->mod->name,
-		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
+		 klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
 	/*
 	 * Initialize all tasks to the initial patch state to prepare them for
@@ -597,7 +597,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task) {
-		WARN_ON_ONCE(task->patch_state != KLP_UNDEFINED);
+		WARN_ON_ONCE(task->patch_state != KLP_TRANSITION_IDLE);
 		task->patch_state = initial_state;
 	}
 	read_unlock(&tasklist_lock);
@@ -607,19 +607,19 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 */
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
-		WARN_ON_ONCE(task->patch_state != KLP_UNDEFINED);
+		WARN_ON_ONCE(task->patch_state != KLP_TRANSITION_IDLE);
 		task->patch_state = initial_state;
 	}
 
 	/*
 	 * Enforce the order of the task->patch_state initializations and the
 	 * func->transition updates to ensure that klp_ftrace_handler() doesn't
-	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
+	 * see a func in transition with a task->patch_state of KLP_TRANSITION_IDLE.
 	 *
 	 * Also enforce the order of the klp_target_state write and future
 	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
 	 * __klp_sched_try_switch() don't set a task->patch_state to
-	 * KLP_UNDEFINED.
+	 * KLP_TRANSITION_IDLE.
 	 */
 	smp_wmb();
 
@@ -652,7 +652,7 @@ void klp_reverse_transition(void)
 
 	pr_debug("'%s': reversing transition from %s\n",
 		 klp_transition_patch->mod->name,
-		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
+		 klp_target_state == KLP_TRANSITION_PATCHED ? "patching to unpatching" :
 						   "unpatching to patching");
 
 	/*
@@ -741,7 +741,7 @@ void klp_force_transition(void)
 		klp_update_patch_state(idle_task(cpu));
 
 	/* Set forced flag for patches being removed. */
-	if (klp_target_state == KLP_UNPATCHED)
+	if (klp_target_state == KLP_TRANSITION_UNPATCHED)
 		klp_transition_patch->forced = true;
 	else if (klp_transition_patch->replace) {
 		klp_for_each_patch(patch) {
-- 
2.37.3


