Return-Path: <live-patching+bounces-2862-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6B5/MxgKDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2862-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:58:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 533B95787C8
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 20EA03042C4C
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EABA3AEF3A;
	Tue, 19 May 2026 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vaIEfeNS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262452DAFCC
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173426; cv=none; b=tKS2gCnup3oLhRkz4NX6SYLD6DnhZFMgevc2kJkie1fBtmD3+g/7Z074Q4qK/HVKYVHvG2YVyyQ3Wb8FDC0bW41p8Ww+mTk+99jr6OQ0Hz0R/7OwcPwFo3HpcBBQ+ftiHeQapQQ5fJbTO7bEXKTPkpHQ4wzF+00vIcwSatY4+5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173426; c=relaxed/simple;
	bh=UPOgm3KMbDRUzafFUZHdkyXwc8rZGs67jTUxLApECC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M00VKLifx24axT7Me+3lVvMEsOLPrkUFy5kxyTKqtiW3qt1NA6EIkevisJnEjOGF1DTHy2e3bX0B5Mhi80j+gq9NSCEV/CQHmIyqUk1BDVE5CpwSmLYFz1fhuXWRstKr+tv2g5GyFXxA46gF68UCIvgr8pku13xNerFucg0KFLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vaIEfeNS; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-83536dc3be5so3155605b3a.1
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173423; x=1779778223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azyUJ35drB6eBvHruuuz2oV972yj5pSTtfb7XbUuZ9M=;
        b=vaIEfeNSb3mGweiHmi2Ooxr+RTFX4aq9+cAGJehBG0Lv+xMJX6SfdvTuLH/a3fkuXN
         h2EWkaly4v2DFtKKX7kuNtdpRyty3NJtwE1rvj4cB4NvdWKSn0U1XW1veQ7A1b9ZhmDW
         4KAjDimPQ5KRRIuRXns9RQGdPqPNCaoAd/0um28HI8bGxbd6gwtai51zYav1lBDyXuam
         D5ss2uTLzTUt+e/OWk+9K4xSp7yoftqRz2CvJdMthmuAH207N478rkSRrXYiewcSBl3T
         XQL1Pgu2TmnJ1mWqVEH9dlgVGV3oRObQsr4BvvMFlMqN0wT2JLyRce59m8Q5YeKbFj3v
         Rw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173423; x=1779778223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azyUJ35drB6eBvHruuuz2oV972yj5pSTtfb7XbUuZ9M=;
        b=KckQDYFKpPtGqlnFzHF85+5CFHG866/qgKS+iDQcUTgLKC7qkxkCa2qfCD6//JweNY
         SoIe1g0V3WUYkv18xw0ct9YZGgcCHewFg0wBIhCNidOtapbreWhwAfyQHKbqagnOSgoA
         Ce0nDSncpdE7JVjUE7jYv0qqePpnjCLGv4Ivy3n8RlAN1k0h7wSzSWAQCb6y6Zz62FQ0
         QU/r3SzstxQaI3MnDzr9loNZeTMnNKEi7YiM8GxWlQcRKc4w+kQPB92v2Irq5PsTwYhA
         Berq9r1y+xG72eCa1k8hbml2jkWPN+DmhtaFeQWR61/F80xDiw5vUWqc9uBs8YPxQ6Mw
         4LLw==
X-Forwarded-Encrypted: i=1; AFNElJ9I1ZLjI1kK+zNUFg1W4nebvvZdOXTknRYLvpjDASzRaymqsQCFMpH/FaTGQNZCXHOoOLr/crSqzTdhB+zx@vger.kernel.org
X-Gm-Message-State: AOJu0YyFfeFEMdHZGmrePvw244R8tBkOW8jlRi+vbt3jLzowKkSvAYgn
	B7IXtjHZ7xpjzP8BSfZlTYVw3ksVH2yaHLJjH5tumt7tmeEA7UWQXrxsgIkF2IEE6Gm3Y8OMcuX
	EBPjKvx6noiPqbo2FAr6WH4LqLQ==
X-Received: from pfbfk10.prod.google.com ([2002:a05:6a00:3a8a:b0:83f:2647:b711])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a10:b0:83e:c8f8:cec7 with SMTP id d2e1a72fcca58-83f33dddb8cmr18668832b3a.35.1779173422844;
 Mon, 18 May 2026 23:50:22 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:50 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-10-dylanbhatch@google.com>
Subject: [PATCH v6 9/9] unwind: arm64: Use sframe to unwind interrupt frames
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2862-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 533B95787C8
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
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/stacktrace.c | 222 ++++++++++++++++++++++++++++++---
 1 file changed, 202 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3ebcf8c53fb0..cee860ca8ce5 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
+#include <linux/sframe.h>
 #include <linux/stacktrace.h>
 
 #include <asm/efi.h>
@@ -26,6 +27,7 @@ enum kunwind_source {
 	KUNWIND_SOURCE_CALLER,
 	KUNWIND_SOURCE_TASK,
 	KUNWIND_SOURCE_REGS_PC,
+	KUNWIND_SOURCE_REGS_LR,
 };
 
 union unwind_flags {
@@ -45,6 +47,7 @@ union unwind_flags {
  * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
+ * @unreliable:  Stacktrace is unreliable.
  */
 struct kunwind_state {
 	struct unwind_state common;
@@ -56,6 +59,7 @@ struct kunwind_state {
 	enum kunwind_source source;
 	union unwind_flags flags;
 	struct pt_regs *regs;
+	bool unreliable;
 };
 
 static __always_inline void
@@ -181,7 +185,6 @@ int kunwind_next_regs_pc(struct kunwind_state *state)
 	state->regs = regs;
 	state->common.pc = regs->pc;
 	state->common.fp = regs->regs[29];
-	state->regs = NULL;
 	state->source = KUNWIND_SOURCE_REGS_PC;
 	return 0;
 }
@@ -244,6 +247,168 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
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
+ * Unwind from a pt_regs according to sframe.
+ */
+static __always_inline int
+kunwind_next_regs_sframe(struct kunwind_state *state)
+{
+	struct unwind_frame frame;
+	unsigned long cfa, fp, ra;
+	enum kunwind_source source = KUNWIND_SOURCE_FRAME;
+	struct pt_regs *regs = state->regs;
+
+	int err;
+
+	if (WARN_ON_ONCE(state->source != KUNWIND_SOURCE_REGS_PC))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!state->regs))
+		return -EINVAL;
+
+	/* FP/SP alignment 8 bytes */
+	if (state->common.fp & 0x7)
+		return -EINVAL;
+
+	err = sframe_find_kernel(state->common.pc, &frame);
+	if (err)
+		return -EINVAL;
+
+	/*
+	 * A kernel unwind should always end at a FRAME_META_TYPE_FINAL
+	 * frame. There should be no outermost frames within the kernel.
+	 */
+	if (frame.outermost)
+		return -EINVAL;
+
+	/* Get the Canonical Frame Address (CFA) */
+	switch (frame.cfa.rule) {
+	case UNWIND_CFA_RULE_SP_OFFSET:
+		cfa = state->regs->sp;
+		break;
+	case UNWIND_CFA_RULE_FP_OFFSET:
+		if (state->common.fp < state->regs->sp)
+			return -EINVAL;
+		cfa = state->common.fp;
+		break;
+	/*
+	 * UNWIND_CFA_RULE_REG_OFFSET and UNWIND_CFA_RULE_REG_OFFSET_DEREF not
+	 * implemented -- flexible FDEs are not currently generated by assembler
+	 * for arm64.
+	 */
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	cfa += frame.cfa.offset;
+
+	/* CFA alignment 16 bytes */
+	if (cfa & 0x15)
+		return -EINVAL;
+
+	/* Get the Return Address (RA) */
+	switch (frame.ra.rule) {
+	case UNWIND_RULE_RETAIN:
+		ra = regs->regs[30];
+		source = KUNWIND_SOURCE_REGS_LR;
+		break;
+
+	/*
+	 * UNWIND_RULE_CFA_OFFSET doesn't make sense for RA.
+	 * The return address cannot legitimately be a stack address.
+	 */
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
+		ra = cfa + frame.ra.offset;
+		break;
+	/*
+	 * UNWIND_RULE_REG_OFFSET and UNWIND_RULE_REG_OFFSET_DEREF not
+	 * implemented -- flexible FDEs are not currently generated by assembler
+	 * for arm64.
+	 */
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
+	/*
+	 * UNWIND_RULE_CFA_OFFSET is currently not used for FP
+	 * (e.g. SFrame cannot represent this rule).
+	 */
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
+		fp = cfa + frame.fp.offset;
+		break;
+	/*
+	 * UNWIND_RULE_REG_OFFSET and UNWIND_RULE_REG_OFFSET_DEREF not
+	 * implemented -- flexible FDEs are not currently generated by assembler
+	 * for arm64.
+	 */
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
+	state->common.fp = fp;
+
+	state->source = source;
+
+	return 0;
+}
+
+#else /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
+
+static __always_inline int
+unwind_next_frame_sframe(struct kunwind_state *state) { return -EINVAL; }
+
+#endif /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME*/
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -259,10 +424,20 @@ kunwind_next(struct kunwind_state *state)
 	state->flags.all = 0;
 
 	switch (state->source) {
+	case KUNWIND_SOURCE_REGS_PC:
+		err = kunwind_next_regs_sframe(state);
+
+		if (err && err != -ENOENT) {
+			/* Fallback to FP based unwinder */
+			err = kunwind_next_frame_record(state);
+			state->unreliable = true;
+		}
+		state->regs = NULL;
+		break;
 	case KUNWIND_SOURCE_FRAME:
 	case KUNWIND_SOURCE_CALLER:
 	case KUNWIND_SOURCE_TASK:
-	case KUNWIND_SOURCE_REGS_PC:
+	case KUNWIND_SOURCE_REGS_LR:
 		err = kunwind_next_frame_record(state);
 		break;
 	default:
@@ -390,34 +565,40 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
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
+	if (state->unreliable) {
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
@@ -452,6 +633,7 @@ static const char *state_source_string(const struct kunwind_state *state)
 	case KUNWIND_SOURCE_CALLER:	return "C";
 	case KUNWIND_SOURCE_TASK:	return "T";
 	case KUNWIND_SOURCE_REGS_PC:	return "P";
+	case KUNWIND_SOURCE_REGS_LR:	return "L";
 	default:			return "U";
 	}
 }
-- 
2.54.0.563.g4f69b47b94-goog


