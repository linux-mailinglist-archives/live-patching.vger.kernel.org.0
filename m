Return-Path: <live-patching+bounces-1311-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7476BA6ABCE
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 18:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F165F485C9F
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 17:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420FB224AF7;
	Thu, 20 Mar 2025 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdMz1U1s"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197182248BE;
	Thu, 20 Mar 2025 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742490976; cv=none; b=AHi29ookEvqvr8QxOb4/UkYEFhQ3aO9XQnDF0wMPkS6OJDTmacAh6HONDMqRjWsr4cy8KqAbgtwHSQvZYShKbbEokIIOrZg4mJ+ZN+SQamp+RTgyOsVeqKMrMCm+7gm1j1TfGtuCd0jBicdebbpFe0b3pBwVl1V2D8tv/LdSu8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742490976; c=relaxed/simple;
	bh=93BptoOqRVNyFCiKnHpDZo5E7NyEmw7OFNQMaCFMsOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmj0eSaEqDTzOdZV2ng/tQMlrqF7a6N+uXycHxUwHizLYDuCanj3IZWsNK3c/di1v4J+YPWDggV18dhFjXwV89xd9980D0hOtgpRFhfEG1DTdfLyqIwzVtcxrLAsHuNgK3pgs5OOV1mkf0uvwR6yI2jqwM0X6BtIDCLvvHlEEb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdMz1U1s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55640C4CEDD;
	Thu, 20 Mar 2025 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742490975;
	bh=93BptoOqRVNyFCiKnHpDZo5E7NyEmw7OFNQMaCFMsOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdMz1U1svm/4L8hrxLq7fu0fIWjgK7YNV0P0hmjtoZdidcxGlN+c8CWY9XwBIFLxW
	 TubZI2sZROkpdT20h2nbq3zhTE8Fv9j5LsaD5JGbjpPsmZTb/G6eG8BestSS6MqDXN
	 I1O9IcFpuZJC+3dz5aJaSL+FeJyCDiLFz+x49k/q6bKGapPjgOScxWi9Co5AVUVX4C
	 KgG5k2bOVtz7cW5xH8GNN9pcxCx6u4Y3BrdvGhLISjcffthPg3pCbgjo7/q6k82HVW
	 R9Vp8yIJ1r4uu5jsA0OG3h52QeioNlWgVWJXf20DHdxg/FtPkXKJDX5WjyalA1fCY5
	 0gHs6Lsz/5RMg==
From: Song Liu <song@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: indu.bhagat@oracle.com,
	puranjay@kernel.org,
	wnliu@google.com,
	irogers@google.com,
	joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	mark.rutland@arm.com,
	peterz@infradead.org,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	will@kernel.org,
	kernel-team@meta.com,
	song@kernel.org
Subject: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
Date: Thu, 20 Mar 2025 10:15:58 -0700
Message-ID: <20250320171559.3423224-2-song@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250320171559.3423224-1-song@kernel.org>
References: <20250320171559.3423224-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With proper exception boundary detection, it is possible to implment
arch_stack_walk_reliable without sframe.

Note that, arch_stack_walk_reliable does not guarantee getting reliable
stack in all scenarios. Instead, it can reliably detect when the stack
trace is not reliable, which is enough to provide reliable livepatching.

Signed-off-by: Song Liu <song@kernel.org>
---
 arch/arm64/Kconfig             |  2 +-
 arch/arm64/kernel/stacktrace.c | 66 +++++++++++++++++++++++++---------
 2 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 701d980ea921..31d5e1ee6089 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -276,6 +276,7 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2500,4 +2501,3 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
-
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..7e07911d8694 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -56,6 +56,7 @@ struct kunwind_state {
 	enum kunwind_source source;
 	union unwind_flags flags;
 	struct pt_regs *regs;
+	bool end_on_unreliable;
 };
 
 static __always_inline void
@@ -230,8 +231,26 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	new_fp = READ_ONCE(record->fp);
 	new_pc = READ_ONCE(record->lr);
 
-	if (!new_fp && !new_pc)
-		return kunwind_next_frame_record_meta(state);
+	if (!new_fp && !new_pc) {
+		int ret;
+
+		ret = kunwind_next_frame_record_meta(state);
+		if (ret < 0) {
+			/*
+			 * This covers two different conditions:
+			 *  1. ret == -ENOENT, unwinding is done.
+			 *  2. ret == -EINVAL, unwinding hit error.
+			 */
+			return ret;
+		}
+		/*
+		 * Searching across exception boundaries. The stack is now
+		 * unreliable.
+		 */
+		if (state->end_on_unreliable)
+			return -EINVAL;
+		return 0;
+	}
 
 	unwind_consume_stack(&state->common, info, fp, sizeof(*record));
 
@@ -277,21 +296,24 @@ kunwind_next(struct kunwind_state *state)
 
 typedef bool (*kunwind_consume_fn)(const struct kunwind_state *state, void *cookie);
 
-static __always_inline void
+static __always_inline int
 do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 	   void *cookie)
 {
-	if (kunwind_recover_return_address(state))
-		return;
+	int ret;
 
-	while (1) {
-		int ret;
+	ret = kunwind_recover_return_address(state);
+	if (ret)
+		return ret;
 
+	while (1) {
 		if (!consume_state(state, cookie))
-			break;
+			return -EINVAL;
 		ret = kunwind_next(state);
+		if (ret == -ENOENT)
+			return 0;
 		if (ret < 0)
-			break;
+			return ret;
 	}
 }
 
@@ -324,10 +346,10 @@ do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 			: stackinfo_get_unknown();		\
 	})
 
-static __always_inline void
+static __always_inline int
 kunwind_stack_walk(kunwind_consume_fn consume_state,
 		   void *cookie, struct task_struct *task,
-		   struct pt_regs *regs)
+		   struct pt_regs *regs, bool end_on_unreliable)
 {
 	struct stack_info stacks[] = {
 		stackinfo_get_task(task),
@@ -348,11 +370,12 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 			.stacks = stacks,
 			.nr_stacks = ARRAY_SIZE(stacks),
 		},
+		.end_on_unreliable = end_on_unreliable,
 	};
 
 	if (regs) {
 		if (task != current)
-			return;
+			return -EINVAL;
 		kunwind_init_from_regs(&state, regs);
 	} else if (task == current) {
 		kunwind_init_from_caller(&state);
@@ -360,7 +383,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		kunwind_init_from_task(&state, task);
 	}
 
-	do_kunwind(&state, consume_state, cookie);
+	return do_kunwind(&state, consume_state, cookie);
 }
 
 struct kunwind_consume_entry_data {
@@ -384,7 +407,18 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 		.cookie = cookie,
 	};
 
-	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
+	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs, false);
+}
+
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			void *cookie, struct task_struct *task)
+{
+	struct kunwind_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+	};
+
+	return kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, NULL, true);
 }
 
 struct bpf_unwind_consume_entry_data {
@@ -409,7 +443,7 @@ noinline noinstr void arch_bpf_stack_walk(bool (*consume_entry)(void *cookie, u6
 		.cookie = cookie,
 	};
 
-	kunwind_stack_walk(arch_bpf_unwind_consume_entry, &data, current, NULL);
+	kunwind_stack_walk(arch_bpf_unwind_consume_entry, &data, current, NULL, false);
 }
 
 static const char *state_source_string(const struct kunwind_state *state)
@@ -456,7 +490,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 		return;
 
 	printk("%sCall trace:\n", loglvl);
-	kunwind_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs);
+	kunwind_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs, false);
 
 	put_task_stack(tsk);
 }
-- 
2.47.1


