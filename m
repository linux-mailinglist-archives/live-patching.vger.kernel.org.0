Return-Path: <live-patching+bounces-1264-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF212A5772E
	for <lists+live-patching@lfdr.de>; Sat,  8 Mar 2025 02:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F6EF7A8CF6
	for <lists+live-patching@lfdr.de>; Sat,  8 Mar 2025 01:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3638612E5B;
	Sat,  8 Mar 2025 01:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAuwDe4S"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D0BA49;
	Sat,  8 Mar 2025 01:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741397277; cv=none; b=dJ5Bx2yCJcQy4vv2oX8qwLJn16sup/N2JK7Hxgel6rxvhqnHEhrYlfANUTNUC9yTuVK5IaaRDkcYsSQ6ewalhe4/uxtB/7WRRc6TpJ97VVoV77GRY/EMK+AilYV4Yk3fYiCq/euW3Lq1rtg9W2+SXaZFLzc/7ct0sXoyj4xQ23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741397277; c=relaxed/simple;
	bh=sIHNZlIzJdDqSwxWmFiuoinsaetd8EpvmKMg9ut31Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOZNB3hJqmQ6ynZi75xhNpw7Gy0ycOzUyu8T2WsaU27gsr9f9gwBHnExgQDkYAiOT/q4Aher4UO2AtZEAAC+njfXFIA0d+hNModuShckNWiLGHwnM6kpxyuIuSZ/3O8O9w2zKYaWuCYSwcu3uoKscSlS0QExIe7Ga6urzIO490A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAuwDe4S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4860C4CED1;
	Sat,  8 Mar 2025 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741397276;
	bh=sIHNZlIzJdDqSwxWmFiuoinsaetd8EpvmKMg9ut31Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAuwDe4SWQ2/jLzudLSBU34nrxJi6TAowDSMiXKz8FbAAeo8UYRT1VU5j++hrdia8
	 XkSWwh3kHAApSnTTRww1MCfyjp04jCrKII9bsd6PAVuK2tZaEqn9Jtq/+Jdu7/7oUk
	 IGj3kr8qzT05+3jMuQ4ku0AyopVsHCjddeLu4ExTEN5i3AGu1/swQImAYxUszmxcft
	 vbmkCoO7dgLKYF9r8Yi0p2RVD1S1IqwVnvcYl1E7x0C1gfazqV6sqVC9iZ/bnJLJ7t
	 BZcY69LBkUzFp0k6T9Gwh8rstTE28YTSY3g/nFklzLwDOavM2m44oG1/q7VI9Kwk/R
	 YLrggYcErTElw==
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
Subject: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Date: Fri,  7 Mar 2025 17:27:41 -0800
Message-ID: <20250308012742.3208215-2-song@kernel.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250308012742.3208215-1-song@kernel.org>
References: <20250308012742.3208215-1-song@kernel.org>
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

This version has been inspired by Weinan Liu's patch [1].

[1] https://lore.kernel.org/live-patching/20250127213310.2496133-7-wnliu@google.com/
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/arm64/Kconfig                         |  2 +-
 arch/arm64/include/asm/stacktrace/common.h |  1 +
 arch/arm64/kernel/stacktrace.c             | 44 +++++++++++++++++++++-
 3 files changed, 45 insertions(+), 2 deletions(-)

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
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 821a8fdd31af..072469fd91b7 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -33,6 +33,7 @@ struct unwind_state {
 	struct stack_info stack;
 	struct stack_info *stacks;
 	int nr_stacks;
+	bool unreliable;
 };
 
 static inline struct stack_info stackinfo_get_unknown(void)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..69d0567a0c38 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -230,8 +230,14 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	new_fp = READ_ONCE(record->fp);
 	new_pc = READ_ONCE(record->lr);
 
-	if (!new_fp && !new_pc)
+	if (!new_fp && !new_pc) {
+		/*
+		 * Searching across exception boundaries. The stack is now
+		 * unreliable.
+		 */
+		state->common.unreliable = true;
 		return kunwind_next_frame_record_meta(state);
+	}
 
 	unwind_consume_stack(&state->common, info, fp, sizeof(*record));
 
@@ -347,6 +353,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		.common = {
 			.stacks = stacks,
 			.nr_stacks = ARRAY_SIZE(stacks),
+			.unreliable = false,
 		},
 	};
 
@@ -387,6 +394,41 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
 }
 
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
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			void *cookie, struct task_struct *task)
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
+
 struct bpf_unwind_consume_entry_data {
 	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
 	void *cookie;
-- 
2.43.5


