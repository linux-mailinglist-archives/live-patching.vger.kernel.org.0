Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C671E531FAB
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiEXARN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiEXARH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:07 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77A0C74DE7;
        Mon, 23 May 2022 17:16:58 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 831E120B8964;
        Mon, 23 May 2022 17:16:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 831E120B8964
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351418;
        bh=3KNu2SqTulpI6MsZJqxj2nDgr1mSyJJSrp9yO31aXUY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IFXCPTA6/D2mLlhEwmbRiLgn3+2MF4BeYPolu/uQdlODAqJxuvl0WObdOZw9ComZ3
         b4RyDxpiQJpjqKMjoWCHrbAULt15XQZhwhhYV6Hh2YCYQ1343HOerzGwwR+Ii5Ubm3
         P9HmqW1QNCv5g6KDbqfvxHUurSknmww/CIAyirHg=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 11/20] objtool: arm64: Walk instructions and compute CFI for each instruction
Date:   Mon, 23 May 2022 19:16:28 -0500
Message-Id: <20220524001637.1707472-12-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Implement arch_initial_func_cfi_state() to initialize the CFI for a
function.

Add code to fpv_decode() to walk the instructions in every function and
compute the CFI information for each instruction.

Implement special handling for cases like jump tables.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/arm64/decode.c |  15 +++
 tools/objtool/fpv.c               | 204 ++++++++++++++++++++++++++++++
 2 files changed, 219 insertions(+)

diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index f9df8b321659..93ef7c0811f1 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -35,6 +35,21 @@ struct decode {
 
 /* --------------------- arch support functions ------------------------- */
 
+void arch_initial_func_cfi_state(struct cfi_init_state *state)
+{
+	int i;
+
+	for (i = 0; i < CFI_NUM_REGS; i++) {
+		state->regs[i].base = CFI_UNDEFINED;
+		state->regs[i].offset = 0;
+	}
+	state->regs[CFI_FP].base = CFI_CFA;
+
+	/* initial CFA (call frame address) */
+	state->cfa.base = CFI_SP;
+	state->cfa.offset = 0;
+}
+
 unsigned long arch_dest_reloc_offset(int addend)
 {
 	return addend;
diff --git a/tools/objtool/fpv.c b/tools/objtool/fpv.c
index 92ad0d0aac8e..52f613ae998f 100644
--- a/tools/objtool/fpv.c
+++ b/tools/objtool/fpv.c
@@ -13,6 +13,8 @@
 #include <objtool/insn.h>
 #include <objtool/warn.h>
 
+static bool	fill;
+
 /*
  * Find the destination instructions for all jumps.
  */
@@ -50,15 +52,217 @@ static void add_jump_destinations(struct objtool_file *file)
 	}
 }
 
+static void update_cfi_state(struct cfi_state *cfi, struct stack_op *op)
+{
+	struct cfi_reg *cfa = &cfi->cfa;
+	struct cfi_reg *regs = cfi->regs;
+
+	if (op->src.reg == CFI_SP) {
+		if (op->dest.reg == CFI_SP)
+			cfa->offset -= op->src.offset;
+		else
+			regs[CFI_FP].offset = -cfa->offset + op->src.offset;
+	} else {
+		if (op->dest.reg == CFI_SP)
+			cfa->offset = -(regs[CFI_FP].offset + op->src.offset);
+		else
+			regs[CFI_FP].offset += op->src.offset;
+	}
+
+	if (cfa->offset < -regs[CFI_FP].offset)
+		regs[CFI_FP].offset = 0;
+}
+
+static void do_stack_ops(struct instruction *insn, struct insn_state *state)
+{
+	struct stack_op *op;
+
+	list_for_each_entry(op, &insn->stack_ops, list) {
+		update_cfi_state(&state->cfi, op);
+	}
+}
+
+static void walk_code(struct objtool_file *file, struct section *sec,
+		      struct symbol *func,
+		      struct instruction *insn, struct insn_state *state)
+{
+	struct symbol *insn_func = insn->func;
+	struct instruction *dest;
+	struct cfi_state save_cfi;
+	unsigned long start, end;
+
+	for (; insn; insn = next_insn_same_sec(file, insn)) {
+
+		if (insn->func != insn_func)
+			return;
+
+		if (insn->cfi) {
+			if (fill) {
+				/* CFI is present. Nothing to fill. */
+				return;
+			}
+			if (insn->cfi->regs[CFI_FP].offset ||
+			    !state->cfi.regs[CFI_FP].offset) {
+				return;
+			}
+			/*
+			 * The new CFI contains a valid frame and the existing
+			 * CFI doesn't. Replace the existing CFI with the new
+			 * one.
+			 */
+		}
+		insn->cfi = cfi_hash_find_or_add(&state->cfi);
+		dest = insn->jump_dest;
+
+		do_stack_ops(insn, state);
+
+		switch (insn->type) {
+		case INSN_BUG:
+		case INSN_RETURN:
+		case INSN_UNRELIABLE:
+			return;
+
+		case INSN_CALL:
+		case INSN_CALL_DYNAMIC:
+			start = func->offset;
+			end = start + func->len;
+			/*
+			 * Treat intra-function calls as jumps and fall
+			 * through.
+			 */
+			if (!dest || dest->sec != sec ||
+			    dest->offset <= start || dest->offset >= end) {
+				break;
+			}
+			/* fallthrough */
+
+		case INSN_JUMP_UNCONDITIONAL:
+		case INSN_JUMP_CONDITIONAL:
+		case INSN_JUMP_DYNAMIC:
+			if (dest) {
+				save_cfi = state->cfi;
+				walk_code(file, sec, func, dest, state);
+				state->cfi = save_cfi;
+			}
+			if (insn->type == INSN_JUMP_UNCONDITIONAL ||
+			    insn->type == INSN_JUMP_DYNAMIC) {
+				return;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
+static void walk_function(struct objtool_file *file, struct section *sec,
+			  struct symbol *func)
+{
+	struct instruction *insn = find_insn(file, sec, func->offset);
+	struct insn_state state;
+
+	init_insn_state(&state, sec);
+	set_func_state(&state.cfi);
+
+	walk_code(file, sec, func, insn, &state);
+}
+
+/*
+ * This function addresses cases like jump tables where there is an array
+ * of unconditional branches. The normal walk would not have visited these
+ * instructions and established CFIs for them. Find those instructions. For
+ * each such instruction, copy the CFI from the branch instruction and
+ * propagate it down.
+ */
+static void fill_function(struct objtool_file *file, struct section *sec,
+			  struct symbol *func)
+{
+	struct instruction *insn, *prev;
+	struct insn_state state;
+
+	func_for_each_insn(file, func, insn) {
+
+		if (insn->cfi) {
+			/* Instruction already has a CFI. */
+			continue;
+		}
+
+		prev = list_prev_entry(insn, list);
+		if (!prev || !prev->cfi) {
+			/*
+			 * Previous instruction does not have a CFI that can
+			 * be used for this instruction.
+			 */
+			continue;
+		}
+
+		if (prev->type != INSN_JUMP_UNCONDITIONAL &&
+		    prev->type != INSN_JUMP_DYNAMIC) {
+			/* Only copy CFI from unconditional branches. */
+			continue;
+		}
+
+		/*
+		 * Propagate the CFI to all the instructions that can be
+		 * visited from the current instruction that don't already
+		 * have a CFI.
+		 */
+		state.cfi = *prev->cfi;
+		walk_code(file, insn->sec, insn->func, insn, &state);
+	}
+}
+
+static void walk_section(struct objtool_file *file, struct section *sec)
+{
+	struct symbol *func;
+
+	list_for_each_entry(func, &sec->symbol_list, list) {
+
+		if (func->type != STT_FUNC || !func->len ||
+		    func->pfunc != func || func->alias != func) {
+			/* No CFI generated for this function. */
+			continue;
+		}
+
+		if (!fill)
+			walk_function(file, sec, func);
+		else
+			fill_function(file, sec, func);
+	}
+}
+
+static void walk_sections(struct objtool_file *file)
+{
+	struct section *sec;
+
+	for_each_sec(file, sec) {
+		if (sec->sh.sh_flags & SHF_EXECINSTR)
+			walk_section(file, sec);
+	}
+}
+
 int fpv_decode(struct objtool_file *file)
 {
 	int ret;
 
+	arch_initial_func_cfi_state(&initial_func_cfi);
+
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+		return -1;
+
 	ret = decode_instructions(file);
 	if (ret)
 		return ret;
 
 	add_jump_destinations(file);
 
+	if (!list_empty(&file->insn_list)) {
+		fill = false;
+		walk_sections(file);
+		fill = true;
+		walk_sections(file);
+	}
+
 	return 0;
 }
-- 
2.25.1

