Return-Path: <live-patching+bounces-1072-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 572D4A1FFEB
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EED0718825DF
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936331DB54C;
	Mon, 27 Jan 2025 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="byKFvHqx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F21DC05F
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013619; cv=none; b=klMT5unNYPyckU5GrZHLl3c/abYc2vJFmZ+H6RpNhgeB7NBAw/H9xgtxBQq8tMvQPajrvUydAXWvnjLHt3x7ISaIf5MdMNwOwjJnNAbmdxGswW8tajEupIGqp/u9xGq2ldEycwfFTgPYRyNHajzprGu6AZEaX7zY1wcMbS2otgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013619; c=relaxed/simple;
	bh=0ubT0xAtIOtmf4+xnpRjnjYol+CqTrZ8xAjo8nvcNvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FL9rX4xiZVFtZ69j7YZ+lq0OB8r7MFjbFPwOfFYQOg+GO0GfJ++p3hVWRmW/brtxNPyb932hpRAQSe1hRSpQB2TMiw9cR75xntZuXM+kwlsBYBC5SvoeBeg/YwUtH8Poy9i/qAS2KYzp+tOTEpU8oRxq7+NPhlQyfMyZmE4GKt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=byKFvHqx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso132664545ad.2
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013617; x=1738618417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mFZXsTdloa5FzORw/CsOyUNbSmbFrEPnylJyQFApTRk=;
        b=byKFvHqxa6uwtj1PpyusG9Crc0EIWmJqd+MM6iNb6/8i/imykVkJFRzl1jJ45smEf1
         Ys7kiBwq3XxjKlAxy9wtxYbuVnO7oq6VD5ZgTxDjiZpwbeeC2xNohSkBC+LxSiaN0571
         mLieTnpf2OipXafKJ6YeVdGQHu+ganUmCuNqc4J379Rww5KTX54Yk0GsGG0XG+rLhgmE
         Xwi5p/ZsaJMr/T72e9oXQApap9CMB2BoFDKthZOxpvIaWVgppvp2Lh5fNQXCAuG8ydoM
         swRUg8/q19FL0G3te1MgYdX5SU4+bXHU9jHHQYE4YhJqzuafiKHonOxcBZg1p2CedG/7
         P4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013617; x=1738618417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mFZXsTdloa5FzORw/CsOyUNbSmbFrEPnylJyQFApTRk=;
        b=SAGXed2ctpdsaQK1vzsNv5e3mrRzPYhlwzq1Tiql+JPB+pc9UWLIjd1UpdMIEaxWdR
         fPyCJKk9PupELy+CiPmqQmeHPRJjuS4RIwosu0b2916EBqUxmBRHwI/ypNHKf/SD0iE4
         8mNAbziDXwiZu2srnUOiQW2Y0zieP9DnRiRZiDhQ8kwr8qXqg0dR4Qi2V9duGT89OLAq
         RmLRspAD26t3YprypL1Ykv763LCIIXB3d39efSjBjiee/XXd22P+JVxjVLHSQw2xxT7z
         IWDo5OPU4v8x8lCdx1UfyUHEsuSkWHi0QM99u6FittlZl6jD/hAge/IAeBe6wM3x6rLt
         wvog==
X-Forwarded-Encrypted: i=1; AJvYcCUXoQ9w+ISK7kH8GPQl64y5cAkKVEoVvVb59zNtAGwP8IdzCG6PogGIUrXSRxXieHSx4sVV4QVQ6/NqG5mD@vger.kernel.org
X-Gm-Message-State: AOJu0Yz54osVxL9jMqq+zs0XRrpb4bB71dcLHfTzUBQYSqjl+J1nTmer
	IjWpuAN541OprQDP4H72gfdyVlToEW6JOy4aCXFyr5A/TDzDs7Mclmk8zUJDQdVE5vqEZnsdng=
	=
X-Google-Smtp-Source: AGHT+IENha76YNN6DTFkO6aZG4PVMEo+T4QLkeiQTYtMA7zB4aNyty+JXRxi3cxPQYVRs4yLEbvYOf/KmQ==
X-Received: from pfbbx20.prod.google.com ([2002:a05:6a00:4294:b0:729:14f9:2f50])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c6:b0:1e0:e000:ca60
 with SMTP id adf61e73a8af0-1eb215ec22fmr70877628637.28.1738013617138; Mon, 27
 Jan 2025 13:33:37 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:07 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-6-wnliu@google.com>
Subject: [PATCH 5/8] unwind: arm64: Add sframe unwinder on arm64
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

Add unwind_next_frame_sframe() function to unwind by sframe info.
Built with GNU Binutils 2.42 to verify that this sframe unwinder can
backtrace correctly on arm64.

Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/include/asm/stacktrace/common.h |  4 ++
 arch/arm64/kernel/setup.c                  |  2 +
 arch/arm64/kernel/stacktrace.c             | 59 ++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 821a8fdd31af..19edae8a5b1a 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -25,6 +25,7 @@ struct stack_info {
  * @stack:       The stack currently being unwound.
  * @stacks:      An array of stacks which can be unwound.
  * @nr_stacks:   The number of stacks in @stacks.
+ * @cfa:         The sp value at the call site of the current function.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -33,6 +34,9 @@ struct unwind_state {
 	struct stack_info stack;
 	struct stack_info *stacks;
 	int nr_stacks;
+#ifdef CONFIG_SFRAME_UNWINDER
+	unsigned long cfa;
+#endif
 };
 
 static inline struct stack_info stackinfo_get_unknown(void)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 4f613e8e0745..d3ac92b624f3 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -32,6 +32,7 @@
 #include <linux/sched/task.h>
 #include <linux/scs.h>
 #include <linux/mm.h>
+#include <linux/sframe_lookup.h>
 
 #include <asm/acpi.h>
 #include <asm/fixmap.h>
@@ -377,6 +378,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 			"This indicates a broken bootloader or old kernel\n",
 			boot_args[1], boot_args[2], boot_args[3]);
 	}
+	init_sframe_table();
 }
 
 static inline bool cpu_can_disable(unsigned int cpu)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..c035adb8fe8a 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -14,6 +14,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
+#include <linux/sframe_lookup.h>
 
 #include <asm/efi.h>
 #include <asm/irq.h>
@@ -242,6 +243,53 @@ kunwind_next_frame_record(struct kunwind_state *state)
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
@@ -261,7 +309,15 @@ kunwind_next(struct kunwind_state *state)
 	case KUNWIND_SOURCE_CALLER:
 	case KUNWIND_SOURCE_TASK:
 	case KUNWIND_SOURCE_REGS_PC:
+#ifdef CONFIG_SFRAME_UNWINDER
+	err = unwind_next_frame_sframe(&state->common);
+
+	/* Fallback to FP based unwinder */
+	if (err)
 		err = kunwind_next_frame_record(state);
+#else
+	err = kunwind_next_frame_record(state);
+#endif
 		break;
 	default:
 		err = -EINVAL;
@@ -347,6 +403,9 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		.common = {
 			.stacks = stacks,
 			.nr_stacks = ARRAY_SIZE(stacks),
+#ifdef CONFIG_SFRAME_UNWINDER
+			.cfa = 0,
+#endif
 		},
 	};
 
-- 
2.48.1.262.g85cc9f2d1e-goog


