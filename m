Return-Path: <live-patching+bounces-2792-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YNAEB3nzA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2792-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:43:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFFD52CEB4
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9EC93079D7E
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79823B27C9;
	Wed, 13 May 2026 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPtJ57Ss"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A4C3AE704;
	Wed, 13 May 2026 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643297; cv=none; b=dZp+rnMNajCYj9+PVdgZqLwBscfA7CCp6d+YLXGig0wODGUMRugqD6MqGguqTP+VnN7P7oC3lZyv9yoXkFObk2u5qVZkRd7Umsh5Uan73I0/2obtwupmlrP5X3V3IkjJKoqSYpkOqu/dghtXKWgWMZfMeCZjsFmA2TAAuqlQVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643297; c=relaxed/simple;
	bh=htHqB9fjsGibk8/Z1/tD3h7Th9hfmcAsTtcWLppiK1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0iTgHnmhKqzl5Og4gnRdrECIxTcKGv3gGZHcd9QsOqtudSuCHSn6lJ/etOox6f4w1CDnNqgwrMc1fIQSdgfHK8BZx5zl/cDl1QizZgFrb4fVwGmkoT36u9E2LtVqLfF2wG3aH5fbjRE8c/o9e/NFLEjcuOtJm/UaFIM4KbV2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPtJ57Ss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7F6C2BCFA;
	Wed, 13 May 2026 03:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643297;
	bh=htHqB9fjsGibk8/Z1/tD3h7Th9hfmcAsTtcWLppiK1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPtJ57Ss2C5oeJm5PngBvSj5BfCbp3P4yplAqZ8VoEjLZJSGSZXibJTMM/OfA7MH3
	 grKttNw5o5/7mZFYsP5lonZ44tZFyZjsLC32PPnktBGsVnvgBxYWfsPTtRUWLjN26a
	 PWQMk3M4oUc7lO90sI+G1cd6PXJNumU8xsaYABLQ25QrGIEWErfxQz7whWRctsMPGn
	 ozD5FYtkW/EKryooEDN6mdJWXb8FFDnhTnuK0HYFoo0nRtvhtzSRUl8s40dMNqcmWe
	 arBHvnTXsm800E9L4UvHnKyadiXmLcy7VWkac0ejFNx5P4rBDvepNVQNuFbCYjyfsh
	 ZsAoKd6Iqfnmg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 19/21] objtool/klp: Introduce objtool for arm64
Date: Tue, 12 May 2026 20:34:15 -0700
Message-ID: <5b66146373b1ff1aba1318fd51867dea2eb882f6.1778642121.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDFFD52CEB4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2792-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Add basic support for arm64 on objtool.  Only "objtool klp" subcommands
are currently supported.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/Kconfig                            |   2 +
 tools/objtool/Makefile                        |   4 +
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/decode.c             | 177 ++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  11 ++
 tools/objtool/arch/arm64/include/arch/elf.h   |  15 ++
 .../objtool/arch/arm64/include/arch/special.h |  21 +++
 tools/objtool/arch/arm64/special.c            |  21 +++
 8 files changed, 253 insertions(+)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/special.h
 create mode 100644 tools/objtool/arch/arm64/special.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943b..101080fd4f99e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -210,9 +210,11 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_KLP_BUILD
 	select HAVE_LIVEPATCH
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
+	select HAVE_OBJTOOL
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI if ARM64_PSEUDO_NMI
 	select HAVE_PERF_REGS
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index a4484fd22a96d..94aabeee97367 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -11,6 +11,10 @@ ifeq ($(SRCARCH),loongarch)
 	BUILD_ORC	   := y
 endif
 
+ifeq ($(SRCARCH),arm64)
+	ARCH_HAS_KLP := y
+endif
+
 ifeq ($(ARCH_HAS_KLP),y)
 	HAVE_XXHASH = $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
 		      $(HOSTCC) $(HOSTCFLAGS) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
diff --git a/tools/objtool/arch/arm64/Build b/tools/objtool/arch/arm64/Build
new file mode 100644
index 0000000000000..d24d5636a5b84
--- /dev/null
+++ b/tools/objtool/arch/arm64/Build
@@ -0,0 +1,2 @@
+objtool-y += decode.o
+objtool-y += special.o
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
new file mode 100644
index 0000000000000..47658c76e1af0
--- /dev/null
+++ b/tools/objtool/arch/arm64/decode.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <objtool/check.h>
+#include <objtool/disas.h>
+#include <objtool/elf.h>
+#include <objtool/arch.h>
+#include <objtool/warn.h>
+#include <objtool/builtin.h>
+
+const char *arch_reg_name[CFI_NUM_REGS] = {};
+
+int arch_ftrace_match(const char *name)
+{
+	return 0;
+}
+
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
+{
+	return reloc_addend(reloc);
+}
+
+bool arch_callee_saved_reg(unsigned char reg)
+{
+	return false;
+}
+
+int arch_decode_hint_reg(u8 sp_reg, int *base)
+{
+	exit(-1);
+}
+
+const char *arch_nop_insn(int len)
+{
+	exit(-1);
+}
+
+const char *arch_ret_insn(int len)
+{
+	exit(-1);
+}
+
+int arch_decode_instruction(struct objtool_file *file, const struct section *sec,
+			    unsigned long offset, unsigned int maxlen,
+			    struct instruction *insn)
+{
+	u32 ins;
+
+	if (maxlen < 4) {
+		ERROR_INSN(insn, "can't decode instruction");
+		return -1;
+	}
+
+	/* arm64 instructions are always LE, thus no bswap_if_needed() */
+	ins = le32toh(*(u32 *)(sec->data->d_buf + offset));
+
+	/*
+	 * These are the bare minimum needed for static branch detection and
+	 * checksum calculations.
+	 */
+	if (ins == 0xd503201f) {
+		/* NOP: static branch */
+		insn->type = INSN_NOP;
+	} else if ((ins & 0xfc000000) == 0x14000000) {
+		/* B: static branch, intra-TU sibling call */
+		insn->type = INSN_JUMP_UNCONDITIONAL;
+		insn->immediate = sign_extend64(ins & 0x03ffffff, 25);
+	} else if ((ins & 0xfc000000) == 0x94000000) {
+		/* BL: intra-TU call */
+		insn->type = INSN_CALL;
+		insn->immediate = sign_extend64(ins & 0x03ffffff, 25);
+	} else if ((ins & 0xff000000) == 0x54000000) {
+		/* B.cond: intra-TU sibling call */
+		insn->type = INSN_JUMP_CONDITIONAL;
+		insn->immediate = sign_extend64((ins >> 5) & 0x7ffff, 18);
+	} else if ((ins & 0x7e000000) == 0x34000000) {
+		/* CBZ/CBNZ: intra-TU sibling call */
+		insn->type = INSN_JUMP_CONDITIONAL;
+		insn->immediate = sign_extend64((ins >> 5) & 0x7ffff, 18);
+	} else if ((ins & 0x7e000000) == 0x36000000) {
+		/* TBZ/TBNZ: intra-TU sibling call */
+		insn->type = INSN_JUMP_CONDITIONAL;
+		insn->immediate = sign_extend64((ins >> 5) & 0x3fff, 13);
+	} else {
+		insn->type = INSN_OTHER;
+	}
+
+	insn->len = 4;
+	return 0;
+}
+
+size_t arch_jump_opcode_bytes(struct objtool_file *file, struct instruction *insn,
+			      unsigned char *buf)
+{
+	u32 ins;
+
+	ins = le32toh(*(u32 *)(insn->sec->data->d_buf + insn->offset));
+
+	switch (insn->type) {
+	case INSN_JUMP_UNCONDITIONAL:
+	case INSN_CALL:
+		ins &= ~0x03ffffff;
+		break;
+	case INSN_JUMP_CONDITIONAL:
+		if ((ins & 0xff000000) == 0x54000000)
+			ins &= ~0x00ffffe0;		   /* B.cond */
+		else if ((ins & 0x7e000000) == 0x34000000)
+			ins &= ~0x00ffffe0;		   /* CBZ/CBNZ */
+		else
+			ins &= ~0x0007ffe0;		   /* TBZ/TBNZ */
+		break;
+	default:
+		break;
+	}
+
+	ins = htole32(ins);
+	memcpy(buf, &ins, 4);
+	return 4;
+}
+
+u64 arch_adjusted_addend(struct reloc *reloc)
+{
+	return reloc_addend(reloc);
+}
+
+unsigned long arch_jump_destination(struct instruction *insn)
+{
+	return insn->offset + (insn->immediate << 2);
+}
+
+bool arch_pc_relative_reloc(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+	case R_AARCH64_PREL64:
+	case R_AARCH64_PREL32:
+	case R_AARCH64_PREL16:
+	case R_AARCH64_LD_PREL_LO19:
+	case R_AARCH64_ADR_PREL_LO21:
+	case R_AARCH64_ADR_PREL_PG_HI21:
+	case R_AARCH64_ADR_PREL_PG_HI21_NC:
+	case R_AARCH64_JUMP26:
+	case R_AARCH64_CALL26:
+	case R_AARCH64_CONDBR19:
+	case R_AARCH64_TSTBR14:
+		return true;
+	default:
+		return false;
+	}
+}
+
+void arch_initial_func_cfi_state(struct cfi_init_state *state)
+{
+	state->cfa.base = CFI_UNDEFINED;
+}
+
+unsigned int arch_reloc_size(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+	case R_AARCH64_ABS64:
+	case R_AARCH64_PREL64:
+		return 8;
+	case R_AARCH64_PREL16:
+		return 2;
+	default:
+		return 4;
+	}
+}
+
+#ifdef DISAS
+int arch_disas_info_init(struct disassemble_info *dinfo)
+{
+	return disas_info_init(dinfo, bfd_arch_aarch64,
+			       bfd_mach_arm_unknown, bfd_mach_aarch64,
+			       NULL);
+}
+#endif /* DISAS */
diff --git a/tools/objtool/arch/arm64/include/arch/cfi_regs.h b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
new file mode 100644
index 0000000000000..49c81cbb6646d
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _OBJTOOL_ARCH_CFI_REGS_H
+#define _OBJTOOL_ARCH_CFI_REGS_H
+
+/* These aren't actually used for arm64 */
+#define CFI_BP 0
+#define CFI_SP 0
+#define CFI_RA 0
+#define CFI_NUM_REGS 2
+
+#endif /* _OBJTOOL_ARCH_CFI_REGS_H */
diff --git a/tools/objtool/arch/arm64/include/arch/elf.h b/tools/objtool/arch/arm64/include/arch/elf.h
new file mode 100644
index 0000000000000..418b90885c501
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/elf.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _OBJTOOL_ARCH_ELF_H
+#define _OBJTOOL_ARCH_ELF_H
+
+#define R_NONE		R_AARCH64_NONE
+#define R_ABS64		R_AARCH64_ABS64
+#define R_ABS32		R_AARCH64_ABS32
+#define R_DATA32	R_AARCH64_PREL32
+#define R_DATA64	R_AARCH64_PREL64
+#define R_TEXT32	R_AARCH64_PREL32
+#define R_TEXT64	R_AARCH64_PREL64
+
+#define ARCH_HAS_INLINE_ALTS 1
+
+#endif /* _OBJTOOL_ARCH_ELF_H */
diff --git a/tools/objtool/arch/arm64/include/arch/special.h b/tools/objtool/arch/arm64/include/arch/special.h
new file mode 100644
index 0000000000000..8ae804a83ea49
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/special.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _OBJTOOL_ARCH_SPECIAL_H
+#define _OBJTOOL_ARCH_SPECIAL_H
+
+#define EX_ENTRY_SIZE 12
+#define EX_ORIG_OFFSET 0
+#define EX_NEW_OFFSET 4
+
+#define JUMP_ENTRY_SIZE 16
+#define JUMP_ORIG_OFFSET 0
+#define JUMP_NEW_OFFSET 4
+#define JUMP_KEY_OFFSET 8
+
+#define ALT_ENTRY_SIZE 12
+#define ALT_ORIG_OFFSET 0
+#define ALT_NEW_OFFSET 4
+#define ALT_FEATURE_OFFSET 8
+#define ALT_ORIG_LEN_OFFSET 10
+#define ALT_NEW_LEN_OFFSET 11
+
+#endif /* _OBJTOOL_ARCH_SPECIAL_H */
diff --git a/tools/objtool/arch/arm64/special.c b/tools/objtool/arch/arm64/special.c
new file mode 100644
index 0000000000000..6ddecd362f3dd
--- /dev/null
+++ b/tools/objtool/arch/arm64/special.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <objtool/special.h>
+
+bool arch_support_alt_relocation(struct special_alt *special_alt,
+				 struct instruction *insn,
+				 struct reloc *reloc)
+{
+	return true;
+}
+
+struct reloc *arch_find_switch_table(struct objtool_file *file,
+				     struct instruction *insn,
+				     unsigned long *table_size)
+{
+	return NULL;
+}
+
+const char *arch_cpu_feature_name(int feature_number)
+{
+	return NULL;
+}
-- 
2.53.0


