Return-Path: <live-patching+bounces-1081-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B589A226EF
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 00:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E2761887CA3
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2025 23:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5581B219F;
	Wed, 29 Jan 2025 23:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFKI3DC/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC817BBF;
	Wed, 29 Jan 2025 23:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193421; cv=none; b=tqP3eNsGHORZKHtqjoiigrKfy/ZInEJG1+KRRiiJuOz9ws8nKCXF0802QxQpkCT3x+GDuIRVATBwTV8eSBKKfG9473iUI/tsvrITA/0BsMBHT33AKbY4RNNRc5Q7S3XscTPkRyb5Rt7qkl28gktm/Dc/vmlerCPrpxcz1rCCnp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193421; c=relaxed/simple;
	bh=wUAJ/v7od0Gk1yKWDiIdIZiAOmZif9syfzaEjk1XI98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IUdWzHK410CGNrOWGyPg5913tvUV4YO0M3eTn01ddB1/pUsoeVXLtyJub3mR9S1UALNQHFoNKEbOoklWBgDBj9pgHV36ZEw58Uichgo0fFNBp5nQi3HKMuASWF7RZwNRH+31h05rOxdtz3w7gDRSaRbsiOUzPiFsnFytdFamBLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFKI3DC/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735BEC4CED1;
	Wed, 29 Jan 2025 23:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738193419;
	bh=wUAJ/v7od0Gk1yKWDiIdIZiAOmZif9syfzaEjk1XI98=;
	h=From:To:Cc:Subject:Date:From;
	b=sFKI3DC/0dh9WCpYNoY1rOI8OJq2KVdOEeiWXMUrstkGDrDmBf0vMC3KwtGEGyd/A
	 2NFu3zxaXhYyoK3hbcbS0zgI6aPGxQlN6QcOJBPN4CAN8+AqfDBYKi2sg79/GLNc/p
	 1OijCbNAD4tJmDVrgrbNaZSF3x+6oVuy30+Nqyw9j10ZqTqA4noOqz+9WjRZo30WyU
	 glWg6lqBo+ysYEXeDfj97P03eYZBRDCGnLnQ7OUVXadbylJV0j5FKUDIqDTiC1dVX/
	 Pz5WNxapg7SZHo+qaiHZtV6dQgZd+nPqkHN09LFgpGNvSybSt4Av/6jhwwN4eFJJhL
	 K/M3XfBR6YjBA==
From: Song Liu <song@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	surajjs@amazon.com,
	duwe@suse.de,
	song@kernel.org,
	kernel-team@meta.com
Subject: [RFC 1/2] arm64: Implement arch_stack_walk_reliable
Date: Wed, 29 Jan 2025 15:29:35 -0800
Message-ID: <20250129232936.1795412-1-song@kernel.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let do_kunwind() and kunwind_stack_walk() return the state of stack walk
properly to the caller, and use them in arch_stack_walk_reliable(). This
can be used to enable livepatching for arm64.

Signed-off-by: Song Liu <song@kernel.org>
---
 arch/arm64/Kconfig             |  2 +-
 arch/arm64/kernel/stacktrace.c | 35 +++++++++++++++++++++++++++-------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 213f42d5ca27..f5af6faf9e2b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -271,6 +271,7 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2495,4 +2496,3 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
-
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627f..280dd6839a18 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -277,22 +277,28 @@ kunwind_next(struct kunwind_state *state)
 
 typedef bool (*kunwind_consume_fn)(const struct kunwind_state *state, void *cookie);
 
-static __always_inline void
+static __always_inline int
 do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 	   void *cookie)
 {
+	int ret;
+
 	if (kunwind_recover_return_address(state))
-		return;
+		return -EINVAL;
 
 	while (1) {
-		int ret;
 
-		if (!consume_state(state, cookie))
+		ret = consume_state(state, cookie);
+		if (!ret)
 			break;
 		ret = kunwind_next(state);
 		if (ret < 0)
 			break;
 	}
+	/* Unwind terminated successfully */
+	if (ret == -ENOENT)
+		ret = 0;
+	return ret;
 }
 
 /*
@@ -324,7 +330,7 @@ do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 			: stackinfo_get_unknown();		\
 	})
 
-static __always_inline void
+static __always_inline int
 kunwind_stack_walk(kunwind_consume_fn consume_state,
 		   void *cookie, struct task_struct *task,
 		   struct pt_regs *regs)
@@ -352,7 +358,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 
 	if (regs) {
 		if (task != current)
-			return;
+			return -EINVAL;
 		kunwind_init_from_regs(&state, regs);
 	} else if (task == current) {
 		kunwind_init_from_caller(&state);
@@ -360,7 +366,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 		kunwind_init_from_task(&state, task);
 	}
 
-	do_kunwind(&state, consume_state, cookie);
+	return do_kunwind(&state, consume_state, cookie);
 }
 
 struct kunwind_consume_entry_data {
@@ -387,6 +393,21 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
 }
 
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			void *cookie, struct task_struct *task)
+{
+	int ret;
+
+	struct kunwind_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+	};
+
+	ret = kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, NULL);
+
+	return ret;
+}
+
 struct bpf_unwind_consume_entry_data {
 	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
 	void *cookie;
-- 
2.43.5


