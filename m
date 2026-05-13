Return-Path: <live-patching+bounces-2787-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOwyMabzA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2787-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:44:38 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C5C52CEE3
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E1AE30CD4E3
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB463AF64B;
	Wed, 13 May 2026 03:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhRMU5ny"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270843AEF4B;
	Wed, 13 May 2026 03:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643295; cv=none; b=pR1PY3oL9GfgYwow2nmdy6GAI3oGLVooIfF57oAjGqFZq80OH1lzV1MZcSy9cyYUPJqyTD+bIHAD4jJ6W8Ln8walKff7t1vk52dhjYWC25UFlcEBEe6aViwuXU01zei3UKn2ezdcjwshDGaCF3FodTfpG/uZS7Nes7khWrBakUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643295; c=relaxed/simple;
	bh=jFDTETNcRZkO+WMEenMV2NobbCVqrkY8dx/Pz4H2Wk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay9//z3I/9PCaYLnXWSnGvJ/IqgpM6Be/Ea6MglGsztXlBbAmDMrHHSCCqnFRYSZyWXFsZIlgtHsQX7lnYdzw1HTkoUzWDCVhtlyM4D8guNz5GAAGeMt4vsTEJUxcvq4EVOrgOzS6efIUcfmwek66OoXpdbTaK3ee5mokZwtW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhRMU5ny; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622D9C32781;
	Wed, 13 May 2026 03:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643295;
	bh=jFDTETNcRZkO+WMEenMV2NobbCVqrkY8dx/Pz4H2Wk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhRMU5nyZGk0qmy6luwh9Bvni2CL50D5jbW+CbbcOACEdQ1UfseznLeg9Yz7KnvMT
	 107G49TNUCLyFbG2EKgKiqFDx9Vxly4+m5BxT9CQdf758mGug8mFvbRPaqP17XBFoq
	 PLS+vmFt5l1KiJrLCaTp48N53ZwxYavANG6lGwk0e+DSrF8JQ8V4r2M73ecEa6lTlM
	 1++FRbkSuo92fEMFw6HoSvCdK46CpRD/Dowh8IOQaURB9YmZX/sJrckE6Mg3jwqSJ3
	 mJAxo+Syie2d2dM0MS+ev7Or6VWpKwAB0WfAPftfMvzRxewM3OT7/wUzdDfi/ahMnS
	 nw1+9mojPPlgg==
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
Subject: [PATCH v3 15/21] objtool/klp: Add arm64 support for prefix/PFE detection
Date: Tue, 12 May 2026 20:34:11 -0700
Message-ID: <c7751602066fec175fc58488c72b0b29224b1ffa.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 27C5C52CEE3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2787-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Add arm64 support for detecting prefixed areas before functions (for
kCFI or ftrace with call ops), and __patchable_function_entries (for
ftrace with call ops or args).

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/include/arch/elf.h |   2 +
 tools/objtool/elf.c                       |  13 ++
 tools/objtool/include/objtool/elf.h       |  22 +++
 tools/objtool/klp-diff.c                  | 166 ++++++++++++++++++++--
 4 files changed, 192 insertions(+), 11 deletions(-)

diff --git a/tools/objtool/arch/x86/include/arch/elf.h b/tools/objtool/arch/x86/include/arch/elf.h
index 7131f7f51a4e8..5ee0ccda7db18 100644
--- a/tools/objtool/arch/x86/include/arch/elf.h
+++ b/tools/objtool/arch/x86/include/arch/elf.h
@@ -10,4 +10,6 @@
 #define R_TEXT32	R_X86_64_PC32
 #define R_TEXT64	R_X86_64_PC32
 
+#define ARCH_HAS_PREFIX_SYMBOLS 1
+
 #endif /* _OBJTOOL_ARCH_ELF */
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 065ccfeb98288..9d5a926934dc2 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -274,6 +274,19 @@ struct symbol *find_func_containing(struct section *sec, unsigned long offset)
 	return NULL;
 }
 
+struct symbol *find_data_mapping_sym(struct section *sec, unsigned long offset)
+{
+	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
+	struct symbol *sym;
+
+	__sym_for_each(sym, tree, offset, offset) {
+		if (sym->offset == offset && is_data_mapping_sym(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 {
 	struct symbol *sym;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 9d36b14f420e2..ab1d53ed23189 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -130,6 +130,7 @@ struct elf {
 	struct list_head sections;
 	struct list_head symbols;
 	unsigned long num_relocs;
+	int pfe_offset;
 
 	int symbol_bits;
 	int symbol_name_bits;
@@ -229,6 +230,7 @@ struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, uns
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len);
 struct symbol *find_func_containing(struct section *sec, unsigned long offset);
+struct symbol *find_data_mapping_sym(struct section *sec, unsigned long offset);
 
 /*
  * Try to see if it's a whole archive (vmlinux.o or module).
@@ -295,6 +297,26 @@ static inline bool is_notype_sym(struct symbol *sym)
 	return sym->type == STT_NOTYPE;
 }
 
+/*
+ * ARM64 mapping symbols ($d, $x, $a, __pi_$d, etc) which mark transitions
+ * between code and data.
+ */
+static inline bool is_mapping_sym(struct symbol *sym)
+{
+	return is_notype_sym(sym) && strchr(sym->name, '$');
+}
+
+static inline bool is_data_mapping_sym(struct symbol *sym)
+{
+	const char *dollar;
+
+	if (!is_mapping_sym(sym))
+		return false;
+
+	dollar = strchr(sym->name, '$');
+	return dollar && dollar[1] == 'd';
+}
+
 static inline bool is_global_sym(struct symbol *sym)
 {
 	return sym->bind == STB_GLOBAL;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 6957292e455e4..eb21f3bf3120b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -20,6 +20,7 @@
 #include <linux/stringify.h>
 #include <linux/string.h>
 #include <linux/jhash.h>
+#include <linux/kconfig.h>
 
 #define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
 
@@ -213,6 +214,98 @@ static int read_sym_checksums(struct elf *elf)
 	return 0;
 }
 
+/*
+ * For non-x86, detect the offset from the function entry point to its
+ * __patchable_function_entries (PFE) relocation target.  x86 doesn't need this,
+ * it clones the __cfi/__pfx symbol instead.
+ *
+ * offset < 0 (before function entry):
+ *
+ *    CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS (arm64)
+ *
+ * offset == 0 (at function entry):
+ *
+ *    CONFIG_DYNAMIC_FTRACE_WITH_ARGS without BTI (arm64)
+ *
+ * offset > 0 (after function entry):
+ *
+ *    CONFIG_DYNAMIC_FTRACE_WITH_ARGS with BTI (arm64)
+ */
+static int read_pfe_offset(struct elf *elf)
+{
+	bool has_pfe = false;
+	struct section *sec;
+
+	if (__is_defined(ARCH_HAS_PREFIX_SYMBOLS))
+		return 0;
+
+	for_each_sec(elf, sec) {
+		struct reloc *reloc;
+
+		if (strcmp(sec->name, "__patchable_function_entries"))
+			continue;
+		if (!sec->rsec)
+			continue;
+
+		has_pfe = true;
+
+		for_each_reloc(sec->rsec, reloc) {
+			unsigned long target = reloc->sym->offset + reloc_addend(reloc);
+			struct symbol *func;
+
+			/* arm64 func */
+			func = find_func_containing(reloc->sym->sec, target);
+			if (func) {
+				elf->pfe_offset = target - func->offset;
+				return 0;
+			}
+
+			/* arm64 CALL_OPS */
+			func = find_func_by_offset(reloc->sym->sec, target + 8);
+			if (func) {
+				elf->pfe_offset = -8;
+				return 0;
+			}
+		}
+	}
+
+	if (has_pfe) {
+		ERROR("can't find __patchable_function_entries offset");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Detect the size of the area before a function's entry point.  This prefix
+ * area is used for CFI type hashes or ftrace call ops.
+ *
+ *  $d mapping symbol (arm64):
+ *
+ *    CONFIG_CFI
+ *
+ *  PFE before function entry, no symbol (arm64):
+ *
+ *    CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS
+ */
+static unsigned long func_pfx_size(struct elf *elf, struct symbol *func)
+{
+	if (__is_defined(ARCH_HAS_PREFIX_SYMBOLS))
+		return 0;
+
+	/* arm64 kCFI $d data mapping symbol */
+	if (func->offset >= 4 &&
+	    find_data_mapping_sym(func->sec, func->offset - 4))
+		return 4;
+
+	/* arm64 CALL_OPS (mutually exclusive with kCFI) */
+	if (elf->pfe_offset < 0 && func->offset >= -elf->pfe_offset)
+		return -elf->pfe_offset;
+
+	return 0;
+}
+
 static struct symbol *first_file_symbol(struct elf *elf)
 {
 	struct symbol *sym;
@@ -302,6 +395,9 @@ static bool is_special_section(struct section *sec)
 		"__ex_table",
 		"__jump_table",
 		"__mcount_loc",
+#ifndef ARCH_HAS_PREFIX_SYMBOLS
+		"__patchable_function_entries",
+#endif
 
 		/*
 		 * Extract .static_call_sites here to inherit non-module
@@ -931,7 +1027,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 				     bool data_too)
 {
 	struct section *out_sec = NULL;
-	unsigned long offset = 0;
+	unsigned long offset = 0, pfx_size = 0;
 	struct symbol *out_sym;
 
 	if (data_too && !is_undef_sym(patched_sym)) {
@@ -963,17 +1059,22 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 			void *data = NULL;
 			size_t size;
 
+			/* Clone (non-x86) function prefix area */
+			pfx_size = is_func_sym(patched_sym) ? func_pfx_size(elf, patched_sym) : 0;
+
 			/* bss doesn't have data */
 			if (patched_sym->sec->data && patched_sym->sec->data->d_buf)
-				data = patched_sym->sec->data->d_buf + patched_sym->offset;
+				data = patched_sym->sec->data->d_buf + patched_sym->offset - pfx_size;
 
 			if (is_sec_sym(patched_sym))
 				size = sec_size(patched_sym->sec);
 			else
-				size = patched_sym->len;
+				size = patched_sym->len + pfx_size;
 
 			if (!elf_add_data(elf, out_sec, data, size))
 				return NULL;
+
+			offset += pfx_size;
 		}
 	}
 
@@ -1251,21 +1352,41 @@ static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
 	return 0;
 }
 
+/*
+ * __patchable_function_entries relocs point to the patchable entry NOPs,
+ * which are at 'pfe_offset' bytes from the function symbol.
+ *
+ * Some entries (e.g., removed weak functions, syscall -ENOSYS stubs) don't
+ * have a corresponding function symbol.  Skip those with a return value of 1.
+ */
+static int convert_pfe_reloc(struct elf *elf, struct reloc *reloc)
+{
+	struct symbol *func;
+
+	func = find_func_by_offset(reloc->sym->sec,
+				   reloc->sym->offset +
+				   reloc_addend(reloc) - elf->pfe_offset);
+	if (!func)
+		return 1;
+
+	reloc->sym = func;
+	set_reloc_sym(elf, reloc, func->idx);
+	set_reloc_addend(elf, reloc, elf->pfe_offset);
+	return 0;
+}
+
 /* Return -1 error, 0 success, 1 skip */
 static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 {
 	struct symbol *sym = reloc->sym;
 	struct section *sec = sym->sec;
 
+	if (!strcmp(reloc->sec->name, ".rela__patchable_function_entries"))
+		return convert_pfe_reloc(elf, reloc);
+
 	if (!is_sec_sym(sym))
 		return 0;
 
-	/* If the symbol has a dedicated section, it's easy to find */
-	sym = find_symbol_by_offset(sec, 0);
-	if (sym && sym->len == sec_size(sec))
-		goto found_sym;
-
-	/* No dedicated section; find the symbol manually */
 	sym = find_symbol_containing_inclusive(sec, arch_adjusted_addend(reloc));
 	if (!sym) {
 		/*
@@ -1293,7 +1414,6 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 		return -1;
 	}
 
-found_sym:
 	reloc->sym = sym;
 	set_reloc_sym(elf, reloc, sym->idx);
 	set_reloc_addend(elf, reloc, reloc_addend(reloc) - sym->offset);
@@ -1856,6 +1976,9 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 
 static int clone_special_section(struct elfs *e, struct section *patched_sec)
 {
+	bool is_pfe = !strcmp(patched_sec->name, "__patchable_function_entries");
+	struct section *out_sec = NULL;
+	struct reloc *patched_reloc;
 	struct symbol *patched_sym;
 
 	/*
@@ -1863,6 +1986,7 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 	 * reference included functions.
 	 */
 	sec_for_each_sym(patched_sec, patched_sym) {
+		struct symbol *out_sym;
 		int ret;
 
 		if (!is_object_sym(patched_sym))
@@ -1877,8 +2001,23 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 		if (ret > 0)
 			continue;
 
-		if (!clone_symbol(e, patched_sym, true))
+		out_sym = clone_symbol(e, patched_sym, true);
+		if (!out_sym)
 			return -1;
+
+		if (!is_pfe || (out_sec && out_sec->sh.sh_link))
+			continue;
+
+		/*
+		 * For reasons, the patched object has multiple PFE sections,
+		 * but we only need to create one combined section for the
+		 * output.  Link the single PFE ouput section to a random text
+		 * section to satisfy the linker for SHF_LINK_ORDER.
+		 */
+		out_sec = out_sym->sec;
+		patched_reloc = find_reloc_by_dest(e->patched, patched_sec,
+						   patched_sym->offset);
+		out_sec->sh.sh_link = patched_reloc->sym->clone->sec->idx;
 	}
 
 	return 0;
@@ -2175,6 +2314,9 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (read_sym_checksums(e.patched))
 		return -1;
 
+	if (read_pfe_offset(e.patched))
+		return -1;
+
 	if (correlate_symbols(&e))
 		return -1;
 
@@ -2188,6 +2330,8 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (!e.out)
 		return -1;
 
+	e.out->pfe_offset = e.patched->pfe_offset;
+
 	/*
 	 * Special section fake symbols are needed so that individual special
 	 * section entries can be extracted by clone_special_sections().
-- 
2.53.0


