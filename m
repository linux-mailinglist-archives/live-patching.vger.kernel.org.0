Return-Path: <live-patching+bounces-1886-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C53C9C9A7
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 19:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 23F554E35E5
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 18:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555E12D0C7F;
	Tue,  2 Dec 2025 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4Iwxv6H"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CFC2C3265;
	Tue,  2 Dec 2025 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764699646; cv=none; b=Y5l6CaORI/egoqaEnfkFBY5+uADXK3fbuKyGfuBOQ8ywpTTBVdLICAlIDmf46iB92HtUkZFG3X6iAY4nDDPFcAKJ9dK1bw2Gj3CwvedL7lAcJL79T8wfNyDGM4YsPmu8RPoFie68y/I9LRYqybUwIUm2HBQGBWGNlIUwyfEQJ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764699646; c=relaxed/simple;
	bh=6YydD1V29Lq5CgnNjkSw6qANowwI15xWUFlqTLG2Y7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJc3mJN08OkZpI3ZIcnCD3/kTRg508rsWAIRM3mUgUGy3+DEUh2Yt27zmzp0rvnjJfhWM1nlVamOqfCI3gXAt5QjVNRuOylNqRDc0/mMYAtGyEHDBkbF8tuA6CdvpU9YFk+H5yqaSrtxF+f+uFksF0mB1ze7AZVYQKKbNJIft78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4Iwxv6H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3189DC116B1;
	Tue,  2 Dec 2025 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764699645;
	bh=6YydD1V29Lq5CgnNjkSw6qANowwI15xWUFlqTLG2Y7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4Iwxv6Hqz1tcGOLUmVevPKXcPP9yTzboMfDxgwjPZyokW8Ph3oSIeByoQbMTy/E0
	 oJYQ9J3OoRuunhVxv8VecNSLMt71wja2Dn1HhgGLZguZZJC8Pe0A9+0ilMu07Rrzvd
	 ood/Ao/qwl5WFHRpGY+un1PLQ2Pi0lZ2TAWuJGRAzhAfre2QwncXMWRHfwLF5puBEU
	 ONtrdB32/ytDczKp+4oJx4K+dh/6CpKS+FaCzdk1FCi5hMDfV0T2FXTt6Fb2taQ14e
	 2dsTr4zZL/Kyi+3y3tgbnAVQb7EfF38aCtsoIvgqS8Gibjmb/TOHnJKlJmhYicp/z0
	 NdQctsLdTVPRA==
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
Subject: [PATCH 1/2] bpf: Add bpf_has_frame_pointer()
Date: Tue,  2 Dec 2025 10:19:18 -0800
Message-ID: <c2764d2ad229d0bcea21dbb774e2494ca34fc130.1764699074.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1764699074.git.jpoimboe@kernel.org>
References: <cover.1764699074.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a bpf_has_frame_pointer() helper that uwninders can call to
determine whether a given instruction pointer is within the valid frame
pointer region of a BPF JIT program or trampoline (i.e., after the
prologue, before the epilogue).

This will enable livepatch (with the ORC unwinder) to reliably unwind
through BPF JIT frames.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 10 ++++++++++
 include/linux/bpf.h         |  3 +++
 kernel/bpf/core.c           | 16 ++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index de5083cb1d37..510e3e62fd2f 100644
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
 
@@ -3299,6 +3304,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 	}
 	EMIT1(0x55);		 /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
+	im->ksym.fp_start = prog - (u8 *)rw_image;
+
 	if (!is_imm8(stack_size)) {
 		/* sub rsp, stack_size */
 		EMIT3_off32(0x48, 0x81, 0xEC, stack_size);
@@ -3436,7 +3443,10 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 
 	emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
+
 	EMIT1(0xC9); /* leave */
+	im->ksym.fp_end = prog - (u8 *)rw_image;
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


