Return-Path: <live-patching+bounces-550-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B77796928B
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 491A8B22439
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2781E1D4600;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQdfHLi8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14EB1D04B8;
	Tue,  3 Sep 2024 04:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336038; cv=none; b=PF62CkMgRXOJZt5An+PzWYAGiS4GD0YsvpGTOm2rgmLxq3QcPh6Wc8o9jhz0JxfG4wBfS6c/W8qP5OQp8HSYpNwCsL0wQdrGrqVDKTKZajyr0FntA79YN0uevoisgFQTFb3WacTc7y+2I8IGtdiCv4DrzgPAIQQCu2h6PCDqHO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336038; c=relaxed/simple;
	bh=lB8wZ30oA2Po8K7j/kcuRjyphLFRSY/xnULSUimRWRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvims/RrxEugGyw5dd6V6QTmuWqO0q3C/Y/HYRJ5vRVbbffW+CoUYoju0Ewg2QT1VjLIqq4xUlwCceOfhzK1BkQLsKMqVLwLsg0SFwOrhlkipYo0jXy7XRyeF1pobq1IcWRVWer3TTgT+4hnCRc722nmwte2XLcXddk8UG94bjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQdfHLi8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF87C4CEC5;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336037;
	bh=lB8wZ30oA2Po8K7j/kcuRjyphLFRSY/xnULSUimRWRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQdfHLi80JpLSICdux80JtelpMIAB7iNtakyXP3pXQuCayOp3EP/CLbm0QYdzSu4+
	 78W6twAs6WRH2mEThvdW1O1l89zBXeeQdpHST6mFQ0/FuaM50eSwhAYbDk0ZYg5HQD
	 AFbi2yQFH8jCkOjElAzSE8Zrb2nQGNKdxAs71SqlkgYxCXW9AXMBpZf8p32Cobh1wl
	 d3Bi022B8Iuy+pqJl8mAf80ILL73MuIVH/dgcNIl35OCuqTQf5iCaE5M8dEJk1S3lj
	 V7mWqbMUGR+IWQK1f33NLKmNm88wCXSUAPer28n6MewP/a5YCd7AAmc1gmBPfo2rwf
	 2lG5ShGQ4FEBg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 16/31] objtool: Simplify fatal error handling
Date: Mon,  2 Sep 2024 20:59:59 -0700
Message-ID: <50a3714d81376d61d5a8b8297c9016f8a0ede519.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For fatal errors, exit right away instead of passing the error back.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/orc.c      |  30 +-
 tools/objtool/arch/x86/decode.c         |  40 +-
 tools/objtool/arch/x86/orc.c            |  27 +-
 tools/objtool/builtin-check.c           |  63 +-
 tools/objtool/check.c                   | 836 ++++++++----------------
 tools/objtool/elf.c                     | 507 +++++---------
 tools/objtool/include/objtool/elf.h     |   8 +-
 tools/objtool/include/objtool/orc.h     |  10 +-
 tools/objtool/include/objtool/special.h |   2 +-
 tools/objtool/include/objtool/warn.h    |  42 +-
 tools/objtool/objtool.c                 |  59 +-
 tools/objtool/orc_dump.c                |  96 +--
 tools/objtool/orc_gen.c                 |  40 +-
 tools/objtool/special.c                 |  56 +-
 tools/objtool/weak.c                    |   2 +-
 15 files changed, 625 insertions(+), 1193 deletions(-)

diff --git a/tools/objtool/arch/loongarch/orc.c b/tools/objtool/arch/loongarch/orc.c
index 873536d009d9..deb3b85e2e81 100644
--- a/tools/objtool/arch/loongarch/orc.c
+++ b/tools/objtool/arch/loongarch/orc.c
@@ -7,7 +7,7 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
+void init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
 	struct cfi_reg *fp = &cfi->regs[CFI_FP];
 	struct cfi_reg *ra = &cfi->regs[CFI_RA];
@@ -21,16 +21,16 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		 * STACK_FRAME_NON_STANDARD functions.
 		 */
 		orc->type = ORC_TYPE_UNDEFINED;
-		return 0;
+		return;
 	}
 
 	switch (cfi->type) {
 	case UNWIND_HINT_TYPE_UNDEFINED:
 		orc->type = ORC_TYPE_UNDEFINED;
-		return 0;
+		return;
 	case UNWIND_HINT_TYPE_END_OF_STACK:
 		orc->type = ORC_TYPE_END_OF_STACK;
-		return 0;
+		return;
 	case UNWIND_HINT_TYPE_CALL:
 		orc->type = ORC_TYPE_CALL;
 		break;
@@ -41,8 +41,7 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->type = ORC_TYPE_REGS_PARTIAL;
 		break;
 	default:
-		WARN_INSN(insn, "unknown unwind hint type %d", cfi->type);
-		return -1;
+		ERROR_INSN(insn, "unknown unwind hint type %d", cfi->type);
 	}
 
 	orc->signal = cfi->signal;
@@ -55,8 +54,7 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->sp_reg = ORC_REG_FP;
 		break;
 	default:
-		WARN_INSN(insn, "unknown CFA base reg %d", cfi->cfa.base);
-		return -1;
+		ERROR(insn, "unknown CFA base reg %d", cfi->cfa.base);
 	}
 
 	switch (fp->base) {
@@ -72,8 +70,7 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->fp_reg = ORC_REG_FP;
 		break;
 	default:
-		WARN_INSN(insn, "unknown FP base reg %d", fp->base);
-		return -1;
+		ERROR_INSN(insn, "unknown FP base reg %d", fp->base);
 	}
 
 	switch (ra->base) {
@@ -89,16 +86,13 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->ra_reg = ORC_REG_FP;
 		break;
 	default:
-		WARN_INSN(insn, "unknown RA base reg %d", ra->base);
-		return -1;
+		ERROR_INSN(insn, "unknown RA base reg %d", ra->base);
 	}
 
 	orc->sp_offset = cfi->cfa.offset;
-
-	return 0;
 }
 
-int write_orc_entry(struct elf *elf, struct section *orc_sec,
+void write_orc_entry(struct elf *elf, struct section *orc_sec,
 		    struct section *ip_sec, unsigned int idx,
 		    struct section *insn_sec, unsigned long insn_off,
 		    struct orc_entry *o)
@@ -110,11 +104,7 @@ int write_orc_entry(struct elf *elf, struct section *orc_sec,
 	memcpy(orc, o, sizeof(*orc));
 
 	/* populate reloc for ip */
-	if (!elf_init_reloc_text_sym(elf, ip_sec, idx * sizeof(int), idx,
-				     insn_sec, insn_off))
-		return -1;
-
-	return 0;
+	elf_init_reloc_text_sym(elf, ip_sec, idx * sizeof(int), idx, insn_sec, insn_off);
 }
 
 static const char *reg_name(unsigned int reg)
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 1b24b05eff09..6b34b058a821 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -36,8 +36,7 @@ static int is_x86_64(const struct elf *elf)
 	case EM_386:
 		return 0;
 	default:
-		WARN("unexpected ELF machine type %d", elf->ehdr.e_machine);
-		return -1;
+		ERROR("unexpected ELF machine type %d", elf->ehdr.e_machine);
 	}
 }
 
@@ -166,10 +165,8 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 
 	ret = insn_decode(&ins, sec->data->d_buf + offset, maxlen,
 			  x86_64 ? INSN_MODE_64 : INSN_MODE_32);
-	if (ret < 0) {
-		WARN("can't decode instruction at %s:0x%lx", sec->name, offset);
-		return -1;
-	}
+	if (ret < 0)
+		ERROR("can't decode instruction at %s:0x%lx", sec->name, offset);
 
 	insn->len = ins.length;
 	insn->type = INSN_OTHER;
@@ -441,10 +438,8 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 		break;
 
 	case 0x8d:
-		if (mod_is_reg()) {
-			WARN("invalid LEA encoding at %s:0x%lx", sec->name, offset);
-			break;
-		}
+		if (mod_is_reg())
+			ERROR("invalid LEA encoding at %s:0x%lx", sec->name, offset);
 
 		/* skip non 64bit ops */
 		if (!rex_w)
@@ -553,8 +548,7 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 			if (ins.prefixes.nbytes == 1 &&
 			    ins.prefixes.bytes[0] == 0xf2) {
 				/* ENQCMD cannot be used in the kernel. */
-				WARN("ENQCMD instruction at %s:%lx", sec->name,
-				     offset);
+				ERROR("ENQCMD instruction at %s:%lx", sec->name, offset);
 			}
 
 		} else if (op2 == 0xa0 || op2 == 0xa8) {
@@ -637,10 +631,8 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 			func = disp->sym;
 			if (disp->sym->type == STT_SECTION)
 				func = find_symbol_by_offset(disp->sym->sec, reloc_addend(disp));
-			if (!func) {
-				WARN("no func for pv_ops[]");
-				return -1;
-			}
+			if (!func)
+				ERROR("no func for pv_ops[]");
 
 			objtool_pv_add(file, idx, func);
 		}
@@ -703,13 +695,13 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 
 			insn->type = INSN_CALL_DYNAMIC;
 			if (has_notrack_prefix(&ins))
-				WARN("notrack prefix found at %s:0x%lx", sec->name, offset);
+				ERROR("notrack prefix found at %s:0x%lx", sec->name, offset);
 
 		} else if (modrm_reg == 4) {
 
 			insn->type = INSN_JUMP_DYNAMIC;
 			if (has_notrack_prefix(&ins))
-				WARN("notrack prefix found at %s:0x%lx", sec->name, offset);
+				ERROR("notrack prefix found at %s:0x%lx", sec->name, offset);
 
 		} else if (modrm_reg == 5) {
 
@@ -764,10 +756,8 @@ const char *arch_nop_insn(int len)
 		{ BYTES_NOP5 },
 	};
 
-	if (len < 1 || len > 5) {
-		WARN("invalid NOP size: %d\n", len);
-		return NULL;
-	}
+	if (len < 1 || len > 5)
+		ERROR("invalid NOP size: %d\n", len);
 
 	return nops[len-1];
 }
@@ -784,10 +774,8 @@ const char *arch_ret_insn(int len)
 		{ BYTE_RET, 0xcc, BYTES_NOP3 },
 	};
 
-	if (len < 1 || len > 5) {
-		WARN("invalid RET size: %d\n", len);
-		return NULL;
-	}
+	if (len < 1 || len > 5)
+		ERROR("invalid RET size: %d\n", len);
 
 	return ret[len-1];
 }
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
index b6cd943e87f9..6e0aa5a56b39 100644
--- a/tools/objtool/arch/x86/orc.c
+++ b/tools/objtool/arch/x86/orc.c
@@ -7,7 +7,7 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
+void init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
 	struct cfi_reg *bp = &cfi->regs[CFI_BP];
 
@@ -20,16 +20,16 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		 * STACK_FRAME_NON_STANDARD functions.
 		 */
 		orc->type = ORC_TYPE_UNDEFINED;
-		return 0;
+		return;
 	}
 
 	switch (cfi->type) {
 	case UNWIND_HINT_TYPE_UNDEFINED:
 		orc->type = ORC_TYPE_UNDEFINED;
-		return 0;
+		return;
 	case UNWIND_HINT_TYPE_END_OF_STACK:
 		orc->type = ORC_TYPE_END_OF_STACK;
-		return 0;
+		return;
 	case UNWIND_HINT_TYPE_CALL:
 		orc->type = ORC_TYPE_CALL;
 		break;
@@ -40,8 +40,7 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->type = ORC_TYPE_REGS_PARTIAL;
 		break;
 	default:
-		WARN_INSN(insn, "unknown unwind hint type %d", cfi->type);
-		return -1;
+		ERROR_INSN(insn, "unknown unwind hint type %d", cfi->type);
 	}
 
 	orc->signal = cfi->signal;
@@ -72,8 +71,7 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->sp_reg = ORC_REG_DX;
 		break;
 	default:
-		WARN_INSN(insn, "unknown CFA base reg %d", cfi->cfa.base);
-		return -1;
+		ERROR_INSN(insn, "unknown CFA base reg %d", cfi->cfa.base);
 	}
 
 	switch (bp->base) {
@@ -87,17 +85,14 @@ int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruct
 		orc->bp_reg = ORC_REG_BP;
 		break;
 	default:
-		WARN_INSN(insn, "unknown BP base reg %d", bp->base);
-		return -1;
+		ERROR_INSN(insn, "unknown BP base reg %d", bp->base);
 	}
 
 	orc->sp_offset = cfi->cfa.offset;
 	orc->bp_offset = bp->offset;
-
-	return 0;
 }
 
-int write_orc_entry(struct elf *elf, struct section *orc_sec,
+void write_orc_entry(struct elf *elf, struct section *orc_sec,
 		    struct section *ip_sec, unsigned int idx,
 		    struct section *insn_sec, unsigned long insn_off,
 		    struct orc_entry *o)
@@ -111,11 +106,7 @@ int write_orc_entry(struct elf *elf, struct section *orc_sec,
 	orc->bp_offset = bswap_if_needed(elf, orc->bp_offset);
 
 	/* populate reloc for ip */
-	if (!elf_init_reloc_text_sym(elf, ip_sec, idx * sizeof(int), idx,
-				     insn_sec, insn_off))
-		return -1;
-
-	return 0;
+	elf_init_reloc_text_sym(elf, ip_sec, idx * sizeof(int), idx, insn_sec, insn_off);
 }
 
 static const char *reg_name(unsigned int reg)
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 2f16f5ee83ae..6894ef68d125 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -8,11 +8,7 @@
 #include <stdlib.h>
 #include <objtool/builtin.h>
 #include <objtool/objtool.h>
-
-#define ERROR(format, ...)				\
-	fprintf(stderr,					\
-		"error: objtool: " format "\n",		\
-		##__VA_ARGS__)
+#include <objtool/warn.h>
 
 struct opts opts;
 
@@ -129,7 +125,7 @@ int cmd_parse_options(int argc, const char **argv, const char * const usage[])
 	return argc;
 }
 
-static bool opts_valid(void)
+static void validate_opts(void)
 {
 	if (opts.hack_jump_label	||
 	    opts.hack_noinstr		||
@@ -143,63 +139,46 @@ static bool opts_valid(void)
 	    opts.stackval		||
 	    opts.static_call		||
 	    opts.uaccess) {
-		if (opts.dump_orc) {
+		if (opts.dump_orc)
 			ERROR("--dump can't be combined with other options");
-			return false;
-		}
 
-		return true;
+		return;
 	}
 
-	if (opts.unret && !opts.rethunk) {
+	if (opts.unret && !opts.rethunk)
 		ERROR("--unret requires --rethunk");
-		return false;
-	}
 
 	if (opts.dump_orc)
-		return true;
+		return;
 
 	ERROR("At least one command required");
-	return false;
 }
 
-static bool mnop_opts_valid(void)
+static void validate_mnop_opts(void)
 {
-	if (opts.mnop && !opts.mcount) {
+	if (opts.mnop && !opts.mcount)
 		ERROR("--mnop requires --mcount");
-		return false;
-	}
-
-	return true;
 }
 
-static bool link_opts_valid(struct objtool_file *file)
+static void validate_link_opts(struct objtool_file *file)
 {
 	if (opts.link)
-		return true;
+		return;
 
 	if (has_multiple_files(file->elf)) {
-		ERROR("Linked object detected, forcing --link");
+		WARN("Linked object detected, forcing --link");
 		opts.link = true;
-		return true;
+		return;
 	}
 
-	if (opts.noinstr) {
+	if (opts.noinstr)
 		ERROR("--noinstr requires --link");
-		return false;
-	}
 
-	if (opts.ibt) {
+	if (opts.ibt)
 		ERROR("--ibt requires --link");
-		return false;
-	}
 
-	if (opts.unret) {
+	if (opts.unret)
 		ERROR("--unret requires --link");
-		return false;
-	}
-
-	return true;
 }
 
 int objtool_run(int argc, const char **argv)
@@ -211,8 +190,7 @@ int objtool_run(int argc, const char **argv)
 	argc = cmd_parse_options(argc, argv, check_usage);
 	objname = argv[0];
 
-	if (!opts_valid())
-		return 1;
+	validate_opts();
 
 	if (opts.dump_orc)
 		return orc_dump(objname);
@@ -221,18 +199,15 @@ int objtool_run(int argc, const char **argv)
 	if (!file)
 		return 1;
 
-	if (!mnop_opts_valid())
-		return 1;
-
-	if (!link_opts_valid(file))
-		return 1;
+	validate_mnop_opts();
+	validate_link_opts(file);
 
 	ret = check(file);
 	if (ret)
 		return ret;
 
 	if (file->elf->changed)
-		return elf_write(file->elf);
+		elf_write(file->elf);
 
 	return 0;
 }
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6490bc939892..af945854dd72 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -292,11 +292,11 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 
 static struct cfi_state *cfi_alloc(void)
 {
-	struct cfi_state *cfi = calloc(1, sizeof(struct cfi_state));
-	if (!cfi) {
-		WARN("calloc failed");
-		exit(1);
-	}
+	struct cfi_state *cfi;
+
+	cfi = calloc(1, sizeof(struct cfi_state));
+	ERROR_ON(!cfi, "calloc");
+
 	nr_cfi++;
 	return cfi;
 }
@@ -346,15 +346,15 @@ static void cfi_hash_add(struct cfi_state *cfi)
 static void *cfi_hash_alloc(unsigned long size)
 {
 	cfi_bits = max(10, ilog2(size));
+
 	cfi_hash = mmap(NULL, sizeof(struct hlist_head) << cfi_bits,
 			PROT_READ|PROT_WRITE,
 			MAP_PRIVATE|MAP_ANON, -1, 0);
-	if (cfi_hash == (void *)-1L) {
-		WARN("mmap fail cfi_hash");
-		cfi_hash = NULL;
-	}  else if (opts.stats) {
+	if (cfi_hash == (void *)-1L)
+		ERROR("mmap fail cfi_hash");
+
+	if (opts.stats)
 		printf("cfi_bits: %d\n", cfi_bits);
-	}
 
 	return cfi_hash;
 }
@@ -366,7 +366,7 @@ static unsigned long nr_insns_visited;
  * Call the arch-specific instruction decoder for all the instructions and add
  * them to the global instruction list.
  */
-static int decode_instructions(struct objtool_file *file)
+static void decode_instructions(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
@@ -405,10 +405,8 @@ static int decode_instructions(struct objtool_file *file)
 		for (offset = 0; offset < sec_size(sec); offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
 				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
-				if (!insns) {
-					WARN("malloc failed");
-					return -1;
-				}
+				ERROR_ON(!insns, "calloc");
+
 				idx = 0;
 			} else {
 				idx++;
@@ -424,8 +422,7 @@ static int decode_instructions(struct objtool_file *file)
 			ret = arch_decode_instruction(file, sec, offset,
 						      sec_size(sec) - offset,
 						      insn);
-			if (ret)
-				return ret;
+			ERROR_ON(ret, "arch_decode_instruction failed");
 
 			prev_len = insn->len;
 
@@ -451,19 +448,14 @@ static int decode_instructions(struct objtool_file *file)
 				/* Heuristic: likely an "end" symbol */
 				if (is_notype_symbol(func))
 					continue;
-				WARN("%s(): STT_FUNC at end of section",
-				     func->name);
-				return -1;
+				ERROR("%s(): STT_FUNC at end of section", func->name);
 			}
 
 			if (func->embedded_insn || func->alias != func)
 				continue;
 
-			if (!find_insn(file, sec, func->offset)) {
-				WARN("%s(): can't find starting instruction",
-				     func->name);
-				return -1;
-			}
+			if (!find_insn(file, sec, func->offset))
+				ERROR("%s(): can't find starting instruction", func->name);
 
 			sym_for_each_insn(file, func, insn) {
 				insn->sym = func;
@@ -483,14 +475,12 @@ static int decode_instructions(struct objtool_file *file)
 
 	if (opts.stats)
 		printf("nr_insns: %lu\n", nr_insns);
-
-	return 0;
 }
 
 /*
  * Read the pv_ops[] .data table to find the static initialized values.
  */
-static int add_pv_ops(struct objtool_file *file, const char *symname)
+static void add_pv_ops(struct objtool_file *file, const char *symname)
 {
 	struct symbol *sym, *func;
 	unsigned long off, end;
@@ -499,7 +489,7 @@ static int add_pv_ops(struct objtool_file *file, const char *symname)
 
 	sym = find_symbol_by_name(file->elf, symname);
 	if (!sym)
-		return 0;
+		return;
 
 	off = sym->offset;
 	end = off + sym->len;
@@ -509,10 +499,14 @@ static int add_pv_ops(struct objtool_file *file, const char *symname)
 			break;
 
 		func = reloc->sym;
-		if (is_section_symbol(func))
+		if (is_section_symbol(func)) {
 			func = find_symbol_by_offset(reloc->sym->sec,
 						     reloc_addend(reloc));
 
+			if (!func)
+				ERROR("can't find sym for %s", reloc->sym->name);
+		}
+
 		idx = (reloc_offset(reloc) - sym->offset) / sizeof(unsigned long);
 
 		objtool_pv_add(file, idx, func);
@@ -522,13 +516,13 @@ static int add_pv_ops(struct objtool_file *file, const char *symname)
 			break;
 	}
 
-	return 0;
+	return;
 }
 
 /*
  * Allocate and initialize file->pv_ops[].
  */
-static int init_pv_ops(struct objtool_file *file)
+static void init_pv_ops(struct objtool_file *file)
 {
 	static const char *pv_ops_tables[] = {
 		"pv_ops",
@@ -542,26 +536,23 @@ static int init_pv_ops(struct objtool_file *file)
 	int idx, nr;
 
 	if (!opts.noinstr)
-		return 0;
+		return;
 
 	file->pv_ops = NULL;
 
 	sym = find_symbol_by_name(file->elf, "pv_ops");
 	if (!sym)
-		return 0;
+		return;
 
 	nr = sym->len / sizeof(unsigned long);
 	file->pv_ops = calloc(sizeof(struct pv_state), nr);
-	if (!file->pv_ops)
-		return -1;
+	ERROR_ON(!file->pv_ops, "calloc");
 
 	for (idx = 0; idx < nr; idx++)
 		INIT_LIST_HEAD(&file->pv_ops[idx].targets);
 
 	for (idx = 0; (pv_ops = pv_ops_tables[idx]); idx++)
 		add_pv_ops(file, pv_ops);
-
-	return 0;
 }
 
 static struct instruction *find_last_insn(struct objtool_file *file,
@@ -580,7 +571,7 @@ static struct instruction *find_last_insn(struct objtool_file *file,
 /*
  * Mark "ud2" instructions and manually annotated dead ends.
  */
-static int add_dead_ends(struct objtool_file *file)
+static void add_dead_ends(struct objtool_file *file)
 {
 	struct section *rsec;
 	struct reloc *reloc;
@@ -601,15 +592,12 @@ static int add_dead_ends(struct objtool_file *file)
 			insn = prev_insn_same_sec(file, insn);
 		else if (offset == sec_size(reloc->sym->sec)) {
 			insn = find_last_insn(file, reloc->sym->sec);
-			if (!insn) {
-				WARN("can't find unreachable insn at %s+0x%" PRIx64,
-				     reloc->sym->sec->name, offset);
-				return -1;
-			}
+			if (!insn)
+				ERROR("can't find unreachable insn at %s+0x%" PRIx64,
+				      reloc->sym->sec->name, offset);
 		} else {
-			WARN("can't find unreachable insn at %s+0x%" PRIx64,
-			     reloc->sym->sec->name, offset);
-			return -1;
+			ERROR("can't find unreachable insn at %s+0x%" PRIx64,
+			      reloc->sym->sec->name, offset);
 		}
 
 		insn->dead_end = true;
@@ -624,7 +612,7 @@ static int add_dead_ends(struct objtool_file *file)
 	 */
 	rsec = find_section_by_name(file->elf, ".rela.discard.reachable");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		offset = reloc->sym->offset + reloc_addend(reloc);
@@ -633,24 +621,19 @@ static int add_dead_ends(struct objtool_file *file)
 			insn = prev_insn_same_sec(file, insn);
 		else if (offset == sec_size(reloc->sym->sec)) {
 			insn = find_last_insn(file, reloc->sym->sec);
-			if (!insn) {
-				WARN("can't find reachable insn at %s+0x%" PRIx64,
-				     reloc->sym->sec->name, offset);
-				return -1;
-			}
+			if (!insn)
+				ERROR("can't find reachable insn at %s+0x%" PRIx64,
+				      reloc->sym->sec->name, offset);
 		} else {
-			WARN("can't find reachable insn at %s+0x%" PRIx64,
-			     reloc->sym->sec->name, offset);
-			return -1;
+			ERROR("can't find reachable insn at %s+0x%" PRIx64,
+			      reloc->sym->sec->name, offset);
 		}
 
 		insn->dead_end = false;
 	}
-
-	return 0;
 }
 
-static int create_static_call_sections(struct objtool_file *file)
+static void create_static_call_sections(struct objtool_file *file)
 {
 	struct static_call_site *site;
 	struct section *sec;
@@ -663,11 +646,11 @@ static int create_static_call_sections(struct objtool_file *file)
 	if (sec) {
 		INIT_LIST_HEAD(&file->static_call_list);
 		WARN("file already has .static_call_sites section, skipping");
-		return 0;
+		return;
 	}
 
 	if (list_empty(&file->static_call_list))
-		return 0;
+		return;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, call_node)
@@ -675,8 +658,6 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = elf_create_section_pair(file->elf, ".static_call_sites",
 				      sizeof(*site), idx, idx * 2);
-	if (!sec)
-		return -1;
 
 	/* Allow modules to modify the low bits of static_call_site::key */
 	sec->sh.sh_flags |= SHF_WRITE;
@@ -685,33 +666,23 @@ static int create_static_call_sections(struct objtool_file *file)
 	list_for_each_entry(insn, &file->static_call_list, call_node) {
 
 		/* populate reloc for 'addr' */
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(*site), idx * 2,
-					     insn->sec, insn->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec, idx * sizeof(*site),
+					idx * 2, insn->sec, insn->offset);
 
 		/* find key symbol */
 		key_name = strdup(insn_call_dest(insn)->name);
-		if (!key_name) {
-			perror("strdup");
-			return -1;
-		}
-		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
-			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
-			WARN("static_call: trampoline name malformed: %s", key_name);
-			free(key_name);
-			return -1;
-		}
+		ERROR_ON(!key_name, "strdup");
+
+		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR, STATIC_CALL_TRAMP_PREFIX_LEN))
+			ERROR("static_call: trampoline name malformed: %s", key_name);
+
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
 		memcpy(tmp, STATIC_CALL_KEY_PREFIX_STR, STATIC_CALL_KEY_PREFIX_LEN);
 
 		key_sym = find_symbol_by_name(file->elf, tmp);
 		if (!key_sym) {
-			if (!opts.module) {
-				WARN("static_call: can't find static_call_key symbol: %s", tmp);
-				free(key_name);
-				return -1;
-			}
+			if (!opts.module)
+				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
 
 			/*
 			 * For modules(), the key might not be exported, which
@@ -727,19 +698,15 @@ static int create_static_call_sections(struct objtool_file *file)
 		free(key_name);
 
 		/* populate reloc for 'key' */
-		if (!elf_init_reloc_data_sym(file->elf, sec,
-					     idx * sizeof(*site) + 4,
-					     (idx * 2) + 1, key_sym,
-					     is_sibling_call(insn) * STATIC_CALL_SITE_TAIL))
-			return -1;
+		elf_init_reloc_data_sym(file->elf, sec, idx * sizeof(*site) + 4,
+					(idx * 2) + 1, key_sym,
+					is_sibling_call(insn) * STATIC_CALL_SITE_TAIL);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_retpoline_sites_sections(struct objtool_file *file)
+static void create_retpoline_sites_sections(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *sec;
@@ -748,7 +715,7 @@ static int create_retpoline_sites_sections(struct objtool_file *file)
 	sec = find_section_by_name(file->elf, ".retpoline_sites");
 	if (sec) {
 		WARN("file already has .retpoline_sites, skipping");
-		return 0;
+		return;
 	}
 
 	idx = 0;
@@ -756,28 +723,22 @@ static int create_retpoline_sites_sections(struct objtool_file *file)
 		idx++;
 
 	if (!idx)
-		return 0;
+		return;
 
 	sec = elf_create_section_pair(file->elf, ".retpoline_sites",
 				      sizeof(int), idx, idx);
-	if (!sec)
-		return -1;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->retpoline_call_list, call_node) {
 
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(int), idx,
-					     insn->sec, insn->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec, idx * sizeof(int), idx,
+					insn->sec, insn->offset);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_return_sites_sections(struct objtool_file *file)
+static void create_return_sites_sections(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *sec;
@@ -786,7 +747,7 @@ static int create_return_sites_sections(struct objtool_file *file)
 	sec = find_section_by_name(file->elf, ".return_sites");
 	if (sec) {
 		WARN("file already has .return_sites, skipping");
-		return 0;
+		return;
 	}
 
 	idx = 0;
@@ -794,28 +755,22 @@ static int create_return_sites_sections(struct objtool_file *file)
 		idx++;
 
 	if (!idx)
-		return 0;
+		return;
 
 	sec = elf_create_section_pair(file->elf, ".return_sites",
 				      sizeof(int), idx, idx);
-	if (!sec)
-		return -1;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->return_thunk_list, call_node) {
 
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(int), idx,
-					     insn->sec, insn->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec, idx * sizeof(int), idx,
+					insn->sec, insn->offset);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_ibt_endbr_seal_sections(struct objtool_file *file)
+static void create_ibt_endbr_seal_sections(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *sec;
@@ -824,7 +779,7 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 	sec = find_section_by_name(file->elf, ".ibt_endbr_seal");
 	if (sec) {
 		WARN("file already has .ibt_endbr_seal, skipping");
-		return 0;
+		return;
 	}
 
 	idx = 0;
@@ -838,12 +793,10 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 	}
 
 	if (!idx)
-		return 0;
+		return;
 
 	sec = elf_create_section_pair(file->elf, ".ibt_endbr_seal",
 				      sizeof(int), idx, idx);
-	if (!sec)
-		return -1;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->endbr_list, call_node) {
@@ -856,20 +809,16 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 		    insn->offset == sym->offset &&
 		    (!strcmp(sym->name, "init_module") ||
 		     !strcmp(sym->name, "cleanup_module")))
-			WARN("%s(): not an indirect call target", sym->name);
+			ERROR("%s(): not an indirect call target", sym->name);
 
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(int), idx,
-					     insn->sec, insn->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec, idx * sizeof(int), idx,
+					insn->sec, insn->offset);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_cfi_sections(struct objtool_file *file)
+static void create_cfi_sections(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *sym;
@@ -879,7 +828,7 @@ static int create_cfi_sections(struct objtool_file *file)
 	if (sec) {
 		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .cfi_sites section, skipping");
-		return 0;
+		return;
 	}
 
 	idx = 0;
@@ -895,8 +844,6 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	sec = elf_create_section_pair(file->elf, ".cfi_sites",
 				      sizeof(unsigned int), idx, idx);
-	if (!sec)
-		return -1;
 
 	idx = 0;
 	for_each_sym(file->elf, sym) {
@@ -906,18 +853,15 @@ static int create_cfi_sections(struct objtool_file *file)
 		if (strncmp(sym->name, "__cfi_", 6))
 			continue;
 
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(unsigned int), idx,
-					     sym->sec, sym->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec,
+					idx * sizeof(unsigned int), idx,
+					sym->sec, sym->offset);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_mcount_loc_sections(struct objtool_file *file)
+static void create_mcount_loc_sections(struct objtool_file *file)
 {
 	size_t addr_size = elf_addr_size(file->elf);
 	struct instruction *insn;
@@ -928,11 +872,11 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 	if (sec) {
 		INIT_LIST_HEAD(&file->mcount_loc_list);
 		WARN("file already has __mcount_loc section, skipping");
-		return 0;
+		return;
 	}
 
 	if (list_empty(&file->mcount_loc_list))
-		return 0;
+		return;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->mcount_loc_list, call_node)
@@ -940,8 +884,6 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = elf_create_section_pair(file->elf, "__mcount_loc", addr_size,
 				      idx, idx);
-	if (!sec)
-		return -1;
 
 	sec->sh.sh_addralign = addr_size;
 
@@ -952,18 +894,14 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 		reloc = elf_init_reloc_text_sym(file->elf, sec, idx * addr_size, idx,
 					       insn->sec, insn->offset);
-		if (!reloc)
-			return -1;
 
 		set_reloc_type(file->elf, reloc, addr_size == 8 ? R_ABS64 : R_ABS32);
 
 		idx++;
 	}
-
-	return 0;
 }
 
-static int create_direct_call_sections(struct objtool_file *file)
+static void create_direct_call_sections(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *sec;
@@ -973,11 +911,11 @@ static int create_direct_call_sections(struct objtool_file *file)
 	if (sec) {
 		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .call_sites section, skipping");
-		return 0;
+		return;
 	}
 
 	if (list_empty(&file->call_list))
-		return 0;
+		return;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->call_list, call_node)
@@ -985,21 +923,16 @@ static int create_direct_call_sections(struct objtool_file *file)
 
 	sec = elf_create_section_pair(file->elf, ".call_sites",
 				      sizeof(unsigned int), idx, idx);
-	if (!sec)
-		return -1;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->call_list, call_node) {
 
-		if (!elf_init_reloc_text_sym(file->elf, sec,
-					     idx * sizeof(unsigned int), idx,
-					     insn->sec, insn->offset))
-			return -1;
+		elf_init_reloc_text_sym(file->elf, sec,
+					idx * sizeof(unsigned int), idx,
+					insn->sec, insn->offset);
 
 		idx++;
 	}
-
-	return 0;
 }
 
 /*
@@ -1025,13 +958,12 @@ static void add_ignores(struct objtool_file *file)
 		case STT_SECTION:
 			func = find_func_by_offset(reloc->sym->sec, reloc_addend(reloc));
 			if (!func)
-				continue;
+				ERROR("bad STACK_FRAME_NON_STANDARD entry");
 			break;
 
 		default:
-			WARN("unexpected relocation symbol type in %s: %d",
-			     rsec->name, reloc->sym->type);
-			continue;
+			ERROR("unexpected relocation symbol type in %s: %d",
+			      rsec->name, reloc->sym->type);
 		}
 
 		func_for_each_insn(file, func, insn)
@@ -1247,7 +1179,7 @@ static void add_uaccess_safe(struct objtool_file *file)
  * But it at least allows objtool to understand the control flow *around* the
  * retpoline.
  */
-static int add_ignore_alternatives(struct objtool_file *file)
+static void add_ignore_alternatives(struct objtool_file *file)
 {
 	struct section *rsec;
 	struct reloc *reloc;
@@ -1255,21 +1187,17 @@ static int add_ignore_alternatives(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.ignore_alts");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.ignore_alts entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.ignore_alts entry");
 
 		insn->ignore_alts = true;
 	}
-
-	return 0;
 }
 
 /*
@@ -1370,7 +1298,7 @@ static void annotate_call_site(struct objtool_file *file,
 		elf_write_insn(file->elf, insn->sec,
 			       insn->offset, insn->len,
 			       sibling ? arch_ret_insn(insn->len)
-			               : arch_nop_insn(insn->len));
+				       : arch_nop_insn(insn->len));
 
 		insn->type = sibling ? INSN_RETURN : INSN_NOP;
 
@@ -1389,7 +1317,7 @@ static void annotate_call_site(struct objtool_file *file,
 
 	if (opts.mcount && sym->fentry) {
 		if (sibling)
-			WARN_INSN(insn, "tail call to __fentry__ !?!?");
+			ERROR_INSN(insn, "tail call to __fentry__ !?!?");
 		if (opts.mnop) {
 			if (reloc)
 				set_reloc_type(file->elf, reloc, R_NONE);
@@ -1504,7 +1432,7 @@ static bool is_first_func_insn(struct objtool_file *file,
 /*
  * Find the destination instructions for all jumps.
  */
-static int add_jump_destinations(struct objtool_file *file)
+static void add_jump_destinations(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct reloc *reloc;
@@ -1559,9 +1487,8 @@ static int add_jump_destinations(struct objtool_file *file)
 					continue;
 				}
 
-				WARN_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
-					  dest_sec->name, dest_off);
-				return -1;
+				ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
+					   dest_sec->name, dest_off);
 			}
 
 			dest_sym = dest_insn->sym;
@@ -1638,8 +1565,6 @@ static int add_jump_destinations(struct objtool_file *file)
 set_jump_dest:
 		insn->jump_dest = dest_insn;
 	}
-
-	return 0;
 }
 
 static struct symbol *find_call_destination(struct section *sec, unsigned long offset)
@@ -1656,7 +1581,7 @@ static struct symbol *find_call_destination(struct section *sec, unsigned long o
 /*
  * Find the destination instructions for all calls.
  */
-static int add_call_destinations(struct objtool_file *file)
+static void add_call_destinations(struct objtool_file *file)
 {
 	struct instruction *insn;
 	unsigned long dest_off;
@@ -1677,24 +1602,18 @@ static int add_call_destinations(struct objtool_file *file)
 			if (insn->ignore)
 				continue;
 
-			if (!insn_call_dest(insn)) {
-				WARN_INSN(insn, "unannotated intra-function call");
-				return -1;
-			}
+			if (!insn_call_dest(insn))
+				ERROR_INSN(insn, "unannotated intra-function call");
 
-			if (insn_func(insn) && !is_function_symbol(insn_call_dest(insn))) {
-				WARN_INSN(insn, "unsupported call to non-function");
-				return -1;
-			}
+			if (insn_func(insn) && !is_function_symbol(insn_call_dest(insn)))
+				ERROR_INSN(insn, "unsupported call to non-function");
 
 		} else if (is_section_symbol(reloc->sym)) {
 			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
 			dest = find_call_destination(reloc->sym->sec, dest_off);
-			if (!dest) {
-				WARN_INSN(insn, "can't find call dest symbol at %s+0x%lx",
-					  reloc->sym->sec->name, dest_off);
-				return -1;
-			}
+			if (!dest)
+				ERROR_INSN(insn, "can't find call dest symbol at %s+0x%lx",
+					   reloc->sym->sec->name, dest_off);
 
 			add_call_dest(file, insn, dest, false);
 
@@ -1704,18 +1623,16 @@ static int add_call_destinations(struct objtool_file *file)
 		} else
 			add_call_dest(file, insn, reloc->sym, false);
 	}
-
-	return 0;
 }
 
 /*
  * The .alternatives section requires some extra special care over and above
  * other special sections because alternatives are patched in place.
  */
-static int handle_group_alt(struct objtool_file *file,
-			    struct special_alt *special_alt,
-			    struct instruction *orig_insn,
-			    struct instruction **new_insn)
+static void handle_group_alt(struct objtool_file *file,
+			     struct special_alt *special_alt,
+			     struct instruction *orig_insn,
+			     struct instruction **new_insn)
 {
 	struct instruction *last_new_insn = NULL, *insn, *nop = NULL;
 	struct alt_group *orig_alt_group, *new_alt_group;
@@ -1726,16 +1643,11 @@ static int handle_group_alt(struct objtool_file *file,
 		struct instruction *last_orig_insn = NULL;
 
 		orig_alt_group = malloc(sizeof(*orig_alt_group));
-		if (!orig_alt_group) {
-			WARN("malloc failed");
-			return -1;
-		}
+		ERROR_ON(!orig_alt_group, "malloc");
+
 		orig_alt_group->cfi = calloc(special_alt->orig_len,
 					     sizeof(struct cfi_state *));
-		if (!orig_alt_group->cfi) {
-			WARN("calloc failed");
-			return -1;
-		}
+		ERROR_ON(!orig_alt_group->cfi, "calloc");
 
 		insn = orig_insn;
 		sec_for_each_insn_from(file, insn) {
@@ -1752,20 +1664,16 @@ static int handle_group_alt(struct objtool_file *file,
 	} else {
 		if (orig_alt_group->last_insn->offset + orig_alt_group->last_insn->len -
 		    orig_alt_group->first_insn->offset != special_alt->orig_len) {
-			WARN_INSN(orig_insn, "weirdly overlapping alternative! %ld != %d",
-				  orig_alt_group->last_insn->offset +
-				  orig_alt_group->last_insn->len -
-				  orig_alt_group->first_insn->offset,
-				  special_alt->orig_len);
-			return -1;
+			ERROR_INSN(orig_insn, "weirdly overlapping alternative! %ld != %d",
+				   orig_alt_group->last_insn->offset +
+				   orig_alt_group->last_insn->len -
+				   orig_alt_group->first_insn->offset,
+				   special_alt->orig_len);
 		}
 	}
 
 	new_alt_group = malloc(sizeof(*new_alt_group));
-	if (!new_alt_group) {
-		WARN("malloc failed");
-		return -1;
-	}
+	ERROR_ON(!new_alt_group, "malloc");
 
 	if (special_alt->new_len < special_alt->orig_len) {
 		/*
@@ -1775,12 +1683,8 @@ static int handle_group_alt(struct objtool_file *file,
 		 * instruction affects the stack, the instruction after it (the
 		 * nop) will propagate the new state to the shared CFI array.
 		 */
-		nop = malloc(sizeof(*nop));
-		if (!nop) {
-			WARN("malloc failed");
-			return -1;
-		}
-		memset(nop, 0, sizeof(*nop));
+		nop = calloc(1, sizeof(*nop));
+		ERROR_ON(!nop, "calloc");
 
 		nop->sec = special_alt->new_sec;
 		nop->offset = special_alt->new_off + special_alt->new_len;
@@ -1819,11 +1723,9 @@ static int handle_group_alt(struct objtool_file *file,
 		 */
 		alt_reloc = insn_reloc(file, insn);
 		if (alt_reloc && arch_pc_relative_reloc(alt_reloc) &&
-		    !arch_support_alt_relocation(special_alt, insn, alt_reloc)) {
+		    !arch_support_alt_relocation(special_alt, insn, alt_reloc))
 
-			WARN_INSN(insn, "unsupported relocation in alternatives section");
-			return -1;
-		}
+			ERROR_INSN(insn, "unsupported relocation in alternatives section");
 
 		if (!is_static_jump(insn))
 			continue;
@@ -1834,18 +1736,14 @@ static int handle_group_alt(struct objtool_file *file,
 		dest_off = arch_jump_destination(insn);
 		if (dest_off == special_alt->new_off + special_alt->new_len) {
 			insn->jump_dest = next_insn_same_sec(file, orig_alt_group->last_insn);
-			if (!insn->jump_dest) {
-				WARN_INSN(insn, "can't find alternative jump destination");
-				return -1;
-			}
+			if (!insn->jump_dest)
+				ERROR_INSN(insn, "can't find alternative jump destination");
 		}
 	}
 
-	if (!last_new_insn) {
-		WARN_FUNC("can't find last new alternative instruction",
-			  special_alt->new_sec, special_alt->new_off);
-		return -1;
-	}
+	if (!last_new_insn)
+		ERROR_FUNC(special_alt->new_sec, special_alt->new_off,
+			   "can't find last new alternative instruction");
 
 end:
 	new_alt_group->orig_group = orig_alt_group;
@@ -1853,7 +1751,6 @@ static int handle_group_alt(struct objtool_file *file,
 	new_alt_group->last_insn = last_new_insn;
 	new_alt_group->nop = nop;
 	new_alt_group->cfi = orig_alt_group->cfi;
-	return 0;
 }
 
 /*
@@ -1861,17 +1758,14 @@ static int handle_group_alt(struct objtool_file *file,
  * If the original instruction is a jump, make the alt entry an effective nop
  * by just skipping the original instruction.
  */
-static int handle_jump_alt(struct objtool_file *file,
-			   struct special_alt *special_alt,
-			   struct instruction *orig_insn,
-			   struct instruction **new_insn)
+static void handle_jump_alt(struct objtool_file *file,
+			    struct special_alt *special_alt,
+			    struct instruction *orig_insn,
+			    struct instruction **new_insn)
 {
 	if (orig_insn->type != INSN_JUMP_UNCONDITIONAL &&
-	    orig_insn->type != INSN_NOP) {
-
-		WARN_INSN(orig_insn, "unsupported instruction at jump label");
-		return -1;
-	}
+	    orig_insn->type != INSN_NOP)
+		ERROR_INSN(orig_insn, "unsupported instruction at jump label");
 
 	if (opts.hack_jump_label && special_alt->key_addend & 2) {
 		struct reloc *reloc = insn_reloc(file, orig_insn);
@@ -1890,7 +1784,7 @@ static int handle_jump_alt(struct objtool_file *file,
 		else
 			file->jl_nop_long++;
 
-		return 0;
+		return;
 	}
 
 	if (orig_insn->len == 2)
@@ -1899,7 +1793,6 @@ static int handle_jump_alt(struct objtool_file *file,
 		file->jl_long++;
 
 	*new_insn = next_insn_same_sec(file, orig_insn);
-	return 0;
 }
 
 /*
@@ -1908,65 +1801,43 @@ static int handle_jump_alt(struct objtool_file *file,
  * instruction(s) has them added to its insn->alts list, which will be
  * traversed in validate_branch().
  */
-static int add_special_section_alts(struct objtool_file *file)
+static void add_special_section_alts(struct objtool_file *file)
 {
 	struct list_head special_alts;
 	struct instruction *orig_insn, *new_insn;
 	struct special_alt *special_alt, *tmp;
 	struct alternative *alt;
-	int ret;
 
-	ret = special_get_alts(file->elf, &special_alts);
-	if (ret)
-		return ret;
+	special_get_alts(file->elf, &special_alts);
 
 	list_for_each_entry_safe(special_alt, tmp, &special_alts, list) {
 
 		orig_insn = find_insn(file, special_alt->orig_sec,
 				      special_alt->orig_off);
-		if (!orig_insn) {
-			WARN_FUNC("special: can't find orig instruction",
-				  special_alt->orig_sec, special_alt->orig_off);
-			ret = -1;
-			goto out;
-		}
+		if (!orig_insn)
+			ERROR_FUNC(special_alt->orig_sec, special_alt->orig_off,
+				   "special: can't find orig instruction");
 
 		new_insn = NULL;
 		if (!special_alt->group || special_alt->new_len) {
 			new_insn = find_insn(file, special_alt->new_sec,
 					     special_alt->new_off);
-			if (!new_insn) {
-				WARN_FUNC("special: can't find new instruction",
-					  special_alt->new_sec,
-					  special_alt->new_off);
-				ret = -1;
-				goto out;
-			}
+			if (!new_insn)
+				ERROR_FUNC(special_alt->new_sec, special_alt->new_off,
+					   "special: can't find new instruction");
 		}
 
 		if (special_alt->group) {
-			if (!special_alt->orig_len) {
-				WARN_INSN(orig_insn, "empty alternative entry");
-				continue;
-			}
+			if (!special_alt->orig_len)
+				ERROR_INSN(orig_insn, "empty alternative entry");
 
-			ret = handle_group_alt(file, special_alt, orig_insn,
-					       &new_insn);
-			if (ret)
-				goto out;
+			handle_group_alt(file, special_alt, orig_insn, &new_insn);
 		} else if (special_alt->jump_or_nop) {
-			ret = handle_jump_alt(file, special_alt, orig_insn,
-					      &new_insn);
-			if (ret)
-				goto out;
+			handle_jump_alt(file, special_alt, orig_insn, &new_insn);
 		}
 
 		alt = malloc(sizeof(*alt));
-		if (!alt) {
-			WARN("malloc failed");
-			ret = -1;
-			goto out;
-		}
+		ERROR_ON(!alt, "malloc");
 
 		alt->insn = new_insn;
 		alt->skip_orig = special_alt->skip_orig;
@@ -1983,13 +1854,10 @@ static int add_special_section_alts(struct objtool_file *file)
 		printf("short:\t%ld\t%ld\n", file->jl_nop_short, file->jl_short);
 		printf("long:\t%ld\t%ld\n", file->jl_nop_long, file->jl_long);
 	}
-
-out:
-	return ret;
 }
 
-static int add_jump_table(struct objtool_file *file, struct instruction *insn,
-			  struct reloc *next_table)
+static void add_jump_table(struct objtool_file *file, struct instruction *insn,
+			   struct reloc *next_table)
 {
 	struct symbol *pfunc = insn_func(insn)->pfunc;
 	struct reloc *table = insn_jump_table(insn);
@@ -2026,10 +1894,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 			break;
 
 		alt = malloc(sizeof(*alt));
-		if (!alt) {
-			WARN("malloc failed");
-			return -1;
-		}
+		ERROR_ON(!alt, "malloc");
 
 		alt->insn = dest_insn;
 		alt->next = insn->alts;
@@ -2037,12 +1902,8 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		prev_offset = reloc_offset(reloc);
 	}
 
-	if (!prev_offset) {
-		WARN_INSN(insn, "can't find switch jump table");
-		return -1;
-	}
-
-	return 0;
+	if (!prev_offset)
+		ERROR_INSN(insn, "can't find switch jump table");
 }
 
 /*
@@ -2125,11 +1986,10 @@ static void mark_func_jump_tables(struct objtool_file *file,
 	}
 }
 
-static int add_func_jump_tables(struct objtool_file *file,
+static void add_func_jump_tables(struct objtool_file *file,
 				  struct symbol *func)
 {
 	struct instruction *insn, *insn_t1 = NULL, *insn_t2;
-	int ret = 0;
 
 	func_for_each_insn(file, func, insn) {
 		if (!insn_jump_table(insn))
@@ -2142,17 +2002,13 @@ static int add_func_jump_tables(struct objtool_file *file,
 
 		insn_t2 = insn;
 
-		ret = add_jump_table(file, insn_t1, insn_jump_table(insn_t2));
-		if (ret)
-			return ret;
+		add_jump_table(file, insn_t1, insn_jump_table(insn_t2));
 
 		insn_t1 = insn_t2;
 	}
 
 	if (insn_t1)
-		ret = add_jump_table(file, insn_t1, NULL);
-
-	return ret;
+		add_jump_table(file, insn_t1, NULL);
 }
 
 /*
@@ -2160,25 +2016,20 @@ static int add_func_jump_tables(struct objtool_file *file,
  * section which contains a list of addresses within the function to jump to.
  * This finds these jump tables and adds them to the insn->alts lists.
  */
-static int add_jump_table_alts(struct objtool_file *file)
+static void add_jump_table_alts(struct objtool_file *file)
 {
 	struct symbol *func;
-	int ret;
 
 	if (!file->rodata)
-		return 0;
+		return;
 
 	for_each_sym(file->elf, func) {
 		if (!is_function_symbol(func))
 			continue;
 
 		mark_func_jump_tables(file, func);
-		ret = add_func_jump_tables(file, func);
-		if (ret)
-			return ret;
+		add_func_jump_tables(file, func);
 	}
-
-	return 0;
 }
 
 static void set_func_state(struct cfi_state *state)
@@ -2190,7 +2041,7 @@ static void set_func_state(struct cfi_state *state)
 	state->type = UNWIND_HINT_TYPE_CALL;
 }
 
-static int read_unwind_hints(struct objtool_file *file)
+static void read_unwind_hints(struct objtool_file *file)
 {
 	struct cfi_state cfi = init_cfi;
 	struct section *sec;
@@ -2202,17 +2053,13 @@ static int read_unwind_hints(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
 	if (!sec)
-		return 0;
+		return;
 
-	if (!sec->rsec) {
-		WARN("missing .rela.discard.unwind_hints section");
-		return -1;
-	}
+	if (!sec->rsec)
+		ERROR("missing .rela.discard.unwind_hints section");
 
-	if (sec_size(sec) % sizeof(struct unwind_hint)) {
-		WARN("struct unwind_hint size mismatch");
-		return -1;
-	}
+	if (sec_size(sec) % sizeof(struct unwind_hint))
+		ERROR("struct unwind_hint size mismatch");
 
 	file->hints = true;
 
@@ -2220,17 +2067,13 @@ static int read_unwind_hints(struct objtool_file *file)
 		hint = (struct unwind_hint *)sec->data->d_buf + i;
 
 		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
-		if (!reloc) {
-			WARN("can't find reloc for unwind_hints[%d]", i);
-			return -1;
-		}
+		if (!reloc)
+			ERROR("can't find reloc for unwind_hints[%d]", i);
 
 		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("can't find insn for unwind_hints[%d]", i);
-			return -1;
-		}
+		if (!insn)
+			ERROR("can't find insn for unwind_hints[%d]", i);
 
 		insn->hint = true;
 
@@ -2253,11 +2096,9 @@ static int read_unwind_hints(struct objtool_file *file)
 		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
-			if (sym && is_global_symbol(sym)) {
-				if (opts.ibt && insn->type != INSN_ENDBR && !insn->noendbr) {
-					WARN_INSN(insn, "UNWIND_HINT_IRET_REGS without ENDBR");
-				}
-			}
+			if (opts.ibt && sym && is_global_symbol(sym) &&
+			    insn->type != INSN_ENDBR && !insn->noendbr)
+				ERROR_INSN(insn, "UNWIND_HINT_IRET_REGS without ENDBR");
 		}
 
 		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
@@ -2268,10 +2109,8 @@ static int read_unwind_hints(struct objtool_file *file)
 		if (insn->cfi)
 			cfi = *(insn->cfi);
 
-		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
-			WARN_INSN(insn, "unsupported unwind_hint sp base reg %d", hint->sp_reg);
-			return -1;
-		}
+		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base))
+			ERROR_INSN(insn, "unsupported unwind_hint sp base reg %d", hint->sp_reg);
 
 		cfi.cfa.offset = bswap_if_needed(file->elf, hint->sp_offset);
 		cfi.type = hint->type;
@@ -2279,11 +2118,9 @@ static int read_unwind_hints(struct objtool_file *file)
 
 		insn->cfi = cfi_hash_find_or_add(&cfi);
 	}
-
-	return 0;
 }
 
-static int read_noendbr_hints(struct objtool_file *file)
+static void read_noendbr_hints(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *rsec;
@@ -2291,23 +2128,19 @@ static int read_noendbr_hints(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.noendbr");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		insn = find_insn(file, reloc->sym->sec,
 				 reloc->sym->offset + reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.noendbr entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.noendbr entry");
 
 		insn->noendbr = 1;
 	}
-
-	return 0;
 }
 
-static int read_retpoline_hints(struct objtool_file *file)
+static void read_retpoline_hints(struct objtool_file *file)
 {
 	struct section *rsec;
 	struct instruction *insn;
@@ -2315,32 +2148,26 @@ static int read_retpoline_hints(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.retpoline_safe");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.retpoline_safe entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.retpoline_safe entry");
 
 		if (insn->type != INSN_JUMP_DYNAMIC &&
 		    insn->type != INSN_CALL_DYNAMIC &&
 		    insn->type != INSN_RETURN &&
-		    insn->type != INSN_NOP) {
-			WARN_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
-			return -1;
-		}
+		    insn->type != INSN_NOP)
+			ERROR_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
 
 		insn->retpoline_safe = true;
 	}
-
-	return 0;
 }
 
-static int read_instr_hints(struct objtool_file *file)
+static void read_instr_hints(struct objtool_file *file)
 {
 	struct section *rsec;
 	struct instruction *insn;
@@ -2348,40 +2175,34 @@ static int read_instr_hints(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.instr_end");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.instr_end entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.instr_end entry");
 
 		insn->instr--;
 	}
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.instr_begin");
 	if (!rsec)
-		return 0;
+		ERROR("missing instr_begin section");
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.instr_begin entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.instr_begin entry");
 
 		insn->instr++;
 	}
-
-	return 0;
 }
 
-static int read_validate_unret_hints(struct objtool_file *file)
+static void read_validate_unret_hints(struct objtool_file *file)
 {
 	struct section *rsec;
 	struct instruction *insn;
@@ -2389,24 +2210,21 @@ static int read_validate_unret_hints(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.validate_unret");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.instr_end entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.instr_end entry");
+
 		insn->unret = 1;
 	}
-
-	return 0;
 }
 
 
-static int read_intra_function_calls(struct objtool_file *file)
+static void read_intra_function_calls(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct section *rsec;
@@ -2414,22 +2232,18 @@ static int read_intra_function_calls(struct objtool_file *file)
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.intra_function_calls");
 	if (!rsec)
-		return 0;
+		return;
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long dest_off;
 		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
-		if (!insn) {
-			WARN("bad .discard.intra_function_call entry");
-			return -1;
-		}
+		if (!insn)
+			ERROR("bad .discard.intra_function_call entry");
 
-		if (insn->type != INSN_CALL) {
-			WARN_INSN(insn, "intra_function_call not a direct call");
-			return -1;
-		}
+		if (insn->type != INSN_CALL)
+			ERROR_INSN(insn, "intra_function_call not a direct call");
 
 		/*
 		 * Treat intra-function CALLs as JMPs, but with a stack_op.
@@ -2440,14 +2254,10 @@ static int read_intra_function_calls(struct objtool_file *file)
 
 		dest_off = arch_jump_destination(insn);
 		insn->jump_dest = find_insn(file, insn->sec, dest_off);
-		if (!insn->jump_dest) {
-			WARN_INSN(insn, "can't find call dest at %s+0x%lx",
-				  insn->sec->name, dest_off);
-			return -1;
-		}
+		if (!insn->jump_dest)
+			ERROR_INSN(insn, "can't find call dest at %s+0x%lx",
+				   insn->sec->name, dest_off);
 	}
-
-	return 0;
 }
 
 /*
@@ -2475,7 +2285,7 @@ static bool is_profiling_func(const char *name)
 	return false;
 }
 
-static int classify_symbols(struct objtool_file *file)
+static void classify_symbols(struct objtool_file *file)
 {
 	struct symbol *func;
 
@@ -2505,8 +2315,6 @@ static int classify_symbols(struct objtool_file *file)
 		if (is_profiling_func(func->name))
 			func->profiling_func = true;
 	}
-
-	return 0;
 }
 
 static void mark_rodata(struct objtool_file *file)
@@ -2535,96 +2343,62 @@ static void mark_rodata(struct objtool_file *file)
 	file->rodata = found;
 }
 
-static int decode_sections(struct objtool_file *file)
+static void decode_sections(struct objtool_file *file)
 {
-	int ret;
-
 	mark_rodata(file);
 
-	ret = init_pv_ops(file);
-	if (ret)
-		return ret;
+	init_pv_ops(file);
 
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = classify_symbols(file);
-	if (ret)
-		return ret;
+	classify_symbols(file);
 
-	ret = decode_instructions(file);
-	if (ret)
-		return ret;
+	decode_instructions(file);
 
 	add_ignores(file);
+
 	add_uaccess_safe(file);
 
-	ret = add_ignore_alternatives(file);
-	if (ret)
-		return ret;
+	add_ignore_alternatives(file);
 
 	/*
 	 * Must be before read_unwind_hints() since that needs insn->noendbr.
 	 */
-	ret = read_noendbr_hints(file);
-	if (ret)
-		return ret;
+	read_noendbr_hints(file);
 
 	/*
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
-		ret = add_special_section_alts(file);
-		if (ret)
-			return ret;
-	}
+	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr)
+		add_special_section_alts(file);
 
-	ret = add_jump_destinations(file);
-	if (ret)
-		return ret;
+	add_jump_destinations(file);
 
 	/*
 	 * Must be before add_call_destination(); it changes INSN_CALL to
 	 * INSN_JUMP.
 	 */
-	ret = read_intra_function_calls(file);
-	if (ret)
-		return ret;
+	read_intra_function_calls(file);
 
-	ret = add_call_destinations(file);
-	if (ret)
-		return ret;
+	add_call_destinations(file);
 
 	/*
 	 * Must be after add_call_destinations() such that it can override
 	 * dead_end_function() marks.
 	 */
-	ret = add_dead_ends(file);
-	if (ret)
-		return ret;
+	add_dead_ends(file);
 
-	ret = add_jump_table_alts(file);
-	if (ret)
-		return ret;
+	add_jump_table_alts(file);
 
-	ret = read_unwind_hints(file);
-	if (ret)
-		return ret;
+	read_unwind_hints(file);
 
-	ret = read_retpoline_hints(file);
-	if (ret)
-		return ret;
+	read_retpoline_hints(file);
 
-	ret = read_instr_hints(file);
-	if (ret)
-		return ret;
+	read_instr_hints(file);
 
-	ret = read_validate_unret_hints(file);
-	if (ret)
-		return ret;
-
-	return 0;
+	read_validate_unret_hints(file);
 }
 
 static bool is_special_call(struct instruction *insn)
@@ -3082,8 +2856,7 @@ static int update_cfi_state(struct instruction *insn,
 			break;
 
 		default:
-			WARN_INSN(insn, "unknown stack-related instruction");
-			return -1;
+			ERROR_INSN(insn, "unknown stack-related instruction");
 		}
 
 		break;
@@ -3170,10 +2943,8 @@ static int update_cfi_state(struct instruction *insn,
 		break;
 
 	case OP_DEST_MEM:
-		if (op->src.type != OP_SRC_POP && op->src.type != OP_SRC_POPF) {
-			WARN_INSN(insn, "unknown stack-related memory operation");
-			return -1;
-		}
+		if (op->src.type != OP_SRC_POP && op->src.type != OP_SRC_POPF)
+			ERROR_INSN(insn, "unknown stack-related memory operation");
 
 		/* pop mem */
 		cfi->stack_size -= 8;
@@ -3183,8 +2954,7 @@ static int update_cfi_state(struct instruction *insn,
 		break;
 
 	default:
-		WARN_INSN(insn, "unknown stack-related instruction");
-		return -1;
+		ERROR_INSN(insn, "unknown stack-related instruction");
 	}
 
 	return 0;
@@ -3207,25 +2977,20 @@ static int propagate_alt_cfi(struct objtool_file *file, struct instruction *insn
 	if (!insn->alt_group)
 		return 0;
 
-	if (!insn->cfi) {
-		WARN("CFI missing");
-		return -1;
-	}
+	if (!insn->cfi)
+		ERROR("CFI missing");
 
 	alt_cfi = insn->alt_group->cfi;
 	group_off = insn->offset - insn->alt_group->first_insn->offset;
 
 	if (!alt_cfi[group_off]) {
 		alt_cfi[group_off] = insn->cfi;
-	} else {
-		if (cficmp(alt_cfi[group_off], insn->cfi)) {
-			struct alt_group *orig_group = insn->alt_group->orig_group ?: insn->alt_group;
-			struct instruction *orig = orig_group->first_insn;
-			char *where = offstr(insn->sec, insn->offset);
-			WARN_INSN(orig, "stack layout conflict in alternatives: %s", where);
-			free(where);
-			return -1;
-		}
+
+	} else if (cficmp(alt_cfi[group_off], insn->cfi)) {
+		struct alt_group *orig_group = insn->alt_group->orig_group ?: insn->alt_group;
+		struct instruction *orig = orig_group->first_insn;
+		char *where = offstr(insn->sec, insn->offset);
+		ERROR_INSN(orig, "stack layout conflict in alternatives: %s", where);
 	}
 
 	return 0;
@@ -3274,16 +3039,15 @@ static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 	struct cfi_state *cfi1 = insn->cfi;
 	int i;
 
-	if (!cfi1) {
-		WARN("CFI missing");
-		return false;
-	}
+	if (!cfi1)
+		ERROR("CFI missing");
 
 	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
 
 		WARN_INSN(insn, "stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
 			  cfi1->cfa.base, cfi1->cfa.offset,
 			  cfi2->cfa.base, cfi2->cfa.offset);
+		return false;
 
 	} else if (memcmp(&cfi1->regs, &cfi2->regs, sizeof(cfi1->regs))) {
 		for (i = 0; i < CFI_NUM_REGS; i++) {
@@ -3294,13 +3058,14 @@ static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 			WARN_INSN(insn, "stack state mismatch: reg1[%d]=%d%+d reg2[%d]=%d%+d",
 				  i, cfi1->regs[i].base, cfi1->regs[i].offset,
 				  i, cfi2->regs[i].base, cfi2->regs[i].offset);
-			break;
+			return false;
 		}
 
 	} else if (cfi1->type != cfi2->type) {
 
 		WARN_INSN(insn, "stack state mismatch: type1=%d type2=%d",
 			  cfi1->type, cfi2->type);
+		return false;
 
 	} else if (cfi1->drap != cfi2->drap ||
 		   (cfi1->drap && cfi1->drap_reg != cfi2->drap_reg) ||
@@ -3309,6 +3074,7 @@ static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
 		WARN_INSN(insn, "stack state mismatch: drap1=%d(%d,%d) drap2=%d(%d,%d)",
 			  cfi1->drap, cfi1->drap_reg, cfi1->drap_offset,
 			  cfi2->drap, cfi2->drap_reg, cfi2->drap_offset);
+		return false;
 
 	} else
 		return true;
@@ -3361,10 +3127,8 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	file->pv_ops[idx].clean = true;
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
-		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
-			file->pv_ops[idx].clean = false;
-		}
+		if (!target->sec->noinstr)
+			ERROR("pv_ops[%d]: %s", idx, target->name);
 	}
 
 	return file->pv_ops[idx].clean;
@@ -4090,14 +3854,14 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	return false;
 }
 
-static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
+static void add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 {
 	struct instruction *insn, *prev;
 	struct cfi_state *cfi;
 
 	insn = find_insn(file, func->sec, func->offset);
 	if (!insn)
-		return -1;
+		ERROR("%s(): can't find starting insn", func->name);
 
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
@@ -4105,40 +3869,39 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
-			return -1;
+			return;
 
 		offset = func->offset - prev->offset;
 
 		if (offset > opts.prefix)
-			return -1;
+			return;
 
 		if (offset < opts.prefix)
 			continue;
 
 		elf_create_prefix_symbol(file->elf, func, opts.prefix);
+
 		break;
 	}
 
 	if (!prev)
-		return -1;
+		return;
 
 	if (!insn->cfi) {
 		/*
 		 * This can happen if stack validation isn't enabled or the
 		 * function is annotated with STACK_FRAME_NON_STANDARD.
 		 */
-		return 0;
+		return;
 	}
 
 	/* Propagate insn->cfi to the prefix code */
 	cfi = cfi_hash_find_or_add(insn->cfi);
 	for (; prev != insn; prev = next_insn_same_sec(file, prev))
 		prev->cfi = cfi;
-
-	return 0;
 }
 
-static int add_prefix_symbols(struct objtool_file *file)
+static void add_prefix_symbols(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
@@ -4154,8 +3917,6 @@ static int add_prefix_symbols(struct objtool_file *file)
 			add_prefix_symbol(file, func);
 		}
 	}
-
-	return 0;
 }
 
 static int validate_symbol(struct objtool_file *file, struct section *sec,
@@ -4381,9 +4142,8 @@ static int validate_ibt_data_reloc(struct objtool_file *file,
 	if (dest->noendbr)
 		return 0;
 
-	WARN_FUNC("data relocation to !ENDBR: %s",
-		  reloc->sec->base, reloc_offset(reloc),
-		  offstr(dest->sec, dest->offset));
+	WARN_FUNC(reloc->sec->base, reloc_offset(reloc),
+		  "data relocation to !ENDBR: %s", offstr(dest->sec, dest->offset));
 
 	return 1;
 }
@@ -4536,7 +4296,7 @@ static int validate_reachable_instructions(struct objtool_file *file)
 }
 
 /* 'funcs' is a space-separated list of function names */
-static int disas_funcs(const char *funcs)
+static void disas_funcs(const char *funcs)
 {
 	const char *objdump_str, *cross_compile;
 	int size, ret;
@@ -4567,22 +4327,16 @@ static int disas_funcs(const char *funcs)
 
 	/* fake snprintf() to calculate the size */
 	size = snprintf(NULL, 0, objdump_str, cross_compile, Objname, funcs) + 1;
-	if (size <= 0) {
-		WARN("objdump string size calculation failed");
-		return -1;
-	}
+	if (size <= 0)
+		ERROR("objdump string size calculation failed");
 
 	cmd = malloc(size);
 
 	/* real snprintf() */
 	snprintf(cmd, size, objdump_str, cross_compile, Objname, funcs);
 	ret = system(cmd);
-	if (ret) {
-		WARN("disassembly failed: %d", ret);
-		return -1;
-	}
-
-	return 0;
+	if (ret)
+		ERROR("disassembly failed: %d", ret);
 }
 
 static int disas_warned_funcs(struct objtool_file *file)
@@ -4640,7 +4394,7 @@ static void free_insns(struct objtool_file *file)
 
 int check(struct objtool_file *file)
 {
-	int ret, warnings = 0;
+	int ret = 0, warnings = 0;
 
 	arch_initial_func_cfi_state(&initial_func_cfi);
 	init_cfi_state(&init_cfi);
@@ -4649,17 +4403,12 @@ int check(struct objtool_file *file)
 	init_cfi_state(&force_undefined_cfi);
 	force_undefined_cfi.force_undefined = true;
 
-	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
-		goto out;
+	cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3));
 
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
 
-	ret = decode_sections(file);
-	if (ret < 0)
-		goto out;
-
-	warnings += ret;
+	decode_sections(file);
 
 	if (!nr_insns)
 		goto out;
@@ -4721,61 +4470,30 @@ int check(struct objtool_file *file)
 		warnings += ret;
 	}
 
-	if (opts.static_call) {
-		ret = create_static_call_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
-	}
+	if (opts.static_call)
+		create_static_call_sections(file);
 
-	if (opts.retpoline) {
-		ret = create_retpoline_sites_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
-	}
+	if (opts.retpoline)
+		create_retpoline_sites_sections(file);
 
-	if (opts.cfi) {
-		ret = create_cfi_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
-	}
+	if (opts.cfi)
+		create_cfi_sections(file);
 
 	if (opts.rethunk) {
-		ret = create_return_sites_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
+		create_return_sites_sections(file);
 
-		if (opts.hack_skylake) {
-			ret = create_direct_call_sections(file);
-			if (ret < 0)
-				goto out;
-			warnings += ret;
-		}
+		if (opts.hack_skylake)
+			create_direct_call_sections(file);
 	}
 
-	if (opts.mcount) {
-		ret = create_mcount_loc_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
-	}
+	if (opts.mcount)
+		create_mcount_loc_sections(file);
 
-	if (opts.prefix) {
-		ret = add_prefix_symbols(file);
-		if (ret < 0)
-			return ret;
-		warnings += ret;
-	}
+	if (opts.prefix)
+		add_prefix_symbols(file);
 
-	if (opts.ibt) {
-		ret = create_ibt_endbr_seal_sections(file);
-		if (ret < 0)
-			goto out;
-		warnings += ret;
-	}
+	if (opts.ibt)
+		create_ibt_endbr_seal_sections(file);
 
 	if (opts.orc && nr_insns) {
 		ret = orc_create(file);
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index fc76692ced2c..84cb6fc235c9 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -72,17 +72,17 @@ static inline void __elf_hash_del(struct elf_hash_node *node,
 	     obj;							\
 	     obj = elf_list_entry(obj->member.next, typeof(*(obj)), member))
 
-#define elf_alloc_hash(name, size) \
-({ \
-	__elf_bits(name) = max(10, ilog2(size)); \
-	__elf_table(name) = mmap(NULL, sizeof(struct elf_hash_node *) << __elf_bits(name), \
-				 PROT_READ|PROT_WRITE, \
-				 MAP_PRIVATE|MAP_ANON, -1, 0); \
-	if (__elf_table(name) == (void *)-1L) { \
-		WARN("mmap fail " #name); \
-		__elf_table(name) = NULL; \
-	} \
-	__elf_table(name); \
+#define elf_alloc_hash(name, size)					\
+({									\
+	__elf_bits(name) = max(10, ilog2(size));			\
+	__elf_table(name) = mmap(NULL,					\
+				 sizeof(struct elf_hash_node *) << __elf_bits(name), \
+				 PROT_READ|PROT_WRITE,			\
+				 MAP_PRIVATE|MAP_ANON, -1, 0);		\
+	if (__elf_table(name) == (void *)-1L)				\
+		ERROR("mmap fail " #name);				\
+									\
+	__elf_table(name);						\
 })
 
 static inline unsigned long __sym_start(struct symbol *s)
@@ -301,68 +301,53 @@ static bool is_dwarf_section(struct section *sec)
 	return !strncmp(sec->name, ".debug_", 7);
 }
 
-static int read_sections(struct elf *elf)
+static void read_sections(struct elf *elf)
 {
 	Elf_Scn *s = NULL;
 	struct section *sec;
 	size_t shstrndx, sections_nr;
 	int i;
 
-	if (elf_getshdrnum(elf->elf, &sections_nr)) {
-		WARN_ELF("elf_getshdrnum");
-		return -1;
-	}
+	if (elf_getshdrnum(elf->elf, &sections_nr))
+		ERROR_ELF("elf_getshdrnum");
 
-	if (elf_getshdrstrndx(elf->elf, &shstrndx)) {
-		WARN_ELF("elf_getshdrstrndx");
-		return -1;
-	}
+	if (elf_getshdrstrndx(elf->elf, &shstrndx))
+		ERROR_ELF("elf_getshdrstrndx");
 
-	if (!elf_alloc_hash(section, sections_nr) ||
-	    !elf_alloc_hash(section_name, sections_nr))
-		return -1;
+	elf_alloc_hash(section, sections_nr);
+	elf_alloc_hash(section_name, sections_nr);
 
 	elf->section_data = calloc(sections_nr, sizeof(*sec));
-	if (!elf->section_data) {
-		perror("calloc");
-		return -1;
-	}
+	ERROR_ON(!elf->section_data, "calloc");
+
 	for (i = 0; i < sections_nr; i++) {
 		sec = &elf->section_data[i];
 
 		INIT_LIST_HEAD(&sec->symbol_list);
 
 		s = elf_getscn(elf->elf, i);
-		if (!s) {
-			WARN_ELF("elf_getscn");
-			return -1;
-		}
+		if (!s)
+			ERROR_ELF("elf_getscn");
 
 		sec->idx = elf_ndxscn(s);
 
-		if (!gelf_getshdr(s, &sec->sh)) {
-			WARN_ELF("gelf_getshdr");
-			return -1;
-		}
+		if (!gelf_getshdr(s, &sec->sh))
+			ERROR_ELF("gelf_getshdr");
+
+		sec->name = elf_strptr(elf->elf, shstrndx, sec->sh.sh_name);
+		if (!sec->name)
+			ERROR_ELF("elf_strptr");
 
 		sec->name = elf_strptr(elf->elf, shstrndx, sec->sh.sh_name);
-		if (!sec->name) {
-			WARN_ELF("elf_strptr");
-			return -1;
-		}
 
 		if (sec_size(sec) != 0 && !is_dwarf_section(sec)) {
 			sec->data = elf_getdata(s, NULL);
-			if (!sec->data) {
-				WARN_ELF("elf_getdata");
-				return -1;
-			}
+			if (!sec->data)
+				ERROR_ELF("elf_getdata");
+
 			if (sec->data->d_off != 0 ||
-			    sec->data->d_size != sec_size(sec)) {
-				WARN("unexpected data attributes for %s",
-				     sec->name);
-				return -1;
-			}
+			    sec->data->d_size != sec_size(sec))
+				ERROR("unexpected data attributes for %s", sec->name);
 		}
 
 		list_add_tail(&sec->list, &elf->sections);
@@ -379,12 +364,8 @@ static int read_sections(struct elf *elf)
 	}
 
 	/* sanity check, one more call to elf_nextscn() should return NULL */
-	if (elf_nextscn(elf->elf, s)) {
-		WARN("section entry mismatch");
-		return -1;
-	}
-
-	return 0;
+	if (elf_nextscn(elf->elf, s))
+		ERROR("section entry mismatch");
 }
 
 static void elf_add_symbol(struct elf *elf, struct symbol *sym)
@@ -428,7 +409,7 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 		__sym_remove(sym, &sym->sec->symbol_tree);
 }
 
-static int read_symbols(struct elf *elf)
+static void read_symbols(struct elf *elf)
 {
 	struct section *symtab, *symtab_shndx, *sec;
 	struct symbol *sym, *pfunc;
@@ -454,32 +435,24 @@ static int read_symbols(struct elf *elf)
 		symbols_nr = 0;
 	}
 
-	if (!elf_alloc_hash(symbol, symbols_nr) ||
-	    !elf_alloc_hash(symbol_name, symbols_nr))
-		return -1;
+	elf_alloc_hash(symbol, symbols_nr);
+	elf_alloc_hash(symbol_name, symbols_nr);
 
 	elf->symbol_data = calloc(symbols_nr, sizeof(*sym));
-	if (!elf->symbol_data) {
-		perror("calloc");
-		return -1;
-	}
+	ERROR_ON(!elf->symbol_data, "calloc");
+
 	for (i = 0; i < symbols_nr; i++) {
 		sym = &elf->symbol_data[i];
 
 		sym->idx = i;
 
-		if (!gelf_getsymshndx(symtab->data, shndx_data, i, &sym->sym,
-				      &shndx)) {
-			WARN_ELF("gelf_getsymshndx");
-			goto err;
-		}
+		if (!gelf_getsymshndx(symtab->data, shndx_data, i, &sym->sym, &shndx))
+			ERROR_ELF("gelf_getsymshndx");
 
 		sym->name = elf_strptr(elf->elf, symtab->sh.sh_link,
 				       sym->sym.st_name);
-		if (!sym->name) {
-			WARN_ELF("elf_strptr");
-			goto err;
-		}
+		if (!sym->name)
+			ERROR_ELF("elf_strptr");
 
 		if ((sym->sym.st_shndx > SHN_UNDEF &&
 		     sym->sym.st_shndx < SHN_LORESERVE) ||
@@ -488,11 +461,9 @@ static int read_symbols(struct elf *elf)
 				shndx = sym->sym.st_shndx;
 
 			sym->sec = find_section_by_index(elf, shndx);
-			if (!sym->sec) {
-				WARN("couldn't find section for symbol %s",
-				     sym->name);
-				goto err;
-			}
+			if (!sym->sec)
+				ERROR("couldn't find section for symbol %s", sym->name);
+
 			if (GELF_ST_TYPE(sym->sym.st_info) == STT_SECTION) {
 				sym->name = sym->sec->name;
 				sym->sec->sym = sym;
@@ -528,20 +499,13 @@ static int read_symbols(struct elf *elf)
 
 			pnamelen = coldstr - sym->name;
 			pname = strndup(sym->name, pnamelen);
-			if (!pname) {
-				WARN("%s(): failed to allocate memory",
-				     sym->name);
-				return -1;
-			}
+			ERROR_ON(!pname, "strndup");
 
 			pfunc = find_symbol_by_name(elf, pname);
-			free(pname);
+			if (!pfunc)
+				ERROR("%s(): can't find parent function", sym->name);
 
-			if (!pfunc) {
-				WARN("%s(): can't find parent function",
-				     sym->name);
-				return -1;
-			}
+			free(pname);
 
 			sym->pfunc = pfunc;
 			pfunc->cfunc = sym;
@@ -561,25 +525,17 @@ static int read_symbols(struct elf *elf)
 			}
 		}
 	}
-
-	return 0;
-
-err:
-	free(sym);
-	return -1;
 }
 
 /*
  * @sym's idx has changed.  Update the relocs which reference it.
  */
-static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
+static void elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 {
 	struct reloc *reloc;
 
 	for (reloc = sym->relocs; reloc; reloc = reloc->sym_next_reloc)
 		set_reloc_sym(elf, reloc, reloc->sym->idx);
-
-	return 0;
 }
 
 /*
@@ -590,7 +546,7 @@ static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
  * If no data block is found, allow adding a new data block provided the index
  * is only one past the end.
  */
-static int elf_update_symbol(struct elf *elf, struct section *symtab,
+static void elf_update_symbol(struct elf *elf, struct section *symtab,
 			     struct section *symtab_shndx, struct symbol *sym)
 {
 	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
@@ -605,17 +561,13 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 		shndx = sym->sym.st_shndx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return -1;
-	}
+	if (!s)
+		ERROR_ELF("elf_getscn");
 
 	if (symtab_shndx) {
 		t = elf_getscn(elf->elf, symtab_shndx->idx);
-		if (!t) {
-			WARN_ELF("elf_getscn");
-			return -1;
-		}
+		if (!t)
+			ERROR_ELF("elf_getscn");
 	}
 
 	for (;;) {
@@ -634,11 +586,9 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 			int num = max(1U, sym->idx/3);
 			void *buf;
 
-			if (idx) {
-				/* we don't do holes in symbol tables */
-				WARN("index out of range");
-				return -1;
-			}
+			/* we don't do holes in symbol tables */
+			if (idx)
+				ERROR("index out of range");
 
 			/* if @idx == 0, it's the next contiguous entry, create it */
 			symtab_data = elf_newdata(s);
@@ -646,10 +596,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 				shndx_data = elf_newdata(t);
 
 			buf = calloc(num, entsize);
-			if (!buf) {
-				WARN("malloc");
-				return -1;
-			}
+			ERROR_ON(!buf, "calloc");
 
 			symtab_data->d_buf = buf;
 			symtab_data->d_size = num * entsize;
@@ -661,10 +608,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 
 			if (t) {
 				buf = calloc(num, sizeof(Elf32_Word));
-				if (!buf) {
-					WARN("malloc");
-					return -1;
-				}
+				ERROR_ON(!buf, "calloc");
 
 				shndx_data->d_buf = buf;
 				shndx_data->d_size = num * sizeof(Elf32_Word);
@@ -679,10 +623,8 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 		}
 
 		/* empty blocks should not happen */
-		if (!symtab_data->d_size) {
-			WARN("zero size data");
-			return -1;
-		}
+		if (!symtab_data->d_size)
+			ERROR("zero size data");
 
 		/* is this the right block? */
 		max_idx = symtab_data->d_size / entsize;
@@ -694,10 +636,8 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	}
 
 	/* something went side-ways */
-	if (idx < 0) {
-		WARN("negative index");
-		return -1;
-	}
+	if (idx < 0)
+		ERROR("negative index");
 
 	/* setup extended section index magic and write the symbol */
 	if ((shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) || is_special_shndx) {
@@ -706,18 +646,12 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 			shndx = 0;
 	} else {
 		sym->sym.st_shndx = SHN_XINDEX;
-		if (!shndx_data) {
-			WARN("no .symtab_shndx");
-			return -1;
-		}
+		if (!shndx_data)
+			ERROR("no .symtab_shndx");
 	}
 
-	if (!gelf_update_symshndx(symtab_data, shndx_data, idx, &sym->sym, shndx)) {
-		WARN_ELF("gelf_update_symshndx");
-		return -1;
-	}
-
-	return 0;
+	if (!gelf_update_symshndx(symtab_data, shndx_data, idx, &sym->sym, shndx))
+		ERROR_ELF("gelf_update_symshndx");
 }
 
 static struct symbol *
@@ -728,12 +662,10 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 	struct symbol *old;
 
 	symtab = find_section_by_name(elf, ".symtab");
-	if (symtab) {
-		symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-	} else {
-		WARN("no .symtab");
-		return NULL;
-	}
+	if (!symtab)
+		ERROR("no symtab");
+
+	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
 
 	new_idx = sec_num_entries(symtab);
 
@@ -752,13 +684,9 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 		elf_hash_add(symbol, &old->hash, new_idx);
 		old->idx = new_idx;
 
-		if (elf_update_symbol(elf, symtab, symtab_shndx, old)) {
-			WARN("elf_update_symbol move");
-			return NULL;
-		}
+		elf_update_symbol(elf, symtab, symtab_shndx, old);
 
-		if (elf_update_sym_relocs(elf, old))
-			return NULL;
+		elf_update_sym_relocs(elf, old);
 
 		new_idx = first_non_local;
 	}
@@ -770,10 +698,7 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 non_local:
 	sym->idx = new_idx;
-	if (elf_update_symbol(elf, symtab, symtab_shndx, sym)) {
-		WARN("elf_update_symbol");
-		return NULL;
-	}
+	elf_update_symbol(elf, symtab, symtab_shndx, sym);
 
 	symtab->sh.sh_size += symtab->sh.sh_entsize;
 	mark_sec_changed(elf, symtab, true);
@@ -789,12 +714,10 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 static struct symbol *
 elf_create_section_symbol(struct elf *elf, struct section *sec)
 {
-	struct symbol *sym = calloc(1, sizeof(*sym));
+	struct symbol *sym;
 
-	if (!sym) {
-		perror("malloc");
-		return NULL;
-	}
+	sym = calloc(1, sizeof(*sym));
+	ERROR_ON(!sym, "calloc");
 
 	sym->name = sec->name;
 	sym->sec = sec;
@@ -806,8 +729,7 @@ elf_create_section_symbol(struct elf *elf, struct section *sec)
 	// st_size 0
 
 	sym = __elf_create_symbol(elf, sym);
-	if (sym)
-		elf_add_symbol(elf, sym);
+	elf_add_symbol(elf, sym);
 
 	return sym;
 }
@@ -821,10 +743,7 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
 	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
 	char *name = malloc(namelen);
 
-	if (!sym || !name) {
-		perror("malloc");
-		return NULL;
-	}
+	ERROR_ON(!sym || !name, "malloc");
 
 	snprintf(name, namelen, "__pfx_%s", orig->name);
 
@@ -837,8 +756,7 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
 	sym->sym.st_size = size;
 
 	sym = __elf_create_symbol(elf, sym);
-	if (sym)
-		elf_add_symbol(elf, sym);
+	elf_add_symbol(elf, sym);
 
 	return sym;
 }
@@ -850,19 +768,15 @@ static struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 {
 	struct reloc *reloc, empty = { 0 };
 
-	if (reloc_idx >= sec_num_entries(rsec)) {
-		WARN("%s: bad reloc_idx %u for %s with %d relocs",
-		     __func__, reloc_idx, rsec->name, sec_num_entries(rsec));
-		return NULL;
-	}
+	if (reloc_idx >= sec_num_entries(rsec))
+		ERROR("bad reloc_idx %u for %s with %d relocs",
+		      reloc_idx, rsec->name, sec_num_entries(rsec));
 
 	reloc = &rsec->relocs[reloc_idx];
 
-	if (memcmp(reloc, &empty, sizeof(empty))) {
-		WARN("%s: %s: reloc %d already initialized!",
-		     __func__, rsec->name, reloc_idx);
-		return NULL;
-	}
+	if (memcmp(reloc, &empty, sizeof(empty)))
+		ERROR("%s: reloc %d already initialized!",
+		      rsec->name, reloc_idx);
 
 	reloc->sec = rsec;
 	reloc->sym = sym;
@@ -880,19 +794,16 @@ static struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 }
 
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
-				      unsigned long offset,
-				      unsigned int reloc_idx,
-				      struct section *insn_sec,
-				      unsigned long insn_off)
+				    unsigned long offset,
+				    unsigned int reloc_idx,
+				    struct section *insn_sec,
+				    unsigned long insn_off)
 {
 	struct symbol *sym = insn_sec->sym;
 	int addend = insn_off;
 
-	if (!is_text_section(insn_sec)) {
-		WARN("bad call to %s() for data symbol %s",
-		     __func__, sym->name);
-		return NULL;
-	}
+	if (!is_text_section(insn_sec))
+		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
 
 	if (!sym) {
 		/*
@@ -902,8 +813,6 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 		 * non-weak function after linking.
 		 */
 		sym = elf_create_section_symbol(elf, insn_sec);
-		if (!sym)
-			return NULL;
 
 		insn_sec->sym = sym;
 	}
@@ -918,17 +827,14 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend)
 {
-	if (is_text_section(sec)) {
-		WARN("bad call to %s() for text symbol %s",
-		     __func__, sym->name);
-		return NULL;
-	}
+	if (is_text_section(sec))
+		ERROR("bad call to %s() for text symbol %s", __func__, sym->name);
 
 	return elf_init_reloc(elf, sec->rsec, reloc_idx, offset, sym, addend,
 			      elf_data_rela_type(elf));
 }
 
-static int read_relocs(struct elf *elf)
+static void read_relocs(struct elf *elf)
 {
 	unsigned long nr_reloc, max_reloc = 0;
 	struct section *rsec;
@@ -937,39 +843,31 @@ static int read_relocs(struct elf *elf)
 	struct symbol *sym;
 	int i;
 
-	if (!elf_alloc_hash(reloc, elf->num_relocs))
-		return -1;
+	elf_alloc_hash(reloc, elf->num_relocs);
 
 	list_for_each_entry(rsec, &elf->sections, list) {
 		if (!is_reloc_section(rsec))
 			continue;
 
 		rsec->base = find_section_by_index(elf, rsec->sh.sh_info);
-		if (!rsec->base) {
-			WARN("can't find base section for reloc section %s",
-			     rsec->name);
-			return -1;
-		}
+		if (!rsec->base)
+			ERROR("can't find base section for reloc section %s", rsec->name);
 
 		rsec->base->rsec = rsec;
 
 		nr_reloc = 0;
 		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(*reloc));
-		if (!rsec->relocs) {
-			perror("calloc");
-			return -1;
-		}
+		ERROR_ON(!rsec->relocs, "calloc");
+
 		for (i = 0; i < sec_num_entries(rsec); i++) {
 			reloc = &rsec->relocs[i];
 
 			reloc->sec = rsec;
 			symndx = reloc_sym(reloc);
 			reloc->sym = sym = find_symbol_by_index(elf, symndx);
-			if (!reloc->sym) {
-				WARN("can't find reloc entry symbol %d for %s",
-				     symndx, rsec->name);
-				return -1;
-			}
+			if (!reloc->sym)
+				ERROR("can't find reloc entry symbol %d for %s",
+				      symndx, rsec->name);
 
 			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
 			reloc->sym_next_reloc = sym->relocs;
@@ -985,8 +883,6 @@ static int read_relocs(struct elf *elf)
 		printf("num_relocs: %lu\n", elf->num_relocs);
 		printf("reloc_bits: %d\n", elf->reloc_bits);
 	}
-
-	return 0;
 }
 
 struct elf *elf_open_read(const char *name, int flags)
@@ -999,21 +895,13 @@ struct elf *elf_open_read(const char *name, int flags)
 
 	elf_version(EV_CURRENT);
 
-	elf = malloc(sizeof(*elf));
-	if (!elf) {
-		perror("malloc");
-		return NULL;
-	}
-	memset(elf, 0, sizeof(*elf));
+	elf = calloc(1, sizeof(*elf));
+	ERROR_ON(!elf, "calloc");
 
 	INIT_LIST_HEAD(&elf->sections);
 
 	elf->fd = open(name, flags);
-	if (elf->fd == -1) {
-		fprintf(stderr, "objtool: Can't open '%s': %s\n",
-			name, strerror(errno));
-		goto err;
-	}
+	ERROR_ON(elf->fd == -1, "can't open '%s': %s", name, strerror(errno));
 
 	if ((flags & O_ACCMODE) == O_RDONLY)
 		cmd = ELF_C_READ_MMAP;
@@ -1023,30 +911,19 @@ struct elf *elf_open_read(const char *name, int flags)
 		cmd = ELF_C_WRITE;
 
 	elf->elf = elf_begin(elf->fd, cmd, NULL);
-	if (!elf->elf) {
-		WARN_ELF("elf_begin");
-		goto err;
-	}
+	if (!elf->elf)
+		ERROR_ELF("elf_begin");
 
-	if (!gelf_getehdr(elf->elf, &elf->ehdr)) {
-		WARN_ELF("gelf_getehdr");
-		goto err;
-	}
+	if (!gelf_getehdr(elf->elf, &elf->ehdr))
+		ERROR_ELF("gelf_getehdr");
 
-	if (read_sections(elf))
-		goto err;
+	read_sections(elf);
 
-	if (read_symbols(elf))
-		goto err;
+	read_symbols(elf);
 
-	if (read_relocs(elf))
-		goto err;
+	read_relocs(elf);
 
 	return elf;
-
-err:
-	elf_close(elf);
-	return NULL;
 }
 
 static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
@@ -1055,24 +932,19 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
 	Elf_Scn *s;
 	int len;
 
-	if (!strtab)
-		strtab = find_section_by_name(elf, ".strtab");
 	if (!strtab) {
-		WARN("can't find .strtab section");
-		return -1;
+		strtab = find_section_by_name(elf, ".strtab");
+		if (!strtab)
+			ERROR("can't find .strtab section");
 	}
 
 	s = elf_getscn(elf->elf, strtab->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return -1;
-	}
+	if (!s)
+		ERROR_ELF("elf_getscn");
 
 	data = elf_newdata(s);
-	if (!data) {
-		WARN_ELF("elf_newdata");
-		return -1;
-	}
+	if (!data)
+		ERROR_ELF("elf_newdata");
 
 	data->d_buf = strdup(str);
 	data->d_size = strlen(str) + 1;
@@ -1094,50 +966,34 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 	Elf_Scn *s;
 
 	sec = malloc(sizeof(*sec));
-	if (!sec) {
-		perror("malloc");
-		return NULL;
-	}
+	ERROR_ON(!sec, "malloc");
 	memset(sec, 0, sizeof(*sec));
 
 	INIT_LIST_HEAD(&sec->symbol_list);
 
 	s = elf_newscn(elf->elf);
-	if (!s) {
-		WARN_ELF("elf_newscn");
-		return NULL;
-	}
+	if (!s)
+		ERROR_ELF("elf_newscn");
 
 	sec->name = strdup(name);
-	if (!sec->name) {
-		perror("strdup");
-		return NULL;
-	}
+	ERROR_ON(!sec->name, "strdup");
 
 	sec->idx = elf_ndxscn(s);
 
 	sec->data = elf_newdata(s);
-	if (!sec->data) {
-		WARN_ELF("elf_newdata");
-		return NULL;
-	}
+	if (!sec->data)
+		ERROR_ELF("elf_newdata");
 
 	sec->data->d_size = size;
 	sec->data->d_align = 1;
 
 	if (size) {
-		sec->data->d_buf = malloc(size);
-		if (!sec->data->d_buf) {
-			perror("malloc");
-			return NULL;
-		}
-		memset(sec->data->d_buf, 0, size);
+		sec->data->d_buf = calloc(1, size);
+		ERROR_ON(!sec->data->d_buf, "calloc");
 	}
 
-	if (!gelf_getshdr(s, &sec->sh)) {
-		WARN_ELF("gelf_getshdr");
-		return NULL;
-	}
+	if (!gelf_getshdr(s, &sec->sh))
+		ERROR_ELF("gelf_getshdr");
 
 	sec->sh.sh_size = size;
 	sec->sh.sh_entsize = entsize;
@@ -1147,15 +1003,12 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 
 	/* Add section name to .shstrtab (or .strtab for Clang) */
 	shstrtab = find_section_by_name(elf, ".shstrtab");
-	if (!shstrtab)
-		shstrtab = find_section_by_name(elf, ".strtab");
 	if (!shstrtab) {
-		WARN("can't find .shstrtab or .strtab section");
-		return NULL;
+		shstrtab = find_section_by_name(elf, ".strtab");
+		if (!shstrtab)
+			ERROR("can't find .shstrtab or .strtab section");
 	}
 	sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
-	if (sec->sh.sh_name == -1)
-		return NULL;
 
 	list_add_tail(&sec->list, &elf->sections);
 	elf_hash_add(section, &sec->hash, sec->idx);
@@ -1174,17 +1027,13 @@ static struct section *elf_create_rela_section(struct elf *elf,
 	char *rsec_name;
 
 	rsec_name = malloc(strlen(sec->name) + strlen(".rela") + 1);
-	if (!rsec_name) {
-		perror("malloc");
-		return NULL;
-	}
+	ERROR_ON(!rsec_name, "malloc");
+
 	strcpy(rsec_name, ".rela");
 	strcat(rsec_name, sec->name);
 
 	rsec = elf_create_section(elf, rsec_name, elf_rela_size(elf), reloc_nr);
 	free(rsec_name);
-	if (!rsec)
-		return NULL;
 
 	rsec->data->d_type = ELF_T_RELA;
 	rsec->sh.sh_type = SHT_RELA;
@@ -1194,10 +1043,7 @@ static struct section *elf_create_rela_section(struct elf *elf,
 	rsec->sh.sh_flags = SHF_INFO_LINK;
 
 	rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
-	if (!rsec->relocs) {
-		perror("calloc");
-		return NULL;
-	}
+	ERROR_ON(!rsec->relocs, "calloc");
 
 	sec->rsec = rsec;
 	rsec->base = sec;
@@ -1212,31 +1058,22 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
 	struct section *sec;
 
 	sec = elf_create_section(elf, name, entsize, nr);
-	if (!sec)
-		return NULL;
-
-	if (!elf_create_rela_section(elf, sec, reloc_nr))
-		return NULL;
-
+	elf_create_rela_section(elf, sec, reloc_nr);
 	return sec;
 }
 
-int elf_write_insn(struct elf *elf, struct section *sec,
-		   unsigned long offset, unsigned int len,
-		   const char *insn)
+void elf_write_insn(struct elf *elf, struct section *sec,
+		    unsigned long offset, unsigned int len,
+		    const char *insn)
 {
 	Elf_Data *data = sec->data;
 
-	if (data->d_type != ELF_T_BYTE || data->d_off) {
-		WARN("write to unexpected data for section: %s", sec->name);
-		return -1;
-	}
+	if (data->d_type != ELF_T_BYTE || data->d_off)
+		ERROR("write to unexpected data for section: %s", sec->name);
 
 	memcpy(data->d_buf + offset, insn, len);
 
 	mark_sec_changed(elf, sec, true);
-
-	return 0;
 }
 
 /*
@@ -1248,7 +1085,7 @@ int elf_write_insn(struct elf *elf, struct section *sec,
  *
  * Yes, libelf sucks and we need to manually truncate if we over-allocate data.
  */
-static int elf_truncate_section(struct elf *elf, struct section *sec)
+static void elf_truncate_section(struct elf *elf, struct section *sec)
 {
 	u64 size = sec_size(sec);
 	bool truncated = false;
@@ -1256,33 +1093,25 @@ static int elf_truncate_section(struct elf *elf, struct section *sec)
 	Elf_Scn *s;
 
 	s = elf_getscn(elf->elf, sec->idx);
-	if (!s) {
-		WARN_ELF("elf_getscn");
-		return -1;
-	}
+	if (!s)
+		ERROR_ELF("elf_getscn");
 
 	for (;;) {
 		/* get next data descriptor for the relevant section */
 		data = elf_getdata(s, data);
 
 		if (!data) {
-			if (size) {
-				WARN("end of section data but non-zero size left\n");
-				return -1;
-			}
-			return 0;
+			if (size)
+				ERROR("end of section data but non-zero size left");
+			return;
 		}
 
-		if (truncated) {
-			/* when we remove symbols */
-			WARN("truncated; but more data\n");
-			return -1;
-		}
+		/* when we remove symbols */
+		if (truncated)
+			ERROR("truncated; but more data");
 
-		if (!data->d_size) {
-			WARN("zero size data");
-			return -1;
-		}
+		if (!data->d_size)
+			ERROR("zero size data");
 
 		if (data->d_size > size) {
 			truncated = true;
@@ -1293,13 +1122,13 @@ static int elf_truncate_section(struct elf *elf, struct section *sec)
 	}
 }
 
-int elf_write(struct elf *elf)
+void elf_write(struct elf *elf)
 {
 	struct section *sec;
 	Elf_Scn *s;
 
 	if (opts.dryrun)
-		return 0;
+		return;
 
 	/* Update changed relocation sections and section headers: */
 	list_for_each_entry(sec, &elf->sections, list) {
@@ -1308,16 +1137,12 @@ int elf_write(struct elf *elf)
 
 		if (sec_changed(sec)) {
 			s = elf_getscn(elf->elf, sec->idx);
-			if (!s) {
-				WARN_ELF("elf_getscn");
-				return -1;
-			}
+			if (!s)
+				ERROR_ELF("elf_getscn");
 
 			/* Note this also flags the section dirty */
-			if (!gelf_update_shdr(s, &sec->sh)) {
-				WARN_ELF("gelf_update_shdr");
-				return -1;
-			}
+			if (!gelf_update_shdr(s, &sec->sh))
+				ERROR_ELF("gelf_update_shdr");
 
 			mark_sec_changed(elf, sec, false);
 		}
@@ -1327,14 +1152,10 @@ int elf_write(struct elf *elf)
 	elf_flagelf(elf->elf, ELF_C_SET, ELF_F_DIRTY);
 
 	/* Write all changes to the file. */
-	if (elf_update(elf->elf, ELF_C_WRITE) < 0) {
-		WARN_ELF("elf_update");
-		return -1;
-	}
+	if (elf_update(elf->elf, ELF_C_WRITE) < 0)
+		ERROR_ELF("elf_update");
 
 	elf->changed = false;
-
-	return 0;
 }
 
 void elf_close(struct elf *elf)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 0c2af699b1bf..8585b9802e1b 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -128,10 +128,10 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend);
 
-int elf_write_insn(struct elf *elf, struct section *sec,
-		   unsigned long offset, unsigned int len,
-		   const char *insn);
-int elf_write(struct elf *elf);
+void elf_write_insn(struct elf *elf, struct section *sec,
+		    unsigned long offset, unsigned int len,
+		    const char *insn);
+void elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 
 struct section *find_section_by_name(const struct elf *elf, const char *name);
diff --git a/tools/objtool/include/objtool/orc.h b/tools/objtool/include/objtool/orc.h
index 15a32def1071..32f313cd30a2 100644
--- a/tools/objtool/include/objtool/orc.h
+++ b/tools/objtool/include/objtool/orc.h
@@ -4,11 +4,11 @@
 
 #include <objtool/check.h>
 
-int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn);
+void init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn);
 void orc_print_dump(struct elf *dummy_elf, struct orc_entry *orc, int i);
-int write_orc_entry(struct elf *elf, struct section *orc_sec,
-		    struct section *ip_sec, unsigned int idx,
-		    struct section *insn_sec, unsigned long insn_off,
-		    struct orc_entry *o);
+void write_orc_entry(struct elf *elf, struct section *orc_sec,
+		     struct section *ip_sec, unsigned int idx,
+		     struct section *insn_sec, unsigned long insn_off,
+		     struct orc_entry *o);
 
 #endif /* _OBJTOOL_ORC_H */
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 86d4af9c5aa9..30898278d904 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -30,7 +30,7 @@ struct special_alt {
 	unsigned int orig_len, new_len; /* group only */
 };
 
-int special_get_alts(struct elf *elf, struct list_head *alts);
+void special_get_alts(struct elf *elf, struct list_head *alts);
 
 void arch_handle_alternative(unsigned short feature, struct special_alt *alt);
 
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index 69995f84f91b..28a475c4eb03 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -48,7 +48,7 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 		"%s: warning: objtool: " format "\n",	\
 		filename, ##__VA_ARGS__)
 
-#define WARN_FUNC(format, sec, offset, ...)		\
+#define WARN_FUNC(sec, offset, format, ...)		\
 ({							\
 	char *_str = offstr(sec, offset);		\
 	WARN("%s: " format, _str, ##__VA_ARGS__);	\
@@ -59,12 +59,21 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 ({									\
 	struct instruction *_insn = (insn);				\
 	if (!_insn->sym || !_insn->sym->warned)				\
-		WARN_FUNC(format, _insn->sec, _insn->offset,		\
+		WARN_FUNC(_insn->sec, _insn->offset, format,		\
 			  ##__VA_ARGS__);				\
 	if (_insn->sym)							\
 		_insn->sym->warned = 1;					\
 })
 
+#define WARN_ONCE(format, ...)						\
+({									\
+	static bool warned;						\
+	if (!warned) {							\
+		warned = true;						\
+		WARN(format, ##__VA_ARGS__);				\
+	}								\
+})
+
 #define BT_INSN(insn, format, ...)				\
 ({								\
 	if (opts.verbose || opts.backtrace) {			\
@@ -78,4 +87,33 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define WARN_ELF(format, ...)				\
 	WARN(format ": %s", ##__VA_ARGS__, elf_errmsg(-1))
 
+#define ERROR(format, ...)						\
+({									\
+	fprintf(stderr,							\
+		"%s: error: objtool [%s:%d]: " format "\n",		\
+		Objname, __FILE__, __LINE__, ##__VA_ARGS__);		\
+	exit(1);							\
+})
+
+#define ERROR_ON(cond, format, ...)					\
+({									\
+	if (cond)							\
+		ERROR(format, ##__VA_ARGS__);				\
+})
+
+#define ERROR_ELF(format, ...)						\
+	ERROR(format ": %s", ##__VA_ARGS__, elf_errmsg(-1))
+
+#define ERROR_FUNC(sec, offset, format, ...)				\
+({									\
+	char *_str = offstr(sec, offset);				\
+	ERROR("%s: " format, _str, ##__VA_ARGS__);			\
+})
+
+#define ERROR_INSN(insn, format, ...)					\
+({									\
+	struct instruction *_insn = (insn);				\
+	ERROR_FUNC(_insn->sec, _insn->offset, format, ##__VA_ARGS__);	\
+})
+
 #endif /* _WARN_H */
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index 6d2102450b35..06f7e518b8a7 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -8,6 +8,8 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <errno.h>
+
 #include <subcmd/exec-cmd.h>
 #include <subcmd/pager.h>
 #include <linux/kernel.h>
@@ -21,82 +23,59 @@ bool help;
 char *Objname;
 static struct objtool_file file;
 
-static bool objtool_create_backup(const char *objname)
+static void objtool_create_backup(const char *objname)
 {
 	int len = strlen(objname);
 	char *buf, *base, *name = malloc(len+6);
 	int s, d, l, t;
 
-	if (!name) {
-		perror("failed backup name malloc");
-		return false;
-	}
+	name = malloc(len+6);
+	ERROR_ON(!name, "malloc");
 
 	strcpy(name, objname);
 	strcpy(name + len, ".orig");
 
 	d = open(name, O_CREAT|O_WRONLY|O_TRUNC, 0644);
-	if (d < 0) {
-		perror("failed to create backup file");
-		return false;
-	}
+	ERROR_ON(d < 0, "can't create '%s': %s", name, strerror(errno));
 
 	s = open(objname, O_RDONLY);
-	if (s < 0) {
-		perror("failed to open orig file");
-		return false;
-	}
+	ERROR_ON(s < 0, "can't open '%s': %s", objname, strerror(errno));
 
 	buf = malloc(4096);
-	if (!buf) {
-		perror("failed backup data malloc");
-		return false;
-	}
+	ERROR_ON(!buf, "malloc");
 
 	while ((l = read(s, buf, 4096)) > 0) {
 		base = buf;
 		do {
 			t = write(d, base, l);
-			if (t < 0) {
-				perror("failed backup write");
-				return false;
-			}
+			ERROR_ON(t < 0, "failed backup write");
+
 			base += t;
 			l -= t;
 		} while (l);
 	}
 
-	if (l < 0) {
-		perror("failed backup read");
-		return false;
-	}
+	ERROR_ON(l < 0, "failed backup read");
 
 	free(name);
 	free(buf);
 	close(d);
 	close(s);
-
-	return true;
 }
 
 struct objtool_file *objtool_open_read(const char *objname)
 {
 	if (Objname) {
-		if (strcmp(Objname, objname)) {
-			WARN("won't handle more than one file at a time");
-			return NULL;
-		}
+		if (strcmp(Objname, objname))
+			ERROR("won't handle more than one file at a time");
+
 		return &file;
 	}
 
 	file.elf = elf_open_read(objname, O_RDWR);
-	if (!file.elf)
-		return NULL;
 
-	if (opts.backup && !objtool_create_backup(objname)) {
-		WARN("can't create backup file");
-		return NULL;
-	}
+	if (opts.backup)
+		objtool_create_backup(objname);
 
 	hash_init(file.insn_hash);
 	INIT_LIST_HEAD(&file.retpoline_call_list);
@@ -116,10 +95,8 @@ void objtool_pv_add(struct objtool_file *f, int idx, struct symbol *func)
 	if (!opts.noinstr)
 		return;
 
-	if (!f->pv_ops) {
-		WARN("paravirt confusion");
-		return;
-	}
+	if (!f->pv_ops)
+		ERROR("paravirt confusion");
 
 	/*
 	 * These functions will be patched into native code,
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 9c0b9d8a34fe..9fd176b7a35c 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -32,56 +32,38 @@ int orc_dump(const char *objname)
 	elf_version(EV_CURRENT);
 
 	fd = open(objname, O_RDONLY);
-	if (fd == -1) {
-		perror("open");
-		return -1;
-	}
+	ERROR_ON(fd == -1, "open");
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
-	if (!elf) {
-		WARN_ELF("elf_begin");
-		return -1;
-	}
+	if (!elf)
+		ERROR_ELF("elf_begin");
+
+	if (!elf64_getehdr(elf))
+		ERROR_ELF("elf64_getehdr");
 
-	if (!elf64_getehdr(elf)) {
-		WARN_ELF("elf64_getehdr");
-		return -1;
-	}
 	memcpy(&dummy_elf.ehdr, elf64_getehdr(elf), sizeof(dummy_elf.ehdr));
 
-	if (elf_getshdrnum(elf, &nr_sections)) {
-		WARN_ELF("elf_getshdrnum");
-		return -1;
-	}
+	if (elf_getshdrnum(elf, &nr_sections))
+		ERROR_ELF("elf_getshdrnum");
 
-	if (elf_getshdrstrndx(elf, &shstrtab_idx)) {
-		WARN_ELF("elf_getshdrstrndx");
-		return -1;
-	}
+	if (elf_getshdrstrndx(elf, &shstrtab_idx))
+		ERROR_ELF("elf_getshdrstrndx");
 
 	for (i = 0; i < nr_sections; i++) {
 		scn = elf_getscn(elf, i);
-		if (!scn) {
-			WARN_ELF("elf_getscn");
-			return -1;
-		}
+		if (!scn)
+			ERROR_ELF("elf_getscn");
 
-		if (!gelf_getshdr(scn, &sh)) {
-			WARN_ELF("gelf_getshdr");
-			return -1;
-		}
+		if (!gelf_getshdr(scn, &sh))
+			ERROR_ELF("gelf_getshdr");
 
 		name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
-		if (!name) {
-			WARN_ELF("elf_strptr");
-			return -1;
-		}
+		if (!name)
+			ERROR_ELF("elf_strptr");
 
 		data = elf_getdata(scn, NULL);
-		if (!data) {
-			WARN_ELF("elf_getdata");
-			return -1;
-		}
+		if (!data)
+			ERROR_ELF("elf_getdata");
 
 		if (!strcmp(name, ".symtab")) {
 			symtab = data;
@@ -101,47 +83,33 @@ int orc_dump(const char *objname)
 	if (!symtab || !strtab_idx || !orc || !orc_ip)
 		return 0;
 
-	if (orc_size % sizeof(*orc) != 0) {
-		WARN("bad .orc_unwind section size");
-		return -1;
-	}
+	if (orc_size % sizeof(*orc) != 0)
+		ERROR("bad .orc_unwind section size");
 
 	nr_entries = orc_size / sizeof(*orc);
 	for (i = 0; i < nr_entries; i++) {
 		if (rela_orc_ip) {
-			if (!gelf_getrela(rela_orc_ip, i, &rela)) {
-				WARN_ELF("gelf_getrela");
-				return -1;
-			}
+			if (!gelf_getrela(rela_orc_ip, i, &rela))
+				ERROR_ELF("gelf_getrela");
 
-			if (!gelf_getsym(symtab, GELF_R_SYM(rela.r_info), &sym)) {
-				WARN_ELF("gelf_getsym");
-				return -1;
-			}
+			if (!gelf_getsym(symtab, GELF_R_SYM(rela.r_info), &sym))
+				ERROR_ELF("gelf_getsym");
 
 			if (GELF_ST_TYPE(sym.st_info) == STT_SECTION) {
 				scn = elf_getscn(elf, sym.st_shndx);
-				if (!scn) {
-					WARN_ELF("elf_getscn");
-					return -1;
-				}
+				if (!scn)
+					ERROR_ELF("elf_getscn");
 
-				if (!gelf_getshdr(scn, &sh)) {
-					WARN_ELF("gelf_getshdr");
-					return -1;
-				}
+				if (!gelf_getshdr(scn, &sh))
+					ERROR_ELF("gelf_getshdr");
 
 				name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
-				if (!name) {
-					WARN_ELF("elf_strptr");
-					return -1;
-				}
+				if (!name)
+					ERROR_ELF("elf_strptr");
 			} else {
 				name = elf_strptr(elf, strtab_idx, sym.st_name);
-				if (!name) {
-					WARN_ELF("elf_strptr");
-					return -1;
-				}
+				if (!name)
+					ERROR_ELF("elf_strptr");
 			}
 
 			printf("%s+%llx:", name, (unsigned long long)rela.r_addend);
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 6eff3d6a125c..56aca3845e20 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -21,22 +21,19 @@ struct orc_list_entry {
 	unsigned long insn_off;
 };
 
-static int orc_list_add(struct list_head *orc_list, struct orc_entry *orc,
+static void orc_list_add(struct list_head *orc_list, struct orc_entry *orc,
 			struct section *sec, unsigned long offset)
 {
-	struct orc_list_entry *entry = malloc(sizeof(*entry));
+	struct orc_list_entry *entry;
 
-	if (!entry) {
-		WARN("malloc failed");
-		return -1;
-	}
+	entry = malloc(sizeof(*entry));
+	ERROR_ON(!entry, "malloc");
 
 	entry->orc	= *orc;
 	entry->insn_sec = sec;
 	entry->insn_off = offset;
 
 	list_add_tail(&entry->list, orc_list);
-	return 0;
 }
 
 static unsigned long alt_group_len(struct alt_group *alt_group)
@@ -70,13 +67,13 @@ int orc_create(struct objtool_file *file)
 			int i;
 
 			if (!alt_group) {
-				if (init_orc_entry(&orc, insn->cfi, insn))
-					return -1;
+				init_orc_entry(&orc, insn->cfi, insn);
+
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;
-				if (orc_list_add(&orc_list, &orc, sec,
-						 insn->offset))
-					return -1;
+
+				orc_list_add(&orc_list, &orc, sec, insn->offset);
+
 				nr++;
 				prev_orc = orc;
 				empty = false;
@@ -95,13 +92,10 @@ int orc_create(struct objtool_file *file)
 				if (!cfi)
 					continue;
 				/* errors are reported on the original insn */
-				if (init_orc_entry(&orc, cfi, insn))
-					return -1;
+				init_orc_entry(&orc, cfi, insn);
 				if (!memcmp(&prev_orc, &orc, sizeof(orc)))
 					continue;
-				if (orc_list_add(&orc_list, &orc, insn->sec,
-						 insn->offset + i))
-					return -1;
+				orc_list_add(&orc_list, &orc, insn->sec, insn->offset + i);
 				nr++;
 				prev_orc = orc;
 				empty = false;
@@ -124,23 +118,17 @@ int orc_create(struct objtool_file *file)
 	sec = find_section_by_name(file->elf, ".orc_unwind");
 	if (sec) {
 		WARN("file already has .orc_unwind section, skipping");
-		return -1;
+		return 0;
 	}
 	orc_sec = elf_create_section(file->elf, ".orc_unwind",
 				     sizeof(struct orc_entry), nr);
-	if (!orc_sec)
-		return -1;
 
 	sec = elf_create_section_pair(file->elf, ".orc_unwind_ip", sizeof(int), nr, nr);
-	if (!sec)
-		return -1;
 
 	/* Write ORC entries to sections: */
 	list_for_each_entry(entry, &orc_list, list) {
-		if (write_orc_entry(file->elf, orc_sec, sec, idx++,
-				    entry->insn_sec, entry->insn_off,
-				    &entry->orc))
-			return -1;
+		write_orc_entry(file->elf, orc_sec, sec, idx++, entry->insn_sec,
+				entry->insn_off, &entry->orc);
 	}
 
 	return 0;
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index 312d01684e21..9838ad700f37 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -65,9 +65,9 @@ static void reloc_to_sec_off(struct reloc *reloc, struct section **sec,
 	*off = reloc->sym->offset + reloc_addend(reloc);
 }
 
-static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
-			 struct section *sec, int idx,
-			 struct special_alt *alt)
+static void get_alt_entry(struct elf *elf, const struct special_entry *entry,
+			  struct section *sec, int idx,
+			  struct special_alt *alt)
 {
 	struct reloc *orig_reloc, *new_reloc;
 	unsigned long offset;
@@ -95,20 +95,15 @@ static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
 	}
 
 	orig_reloc = find_reloc_by_dest(elf, sec, offset + entry->orig);
-	if (!orig_reloc) {
-		WARN_FUNC("can't find orig reloc", sec, offset + entry->orig);
-		return -1;
-	}
+	if (!orig_reloc)
+		ERROR_FUNC(sec, offset + entry->orig, "can't find orig reloc");
 
 	reloc_to_sec_off(orig_reloc, &alt->orig_sec, &alt->orig_off);
 
 	if (!entry->group || alt->new_len) {
 		new_reloc = find_reloc_by_dest(elf, sec, offset + entry->new);
-		if (!new_reloc) {
-			WARN_FUNC("can't find new reloc",
-				  sec, offset + entry->new);
-			return -1;
-		}
+		if (!new_reloc)
+			ERROR_FUNC(sec, offset + entry->new, "can't find new reloc");
 
 		reloc_to_sec_off(new_reloc, &alt->new_sec, &alt->new_off);
 
@@ -121,15 +116,11 @@ static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
 		struct reloc *key_reloc;
 
 		key_reloc = find_reloc_by_dest(elf, sec, offset + entry->key);
-		if (!key_reloc) {
-			WARN_FUNC("can't find key reloc",
-				  sec, offset + entry->key);
-			return -1;
-		}
+		if (!key_reloc)
+			ERROR_FUNC(sec, offset + entry->key, "can't find key reloc");
+
 		alt->key_addend = reloc_addend(key_reloc);
 	}
-
-	return 0;
 }
 
 /*
@@ -137,13 +128,13 @@ static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
  * describe all the alternate instructions which can be patched in or
  * redirected to at runtime.
  */
-int special_get_alts(struct elf *elf, struct list_head *alts)
+void special_get_alts(struct elf *elf, struct list_head *alts)
 {
 	const struct special_entry *entry;
 	struct section *sec;
 	unsigned int nr_entries;
 	struct special_alt *alt;
-	int idx, ret;
+	int idx;
 
 	INIT_LIST_HEAD(alts);
 
@@ -152,31 +143,18 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 		if (!sec)
 			continue;
 
-		if (sec_size(sec) % entry->size != 0) {
-			WARN("%s size not a multiple of %d",
-			     sec->name, entry->size);
-			return -1;
-		}
+		if (sec_size(sec) % entry->size != 0)
+			ERROR("%s size not a multiple of %d", sec->name, entry->size);
 
 		nr_entries = sec_size(sec) / entry->size;
 
 		for (idx = 0; idx < nr_entries; idx++) {
-			alt = malloc(sizeof(*alt));
-			if (!alt) {
-				WARN("malloc failed");
-				return -1;
-			}
-			memset(alt, 0, sizeof(*alt));
+			alt = calloc(1, sizeof(*alt));
+			ERROR_ON(!alt, "calloc");
 
-			ret = get_alt_entry(elf, entry, sec, idx, alt);
-			if (ret > 0)
-				continue;
-			if (ret < 0)
-				return ret;
+			get_alt_entry(elf, entry, sec, idx, alt);
 
 			list_add_tail(&alt->list, alts);
 		}
 	}
-
-	return 0;
 }
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index b568da3c33e6..426fdf0b7548 100644
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -12,7 +12,7 @@
 #define UNSUPPORTED(name)						\
 ({									\
 	fprintf(stderr, "error: objtool: " name " not implemented\n");	\
-	return ENOSYS;							\
+	exit(1);							\
 })
 
 int __weak orc_dump(const char *objname)
-- 
2.45.2


