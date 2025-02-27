Return-Path: <live-patching+bounces-1236-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F35A4732E
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 03:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BAB2188C3CC
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 02:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D0715E5DC;
	Thu, 27 Feb 2025 02:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sqi2jVil"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D5818035
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 02:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740624478; cv=none; b=FMMerCMNyuhyMjc1rPVAuuSKLodhunM5KmD4gFz9vUq+oJ7ROBsJkypfkxXr4CTFhVAC2gncJ+8Ft/iNDcn9bEbKruJGUSVd/dW6ATF/0P2O49Gj8dsyx3b/NAvdr34Hyr6zCGh9XrBO8bNWr2YEGAdiH9yNup78sgl7+nq4bP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740624478; c=relaxed/simple;
	bh=dBYeTnQ2KezXEuLPj/I7aH0AmK/HEzM/HyKyNMvPp94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PCvccLLciS7+j4KIQRPqcXFQEAbA2iXCQ0i5ceuR97+dzTx/lxxIvb5zOwzXqKxdCM3Zmjm6xjpLdkG3VzFdQYOMqlbHneo6qNcAj8W2/ixK4mfo0z5/YPewnrjqnrwq9tBihh1IzQrA0MHyovBW3UDWjdsf8I+ch/UFF2JGbMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sqi2jVil; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-219f8263ae0so7216525ad.0
        for <live-patching@vger.kernel.org>; Wed, 26 Feb 2025 18:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740624476; x=1741229276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6Aypr33KkO0kAwBxOIdwjSHu0AqfEFCyeXZeQR9PkU=;
        b=Sqi2jVilobkyGTr8mqURfVs9YK9KM21GlAvhbmuhacn4O2hs6cH8Y8360Gx5lA7MpU
         xKMDcVwFndOU4oa4dmd3LVj57QkKosgcfIo8t20427mEiTVSBS3JkOutvvaHxUfNEwQu
         cJvFtuo90zTD6inLXIi1koxBDo+wpn6SOli4XHxSQYkWXwWGrZ6FpOVnTmoakPJ3+MuJ
         j5RNlPOvuZTjAt95q+Zbnd60eykT6cS79RQjBZ9KZ27jDk1pffASHd+VES4FOHTQoXMK
         9fVyLZORck2Xt8g6QyH7HGEj2a84v8K2OesYQ0FxUMFce+K+ENIp/s35m+kgLizjdLom
         iFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740624476; x=1741229276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6Aypr33KkO0kAwBxOIdwjSHu0AqfEFCyeXZeQR9PkU=;
        b=NULe0TFmM675tpP4P3KPM48SkRvRtKZuUQE4tnMXkaQElXKAmYheyobCRXnkDyID6s
         WwcBJMnH7kG9LDH4+VDICN5UaLKl4rVqvUE329XtZDEmPgRAISjJUwtEJgysrTQIKU2K
         v8AMyw4QjAcaL+tMH12eaUbOWZyhOMIm1hxQc5JPJyR2IJKHDa8ilU6tNXpFrI+C9IDe
         mG6pIsFSEffFL6zRoJq0jHgfwo3II7cq4lZUQxo8MLFLhd6fZdvuHnYOrq1L/snbp8Uy
         kAb4THNvWobxwQmeNnISZ9D9K91kTbzejYmZs7ZPN6Kw45mRM5OtjaujQIrj7hK/HhMZ
         DJvw==
X-Gm-Message-State: AOJu0YxPdTLapkcE5I39m9XggXhfVr/WNNq3cGjV6Lpq/uTGPT4v1v+i
	SoZR92snUP8Bg/x7qQGizSCpm3nglmPBkxOCeTCgXbKMu6jGrlFA
X-Gm-Gg: ASbGncu8gSQ8kLfD253B4sjSf6+k8ctLmN18n1Wzn+C8v1934fksS5l/sAuR4vicKds
	3/bQcGGnNwvwFlvx2STybFf/lksuVZh75x9w0zG86cpueky4JE0Oof97HKSNECd2BLeo2IQ8KJD
	UrlHZFqlw4jeMazf9POoI5h3ikyqFdIWJ/Y/NrDcF6++eO+RH4ducOrdGMsdSswKmrBW7QsVIHB
	/2XnkBOiBJ2sqmGaLTEdrcvSzKBvMGO4FlW3ZDz1RHZE0W2ra7Mm39YlUQqQ2rDV2QSZAWEdNqF
	5rzSv/DTd8E4fwo+gSTB7ly2rSgxTFnVbJo8lAK9ciNKd7wTLQ==
X-Google-Smtp-Source: AGHT+IFWwzW3S22hdf2HwVdaML40mlV5rajQgAJiyHzhwv+gqBpwcyWFsGoGSOgwWGjw2vWPUSl0Kw==
X-Received: by 2002:a17:902:ebd1:b0:223:325c:89f6 with SMTP id d9443c01a7336-223325c8ef5mr65292445ad.10.1740624475828;
        Wed, 26 Feb 2025 18:47:55 -0800 (PST)
Received: from localhost.localdomain ([61.173.25.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050fdafsm3681905ad.214.2025.02.26.18.47.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Feb 2025 18:47:55 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 2/2] livepatch: Replace tasklist_lock with RCU
Date: Thu, 27 Feb 2025 10:47:33 +0800
Message-Id: <20250227024733.16989-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250227024733.16989-1-laoar.shao@gmail.com>
References: <20250227024733.16989-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tasklist_lock in the KLP transition might result high latency under
specific workload. We can replace it with RCU.

After a new task is forked, its kernel stack is always set to empty[0].
Therefore, we can init these new tasks to KLP_TRANSITION_IDLE state
after they are forked. If these tasks are forked during the KLP
transition but before klp_check_and_switch_task(), they can be safely
skipped during klp_check_and_switch_task(). Additionally, if
klp_ftrace_handler() is triggered right after forking, the task can
determine which function to use based on the klp_target_state.

With the above change, we can safely convert the tasklist_lock to RCU.

Link: https://lore.kernel.org/all/20250213173253.ovivhuq2c5rmvkhj@jpoimboe/ [0]
Link: https://lore.kernel.org/all/20250214181206.xkvxohoc4ft26uhf@jpoimboe/ [1]
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h     |  4 ++--
 kernel/fork.c                 |  2 +-
 kernel/livepatch/patch.c      |  8 +++++++-
 kernel/livepatch/transition.c | 35 ++++++++++++++---------------------
 kernel/livepatch/transition.h |  1 +
 5 files changed, 25 insertions(+), 25 deletions(-)

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
index 90408500e5a3..3da98877c785 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -95,7 +95,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 		patch_state = current->patch_state;
 
-		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
+		/* If the patch_state is KLP_TRANSITION_IDLE, it means the task
+		 * was forked after klp_init_transition(). In this case, the
+		 * newly forked task can determine which function to use based
+		 * on the klp_target_state.
+		 */
+		if (patch_state == KLP_TRANSITION_IDLE)
+			patch_state = klp_target_state;
 
 		if (patch_state == KLP_TRANSITION_UNPATCHED) {
 			/*
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..af76defca67a 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
 
 struct klp_patch *klp_transition_patch;
 
-static int klp_target_state = KLP_TRANSITION_IDLE;
+int klp_target_state = KLP_TRANSITION_IDLE;
 
 static unsigned int klp_signals_cnt;
 
@@ -294,6 +294,14 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
 {
 	int ret;
 
+	/*
+	 * If the patch_state remains KLP_TRANSITION_IDLE at this point, it
+	 * indicates that the task was forked after klp_init_transition().
+	 * In this case, it is safe to skip the task.
+	 */
+	if (!test_tsk_thread_flag(task, TIF_PATCH_PENDING))
+		return 0;
+
 	if (task_curr(task) && task != current)
 		return -EBUSY;
 
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


