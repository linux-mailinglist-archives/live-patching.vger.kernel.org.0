Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2940A68769C
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjBBHnS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjBBHmx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:53 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0FFD84952;
        Wed,  1 Feb 2023 23:42:38 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A4A8720861F6;
        Wed,  1 Feb 2023 23:42:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A4A8720861F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323758;
        bh=ZReeOzoTrtsb5LMSAI87dQm76FTp/hJZoPEJyZX88wA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LoHhNNqfKNphpcEW3Qd8TKXIdVNy37/Cs3LLnduT4IgGh3B7pNL/KWbIOyStRmTZi
         U94SYC1JoUa9b8XD8x6HHQygE5AhnhZWr747OMUR2UApiZ0yyL8dQr/Y7FXJmZa0KX
         BHDkLPunEUG48UuAFm/Z0i0FAT5kmcaKOsQ5IFE4=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 13/22] objtool: arm64: Walk instructions and compute CFI for each instruction
Date:   Thu,  2 Feb 2023 01:40:27 -0600
Message-Id: <20230202074036.507249-14-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Implement arch_initial_func_cfi_state() to initialize the CFI for a
function.

Add code to check() in dcheck.c to walk the instructions in every function
and compute the CFI information for each instruction.

Perform the following checks to validate the CFI:

	- Make sure that there is exactly one frame pointer prolog for
	  an epilog.

	- Make sure that the frame pointer register is initialized to
	  the location at which the previous frame pointer is stored
	  on the stack.

	- Make sure that the frame pointer is restored in the epilog
	  from the same location on stack where it was saved.

	- Make sure that the return address is restored in the epilog
	  from the same location on stack where it was saved.

	- Make sure that the frame pointer and return address are saved
	  on the stack adjacent to each other in the correct order as
	  specified in the ABI.

	- If an instruction can be reached via two different code paths,
	  make sure that the CFIs computed from traversing each path match
	  for the instruction.

	- Every time the frame pointer or stack offset is changed, make sure
	  the offsets have legal values.

insn_cfi_match() is used to compare CFIs to see if they match. When there
is a mismatch, the function emits error messages. With static checking,
these errors result in failure. With dynamic checking, these errors
only resulting in marking those instructions as unreliable for unwind.
In the latter case, suppress the warning messages.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/arm64/decode.c    |  15 ++
 tools/objtool/check.c                |   2 +-
 tools/objtool/dcheck.c               | 287 +++++++++++++++++++++++++++
 tools/objtool/include/objtool/insn.h |   3 +-
 tools/objtool/insn.c                 |  39 ++--
 5 files changed, 329 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index 81653ed3c323..f723be80c09a 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -22,6 +22,21 @@
 
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
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d14a2b7b8b37..94efe94a566e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2863,7 +2863,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 
 		visited = VISITED_BRANCH << state.uaccess;
 		if (insn->visited & VISITED_BRANCH_MASK) {
-			if (!insn->hint && !insn_cfi_match(insn, &state.cfi))
+			if (!insn->hint && !insn_cfi_match(insn, &state.cfi, true))
 				return 1;
 
 			if (insn->visited & visited)
diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
index eb806a032a32..8b78cb608528 100644
--- a/tools/objtool/dcheck.c
+++ b/tools/objtool/dcheck.c
@@ -49,6 +49,283 @@ static void add_jump_destinations(struct objtool_file *file)
 	}
 }
 
+static bool update_cfi_state(struct cfi_state *cfi, struct stack_op *op)
+{
+	struct cfi_reg *cfa = &cfi->cfa;
+	struct cfi_reg *fp_reg = &cfi->regs[CFI_FP];
+	struct cfi_reg *fp_val = &cfi->vals[CFI_FP];
+	struct cfi_reg *ra_val = &cfi->vals[CFI_RA];
+	enum op_src_type src_type = op->src.type;
+	enum op_dest_type dest_type = op->dest.type;
+	unsigned char dest_reg = op->dest.reg;
+	int offset;
+
+	if (src_type == OP_SRC_ADD && dest_type == OP_DEST_REG) {
+
+		if (op->src.reg == CFI_SP) {
+			if (op->dest.reg == CFI_SP) {
+				cfa->offset -= op->src.offset;
+			} else {
+				if (fp_reg->offset) {
+					/* FP is already set. */
+					return false;
+				}
+				fp_reg->offset = -cfa->offset + op->src.offset;
+				if (fp_reg->offset != fp_val->offset) {
+					/*
+					 * FP does not match the location
+					 * where FP is stored on stack.
+					 */
+					return false;
+				}
+			}
+		} else {
+			if (op->dest.reg == CFI_SP) {
+				cfa->offset =
+					-(fp_reg->offset + op->src.offset);
+			} else {
+				/* Setting the FP from itself is unreliable. */
+				return false;
+			}
+		}
+		/*
+		 * When the stack pointer is restored in the frame pointer
+		 * epilog, forget where the FP and RA were stored.
+		 */
+		if (cfa->offset < -fp_val->offset)
+			fp_val->offset = 0;
+		if (cfa->offset < -ra_val->offset)
+			ra_val->offset = 0;
+		goto out;
+	}
+
+	if (src_type == OP_SRC_REG_INDIRECT && dest_type == OP_DEST_REG) {
+		offset = -cfa->offset + op->src.offset;
+		if (dest_reg == CFI_FP) {
+			if (!fp_val->offset || fp_val->offset != offset) {
+				/*
+				 * Loading the FP from a different place than
+				 * where it is stored.
+				 */
+				return false;
+			}
+			if (!ra_val->offset ||
+			    (ra_val->offset - fp_val->offset) != 8) {
+				/* FP and RA must be adjacent in a frame. */
+				return false;
+			}
+			fp_reg->offset = 0;
+		}
+		goto out;
+	}
+
+	if (src_type == OP_SRC_REG && dest_type == OP_DEST_REG_INDIRECT) {
+		offset = -cfa->offset + op->dest.offset;
+		if (dest_reg == CFI_FP) {
+			/* Record where the FP is stored on the stack. */
+			fp_val->offset = offset;
+		} else {
+			/* Record where the RA is stored on the stack. */
+			if (fp_val->offset && (offset - fp_val->offset) == 8)
+				ra_val->offset = offset;
+		}
+		goto out;
+	}
+	return false;
+out:
+	if (cfa->offset < 0 || fp_reg->offset > 0 ||
+	    fp_val->offset > 0 || ra_val->offset > 0) {
+		/* Unexpected SP and FP offset values. */
+		return false;
+	}
+	return true;
+}
+
+static bool do_stack_ops(struct instruction *insn, struct insn_state *state)
+{
+	struct stack_op *op;
+
+	list_for_each_entry(op, &insn->stack_ops, list) {
+		if (!update_cfi_state(&state->cfi, op))
+			return false;
+	}
+	return true;
+}
+
+static bool validate_branch(struct objtool_file *file, struct section *sec,
+			    struct symbol *func, struct instruction *insn,
+			    struct insn_state *state)
+{
+	struct symbol *insn_func = insn->func;
+	struct instruction *dest;
+	struct cfi_state save_cfi;
+	struct cfi_reg *cfa;
+	struct cfi_reg *regs;
+	unsigned long start, end;
+
+	for (; insn; insn = next_insn_same_sec(file, insn)) {
+
+		if (insn->func != insn_func)
+			return true;
+
+		if (insn->cfi)
+			return insn_cfi_match(insn, &state->cfi, false);
+
+		insn->cfi = cfi_hash_find_or_add(&state->cfi);
+		dest = insn->jump_dest;
+
+		if (!do_stack_ops(insn, state))
+			return false;
+
+		switch (insn->type) {
+		case INSN_BUG:
+			return true;
+
+		case INSN_UNRELIABLE:
+			return false;
+
+		case INSN_RETURN:
+			cfa = &state->cfi.cfa;
+			regs = state->cfi.regs;
+			if (cfa->offset || regs[CFI_FP].offset) {
+				/* SP and FP offsets should be 0 on return. */
+				return false;
+			}
+			return true;
+
+		case INSN_CALL:
+		case INSN_CALL_DYNAMIC:
+			start = func->offset;
+			end = start + func->len;
+			/* Treat intra-function calls as jumps. */
+			if (!dest || dest->sec != sec ||
+			    dest->offset <= start || dest->offset >= end) {
+				break;
+			}
+
+		case INSN_JUMP_UNCONDITIONAL:
+		case INSN_JUMP_CONDITIONAL:
+		case INSN_JUMP_DYNAMIC:
+			if (dest) {
+				save_cfi = state->cfi;
+				if (!validate_branch(file, sec, func, dest,
+						     state)) {
+					return false;
+				}
+				state->cfi = save_cfi;
+			}
+			if (insn->type == INSN_JUMP_UNCONDITIONAL ||
+			    insn->type == INSN_JUMP_DYNAMIC) {
+				return true;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+	return true;
+}
+
+static bool walk_reachable(struct objtool_file *file, struct section *sec,
+			   struct symbol *func)
+{
+	struct instruction *insn = find_insn(file, sec, func->offset);
+	struct insn_state state;
+
+	func_for_each_insn(file, func, insn) {
+
+		if (insn->offset != func->offset &&
+		    (insn->type != INSN_START || insn->cfi)) {
+			continue;
+		}
+
+		init_insn_state(file, &state, sec);
+		set_func_state(&state.cfi);
+
+		if (!validate_branch(file, sec, func, insn, &state))
+			return false;
+	}
+	return true;
+}
+
+static void remove_cfi(struct objtool_file *file, struct symbol *func)
+{
+	struct instruction *insn;
+
+	func_for_each_insn(file, func, insn) {
+		insn->cfi = NULL;
+	}
+}
+
+/*
+ * Instructions that were not visited by walk_reachable() would not have a
+ * CFI. Try to initialize their CFI. For instance, there could be a table of
+ * unconditional branches like for a switch statement. Or, code can be patched
+ * by the kernel at runtime. After patching, some of the previously unreachable
+ * code may become reachable.
+ *
+ * This follows the same pattern as the DWARF info generated by the compiler.
+ */
+static bool walk_unreachable(struct objtool_file *file, struct section *sec,
+			     struct symbol *func)
+{
+	struct instruction *insn, *prev;
+	struct insn_state state;
+
+	func_for_each_insn(file, func, insn) {
+
+		if (insn->cfi)
+			continue;
+
+		prev = list_prev_entry(insn, list);
+		if (!prev || prev->func != insn->func || !prev->cfi)
+			continue;
+
+		if (prev->type != INSN_JUMP_UNCONDITIONAL &&
+		    prev->type != INSN_JUMP_DYNAMIC &&
+		    prev->type != INSN_BUG) {
+			continue;
+		}
+
+		/* Propagate the CFI. */
+		state.cfi = *prev->cfi;
+		if (!validate_branch(file, sec, func, insn, &state))
+			return false;
+	}
+	return true;
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
+		if (!walk_reachable(file, sec, func) ||
+		    !walk_unreachable(file, sec, func)) {
+			remove_cfi(file, func);
+			continue;
+		}
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
 int check(struct objtool_file *file)
 {
 	int ret;
@@ -56,11 +333,21 @@ int check(struct objtool_file *file)
 	if (!opts.stackval)
 		return 1;
 
+	arch_initial_func_cfi_state(&initial_func_cfi);
+
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+		return -1;
+
 	ret = decode_instructions(file);
 	if (ret)
 		return ret;
 
 	add_jump_destinations(file);
 
+	if (list_empty(&file->insn_list))
+		return 0;
+
+	walk_sections(file);
+
 	return 0;
 }
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index cfd1ae7e2e8e..3a43a591b318 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -84,7 +84,8 @@ struct instruction *next_insn_same_sec(struct objtool_file *file,
 struct instruction *next_insn_same_func(struct objtool_file *file,
 					struct instruction *insn);
 struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
-bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
+bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2,
+		    bool print);
 bool same_function(struct instruction *insn1, struct instruction *insn2);
 bool is_first_func_insn(struct objtool_file *file, struct instruction *insn);
 
diff --git a/tools/objtool/insn.c b/tools/objtool/insn.c
index e570b46ad39e..be3617d55aea 100644
--- a/tools/objtool/insn.c
+++ b/tools/objtool/insn.c
@@ -135,7 +135,8 @@ bool is_first_func_insn(struct objtool_file *file, struct instruction *insn)
 	return false;
 }
 
-bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
+bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2,
+		    bool print)
 {
 	struct cfi_state *cfi1 = insn->cfi;
 	int i;
@@ -147,10 +148,12 @@ bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 
 	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
 
-		WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
-			  insn->sec, insn->offset,
-			  cfi1->cfa.base, cfi1->cfa.offset,
-			  cfi2->cfa.base, cfi2->cfa.offset);
+		if (print) {
+			WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
+				  insn->sec, insn->offset,
+				  cfi1->cfa.base, cfi1->cfa.offset,
+				  cfi2->cfa.base, cfi2->cfa.offset);
+		}
 
 	} else if (memcmp(&cfi1->regs, &cfi2->regs, sizeof(cfi1->regs))) {
 		for (i = 0; i < CFI_NUM_REGS; i++) {
@@ -158,26 +161,32 @@ bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 				    sizeof(struct cfi_reg)))
 				continue;
 
-			WARN_FUNC("stack state mismatch: reg1[%d]=%d%+d reg2[%d]=%d%+d",
-				  insn->sec, insn->offset,
-				  i, cfi1->regs[i].base, cfi1->regs[i].offset,
-				  i, cfi2->regs[i].base, cfi2->regs[i].offset);
+			if (print) {
+				WARN_FUNC("stack state mismatch: reg1[%d]=%d%+d reg2[%d]=%d%+d",
+					  insn->sec, insn->offset,
+					  i, cfi1->regs[i].base, cfi1->regs[i].offset,
+					  i, cfi2->regs[i].base, cfi2->regs[i].offset);
+			}
 			break;
 		}
 
 	} else if (cfi1->type != cfi2->type) {
 
-		WARN_FUNC("stack state mismatch: type1=%d type2=%d",
-			  insn->sec, insn->offset, cfi1->type, cfi2->type);
+		if (print) {
+			WARN_FUNC("stack state mismatch: type1=%d type2=%d",
+				  insn->sec, insn->offset, cfi1->type, cfi2->type);
+		}
 
 	} else if (cfi1->drap != cfi2->drap ||
 		   (cfi1->drap && cfi1->drap_reg != cfi2->drap_reg) ||
 		   (cfi1->drap && cfi1->drap_offset != cfi2->drap_offset)) {
 
-		WARN_FUNC("stack state mismatch: drap1=%d(%d,%d) drap2=%d(%d,%d)",
-			  insn->sec, insn->offset,
-			  cfi1->drap, cfi1->drap_reg, cfi1->drap_offset,
-			  cfi2->drap, cfi2->drap_reg, cfi2->drap_offset);
+		if (print) {
+			WARN_FUNC("stack state mismatch: drap1=%d(%d,%d) drap2=%d(%d,%d)",
+				  insn->sec, insn->offset,
+				  cfi1->drap, cfi1->drap_reg, cfi1->drap_offset,
+				  cfi2->drap, cfi2->drap_reg, cfi2->drap_offset);
+		}
 
 	} else
 		return true;
-- 
2.25.1

