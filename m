Return-Path: <live-patching+bounces-1875-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF77C7C0C4
	for <lists+live-patching@lfdr.de>; Sat, 22 Nov 2025 01:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 103033438E1
	for <lists+live-patching@lfdr.de>; Sat, 22 Nov 2025 00:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F89E201004;
	Sat, 22 Nov 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfM9OGf7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C671C5D72;
	Sat, 22 Nov 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763772970; cv=none; b=HJxxEHgcS6yyuEnhJl48y/xm4jYYec8M9ochU7gpR83CS6iTYsjyFABGc5VfTz0eP4gZJ78hOmzb5zhMLLLHgRBHxsjHVmEf6p+anaezvA0bnDC7QhypjS5ukI8lpmOmhQRrS49wErtF0hUqAfLKNzlTSJGb6pCerLodpFdCjfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763772970; c=relaxed/simple;
	bh=xcizmFTGKAM+3wGhQq/RlwVd1svgCwYfWkKqY6ABGVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buLMlV5aAJzABNyaB0w5z5s2vzt1/cY9prXa8v0Cm8Hur7V2dBO7NK+sNJnTAzlw/O+AYBRVKvfm8mPBJpKB2uA6qAwWZbcYdTXupHpDAj5SyRQ4Eh548I7edKYuIo45uU+GdzujXFAtYyCA48WlnsSC1oMMCSKyvlfzOWdUBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfM9OGf7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DAAC4CEF1;
	Sat, 22 Nov 2025 00:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763772970;
	bh=xcizmFTGKAM+3wGhQq/RlwVd1svgCwYfWkKqY6ABGVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfM9OGf7nRK3ekPd7FEpA1oLFzPNItM0Q6Bz7LaAIucD3buHzN/A9PPKK2uxQds0e
	 AkIOoI30rxkqZQgpn095PSP0uYYTknLWBlnX9vL9GCklgkTfvOKMM6Y6fCYThfjrsJ
	 N8st7Mb5DTjRzc3QoY2aQTcNMLZO7ZiLGrxIii+Aa4E5CUaWnQ0adNBPor/crfl2l7
	 9GA0A/46NLT1FgV2PzxEQui0dTb4KMFOhaJ4UYOZjD8OzTt2xL1DBk1PzJ9YT/KkgV
	 UTU2is7CDhElJRNwkBF2sPDcDYIdnv32TgYEnhp+urOFW5RUPZ4gjdzOsrDV+Dblcg
	 d7Pj01vlIAgtg==
Date: Fri, 21 Nov 2025 16:56:07 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, 
	bpf@vger.kernel.org, live-patching@vger.kernel.org, 
	DL Linux Open Source Team <linux-open-source@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
	andrii@kernel.org, Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: BPF fentry/fexit trampolines stall livepatch stalls transition
 due to missing ORC unwind metadata
Message-ID: <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>

On Thu, Nov 20, 2025 at 01:15:12PM +0100, Miroslav Benes wrote:
> > Impact
> > 
> > This affects production systems where:
> > - Security/observability tools use BPF fentry/fexit hooks
> > - Live kernel patching is required for security updates
> > - Kernel threads may be blocked in hooked network/storage functions
> > 
> > The livepatch transition can stall for 60+ seconds before failing, blocking
> > critical security patches.
> 
> Unfortunately yes.
> 
> > Questions for the Community
> > 
> > 1. Is this a known limitation (I assume yes) ?
> 
> Yes.
> 
> > 2. Runtime ORC generation? Could the BPF JIT generate ORC unwind entries for
> > trampolines, similar to how ftrace trampolines are handled?
> > 3. Trampoline registration? Could BPF trampolines register their address
> > ranges with the ORC unwinder to avoid the "unreliable" marking?
> > 4. Alternative unwinding? Could livepatch use an alternative unwinding method
> > when BPF trampolines are detected (e.g., frame pointers with validation)?
> > 5. Workarounds? I mention one bellow and I would be happy to hear if anyone
> > has a better idea to propose ?
> 
> There is a parallel discussion going on under sframe unwiding enablement 
> for arm64. See this subthread 
> https://lore.kernel.org/all/CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com/T/#u
> 
> I would really welcome if it is solved eventually because it seems we will 
> meet the described issue more and more often (Josh, I think this email 
> shows that it happens in practice with the existing monitoring services 
> based on BPF).

Maybe we can take advantage of the fact that BPF uses frame pointers
unconditionally, and avoid the complexity of "dynamic ORC" for now, by
just having BPF keep track of where the frame pointer is valid (after
the prologue, before the epilogue).

Something like the below (completely untested).

Andrey, can you try this patch?

---8<---

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 977ee75e047c..f610fde2d5c4 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -2,6 +2,7 @@
 #include <linux/objtool.h>
 #include <linux/module.h>
 #include <linux/sort.h>
+#include <linux/bpf.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
@@ -172,6 +173,25 @@ static struct orc_entry *orc_ftrace_find(unsigned long ip)
 }
 #endif
 
+/* Fake frame pointer entry -- used as a fallback for generated code */
+static struct orc_entry orc_fp_entry = {
+	.type		= ORC_TYPE_CALL,
+	.sp_reg		= ORC_REG_BP,
+	.sp_offset	= 16,
+	.bp_reg		= ORC_REG_PREV_SP,
+	.bp_offset	= -16,
+};
+
+static struct orc_entry *orc_bpf_find(unsigned long ip)
+{
+#ifdef CONFIG_BPF_JIT
+	if (bpf_has_frame_pointer(ip))
+		return &orc_fp_entry;
+#endif
+
+	return NULL;
+}
+
 /*
  * If we crash with IP==0, the last successfully executed instruction
  * was probably an indirect function call with a NULL function pointer,
@@ -186,15 +206,6 @@ static struct orc_entry null_orc_entry = {
 	.type = ORC_TYPE_CALL
 };
 
-/* Fake frame pointer entry -- used as a fallback for generated code */
-static struct orc_entry orc_fp_entry = {
-	.type		= ORC_TYPE_CALL,
-	.sp_reg		= ORC_REG_BP,
-	.sp_offset	= 16,
-	.bp_reg		= ORC_REG_PREV_SP,
-	.bp_offset	= -16,
-};
-
 static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
@@ -238,6 +249,11 @@ static struct orc_entry *orc_find(unsigned long ip)
 	if (orc)
 		return orc;
 
+	/* BPF lookup: */
+	orc = orc_bpf_find(ip);
+	if (orc)
+		return orc;
+
 	return orc_ftrace_find(ip);
 }
 
@@ -495,9 +511,8 @@ bool unwind_next_frame(struct unwind_state *state)
 	if (!orc) {
 		/*
 		 * As a fallback, try to assume this code uses a frame pointer.
-		 * This is useful for generated code, like BPF, which ORC
-		 * doesn't know about.  This is just a guess, so the rest of
-		 * the unwind is no longer considered reliable.
+		 * This is just a guess, so the rest of the unwind is no longer
+		 * considered reliable.
 		 */
 		orc = &orc_fp_entry;
 		state->error = true;
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

