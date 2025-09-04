Return-Path: <live-patching+bounces-1630-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25702B449D6
	for <lists+live-patching@lfdr.de>; Fri,  5 Sep 2025 00:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F378D7A9AC7
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 22:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9CB2EC56F;
	Thu,  4 Sep 2025 22:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJBhliaz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5532E8B87
	for <live-patching@vger.kernel.org>; Thu,  4 Sep 2025 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757025578; cv=none; b=cRQ8mYK5x/XFyji9Sm1WSAIMCi9QmsCG2SIaXT3XHqrWF/Z1cAGvbsrNu7wCNkoq+jDgiPjsANoRB+PdSsXssUG85v1ciZZUlD/Cg65wonv3hvmO+WudTEpdkLFN3tt3ZkJuJ9AakdV/M2iWCHcxoVHkk729Vz6wLRnkzaRM5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757025578; c=relaxed/simple;
	bh=dlLs+yi7RwXEFoGkLBmy8K3WE1BY0qc9j744kGghnWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DzStm4ZgUsX2ixniL2vnJ4X3k9MgnnQW3ZeYJPCpJhJcoGzeyiC0bGs2yJES6PWtrK33iTE7mc6MZTCxVdf+dg/VTc9JjTTZ81GrSmCWtlqrC7BZsHSkeFqyhF+9+Gjz66XbMoXgp2Funs4Vlj5R/0t644bYrZ3RhxHbPndyzxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJBhliaz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24caf28cce0so31662405ad.0
        for <live-patching@vger.kernel.org>; Thu, 04 Sep 2025 15:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757025576; x=1757630376; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0NQT71Rd3hFVreB2uwDzx4dZZ1nQuKfGGKuQOi/O3l8=;
        b=iJBhliaznHDR/NuiId7sWKJ6WkgbRZAgCRhMivhm6r2jkRWugg3+RAGUbQPA5+xmRh
         kkVlkOmsItRApf6el4SMs41avh27Y8MncbON+Xa8J+bfCaEh1ynL5bmlRfnI8MC1ul9s
         1OeKFKkWS7Dl9uuxrIb6nWcu3Nat1kiGq5wh1mnK4o5VN1lmdSzwZJlHM1XIll2ul9mT
         b6HMFZGWNWlanqZQDq6qUiSHqRcXHW83IIuAq/xCVfNS48LzcdfaRdCJ20/Df+Op+Ko0
         nfd2it4LMynCExS1ajhkE2b7CkCNeRSWqnIojzUg0q8/IifnlakM6mZYzZWyO9p9fGE7
         aPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757025576; x=1757630376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0NQT71Rd3hFVreB2uwDzx4dZZ1nQuKfGGKuQOi/O3l8=;
        b=EgIDHwNrXJCspAAv543dR49NKrucWW2HREmySlEiYB7WpyG48dtZnkeEMEEz0PMY5A
         7v62ZxapifEwoD5/N1RVTOK6o5qyK/biyIvJdbRwfvjhc+eStpniVGEcikjISUNzTrB1
         WMKSYC3+DNK7+qbs4/P9Lax2JvZLEQ3ZXQ+DNggIjBdIKe0/EgNPnnGZrv95qROqU5p7
         2BNtJFylwCnEt1oE0iRzszXHxcikAW/iUG8ZW/DtoKmXM+bFtyjDHdw9uLcn1tfNXb44
         NnHSM/jVK/Kx++uzSHvtMl0e1x8PhoDwJiBgt6ZhARK1heH9Ssp2jWQePgixr8RMmV8w
         tNOA==
X-Forwarded-Encrypted: i=1; AJvYcCU0saD5GPApS9oEGTZhRY5QWOKDILv1DS4LMng1HGP4VeviHEW+cXkm3HxlQDgxplKqbSJvPwziWUGFzi3W@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1q0Agctq7yd9Sw+yjfvXeR7Ij+5vHmudDoUPT67+rMocW31RT
	I6vO/hM+Bf1+8lE3hef3gBaWLZPsS9m0ivELqBDihLAn3VPPxINh0yvRvgqzex28G+zRoHvJOIb
	RCZZCiHPVoSgDEP04w4svomR8Fg==
X-Google-Smtp-Source: AGHT+IGU9/lQfrcWOX/dpTT9E6qyc3rvM+V4d9jDHZ4cKgBH8shTzfPR7bsY0ynubJ92rvKh6T2ZEGmb0PlBrTok+w==
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:327:b430:11ad])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5cf:b0:242:8a45:a959 with SMTP id d9443c01a7336-24944ae5ff7mr273875345ad.47.1757025576197;
 Thu, 04 Sep 2025 15:39:36 -0700 (PDT)
Date: Thu,  4 Sep 2025 22:38:50 +0000
In-Reply-To: <20250904223850.884188-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250904223850.884188-7-dylanbhatch@google.com>
Subject: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with sframe unwinder.
From: Dylan Hatch <dylanbhatch@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

From: Weinan Liu <wnliu@google.com>

Add unwind_next_frame_sframe() function to unwind by sframe info.
Built with GNU Binutils 2.42 to verify that this sframe unwinder can
backtrace correctly on arm64.

To support livepatch, we need to add arch_stack_walk_reliable to
support reliable stacktrace according to
https://docs.kernel.org/livepatch/reliable-stacktrace.html#requirements

report stacktrace is not reliable if we are not able to unwind the stack
by sframe unwinder and fallback to FP based unwinder

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace/common.h |   6 ++
 arch/arm64/kernel/setup.c                  |   2 +
 arch/arm64/kernel/stacktrace.c             | 102 +++++++++++++++++++++
 3 files changed, 110 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 821a8fdd31af..26449cd402db 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -25,6 +25,8 @@ struct stack_info {
  * @stack:       The stack currently being unwound.
  * @stacks:      An array of stacks which can be unwound.
  * @nr_stacks:   The number of stacks in @stacks.
+ * @cfa:         The sp value at the call site of the current function.
+ * @unreliable:  Stacktrace is unreliable.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -33,6 +35,10 @@ struct unwind_state {
 	struct stack_info stack;
 	struct stack_info *stacks;
 	int nr_stacks;
+#ifdef CONFIG_SFRAME_UNWINDER
+	unsigned long cfa;
+	bool unreliable;
+#endif
 };
 
 static inline struct stack_info stackinfo_get_unknown(void)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 77c7926a4df6..ac1da45da532 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -32,6 +32,7 @@
 #include <linux/sched/task.h>
 #include <linux/scs.h>
 #include <linux/mm.h>
+#include <linux/sframe_lookup.h>
 
 #include <asm/acpi.h>
 #include <asm/fixmap.h>
@@ -375,6 +376,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 			"This indicates a broken bootloader or old kernel\n",
 			boot_args[1], boot_args[2], boot_args[3]);
 	}
+	init_sframe_table();
 }
 
 static inline bool cpu_can_disable(unsigned int cpu)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3ebcf8c53fb0..72e78024d05e 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -14,6 +14,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
+#include <linux/sframe_lookup.h>
 
 #include <asm/efi.h>
 #include <asm/irq.h>
@@ -244,6 +245,53 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	return 0;
 }
 
+#ifdef CONFIG_SFRAME_UNWINDER
+/*
+ * Unwind to the next frame according to sframe.
+ */
+static __always_inline int
+unwind_next_frame_sframe(struct unwind_state *state)
+{
+	unsigned long fp = state->fp, ip = state->pc;
+	unsigned long base_reg, cfa;
+	unsigned long pc_addr, fp_addr;
+	struct sframe_ip_entry entry;
+	struct stack_info *info;
+	struct frame_record *record = (struct frame_record *)fp;
+
+	int err;
+
+	/* frame record alignment 8 bytes */
+	if (fp & 0x7)
+		return -EINVAL;
+
+	info = unwind_find_stack(state, fp, sizeof(*record));
+	if (!info)
+		return -EINVAL;
+
+	err = sframe_find_pc(ip, &entry);
+	if (err)
+		return -EINVAL;
+
+	unwind_consume_stack(state, info, fp, sizeof(*record));
+
+	base_reg = entry.use_fp ? fp : state->cfa;
+
+	/* Set up the initial CFA using fp based info if CFA is not set */
+	if (!state->cfa)
+		cfa = fp - entry.fp_offset;
+	else
+		cfa = base_reg + entry.cfa_offset;
+	fp_addr = cfa + entry.fp_offset;
+	pc_addr = cfa + entry.ra_offset;
+	state->cfa = cfa;
+	state->fp = READ_ONCE(*(unsigned long *)(fp_addr));
+	state->pc = READ_ONCE(*(unsigned long *)(pc_addr));
+
+	return 0;
+}
+#endif
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -263,7 +311,20 @@ kunwind_next(struct kunwind_state *state)
 	case KUNWIND_SOURCE_CALLER:
 	case KUNWIND_SOURCE_TASK:
 	case KUNWIND_SOURCE_REGS_PC:
+#ifdef CONFIG_SFRAME_UNWINDER
+	if (!state->common.unreliable)
+		err = unwind_next_frame_sframe(&state->common);
+
+	/* Fallback to FP based unwinder */
+	if (err || state->common.unreliable) {
 		err = kunwind_next_frame_record(state);
+		/* Mark its stacktrace result as unreliable if it is unwindable via FP */
+		if (!err)
+			state->common.unreliable = true;
+	}
+#else
+	err = kunwind_next_frame_record(state);
+#endif
 		break;
 	default:
 		err = -EINVAL;
@@ -350,6 +411,9 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		.common = {
 			.stacks = stacks,
 			.nr_stacks = ARRAY_SIZE(stacks),
+#ifdef CONFIG_SFRAME_UNWINDER
+			.cfa = 0,
+#endif
 		},
 	};
 
@@ -390,6 +454,43 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
 }
 
+#ifdef CONFIG_SFRAME_UNWINDER
+struct kunwind_reliable_consume_entry_data {
+	stack_trace_consume_fn consume_entry;
+	void *cookie;
+	bool unreliable;
+};
+
+static __always_inline bool
+arch_kunwind_reliable_consume_entry(const struct kunwind_state *state, void *cookie)
+{
+	struct kunwind_reliable_consume_entry_data *data = cookie;
+
+	if (state->common.unreliable) {
+		data->unreliable = true;
+		return false;
+	}
+	return data->consume_entry(data->cookie, state->common.pc);
+}
+
+noinline notrace int arch_stack_walk_reliable(
+				stack_trace_consume_fn consume_entry,
+				void *cookie, struct task_struct *task)
+{
+	struct kunwind_reliable_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+		.unreliable = false,
+	};
+
+	kunwind_stack_walk(arch_kunwind_reliable_consume_entry, &data, task, NULL);
+
+	if (data.unreliable)
+		return -EINVAL;
+
+	return 0;
+}
+#else
 static __always_inline bool
 arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
 {
@@ -419,6 +520,7 @@ noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_ent
 	return kunwind_stack_walk(arch_reliable_kunwind_consume_entry, &data,
 				  task, NULL);
 }
+#endif
 
 struct bpf_unwind_consume_entry_data {
 	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
-- 
2.51.0.355.g5224444f11-goog


