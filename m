Return-Path: <live-patching+bounces-1582-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C79AEAB69
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0541717C967
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5DB2900AD;
	Thu, 26 Jun 2025 23:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrJZPtBt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3E290098;
	Thu, 26 Jun 2025 23:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982208; cv=none; b=MCPIydk6AZpe1gVQH8LmgHvmiJzfZYMhJ+ip51bzvxF7nsYMuxRaN70CfJrtqonAEmz/zDD8vgGGPeSaOJ49gYmusdgfOZ68akxbSaPnQgqoHvy71fJDDWmLU0sr2lF7lp5lkyBVvUdCys2wyqYc2vKjU22YRl9Tj/B73O103JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982208; c=relaxed/simple;
	bh=RpFnlBNANteGCRsJC4kUjhp7pwuG/SjD6jbzG+crZyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KApiGljciiVV9uL/OUFJ40/7OTKX1PQrzFSmERXH5Xv9CICSMkfPS4Lnn1FLexIxyPCz21UjTib2tyBsYSHWvfO0D6THiE3+LGxND4ta6EMUUY42HJGb0M65WA1FS+C/00Iy7zH/RYGRe+ekJWs93kEVLO+nBrI7i+HtnMQDkS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrJZPtBt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFAAC4CEF0;
	Thu, 26 Jun 2025 23:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982208;
	bh=RpFnlBNANteGCRsJC4kUjhp7pwuG/SjD6jbzG+crZyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrJZPtBtBM9pOXzRvUSMDFw1GLhaqYvqiiCCfwydZmQjBv83YyunW2ng7yzZrn/y3
	 oz0v4n5BXjww5Qdn2k9an2s10WaGNN/wY+cxz3hYi2v9flGS8YHIcEcGZBgeZ+xAXi
	 qBeo0yRIo2Y3+WPXh3VEF7HNDQyPGv8O1selQtk/ImiyF205J/LaqEkyYSW/Kps+OT
	 hN6fIt3DyqfgRbbnPwMzZ5cQf/3L33bhEswNc2vUrrMRhBnkzHuvfD5ZmThZQcIxS/
	 WsMaYt1G0QKwg/pzij3XiqooJpPfV3erxTN2Ab5JYwSPGL22tsMcq347DglRjAz41q
	 f8TypoxlV5agg==
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
Subject: [PATCH v3 52/64] objtool/klp: Introduce klp diff subcommand for diffing object files
Date: Thu, 26 Jun 2025 16:55:39 -0700
Message-ID: <d2d72fbe1a4762858742efece78c16d7034921b8.1750980517.git.jpoimboe@kernel.org>
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

Add a new klp diff subcommand which performs a binary diff between two
object files and extracts changed functions into a new object which can
then be linked into a livepatch module.

This builds on concepts from the longstanding out-of-tree kpatch [1]
project which began in 2012 and has been used for many years to generate
livepatch modules for production kernels.  However, this is a complete
rewrite which incorporates hard-earned lessons from 12+ years of
maintaining kpatch.

Key improvements compared to kpatch-build:

  - Integrated with objtool: Leverages objtool's existing control-flow
    graph analysis to help detect changed functions.

  - Works on vmlinux.o: Supports late-linked objects, making it
    compatible with LTO, IBT, and similar.

  - Simplified code base: ~3k fewer lines of code.

  - Upstream: No more out-of-tree #ifdef hacks, far less cruft.

  - Cleaner internals: Vastly simplified logic for symbol/section/reloc
    inclusion and special section extraction.

  - Robust __LINE__ macro handling: Avoids false positive binary diffs
    caused by the __LINE__ macro by introducing a fix-patch-lines script
    (coming in a later patch) which injects #line directives into the
    source .patch to preserve the original line numbers at compile time.

Note the end result of this subcommand is not yet functionally complete.
Livepatch needs some ELF magic which linkers don't like:

  - Two relocation sections (.rela*, .klp.rela*) for the same text
    section.

  - Use of SHN_LIVEPATCH to mark livepatch symbols.

Unfortunately linkers tend to mangle such things.  To work around that,
klp diff generates a linker-compliant intermediate binary which encodes
the relevant KLP section/reloc/symbol metadata.

After module linking, a klp post-link step (coming soon) will clean up
the mess and convert the linked .ko into a fully compliant livepatch
module.

Note this subcommand requires the diffed binaries to have been compiled
with -ffunction-sections and -fdata-sections, and processed with
'objtool --checksum'.  Those constraints will be handled by a klp-build
script introduced in a later patch.

Without '-ffunction-sections -fdata-sections', reliable object diffing
would be infeasible due to toolchain limitations:

  - For intra-file+intra-section references, the compiler might
    occasionally generated hard-coded instruction offsets instead of
    relocations.

  - Section-symbol-based references can be ambiguous:

    - Overlapping or zero-length symbols create ambiguity as to which
      symbol is being referenced.

    - A reference to the end of a symbol (e.g., checking array bounds)
      can be misinterpreted as a reference to the next symbol, or vice
      versa.

A potential future alternative to '-ffunction-sections -fdata-sections'
would be to introduce a toolchain option that forces symbol-based
(non-section) relocations.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 MAINTAINERS                              |    2 +-
 include/linux/livepatch.h                |   25 +-
 include/linux/livepatch_external.h       |   76 +
 kernel/livepatch/core.c                  |    4 +-
 scripts/module.lds.S                     |   10 +-
 tools/include/linux/livepatch_external.h |   76 +
 tools/include/linux/string.h             |   14 +
 tools/objtool/Build                      |    4 +-
 tools/objtool/Makefile                   |    3 +-
 tools/objtool/arch/x86/decode.c          |   40 +
 tools/objtool/builtin-klp.c              |   52 +
 tools/objtool/check.c                    |   14 -
 tools/objtool/elf.c                      |   21 +-
 tools/objtool/include/objtool/arch.h     |    1 +
 tools/objtool/include/objtool/builtin.h  |    2 +
 tools/objtool/include/objtool/elf.h      |   52 +-
 tools/objtool/include/objtool/klp.h      |   31 +
 tools/objtool/include/objtool/objtool.h  |    2 +
 tools/objtool/include/objtool/util.h     |   19 +
 tools/objtool/klp-diff.c                 | 1600 ++++++++++++++++++++++
 tools/objtool/objtool.c                  |   41 +-
 tools/objtool/sync-check.sh              |    1 +
 tools/objtool/weak.c                     |    7 +
 23 files changed, 2038 insertions(+), 59 deletions(-)
 create mode 100644 include/linux/livepatch_external.h
 create mode 100644 tools/include/linux/livepatch_external.h
 create mode 100644 tools/objtool/builtin-klp.c
 create mode 100644 tools/objtool/include/objtool/klp.h
 create mode 100644 tools/objtool/include/objtool/util.h
 create mode 100644 tools/objtool/klp-diff.c

diff --git a/MAINTAINERS b/MAINTAINERS
index efb51ee92683..0298d9570ca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14002,7 +14002,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.g
 F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 F:	Documentation/livepatch/
 F:	arch/powerpc/include/asm/livepatch.h
-F:	include/linux/livepatch.h
+F:	include/linux/livepatch*.h
 F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	samples/livepatch/
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..772919e8096a 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -13,6 +13,7 @@
 #include <linux/ftrace.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/livepatch_external.h>
 #include <linux/livepatch_sched.h>
 
 #if IS_ENABLED(CONFIG_LIVEPATCH)
@@ -77,30 +78,6 @@ struct klp_func {
 	bool transition;
 };
 
-struct klp_object;
-
-/**
- * struct klp_callbacks - pre/post live-(un)patch callback structure
- * @pre_patch:		executed before code patching
- * @post_patch:		executed after code patching
- * @pre_unpatch:	executed before code unpatching
- * @post_unpatch:	executed after code unpatching
- * @post_unpatch_enabled:	flag indicating if post-unpatch callback
- * 				should run
- *
- * All callbacks are optional.  Only the pre-patch callback, if provided,
- * will be unconditionally executed.  If the parent klp_object fails to
- * patch for any reason, including a non-zero error status returned from
- * the pre-patch callback, no further callbacks will be executed.
- */
-struct klp_callbacks {
-	int (*pre_patch)(struct klp_object *obj);
-	void (*post_patch)(struct klp_object *obj);
-	void (*pre_unpatch)(struct klp_object *obj);
-	void (*post_unpatch)(struct klp_object *obj);
-	bool post_unpatch_enabled;
-};
-
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
diff --git a/include/linux/livepatch_external.h b/include/linux/livepatch_external.h
new file mode 100644
index 000000000000..138af19b0f5c
--- /dev/null
+++ b/include/linux/livepatch_external.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * External livepatch interfaces for patch creation tooling
+ */
+
+#ifndef _LINUX_LIVEPATCH_EXTERNAL_H_
+#define _LINUX_LIVEPATCH_EXTERNAL_H_
+
+#include <linux/types.h>
+
+#define KLP_RELOC_SEC_PREFIX		".klp.rela."
+#define KLP_SYM_PREFIX			".klp.sym."
+
+#define __KLP_PRE_PATCH_PREFIX		__klp_pre_patch_callback_
+#define __KLP_POST_PATCH_PREFIX		__klp_post_patch_callback_
+#define __KLP_PRE_UNPATCH_PREFIX	__klp_pre_unpatch_callback_
+#define __KLP_POST_UNPATCH_PREFIX	__klp_post_unpatch_callback_
+
+#define KLP_PRE_PATCH_PREFIX		__stringify(__KLP_PRE_PATCH_PREFIX)
+#define KLP_POST_PATCH_PREFIX		__stringify(__KLP_POST_PATCH_PREFIX)
+#define KLP_PRE_UNPATCH_PREFIX		__stringify(__KLP_PRE_UNPATCH_PREFIX)
+#define KLP_POST_UNPATCH_PREFIX		__stringify(__KLP_POST_UNPATCH_PREFIX)
+
+struct klp_object;
+
+typedef int (*klp_pre_patch_t)(struct klp_object *obj);
+typedef void (*klp_post_patch_t)(struct klp_object *obj);
+typedef void (*klp_pre_unpatch_t)(struct klp_object *obj);
+typedef void (*klp_post_unpatch_t)(struct klp_object *obj);
+
+/**
+ * struct klp_callbacks - pre/post live-(un)patch callback structure
+ * @pre_patch:		executed before code patching
+ * @post_patch:		executed after code patching
+ * @pre_unpatch:	executed before code unpatching
+ * @post_unpatch:	executed after code unpatching
+ * @post_unpatch_enabled:	flag indicating if post-unpatch callback
+ *				should run
+ *
+ * All callbacks are optional.  Only the pre-patch callback, if provided,
+ * will be unconditionally executed.  If the parent klp_object fails to
+ * patch for any reason, including a non-zero error status returned from
+ * the pre-patch callback, no further callbacks will be executed.
+ */
+struct klp_callbacks {
+	klp_pre_patch_t		pre_patch;
+	klp_post_patch_t	post_patch;
+	klp_pre_unpatch_t	pre_unpatch;
+	klp_post_unpatch_t	post_unpatch;
+	bool post_unpatch_enabled;
+};
+
+/*
+ * 'struct klp_{func,object}_ext' are compact "external" representations of
+ * 'struct klp_{func,object}'.   They are used by objtool for livepatch
+ * generation.  The structs are then read by the livepatch module and converted
+ * to the real structs before calling klp_enable_patch().
+ *
+ * TODO make these the official API for klp_enable_patch().  That should
+ * simplify livepatch's interface as well as its data structure lifetime
+ * management.
+ */
+struct klp_func_ext {
+	const char *old_name;
+	void *new_func;
+	unsigned long sympos;
+};
+
+struct klp_object_ext {
+	const char *name;
+	struct klp_func_ext *funcs;
+	struct klp_callbacks callbacks;
+	unsigned int nr_funcs;
+};
+
+#endif /* _LINUX_LIVEPATCH_EXTERNAL_H_ */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 7e443c2cf7d4..0044a8125013 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -224,7 +224,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%511[^,],%lu",
+			     KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
@@ -303,7 +303,7 @@ static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	 * See comment in klp_resolve_symbols() for an explanation
 	 * of the selected field width value.
 	 */
-	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELOC_SEC_PREFIX "%55[^.]",
 		     sec_objname);
 	if (cnt != 1) {
 		pr_err("section %s has an incorrectly formatted name\n",
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 0b5ea63d1c67..05abb3ceabef 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -34,8 +34,16 @@ SECTIONS {
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
+	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
+
+	__klp_objects		0: ALIGN(8) {
+		__start_klp_objects = .;
+		KEEP(*(__klp_objects))
+		__stop_klp_objects = .;
+	}
+
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
-	__kcfi_traps 		: { KEEP(*(.kcfi_traps)) }
+	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
 #endif
 
 	.text : {
diff --git a/tools/include/linux/livepatch_external.h b/tools/include/linux/livepatch_external.h
new file mode 100644
index 000000000000..138af19b0f5c
--- /dev/null
+++ b/tools/include/linux/livepatch_external.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * External livepatch interfaces for patch creation tooling
+ */
+
+#ifndef _LINUX_LIVEPATCH_EXTERNAL_H_
+#define _LINUX_LIVEPATCH_EXTERNAL_H_
+
+#include <linux/types.h>
+
+#define KLP_RELOC_SEC_PREFIX		".klp.rela."
+#define KLP_SYM_PREFIX			".klp.sym."
+
+#define __KLP_PRE_PATCH_PREFIX		__klp_pre_patch_callback_
+#define __KLP_POST_PATCH_PREFIX		__klp_post_patch_callback_
+#define __KLP_PRE_UNPATCH_PREFIX	__klp_pre_unpatch_callback_
+#define __KLP_POST_UNPATCH_PREFIX	__klp_post_unpatch_callback_
+
+#define KLP_PRE_PATCH_PREFIX		__stringify(__KLP_PRE_PATCH_PREFIX)
+#define KLP_POST_PATCH_PREFIX		__stringify(__KLP_POST_PATCH_PREFIX)
+#define KLP_PRE_UNPATCH_PREFIX		__stringify(__KLP_PRE_UNPATCH_PREFIX)
+#define KLP_POST_UNPATCH_PREFIX		__stringify(__KLP_POST_UNPATCH_PREFIX)
+
+struct klp_object;
+
+typedef int (*klp_pre_patch_t)(struct klp_object *obj);
+typedef void (*klp_post_patch_t)(struct klp_object *obj);
+typedef void (*klp_pre_unpatch_t)(struct klp_object *obj);
+typedef void (*klp_post_unpatch_t)(struct klp_object *obj);
+
+/**
+ * struct klp_callbacks - pre/post live-(un)patch callback structure
+ * @pre_patch:		executed before code patching
+ * @post_patch:		executed after code patching
+ * @pre_unpatch:	executed before code unpatching
+ * @post_unpatch:	executed after code unpatching
+ * @post_unpatch_enabled:	flag indicating if post-unpatch callback
+ *				should run
+ *
+ * All callbacks are optional.  Only the pre-patch callback, if provided,
+ * will be unconditionally executed.  If the parent klp_object fails to
+ * patch for any reason, including a non-zero error status returned from
+ * the pre-patch callback, no further callbacks will be executed.
+ */
+struct klp_callbacks {
+	klp_pre_patch_t		pre_patch;
+	klp_post_patch_t	post_patch;
+	klp_pre_unpatch_t	pre_unpatch;
+	klp_post_unpatch_t	post_unpatch;
+	bool post_unpatch_enabled;
+};
+
+/*
+ * 'struct klp_{func,object}_ext' are compact "external" representations of
+ * 'struct klp_{func,object}'.   They are used by objtool for livepatch
+ * generation.  The structs are then read by the livepatch module and converted
+ * to the real structs before calling klp_enable_patch().
+ *
+ * TODO make these the official API for klp_enable_patch().  That should
+ * simplify livepatch's interface as well as its data structure lifetime
+ * management.
+ */
+struct klp_func_ext {
+	const char *old_name;
+	void *new_func;
+	unsigned long sympos;
+};
+
+struct klp_object_ext {
+	const char *name;
+	struct klp_func_ext *funcs;
+	struct klp_callbacks callbacks;
+	unsigned int nr_funcs;
+};
+
+#endif /* _LINUX_LIVEPATCH_EXTERNAL_H_ */
diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
index 8499f509f03e..51ad3cf4fa82 100644
--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -44,6 +44,20 @@ static inline bool strstarts(const char *str, const char *prefix)
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 
+/*
+ * Checks if a string ends with another.
+ */
+static inline bool str_ends_with(const char *str, const char *substr)
+{
+	size_t len = strlen(str);
+	size_t sublen = strlen(substr);
+
+	if (sublen > len)
+		return false;
+
+	return !strcmp(str + len - sublen, substr);
+}
+
 extern char * __must_check skip_spaces(const char *);
 
 extern char *strim(char *);
diff --git a/tools/objtool/Build b/tools/objtool/Build
index a3cdf8af6635..0b01657671d7 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -8,8 +8,8 @@ objtool-y += builtin-check.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
-objtool-$(BUILD_ORC) += orc_gen.o
-objtool-$(BUILD_ORC) += orc_dump.o
+objtool-$(BUILD_ORC) += orc_gen.o orc_dump.o
+objtool-$(BUILD_KLP) += builtin-klp.o klp-diff.o
 
 objtool-y += libstring.o
 objtool-y += libctype.o
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 958761c05b7c..48928c9bebef 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -15,13 +15,14 @@ ifeq ($(ARCH_HAS_KLP),y)
 	HAVE_XXHASH = $(shell echo "int main() {}" | \
 		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
 	ifeq ($(HAVE_XXHASH),y)
+		BUILD_KLP	 := y
 		LIBXXHASH_CFLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null) \
 				    -DBUILD_KLP
 		LIBXXHASH_LIBS   := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
 	endif
 endif
 
-export BUILD_ORC
+export BUILD_ORC BUILD_KLP
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 36a65cecada3..c4d6b90b1134 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -89,6 +89,46 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 	return phys_to_virt(addend);
 }
 
+static void scan_for_insn(struct section *sec, unsigned long offset,
+			  unsigned long *insn_off, unsigned int *insn_len)
+{
+	unsigned long o = 0;
+	struct insn insn;
+
+	while (1) {
+
+		insn_decode(&insn, sec->data->d_buf + o, sec_size(sec) - o,
+			    INSN_MODE_64);
+
+		if (o + insn.length > offset) {
+			*insn_off = o;
+			*insn_len = insn.length;
+			return;
+		}
+
+		o += insn.length;
+	}
+}
+
+u64 arch_adjusted_addend(struct reloc *reloc)
+{
+	unsigned int type = reloc_type(reloc);
+	s64 addend = reloc_addend(reloc);
+	unsigned long insn_off;
+	unsigned int insn_len;
+
+	if (type == R_X86_64_PLT32)
+		return addend + 4;
+
+	if (type != R_X86_64_PC32 || !is_text_sec(reloc->sec->base))
+		return addend;
+
+	scan_for_insn(reloc->sec->base, reloc_offset(reloc),
+		      &insn_off, &insn_len);
+
+	return addend + insn_off + insn_len - reloc_offset(reloc);
+}
+
 unsigned long arch_jump_destination(struct instruction *insn)
 {
 	return insn->offset + insn->len + insn->immediate;
diff --git a/tools/objtool/builtin-klp.c b/tools/objtool/builtin-klp.c
new file mode 100644
index 000000000000..9b13dd1182af
--- /dev/null
+++ b/tools/objtool/builtin-klp.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <subcmd/parse-options.h>
+#include <string.h>
+#include <stdlib.h>
+#include <objtool/builtin.h>
+#include <objtool/objtool.h>
+#include <objtool/klp.h>
+
+struct subcmd {
+	const char *name;
+	const char *description;
+	int (*fn)(int, const char **);
+};
+
+static struct subcmd subcmds[] = {
+	{ "diff",		"Generate binary diff of two object files",		cmd_klp_diff, },
+};
+
+static void cmd_klp_usage(void)
+{
+	fprintf(stderr, "usage: objtool klp <subcommand> [<options>]\n\n");
+	fprintf(stderr, "Subcommands:\n");
+
+	for (int i = 0; i < ARRAY_SIZE(subcmds); i++) {
+		struct subcmd *cmd = &subcmds[i];
+
+		fprintf(stderr, "  %s\t%s\n", cmd->name, cmd->description);
+	}
+
+	exit(1);
+}
+
+int cmd_klp(int argc, const char **argv)
+{
+	argc--;
+	argv++;
+
+	if (!argc)
+		cmd_klp_usage();
+
+	if (argc) {
+		for (int i = 0; i < ARRAY_SIZE(subcmds); i++) {
+			struct subcmd *cmd = &subcmds[i];
+
+			if (!strcmp(cmd->name, argv[0]))
+				return cmd->fn(argc, argv);
+		}
+	}
+
+	cmd_klp_usage();
+	return 0;
+}
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 7e492945e5e5..9d1f545279a6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -186,20 +186,6 @@ static bool is_sibling_call(struct instruction *insn)
 	return (is_static_jump(insn) && insn_call_dest(insn));
 }
 
-/*
- * Checks if a string ends with another.
- */
-static bool str_ends_with(const char *s, const char *sub)
-{
-	const int slen = strlen(s);
-	const int sublen = strlen(sub);
-
-	if (sublen > slen)
-		return 0;
-
-	return !memcmp(s + slen - sublen, sub, sublen);
-}
-
 /*
  * Checks if a function is a Rust "noreturn" one.
  */
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d2f418a34881..16c8d36afe4e 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -288,6 +288,18 @@ struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 	return NULL;
 }
 
+struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name)
+{
+	struct symbol *sym;
+
+	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(name)) {
+		if (!strcmp(sym->name, name) && !is_local_sym(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
@@ -475,6 +487,8 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 	else
 		entry = &sym->sec->symbol_list;
 	list_add(&sym->list, entry);
+
+	list_add_tail(&sym->global_list, &elf->symbols);
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
@@ -528,6 +542,9 @@ static int read_symbols(struct elf *elf)
 		ERROR_GLIBC("calloc");
 		return -1;
 	}
+
+	INIT_LIST_HEAD(&elf->symbols);
+
 	for (i = 0; i < symbols_nr; i++) {
 		sym = &elf->symbol_data[i];
 
@@ -636,7 +653,7 @@ static int mark_group_syms(struct elf *elf)
 		return -1;
 	}
 
-	list_for_each_entry(sec, &elf->sections, list) {
+	for_each_sec(elf, sec) {
 		if (sec->sh.sh_type == SHT_GROUP &&
 		    sec->sh.sh_link == symtab->idx) {
 			sym = find_symbol_by_index(elf, sec->sh.sh_info);
@@ -1219,6 +1236,8 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 		return NULL;
 	}
 
+	INIT_LIST_HEAD(&elf->symbols);
+
 	if (!elf_alloc_hash(section,		1000) ||
 	    !elf_alloc_hash(section_name,	1000) ||
 	    !elf_alloc_hash(symbol,		10000) ||
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 07729a240159..03c86caec4d6 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -84,6 +84,7 @@ bool arch_callee_saved_reg(unsigned char reg);
 unsigned long arch_jump_destination(struct instruction *insn);
 
 s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc);
+u64 arch_adjusted_addend(struct reloc *reloc);
 
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 92bc7089cfc1..e60438577000 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -52,4 +52,6 @@ int objtool_run(int argc, const char **argv);
 
 int make_backup(void);
 
+int cmd_klp(int argc, const char **argv);
+
 #endif /* _BUILTIN_H */
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 4cfd09e66cb5..903cbcb84e6b 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -17,6 +17,7 @@
 #include <objtool/checksum_types.h>
 #include <arch/elf.h>
 
+#define SEC_NAME_LEN		1024
 #define SYM_NAME_LEN		512
 
 #ifdef LIBELF_USE_DEPRECATED
@@ -50,10 +51,12 @@ struct section {
 	bool _changed, text, rodata, noinstr, init, truncate;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
+	struct section *twin;
 };
 
 struct symbol {
 	struct list_head list;
+	struct list_head global_list;
 	struct rb_node node;
 	struct elf_hash_node hash;
 	struct elf_hash_node name_hash;
@@ -79,10 +82,13 @@ struct symbol {
 	u8 cold		     : 1;
 	u8 prefix	     : 1;
 	u8 debug_checksum    : 1;
+	u8 changed	     : 1;
+	u8 included	     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
 	struct checksum csum;
+	struct symbol *twin, *clone;
 };
 
 struct reloc {
@@ -100,6 +106,7 @@ struct elf {
 	const char *name, *tmp_name;
 	unsigned int num_files;
 	struct list_head sections;
+	struct list_head symbols;
 	unsigned long num_relocs;
 
 	int symbol_bits;
@@ -175,6 +182,7 @@ struct section *find_section_by_name(const struct elf *elf, const char *name);
 struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
+struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
@@ -435,22 +443,44 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
+#define sec_prev_sym(sym)						\
+	sym->sec && sym->list.prev != &sym->sec->symbol_list ?		\
+	list_prev_entry(sym, list) : NULL
+
 #define for_each_sym(elf, sym)						\
-	for (struct section *__sec, *__fake = (struct section *)1;	\
-	     __fake; __fake = NULL)					\
-		for_each_sec(elf, __sec)				\
-			sec_for_each_sym(__sec, sym)
+	list_for_each_entry(sym, &elf->symbols, global_list)
+
+#define for_each_sym_continue(elf, sym)					\
+	list_for_each_entry_continue(sym, &elf->symbols, global_list)
+
+#define rsec_next_reloc(rsec, reloc)					\
+	reloc_idx(reloc) < sec_num_entries(rsec) - 1 ? reloc + 1 : NULL
 
 #define for_each_reloc(rsec, reloc)					\
-	for (int __i = 0, __fake = 1; __fake; __fake = 0)		\
-		for (reloc = rsec->relocs;				\
-		     __i < sec_num_entries(rsec);			\
-		     __i++, reloc++)
+	for (reloc = rsec->relocs; reloc; reloc = rsec_next_reloc(rsec, reloc))
 
 #define for_each_reloc_from(rsec, reloc)				\
-	for (int __i = reloc_idx(reloc);				\
-	     __i < sec_num_entries(rsec);				\
-	     __i++, reloc++)
+	for (; reloc; reloc = rsec_next_reloc(rsec, reloc))
+
+#define sym_for_each_reloc(elf, sym, reloc)				\
+	for (reloc = find_reloc_by_dest_range(elf, sym->sec,		\
+					      sym->offset, sym->len);	\
+	     reloc && reloc_offset(reloc) <  sym->offset + sym->len;	\
+	     reloc = rsec_next_reloc(sym->sec->rsec, reloc))
+
+static inline struct symbol *get_func_prefix(struct symbol *func)
+{
+	struct symbol *prev;
+
+	if (!is_func_sym(func))
+		return NULL;
+
+	prev = sec_prev_sym(func);
+	if (prev && is_prefix_func(prev))
+		return prev;
+
+	return NULL;
+}
 
 #define OFFSET_STRIDE_BITS	4
 #define OFFSET_STRIDE		(1UL << OFFSET_STRIDE_BITS)
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
new file mode 100644
index 000000000000..07928fac059b
--- /dev/null
+++ b/tools/objtool/include/objtool/klp.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _OBJTOOL_KLP_H
+#define _OBJTOOL_KLP_H
+
+/*
+ * __klp_objects and __klp_funcs are created by klp diff and used by the patch
+ * module init code to build the klp_patch, klp_object and klp_func structs
+ * needed by the livepatch API.
+ */
+#define KLP_OBJECTS_SEC	"__klp_objects"
+#define KLP_FUNCS_SEC	"__klp_funcs"
+
+/*
+ * __klp_relocs is an intermediate section which are created by klp diff and
+ * converted into KLP symbols/relas by "objtool klp post-link".  This is needed
+ * to work around the linker, which doesn't preserve SHN_LIVEPATCH or
+ * SHF_RELA_LIVEPATCH, nor does it support having two RELA sections for a
+ * single PROGBITS section.
+ */
+#define KLP_RELOCS_SEC	"__klp_relocs"
+#define KLP_STRINGS_SEC	".rodata.klp.str1.1"
+
+struct klp_reloc {
+	void *offset;
+	void *sym;
+	u32 type;
+};
+
+int cmd_klp_diff(int argc, const char **argv);
+
+#endif /* _OBJTOOL_KLP_H */
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 90c591b5bd68..37e9fe4492d6 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -41,6 +41,8 @@ struct objtool_file {
 	struct pv_state *pv_ops;
 };
 
+char *top_level_dir(const char *file);
+
 struct objtool_file *objtool_open_read(const char *_objname);
 
 int objtool_pv_add(struct objtool_file *file, int idx, struct symbol *func);
diff --git a/tools/objtool/include/objtool/util.h b/tools/objtool/include/objtool/util.h
new file mode 100644
index 000000000000..a0180b312f73
--- /dev/null
+++ b/tools/objtool/include/objtool/util.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _UTIL_H
+#define _UTIL_H
+
+#include <objtool/warn.h>
+
+#define snprintf_check(str, size, format, args...)			\
+({									\
+	int __ret = snprintf(str, size, format, args);			\
+	if (__ret < 0)							\
+		ERROR_GLIBC("snprintf");				\
+	else if (__ret >= size)						\
+		ERROR("snprintf() failed for '" format "'", args);	\
+	else								\
+		__ret = 0;						\
+	__ret;								\
+})
+
+#endif /* _UTIL_H */
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
new file mode 100644
index 000000000000..85c6a480ecdb
--- /dev/null
+++ b/tools/objtool/klp-diff.c
@@ -0,0 +1,1600 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#define _GNU_SOURCE /* memmem() */
+#include <subcmd/parse-options.h>
+#include <stdlib.h>
+#include <string.h>
+#include <libgen.h>
+#include <stdio.h>
+#include <ctype.h>
+
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/arch.h>
+#include <objtool/klp.h>
+#include <objtool/util.h>
+#include <arch/special.h>
+
+#include <linux/livepatch_external.h>
+#include <linux/stringify.h>
+#include <linux/string.h>
+#include <linux/jhash.h>
+
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+
+struct elfs {
+	struct elf *orig, *patched, *out;
+	const char *modname;
+};
+
+struct export {
+	struct hlist_node hash;
+	char *mod, *sym;
+};
+
+static const char * const klp_diff_usage[] = {
+	"objtool klp diff [<options>] <in1.o> <in2.o> <out.o>",
+	NULL,
+};
+
+static const struct option klp_diff_options[] = {
+	OPT_END(),
+};
+
+static DEFINE_HASHTABLE(exports, 15);
+
+static inline u32 str_hash(const char *str)
+{
+	return jhash(str, strlen(str), 0);
+}
+
+static int read_exports(void)
+{
+	const char *symvers = "Module.symvers";
+	char line[1024], *path = NULL;
+	unsigned int line_num = 1;
+	FILE *file;
+
+	file = fopen(symvers, "r");
+	if (!file) {
+		path = top_level_dir(symvers);
+		if (!path) {
+			ERROR("can't open '%s', \"objtool diff\" should be run from the kernel tree", symvers);
+			return -1;
+		}
+
+		file = fopen(path, "r");
+		if (!file) {
+			ERROR_GLIBC("fopen");
+			return -1;
+		}
+	}
+
+	while (fgets(line, 1024, file)) {
+		char *sym, *mod, *type;
+		struct export *export;
+
+		sym = strchr(line, '\t');
+		if (!sym) {
+			ERROR("malformed Module.symvers (sym) at line %d", line_num);
+			return -1;
+		}
+
+		*sym++ = '\0';
+
+		mod = strchr(sym, '\t');
+		if (!mod) {
+			ERROR("malformed Module.symvers (mod) at line %d", line_num);
+			return -1;
+		}
+
+		*mod++ = '\0';
+
+		type = strchr(mod, '\t');
+		if (!type) {
+			ERROR("malformed Module.symvers (type) at line %d", line_num);
+			return -1;
+		}
+
+		*type++ = '\0';
+
+		if (*sym == '\0' || *mod == '\0') {
+			ERROR("malformed Module.symvers at line %d", line_num);
+			return -1;
+		}
+
+		export = calloc(1, sizeof(*export));
+		if (!export) {
+			ERROR_GLIBC("calloc");
+			return -1;
+		}
+
+		export->mod = strdup(mod);
+		if (!export->mod) {
+			ERROR_GLIBC("strdup");
+			return -1;
+		}
+
+		export->sym = strdup(sym);
+		if (!export->sym) {
+			ERROR_GLIBC("strdup");
+			return -1;
+		}
+
+		hash_add(exports, &export->hash, str_hash(sym));
+	}
+
+	free(path);
+	fclose(file);
+
+	return 0;
+}
+
+static int read_sym_checksums(struct elf *elf)
+{
+	struct section *sec;
+
+	sec = find_section_by_name(elf, SYM_CHECKSUM_SEC);
+	if (!sec) {
+		ERROR("'%s' missing " SYM_CHECKSUM_SEC " section, file not processed by 'objtool --checksum'?",
+		      elf->name);
+		return -1;
+	}
+
+	if (!sec->rsec) {
+		ERROR("missing reloc section for " SYM_CHECKSUM_SEC);
+		return -1;
+	}
+
+	if (sec_size(sec) % sizeof(struct sym_checksum)) {
+		ERROR("struct sym_checksum size mismatch");
+		return -1;
+	}
+
+	for (int i = 0; i < sec_size(sec) / sizeof(struct sym_checksum); i++) {
+		struct sym_checksum *sym_checksum;
+		struct reloc *reloc;
+		struct symbol *sym;
+
+		sym_checksum = (struct sym_checksum *)sec->data->d_buf + i;
+
+		reloc = find_reloc_by_dest(elf, sec, i * sizeof(*sym_checksum));
+		if (!reloc) {
+			ERROR("can't find reloc for sym_checksum[%d]", i);
+			return -1;
+		}
+
+		sym = reloc->sym;
+
+		if (is_sec_sym(sym)) {
+			ERROR("not sure how to handle section %s", sym->name);
+			return -1;
+		}
+
+		if (is_func_sym(sym))
+			sym->csum.checksum = sym_checksum->checksum;
+	}
+
+	return 0;
+}
+
+static struct symbol *first_file_symbol(struct elf *elf)
+{
+	struct symbol *sym;
+
+	for_each_sym(elf, sym) {
+		if (is_file_sym(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
+static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
+{
+	for_each_sym_continue(elf, sym) {
+		if (is_file_sym(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
+/*
+ * Certain static local variables should never be correlated.  They will be
+ * used in place rather than referencing the originals.
+ */
+static bool is_uncorrelated_static_local(struct symbol *sym)
+{
+	static const char * const vars[] = {
+		"__key.",
+		"__warned.",
+		"__already_done.",
+		"__func__.",
+		"_rs.",
+		"descriptor.",
+		"CSWTCH.",
+	};
+
+	if (!is_object_sym(sym) || !is_local_sym(sym))
+		return false;
+
+	if (!strcmp(sym->sec->name, ".data.once"))
+		return true;
+
+	for (int i = 0; i < ARRAY_SIZE(vars); i++) {
+		if (strstarts(sym->name, vars[i]))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Clang emits several useless .Ltmp_* code labels.
+ */
+static bool is_clang_tmp_label(struct symbol *sym)
+{
+	return sym->type == STT_NOTYPE &&
+	       is_text_sec(sym->sec) &&
+	       strstarts(sym->name, ".Ltmp") &&
+	       isdigit(sym->name[5]);
+}
+
+static bool is_special_section(struct section *sec)
+{
+	static const char * const specials[] = {
+		".altinstructions",
+		".smp_locks",
+		"__bug_table",
+		"__ex_table",
+		"__jump_table",
+		"__mcount_loc",
+
+		/*
+		 * Extract .static_call_sites here to inherit non-module
+		 * preferential treatment.  The later static call processing
+		 * during klp module build will be skipped when it sees this
+		 * section already exists.
+		 */
+		".static_call_sites",
+	};
+
+	static const char * const non_special_discards[] = {
+		".discard.addressable",
+		SYM_CHECKSUM_SEC,
+	};
+
+	if (is_text_sec(sec))
+		return false;
+
+	for (int i = 0; i < ARRAY_SIZE(specials); i++) {
+		if (!strcmp(sec->name, specials[i]))
+			return true;
+	}
+
+	/* Most .discard data sections are special */
+	for (int i = 0; i < ARRAY_SIZE(non_special_discards); i++) {
+		if (!strcmp(sec->name, non_special_discards[i]))
+			return false;
+	}
+
+	return strstarts(sec->name, ".discard.");
+}
+
+/*
+ * These sections are referenced by special sections but aren't considered
+ * special sections themselves.
+ */
+static bool is_special_section_aux(struct section *sec)
+{
+	static const char * const specials_aux[] = {
+		".altinstr_replacement",
+		".altinstr_aux",
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(specials_aux); i++) {
+		if (!strcmp(sec->name, specials_aux[i]))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * These symbols should never be correlated, so their local patched versions
+ * are used instead of linking to the originals.
+ */
+static bool dont_correlate(struct symbol *sym)
+{
+	return is_file_sym(sym) ||
+	       is_null_sym(sym) ||
+	       is_sec_sym(sym) ||
+	       is_prefix_func(sym) ||
+	       is_uncorrelated_static_local(sym) ||
+	       is_clang_tmp_label(sym) ||
+	       is_string_sec(sym->sec) ||
+	       is_special_section(sym->sec) ||
+	       is_special_section_aux(sym->sec) ||
+	       strstarts(sym->name, "__initcall__");
+}
+
+/*
+ * For each symbol in the original kernel, find its corresponding "twin" in the
+ * patched kernel.
+ */
+static int correlate_symbols(struct elfs *e)
+{
+	struct symbol *file1_sym, *file2_sym;
+	struct symbol *sym1, *sym2;
+
+	/* Correlate locals */
+	for (file1_sym = first_file_symbol(e->orig),
+	     file2_sym = first_file_symbol(e->patched); ;
+	     file1_sym = next_file_symbol(e->orig, file1_sym),
+	     file2_sym = next_file_symbol(e->patched, file2_sym)) {
+
+		if (!file1_sym && file2_sym) {
+			ERROR("FILE symbol mismatch: NULL != %s", file2_sym->name);
+			return -1;
+		}
+
+		if (file1_sym && !file2_sym) {
+			ERROR("FILE symbol mismatch: %s != NULL", file1_sym->name);
+			return -1;
+		}
+
+		if (!file1_sym)
+			break;
+
+		if (strcmp(file1_sym->name, file2_sym->name)) {
+			ERROR("FILE symbol mismatch: %s != %s", file1_sym->name, file2_sym->name);
+			return -1;
+		}
+
+		file1_sym->twin = file2_sym;
+		file2_sym->twin = file1_sym;
+
+		sym1 = file1_sym;
+
+		for_each_sym_continue(e->orig, sym1) {
+			if (is_file_sym(sym1) || !is_local_sym(sym1))
+				break;
+
+			if (dont_correlate(sym1))
+				continue;
+
+			sym2 = file2_sym;
+			for_each_sym_continue(e->patched, sym2) {
+				if (is_file_sym(sym2) || !is_local_sym(sym2))
+					break;
+
+				if (sym2->twin || dont_correlate(sym2))
+					continue;
+
+				if (strcmp(sym1->demangled_name, sym2->demangled_name))
+					continue;
+
+				sym1->twin = sym2;
+				sym2->twin = sym1;
+				break;
+			}
+		}
+	}
+
+	/* Correlate globals */
+	for_each_sym(e->orig, sym1) {
+		if (sym1->bind == STB_LOCAL)
+			continue;
+
+		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+
+		if (sym2 && !sym2->twin && !strcmp(sym1->name, sym2->name)) {
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+		}
+	}
+
+	for_each_sym(e->orig, sym1) {
+		if (sym1->twin || dont_correlate(sym1))
+			continue;
+		WARN("no correlation: %s", sym1->name);
+	}
+
+	return 0;
+}
+
+/* "sympos" is used by livepatch to disambiguate duplicate symbol names */
+static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
+{
+	bool vmlinux = str_ends_with(objname, "vmlinux.o");
+	unsigned long sympos = 0, nr_matches = 0;
+	bool has_dup = false;
+	struct symbol *s;
+
+	if (sym->bind != STB_LOCAL)
+		return 0;
+
+	if (vmlinux && sym->type == STT_FUNC) {
+		/*
+		 * HACK: Unfortunately, symbol ordering can differ between
+		 * vmlinux.o and vmlinux due to the linker script emitting
+		 * .text.unlikely* before .text*.  Count .text.unlikely* first.
+		 *
+		 * TODO: Disambiguate symbols more reliably (checksums?)
+		 */
+		for_each_sym(elf, s) {
+			if (strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+		for_each_sym(elf, s) {
+			if (!strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+	} else {
+		for_each_sym(elf, s) {
+			if (!strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+	}
+
+	if (!sympos) {
+		ERROR("can't find sympos for %s", sym->name);
+		return ULONG_MAX;
+	}
+
+	return has_dup ? sympos : 0;
+}
+
+static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym);
+
+static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym,
+				     bool data_too)
+{
+	struct section *out_sec = NULL;
+	unsigned long offset = 0;
+	struct symbol *out_sym;
+
+	if (data_too && !is_undef_sym(patched_sym)) {
+		struct section *patched_sec = patched_sym->sec;
+
+		out_sec = find_section_by_name(elf, patched_sec->name);
+		if (!out_sec) {
+			out_sec = elf_create_section(elf, patched_sec->name, 0,
+						     patched_sec->sh.sh_entsize,
+						     patched_sec->sh.sh_type,
+						     patched_sec->sh.sh_addralign,
+						     patched_sec->sh.sh_flags);
+			if (!out_sec)
+				return NULL;
+		}
+
+		if (is_string_sec(patched_sym->sec)) {
+			out_sym = elf_create_section_symbol(elf, out_sec);
+			if (!out_sym)
+				return NULL;
+
+			goto sym_created;
+		}
+
+		if (!is_sec_sym(patched_sym))
+			offset = sec_size(out_sec);
+
+		if (patched_sym->len || is_sec_sym(patched_sym)) {
+			void *data = NULL;
+			size_t size;
+
+			/* bss doesn't have data */
+			if (patched_sym->sec->data->d_buf)
+				data = patched_sym->sec->data->d_buf + patched_sym->offset;
+
+			if (is_sec_sym(patched_sym))
+				size = sec_size(patched_sym->sec);
+			else
+				size = patched_sym->len;
+
+			if (!elf_add_data(elf, out_sec, data, size))
+				return NULL;
+		}
+	}
+
+	out_sym = elf_create_symbol(elf, patched_sym->name, out_sec,
+				    patched_sym->bind, patched_sym->type,
+				    offset, patched_sym->len);
+	if (!out_sym)
+		return NULL;
+
+sym_created:
+	patched_sym->clone = out_sym;
+	out_sym->clone = patched_sym;
+
+	return out_sym;
+}
+
+/*
+ * Copy a symbol to the output object, optionally including its data and
+ * relocations.
+ */
+static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
+				   bool data_too)
+{
+	struct symbol *pfx;
+
+	if (patched_sym->clone)
+		return patched_sym->clone;
+
+	/* Make sure the prefix gets cloned first */
+	if (is_func_sym(patched_sym) && data_too) {
+		pfx = get_func_prefix(patched_sym);
+		if (pfx)
+			clone_symbol(e, pfx, true);
+	}
+
+	if (!__clone_symbol(e->out, patched_sym, data_too))
+		return NULL;
+
+	if (data_too && clone_sym_relocs(e, patched_sym))
+		return NULL;
+
+	return patched_sym->clone;
+}
+
+static void mark_included_function(struct symbol *func)
+{
+	struct symbol *pfx;
+
+	func->included = 1;
+
+	/* Include prefix function */
+	pfx = get_func_prefix(func);
+	if (pfx)
+		pfx->included = 1;
+
+	/* Make sure .cold parent+child always stay together */
+	if (func->cfunc && func->cfunc != func)
+		func->cfunc->included = 1;
+	if (func->pfunc && func->pfunc != func)
+		func->pfunc->included = 1;
+}
+
+/*
+ * Copy all changed functions (and their dependencies) from the patched object
+ * to the output object.
+ */
+static int mark_changed_functions(struct elfs *e)
+{
+	struct symbol *sym_orig, *patched_sym;
+	bool changed = false;
+
+	/* Find changed functions */
+	for_each_sym(e->orig, sym_orig) {
+		if (!is_func_sym(sym_orig) || is_prefix_func(sym_orig))
+			continue;
+
+		patched_sym = sym_orig->twin;
+		if (!patched_sym)
+			continue;
+
+		if (sym_orig->csum.checksum != patched_sym->csum.checksum) {
+			patched_sym->changed = 1;
+			mark_included_function(patched_sym);
+			changed = true;
+		}
+	}
+
+	/* Find added functions and print them */
+	for_each_sym(e->patched, patched_sym) {
+		if (!is_func_sym(patched_sym) || is_prefix_func(patched_sym))
+			continue;
+
+		if (!patched_sym->twin) {
+			printf("%s: new function: %s\n", objname, patched_sym->name);
+			mark_included_function(patched_sym);
+			changed = true;
+		}
+	}
+
+	/* Print changed functions */
+	for_each_sym(e->patched, patched_sym) {
+		if (patched_sym->changed)
+			printf("%s: changed function: %s\n", objname, patched_sym->name);
+	}
+
+	return !changed ? -1 : 0;
+}
+
+static int clone_included_functions(struct elfs *e)
+{
+	struct symbol *patched_sym;
+
+	for_each_sym(e->patched, patched_sym) {
+		if (patched_sym->included) {
+			if (!clone_symbol(e, patched_sym, true))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Determine whether a relocation should reference the section rather than the
+ * underlying symbol.
+ */
+static bool section_reference_needed(struct section *sec)
+{
+	/*
+	 * String symbols are zero-length and uncorrelated.  It's easier to
+	 * deal with them as section symbols.
+	 */
+	if (is_string_sec(sec))
+		return true;
+
+	/*
+	 * .rodata has mostly anonymous data so there's no way to determine the
+	 * length of a needed reference.  just copy the whole section if needed.
+	 */
+	if (strstarts(sec->name, ".rodata"))
+		return true;
+
+	/* UBSAN anonymous data */
+	if (strstarts(sec->name, ".data..Lubsan") ||	/* GCC */
+	    strstarts(sec->name, ".data..L__unnamed_"))	/* Clang */
+		return true;
+
+	return false;
+}
+
+static bool is_reloc_allowed(struct reloc *reloc)
+{
+	return section_reference_needed(reloc->sym->sec) == is_sec_sym(reloc->sym);
+}
+
+static struct export *find_export(struct symbol *sym)
+{
+	struct export *export;
+
+	hash_for_each_possible(exports, export, hash, str_hash(sym->name)) {
+		if (!strcmp(export->sym, sym->name))
+			return export;
+	}
+
+	return NULL;
+}
+
+static const char *__find_modname(struct elfs *e)
+{
+	struct section *sec;
+	char *name;
+
+	sec = find_section_by_name(e->orig, ".modinfo");
+	if (!sec) {
+		ERROR("missing .modinfo section");
+		return NULL;
+	}
+
+	name = memmem(sec->data->d_buf, sec_size(sec), "\0name=", 6);
+	if (name)
+		return name + 6;
+
+	name = strdup(e->orig->name);
+	if (!name) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
+	for (char *c = name; *c; c++) {
+		if (*c == '/')
+			name = c + 1;
+		else if (*c == '-')
+			*c = '_';
+		else if (*c == '.') {
+			*c = '\0';
+			break;
+		}
+	}
+
+	return name;
+}
+
+/* Get the object's module name as defined by the kernel (and klp_object) */
+static const char *find_modname(struct elfs *e)
+{
+	const char *modname;
+
+	if (e->modname)
+		return e->modname;
+
+	modname = __find_modname(e);
+	e->modname = modname;
+	return modname;
+}
+
+/*
+ * Copying a function from its native compiled environment to a kernel module
+ * removes its natural access to local functions/variables and unexported
+ * globals.  References to such symbols need to be converted to KLP relocs so
+ * the kernel arch relocation code knows to apply them and where to find the
+ * symbols.  Particularly, duplicate static symbols need to be disambiguated.
+ */
+static bool klp_reloc_needed(struct reloc *patched_reloc)
+{
+	struct symbol *patched_sym = patched_reloc->sym;
+	struct export *export;
+
+	/* no external symbol to reference */
+	if (dont_correlate(patched_sym))
+		return false;
+
+	/* For included functions, a regular reloc will do. */
+	if (patched_sym->included)
+		return false;
+
+	/*
+	 * If exported by a module, it has to be a klp reloc.  Thanks to the
+	 * clusterfunk that is late module patching, the patch module is
+	 * allowed to be loaded before any modules it depends on.
+	 *
+	 * If exported by vmlinux, a normal reloc will do.
+	 */
+	export = find_export(patched_sym);
+	if (export)
+		return strcmp(export->mod, "vmlinux");
+
+	if (!patched_sym->twin) {
+		/*
+		 * Presumably the symbol and its reference were added by the
+		 * patch.  The symbol could be defined in this .o or in another
+		 * .o in the patch module.
+		 *
+		 * This check needs to be *after* the export check due to the
+		 * possibility of the patch adding a new UNDEF reference to an
+		 * exported symbol.
+		 */
+		return false;
+	}
+
+	/* Unexported symbol which lives in the original vmlinux or module. */
+	return true;
+}
+
+static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
+{
+	struct symbol *sym = reloc->sym;
+	struct section *sec = sym->sec;
+
+	if (!sec->sym && !elf_create_section_symbol(elf, sec))
+		return -1;
+
+	reloc->sym = sec->sym;
+	set_reloc_sym(elf, reloc, sym->idx);
+	set_reloc_addend(elf, reloc, sym->offset + reloc_addend(reloc));
+	return 0;
+}
+
+static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
+{
+	struct symbol *sym = reloc->sym;
+	struct section *sec = sym->sec;
+
+	/* If the symbol has a dedicated section, it's easy to find */
+	sym = find_symbol_by_offset(sec, 0);
+	if (sym && sym->len == sec_size(sec))
+		goto found_sym;
+
+	/* No dedicated section; find the symbol manually */
+	sym = find_symbol_containing(sec, arch_adjusted_addend(reloc));
+	if (!sym) {
+		/*
+		 * This can happen for special section references to weak code
+		 * whose symbol has been stripped by the linker.
+		 */
+		return -1;
+	}
+
+found_sym:
+	reloc->sym = sym;
+	set_reloc_sym(elf, reloc, sym->idx);
+	set_reloc_addend(elf, reloc, reloc_addend(reloc) - sym->offset);
+	return 0;
+}
+
+/*
+ * Convert a relocation symbol reference to the needed format: either a section
+ * symbol or the underlying symbol itself.
+ */
+static int convert_reloc_sym(struct elf *elf, struct reloc *reloc)
+{
+	if (is_reloc_allowed(reloc))
+		return 0;
+
+	if (section_reference_needed(reloc->sym->sec))
+		return convert_reloc_sym_to_secsym(elf, reloc);
+	else
+		return convert_reloc_secsym_to_sym(elf, reloc);
+}
+
+/*
+ * Convert a regular relocation to a klp relocation (sort of).
+ */
+static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
+			   struct section *sec, unsigned long offset,
+			   struct export *export)
+{
+	struct symbol *patched_sym = patched_reloc->sym;
+	s64 addend = reloc_addend(patched_reloc);
+	const char *sym_modname, *sym_orig_name;
+	static struct section *klp_relocs;
+	struct symbol *sym, *klp_sym;
+	unsigned long klp_reloc_off;
+	char sym_name[SYM_NAME_LEN];
+	struct klp_reloc klp_reloc;
+	unsigned long sympos;
+
+	if (!patched_sym->twin) {
+		ERROR("unexpected klp reloc for new symbol %s", patched_sym->name);
+		return -1;
+	}
+
+	/*
+	 * Keep the original reloc intact for now to avoid breaking objtool run
+	 * which relies on proper relocations for many of its features.  This
+	 * will be disabled later by "objtool klp post-link".
+	 *
+	 * Convert it to UNDEF (and WEAK to avoid modpost warnings).
+	 */
+
+	sym = patched_sym->clone;
+	if (!sym) {
+		/* STB_WEAK: avoid modpost undefined symbol warnings */
+		sym = elf_create_symbol(e->out, patched_sym->name, NULL,
+					STB_WEAK, patched_sym->type, 0, 0);
+		if (!sym)
+			return -1;
+
+		patched_sym->clone = sym;
+		sym->clone = patched_sym;
+	}
+
+	if (!elf_create_reloc(e->out, sec, offset, sym, addend, reloc_type(patched_reloc)))
+		return -1;
+
+	/*
+	 * Create the KLP symbol.
+	 */
+
+	if (export) {
+		sym_modname = export->mod;
+		sym_orig_name = export->sym;
+		sympos = 0;
+	} else {
+		sym_modname = find_modname(e);
+		if (!sym_modname)
+			return -1;
+
+		sym_orig_name = patched_sym->twin->name;
+		sympos = find_sympos(e->orig, patched_sym->twin);
+		if (sympos == ULONG_MAX)
+			return -1;
+	}
+
+	/* symbol format: .klp.sym.modname.sym_name,sympos */
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_SYM_PREFIX "%s.%s,%ld",
+		      sym_modname, sym_orig_name, sympos))
+		return -1;
+
+	klp_sym = find_symbol_by_name(e->out, sym_name);
+	if (!klp_sym) {
+		/* STB_WEAK: avoid modpost undefined symbol warnings */
+		klp_sym = elf_create_symbol(e->out, sym_name, NULL,
+					    STB_WEAK, patched_sym->type, 0, 0);
+		if (!klp_sym)
+			return -1;
+	}
+
+	/*
+	 * Create the __klp_relocs entry.  This will be converted to an actual
+	 * KLP rela by "objtool klp post-link".
+	 *
+	 * This intermediate step is necessary to prevent corruption by the
+	 * linker, which doesn't know how to properly handle two rela sections
+	 * applying to the same base section.
+	 */
+
+	if (!klp_relocs) {
+		klp_relocs = elf_create_section(e->out, KLP_RELOCS_SEC, 0,
+						0, SHT_PROGBITS, 8, SHF_ALLOC);
+		if (!klp_relocs)
+			return -1;
+	}
+
+	klp_reloc_off = sec_size(klp_relocs);
+	memset(&klp_reloc, 0, sizeof(klp_reloc));
+
+	klp_reloc.type = reloc_type(patched_reloc);
+	if (!elf_add_data(e->out, klp_relocs, &klp_reloc, sizeof(klp_reloc)))
+		return -1;
+
+	/* klp_reloc.offset */
+	if (!sec->sym && !elf_create_section_symbol(e->out, sec))
+		return -1;
+
+	if (!elf_create_reloc(e->out, klp_relocs,
+			      klp_reloc_off + offsetof(struct klp_reloc, offset),
+			      sec->sym, offset, R_ABS64))
+		return -1;
+
+	/* klp_reloc.sym */
+	if (!elf_create_reloc(e->out, klp_relocs,
+			      klp_reloc_off + offsetof(struct klp_reloc, sym),
+			      klp_sym, addend, R_ABS64))
+		return -1;
+
+	return 0;
+}
+
+/* Copy a reloc and its symbol to the output object */
+static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
+			struct section *sec, unsigned long offset)
+{
+	struct symbol *patched_sym = patched_reloc->sym;
+	struct export *export = find_export(patched_sym);
+	long addend = reloc_addend(patched_reloc);
+	struct symbol *out_sym;
+	bool klp;
+
+	if (!is_reloc_allowed(patched_reloc)) {
+		ERROR_FUNC(patched_reloc->sec->base, reloc_offset(patched_reloc),
+			   "missing symbol for reference to %s+%ld",
+			   patched_sym->name, addend);
+		return -1;
+	}
+
+	klp = klp_reloc_needed(patched_reloc);
+
+	if (klp) {
+		if (clone_reloc_klp(e, patched_reloc, sec, offset, export))
+			return -1;
+
+		return 0;
+	}
+
+	/*
+	 * Why !export sets 'data_too':
+	 *
+	 * Unexported non-klp symbols need to live in the patch module,
+	 * otherwise there will be unresolved symbols.  Notably, this includes:
+	 *
+	 *   - New functions/data
+	 *   - String sections
+	 *   - Special section entries
+	 *   - Uncorrelated static local variables
+	 *   - UBSAN sections
+	 */
+	out_sym = clone_symbol(e, patched_sym, patched_sym->included || !export);
+	if (!out_sym)
+		return -1;
+
+	/*
+	 * For strings, all references use section symbols, thanks to
+	 * section_reference_needed().  clone_symbol() has cloned an empty
+	 * version of the string section.  Now copy the string itself.
+	 */
+	if (is_string_sec(patched_sym->sec)) {
+		const char *str = patched_sym->sec->data->d_buf + addend;
+
+		addend = elf_add_string(e->out, out_sym->sec, str);
+		if (addend == -1)
+			return -1;
+	}
+
+	if (!elf_create_reloc(e->out, sec, offset, out_sym, addend,
+			      reloc_type(patched_reloc)))
+		return -1;
+
+	return 0;
+}
+
+/* Copy all relocs needed for a symbol's contents */
+static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
+{
+	struct section *patched_rsec = patched_sym->sec->rsec;
+	struct reloc *patched_reloc;
+	unsigned long start, end;
+	struct symbol *out_sym;
+
+	out_sym = patched_sym->clone;
+	if (!out_sym) {
+		ERROR("no clone for %s", patched_sym->name);
+		return -1;
+	}
+
+	if (!patched_rsec)
+		return 0;
+
+	if (!is_sec_sym(patched_sym) && !patched_sym->len)
+		return 0;
+
+	if (is_string_sec(patched_sym->sec))
+		return 0;
+
+	if (is_sec_sym(patched_sym)) {
+		start = 0;
+		end = sec_size(patched_sym->sec);
+	} else {
+		start = patched_sym->offset;
+		end = start + patched_sym->len;
+	}
+
+	for_each_reloc(patched_rsec, patched_reloc) {
+		unsigned long offset;
+
+		if (reloc_offset(patched_reloc) < start ||
+		    reloc_offset(patched_reloc) >= end)
+			continue;
+
+		/*
+		 * Skip any reloc referencing .altinstr_aux.  Its code is
+		 * always patched by alternatives.  See ALTERNATIVE_TERNARY().
+		 */
+		if (patched_reloc->sym->sec &&
+		    !strcmp(patched_reloc->sym->sec->name, ".altinstr_aux"))
+			continue;
+
+		if (convert_reloc_sym(e->patched, patched_reloc)) {
+			ERROR_FUNC(patched_rsec->base, reloc_offset(patched_reloc),
+				   "failed to convert reloc sym '%s' to its proper format",
+				   patched_reloc->sym->name);
+			return -1;
+		}
+
+		offset = out_sym->offset + (reloc_offset(patched_reloc) - patched_sym->offset);
+
+		if (clone_reloc(e, patched_reloc, out_sym->sec, offset))
+			return -1;
+	}
+	return 0;
+
+}
+
+/* Keep a special section entry if it references an included function */
+static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
+{
+	struct reloc *reloc;
+
+	if (is_sec_sym(sym) || !sym->sec->rsec)
+		return false;
+
+	sym_for_each_reloc(elf, sym, reloc) {
+		if (convert_reloc_sym(elf, reloc))
+			continue;
+
+		if (is_func_sym(reloc->sym) && reloc->sym->included)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Klp relocations aren't allowed for __jump_table and .static_call_sites if
+ * the referenced symbol lives in a kernel module, because such klp relocs may
+ * be applied after static branch/call init, resulting in code corruption.
+ *
+ * Validate a special section entry to avoid that.  Note that an inert
+ * tracepoint is harmless enough, in that case just skip the entry and print a
+ * warning.  Otherwise, return an error.
+ *
+ * This is only a temporary limitation which will be fixed when livepatch adds
+ * support for submodules: fully self-contained modules which are embedded in
+ * the top-level livepatch module's data and which can be loaded on demand when
+ * their corresponding to-be-patched module gets loaded.  Then klp relocs can
+ * be retired.
+ *
+ * Return:
+ *   -1: error: validation failed
+ *    1: warning: tracepoint skipped
+ *    0: success
+ */
+static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym)
+{
+	bool static_branch = !strcmp(sym->sec->name, "__jump_table");
+	bool static_call   = !strcmp(sym->sec->name, ".static_call_sites");
+	struct symbol *code_sym = NULL;
+	unsigned long code_offset = 0;
+	struct reloc *reloc;
+	int ret = 0;
+
+	if (!static_branch && !static_call)
+		return 0;
+
+	sym_for_each_reloc(e->patched, sym, reloc) {
+		const char *sym_modname;
+		struct export *export;
+
+		/* Static branch/call keys are always STT_OBJECT */
+		if (reloc->sym->type != STT_OBJECT) {
+
+			/* Save code location which can be printed below */
+			if (reloc->sym->type == STT_FUNC && !code_sym) {
+				code_sym = reloc->sym;
+				code_offset = reloc_addend(reloc);
+			}
+
+			continue;
+		}
+
+		if (!klp_reloc_needed(reloc))
+			continue;
+
+		export = find_export(reloc->sym);
+		if (export) {
+			sym_modname = export->mod;
+		} else {
+			sym_modname = find_modname(e);
+			if (!sym_modname)
+				return -1;
+		}
+
+		/* vmlinux keys are ok */
+		if (!strcmp(sym_modname, "vmlinux"))
+			continue;
+
+		if (static_branch) {
+			if (strstarts(reloc->sym->name, "__tracepoint_")) {
+				WARN("%s: disabling unsupported tracepoint %s",
+				     code_sym->name, reloc->sym->name + 13);
+				ret = 1;
+				continue;
+			}
+
+			ERROR("%s+0x%lx: unsupported static branch key %s.  Use static_key_enabled() instead",
+			      code_sym->name, code_offset, reloc->sym->name);
+			return -1;
+		}
+
+		/* static call */
+		if (strstarts(reloc->sym->name, "__SCK__tp_func_")) {
+			ret = 1;
+			continue;
+		}
+
+		ERROR("%s()+0x%lx: unsupported static call key %s.  Use KLP_STATIC_CALL() instead",
+		      code_sym->name, code_offset, reloc->sym->name);
+		return -1;
+	}
+
+	return ret;
+}
+
+static int special_section_entry_size(struct section *sec)
+{
+	unsigned int reloc_size;
+
+	if ((sec->sh.sh_flags & SHF_MERGE) && sec->sh.sh_entsize)
+		return sec->sh.sh_entsize;
+
+	if (!sec->rsec)
+		return 0;
+
+	/* Check for a simple array of pointers */
+	reloc_size = arch_reloc_size(sec->rsec->relocs);
+	if (sec_size(sec) == reloc_size * sec_num_entries(sec->rsec))
+		return reloc_size;
+
+	return 0;
+}
+
+static int create_fake_symbol(struct elf *elf, struct section *sec,
+			      unsigned long offset, size_t size)
+{
+	char name[SYM_NAME_LEN];
+	unsigned int type;
+	static int ctr;
+	char *c;
+
+	if (snprintf_check(name, SYM_NAME_LEN, "__DISCARD_%s_%d", sec->name, ctr++))
+		return -1;
+
+	for (c = name; *c; c++)
+		if (*c == '.')
+			*c = '_';
+
+	/*
+	 * STT_NOTYPE: Prevent objtool from validating .altinstr_replacement
+	 *	       while still allowing objdump to disassemble it.
+	 */
+	type = is_text_sec(sec) ? STT_NOTYPE : STT_OBJECT;
+	if (!elf_create_symbol(elf, name, sec, STB_LOCAL, type, offset, size))
+		return -1;
+
+	return 0;
+}
+
+static int clone_special_section(struct elfs *e, struct section *patched_sec)
+{
+	struct symbol *patched_sym;
+	unsigned int entry_size;
+	unsigned long offset;
+
+	entry_size = special_section_entry_size(patched_sec);
+	if (!entry_size) {
+		/*
+		 * Any special section more complex than a simple array of
+		 * pointers must have its entry size specified in sh_entsize
+		 * (and the SHF_MERGE flag set so the linker preserves it).
+		 *
+		 * Clang older than version 20 doesn't properly preserve
+		 * sh_entsize and will error out here.
+		 */
+		ERROR("%s: buggy linker and/or missing sh_entsize", patched_sec->name);
+		return -1;
+	}
+
+	/*
+	 * In the patched object, create a fake symbol for each special section
+	 * entry.  This makes the below extracting of entries much easier.
+	 */
+	for (offset = 0; offset < sec_size(patched_sec); offset += entry_size) {
+		if (create_fake_symbol(e->patched, patched_sec, offset, entry_size))
+			return -1;
+
+		/* Symbolize alternative replacements: */
+		if (!strcmp(patched_sec->name, ".altinstructions")) {
+			struct reloc *reloc;
+			unsigned char size;
+
+			reloc = find_reloc_by_dest(e->patched, patched_sec, offset + ALT_NEW_OFFSET);
+			if (!reloc) {
+				ERROR_FUNC(patched_sec, offset + ALT_NEW_OFFSET, "can't find new reloc");
+				return -1;
+			}
+
+			size = *(unsigned char *)(patched_sec->data->d_buf + offset + ALT_NEW_LEN_OFFSET);
+
+			if (create_fake_symbol(e->patched, reloc->sym->sec,
+					       reloc->sym->offset + reloc_addend(reloc), size))
+				return -1;
+		}
+	}
+
+	/*
+	 * Extract all special section entries (and their dependencies) which
+	 * reference included functions.
+	 */
+	sec_for_each_sym(patched_sec, patched_sym) {
+		int ret;
+
+		if (!is_object_sym(patched_sym))
+			continue;
+
+		if (!should_keep_special_sym(e->patched, patched_sym))
+			continue;
+
+		ret = validate_special_section_klp_reloc(e, patched_sym);
+		if (ret < 0)
+			return -1;
+		if (ret > 0)
+			continue;
+
+		if (!clone_symbol(e, patched_sym, true))
+			return -1;
+	}
+
+	return 0;
+}
+
+/* Extract only the needed bits from special sections */
+static int clone_special_sections(struct elfs *e)
+{
+	struct section *patched_sec;
+
+	for_each_sec(e->patched, patched_sec) {
+		if (is_special_section(patched_sec)) {
+			if (clone_special_section(e, patched_sec))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Create __klp_objects and __klp_funcs sections which are intermediate
+ * sections provided as input to the patch module's init code for building the
+ * klp_patch, klp_object and klp_func structs for the livepatch API.
+ */
+static int create_klp_sections(struct elfs *e)
+{
+	size_t obj_size  = sizeof(struct klp_object_ext);
+	size_t func_size = sizeof(struct klp_func_ext);
+	struct section *obj_sec, *funcs_sec, *str_sec;
+	struct symbol *funcs_sym, *str_sym, *sym;
+	char sym_name[SYM_NAME_LEN];
+	unsigned int nr_funcs = 0;
+	const char *modname;
+	void *obj_data;
+	s64 addend;
+
+	obj_sec  = elf_create_section_pair(e->out, KLP_OBJECTS_SEC, obj_size, 0, 0);
+	if (!obj_sec)
+		return -1;
+
+	funcs_sec = elf_create_section_pair(e->out, KLP_FUNCS_SEC, func_size, 0, 0);
+	if (!funcs_sec)
+		return -1;
+
+	funcs_sym = elf_create_section_symbol(e->out, funcs_sec);
+	if (!funcs_sym)
+		return -1;
+
+	str_sec = elf_create_section(e->out, KLP_STRINGS_SEC, 0, 0,
+				     SHT_PROGBITS, 1,
+				     SHF_ALLOC | SHF_STRINGS | SHF_MERGE);
+	if (!str_sec)
+		return -1;
+
+	if (elf_add_string(e->out, str_sec, "") == -1)
+		return -1;
+
+	str_sym = elf_create_section_symbol(e->out, str_sec);
+	if (!str_sym)
+		return -1;
+
+	/* allocate klp_object_ext */
+	obj_data = elf_add_data(e->out, obj_sec, NULL, obj_size);
+	if (!obj_data)
+		return -1;
+
+	modname = find_modname(e);
+	if (!modname)
+		return -1;
+
+	/* klp_object_ext.name */
+	if (strcmp(modname, "vmlinux")) {
+		addend = elf_add_string(e->out, str_sec, modname);
+		if (addend == -1)
+			return -1;
+
+		if (!elf_create_reloc(e->out, obj_sec,
+				      offsetof(struct klp_object_ext, name),
+				      str_sym, addend, R_ABS64))
+			return -1;
+	}
+
+	/* klp_object_ext.funcs */
+	if (!elf_create_reloc(e->out, obj_sec, offsetof(struct klp_object_ext, funcs),
+			      funcs_sym, 0, R_ABS64))
+		return -1;
+
+	for_each_sym(e->out, sym) {
+		unsigned long offset = nr_funcs * func_size;
+		unsigned long sympos;
+		void *func_data;
+
+		if (!is_func_sym(sym) || sym->cold || !sym->clone || !sym->clone->changed)
+			continue;
+
+		/* allocate klp_func_ext */
+		func_data = elf_add_data(e->out, funcs_sec, NULL, func_size);
+		if (!func_data)
+			return -1;
+
+		/* klp_func_ext.old_name */
+		addend = elf_add_string(e->out, str_sec, sym->clone->twin->name);
+		if (addend == -1)
+			return -1;
+
+		if (!elf_create_reloc(e->out, funcs_sec,
+				      offset + offsetof(struct klp_func_ext, old_name),
+				      str_sym, addend, R_ABS64))
+			return -1;
+
+		/* klp_func_ext.new_func */
+		if (!elf_create_reloc(e->out, funcs_sec,
+				      offset + offsetof(struct klp_func_ext, new_func),
+				      sym, 0, R_ABS64))
+			return -1;
+
+		/* klp_func_ext.sympos */
+		BUILD_BUG_ON(sizeof(sympos) != sizeof_field(struct klp_func_ext, sympos));
+		sympos = find_sympos(e->orig, sym->clone->twin);
+		if (sympos == ULONG_MAX)
+			return -1;
+		memcpy(func_data + offsetof(struct klp_func_ext, sympos), &sympos,
+		       sizeof_field(struct klp_func_ext, sympos));
+
+		nr_funcs++;
+	}
+
+	/* klp_object_ext.nr_funcs */
+	BUILD_BUG_ON(sizeof(nr_funcs) != sizeof_field(struct klp_object_ext, nr_funcs));
+	memcpy(obj_data + offsetof(struct klp_object_ext, nr_funcs), &nr_funcs,
+	       sizeof_field(struct klp_object_ext, nr_funcs));
+
+	/*
+	 * Find callback pointers created by KLP_PRE_PATCH_CALLBACK() and
+	 * friends, and add them to the klp object.
+	 */
+
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_PRE_PATCH_PREFIX "%s", modname))
+		return -1;
+
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		if (!elf_create_reloc(e->out, obj_sec,
+				      offsetof(struct klp_object_ext, callbacks) +
+				      offsetof(struct klp_callbacks, pre_patch),
+				      reloc->sym, reloc_addend(reloc), R_ABS64))
+			return -1;
+	}
+
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_POST_PATCH_PREFIX "%s", modname))
+		return -1;
+
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		if (!elf_create_reloc(e->out, obj_sec,
+				      offsetof(struct klp_object_ext, callbacks) +
+				      offsetof(struct klp_callbacks, post_patch),
+				      reloc->sym, reloc_addend(reloc), R_ABS64))
+			return -1;
+	}
+
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_PRE_UNPATCH_PREFIX "%s", modname))
+		return -1;
+
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		if (!elf_create_reloc(e->out, obj_sec,
+				      offsetof(struct klp_object_ext, callbacks) +
+				      offsetof(struct klp_callbacks, pre_unpatch),
+				      reloc->sym, reloc_addend(reloc), R_ABS64))
+			return -1;
+	}
+
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_POST_UNPATCH_PREFIX "%s", modname))
+		return -1;
+
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		if (!elf_create_reloc(e->out, obj_sec,
+				      offsetof(struct klp_object_ext, callbacks) +
+				      offsetof(struct klp_callbacks, post_unpatch),
+				      reloc->sym, reloc_addend(reloc), R_ABS64))
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Copy all .modinfo import_ns= tags to ensure all namespaced exported symbols
+ * can be accessed via normal relocs.
+ */
+static int copy_import_ns(struct elfs *e)
+{
+	struct section *patched_sec, *out_sec = NULL;
+	char *import_ns, *data_end;
+
+	patched_sec = find_section_by_name(e->patched, ".modinfo");
+	if (!patched_sec)
+		return 0;
+
+	import_ns = patched_sec->data->d_buf;
+	if (!import_ns)
+		return 0;
+
+	for (data_end = import_ns + sec_size(patched_sec);
+	     import_ns < data_end;
+	     import_ns += strlen(import_ns) + 1) {
+
+		import_ns = memmem(import_ns, data_end - import_ns, "import_ns=", 10);
+		if (!import_ns)
+			return 0;
+
+		if (!out_sec) {
+			out_sec = find_section_by_name(e->out, ".modinfo");
+			if (!out_sec) {
+				out_sec = elf_create_section(e->out, ".modinfo", 0,
+							     patched_sec->sh.sh_entsize,
+							     patched_sec->sh.sh_type,
+							     patched_sec->sh.sh_addralign,
+							     patched_sec->sh.sh_flags);
+				if (!out_sec)
+					return -1;
+			}
+		}
+
+		if (!elf_add_data(e->out, out_sec, import_ns, strlen(import_ns) + 1))
+			return -1;
+	}
+
+	return 0;
+}
+
+int cmd_klp_diff(int argc, const char **argv)
+{
+	struct elfs e = {0};
+
+	argc = parse_options(argc, argv, klp_diff_options, klp_diff_usage, 0);
+	if (argc != 3)
+		usage_with_options(klp_diff_usage, klp_diff_options);
+
+	objname = argv[0];
+
+	e.orig = elf_open_read(argv[0], O_RDONLY);
+	e.patched = elf_open_read(argv[1], O_RDONLY);
+	e.out = NULL;
+
+	if (!e.orig || !e.patched)
+		return -1;
+
+	if (read_exports())
+		return -1;
+
+	if (read_sym_checksums(e.orig))
+		return -1;
+
+	if (read_sym_checksums(e.patched))
+		return -1;
+
+	if (correlate_symbols(&e))
+		return -1;
+
+	if (mark_changed_functions(&e))
+		return 0;
+
+	e.out = elf_create_file(&e.orig->ehdr, argv[2]);
+	if (!e.out)
+		return -1;
+
+	if (clone_included_functions(&e))
+		return -1;
+
+	if (clone_special_sections(&e))
+		return -1;
+
+	if (create_klp_sections(&e))
+		return -1;
+
+	if (copy_import_ns(&e))
+		return -1;
+
+	if  (elf_write(e.out))
+		return -1;
+
+	return elf_close(e.out);
+}
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index 5c8b974ad0f9..c8f611c1320d 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -16,8 +16,6 @@
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
 
-bool help;
-
 static struct objtool_file file;
 
 struct objtool_file *objtool_open_read(const char *filename)
@@ -71,6 +69,39 @@ int objtool_pv_add(struct objtool_file *f, int idx, struct symbol *func)
 	return 0;
 }
 
+char *top_level_dir(const char *file)
+{
+	ssize_t len, self_len, file_len;
+	char self[PATH_MAX], *str;
+	int i;
+
+	len = readlink("/proc/self/exe", self, sizeof(self) - 1);
+	if (len <= 0)
+		return NULL;
+	self[len] = '\0';
+
+	for (i = 0; i < 3; i++) {
+		char *s = strrchr(self, '/');
+		if (!s)
+			return NULL;
+		*s = '\0';
+	}
+
+	self_len = strlen(self);
+	file_len = strlen(file);
+
+	str = malloc(self_len + file_len + 2);
+	if (!str)
+		return NULL;
+
+	memcpy(str, self, self_len);
+	str[self_len] = '/';
+	strcpy(str + self_len + 1, file);
+
+	return str;
+}
+
+
 int main(int argc, const char **argv)
 {
 	static const char *UNUSED = "OBJTOOL_NOT_IMPLEMENTED";
@@ -79,5 +110,11 @@ int main(int argc, const char **argv)
 	exec_cmd_init("objtool", UNUSED, UNUSED, UNUSED);
 	pager_init(UNUSED);
 
+	if (argc > 1 && !strcmp(argv[1], "klp")) {
+		argc--;
+		argv++;
+		return cmd_klp(argc, argv);
+	}
+
 	return objtool_run(argc, argv);
 }
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 81d120d05442..e1d98fb03157 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -16,6 +16,7 @@ arch/x86/include/asm/orc_types.h
 arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
+include/linux/livepatch_external.h
 include/linux/static_call_types.h
 "
 
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index d83f607733b0..d6562f292259 100644
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -8,6 +8,8 @@
 #include <stdbool.h>
 #include <errno.h>
 #include <objtool/objtool.h>
+#include <objtool/arch.h>
+#include <objtool/builtin.h>
 
 #define UNSUPPORTED(name)						\
 ({									\
@@ -24,3 +26,8 @@ int __weak orc_create(struct objtool_file *file)
 {
 	UNSUPPORTED("ORC");
 }
+
+int __weak cmd_klp(int argc, const char **argv)
+{
+	UNSUPPORTED("klp");
+}
-- 
2.49.0


