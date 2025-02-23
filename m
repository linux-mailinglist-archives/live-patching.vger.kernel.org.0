Return-Path: <live-patching+bounces-1223-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71204A40CF1
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 07:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8175417823F
	for <lists+live-patching@lfdr.de>; Sun, 23 Feb 2025 06:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC071DA63D;
	Sun, 23 Feb 2025 06:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhYHRBaC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314811C84DD;
	Sun, 23 Feb 2025 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740291671; cv=none; b=UQ/av1p6e6ADJph82ACdz+jcCHAnfxqv8RE6frblyHEhfla/+q2rSUaOt1K2/nnEdzpNZidBk/l9s4B98L0RY66P9hqfp5t5fU58rOBvIhr4kg98DXKlUpeJ0aRl/TF1ms0RQfm9sKl3JwZsqorrGotNZRnHPJao4EaRwMhkhTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740291671; c=relaxed/simple;
	bh=EAbTiBt0vbqz7Eckd3N6ONhKdF5omR8ineaSQGYw2gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vn60L5xSnNf3QrfJNV7nYfEMcdTGNQ70dM9gu3SQrk89xThbCCbe3h7r3it4DhUKyxI9n7btrU2CSIP0lTN041z0Bx/SPABMVEJQYuR+f0fVfgrH5tkfaJx3mXx06tfnGHoBhQEeR70RmFCwO9QPBF/bIjaSs544ZNzt+3qdPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhYHRBaC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-220e6028214so73384265ad.0;
        Sat, 22 Feb 2025 22:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740291666; x=1740896466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Z2GJmTzeGj4EN3VSoIAcvWrzfzVxHWYzShnooMd6fI=;
        b=FhYHRBaCTTp2Ex4wtinD1Eb6SKd921jN06x55vPG7TEvlqKIyZ6iCITSjG1XbRF2ef
         QAcFe7mE89GE8Xk5vhdTwdb7IjeLKVgt3Ur3CXNUXsp1R5U3sqWTGG0olvnoSGTfqEH/
         GuG4EuBKk2G+WFVy9JqdWw/MsWUBrM8rUdItcOPbpro3zURk9FmnuVUa048wAnwhpDzY
         xQappn0dBj8ISjlPTPBkkhSC/GRw0E4JlW6ICIv6KVOBBcUPOU0CRZnAbbrEKEqRmyYX
         6tLIP0OkpOHMzsPY8+Xt5gtU1du8EkBkEOsiMkRuVnYNe3L0MajlyxJ/C1s9FJK39dXx
         rWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740291666; x=1740896466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Z2GJmTzeGj4EN3VSoIAcvWrzfzVxHWYzShnooMd6fI=;
        b=six65+aky/f8DM3pl6ZVsEJy/SqbTBZ85q+y7XM+Vn4YRxW6XY900HyN/x5tcT9WhU
         jeH/xeCvRt5Ezhb4bT0bkbAYvqauj7ctDVxFt/p1xd8jNoNhVchHAH8yk2mblCnhj9RF
         B7iXYSbN0J134bB3BqAm+9FFvOGdeL8l5OIddKDTROxL7P8BaePO8FtHhB9aIKKYyyCc
         2GWSOaMXiUXpNJC2Ey6F1VarpcrXQxeMc2ZKXMAm6CGo45FSHc/3iyaaMgtxaq85yeWH
         aU8wCEUSdM5oqVdjWKOS+MFdMxR2i+NeXpzpuEe1EKzg540RtCI9xu/jyp4mUylaPb3/
         VAoA==
X-Forwarded-Encrypted: i=1; AJvYcCURcI23eioAEubUpxAhgJCkOOtjOf3TUd6R2EwV1/0P5kYz2Qb5bVld3I/jFSitL/luB146vB3YCFA714Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqErnur5d20NU0N3h23kZPNgusFBBrTI03frdR+5KyGEb7g2xx
	Bn30y/0yqKwJx6kAHb4lkxiugLIfM/JxiMELrfL0Eri/Xx16u+lQ
X-Gm-Gg: ASbGncviYCBbP7YibhlHz3V9jYVOwo5TpUZFtTz4hz8W28zSUgidywEwZ1ye1T7UqW7
	CEvB2AQLjuEE79QIBu1yPuDlE9Z2MQF5v6WbqwwWIrIlqLlsmqSQFOS5le3/retxFZ9PtU5O2up
	I//q4wW6QOpzhqQIWliWs10cKqCsNmMD251SnpTlD8ooG8YJ1XG4mAHgiCW4IUXQU8rzonrWwFI
	84StxCb+K3rFdQq/2gdbkvPA4u+UuNnfizlykxQXMUuc3D7pNJevs3L5332li5dxx7dmJoxpFRm
	fPOS9cVhnJhOJEVfItKl2UYpNUhkp2Sis3XfbgBtdPsPw0kTvMI=
X-Google-Smtp-Source: AGHT+IE7MSQSoGKzifVL3ZzOf04hSMJvugBu/CqYY7Cb81rTd6tX1n3ErSxzrifLSnKw+/0gra+J/g==
X-Received: by 2002:a17:903:22d1:b0:215:4a4e:9262 with SMTP id d9443c01a7336-2219ff8287bmr119209455ad.8.1740291666512;
        Sat, 22 Feb 2025 22:21:06 -0800 (PST)
Received: from localhost.localdomain ([39.144.244.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d558ed3fsm160750795ad.232.2025.02.22.22.21.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Feb 2025 22:21:05 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 2/2] livepatch: Replace tasklist_lock with RCU
Date: Sun, 23 Feb 2025 14:20:46 +0800
Message-Id: <20250223062046.2943-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250223062046.2943-1-laoar.shao@gmail.com>
References: <20250223062046.2943-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tasklist_lock in the KLP transition may cause high latency under
certain workloads. To address this, we can replace it with RCU.

When a new task is forked, its kernel stack is always initialized to
empty[0]. As a result, we can set these new tasks to the
KLP_TRANSITION_IDLE state immediately after forking. If these tasks are
forked during the KLP transition but before klp_check_and_switch_task(), it
is safe to switch them to the klp_target_state within
klp_check_and_switch_task(). Additionally, if the klp_ftrace_handler() is
triggered before the task is switched to the klp_target_state, it is also
safe to perform the state transition within this ftrace handler[1].

With these changes, we can safely replace the tasklist_lock with RCU.

Link: https://lore.kernel.org/all/20250213173253.ovivhuq2c5rmvkhj@jpoimboe/ [0]
Link: https://lore.kernel.org/all/20250214181206.xkvxohoc4ft26uhf@jpoimboe/ [1]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h     |  4 ++--
 kernel/fork.c                 |  2 +-
 kernel/livepatch/patch.c      |  7 ++++++-
 kernel/livepatch/transition.c | 35 ++++++++++++++---------------------
 kernel/livepatch/transition.h |  1 +
 5 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..41c424120f49 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -198,7 +198,7 @@ int klp_enable_patch(struct klp_patch *);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
-void klp_copy_process(struct task_struct *child);
+void klp_init_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
 static inline bool klp_patch_pending(struct task_struct *task)
@@ -241,7 +241,7 @@ static inline int klp_module_coming(struct module *mod) { return 0; }
 static inline void klp_module_going(struct module *mod) {}
 static inline bool klp_patch_pending(struct task_struct *task) { return false; }
 static inline void klp_update_patch_state(struct task_struct *task) {}
-static inline void klp_copy_process(struct task_struct *child) {}
+static inline void klp_init_process(struct task_struct *child) {}
 
 static inline
 int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
diff --git a/kernel/fork.c b/kernel/fork.c
index 735405a9c5f3..da247c4d5ec5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2544,7 +2544,7 @@ __latent_entropy struct task_struct *copy_process(
 		p->exit_signal = args->exit_signal;
 	}
 
-	klp_copy_process(p);
+	klp_init_process(p);
 
 	sched_core_fork(p);
 
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..5e523a3fbb3c 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -95,7 +95,12 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 		patch_state = current->patch_state;
 
-		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
+		/* If the patch_state is KLP_TRANSITION_IDLE, it indicates the
+		 * task was forked after klp_init_transition(). For this newly
+		 * forked task, it is safe to switch it to klp_target_state.
+		 */
+		if (patch_state == KLP_TRANSITION_IDLE)
+			current->patch_state = klp_target_state;
 
 		if (patch_state == KLP_TRANSITION_UNPATCHED) {
 			/*
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..ae4512e2acc9 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
 
 struct klp_patch *klp_transition_patch;
 
-static int klp_target_state = KLP_TRANSITION_IDLE;
+int klp_target_state = KLP_TRANSITION_IDLE;
 
 static unsigned int klp_signals_cnt;
 
@@ -294,6 +294,13 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
 {
 	int ret;
 
+	/* If the patch_state remains KLP_TRANSITION_IDLE at this point, it
+	 * indicates that the task was forked after klp_init_transition(). For
+	 * this newly forked task, it is now safe to perform the switch.
+	 */
+	if (task->patch_state == KLP_TRANSITION_IDLE)
+		goto out;
+
 	if (task_curr(task) && task != current)
 		return -EBUSY;
 
@@ -301,6 +308,7 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
 	if (ret)
 		return ret;
 
+out:
 	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	task->patch_state = klp_target_state;
 	return 0;
@@ -466,11 +474,11 @@ void klp_try_complete_transition(void)
 	 * Usually this will transition most (or all) of the tasks on a system
 	 * unless the patch includes changes to a very common function.
 	 */
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	for_each_process_thread(g, task)
 		if (!klp_try_switch_task(task))
 			complete = false;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * Ditto for the idle "swapper" tasks.
@@ -694,25 +702,10 @@ void klp_reverse_transition(void)
 }
 
 /* Called from copy_process() during fork */
-void klp_copy_process(struct task_struct *child)
+void klp_init_process(struct task_struct *child)
 {
-
-	/*
-	 * The parent process may have gone through a KLP transition since
-	 * the thread flag was copied in setup_thread_stack earlier. Bring
-	 * the task flag up to date with the parent here.
-	 *
-	 * The operation is serialized against all klp_*_transition()
-	 * operations by the tasklist_lock. The only exceptions are
-	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
-	 * cannot race with them because we are current.
-	 */
-	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
-		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
-	else
-		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
-
-	child->patch_state = current->patch_state;
+	clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
+	child->patch_state = KLP_TRANSITION_IDLE;
 }
 
 /*
diff --git a/kernel/livepatch/transition.h b/kernel/livepatch/transition.h
index 322db16233de..febcf1d50fc5 100644
--- a/kernel/livepatch/transition.h
+++ b/kernel/livepatch/transition.h
@@ -5,6 +5,7 @@
 #include <linux/livepatch.h>
 
 extern struct klp_patch *klp_transition_patch;
+extern int klp_target_state;
 
 void klp_init_transition(struct klp_patch *patch, int state);
 void klp_cancel_transition(void);
-- 
2.43.5


