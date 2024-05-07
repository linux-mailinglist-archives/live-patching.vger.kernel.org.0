Return-Path: <live-patching+bounces-249-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C058BDA77
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 07:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68430282F0A
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 05:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7FB6A8AE;
	Tue,  7 May 2024 05:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4NyOVP1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B024A12;
	Tue,  7 May 2024 05:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715058101; cv=none; b=BdAKRM00aX0BQ0eN7BbpO9G9fJQFPzww1dQvC32jd2KkjAErE8Xb2DGLiRoZn/SL57sRC+xTcWiYpfHUuydWVzWRyAh+Pixl56u38tDPf6em25iLjeucsF6gpWWHTT7Cmu35wlSRxiVJyEvdeQ3mDyPgy5uh0zFviUx29ug8HWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715058101; c=relaxed/simple;
	bh=/LEwJQaoxTWOz3OpzgUgfGp8zBcgAZBQ26UJcPtYtA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dKFVjDVs60L7AS0blcc9jqMd3HIy/ZwFFVxfQ9fZVoq77KFcJUu7ZTtz2Iv4o+LSUAtDBbfaVoQRnTYhnCe5w0W8yIvdzQaa6QFLYRU6kITJlq4L1joHi8ONWCh9buNExjbuYqnpTWK/i/O34MpGY0qYQOiZzrW4XFd9arBI4G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4NyOVP1; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2b43490e0e2so1790114a91.2;
        Mon, 06 May 2024 22:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715058099; x=1715662899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mtN94j+lNHyybJ7C8WwKJdIeg+2tzu+Ix5x0Ce2YrE=;
        b=V4NyOVP1uvJIm8zPKk+Ed4xcinMBqM+G7jC94v5mFgKu6UA/cMFqh6S/SlKqYBs7GC
         +SI/JFvfGfMlwiU7m1T55RfWZTyNF9GFo0vl3BivjlECHWDofoW02ZZd5u01NMWcj6nD
         U+YThJNMzO2t99hG2OIJzUPHtIuTuiRlFiyxNyQRJQNcUsj08wjOWdVAcMN4pJQdlc3z
         TpcAe3qezNoO9DI0PE0W2a+/1pR6B1hZyAPor9V89B/EW7qDMJLGYdrCFLo3m01a6ag0
         eAip+ST1+ZHdfFdEVj+GwBnysUG9tu/NNJv8NPhnljsaO9t8/XC/YaT1XWn9jR5ja/oc
         iWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715058099; x=1715662899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mtN94j+lNHyybJ7C8WwKJdIeg+2tzu+Ix5x0Ce2YrE=;
        b=V0WEKpIQZ6/PlDxoRRgCu2kFFAOMpf/MWasbzatcieGn9QCHezezQd5c3k30ztPmQ4
         UZmjymDcg/mTe4nq0nKq+r+nz9H48r3SBGF6SEfoQPMrfmpgUjLoKxzEttT6C3pL2NaV
         gaIiqEOHbfIR1rjyq7BoZmU6uohrfk2RxyMy4DvKjE8eJtkG9Oi9JXjqVi3PBCDAB1/e
         vTEfP+1Y8C000rlX9RgEVYAQRKsNZ5xiuAHSFVOZGxA8mc11UYgJu0zz5XHfI/87ejn6
         dNCAj0p/DwZIlWh66ebl8Oiut12cdi/2jhZ0cfCvrZheHP+1tY+G4WRsw08TbCeQ7CLZ
         WsYA==
X-Forwarded-Encrypted: i=1; AJvYcCW6dftxUXoXfF6SPwuHzyHb/DjxPkZG8a3+2cu3SKk9QFR21FdjMaDlREMwA9NBcpX9WRG6+vf+rd0cEFPmkmGcyy0kbOISb2M/Iri9
X-Gm-Message-State: AOJu0YxgishV5c3tLGBjwQ8aHQO9lrZbjj0trQRNJz95bdJLEFPVDIdV
	6+3RKCfRXnBg13SbuygEu+HiziePg316u202qxJoxkiXeFbKiiqp
X-Google-Smtp-Source: AGHT+IE8drIHRE0DZ/NUnuG66sN4WKt7cEfDyGYBuHyskBvaHacHSgqHajnEsarkmnJihZWZG6YbQA==
X-Received: by 2002:a17:90b:374e:b0:2b0:8497:1c57 with SMTP id ne14-20020a17090b374e00b002b084971c57mr9432335pjb.27.1715058093954;
        Mon, 06 May 2024 22:01:33 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id nc15-20020a17090b37cf00b002b115be650bsm10894236pjb.10.2024.05.06.22.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 22:01:33 -0700 (PDT)
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
Date: Tue,  7 May 2024 13:01:11 +0800
Message-Id: <20240507050111.38195-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240507050111.38195-1-zhangwarden@gmail.com>
References: <20240507050111.38195-1-zhangwarden@gmail.com>
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
 kernel/livepatch/core.c       |  4 +--
 kernel/livepatch/patch.c      |  4 +--
 kernel/livepatch/transition.c | 54 +++++++++++++++++------------------
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9b9b38e89563..51a258c24ff5 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -18,9 +18,9 @@
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
 /* task patch states */
-#define KLP_UNDEFINED	-1
-#define KLP_UNPATCHED	 0
-#define KLP_PATCHED	 1
+#define KLP_TRANSITION_IDLE		-1
+#define KLP_TRANSITION_UNPATCHED	 0
+#define KLP_TRANSITION_PATCHED		 1
 
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
index ecbc9b6aba3a..52426665eecc 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -973,7 +973,7 @@ static int __klp_disable_patch(struct klp_patch *patch)
 	if (klp_transition_patch)
 		return -EBUSY;
 
-	klp_init_transition(patch, KLP_UNPATCHED);
+	klp_init_transition(patch, KLP_TRANSITION_UNPATCHED);
 
 	klp_for_each_object(patch, obj)
 		if (obj->patched)
@@ -1008,7 +1008,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
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


