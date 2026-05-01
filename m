Return-Path: <live-patching+bounces-2664-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJOcH0wp9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2664-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:17:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFED4AA303
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 00F50304EA54
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95986377575;
	Fri,  1 May 2026 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmiY2UaY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCC3377009;
	Fri,  1 May 2026 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608553; cv=none; b=eWF8xtrxbkuZMvYLnyCLvdMCDAxKR9zf0HrF6YBBar++4tcElCIRf64sZpAu7lUSPugvXUm63lWj8EdRhPpSYlwPkYcShrMmUzF31+kNcCSA1F4SP4YWW4CqC70a6JraX18Y6o3pAmp0ZqU6zuTTvIajPv/s3kuhN3+Mpa5FPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608553; c=relaxed/simple;
	bh=P0MaWoXei4QXxRNgMPz3urNwgaUfcNbE/81k0UNZncg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ+Qzk47Jc6ShbNDyvgcSQjL9cJZ68TbNs+shNO9RfysLQltKA1buYN4YhRr75T8jDu46rA9QsQUIkI9wxwyjwUi2UJ1Yg38B0pWCHsq1ozbXMrZP7JM9gukEsr1IAO3Q/9xCtdLBgphvHlf9fJrIAlnNoXNGbpLfGVZHPA7JRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmiY2UaY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0673DC2BCB8;
	Fri,  1 May 2026 04:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608553;
	bh=P0MaWoXei4QXxRNgMPz3urNwgaUfcNbE/81k0UNZncg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmiY2UaYX0Ljq0p8osaiJNLWP/UlHrpx23wlnj6fOKxsvYDam0vlc+SH/6HN2cvoR
	 A+podxTPUNbgupsfPWHw1av0ivplL+MC718VFKGldVSCHM7H9i+RL9zZbWlcrFaQaJ
	 Og5q+eJpY7scacUHFeQHFHPjWpnI0onrWGjg7yzqVYhpaeWVTeXO6TgSEXZ8tJ/VWg
	 kWAytOW3UofKIMhqqy1CMP66fmnOvVaf5Be8KWJJcNZJ47svXWl/982PrbBTdeJ5EQ
	 gWaSTgxoOuCDnKJUjUqckfaBCAZ4CETBVTY810PMjVxbz3pczu168gda8nDjH8oKZc
	 O0MHp3ixHCrPQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 48/53] objtool: Add insn_sym() helper
Date: Thu, 30 Apr 2026 21:08:36 -0700
Message-ID: <52633c62366f87d9b78ebd77873a08b9ac6d31c8.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AFED4AA303
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2664-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Alternative replacement instructions awkwardly have insn->sym set to the
function they get patched to rather than the symbol (or rather lack
thereof) they belong to in the file.

This makes it difficult to know where a given instruction actually
lives.

Add a new insn_sym() helper which preserves the existing semantic of
insn->sym.  Rename insn->sym to insn->_sym, which contains the actual
ELF binary symbol (or NULL, for alternative replacements) an instruction
lives in.

The private insn->_sym value will be needed for a subsequent patch.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                 | 31 ++++++++++++---------------
 tools/objtool/disas.c                 | 22 +++++++++----------
 tools/objtool/include/objtool/check.h | 20 +++++++++++++++--
 tools/objtool/include/objtool/warn.h  |  6 +++---
 tools/objtool/trace.c                 |  8 +++----
 5 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ae047be919c5..410061aeed26 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -495,7 +495,7 @@ static int decode_instructions(struct objtool_file *file)
 			}
 
 			sym_for_each_insn(file, func, insn) {
-				insn->sym = func;
+				insn->_sym = func;
 				if (is_func_sym(func) &&
 				    insn->type == INSN_ENDBR &&
 				    list_empty(&insn->call_node)) {
@@ -859,15 +859,14 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 	list_for_each_entry(insn, &file->endbr_list, call_node) {
 
 		int *site = (int *)sec->data->d_buf + idx;
-		struct symbol *sym = insn->sym;
+		struct symbol *func = insn_func(insn);
 		*site = 0;
 
-		if (opts.module && sym && is_func_sym(sym) &&
-		    insn->offset == sym->offset &&
-		    (!strcmp(sym->name, "init_module") ||
-		     !strcmp(sym->name, "cleanup_module"))) {
+		if (opts.module && func && insn->offset == func->offset &&
+		    (!strcmp(func->name, "init_module") ||
+		     !strcmp(func->name, "cleanup_module"))) {
 			ERROR("%s(): Magic init_module() function name is deprecated, use module_init(fn) instead",
-			      sym->name);
+			      func->name);
 			return -1;
 		}
 
@@ -1581,7 +1580,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		}
 
 		if (!dest_sym || is_sec_sym(dest_sym)) {
-			dest_sym = dest_insn->sym;
+			dest_sym = insn_sym(dest_insn);
 			if (!dest_sym)
 				goto set_jump_dest;
 		}
@@ -1597,7 +1596,7 @@ static int add_jump_destinations(struct objtool_file *file)
 			continue;
 		}
 
-		if (!insn->sym || insn->sym->pfunc == dest_sym->pfunc)
+		if (!insn_sym(insn) || insn_sym(insn)->pfunc == dest_sym->pfunc)
 			goto set_jump_dest;
 
 		/*
@@ -1770,7 +1769,6 @@ static int handle_group_alt(struct objtool_file *file,
 		nop->offset = special_alt->new_off + special_alt->new_len;
 		nop->len = special_alt->orig_len - special_alt->new_len;
 		nop->type = INSN_NOP;
-		nop->sym = orig_insn->sym;
 		nop->alt_group = new_alt_group;
 		nop->fake = 1;
 	}
@@ -1789,7 +1787,6 @@ static int handle_group_alt(struct objtool_file *file,
 
 		last_new_insn = insn;
 
-		insn->sym = orig_insn->sym;
 		insn->alt_group = new_alt_group;
 
 		/*
@@ -2432,12 +2429,12 @@ static int __annotate_late(struct objtool_file *file, int type, struct instructi
 		break;
 
 	case ANNOTYPE_NOCFI:
-		sym = insn->sym;
+		sym = insn_sym(insn);
 		if (!sym) {
 			ERROR_INSN(insn, "dodgy NOCFI annotation");
 			return -1;
 		}
-		insn->sym->nocfi = 1;
+		insn_sym(insn)->nocfi = 1;
 		break;
 
 	default:
@@ -2538,7 +2535,7 @@ static void mark_holes(struct objtool_file *file)
 	 * favour of a regular symbol, but leaves the code in place.
 	 */
 	for_each_insn(file, insn) {
-		if (insn->sym || !find_symbol_hole_containing(insn->sec, insn->offset)) {
+		if (insn_sym(insn) || !find_symbol_hole_containing(insn->sec, insn->offset)) {
 			in_hole = false;
 			continue;
 		}
@@ -2982,7 +2979,7 @@ static int update_cfi_state(struct instruction *insn,
 			}
 
 			if (op->dest.reg == CFI_BP && op->src.reg == CFI_SP &&
-			    insn->sym->frame_pointer) {
+			    insn_sym(insn)->frame_pointer) {
 				/* addi.d fp,sp,imm on LoongArch */
 				if (cfa->base == CFI_SP && cfa->offset == op->src.offset) {
 					cfa->base = CFI_BP;
@@ -2994,7 +2991,7 @@ static int update_cfi_state(struct instruction *insn,
 			if (op->dest.reg == CFI_SP && op->src.reg == CFI_BP) {
 				/* addi.d sp,fp,imm on LoongArch */
 				if (cfa->base == CFI_BP && cfa->offset == 0) {
-					if (insn->sym->frame_pointer) {
+					if (insn_sym(insn)->frame_pointer) {
 						cfa->base = CFI_SP;
 						cfa->offset = -op->src.offset;
 					}
@@ -4171,7 +4168,7 @@ static int validate_retpoline(struct objtool_file *file)
 	 * broken.
 	 */
 	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
-		struct symbol *sym = insn->sym;
+		struct symbol *sym = insn_sym(insn);
 
 		if (sym && (is_notype_sym(sym) ||
 			    is_func_sym(sym)) && !sym->nocfi) {
diff --git a/tools/objtool/disas.c b/tools/objtool/disas.c
index 59090234af19..e6a54a83605c 100644
--- a/tools/objtool/disas.c
+++ b/tools/objtool/disas.c
@@ -210,7 +210,7 @@ static bool disas_print_addr_alt(bfd_vma addr, struct disassemble_info *dinfo)
 	offset = addr - alt_group->first_insn->offset;
 
 	addr = orig_first_insn->offset + offset;
-	sym = orig_first_insn->sym;
+	sym = insn_sym(orig_first_insn);
 
 	disas_print_addr_sym(orig_first_insn->sec, sym, addr, dinfo);
 
@@ -222,15 +222,13 @@ static void disas_print_addr_noreloc(bfd_vma addr,
 {
 	struct disas_context *dctx = dinfo->application_data;
 	struct instruction *insn = dctx->insn;
-	struct symbol *sym = NULL;
+	struct symbol *sym = insn_sym(insn);
 
 	if (disas_print_addr_alt(addr, dinfo))
 		return;
 
-	if (insn->sym && addr >= insn->sym->offset &&
-	    addr < insn->sym->offset + insn->sym->len) {
-		sym = insn->sym;
-	}
+	if (sym && (addr < sym->offset || addr >= sym->offset + sym->len))
+		sym = NULL;
 
 	disas_print_addr_sym(insn->sec, sym, addr, dinfo);
 }
@@ -291,9 +289,9 @@ static void disas_print_address(bfd_vma addr, struct disassemble_info *dinfo)
 	 * up. So check it first.
 	 */
 	jump_dest = insn->jump_dest;
-	if (jump_dest && jump_dest->sym && jump_dest->offset == addr) {
+	if (jump_dest && insn_sym(jump_dest) && jump_dest->offset == addr) {
 		if (!disas_print_addr_alt(addr, dinfo))
-			disas_print_addr_sym(jump_dest->sec, jump_dest->sym,
+			disas_print_addr_sym(jump_dest->sec, insn_sym(jump_dest),
 					     addr, dinfo);
 		return;
 	}
@@ -768,8 +766,8 @@ static int disas_alt_jump(struct disas_alt *dalt)
 		if (orig_insn->len == 5)
 			suffix[0] = 'q';
 		str = strfmt("jmp%-3s %lx <%s+0x%lx>", suffix,
-			     dest_insn->offset, dest_insn->sym->name,
-			     dest_insn->offset - dest_insn->sym->offset);
+			     dest_insn->offset, insn_sym(dest_insn)->name,
+			     dest_insn->offset - insn_sym(dest_insn)->offset);
 		nops = 0;
 	} else {
 		str = strfmt("nop%d", orig_insn->len);
@@ -794,8 +792,8 @@ static int disas_alt_extable(struct disas_alt *dalt)
 
 	alt_insn = dalt->alt->insn;
 	str = strfmt("resume at 0x%lx <%s+0x%lx>",
-		     alt_insn->offset, alt_insn->sym->name,
-		     alt_insn->offset - alt_insn->sym->offset);
+		     alt_insn->offset, insn_sym(alt_insn)->name,
+		     alt_insn->offset - insn_sym(alt_insn)->offset);
 	if (!str)
 		return -1;
 
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index eea64728d39b..fe08205d8eb1 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -94,14 +94,30 @@ struct instruction {
 		};
 	};
 	struct alternative *alts;
-	struct symbol *sym;
+	struct symbol *_sym;
 	struct stack_op *stack_ops;
 	struct cfi_state *cfi;
 };
 
+/*
+ * Return the symbol associated with an instruction.  For alternative
+ * replacements, return the symbol of the original code being replaced rather
+ * than NULL.  insn->_sym reflects the actual location in the ELF file.
+ */
+static inline struct symbol *insn_sym(struct instruction *insn)
+{
+	struct symbol *sym = insn->_sym;
+
+	if ((!sym || !is_func_sym(sym)) &&
+	    insn->alt_group && insn->alt_group->orig_group)
+		sym = insn->alt_group->orig_group->first_insn->_sym;
+
+	return sym;
+}
+
 static inline struct symbol *insn_func(struct instruction *insn)
 {
-	struct symbol *sym = insn->sym;
+	struct symbol *sym = insn_sym(insn);
 
 	if (sym && sym->type != STT_FUNC)
 		sym = NULL;
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index a9936d60980c..870e147f3a56 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -77,13 +77,13 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define WARN_INSN(insn, format, ...)					\
 ({									\
 	struct instruction *_insn = (insn);				\
-	if (!_insn->sym || !_insn->sym->warned)	{			\
+	if (!insn_sym(_insn) || !insn_sym(_insn)->warned)	{	\
 		WARN_FUNC(_insn->sec, _insn->offset, format,		\
 			  ##__VA_ARGS__);				\
 		BT_INSN(_insn, "");					\
 	}								\
-	if (_insn->sym)							\
-		_insn->sym->warned = 1;					\
+	if (insn_sym(_insn))						\
+		insn_sym(_insn)->warned = 1;				\
 })
 
 #define BT_INSN(insn, format, ...)				\
diff --git a/tools/objtool/trace.c b/tools/objtool/trace.c
index 5dec44dab781..61c6aa302bc3 100644
--- a/tools/objtool/trace.c
+++ b/tools/objtool/trace.c
@@ -169,8 +169,8 @@ void trace_alt_begin(struct instruction *orig_insn, struct alternative *alt,
 		 */
 		TRACE_ALT_INFO_NOADDR(orig_insn, "/ ", "%s for instruction at 0x%lx <%s+0x%lx>",
 				      alt_name,
-				      orig_insn->offset, orig_insn->sym->name,
-				      orig_insn->offset - orig_insn->sym->offset);
+				      orig_insn->offset, insn_sym(orig_insn)->name,
+				      orig_insn->offset - insn_sym(orig_insn)->offset);
 	} else {
 		TRACE_ALT_INFO_NOADDR(orig_insn, "/ ", "%s", alt_name);
 	}
@@ -185,8 +185,8 @@ void trace_alt_begin(struct instruction *orig_insn, struct alternative *alt,
 		if (orig_insn->type == INSN_NOP) {
 			suffix[0] = (orig_insn->len == 5) ? 'q' : '\0';
 			TRACE_ADDR(orig_insn, "jmp%-3s %lx <%s+0x%lx>", suffix,
-				   alt_insn->offset, alt_insn->sym->name,
-				   alt_insn->offset - alt_insn->sym->offset);
+				   alt_insn->offset, insn_sym(alt_insn)->name,
+				   alt_insn->offset - insn_sym(alt_insn)->offset);
 		} else {
 			TRACE_ADDR(orig_insn, "nop%d", orig_insn->len);
 			trace_depth--;
-- 
2.53.0


