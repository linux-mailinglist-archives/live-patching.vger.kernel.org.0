Return-Path: <live-patching+bounces-1306-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B882A69B04
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 22:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48A177AAB79
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 21:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6383E219319;
	Wed, 19 Mar 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mStctrl4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DA4214A71;
	Wed, 19 Mar 2025 21:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742420303; cv=none; b=tTjNCyVy9J+ZKsaie8QeaM9m6vvbaF3vdsDhffxuyLVTOUoObxK6TgmQsIu/PcWU7usmF58jWq8agL1k8yYR9Gw46cc+6/AvWK31DjfL9f/5yV3UqGL07hhoBrZrf8xYyuQr5MsAVZ52tUZaOJEoou1ZLqO17fXYLCMlH80xzXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742420303; c=relaxed/simple;
	bh=b3782zZ5mBpEsCfIXFJrh0cYSGOEO7W0tZltv4hR2Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGCXKKpLVVqh7Dapjb0yaOp4dMnLNZx3VvBE216HC9t68kQEIPM9LuGBkQ+zKmRdnQPDJi/08twuboHoP3wNvSAOvZjOP+rYoFQXTzM4/WHXFLS/sVaJ3zVhELlcVE8SxAwdFGgZjJGth6avaXPRRK3/3Q1YruNJhwiQxWx4vwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mStctrl4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916A1C4CEE4;
	Wed, 19 Mar 2025 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742420302;
	bh=b3782zZ5mBpEsCfIXFJrh0cYSGOEO7W0tZltv4hR2Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mStctrl4lCekO+dl4eagJSdNZV+kqYM0f2br1RCNNeQ6eL6KdLcOcmjN69tpdcaH7
	 MMDyUZp247ok/3MkHxdlyi3gRqsSHYYbN0iTB8PFQTJbtePINQI8e/HkDu3nrbrD/G
	 cgZMw1pgCRnKR/sy+OFlG5tPHOFD2RnjFEr+Cg/KPI/DckAO3Ek6jV/YlGBnztW3hF
	 CgAj+oxGXMU763ZurWS7xPS5Ht+pQ+43068p8Jmpvhw+UnI0wrVaZz1nlGY28nr1G7
	 2U2cJusDE+dkBWVSvQ31gqSI5omBkJ0cDsqNqrKzKhRwNJuCOtmHkAtyzNxLVUIzwB
	 zFJvFb2aFzQBw==
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
Subject: [PATCH v2 1/2] arm64: Implement arch_stack_walk_reliable
Date: Wed, 19 Mar 2025 14:37:06 -0700
Message-ID: <20250319213707.1784775-2-song@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250319213707.1784775-1-song@kernel.org>
References: <20250319213707.1784775-1-song@kernel.org>
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
 arch/arm64/kernel/stacktrace.c | 70 ++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 940343beb3d4..ed4f7bf4a879 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -275,6 +275,7 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2499,4 +2500,3 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
-
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..b0489aad5897 100644
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
@@ -384,7 +407,22 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
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
+	int ret;
+
+	ret = kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, NULL, true);
+	if (ret == -ENOENT)
+		ret = 0;
+	return ret;
 }
 
 struct bpf_unwind_consume_entry_data {
@@ -409,7 +447,7 @@ noinline noinstr void arch_bpf_stack_walk(bool (*consume_entry)(void *cookie, u6
 		.cookie = cookie,
 	};
 
-	kunwind_stack_walk(arch_bpf_unwind_consume_entry, &data, current, NULL);
+	kunwind_stack_walk(arch_bpf_unwind_consume_entry, &data, current, NULL, false);
 }
 
 static const char *state_source_string(const struct kunwind_state *state)
@@ -456,7 +494,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 		return;
 
 	printk("%sCall trace:\n", loglvl);
-	kunwind_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs);
+	kunwind_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs, false);
 
 	put_task_stack(tsk);
 }
-- 
2.47.1


