Return-Path: <live-patching+bounces-1895-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EE4CA2430
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 04:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78AB23051309
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 03:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A747C2FF14E;
	Thu,  4 Dec 2025 03:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4ueK4fO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B4A2FABE3;
	Thu,  4 Dec 2025 03:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764819151; cv=none; b=KzXnU8Rn/k46NerIHsJD5MsQ5dW5W9GMa67wyWjGty/BH0zqdgyKwfghQO27355FCHfn1vd2+8KUflMWHATsCD8N+t/AEDxbsHVuwSoUFvbE8jixh06I3z1jIG7NHFlkM8gV2EZu4GgF661kOnhfnQF3RBhO+11kpLikOSOlb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764819151; c=relaxed/simple;
	bh=yDtvvG/5I3bNM5cx+KLJA0l/qkwgemErJcJUz4VFjOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSNQOVr47UjpRl+4moKZ0WCCkCq0nJJpIXjPRCQ9zjEXeXHUmAL6OWGzy2ElxXUqGXc96rvS1cRxWrXofYG0ONOh+wrSXQI/vAstMbPyJvlUPrbK0HGkRPEu0DBznXWpMiNen1DuZ+3ijYAkOgvOysSLEj0xOaBaPNz8qZ52SS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4ueK4fO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCC6C19423;
	Thu,  4 Dec 2025 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764819150;
	bh=yDtvvG/5I3bNM5cx+KLJA0l/qkwgemErJcJUz4VFjOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4ueK4fODazjXLi8qe+Z4foE7PjfpYx01jgvSsNAFlIzAX+HT2ZHUkLMzSgqIKc15
	 Owcjpm2cScJJiKjgrfGefIm2UgOyrM7NGDVQgXln0g4xysKFmF0QKoDcYpI/PmNW/8
	 WgkGA5ib3SUu92OsEpD+Nmjy28ua6yS7obB26FrWt/HsqKI185TxWJYJPOJ4c9Mv0W
	 K/6EiV8B7EKb1SQJY7TUdSCzkgewVKjlAwu4qVGfYfFbUjIMzGj/EbNyUr/iVEuHXg
	 IaUXSXj3ihmIiwMq882mQpL8BGi/tTjKAox8yPRIObrme8rpMfOwY2iKkj+do5OguR
	 3xCCj6ql56U9Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	bpf@vger.kernel.org,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>,
	Raja Khan <raja.khan@crowdstrike.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 1/2] bpf: Add bpf_has_frame_pointer()
Date: Wed,  3 Dec 2025 19:32:15 -0800
Message-ID: <fd2bc5b4e261a680774b28f6100509fd5ebad2f0.1764818927.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1764818927.git.jpoimboe@kernel.org>
References: <cover.1764818927.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a bpf_has_frame_pointer() helper that unwinders can call to
determine whether a given instruction pointer is within the valid frame
pointer region of a BPF JIT program or trampoline (i.e., after the
prologue, before the epilogue).

This will enable livepatch (with the ORC unwinder) to reliably unwind
through BPF JIT frames.

Acked-by: Song Liu <song@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky<andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 12 ++++++++++++
 include/linux/bpf.h         |  3 +++
 kernel/bpf/core.c           | 16 ++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index de5083cb1d37..3ec4fa94086a 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1661,6 +1661,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *rw_image
 	emit_prologue(&prog, image, stack_depth,
 		      bpf_prog_was_classic(bpf_prog), tail_call_reachable,
 		      bpf_is_subprog(bpf_prog), bpf_prog->aux->exception_cb);
+
+	bpf_prog->aux->ksym.fp_start = prog - temp;
+
 	/* Exception callback will clobber callee regs for its own use, and
 	 * restore the original callee regs from main prog's stack frame.
 	 */
@@ -2716,6 +2719,8 @@ st:			if (is_imm8(insn->off))
 					pop_r12(&prog);
 			}
 			EMIT1(0xC9);         /* leave */
+			bpf_prog->aux->ksym.fp_end = prog - temp;
+
 			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
 			break;
 
@@ -3299,6 +3304,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 	}
 	EMIT1(0x55);		 /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
+	if (im)
+		im->ksym.fp_start = prog - (u8 *)rw_image;
+
 	if (!is_imm8(stack_size)) {
 		/* sub rsp, stack_size */
 		EMIT3_off32(0x48, 0x81, 0xEC, stack_size);
@@ -3436,7 +3444,11 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 
 	emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
+
 	EMIT1(0xC9); /* leave */
+	if (im)
+		im->ksym.fp_end = prog - (u8 *)rw_image;
+
 	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
 		/* skip our return address and return to parent */
 		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d808253f2e94..e3f56e8443da 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1257,6 +1257,8 @@ struct bpf_ksym {
 	struct list_head	 lnode;
 	struct latch_tree_node	 tnode;
 	bool			 prog;
+	u32			 fp_start;
+	u32			 fp_end;
 };
 
 enum bpf_tramp_prog_type {
@@ -1483,6 +1485,7 @@ void bpf_image_ksym_add(struct bpf_ksym *ksym);
 void bpf_image_ksym_del(struct bpf_ksym *ksym);
 void bpf_ksym_add(struct bpf_ksym *ksym);
 void bpf_ksym_del(struct bpf_ksym *ksym);
+bool bpf_has_frame_pointer(unsigned long ip);
 int bpf_jit_charge_modmem(u32 size);
 void bpf_jit_uncharge_modmem(u32 size);
 bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d595fe512498..7cd8382d1152 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -760,6 +760,22 @@ struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
 	       NULL;
 }
 
+bool bpf_has_frame_pointer(unsigned long ip)
+{
+	struct bpf_ksym *ksym;
+	unsigned long offset;
+
+	guard(rcu)();
+
+	ksym = bpf_ksym_find(ip);
+	if (!ksym || !ksym->fp_start || !ksym->fp_end)
+		return false;
+
+	offset = ip - ksym->start;
+
+	return offset >= ksym->fp_start && offset < ksym->fp_end;
+}
+
 const struct exception_table_entry *search_bpf_extables(unsigned long addr)
 {
 	const struct exception_table_entry *e = NULL;
-- 
2.51.1


