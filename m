Return-Path: <live-patching+bounces-1580-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C69AEAB6D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728D83B20DF
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EA628F53F;
	Thu, 26 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzyPKafH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62B28ECF1;
	Thu, 26 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982206; cv=none; b=Q7gx9fpqBeKbPiuZb2TkfL9NpY+Q5lqhtvEQtAfv0XiThIIScMH6iVPg68BoB5fKX5jNCv2xy5qVEJBLPpIU40Tl2FtdzLbf/sVkabso0U+5nogEcUbgdE6FO6F+C5rynUUdvL/5fCxiSBi7/p7MBEtJZTSp/ihW18tGw77wmIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982206; c=relaxed/simple;
	bh=/el9pDEndOZwCwQdy2qpNEXBM4T/xo5JICuxdIbTDl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9ypGD8OictQxeRMBKFchjjn1UfGN7IqQvQJkhhArbFbQPmef8kA8KgeSBv0G8NDJNlBpeWPDNidifrMK3WukeBlZfqFuYctwNpjmEQ/S4CrRr1A4tabrM7CVm5mNrgo1ZDZAJj3uk9DGg05VsOm+Pbztk53JZgOJe5BQwFBfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzyPKafH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01890C4CEF3;
	Thu, 26 Jun 2025 23:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982206;
	bh=/el9pDEndOZwCwQdy2qpNEXBM4T/xo5JICuxdIbTDl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzyPKafHYogSAkKMYo/8hrx1D/WsUmjNZ9G9PIQkJlnuK2ldaXcDJfCX/SqF5uB0a
	 PT3v3VjH+XnslmQhUJ2x87kOZBkONO75eSmdB903n9gzMnj7Fx/eb+jibW/f2anHsV
	 s+2Qa6HflsXDCoNzYJur3kzjAJgSv14rEP1IORMy52U36OVQbwrIZ/aZtnkqKJ+JMI
	 rLfQ53ZNh0gnPeF6z8U3LLLhUjsTbw8ScXrgP3TMlDfLjqLZg9Fz/SuEaySbi/rkHB
	 2zvbORF1a5DRRckSPBJP3URHIVqNc0EYhe9IIOIofbgMx9npHfUZk++pZ/u37JdIhR
	 jsPBiVC5AbUaw==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 50/64] objtool/klp: Add --checksum option to generate per-function checksums
Date: Thu, 26 Jun 2025 16:55:37 -0700
Message-ID: <ddbc940aea9bbce037527c6d83ef192faf60b72c.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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
 tools/objtool/builtin-check.c                 |  12 +-
 tools/objtool/check.c                         | 140 +++++++++++++++++-
 tools/objtool/elf.c                           |  46 +++++-
 tools/objtool/include/objtool/builtin.h       |   3 +-
 tools/objtool/include/objtool/check.h         |   5 +-
 tools/objtool/include/objtool/checksum.h      |  42 ++++++
 .../objtool/include/objtool/checksum_types.h  |  25 ++++
 tools/objtool/include/objtool/elf.h           |   5 +-
 tools/objtool/include/objtool/objtool.h       |   2 +
 10 files changed, 292 insertions(+), 26 deletions(-)
 create mode 100644 tools/objtool/include/objtool/checksum.h
 create mode 100644 tools/objtool/include/objtool/checksum_types.h

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index fc82d47f2b9a..958761c05b7c 100644
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
index 3172f7e98147..331c6e1dc04c 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,6 +73,7 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
+	OPT_BOOLEAN(0,		 "checksum", &opts.checksum, "generate per-function checksums"),
 	OPT_BOOLEAN(0  ,	 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
 	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
@@ -159,7 +160,16 @@ static bool opts_valid(void)
 		return false;
 	}
 
-	if (opts.hack_jump_label	||
+
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
index c3e1ca3dba06..fd7e470f01bd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -15,6 +15,7 @@
 #include <objtool/special.h>
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
+#include <objtool/checksum.h>
 
 #include <linux/objtool_types.h>
 #include <linux/hashtable.h>
@@ -978,6 +979,59 @@ static int create_direct_call_sections(struct objtool_file *file)
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
+	sec = find_section_by_name(file->elf, SYM_CHECKSUM_SEC);
+	if (sec) {
+		if (!opts.dryrun)
+			WARN("file already has " SYM_CHECKSUM_SEC " section, skipping");
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
@@ -1755,6 +1809,7 @@ static int handle_group_alt(struct objtool_file *file,
 		nop->type = INSN_NOP;
 		nop->sym = orig_insn->sym;
 		nop->alt_group = new_alt_group;
+		nop->fake = 1;
 	}
 
 	if (!special_alt->new_len) {
@@ -2524,6 +2579,14 @@ static void mark_holes(struct objtool_file *file)
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
@@ -2552,7 +2615,7 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
+	if (validate_branch_enabled() || opts.noinstr) {
 		if (add_special_section_alts(file))
 			return -1;
 	}
@@ -3524,6 +3587,50 @@ static bool skip_alt_group(struct instruction *insn)
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
@@ -3544,6 +3651,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 	while (1) {
 		next_insn = next_insn_to_validate(file, insn);
 
+		if (opts.checksum && func && insn->sec)
+			checksum_update_insn(file, func, insn);
+
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (is_prefix_func(func))
@@ -3793,7 +3903,13 @@ static int validate_unwind_hint(struct objtool_file *file,
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
@@ -4141,6 +4257,7 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 			   struct symbol *sym, struct insn_state *state)
 {
 	struct instruction *insn;
+	struct symbol *func;
 	int ret;
 
 	if (!sym->len) {
@@ -4158,9 +4275,18 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
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
 
@@ -4637,7 +4763,7 @@ int check(struct objtool_file *file)
 	if (opts.retpoline)
 		warnings += validate_retpoline(file);
 
-	if (opts.stackval || opts.orc || opts.uaccess) {
+	if (validate_branch_enabled()) {
 		int w = 0;
 
 		w += validate_functions(file);
@@ -4713,6 +4839,12 @@ int check(struct objtool_file *file)
 			goto out;
 	}
 
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
index b88190fe7131..d2f418a34881 100644
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
@@ -453,6 +485,12 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
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
@@ -526,7 +564,8 @@ static int read_symbols(struct elf *elf)
 		} else
 			sym->sec = find_section_by_index(elf, 0);
 
-		elf_add_symbol(elf, sym);
+		if (elf_add_symbol(elf, sym))
+			return -1;
 	}
 
 	if (opts.stats) {
@@ -864,7 +903,8 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 		mark_sec_changed(elf, symtab_shndx, true);
 	}
 
-	elf_add_symbol(elf, sym);
+	if (elf_add_symbol(elf, sym))
+		return NULL;
 
 	return sym;
 }
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index de6c08f8e060..06083e8c5c91 100644
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
+	bool checksum;
 	bool uaccess;
 	int prefix;
-	bool cfi;
 
 	/* options: */
 	bool backtrace;
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 0f4e7ac929ef..d73b0c3ae1ee 100644
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
index 000000000000..927ca74b5c39
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
index 000000000000..507efdd8ab5b
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
index a0fc252e1993..4d1023fdb700 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -13,6 +13,8 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <linux/jhash.h>
+
+#include <objtool/checksum_types.h>
 #include <arch/elf.h>
 
 #define SYM_NAME_LEN		512
@@ -57,7 +59,7 @@ struct symbol {
 	struct elf_hash_node name_hash;
 	GElf_Sym sym;
 	struct section *sec;
-	const char *name;
+	const char *name, *demangled_name;
 	unsigned int idx, len;
 	unsigned long offset;
 	unsigned long __subtree_last;
@@ -79,6 +81,7 @@ struct symbol {
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
+	struct checksum csum;
 };
 
 struct reloc {
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index c0dc86a78ff6..90c591b5bd68 100644
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
2.49.0


