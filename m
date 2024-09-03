Return-Path: <live-patching+bounces-563-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A1C9692A4
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE56282CC7
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBA6200128;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJNVwzJv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8747520011E;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336044; cv=none; b=GQltXHwzvB3yxKdNly/WljCjvYERPeh68+rXahc0sY2CXy8v2TosSqWCBi3fq4bWM6L6Vu7POfmqhd2bCo7Vfa3K4ikbaXqKg8pjysvaJM+jGVtFhkvG3YC6uzOrmbuzKSWgIZ9ALbUTwmmHMwF8Thmux+SMCODrD6spCNw8rSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336044; c=relaxed/simple;
	bh=KhD/6JeYp0HzWzUQGCZwBMmcsHO1K5HE8VDDwOmizj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7boxCK70In8JpY/AtcISOw3pxkoqkVD64C/f/e6SgSNiPmVYIsbA+nCON2PwSF3i+4kRzRMa3vPrgC5/geXVMjeWdzqlU5aVoG3Srr3vJuXErGFaWoWXQOYFnKv45V3hZl2kKSVT37/+mbUiMqgKjLhqyCOxtBtUS1qe6JkaY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJNVwzJv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06F2C4CECA;
	Tue,  3 Sep 2024 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336044;
	bh=KhD/6JeYp0HzWzUQGCZwBMmcsHO1K5HE8VDDwOmizj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJNVwzJvPzcxAR0nAQ2qiqUpjHFtFxBvFbS18VaJDuHX/Gl+36PQM9PBFWjxR+aOQ
	 bvEe5zSrSZsLMtgntI3ufwCuEIG5FaBzrIYyTMu3BDKZwiMCAWPxuj3DIY3rPRnfED
	 uZ4dhtzHCPBUYSOgTPrP6VuOw4DwHbKN7LU8L8LlbUkUOmQEvuCpjCWzPBFyI9EHDu
	 9GwV3fP7OHwXO/TgRgNgDnToYQz8vkEDt3fpC2uLlvXh0ZHHg5AFfm1Q4vlojz6MAE
	 SDAxBEJ8HNOe00J1KjHW8HW+AP2105XmziciAXkase2eetCUxJV/sRcPN0pBIy0g86
	 FoxYWOwGvVGzA==
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
Subject: [RFC 29/31] objtool: Calculate function checksums
Date: Mon,  2 Sep 2024 21:00:12 -0700
Message-ID: <ffe8cd49f291ab710573616ae1d9ff762405287e.1725334260.git.jpoimboe@kernel.org>
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

Calculate per-function checksums based on the functions' content and
relocations.  This will enable objtool to do binary diffs.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/Makefile.lib                    |   1 +
 tools/objtool/Makefile                  |   7 +-
 tools/objtool/builtin-check.c           |   1 +
 tools/objtool/check.c                   | 137 +++++++++++++++++++++++-
 tools/objtool/elf.c                     |  31 ++++++
 tools/objtool/include/objtool/builtin.h |   3 +-
 tools/objtool/include/objtool/check.h   |   5 +-
 tools/objtool/include/objtool/elf.h     |  11 +-
 tools/objtool/include/objtool/objtool.h |   2 +
 9 files changed, 188 insertions(+), 10 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 8411e3d53938..9f4708702ef7 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -265,6 +265,7 @@ ifdef CONFIG_OBJTOOL
 
 objtool := $(objtree)/tools/objtool/objtool
 
+objtool-args-$(CONFIG_LIVEPATCH)			+= --sym-checksum
 objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index bf7f7f84ac62..6833804ca419 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -21,6 +21,9 @@ OBJTOOL_IN := $(OBJTOOL)-in.o
 LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
 LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
+LIBXXHASH_FLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null)
+LIBXXHASH_LIBS  := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
+
 all: $(OBJTOOL)
 
 INCLUDES := -I$(srctree)/tools/include \
@@ -32,8 +35,8 @@ INCLUDES := -I$(srctree)/tools/include \
 # Note, EXTRA_WARNINGS here was determined for CC and not HOSTCC, it
 # is passed here to match a legacy behavior.
 WARNINGS := $(EXTRA_WARNINGS) -Wno-switch-default -Wno-switch-enum -Wno-packed -Wno-nested-externs
-OBJTOOL_CFLAGS := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBELF_FLAGS)
-OBJTOOL_LDFLAGS := $(LIBELF_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
+OBJTOOL_CFLAGS := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_FLAGS)
+OBJTOOL_LDFLAGS := $(LIBELF_LIBS) $(LIBXXHASH_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
 
 # Allow old libelf to be used:
 elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJTOOL_CFLAGS) -x c -E - | grep elf_getshdr)
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 6894ef68d125..f3473c046c86 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -75,6 +75,7 @@ static const struct option check_options[] = {
 	OPT_BOOLEAN('l', "sls", &opts.sls, "validate straight-line-speculation mitigations"),
 	OPT_BOOLEAN('s', "stackval", &opts.stackval, "validate frame pointer rules"),
 	OPT_BOOLEAN('t', "static-call", &opts.static_call, "annotate static calls"),
+	OPT_BOOLEAN(0,   "sym-checksum", &opts.sym_checksum, "generate per-function checksums"),
 	OPT_BOOLEAN('u', "uaccess", &opts.uaccess, "validate uaccess rules for SMAP"),
 	OPT_BOOLEAN(0  , "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_CALLBACK_OPTARG(0, "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5dd78a7f75c3..0e9e485cd3b6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -8,6 +8,8 @@
 #include <inttypes.h>
 #include <sys/mman.h>
 
+#include <xxhash.h>
+
 #include <objtool/builtin.h>
 #include <objtool/cfi.h>
 #include <objtool/arch.h>
@@ -951,6 +953,48 @@ static void create_direct_call_sections(struct objtool_file *file)
 	}
 }
 
+static void create_sym_checksum_section(struct objtool_file *file)
+{
+	struct section *sec;
+	struct symbol *sym;
+	unsigned int idx = 0;
+	struct sym_checksum *sym_checksum;
+	size_t entsize = sizeof(struct sym_checksum);
+
+	sec = find_section_by_name(file->elf, SYM_CHECKSUM_SEC);
+	if (sec) {
+		WARN("file already has " SYM_CHECKSUM_SEC " section, skipping");
+		return;
+	}
+
+	for_each_sym(file->elf, sym)
+		if (sym->checksum)
+			idx++;
+
+	if (!idx)
+		return;
+
+	sec = elf_create_section_pair(file->elf, ".discard.sym_checksum", entsize,
+				      idx, idx);
+
+	idx = 0;
+	for_each_sym(file->elf, sym) {
+		if (!sym->checksum)
+			continue;
+
+		elf_init_reloc(file->elf, sec->rsec, idx, idx * entsize, sym,
+			       0, R_TEXT64);
+
+		sym_checksum = (struct sym_checksum *)sec->data->d_buf + idx;
+		sym_checksum->addr = 0; /* reloc */
+		sym_checksum->checksum = sym->checksum;
+
+		mark_sec_changed(file->elf, sec, true);
+
+		idx++;
+	}
+}
+
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -1709,6 +1753,7 @@ static void handle_group_alt(struct objtool_file *file,
 		nop->sym = orig_insn->sym;
 		nop->alt_group = new_alt_group;
 		nop->ignore = orig_insn->ignore_alts;
+		nop->fake = 1;
 	}
 
 	if (!special_alt->new_len) {
@@ -3291,6 +3336,58 @@ static struct instruction *next_insn_to_validate(struct objtool_file *file,
 	return next_insn_same_sec(file, alt_group->orig_group->last_insn);
 }
 
+static void update_sym_checksum(struct symbol *func, struct instruction *insn,
+				const void *data, size_t size)
+{
+	XXH3_64bits_update(func->checksum_state, data, size);
+}
+
+static void update_insn_sym_checksum(struct objtool_file *file, struct symbol *func,
+				 struct instruction *insn)
+{
+	struct reloc *reloc = insn_reloc(file, insn);
+	struct symbol *dest = insn_call_dest(insn);
+
+	if (dest && !reloc) {
+		update_sym_checksum(func, insn, insn->sec->data->d_buf + insn->offset, 1);
+		update_sym_checksum(func, insn, dest->name, strlen(dest->name));
+	} else if (!insn->fake) {
+		update_sym_checksum(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+	}
+
+	if (reloc) {
+		struct symbol *sym = reloc->sym;
+
+		if (sym->sec && is_string_section(sym->sec)) {
+			s64 addend;
+			char *str;
+
+			addend = arch_insn_adjusted_addend(insn, reloc);
+
+			str = sym->sec->data->d_buf + sym->offset + addend;
+
+			update_sym_checksum(func, insn, str, strlen(str));
+
+		} else {
+			u64 offset = arch_insn_adjusted_addend(insn, reloc);
+
+			if (is_section_symbol(sym)) {
+				sym = find_symbol_containing(reloc->sym->sec, offset);
+				if (!sym)
+					return;
+
+				offset -= sym->offset;
+			}
+
+			update_sym_checksum(func, insn, sym->demangled_name,
+					    strlen(sym->demangled_name));
+
+			update_sym_checksum(func, insn, &offset, sizeof(offset));
+		}
+	}
+}
+
+
 /*
  * Follow the branch starting at the given instruction, and recursively follow
  * any other branches (jumps).  Meanwhile, track the frame pointer state at
@@ -3306,11 +3403,15 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 	u8 visited;
 	int ret;
 
-	sec = insn->sec;
-
 	while (1) {
 		next_insn = next_insn_to_validate(file, insn);
 
+		// moved this because alt can continue to orig thanks to next_insn_same_sec
+		sec = insn->sec;
+
+		if (opts.sym_checksum && func && sec)
+			update_insn_sym_checksum(file, func, insn);
+
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (!strncmp(func->name, "__cfi_", 6) ||
@@ -3549,7 +3650,15 @@ static int validate_unwind_hint(struct objtool_file *file,
 				  struct insn_state *state)
 {
 	if (insn->hint && !insn->visited && !insn->ignore) {
-		int ret = validate_branch(file, insn_func(insn), insn, *state);
+		struct symbol *func = insn_func(insn);
+		int ret;
+
+		if (func && !func->checksum_state) {
+			func->checksum_state = XXH3_createState();
+			XXH3_64bits_reset(func->checksum_state);
+		}
+
+		ret = validate_branch(file, func, insn, *state);
 		if (ret)
 			BT_INSN(insn, "<=== (hint)");
 		return ret;
@@ -3941,7 +4050,9 @@ static void add_prefix_symbols(struct objtool_file *file)
 static int validate_symbol(struct objtool_file *file, struct section *sec,
 			   struct symbol *sym, struct insn_state *state)
 {
+	static XXH3_state_t *checksum_state;
 	struct instruction *insn;
+	struct symbol *func;
 	int ret;
 
 	if (!sym->len) {
@@ -3958,9 +4069,24 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 
 	state->uaccess = sym->uaccess_safe;
 
-	ret = validate_branch(file, insn_func(insn), insn, *state);
+	func = insn_func(insn);
+
+	if (func && !func->checksum_state) {
+		if (!checksum_state)
+			checksum_state = XXH3_createState();
+		XXH3_64bits_reset(checksum_state);
+		func->checksum_state = checksum_state;
+	}
+
+	ret = validate_branch(file, func, insn, *state);
 	if (ret)
 		BT_INSN(insn, "<=== (sym)");
+
+	if (func) {
+		func->checksum = XXH3_64bits_digest(func->checksum_state);
+		func->checksum_state = NULL;
+	}
+
 	return ret;
 }
 
@@ -4509,6 +4635,9 @@ int check(struct objtool_file *file)
 	if (opts.ibt)
 		create_ibt_endbr_seal_sections(file);
 
+	if (opts.sym_checksum)
+		create_sym_checksum_section(file);
+
 	if (opts.orc && nr_insns) {
 		ret = orc_create(file);
 		if (ret < 0)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 3109277804cc..022873bf7064 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -17,6 +17,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <libgen.h>
+#include <ctype.h>
 #include <linux/interval_tree_generic.h>
 #include <objtool/builtin.h>
 #include <objtool/elf.h>
@@ -396,6 +397,34 @@ static void read_sections(struct elf *elf)
 		ERROR("section entry mismatch");
 }
 
+static const char *demangle_name(struct symbol *sym)
+{
+	char *str;
+
+	if (!is_local_symbol(sym))
+		return sym->name;
+
+	if (!is_function_symbol(sym) && !is_object_symbol(sym))
+		return sym->name;
+
+	if (!strstarts(sym->name, "__UNIQUE_ID_") && !strchr(sym->name, '.'))
+		return sym->name;
+
+	str = strdup(sym->name);
+	ERROR_ON(!str, "strdup");
+
+	for (int i = strlen(str) - 1; i >= 0; i--) {
+		char c = str[i];
+
+		if (!isdigit(c) && c != '.') {
+			str[i + 1] = '\0';
+			break;
+		}
+	};
+
+	return str;
+}
+
 static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 {
 	struct list_head *entry;
@@ -440,6 +469,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	if (sym->type == STT_NOTYPE && !sym->len)
 		__sym_remove(sym, &sym->sec->symbol_tree);
 #endif
+
+	sym->demangled_name = demangle_name(sym);
 }
 
 static void read_symbols(struct elf *elf)
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index fcca6662c8b4..eab376169c1e 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,6 +9,7 @@
 
 struct opts {
 	/* actions: */
+	bool cfi;
 	bool dump_orc;
 	bool hack_jump_label;
 	bool hack_noinstr;
@@ -23,9 +24,9 @@ struct opts {
 	bool sls;
 	bool stackval;
 	bool static_call;
+	bool sym_checksum;
 	bool uaccess;
 	int prefix;
-	bool cfi;
 
 	/* options: */
 	bool backtrace;
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index daa46f1f0965..b546a31dc2a9 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -63,8 +63,9 @@ struct instruction {
 	    noendbr		: 1,
 	    unret		: 1,
 	    visited		: 4,
-	    no_reloc		: 1;
-		/* 10 bit hole */
+	    no_reloc		: 1,
+	    fake		: 1;
+		/* 9 bit hole */
 
 	struct alt_group *alt_group;
 	struct instruction *jump_dest;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index f759686d46d7..1f14f33d279e 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -13,6 +13,7 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <linux/jhash.h>
+#include <xxhash.h>
 #include <arch/elf.h>
 
 #define SYM_NAME_LEN		512
@@ -29,6 +30,11 @@
 #define ELF_C_READ_MMAP ELF_C_READ
 #endif
 
+struct sym_checksum {
+	u64 addr;
+	u64 checksum;
+};
+
 struct elf_hash_node {
 	struct elf_hash_node *next;
 };
@@ -56,7 +62,7 @@ struct symbol {
 	struct elf_hash_node name_hash;
 	GElf_Sym sym;
 	struct section *sec;
-	const char *name;
+	const char *name, *demangled_name;
 	unsigned int idx, len;
 	unsigned long offset;
 	unsigned long __subtree_last;
@@ -73,6 +79,9 @@ struct symbol {
 	u8 local_label       : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
+
+	XXH3_state_t *checksum_state;
+	XXH64_hash_t checksum;
 };
 
 struct reloc {
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index ae30497e014b..3280abcce55e 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -14,6 +14,8 @@
 
 #define __weak __attribute__((weak))
 
+#define SYM_CHECKSUM_SEC ".discard.sym_checksum"
+
 struct pv_state {
 	bool clean;
 	struct list_head targets;
-- 
2.45.2


