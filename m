Return-Path: <live-patching+bounces-2902-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCUxL77lFmruvgcAu9opvQ
	(envelope-from <live-patching+bounces-2902-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:38:22 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3626C5E446E
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 78F9E3063E84
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D543403EA3;
	Wed, 27 May 2026 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HThjKnEF"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76898403E9A;
	Wed, 27 May 2026 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885352; cv=none; b=hcL7sIljb2jUgvdorR+TvjXVd28LkoK5qRiRZGvCwhibm4pKKUC5QrN2TsNV4ze/RoMidNbGXReaq5cTH3eCpIHAVRYTSny43DCuM0ggcNiYLk2QeATIWLfg3bz/XRJ0SpmDr7jUbUnS2GtQ2ZC8A8JULXeRBjRBlxz+Laks2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885352; c=relaxed/simple;
	bh=P9tchkPn7nicuhH05c/nVuXpiXVPC63jUT8L+QwGhhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRw+z5jLiljjIzW5/hWfCogSu5yCjB839XF6LztX6FBZrEPKzLzx3ibCTDLVqNPO0MyEAbdTsX/S23Z+5HjLO6FgTcQ5mnCkebdEMZ4aSUidikDqN7ePd53Aa2y4pYikVlQF20UbFWEIBlD+sDilMmSKwgySPfev979ZJt9PLU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HThjKnEF; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779885344; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PWXhWzyCALmai/5XB1OyTOO1hzuVkcfr5CK2JaR3L3w=;
	b=HThjKnEFgmS2vhDw3rwV7gFfXeMvq3FkBkCI2DnpMqp4ZqwwG/+36V++hLW7GWzu7YIMF3Pf3ireerAnfxB764kAsnaWdMe6RDQvK2nd2MXZrdpeE1NfuM6vPx5gTXhUyU5WsBIQRq45TML68n/pPanpa4gDEJGtFxlEs1bJwVU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3jh1D0_1779885340;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3jh1D0_1779885340 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 20:35:41 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH 5/8] riscv: stacktrace: introduce stack-bound tracking helpers
Date: Wed, 27 May 2026 20:35:27 +0800
Message-ID: <20260527123530.2593918-6-wanghan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2902-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,goodmis.org,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wanghan@linux.alibaba.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,alibaba.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 3626C5E446E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A reliable unwinder needs to validate that every frame record it reads
is fully contained in a known kernel stack, and it needs to refuse to
walk back into a stack it has already left. Add the building blocks
for that:

  * struct stack_info / struct unwind_state in a new
    asm/stacktrace/common.h, modelled on the arm64 reference
    implementation.
  * stackinfo_get_irq() / stackinfo_get_task() / stackinfo_get_overflow()
    plus the corresponding on_*_stack() predicates in asm/stacktrace.h,
    so callers can ask "is this object on stack X?" by stack kind
    rather than open-coded address arithmetic.
  * unwind_init_common(), unwind_find_stack() and
    unwind_consume_stack() helpers that enforce the
    forward-progress-only invariant required for reliability.

No existing user is wired up to these helpers in this commit; the
unwinder switch comes in a follow-up. The header changes leave
on_thread_stack() with the same semantics as before, just expressed in
terms of the new helpers.

Signed-off-by: Wang Han <wanghan@linux.alibaba.com>
---
 arch/riscv/include/asm/stacktrace.h        |  65 ++++++++-
 arch/riscv/include/asm/stacktrace/common.h | 159 +++++++++++++++++++++
 2 files changed, 222 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/stacktrace/common.h

diff --git a/arch/riscv/include/asm/stacktrace.h b/arch/riscv/include/asm/stacktrace.h
index b1495a7e06ce..bc87c4940379 100644
--- a/arch/riscv/include/asm/stacktrace.h
+++ b/arch/riscv/include/asm/stacktrace.h
@@ -3,8 +3,13 @@
 #ifndef _ASM_RISCV_STACKTRACE_H
 #define _ASM_RISCV_STACKTRACE_H
 
+#include <linux/percpu.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+
+#include <asm/irq_stack.h>
 #include <asm/ptrace.h>
+#include <asm/stacktrace/common.h>
 
 struct stackframe {
 	unsigned long fp;
@@ -16,14 +21,70 @@ extern void notrace walk_stackframe(struct task_struct *task, struct pt_regs *re
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
 			   const char *loglvl);
 
-static inline bool on_thread_stack(void)
+/*
+ * IRQ stack accessors
+ */
+static inline struct stack_info stackinfo_get_irq(void)
+{
+	unsigned long low = (unsigned long)raw_cpu_read(irq_stack_ptr);
+	unsigned long high = low + IRQ_STACK_SIZE;
+
+	return (struct stack_info) {
+		.low = low,
+		.high = high,
+	};
+}
+
+static inline bool on_irq_stack(unsigned long sp, unsigned long size)
+{
+	struct stack_info info = stackinfo_get_irq();
+
+	return stackinfo_on_stack(&info, sp, size);
+}
+
+/*
+ * Task stack accessors
+ */
+static inline struct stack_info stackinfo_get_task(const struct task_struct *tsk)
 {
-	return !(((unsigned long)(current->stack) ^ current_stack_pointer) & ~(THREAD_SIZE - 1));
+	unsigned long low = (unsigned long)task_stack_page(tsk);
+	unsigned long high = low + THREAD_SIZE;
+
+	return (struct stack_info) {
+		.low = low,
+		.high = high,
+	};
+}
+
+static inline bool on_task_stack(const struct task_struct *tsk,
+				 unsigned long sp, unsigned long size)
+{
+	struct stack_info info = stackinfo_get_task(tsk);
+
+	return stackinfo_on_stack(&info, sp, size);
 }
 
+/*
+ * Cast is necessary since current->stack is an opaque ptr.
+ */
+#define on_thread_stack()	(on_task_stack(current, current_stack_pointer, 1))
 
+/*
+ * Overflow stack accessors
+ */
 #ifdef CONFIG_VMAP_STACK
 DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+
+static inline struct stack_info stackinfo_get_overflow(void)
+{
+	unsigned long low = (unsigned long)raw_cpu_ptr(overflow_stack);
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return (struct stack_info) {
+		.low = low,
+		.high = high,
+	};
+}
 #endif /* CONFIG_VMAP_STACK */
 
 #endif /* _ASM_RISCV_STACKTRACE_H */
diff --git a/arch/riscv/include/asm/stacktrace/common.h b/arch/riscv/include/asm/stacktrace/common.h
new file mode 100644
index 000000000000..87d6d40672f3
--- /dev/null
+++ b/arch/riscv/include/asm/stacktrace/common.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * RISC-V common stack unwinder types and helpers.
+ *
+ * See: arch/arm64/include/asm/stacktrace/common.h for the reference
+ * implementation.
+ *
+ * Copyright (C) 2024
+ */
+#ifndef __ASM_RISCV_STACKTRACE_COMMON_H
+#define __ASM_RISCV_STACKTRACE_COMMON_H
+
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+
+#include <asm/stacktrace/frame.h>
+
+/**
+ * struct stack_info - describes the bounds of a stack.
+ *
+ * @low:  The lowest valid address on the stack.
+ * @high: The highest valid address on the stack.
+ */
+struct stack_info {
+	unsigned long low;
+	unsigned long high;
+};
+
+/**
+ * struct unwind_state - state used for robust unwinding.
+ *
+ * @fp:        The fp value in the frame record (or the real fp).
+ * @pc:        The ra value in the frame record (or the real ra).
+ *
+ * @stack:     The stack currently being unwound.
+ * @stacks:    An array of stacks which can be unwound.
+ * @nr_stacks: The number of stacks in @stacks.
+ */
+struct unwind_state {
+	unsigned long fp;
+	unsigned long pc;
+
+	struct stack_info stack;
+	struct stack_info *stacks;
+	int nr_stacks;
+};
+
+/**
+ * stackinfo_get_unknown() - Get an unknown stack_info.
+ *
+ * Return: a stack_info with low and high set to 0.
+ */
+static inline struct stack_info stackinfo_get_unknown(void)
+{
+	return (struct stack_info) {
+		.low = 0,
+		.high = 0,
+	};
+}
+
+/**
+ * stackinfo_on_stack() - Check whether an object is fully within a stack.
+ *
+ * @info: The stack to check against.
+ * @sp:   The base address of the object.
+ * @size: The size of the object.
+ *
+ * Return: true if the object is fully contained within the stack.
+ */
+static inline bool stackinfo_on_stack(const struct stack_info *info,
+				      unsigned long sp, unsigned long size)
+{
+	if (!info->low)
+		return false;
+
+	if (sp < info->low || sp + size < sp || sp + size > info->high)
+		return false;
+
+	return true;
+}
+
+/**
+ * unwind_init_common() - Initialize the common parts of the unwind state.
+ *
+ * @state: the unwind state to initialize.
+ */
+static inline void unwind_init_common(struct unwind_state *state)
+{
+	state->stack = stackinfo_get_unknown();
+}
+
+/**
+ * unwind_find_stack() - Find the accessible stack which entirely contains an
+ * object.
+ *
+ * @state: the current unwind state.
+ * @sp:    the base address of the object.
+ * @size:  the size of the object.
+ *
+ * Return: a pointer to the relevant stack_info if found; NULL otherwise.
+ */
+static inline struct stack_info *unwind_find_stack(struct unwind_state *state,
+						   unsigned long sp,
+						   unsigned long size)
+{
+	struct stack_info *info = &state->stack;
+
+	if (stackinfo_on_stack(info, sp, size))
+		return info;
+
+	for (int i = 0; i < state->nr_stacks; i++) {
+		info = &state->stacks[i];
+		if (stackinfo_on_stack(info, sp, size))
+			return info;
+	}
+
+	return NULL;
+}
+
+/**
+ * unwind_consume_stack() - Update stack boundaries so that future unwind steps
+ * cannot consume this object again.
+ *
+ * @state: the current unwind state.
+ * @info:  the stack_info of the stack containing the object.
+ * @sp:    the base address of the object.
+ * @size:  the size of the object.
+ *
+ * Stack transitions are strictly one-way, and once we've
+ * transitioned from one stack to another, it's never valid to
+ * unwind back to the old stack.
+ *
+ * Note that stacks can nest in several valid orders, e.g.
+ *
+ *   TASK -> IRQ -> OVERFLOW
+ *
+ * ... so we do not check the specific order of stack
+ * transitions.
+ */
+static inline void unwind_consume_stack(struct unwind_state *state,
+					struct stack_info *info,
+					unsigned long sp,
+					unsigned long size)
+{
+	struct stack_info tmp;
+
+	tmp = *info;
+	*info = stackinfo_get_unknown();
+	state->stack = tmp;
+
+	/*
+	 * Future unwind steps can only consume stack above this frame record.
+	 * Update the current stack to start immediately above it.
+	 */
+	state->stack.low = sp + size;
+}
+
+#endif /* __ASM_RISCV_STACKTRACE_COMMON_H */
-- 
2.43.0


