Return-Path: <live-patching+bounces-1704-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEF2B80E30
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E7761C27131
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6399737C0F5;
	Wed, 17 Sep 2025 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYMyWnwq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760E37C0E6;
	Wed, 17 Sep 2025 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125091; cv=none; b=akkLnGJ/wG3yNy028g2YHW7OBIPKq3L4XR/W1a1g3jKQ8nog4v21e07hUaYFgEgbNlknnKTuSZqBNxvwMQSt2b6gFUvdbk0hmpkUdyFi9sN8to/LTjbebztOVxm+JK7qhDB5iWvECGB6cy8iQgwL6s5yv5tbudg/NMIsAEXq7LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125091; c=relaxed/simple;
	bh=oOv7QsS+kVHWf+fVHqDkm+Igs/X0umzlNCxyOahtx7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLWpdLxt5b9j1tYW8lpobbGxYQe9a/NfHhOuCyBtglDZK8/+xgWshK0eiy/Gj2zn8XCXk69rGEL0Fjumy7Qtf3E9bBrCyvujIABFtIKDHPX9LXDFHrzXLureyYWSpZlOXKQsTBagL9hghAYXfkclcq50jshz1YiEBF6jwA5xwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYMyWnwq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87207C4CEE7;
	Wed, 17 Sep 2025 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125091;
	bh=oOv7QsS+kVHWf+fVHqDkm+Igs/X0umzlNCxyOahtx7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYMyWnwqQrmVGC6yzAxdDN7u66BMnMlXeQFxKPxwY7hOGFss1DmlZZtaIWEHdyIsQ
	 qMNdmufeNzTWpi41MXTeV8zqF2/n8wtZZD3lHDsTZC1Ag6l6dcmp9ZdALreoZl/ndf
	 Dx8B1t+dt3Rl3X+KveDSubxvtsyHfIxep/R6rtodCkcErVYT/KpS0siW9VoTTcQpHT
	 +ud40xJv0EorBoq1nAbZhg8Y8wFyQw8YN3VdcvCepGlVJYJfpfzSn30sdoSh1eug8U
	 CLLces0A5WPazq4O2JvHSIbpgEepDk6L109zpmLliPx/h827ZiL4u2vWklYnnWNGLs
	 N1vb6w6hkTKzw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate per-function checksums
Date: Wed, 17 Sep 2025 09:03:57 -0700
Message-ID: <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, add a command-line
option to generate a unique checksum for each function.  This will
enable detection of functions which have changed between two versions of
an object file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Makefile                        |  38 +++--
 tools/objtool/builtin-check.c                 |  11 +-
 tools/objtool/check.c                         | 140 +++++++++++++++++-
 tools/objtool/elf.c                           |  46 +++++-
 tools/objtool/include/objtool/builtin.h       |   5 +-
 tools/objtool/include/objtool/check.h         |   5 +-
 tools/objtool/include/objtool/checksum.h      |  42 ++++++
 .../objtool/include/objtool/checksum_types.h  |  25 ++++
 tools/objtool/include/objtool/elf.h           |   4 +-
 9 files changed, 289 insertions(+), 27 deletions(-)
 create mode 100644 tools/objtool/include/objtool/checksum.h
 create mode 100644 tools/objtool/include/objtool/checksum_types.h

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index fc82d47f2b9a7..958761c05b7c3 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -2,6 +2,27 @@
 include ../scripts/Makefile.include
 include ../scripts/Makefile.arch
 
+ifeq ($(SRCARCH),x86)
+	BUILD_ORC    := y
+	ARCH_HAS_KLP := y
+endif
+
+ifeq ($(SRCARCH),loongarch)
+	BUILD_ORC	   := y
+endif
+
+ifeq ($(ARCH_HAS_KLP),y)
+	HAVE_XXHASH = $(shell echo "int main() {}" | \
+		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
+	ifeq ($(HAVE_XXHASH),y)
+		LIBXXHASH_CFLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null) \
+				    -DBUILD_KLP
+		LIBXXHASH_LIBS   := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
+	endif
+endif
+
+export BUILD_ORC
+
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
@@ -36,10 +57,10 @@ INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/objtool/arch/$(SRCARCH)/include \
 	    -I$(LIBSUBCMD_OUTPUT)/include
 
-OBJTOOL_CFLAGS  := -std=gnu11 -fomit-frame-pointer -O2 -g \
-		   $(WARNINGS) $(INCLUDES) $(LIBELF_FLAGS) $(HOSTCFLAGS)
+OBJTOOL_CFLAGS  := -std=gnu11 -fomit-frame-pointer -O2 -g $(WARNINGS)	\
+		   $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_CFLAGS) $(HOSTCFLAGS)
 
-OBJTOOL_LDFLAGS := $(LIBSUBCMD) $(LIBELF_LIBS) $(HOSTLDFLAGS)
+OBJTOOL_LDFLAGS := $(LIBSUBCMD) $(LIBELF_LIBS) $(LIBXXHASH_LIBS) $(HOSTLDFLAGS)
 
 # Allow old libelf to be used:
 elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJTOOL_CFLAGS) -x c -E - 2>/dev/null | grep elf_getshdr)
@@ -51,17 +72,6 @@ HOST_OVERRIDES := CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)"
 AWK = awk
 MKDIR = mkdir
 
-BUILD_ORC := n
-
-ifeq ($(SRCARCH),x86)
-	BUILD_ORC := y
-endif
-
-ifeq ($(SRCARCH),loongarch)
-	BUILD_ORC := y
-endif
-
-export BUILD_ORC
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
 
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 07983cdeded0f..101f05606a990 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,6 +73,7 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
+	OPT_BOOLEAN(0,		 "checksum", &opts.checksum, "generate per-function checksums"),
 	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
 	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
@@ -160,7 +161,15 @@ static bool opts_valid(void)
 		return false;
 	}
 
-	if (opts.hack_jump_label	||
+#ifndef BUILD_KLP
+	if (opts.checksum) {
+		ERROR("--checksum not supported; install xxhash-devel and recompile");
+		return false;
+	}
+#endif
+
+	if (opts.checksum		||
+	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
 	    opts.ibt			||
 	    opts.mcount			||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 969a61766f4a6..fec53407428e2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -14,6 +14,7 @@
 #include <objtool/check.h>
 #include <objtool/special.h>
 #include <objtool/warn.h>
+#include <objtool/checksum.h>
 
 #include <linux/objtool_types.h>
 #include <linux/hashtable.h>
@@ -971,6 +972,59 @@ static int create_direct_call_sections(struct objtool_file *file)
 	return 0;
 }
 
+#ifdef BUILD_KLP
+static int create_sym_checksum_section(struct objtool_file *file)
+{
+	struct section *sec;
+	struct symbol *sym;
+	unsigned int idx = 0;
+	struct sym_checksum *checksum;
+	size_t entsize = sizeof(struct sym_checksum);
+
+	sec = find_section_by_name(file->elf, ".discard.sym_checksum");
+	if (sec) {
+		if (!opts.dryrun)
+			WARN("file already has .discard.sym_checksum section, skipping");
+
+		return 0;
+	}
+
+	for_each_sym(file->elf, sym)
+		if (sym->csum.checksum)
+			idx++;
+
+	if (!idx)
+		return 0;
+
+	sec = elf_create_section_pair(file->elf, ".discard.sym_checksum", entsize,
+				      idx, idx);
+	if (!sec)
+		return -1;
+
+	idx = 0;
+	for_each_sym(file->elf, sym) {
+		if (!sym->csum.checksum)
+			continue;
+
+		if (!elf_init_reloc(file->elf, sec->rsec, idx, idx * entsize,
+				    sym, 0, R_TEXT64))
+			return -1;
+
+		checksum = (struct sym_checksum *)sec->data->d_buf + idx;
+		checksum->addr = 0; /* reloc */
+		checksum->checksum = sym->csum.checksum;
+
+		mark_sec_changed(file->elf, sec, true);
+
+		idx++;
+	}
+
+	return 0;
+}
+#else
+static int create_sym_checksum_section(struct objtool_file *file) { return -EINVAL; }
+#endif
+
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -1748,6 +1802,7 @@ static int handle_group_alt(struct objtool_file *file,
 		nop->type = INSN_NOP;
 		nop->sym = orig_insn->sym;
 		nop->alt_group = new_alt_group;
+		nop->fake = 1;
 	}
 
 	if (!special_alt->new_len) {
@@ -2527,6 +2582,14 @@ static void mark_holes(struct objtool_file *file)
 	}
 }
 
+static bool validate_branch_enabled(void)
+{
+	return opts.stackval ||
+	       opts.orc ||
+	       opts.uaccess ||
+	       opts.checksum;
+}
+
 static int decode_sections(struct objtool_file *file)
 {
 	mark_rodata(file);
@@ -2555,7 +2618,7 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
+	if (validate_branch_enabled() || opts.noinstr) {
 		if (add_special_section_alts(file))
 			return -1;
 	}
@@ -3527,6 +3590,50 @@ static bool skip_alt_group(struct instruction *insn)
 	return alt_insn->type == INSN_CLAC || alt_insn->type == INSN_STAC;
 }
 
+static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
+				 struct instruction *insn)
+{
+	struct reloc *reloc = insn_reloc(file, insn);
+	unsigned long offset;
+	struct symbol *sym;
+
+	if (insn->fake)
+		return;
+
+	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+
+	if (!reloc) {
+		struct symbol *call_dest = insn_call_dest(insn);
+
+		if (call_dest)
+			checksum_update(func, insn, call_dest->demangled_name,
+					strlen(call_dest->demangled_name));
+		return;
+	}
+
+	sym = reloc->sym;
+	offset = arch_insn_adjusted_addend(insn, reloc);
+
+	if (is_string_sec(sym->sec)) {
+		char *str;
+
+		str = sym->sec->data->d_buf + sym->offset + offset;
+		checksum_update(func, insn, str, strlen(str));
+		return;
+	}
+
+	if (is_sec_sym(sym)) {
+		sym = find_symbol_containing(reloc->sym->sec, offset);
+		if (!sym)
+			return;
+
+		offset -= sym->offset;
+	}
+
+	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
+	checksum_update(func, insn, &offset, sizeof(offset));
+}
+
 /*
  * Follow the branch starting at the given instruction, and recursively follow
  * any other branches (jumps).  Meanwhile, track the frame pointer state at
@@ -3547,6 +3654,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 	while (1) {
 		next_insn = next_insn_to_validate(file, insn);
 
+		if (opts.checksum && func && insn->sec)
+			checksum_update_insn(file, func, insn);
+
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (is_prefix_func(func))
@@ -3796,7 +3906,13 @@ static int validate_unwind_hint(struct objtool_file *file,
 				  struct insn_state *state)
 {
 	if (insn->hint && !insn->visited) {
-		int ret = validate_branch(file, insn_func(insn), insn, *state);
+		struct symbol *func = insn_func(insn);
+		int ret;
+
+		if (opts.checksum)
+			checksum_init(func);
+
+		ret = validate_branch(file, func, insn, *state);
 		if (ret)
 			BT_INSN(insn, "<=== (hint)");
 		return ret;
@@ -4175,6 +4291,7 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 			   struct symbol *sym, struct insn_state *state)
 {
 	struct instruction *insn;
+	struct symbol *func;
 	int ret;
 
 	if (!sym->len) {
@@ -4192,9 +4309,18 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	if (opts.uaccess)
 		state->uaccess = sym->uaccess_safe;
 
-	ret = validate_branch(file, insn_func(insn), insn, *state);
+	func = insn_func(insn);
+
+	if (opts.checksum)
+		checksum_init(func);
+
+	ret = validate_branch(file, func, insn, *state);
 	if (ret)
 		BT_INSN(insn, "<=== (sym)");
+
+	if (opts.checksum)
+		checksum_finish(func);
+
 	return ret;
 }
 
@@ -4712,7 +4838,7 @@ int check(struct objtool_file *file)
 	if (opts.retpoline)
 		warnings += validate_retpoline(file);
 
-	if (opts.stackval || opts.orc || opts.uaccess) {
+	if (validate_branch_enabled()) {
 		int w = 0;
 
 		w += validate_functions(file);
@@ -4791,6 +4917,12 @@ int check(struct objtool_file *file)
 	if (opts.noabs)
 		warnings += check_abs_references(file);
 
+	if (opts.checksum) {
+		ret = create_sym_checksum_section(file);
+		if (ret)
+			goto out;
+	}
+
 	if (opts.orc && nr_insns) {
 		ret = orc_create(file);
 		if (ret)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 6095baba8e9c5..0119b3b4c5540 100644
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
@@ -412,7 +413,38 @@ static int read_sections(struct elf *elf)
 	return 0;
 }
 
-static void elf_add_symbol(struct elf *elf, struct symbol *sym)
+static const char *demangle_name(struct symbol *sym)
+{
+	char *str;
+
+	if (!is_local_sym(sym))
+		return sym->name;
+
+	if (!is_func_sym(sym) && !is_object_sym(sym))
+		return sym->name;
+
+	if (!strstarts(sym->name, "__UNIQUE_ID_") && !strchr(sym->name, '.'))
+		return sym->name;
+
+	str = strdup(sym->name);
+	if (!str) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
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
+static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 {
 	struct list_head *entry;
 	struct rb_node *pnode;
@@ -456,6 +488,12 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
+
+	sym->demangled_name = demangle_name(sym);
+	if (!sym->demangled_name)
+		return -1;
+
+	return 0;
 }
 
 static int read_symbols(struct elf *elf)
@@ -529,7 +567,8 @@ static int read_symbols(struct elf *elf)
 		} else
 			sym->sec = find_section_by_index(elf, 0);
 
-		elf_add_symbol(elf, sym);
+		if (elf_add_symbol(elf, sym))
+			return -1;
 	}
 
 	if (opts.stats) {
@@ -867,7 +906,8 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 		mark_sec_changed(elf, symtab_shndx, true);
 	}
 
-	elf_add_symbol(elf, sym);
+	if (elf_add_symbol(elf, sym))
+		return NULL;
 
 	return sym;
 }
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 7d559a2c13b7b..338bdab6b9ad8 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,12 +9,15 @@
 
 struct opts {
 	/* actions: */
+	bool cfi;
+	bool checksum;
 	bool dump_orc;
 	bool hack_jump_label;
 	bool hack_noinstr;
 	bool hack_skylake;
 	bool ibt;
 	bool mcount;
+	bool noabs;
 	bool noinstr;
 	bool orc;
 	bool retpoline;
@@ -25,8 +28,6 @@ struct opts {
 	bool static_call;
 	bool uaccess;
 	int prefix;
-	bool cfi;
-	bool noabs;
 
 	/* options: */
 	bool backtrace;
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 0f4e7ac929ef0..d73b0c3ae1ee3 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -65,8 +65,9 @@ struct instruction {
 	    unret		: 1,
 	    visited		: 4,
 	    no_reloc		: 1,
-	    hole		: 1;
-		/* 10 bit hole */
+	    hole		: 1,
+	    fake		: 1;
+		/* 9 bit hole */
 
 	struct alt_group *alt_group;
 	struct instruction *jump_dest;
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
new file mode 100644
index 0000000000000..927ca74b5c39e
--- /dev/null
+++ b/tools/objtool/include/objtool/checksum.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _OBJTOOL_CHECKSUM_H
+#define _OBJTOOL_CHECKSUM_H
+
+#include <objtool/elf.h>
+
+#ifdef BUILD_KLP
+
+static inline void checksum_init(struct symbol *func)
+{
+	if (func && !func->csum.state) {
+		func->csum.state = XXH3_createState();
+		XXH3_64bits_reset(func->csum.state);
+	}
+}
+
+static inline void checksum_update(struct symbol *func,
+				   struct instruction *insn,
+				   const void *data, size_t size)
+{
+	XXH3_64bits_update(func->csum.state, data, size);
+}
+
+static inline void checksum_finish(struct symbol *func)
+{
+	if (func && func->csum.state) {
+		func->csum.checksum = XXH3_64bits_digest(func->csum.state);
+		func->csum.state = NULL;
+	}
+}
+
+#else /* !BUILD_KLP */
+
+static inline void checksum_init(struct symbol *func) {}
+static inline void checksum_update(struct symbol *func,
+				   struct instruction *insn,
+				   const void *data, size_t size) {}
+static inline void checksum_finish(struct symbol *func) {}
+
+#endif /* !BUILD_KLP */
+
+#endif /* _OBJTOOL_CHECKSUM_H */
diff --git a/tools/objtool/include/objtool/checksum_types.h b/tools/objtool/include/objtool/checksum_types.h
new file mode 100644
index 0000000000000..507efdd8ab5b9
--- /dev/null
+++ b/tools/objtool/include/objtool/checksum_types.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _OBJTOOL_CHECKSUM_TYPES_H
+#define _OBJTOOL_CHECKSUM_TYPES_H
+
+struct sym_checksum {
+	u64 addr;
+	u64 checksum;
+};
+
+#ifdef BUILD_KLP
+
+#include <xxhash.h>
+
+struct checksum {
+	XXH3_state_t *state;
+	XXH64_hash_t checksum;
+};
+
+#else /* !BUILD_KLP */
+
+struct checksum {};
+
+#endif /* !BUILD_KLP */
+
+#endif /* _OBJTOOL_CHECKSUM_TYPES_H */
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 814cfc0bbf16b..bc7d8a6167f8f 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -15,6 +15,7 @@
 #include <linux/jhash.h>
 
 #include <objtool/endianness.h>
+#include <objtool/checksum_types.h>
 #include <arch/elf.h>
 
 #define SYM_NAME_LEN		512
@@ -61,7 +62,7 @@ struct symbol {
 	struct elf_hash_node name_hash;
 	GElf_Sym sym;
 	struct section *sec;
-	const char *name;
+	const char *name, *demangled_name;
 	unsigned int idx, len;
 	unsigned long offset;
 	unsigned long __subtree_last;
@@ -84,6 +85,7 @@ struct symbol {
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
+	struct checksum csum;
 };
 
 struct reloc {
-- 
2.50.0


