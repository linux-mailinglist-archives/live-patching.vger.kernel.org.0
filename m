Return-Path: <live-patching+bounces-1073-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 058BCA1FFED
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE19118834AE
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA40D1DC9B1;
	Mon, 27 Jan 2025 21:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJjR64Tw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A271DC992
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013621; cv=none; b=VEkEbOT0TMccyNcF+gIVZUwVfNGnTkV2ucb0Wg4tyNAKgBTubKwiVXIbnf5fr5/H1YEMxgTfTWbq0g8/eFyQ64xI+9GcOw6AHdECLk1BcDUnLDuGu0lMfS3PeHlhxw0TJJRlh6n/bH7tZwXOrxyGFBZx/BWrSHZd/U5L6UwtA6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013621; c=relaxed/simple;
	bh=tLQk9i7rfIosZMUbrAAbSOIaa7HREbh9qj/W4g2I5R0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VVN0khwWNiA/qpunCU6qw7f1jBK7AnaOcsFyMadyB2DVMf9K1kXg+Z59ynYKPop81wx1pJmXM4tZrQVhOkucy0YuQ3Lkp4DHv508KY7GxgnE6GCIR6pQj8SkalT4kf9Gf/xv3kUK8GaGBxM9PBk+fwFAEL9+yU6GtrAZqZJQ65s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJjR64Tw; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2164fad3792so82086245ad.0
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013619; x=1738618419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FcMmLMqjQF9870LrAMy1ogNf6Ad9PcDDaPxJ25OGjiY=;
        b=UJjR64Twt0a/emLT+XNSdujeU7vYZURAjRUPGpFeJDkby7i07DSNHLR8rnGPWOfd0M
         aGxnYZJ0QUhpjwC8P5DrCb3/FKHI+4BR4/JHAYiRIDNXCaZ1xPgTIUFmpb1GdXckUkJB
         l0Hb03BR89lyeV5mNco8xVD4cqBlIhtHuhqhBAP2/gUIh/GqrhZtfPXrlDW13yzNyj80
         dJu1pWM1HSUvjWB7SV/WzXI7lMzigKUuZFhHYnSInmb9U+VpSfMzcWTFoCvYgLi9qZJk
         bdBtfXowLHxLVP/ehik04W5ZBRtcjrGm8mwerEY3tOQszgbFVqNWJ5l+Lx8/iE31XtnO
         VFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013619; x=1738618419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcMmLMqjQF9870LrAMy1ogNf6Ad9PcDDaPxJ25OGjiY=;
        b=nk4+w7FJtfn3diLjNTL9RHRcl+RAhlHiAf0KTSiTG+M9rr7cxGrH+0/Q2VSomNbTaJ
         lP/ty87SIVB+OdW1arclXvWW8ACngN2tuJUT06izNhyf3kI3hxFSalj9ZGNX6BMf5/Wl
         dnlJNW4niniYqDBFlZGAE2vviAJpPaHiBNDdJEWyS5pb4pKVmHawqxVX2lcG96/1bRGm
         +r6kJanJk7b7/1oBzH8KilXTmlFk5CevmLyfE3bfIaCsxon0T4RdbGtEbrnuMdnxWXtD
         ov+T7srNhFcWRapmHLdE65BgKQp1M3p8OQLHsZCkYYsSocJ0qIVvzriEDCv57vHeSoJI
         0wzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvOCQYExGcNRTi7SSPnniziJ2DFoIMm90/opRTdDI5599ffBOIYNkFh0oa8gT81hSbLo6r51WDkf1z74BV@vger.kernel.org
X-Gm-Message-State: AOJu0YzrlOkrePolhO9UQnwm9i/IVyc0U5LoBVGpMVFcG8zzYmRi9Mw1
	JKK3L+g+1pNRfXwRmHbhXeWxbBdeXL8Ec37hAsoaJPmBQyyyrejqUYCSfKwudd0iGak6qZzVUQ=
	=
X-Google-Smtp-Source: AGHT+IENqQ4a+JpNNuEyJE6twpdJLH79mb1KDwUiISYTqFmJctu2Pc5D2j5e3Ta7eQhNemgumBMfeJjRgA==
X-Received: from pgbbg17.prod.google.com ([2002:a05:6a02:111:b0:7fc:2b57:38f5])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:841c:b0:1e0:d9a0:4ff7
 with SMTP id adf61e73a8af0-1eb21599eecmr80987482637.32.1738013619557; Mon, 27
 Jan 2025 13:33:39 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:08 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-7-wnliu@google.com>
Subject: [PATCH 6/8] unwind: arm64: add reliable stacktrace support for arm64
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

To support livepatch, we need to add arch_stack_walk_reliable to
support reliable stacktrace according to
https://docs.kernel.org/livepatch/reliable-stacktrace.html#requirements

report stacktrace is not reliable if we are not able to unwind the stack
by sframe unwinder and fallback to FP based unwinder

Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/include/asm/stacktrace/common.h |  2 +
 arch/arm64/kernel/stacktrace.c             | 47 +++++++++++++++++++++-
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 19edae8a5b1a..26449cd402db 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -26,6 +26,7 @@ struct stack_info {
  * @stacks:      An array of stacks which can be unwound.
  * @nr_stacks:   The number of stacks in @stacks.
  * @cfa:         The sp value at the call site of the current function.
+ * @unreliable:  Stacktrace is unreliable.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -36,6 +37,7 @@ struct unwind_state {
 	int nr_stacks;
 #ifdef CONFIG_SFRAME_UNWINDER
 	unsigned long cfa;
+	bool unreliable;
 #endif
 };
 
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c035adb8fe8a..eab16dc05bb5 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -310,11 +310,16 @@ kunwind_next(struct kunwind_state *state)
 	case KUNWIND_SOURCE_TASK:
 	case KUNWIND_SOURCE_REGS_PC:
 #ifdef CONFIG_SFRAME_UNWINDER
-	err = unwind_next_frame_sframe(&state->common);
+	if (!state->common.unreliable)
+		err = unwind_next_frame_sframe(&state->common);
 
 	/* Fallback to FP based unwinder */
-	if (err)
+	if (err || state->common.unreliable) {
 		err = kunwind_next_frame_record(state);
+		/* Mark its stacktrace result as unreliable if it is unwindable via FP */
+		if (!err)
+			state->common.unreliable = true;
+	}
 #else
 	err = kunwind_next_frame_record(state);
 #endif
@@ -446,6 +451,44 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
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
+#endif
+
 struct bpf_unwind_consume_entry_data {
 	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
 	void *cookie;
-- 
2.48.1.262.g85cc9f2d1e-goog


