Return-Path: <live-patching+bounces-2306-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LnpB/AA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2306-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:52:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC973A6667
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11FB63057C4B
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8A43976AB;
	Mon,  6 Apr 2026 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AcreckdU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA0397694
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501437; cv=none; b=HgPP7ZL3i6OCLyaUZCJa8hec0BXRk7t36rPelPzZo1o+uUF4MEhdQeCfMGtHnwSJuCtboXgc25lUi+UQI+H8cNzq4B0awwTV2Zxxlcmrs5TvZAvkjKslrE+wpw68eImw0CosqldZKnjV2LOF1Osv1MOr9vCD+81joM4nSqIoSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501437; c=relaxed/simple;
	bh=Ki65MefgNzHq6ISx6NAc0yPLIHUzqBtO6jD9b5LCdMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GWur/AuifBwRVaTsFJ2NcRvJR6S1T6EtRSZXG31PCoBUQtrJ4Ks9BeyF6nvGH9GwC23lAxZVTGFX4YDoX5KJd0XJNjN+uKGd3y4wDvXiznUb1q6YWiZ9YeW8mKX6NBUNcQ+cENfX9+mJM5VcwmJ1p1FZilH6njwU0BGQLWjshTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AcreckdU; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c8768a704so2337829b3a.3
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501436; x=1776106236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NUfWhY67lIhptCLOMSh+gb51pACdbxlvycMF2len7NM=;
        b=AcreckdUXxhg1MnM2ISQovCWlLMPlJOpnX9rIt3AADzUQN47jZPMH+IH3rItLBMy9/
         enuKUhBDsNSCZmNYWKkN7a7EqAoIJrIOhBnMxXsfo+cri23bpLurEMXlhPm4XKuN029v
         iwTUQxnePOEj3xrk+5FTW2fQ5kytS27HzpPlZxMonlYDTEsAbq3E57kLCek8R3213nok
         yJzG9SnXPuJgzGWL9LaAgRqz56VKWWzHoa9KJIRtDZAfuWX5u0hRP382RXZ6Hk5PoxeX
         Xn8lFyED3hzuinuwHTwFoMpjt1t4m98cmhrTknAOhNBBauLKka06EVe6z/rDv0UGG7fb
         pxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501436; x=1776106236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUfWhY67lIhptCLOMSh+gb51pACdbxlvycMF2len7NM=;
        b=XYEGzsPUBDfStyWqDPBuzHWF1tiSPx5GWkSc9f9qIBOOsXKDQEbWWkChio+LnJ0seb
         jU4wim6sGjPKS5ap5zsx6YHdgzjbrCnmuZOpw6LZx6o1I6n1BhEOTRgfq8AT68PBqhDx
         X876Mt+JooVMzCFx9ag+xYhpeqeE+vhUzsm6hqTWTHBmwv0G9z3AVQwh6AGTpdCHvqTN
         OLF5+Uk5JHzwS96SdgMg0JFhd8K0s5LDyqhUU61i6pZgDraXzSm0L6srFo4rldHzN5sn
         PZ9Tgww60Kzh8QYKyY6TxnxQpeOC6EJI3xVX0yZWVeOddbjvL9DxIvNbagRI9/eGYuoG
         TZAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMdy4rP9zslahZwZddn0+YFT9XyBS3wYPI4XI+v1RpLEEDH5PYjircCBNYpW/AV8gA/ZhO64FS35mCUrxu@vger.kernel.org
X-Gm-Message-State: AOJu0YynuGcqaaPL4c5wuRVg61iEg62Yilg2WGnFp+Tlnn4wI/U9vMd3
	gF8Yo3BAkwJaQb75pzklHEFYWyLpoZUI5sR0PYyE1ktQtvpGGdqkqEiDsHzesWJO4enQJhaf6fP
	6T7eLzd6mUMnOO/JIeh7yKScE5g==
X-Received: from pfx21.prod.google.com ([2002:a05:6a00:a455:b0:829:7f86:634])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1805:b0:82a:1380:417d with SMTP id d2e1a72fcca58-82d0dbcfad1mr13503330b3a.52.1775501435455;
 Mon, 06 Apr 2026 11:50:35 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:50:00 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-9-dylanbhatch@google.com>
Subject: [PATCH v3 8/8] unwind: arm64: Use sframe to unwind interrupt frames.
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2306-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BCC973A6667
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add unwind_next_frame_sframe() function to unwind by sframe info if
present. Use this method at exception boundaries, falling back to
frame-pointer unwind only on failure. In such failure cases, the
stacktrace is considered unreliable.

During normal unwind, prefer frame pointer unwind (for better
performance) with sframe as a backup.

This change restores the LR behavior originally introduced in commit
c2c6b27b5aa14fa2 ("arm64: stacktrace: unwind exception boundaries"),
But later removed in commit 32ed1205682e ("arm64: stacktrace: Skip
reporting LR at exception boundaries")

This can be done because the sframe data can be used to determine
whether the LR is current for the PC value recovered from pt_regs at the
exception boundary.

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace/common.h |   6 +
 arch/arm64/kernel/stacktrace.c             | 242 +++++++++++++++++++--
 2 files changed, 228 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 821a8fdd31af..96c4c0a7e6de 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -21,6 +21,8 @@ struct stack_info {
  *
  * @fp:          The fp value in the frame record (or the real fp)
  * @pc:          The lr value in the frame record (or the real lr)
+ * @sp:          The sp value at the call site of the current function.
+ * @unreliable:  Stacktrace is unreliable.
  *
  * @stack:       The stack currently being unwound.
  * @stacks:      An array of stacks which can be unwound.
@@ -29,7 +31,11 @@ struct stack_info {
 struct unwind_state {
 	unsigned long fp;
 	unsigned long pc;
+#ifdef CONFIG_SFRAME_UNWINDER
+	unsigned long sp;
+#endif
 
+	bool unreliable;
 	struct stack_info stack;
 	struct stack_info *stacks;
 	int nr_stacks;
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3ebcf8c53fb0..16a4eb31c5c1 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -14,6 +14,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
+#include <linux/sframe.h>
 
 #include <asm/efi.h>
 #include <asm/irq.h>
@@ -26,6 +27,7 @@ enum kunwind_source {
 	KUNWIND_SOURCE_CALLER,
 	KUNWIND_SOURCE_TASK,
 	KUNWIND_SOURCE_REGS_PC,
+	KUNWIND_SOURCE_REGS_LR,
 };
 
 union unwind_flags {
@@ -85,6 +87,9 @@ kunwind_init_from_regs(struct kunwind_state *state,
 	state->regs = regs;
 	state->common.fp = regs->regs[29];
 	state->common.pc = regs->pc;
+#ifdef CONFIG_SFRAME_UNWINDER
+	state->common.sp = regs->sp;
+#endif
 	state->source = KUNWIND_SOURCE_REGS_PC;
 }
 
@@ -103,6 +108,9 @@ kunwind_init_from_caller(struct kunwind_state *state)
 
 	state->common.fp = (unsigned long)__builtin_frame_address(1);
 	state->common.pc = (unsigned long)__builtin_return_address(0);
+#ifdef CONFIG_SFRAME_UNWINDER
+	state->common.sp = (unsigned long)__builtin_frame_address(0);
+#endif
 	state->source = KUNWIND_SOURCE_CALLER;
 }
 
@@ -124,6 +132,9 @@ kunwind_init_from_task(struct kunwind_state *state,
 
 	state->common.fp = thread_saved_fp(task);
 	state->common.pc = thread_saved_pc(task);
+#ifdef CONFIG_SFRAME_UNWINDER
+	state->common.sp = thread_saved_sp(task);
+#endif
 	state->source = KUNWIND_SOURCE_TASK;
 }
 
@@ -181,7 +192,6 @@ int kunwind_next_regs_pc(struct kunwind_state *state)
 	state->regs = regs;
 	state->common.pc = regs->pc;
 	state->common.fp = regs->regs[29];
-	state->regs = NULL;
 	state->source = KUNWIND_SOURCE_REGS_PC;
 	return 0;
 }
@@ -237,6 +247,9 @@ kunwind_next_frame_record(struct kunwind_state *state)
 
 	unwind_consume_stack(&state->common, info, fp, sizeof(*record));
 
+#ifdef CONFIG_SFRAME_UNWINDER
+	state->common.sp = state->common.fp;
+#endif
 	state->common.fp = new_fp;
 	state->common.pc = new_pc;
 	state->source = KUNWIND_SOURCE_FRAME;
@@ -244,6 +257,172 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	return 0;
 }
 
+#ifdef CONFIG_SFRAME_UNWINDER
+
+static __always_inline struct stack_info *
+get_word(struct unwind_state *state, unsigned long *word)
+{
+	unsigned long addr = *word;
+	struct stack_info *info;
+
+	info = unwind_find_stack(state, addr, sizeof(addr));
+	if (!info)
+		return info;
+
+	*word = READ_ONCE(*(unsigned long *)addr);
+
+	return info;
+}
+
+static __always_inline int
+get_consume_word(struct unwind_state *state, unsigned long *word)
+{
+	struct stack_info *info;
+	unsigned long addr = *word;
+
+	info = get_word(state, word);
+	if (!info)
+		return -EINVAL;
+
+	unwind_consume_stack(state, info, addr, sizeof(addr));
+	return 0;
+}
+
+/*
+ * Unwind to the next frame according to sframe.
+ */
+static __always_inline int
+unwind_next_frame_sframe(struct kunwind_state *state)
+{
+	struct unwind_frame frame;
+	unsigned long cfa, fp, ra;
+	enum kunwind_source source = KUNWIND_SOURCE_FRAME;
+	struct pt_regs *regs = state->regs;
+
+	int err;
+
+	/* FP/SP alignment 8 bytes */
+	if (state->common.fp & 0x7 || state->common.sp & 0x7)
+		return -EINVAL;
+
+	/*
+	 * Most/all outermost functions are not visible to sframe. So, check for
+	 * a meta frame record if the sframe lookup fails.
+	 */
+	err = sframe_find_kernel(state->common.pc, &frame);
+	if (err)
+		return kunwind_next_frame_record_meta(state);
+
+	if (frame.outermost)
+		return -ENOENT;
+
+	/* Get the Canonical Frame Address (CFA) */
+	switch (frame.cfa.rule) {
+	case UNWIND_CFA_RULE_SP_OFFSET:
+		cfa = state->common.sp;
+		break;
+	case UNWIND_CFA_RULE_FP_OFFSET:
+		if (state->common.fp < state->common.sp)
+			return -EINVAL;
+		cfa = state->common.fp;
+		break;
+	case UNWIND_CFA_RULE_REG_OFFSET:
+	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
+		if (!regs)
+			return -EINVAL;
+		cfa = regs->regs[frame.cfa.regnum];
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	cfa += frame.cfa.offset;
+
+	/*
+	 * CFA typically points to a higher address than RA or FP, so don't
+	 * consume from the stack when we read it.
+	 */
+	if (frame.cfa.rule & UNWIND_RULE_DEREF &&
+	    !get_word(&state->common, &cfa))
+		return -EINVAL;
+
+	/* CFA alignment 8 bytes */
+	if (cfa & 0x7)
+		return -EINVAL;
+
+	/* Get the Return Address (RA) */
+	switch (frame.ra.rule) {
+	case UNWIND_RULE_RETAIN:
+		if (!regs)
+			return -EINVAL;
+		ra = regs->regs[30];
+		source = KUNWIND_SOURCE_REGS_LR;
+		break;
+	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
+		ra = cfa + frame.ra.offset;
+		break;
+	case UNWIND_RULE_REG_OFFSET:
+	case UNWIND_RULE_REG_OFFSET_DEREF:
+		if (!regs)
+			return -EINVAL;
+		ra = regs->regs[frame.cfa.regnum];
+		ra += frame.ra.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/* Get the Frame Pointer (FP) */
+	switch (frame.fp.rule) {
+	case UNWIND_RULE_RETAIN:
+		fp = state->common.fp;
+		break;
+	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
+		fp = cfa + frame.fp.offset;
+		break;
+	case UNWIND_RULE_REG_OFFSET:
+	case UNWIND_RULE_REG_OFFSET_DEREF:
+		if (!regs)
+			return -EINVAL;
+		fp = regs->regs[frame.fp.regnum];
+		fp += frame.fp.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/*
+	 * Consume RA and FP from the stack. The frame record puts FP at a lower
+	 * address than RA, so we always read FP first.
+	 */
+	if (frame.fp.rule & UNWIND_RULE_DEREF &&
+	    !get_word(&state->common, &fp))
+		return -EINVAL;
+
+	if (frame.ra.rule & UNWIND_RULE_DEREF &&
+	    get_consume_word(&state->common, &ra))
+		return -EINVAL;
+
+	state->common.pc = ra;
+	state->common.sp = cfa;
+	state->common.fp = fp;
+
+	state->source = source;
+
+	return 0;
+}
+
+#else
+
+static __always_inline int
+unwind_next_frame_sframe(struct kunwind_state *state) { return -EINVAL; }
+
+#endif
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -259,12 +438,25 @@ kunwind_next(struct kunwind_state *state)
 	state->flags.all = 0;
 
 	switch (state->source) {
+	case KUNWIND_SOURCE_REGS_PC:
+		err = unwind_next_frame_sframe(state);
+
+		if (err && err != -ENOENT) {
+			/* Fallback to FP based unwinder */
+			err = kunwind_next_frame_record(state);
+			state->common.unreliable = true;
+		}
+		state->regs = NULL;
+		break;
 	case KUNWIND_SOURCE_FRAME:
 	case KUNWIND_SOURCE_CALLER:
 	case KUNWIND_SOURCE_TASK:
-	case KUNWIND_SOURCE_REGS_PC:
+	case KUNWIND_SOURCE_REGS_LR:
 		err = kunwind_next_frame_record(state);
+		if (err && err != -ENOENT)
+			err = unwind_next_frame_sframe(state);
 		break;
+
 	default:
 		err = -EINVAL;
 	}
@@ -350,6 +542,9 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		.common = {
 			.stacks = stacks,
 			.nr_stacks = ARRAY_SIZE(stacks),
+#ifdef CONFIG_SFRAME_UNWINDER
+			.sp = 0,
+#endif
 		},
 	};
 
@@ -390,34 +585,40 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
 }
 
+struct kunwind_reliable_consume_entry_data {
+	stack_trace_consume_fn consume_entry;
+	void *cookie;
+	bool unreliable;
+};
+
 static __always_inline bool
-arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
+arch_kunwind_reliable_consume_entry(const struct kunwind_state *state, void *cookie)
 {
-	/*
-	 * At an exception boundary we can reliably consume the saved PC. We do
-	 * not know whether the LR was live when the exception was taken, and
-	 * so we cannot perform the next unwind step reliably.
-	 *
-	 * All that matters is whether the *entire* unwind is reliable, so give
-	 * up as soon as we hit an exception boundary.
-	 */
-	if (state->source == KUNWIND_SOURCE_REGS_PC)
-		return false;
+	struct kunwind_reliable_consume_entry_data *data = cookie;
 
-	return arch_kunwind_consume_entry(state, cookie);
+	if (state->common.unreliable) {
+		data->unreliable = true;
+		return false;
+	}
+	return data->consume_entry(data->cookie, state->common.pc);
 }
 
-noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
-					      void *cookie,
-					      struct task_struct *task)
+noinline notrace int arch_stack_walk_reliable(
+				stack_trace_consume_fn consume_entry,
+				void *cookie, struct task_struct *task)
 {
-	struct kunwind_consume_entry_data data = {
+	struct kunwind_reliable_consume_entry_data data = {
 		.consume_entry = consume_entry,
 		.cookie = cookie,
+		.unreliable = false,
 	};
 
-	return kunwind_stack_walk(arch_reliable_kunwind_consume_entry, &data,
-				  task, NULL);
+	kunwind_stack_walk(arch_kunwind_reliable_consume_entry, &data, task, NULL);
+
+	if (data.unreliable)
+		return -EINVAL;
+
+	return 0;
 }
 
 struct bpf_unwind_consume_entry_data {
@@ -452,6 +653,7 @@ static const char *state_source_string(const struct kunwind_state *state)
 	case KUNWIND_SOURCE_CALLER:	return "C";
 	case KUNWIND_SOURCE_TASK:	return "T";
 	case KUNWIND_SOURCE_REGS_PC:	return "P";
+	case KUNWIND_SOURCE_REGS_LR:	return "L";
 	default:			return "U";
 	}
 }
-- 
2.53.0.1213.gd9a14994de-goog


