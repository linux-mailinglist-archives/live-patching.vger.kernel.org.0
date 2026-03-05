Return-Path: <live-patching+bounces-2121-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALpYAWz5qGlzzwAAu9opvQ
	(envelope-from <live-patching+bounces-2121-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:33:00 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BAF20A8C7
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 86D2B3058F4D
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B67296BC8;
	Thu,  5 Mar 2026 03:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDavCUp7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C332951B3;
	Thu,  5 Mar 2026 03:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681520; cv=none; b=TjiL52HQJ8p8vntVNNIPfhXoJgcp287iAKpIrRQexNIRsPStg3Asxcr2hsEyujmGkuQ5hYStlHC5Y6wP1wEZd4+5gWRXzLoCI1WcrBiPCz8WlTUVHAkuziYmWUhNZ1FHAiPeMpUfFLVsdBohipQu+kD980dNkgDJwuGIkaJA+VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681520; c=relaxed/simple;
	bh=T7UwqfC/qq6LxWXm5c1q8OXLRhM17hhhTRRQ0ZOmsSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucSYN9dEWNo8GvHJZx1x/Tw0Y2LtzR1rPnj06emmLe0UMODV27UV799xv7/xkxyq0iMHY0WSrYi6JenKAZg41QXYoRjC487k81Gl5IDD7JHKtvuEYvk+IcQpm+0IqRfosQIOABh46l+e5XKG1uL5aeSys+/phMMGC1lCIGwWIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDavCUp7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B66C2BCB4;
	Thu,  5 Mar 2026 03:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681520;
	bh=T7UwqfC/qq6LxWXm5c1q8OXLRhM17hhhTRRQ0ZOmsSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDavCUp7L5xrfmlTAmLhQvHfj0P6O49id66RDxtAqLK+o1pl9sLef1kMmtG6nnMhP
	 jewLiUnwj/doqZ4ZP8FZsaxQYpywuDdCle9HQ5xUtogS7Dmsn20NO8R9WvFL/cpNCy
	 CR86hlYuNnt5+FP65ILLYc2VP0Im+W02oWTsiincSgMJGE+rWSrdRE13zjrzIfJC6j
	 hY2WfnACRcQk19jO2rUzsvMFOF+iOsuF8cclCA6z+Y4xeanpfwfaOWl4UIg7Or/q2o
	 lGy605JCKe2uyz1cXNV08191FMWm8FBK4szpwnh3xiE16HMFu9h490fgUuep2tLA6A
	 mlqaUnNFARZeA==
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
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/14] objtool: Introduce objtool for arm64
Date: Wed,  4 Mar 2026 19:31:32 -0800
Message-ID: <5ad66ec6131539de1704b1f1c0fa9abb7ca37922.1772681234.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772681234.git.jpoimboe@kernel.org>
References: <cover.1772681234.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1BAF20A8C7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2121-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add basic support for arm64 on objtool.  Only --checksum is currently
supported.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/Kconfig                            |   2 +
 tools/objtool/Makefile                        |   4 +
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/decode.c             | 116 ++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  11 ++
 tools/objtool/arch/arm64/include/arch/elf.h   |  13 ++
 .../objtool/arch/arm64/include/arch/special.h |  21 ++++
 tools/objtool/arch/arm64/special.c            |  21 ++++
 8 files changed, 190 insertions(+)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/special.h
 create mode 100644 tools/objtool/arch/arm64/special.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..354aa80c5b4b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -236,9 +236,11 @@ config ARM64
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
index 6964175abdfd..288db5bc3002 100644
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
 		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
diff --git a/tools/objtool/arch/arm64/Build b/tools/objtool/arch/arm64/Build
new file mode 100644
index 000000000000..d24d5636a5b8
--- /dev/null
+++ b/tools/objtool/arch/arm64/Build
@@ -0,0 +1,2 @@
+objtool-y += decode.o
+objtool-y += special.o
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
new file mode 100644
index 000000000000..ee93c096243f
--- /dev/null
+++ b/tools/objtool/arch/arm64/decode.c
@@ -0,0 +1,116 @@
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
+	u32 i = *((u32 *)(sec->data->d_buf + offset));
+
+	insn->len = 4;
+
+	/*
+	 * These are the bare minimum needed for static branch detection and
+	 * checksum calculations.
+	 */
+	if (i == 0xd503201f || i == 0x2a1f03f7) {
+		/* For static branches */
+		insn->type = INSN_NOP;
+	} else if ((i & 0xfc000000) == 0x14000000) {
+		/* For static branches and intra-TU sibling calls */
+		insn->type = INSN_JUMP_UNCONDITIONAL;
+		insn->immediate = sign_extend64(i & 0x03ffffff, 25);
+	} else if ((i & 0xfc000000) == 0x94000000) {
+		/* For intra-TU calls */
+		insn->type = INSN_CALL;
+		insn->immediate = sign_extend64(i & 0x03ffffff, 25);
+	} else if ((i & 0xff000000) == 0x54000000) {
+		/* For intra-TU conditional sibling calls */
+		insn->type = INSN_JUMP_CONDITIONAL;
+		insn->immediate = sign_extend64((i & 0xffffe0) >> 5, 18);
+	} else {
+		insn->type = INSN_OTHER;
+	}
+
+	return 0;
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
+	return false;
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
index 000000000000..49c81cbb6646
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
index 000000000000..80a1bc479930
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/elf.h
@@ -0,0 +1,13 @@
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
+#endif /* _OBJTOOL_ARCH_ELF_H */
diff --git a/tools/objtool/arch/arm64/include/arch/special.h b/tools/objtool/arch/arm64/include/arch/special.h
new file mode 100644
index 000000000000..8ae804a83ea4
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
index 000000000000..3c2b83d94939
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
+	return false;
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


