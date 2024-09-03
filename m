Return-Path: <live-patching+bounces-565-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 297109692A9
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05A011F22C1E
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1105205E0B;
	Tue,  3 Sep 2024 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfyylwoJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A205B201278;
	Tue,  3 Sep 2024 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336045; cv=none; b=HN8aIN0caeyaejtFHKOMU6jdwd69nJztrj7VPo6tG7gARwD5lga4hM1I1AOAVrV/OnW4ADCr5SG/C8O3Ndxv5Bxo1FUORZGQOrxI7HV65H6Ynk2U8U8PCO7XejXOjsHv3Nw1b1zgUVJDAqg50eX8My6Sxi86WDqtbtbDpjw6BW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336045; c=relaxed/simple;
	bh=2387ZLqzG+E9PtfZZ8vkWz/hfacL1d+dPSLFhvagAjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGFYoQmqkk6zgxyHflLzv2OMVaDcn/ANnEjl9060FA1eB75MEZuTpFMSIP8ren5MbHBGBj2VSb3FZklTv0q+qr5bHq6cjtSWQGFDBJqnfucx2o8sL0OAqt+rTIFxLztwNQNjVnJ1eQ4c5tpPgXUzEREQqYTng13XF7anSq60wsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfyylwoJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C717BC4CEC8;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336045;
	bh=2387ZLqzG+E9PtfZZ8vkWz/hfacL1d+dPSLFhvagAjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfyylwoJ8hbNBjArbRLMwtDAdGKVpnyeiZtCp7fSguMhYIpb7xqLClVa3MOdrgUIY
	 hMU07h7bGzAYKkmv9/OTkWAa300Yh3b4WdcSr1uaFwkGACQjjR/JBN8STIITc0BqOz
	 vLEJJ1kbo9CHRjKq7DNrnPJek7pS0YjSVpvocZ391AaRZuiCqYn/OrbY+5KtRsQ9EP
	 BwEE7gvnIbjpd1Yn4HRLwj7ZYpsSLSK+Rqc2neId67H+8aGF60O3uxmEYssmK7E8pB
	 yK9iM94zajKWKK0A02VESJOBegkuZNJ4KTWlABDcHGtafovmDN4k0e5j6cHvjRKPzl
	 GjEEv7GshCiWg==
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
Subject: [RFC 31/31] objtool, livepatch: Livepatch module generation
Date: Mon,  2 Sep 2024 21:00:14 -0700
Message-ID: <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
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

Add a klp-build script which makes use of a new "objtool klp" subcommand
to generate livepatch modules using a source patch as input.

The concept is similar to kpatch-build which has been a successful
out-of-tree project for over a decade.  It takes a source .patch as an
input, builds kernels before and after, does a binary diff, and copies
any changed functions into a new object file which is then linked into a
livepatch module.

By making use of existing objtool functionalities, and taking from
lessons learned over the last decade of maintaining kpatch-build, the
overall design is much simpler.  In fact, it's a complete redesign and
has been written from scratch (no copied code).

Advantages over kpatch-build:

  - Runs on vmlinux.o, so it's compatible with late-linked features like
    IBT and LTO

  - Much simpler design: ~3k fewer LOC

  - Makes use of existing objtool CFG functionality to create checksums
    to trivially detect changed functions

  - Offset __LINE__ changes are no longer a problem thanks to the
    adjust-patch-lines script

  - In-tree means less cruft, easier maintenance, and a larger pool of
    potential maintainers

To use, run the following from the kernel source root:

  scripts/livepatch/klp-build /path/to/my.patch

If it succeeds, the patch module (livepatch.ko) will be created in the
current directory.

TODO:

  - specify module name on cmdline
  - handle edge cases like correlation of static locals
  - support other arches (currently x86-64 only)
  - support clang
  - performance optimization
  - automated testing

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 .gitignore                              |    3 +
 include/linux/livepatch.h               |   25 +-
 include/linux/livepatch_ext.h           |   83 ++
 include/linux/livepatch_patch.h         |   73 ++
 kernel/livepatch/core.c                 |    4 +-
 scripts/livepatch/adjust-patch-lines    |  181 ++++
 scripts/livepatch/klp-build             |  355 ++++++++
 scripts/livepatch/module.c              |  120 +++
 scripts/module.lds.S                    |    9 +-
 tools/include/linux/livepatch_ext.h     |   83 ++
 tools/objtool/Build                     |    4 +-
 tools/objtool/Makefile                  |   33 +-
 tools/objtool/arch/x86/decode.c         |   40 +
 tools/objtool/check.c                   |   29 +-
 tools/objtool/elf.c                     |   18 +-
 tools/objtool/include/objtool/arch.h    |    1 +
 tools/objtool/include/objtool/builtin.h |    1 +
 tools/objtool/include/objtool/elf.h     |   20 +-
 tools/objtool/include/objtool/klp.h     |   25 +
 tools/objtool/include/objtool/objtool.h |    2 +-
 tools/objtool/klp-diff.c                | 1112 +++++++++++++++++++++++
 tools/objtool/klp-link.c                |  122 +++
 tools/objtool/klp.c                     |   57 ++
 tools/objtool/objtool.c                 |    6 +
 tools/objtool/sync-check.sh             |    1 +
 tools/objtool/weak.c                    |    7 +
 26 files changed, 2361 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/livepatch_ext.h
 create mode 100644 include/linux/livepatch_patch.h
 create mode 100755 scripts/livepatch/adjust-patch-lines
 create mode 100755 scripts/livepatch/klp-build
 create mode 100644 scripts/livepatch/module.c
 create mode 100644 tools/include/linux/livepatch_ext.h
 create mode 100644 tools/objtool/include/objtool/klp.h
 create mode 100644 tools/objtool/klp-diff.c
 create mode 100644 tools/objtool/klp-link.c
 create mode 100644 tools/objtool/klp.c

diff --git a/.gitignore b/.gitignore
index c59dc60ba62e..28bb70c9e808 100644
--- a/.gitignore
+++ b/.gitignore
@@ -171,3 +171,6 @@ sphinx_*/
 
 # Rust analyzer configuration
 /rust-project.json
+
+# Livepatch module build directory
+/klp-tmp
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..d54e4dfe320e 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -13,6 +13,7 @@
 #include <linux/ftrace.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/livepatch_ext.h>
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
diff --git a/include/linux/livepatch_ext.h b/include/linux/livepatch_ext.h
new file mode 100644
index 000000000000..4b71e72952d5
--- /dev/null
+++ b/include/linux/livepatch_ext.h
@@ -0,0 +1,83 @@
+/* SPDX License-Identifier: GPL-2.0-or-later */
+/*
+ * External livepatch interfaces for patch creation tooling
+ *
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+
+#ifndef _LINUX_LIVEPATCH_EXT_H_
+#define _LINUX_LIVEPATCH_EXT_H_
+
+#include <linux/types.h>
+
+#define KLP_RELOC_SEC_PREFIX	".klp.rela."
+#define KLP_SYM_PREFIX		".klp.sym."
+
+#define KLP_CALLBACKS_SEC		".discard.klp_callbacks"
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
+ *
+ * TODO possibly use struct_group_tagged() to declare these within the original
+ * structs.
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
+#endif /* _LINUX_LIVEPATCH_EXT_H_ */
diff --git a/include/linux/livepatch_patch.h b/include/linux/livepatch_patch.h
new file mode 100644
index 000000000000..6f3b930cdc5a
--- /dev/null
+++ b/include/linux/livepatch_patch.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Helper macros for livepatch source patches
+ *
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+#ifndef _LINUX_LIVEPATCH_PATCH_H_
+#define _LINUX_LIVEPATCH_PATCH_H_
+
+#include <linux/livepatch.h>
+
+#ifdef MODULE
+#define KLP_OBJNAME __KBUILD_MODNAME
+#else
+#define KLP_OBJNAME vmlinux
+#endif
+
+#define KLP_PRE_PATCH_CALLBACK(func)						\
+	klp_pre_patch_t __used __section(KLP_CALLBACKS_SEC)			\
+		__PASTE(__KLP_PRE_PATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_POST_PATCH_CALLBACK(func)						\
+	klp_post_patch_t __used __section(KLP_CALLBACKS_SEC)			\
+		__PASTE(__KLP_POST_PATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_PRE_UNPATCH_CALLBACK(func)						\
+	klp_pre_unpatch_t __used __section(KLP_CALLBACKS_SEC)			\
+		__PASTE(__KLP_PRE_UNPATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_POST_UNPATCH_CALLBACK(func)						\
+	klp_post_unpatch_t __used __section(KLP_CALLBACKS_SEC)			\
+		__PASTE(__KLP_POST_UNPATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_SYSCALL_METADATA(sname)					\
+	static struct syscall_metadata __used				\
+	  __section("__syscalls_metadata")				\
+	  *__p_syscall_meta_##sname = NULL;				\
+									\
+	static struct trace_event_call __used				\
+	  __section("_ftrace_events")					\
+	  *__event_enter_##sname = NULL
+
+#define KLP_SYSCALL_DEFINE1(name, ...) KLP_SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE2(name, ...) KLP_SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE3(name, ...) KLP_SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE4(name, ...) KLP_SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE5(name, ...) KLP_SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE6(name, ...) KLP_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
+
+#define KLP_SYSCALL_DEFINEx(x, sname, ...)				\
+	KLP_SYSCALL_METADATA(sname);					\
+	__KLP_SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+
+#ifdef CONFIG_X86_64
+
+// TODO move this to arch/x86/include/asm/syscall_wrapper.h and share code
+#define __KLP_SYSCALL_DEFINEx(x, name, ...)			\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	__X64_SYS_STUBx(x, name, __VA_ARGS__)				\
+	__IA32_SYS_STUBx(x, name, __VA_ARGS__)				\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
+	{								\
+		long ret = __klp_do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));\
+		__MAP(x,__SC_TEST,__VA_ARGS__);				\
+		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
+		return ret;						\
+	}								\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
+
+#endif
+
+#endif /* _LINUX_LIVEPATCH_PATCH_H_ */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 76ffe29934d4..8ff917973254 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -226,7 +226,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%511[^,],%lu",
+			     KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
@@ -305,7 +305,7 @@ static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	 * See comment in klp_resolve_symbols() for an explanation
 	 * of the selected field width value.
 	 */
-	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELOC_SEC_PREFIX "%55[^.]",
 		     sec_objname);
 	if (cnt != 1) {
 		pr_err("section %s has an incorrectly formatted name\n",
diff --git a/scripts/livepatch/adjust-patch-lines b/scripts/livepatch/adjust-patch-lines
new file mode 100755
index 000000000000..b29592a57ed3
--- /dev/null
+++ b/scripts/livepatch/adjust-patch-lines
@@ -0,0 +1,181 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+#
+# Add #line statements to a patch so it doesn't affect __LINE__ usage
+
+SCRIPT="$(basename "$0")"
+
+set -o errexit
+set -o errtrace
+set -o pipefail
+
+warn() {
+	str="$1"
+	if [ -n "$str" ]; then
+		echo -e "$SCRIPT: error: $*" >&2
+	else
+		echo -e "$SCRIPT: error" >&2
+
+	fi
+}
+
+die() {
+	warn "$@"
+	if [ -n "$TMPFILE" ]; then
+		rm -f "$TMPFILE"
+	fi
+	exit 1
+}
+
+do_trap() {
+	die
+}
+
+trap do_trap ERR
+
+__usage() {
+	echo "Usage: $SCRIPT [options] patch_file [output_file]"
+	echo "Add #line statements to a patch so it doesn't affect __LINE__ usage"
+	echo "for the rest of the file.  This prevents false positive changes in the binary."
+	echo
+	echo "Options:"
+	echo "  -h, --help       Show this help message and exit"
+	echo
+	echo "Arguments:"
+	echo "  patch_file       Source .patch file"
+	echo "  output_file      Optional output file.  If not provided 'patch_file' will be"
+	echo "                   edited in place."
+}
+
+usage() {
+	__usage >&2
+}
+
+args=$(getopt -o "h" -l "help" -- "$@")
+eval set -- "$args"
+
+while true; do
+	case "$1" in
+		-h | --help)
+			usage
+			exit 0
+			;;
+		--)
+			shift
+			break
+			;;
+		*)
+			usage
+			exit 1
+			;;
+	esac
+done
+
+if [ $# != 1 ] && [ $# != 2 ]; then
+	usage
+	die "unexpected # of args $#"
+fi
+
+patch="$1"
+
+if [ ! -e "$patch" ]; then
+	die "missing file: $patch"
+fi
+
+if [ $# = 2 ]; then
+	output="$2"
+else
+	output="$patch"
+fi
+
+TMPFILE="$(mktemp)"
+
+skip_file=false
+in_hunk=false
+needs_update=false
+while IFS= read -r line; do
+	if [[ "$line" =~ ^---\  ]]; then
+		filename="${line#--- */}"
+
+		if [[ ! "$filename" =~ \.[ch]$ ]]; then
+			skip_file=true
+			echo "$line" >> "$TMPFILE"
+			continue
+		fi
+
+		case "$filename" in
+			*vmlinux.lds.h)
+				skip_file=true
+				echo "$line" >> "$TMPFILE"
+				continue
+				;;
+		esac
+
+		skip_file=false
+		in_hunk=false
+		needs_update=false
+		echo "$line" >> "$TMPFILE"
+		continue
+	fi
+
+	if $skip_file; then
+		echo "$line" >> "$TMPFILE"
+		continue
+	fi
+
+	if [[ "$line" =~ ^@@ ]]; then
+
+		in_hunk=true
+		needs_update=false
+
+		cur="${line#*-}"
+		cur="${cur%%,*}"
+		((cur--))
+
+		last="${line#*,}"
+		last="${last%% *}"
+		last=$((cur + last))
+
+		echo "$line" >> "$TMPFILE"
+		continue
+	fi
+
+	if $in_hunk; then
+		if [[ "$line" =~ ^\+ ]]; then
+			needs_update=true
+			echo "$line" >> "$TMPFILE"
+			continue
+		fi
+
+		if [[ "$line" =~ ^- ]]; then
+			((cur++))
+			needs_update=true
+			echo "$line" >> "$TMPFILE"
+			continue
+		fi
+
+		if $needs_update; then
+			((cur++))
+			needs_update=false
+			echo "+#line $cur" >> "$TMPFILE"
+			echo "$line" >> "$TMPFILE"
+			continue
+		fi
+
+		((cur++))
+		echo "$line" >> "$TMPFILE"
+
+		if [ $cur = $last ]; then
+			in_hunk=false
+		fi
+
+		continue
+	fi
+
+	echo "$line" >> "$TMPFILE"
+
+done < "$patch"
+
+mv -f "$TMPFILE" "$output"
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
new file mode 100755
index 000000000000..e16584a4b697
--- /dev/null
+++ b/scripts/livepatch/klp-build
@@ -0,0 +1,355 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+
+set -o errexit
+set -o errtrace
+set -o pipefail
+
+SCRIPT="$(basename "$0")"
+SCRIPTDIR="$(readlink -f "$(dirname "$(type -p "$0")")")"
+
+SRC="$(pwd)"
+BUILD_DIR="$SRC"
+TMP_DIR="$BUILD_DIR/klp-tmp"
+ORIG_DIR="$TMP_DIR/orig"
+PATCHED_DIR="$TMP_DIR/patched"
+OUTPUT_DIR="$TMP_DIR/out"
+TMP_TMP_DIR="$TMP_DIR/tmp"
+
+shopt -o xtrace | grep -q 'on' && XTRACE=1
+
+status() {
+	echo -e "- $SCRIPT: $*"
+}
+
+warn() {
+	str="$1"
+	if [[ -n "$str" ]]; then
+		echo "$SCRIPT: error: $*" >&2
+	else
+		echo "$SCRIPT: error" >&2
+	fi
+}
+
+die() {
+	warn "$@"
+	revert_applied_patches "--recount"
+	[[ -z "$DEBUG" ]] && rm -rf "$TMP_DIR"
+	exit 1
+}
+
+__trap() {
+	die "line $1"
+}
+
+trap '__trap ${LINENO}' ERR INT
+
+__usage() {
+	echo "Usage: $SCRIPT [options] patch_file(s)"
+	echo "Generate a livepatch module"
+	echo
+	echo "Options:"
+	echo "  -h, --help       Show this help message and exit"
+	echo
+	echo "Arguments:"
+	echo "  patch_file(s)    One or more .patch files"
+}
+
+usage() {
+	__usage >&2
+}
+
+apply_patch() {
+	local patch="$1"
+	local extra_args="$2"
+
+	[[ -f "$patch" ]] || die "$patch doesn't exist"
+
+	( cd "$SRC" && git apply --quiet --check $extra_args "$patch" ) || die "$patch failed to apply"
+	( cd "$SRC" && git apply --quiet $extra_args "$patch" )         || die "$patch failed to apply"
+	APPLIED_PATCHES+=("$patch")
+}
+
+revert_patch() {
+	local patch="$1"
+	local extra_args="$2"
+
+	( cd "$SRC" && git apply --reverse --quiet $extra_args "$patch" ) || die "$patch failed to apply"
+	APPLIED_PATCHES=("${APPLIED_PATCHES[@]/$patch}")
+}
+
+revert_applied_patches() {
+	local patches=("${APPLIED_PATCHES[@]}")
+	local extra_args="$1"
+
+	for (( i=${#patches[@]}-1 ; i>=0 ; i-- )) ; do
+		local patch="${patches[$i]}"
+
+		# "deleted" entry can still exist as an empty string
+		[[ "$patch" ]] || continue
+
+		revert_patch "${patches[$i]}" "$extra_args"
+	done
+
+	APPLIED_PATCHES=()
+}
+
+apply_patches() {
+	for patch in "${PATCHES[@]}"; do
+		apply_patch "$patch"
+	done
+}
+
+validate_patches() {
+	apply_patches
+	revert_applied_patches
+}
+
+refresh_patch() {
+	local patch="$1"
+	local tmp="$TMP_TMP_DIR"
+
+	rm -rf "$tmp"
+	mkdir -p "$tmp"
+
+	while read -r file; do
+		local dest
+		dest="$tmp/a/$(dirname "$file")"
+		mkdir -p "$dest"
+		cp -f "$SRC/$file" "$dest"
+	done < <(grep -E '^(--- |\+\+\+ )' "$patch" | sed -E 's/(--- a\/|\+\+\+ b\/)//' | sort | uniq)
+
+	apply_patch "$patch" --recount
+
+	while read -r file; do
+		local dest
+		dest="$tmp/b/$(dirname "$file")"
+		mkdir -p "$dest"
+		cp -f "$SRC/$file" "$dest"
+	done < <(grep -E '^(--- |\+\+\+ )' "$patch" | sed -E 's/(--- a\/|\+\+\+ b\/)//' | sort | uniq)
+
+	revert_patch "$patch" --recount
+
+	(
+		cd "$tmp"
+		git diff --no-index --no-prefix a b > "$patch" || true
+	)
+}
+
+# Copy the patches to a temporary directory, fix their lines so as not to
+# affect the __LINE__ macro for otherwise unchanged functions, and update
+# $PATCHES to point to fixed patches.
+copy_and_fix_patches() {
+
+	idx=0001
+	for patch in "${PATCHES[@]}"; do
+		cp -f "$patch"  "$TMP_DIR/$idx-$(basename "$patch")"
+		idx=$(printf "%04d" $((10#$idx + 1)))
+	done
+
+	PATCHES=()
+	idx=0001
+	while true; do
+		patch="$(ls "$TMP_DIR"/"$idx"-*.patch 2> /dev/null || true)"
+		[[ -z "$patch" ]] && break
+
+		refresh_patch "$patch"
+		"$SCRIPTDIR/adjust-patch-lines" "$patch" || die "adjust-patch-lines failed"
+		refresh_patch "$patch"
+		apply_patch "$patch"
+
+		idx=$(printf "%04d" $((10#$idx + 1)))
+	done
+
+	revert_applied_patches
+
+	idx=0001
+	while true; do
+		patch="$(ls "$TMP_DIR"/"$idx"-*.patch 2> /dev/null || true)"
+		[[ -z "$patch" ]] && break
+
+		PATCHES+=("$patch")
+
+		idx=$(printf "%04d" $((10#$idx + 1)))
+	done
+}
+
+build_kernel() {
+	local options
+
+	if [[ -n "$VERBOSE" ]]; then
+		options="V=1"
+	else
+		options="-s"
+	fi
+
+	( cd "$SRC" && make -j"$(nproc)" "$options" vmlinux modules ) || die "kernel build failed"
+}
+
+copy_orig_objs() {
+	if [[ "$XTRACE" = 1 ]]; then
+		set +x
+	fi
+
+	while read -r _file; do
+		local file="${_file/.ko/.o}"
+		local rel_file="${file#"$BUILD_DIR"/}"
+		local dest_dir="$ORIG_DIR/$(dirname "$rel_file")"
+
+		# ignore any livepatch modules in pwd
+		if [[ "$_file" = *.ko ]] && [[ "$(dirname "$file")" -ef "$BUILD_DIR" ]]; then
+			continue
+		fi
+
+		[[ -f "$file" ]] || die "can't find $file"
+
+		mkdir -p "$dest_dir"
+		cp -f "$file" "$dest_dir" || die "cp -f $file $dest_dir failed"
+	done < <(find "$BUILD_DIR" -type f \( -name vmlinux.o -o -name "*.ko" \))
+
+	if [[ -n "$XTRACE" ]]; then
+		set -x
+	fi
+}
+
+diff_objects() {
+	local timestamp="$1"
+
+	while read -r _file; do
+		local file="${_file/.ko/.o}"
+		local rel_file="${file#"$BUILD_DIR"/}"
+		local orig="$ORIG_DIR/$rel_file"
+		local patched="$PATCHED_DIR/$rel_file"
+		local output="$OUTPUT_DIR/$rel_file"
+
+		[[ -f "$file" ]] || die "can't find $file"
+
+		mkdir -p "$(dirname "$patched")"
+		cp -f "$file" "$patched"
+
+		mkdir -p "$(dirname "$output")"
+
+		# status "diff: $rel_file"
+
+		"$SRC/tools/objtool/objtool" klp diff "$orig" "$patched" "$output" || die "objtool klp diff failed"
+	done < <(find "$BUILD_DIR" -type f \( -name vmlinux.o -o -name "*.ko" \) -newer "$timestamp")
+
+	local nr_objs="$(find "$OUTPUT_DIR" -type f \( -name vmlinux.o -o -name "*.ko" \) | wc -l)"
+
+	if [[ "$nr_objs" = 0 ]]; then
+		die "no changes detected"
+	fi
+}
+
+build_patch_module() {
+	local makefile="$OUTPUT_DIR/Kbuild"
+	local verbose
+	local replace
+
+	cp -f "$SRC/scripts/livepatch/module.c" "$OUTPUT_DIR"
+
+	echo "obj-m := $NAME.o" > "$makefile"
+	echo -n "$NAME-y := module.o" >> "$makefile"
+
+	while read -r file; do
+		cp -f "$file" "$file"_shipped
+		echo -n " ${file#"$OUTPUT_DIR"/}" >> "$makefile"
+	done < <(find "$OUTPUT_DIR" -type f -name "*.o" )
+	echo >> "$makefile"
+
+	if [[ -n "$VERBOSE" ]]; then
+		verbose="V=1"
+	else
+		verbose="-s"
+	fi
+
+	[[ $REPLACE == 1 ]] && replace="KCFLAGS=-DKLP_REPLACE"
+
+	make -C . M="$OUTPUT_DIR" "$verbose" $replace || die "module build failed"
+
+	cp -f "$OUTPUT_DIR/$NAME.ko" "$OUTPUT_DIR/$NAME.ko.prelink"
+
+	"$SRC/tools/objtool/objtool" klp link "$OUTPUT_DIR/$NAME.ko" || die "objtool klp link failed"
+
+	cp -f "$OUTPUT_DIR/$NAME.ko" .
+}
+
+args=$(getopt -o dhn:v -l "debug,help,name:,verbose,noreplace" -- "$@")
+eval set -- "$args"
+
+NAME="livepatch"
+REPLACE=1
+
+while true; do
+	case "$1" in
+		-d | --debug)
+			DEBUG=1
+			;;
+		-h | --help)
+			usage
+			exit 0
+			;;
+		-n | --name)
+			NAME="$2"
+			shift
+			;;
+		--noreplace)
+			REPLACE=0
+			;;
+		-v | --verbose)
+			VERBOSE=1
+			;;
+		--)
+			shift
+			break
+			;;
+		*)
+			usage
+			exit 1
+			;;
+	esac
+	shift
+done
+
+if [[ $# -eq 0 ]]; then
+	usage
+	exit 1
+fi
+
+# not yet smart enough to handle anything other than in-tree builds from pwd
+[[ "$PWD" -ef "$SCRIPTDIR/../.." ]] || die "please run from the kernel root directory"
+
+[[ -x "$SCRIPTDIR/adjust-patch-lines" ]] || die "can't find adjust-patch-lines script"
+
+validate_patches
+
+rm -rf "$TMP_DIR"
+mkdir -p "$TMP_DIR"
+APPLIED_PATCHES=()
+PATCHES=("$@")
+
+# this updates ${PATCHES} to point to the modified versions
+copy_and_fix_patches
+
+status "building original kernel"
+build_kernel
+copy_orig_objs
+
+touch "$TMP_DIR/timestamp"
+
+status "building patched kernel"
+apply_patches
+export KBUILD_MODPOST_WARN=1
+build_kernel
+revert_applied_patches
+
+status "diffing objects"
+diff_objects "$TMP_DIR/timestamp"
+
+status "building patch module"
+build_patch_module
+
+status  "success"
+[[ -z "$DEBUG" ]] && rm -rf "$TMP_DIR"
diff --git a/scripts/livepatch/module.c b/scripts/livepatch/module.c
new file mode 100644
index 000000000000..101cabf6b2f1
--- /dev/null
+++ b/scripts/livepatch/module.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Base module code for a livepatch kernel module
+ *
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/livepatch.h>
+
+// TODO livepatch could recognize these sections directly
+// TODO use function checksums instead of sympos
+
+extern char __start_klp_objects, __stop_klp_objects;
+
+/*
+ * Create weak versions of the linker-created symbols to prevent modpost from
+ * warning about unresolved symbols.
+ */
+__weak char __start_klp_objects = 0;
+__weak char __stop_klp_objects  = 0;
+struct klp_object_ext *__start_objs = (struct klp_object_ext *)&__start_klp_objects;
+struct klp_object_ext *__stop_objs  = (struct klp_object_ext *)&__stop_klp_objects;
+
+static struct klp_patch *patch;
+
+static int __init livepatch_mod_init(void)
+{
+	struct klp_object *objs;
+	unsigned int nr_objs;
+	int ret;
+
+	nr_objs = __stop_objs - __start_objs;
+
+	if (!__start_klp_objects || !nr_objs) {
+		pr_err("nothing to patch!\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
+	if (!patch) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	objs = kzalloc(sizeof(struct klp_object) * (nr_objs + 1),  GFP_KERNEL);
+	if (!objs) {
+		ret = -ENOMEM;
+		goto err_free_patch;
+	}
+
+	for (int i = 0; i < nr_objs; i++) {
+		struct klp_object_ext *obj_ext = __start_objs + i;
+		struct klp_func_ext *funcs_ext = obj_ext->funcs;
+		unsigned int nr_funcs = obj_ext->nr_funcs;
+		struct klp_func *funcs = objs[i].funcs;
+		struct klp_object *obj = objs + i;
+
+		funcs = kzalloc(sizeof(struct klp_func) * (obj_ext->nr_funcs + 1), GFP_KERNEL);
+		if (!funcs) {
+			ret = -ENOMEM;
+			for (int j = 0; j < i; j++)
+				kfree(objs[i].funcs);
+			goto err_free_objs;
+		}
+
+		for (int j = 0; j < nr_funcs; j++) {
+			funcs[j].old_name   = funcs_ext[j].old_name;
+			funcs[j].new_func   = funcs_ext[j].new_func;
+			funcs[j].old_sympos = funcs_ext[j].sympos;
+		}
+
+		obj->name = obj_ext->name;
+		obj->funcs = funcs;
+
+		memcpy(&obj->callbacks, &obj_ext->callbacks, sizeof(struct klp_callbacks));
+	}
+
+	patch->mod = THIS_MODULE;
+	patch->objs = objs;
+
+	/* TODO patch->states */
+
+#ifdef KLP_REPLACE
+	patch->replace = true;
+#else
+	patch->replace = false;
+#endif
+
+	return klp_enable_patch(patch);
+
+err_free_objs:
+	kfree(objs);
+err_free_patch:
+	kfree(patch);
+err:
+	return ret;
+}
+
+static void __exit livepatch_mod_exit(void)
+{
+	unsigned int nr_objs;
+
+	nr_objs = __stop_objs - __start_objs;
+
+	for (int i = 0; i < nr_objs; i++)
+		kfree(patch->objs[i].funcs);
+
+	kfree(patch->objs);
+	kfree(patch);
+}
+
+module_init(livepatch_mod_init);
+module_exit(livepatch_mod_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 5cbae820bca0..aec4b9f0ec95 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -32,8 +32,15 @@ SECTIONS {
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
+	__klp_objects		0: ALIGN(8) {
+		__start_klp_objects = .;
+		KEEP(*(__klp_objects))
+		__stop_klp_objects = .;
+	}
+	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
+
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
-	__kcfi_traps 		: { KEEP(*(.kcfi_traps)) }
+	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
 #endif
 
 #if defined(CONFIG_LTO_CLANG) || defined(CONFIG_LIVEPATCH)
diff --git a/tools/include/linux/livepatch_ext.h b/tools/include/linux/livepatch_ext.h
new file mode 100644
index 000000000000..4b71e72952d5
--- /dev/null
+++ b/tools/include/linux/livepatch_ext.h
@@ -0,0 +1,83 @@
+/* SPDX License-Identifier: GPL-2.0-or-later */
+/*
+ * External livepatch interfaces for patch creation tooling
+ *
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+
+#ifndef _LINUX_LIVEPATCH_EXT_H_
+#define _LINUX_LIVEPATCH_EXT_H_
+
+#include <linux/types.h>
+
+#define KLP_RELOC_SEC_PREFIX	".klp.rela."
+#define KLP_SYM_PREFIX		".klp.sym."
+
+#define KLP_CALLBACKS_SEC		".discard.klp_callbacks"
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
+ *
+ * TODO possibly use struct_group_tagged() to declare these within the original
+ * structs.
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
+#endif /* _LINUX_LIVEPATCH_EXT_H_ */
diff --git a/tools/objtool/Build b/tools/objtool/Build
index a3cdf8af6635..f917e70f0fd0 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -8,8 +8,8 @@ objtool-y += builtin-check.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
-objtool-$(BUILD_ORC) += orc_gen.o
-objtool-$(BUILD_ORC) += orc_dump.o
+objtool-$(BUILD_ORC) += orc_gen.o orc_dump.o
+objtool-$(BUILD_KLP) += klp.o klp-diff.o klp-link.o
 
 objtool-y += libstring.o
 objtool-y += libctype.o
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 6833804ca419..cdae220abca0 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -2,6 +2,25 @@
 include ../scripts/Makefile.include
 include ../scripts/Makefile.arch
 
+BUILD_ORC := n
+BUILD_KLP := n
+
+ifeq ($(SRCARCH),x86)
+BUILD_ORC := y
+BUILD_KLP := y
+endif
+
+ifeq ($(SRCARCH),loongarch)
+BUILD_ORC := y
+endif
+
+export BUILD_ORC BUILD_KLP
+
+ifeq ($(BUILD_KLP),y)
+LIBXXHASH_FLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null)
+LIBXXHASH_LIBS  := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
+endif
+
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
@@ -21,9 +40,6 @@ OBJTOOL_IN := $(OBJTOOL)-in.o
 LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
 LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
-LIBXXHASH_FLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null)
-LIBXXHASH_LIBS  := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)
-
 all: $(OBJTOOL)
 
 INCLUDES := -I$(srctree)/tools/include \
@@ -54,17 +70,6 @@ else
   Q = @
 endif
 
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
 
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 5468fd15f380..bb24e963f371 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -94,6 +94,46 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
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
+	if (type != R_X86_64_PC32 || !is_text_section(reloc->sec->base))
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
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0e9e485cd3b6..f55dec2932de 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -647,6 +647,20 @@ static void create_fake_symbol(struct objtool_file *file, const char *name_pfx,
 	elf_create_symbol(file->elf, name, sec, STB_LOCAL, STT_OBJECT, offset, size);
 }
 
+static bool is_livepatch_module(struct objtool_file *file)
+{
+	struct section *sec;
+
+	if (!opts.module)
+		return false;
+
+	sec = find_section_by_name(file->elf, ".modinfo");
+	if (!sec)
+		return false;
+
+	return memmem(sec->data->d_buf, sec_size(sec), "livepatch=Y", 12);
+}
+
 static void create_static_call_sections(struct objtool_file *file)
 {
 	struct static_call_site *site;
@@ -659,7 +673,14 @@ static void create_static_call_sections(struct objtool_file *file)
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
 		INIT_LIST_HEAD(&file->static_call_list);
-		WARN("file already has .static_call_sites section, skipping");
+
+		/*
+		 * Livepatch modules may have already extracted the static call
+		 * site entries.
+		 */
+		if (!file->klp)
+			WARN("file already has .static_call_sites section, skipping");
+
 		return;
 	}
 
@@ -696,7 +717,7 @@ static void create_static_call_sections(struct objtool_file *file)
 
 		key_sym = find_symbol_by_name(file->elf, tmp);
 		if (!key_sym) {
-			if (!opts.module)
+			if (!opts.module || file->klp)
 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
 
 			/*
@@ -2406,6 +2427,8 @@ static void mark_rodata(struct objtool_file *file)
 
 static void decode_sections(struct objtool_file *file)
 {
+	file->klp = is_livepatch_module(file);
+
 	mark_rodata(file);
 
 	init_pv_ops(file);
@@ -4006,7 +4029,7 @@ static void add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 			continue;
 
 		sym_pfx = elf_create_prefix_symbol(file->elf, func, opts.prefix);
-		if (!sym_pfx)
+		if (!sym_pfx && !file->klp)
 			ERROR("duplicate prefix symbol for %s\n", func->name);
 
 		break;
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 022873bf7064..7960921996bd 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -21,6 +21,7 @@
 #include <linux/interval_tree_generic.h>
 #include <objtool/builtin.h>
 #include <objtool/elf.h>
+#include <objtool/klp.h>
 #include <objtool/warn.h>
 
 #define ALIGN_UP(x, align_to) (((x) + ((align_to)-1)) & ~((align_to)-1))
@@ -456,6 +457,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	else
 		entry = &sym->sec->symbol_list;
 	list_add(&sym->list, entry);
+
+	list_add_tail(&sym->global_list, &elf->symbols);
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
@@ -505,6 +508,8 @@ static void read_symbols(struct elf *elf)
 	elf->symbol_data = calloc(symbols_nr, sizeof(*sym));
 	ERROR_ON(!elf->symbol_data, "calloc");
 
+	INIT_LIST_HEAD(&elf->symbols);
+
 	for (i = 0; i < symbols_nr; i++) {
 		sym = &elf->symbol_data[i];
 
@@ -720,7 +725,7 @@ static void elf_update_symbol(struct elf *elf, struct section *symtab,
 static struct symbol *__elf_create_symbol(struct elf *elf, const char *name,
 					  struct section *sec, unsigned int bind,
 					  unsigned int type, unsigned long offset,
-					  size_t size)
+					  size_t size, bool klp)
 {
 	struct section *symtab, *symtab_shndx;
 	Elf32_Word first_non_local, new_idx;
@@ -735,6 +740,9 @@ static struct symbol *__elf_create_symbol(struct elf *elf, const char *name,
 			sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
 	}
 
+	if (klp)
+		sym->sym.st_shndx = SHN_LIVEPATCH;
+
 	sym->sec = sec ? : find_section_by_index(elf, 0);
 
 	sym->sym.st_info  = GELF_ST_INFO(bind, type);
@@ -799,7 +807,7 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				   unsigned int type, unsigned long offset,
 				   size_t size)
 {
-	return __elf_create_symbol(elf, name, sec, bind, type, offset, size);
+	return __elf_create_symbol(elf, name, sec, bind, type, offset, size, false);
 }
 
 struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
@@ -812,6 +820,12 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
+struct symbol *elf_create_klp_symbol(struct elf *elf, const char *name,
+				     unsigned int bind, unsigned int type)
+{
+	return __elf_create_symbol(elf, name, NULL, bind, type, 0, 0, true);
+}
+
 struct symbol *
 elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
 {
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 14911fdfdc8f..d9f019ef89a7 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -82,6 +82,7 @@ bool arch_callee_saved_reg(unsigned char reg);
 unsigned long arch_jump_destination(struct instruction *insn);
 
 s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc);
+u64 arch_adjusted_addend(struct reloc *reloc);
 
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index eab376169c1e..26bbf04afb24 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -46,5 +46,6 @@ extern struct opts opts;
 extern int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
 extern int objtool_run(int argc, const char **argv);
+extern int cmd_klp(int argc, const char **argv);
 
 #endif /* _BUILTIN_H */
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 1f14f33d279e..43839b3ac80f 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -16,6 +16,7 @@
 #include <xxhash.h>
 #include <arch/elf.h>
 
+#define SEC_NAME_LEN		512
 #define SYM_NAME_LEN		512
 
 #ifdef LIBELF_USE_DEPRECATED
@@ -53,10 +54,12 @@ struct section {
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
 	struct reloc *relocs;
+	struct section *twin;
 };
 
 struct symbol {
 	struct list_head list;
+	struct list_head global_list;
 	struct rb_node node;
 	struct elf_hash_node hash;
 	struct elf_hash_node name_hash;
@@ -77,8 +80,11 @@ struct symbol {
 	u8 warned	     : 1;
 	u8 embedded_insn     : 1;
 	u8 local_label       : 1;
+	u8 changed	     : 1;
+	u8 added	     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
+	struct symbol *twin, *clone;
 
 	XXH3_state_t *checksum_state;
 	XXH64_hash_t checksum;
@@ -99,6 +105,7 @@ struct elf {
 	const char *name, *tmp_name;
 	unsigned int num_files;
 	struct list_head sections;
+	struct list_head symbols;
 	unsigned long num_relocs;
 
 	int symbol_bits;
@@ -138,6 +145,8 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
 struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
 					size_t size);
+struct symbol *elf_create_klp_symbol(struct elf *elf, const char *name,
+				     unsigned int bind, unsigned int type);
 
 struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
 			       unsigned long offset, struct symbol *sym,
@@ -412,11 +421,14 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 #define sec_for_each_sym_continue_reverse(sec, sym)			\
 	list_for_each_entry_continue_reverse(sym, &sec->symbol_list, list)
 
+#define sec_prev_sym(sec, sym)						\
+	sym->list.prev == &sec->symbol_list ? NULL : list_prev_entry(sym, list)
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
 
 #define for_each_reloc(rsec, reloc)					\
 	for (int __i = 0, __fake = 1; __fake; __fake = 0)		\
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
new file mode 100644
index 000000000000..0df1dd273e1e
--- /dev/null
+++ b/tools/objtool/include/objtool/klp.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+#ifndef _OBJTOOL_KLP_H
+#define _OBJTOOL_KLP_H
+
+#define SHF_RELA_LIVEPATCH	0x00100000
+#define SHN_LIVEPATCH		0xff20
+
+#define KLP_RELOCS_SEC	".klp.relocs"
+#define KLP_OBJECTS_SEC	"__klp_objects"
+#define KLP_FUNCS_SEC	"__klp_funcs"
+#define KLP_STRINGS_SEC	".rodata.klp.str1.1"
+
+struct klp_reloc {
+	void *offset;
+	void *sym;
+	u32 type;
+};
+
+int cmd_klp_diff(int argc, const char **argv);
+int cmd_klp_link(int argc, const char **argv);
+
+#endif /* _OBJTOOL_KLP_H */
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 3280abcce55e..f562b08bfbff 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -30,7 +30,7 @@ struct objtool_file {
 	struct list_head mcount_loc_list;
 	struct list_head endbr_list;
 	struct list_head call_list;
-	bool ignore_unreachables, hints, rodata;
+	bool ignore_unreachables, hints, rodata, klp;
 
 	unsigned int nr_endbr;
 	unsigned int nr_endbr_int;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
new file mode 100644
index 000000000000..76296e38f9ff
--- /dev/null
+++ b/tools/objtool/klp-diff.c
@@ -0,0 +1,1112 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+#include <libgen.h>
+#include <stdio.h>
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/arch.h>
+#include <objtool/klp.h>
+#include <linux/livepatch_ext.h>
+#include <linux/stringify.h>
+#include <linux/string.h>
+#include <linux/jhash.h>
+
+#define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+
+struct elfs {
+	struct elf *orig, *patched, *out;
+};
+
+struct export {
+	struct hlist_node hash;
+	char *mod, *sym;
+};
+
+static DEFINE_HASHTABLE(exports, 15);
+
+static inline u32 str_hash(const char *str)
+{
+	return jhash(str, strlen(str), 0);
+}
+
+static void read_exports(void)
+{
+	const char *symvers = "Module.symvers";
+	char line[1024];
+	FILE *file;
+
+	file = fopen(symvers, "r");
+	ERROR_ON(!file, "can't open '%s', \"objtool diff\" should be run from the kernel tree", symvers);
+
+	while (fgets(line, 1024, file)) {
+		char *sym, *mod, *exp;
+		struct export *export;
+
+		sym = strchr(line, '\t');
+		ERROR_ON(!sym, "malformed Module.symvers");
+
+		*sym++ = '\0';
+
+		mod = strchr(sym, '\t');
+		ERROR_ON(!mod, "malformed Module.symvers");
+
+		*mod++ = '\0';
+
+		exp = strchr(mod, '\t');
+		ERROR_ON(!exp, "malformed Module.symvers");
+
+		*exp++ = '\0';
+
+		ERROR_ON(*sym == '\0' || *mod == '\0', "malformed Module.symvers");
+
+		export = calloc(1, sizeof(*export));
+		ERROR_ON(!export, "calloc");
+
+		export->mod = strdup(mod);
+		export->sym = strdup(sym);
+		hash_add(exports, &export->hash, str_hash(sym));
+	}
+}
+
+static int read_sym_checksums(struct elf *elf)
+{
+	struct section *sec;
+
+	sec = find_section_by_name(elf, SYM_CHECKSUM_SEC);
+	if (!sec)
+		return 0;
+
+	if (!sec->rsec)
+		ERROR("missing reloc section for " SYM_CHECKSUM_SEC);
+
+	if (sec_size(sec) % sizeof(struct sym_checksum))
+		ERROR("struct sym_checksum size mismatch");
+
+	for (int i = 0; i < sec_size(sec) / sizeof(struct sym_checksum); i++) {
+		struct sym_checksum *sym_checksum;
+		struct reloc *reloc;
+		struct symbol *sym;
+
+		sym_checksum = (struct sym_checksum *)sec->data->d_buf + i;
+
+		reloc = find_reloc_by_dest(elf, sec, i * sizeof(*sym_checksum));
+		if (!reloc)
+			ERROR("can't find reloc for sym_checksum[%d]", i);
+
+		sym = reloc->sym;
+
+		if (is_section_symbol(sym))
+			ERROR("not sure how to handle section %s", sym->name);
+
+		if (is_function_symbol(sym))
+			sym->checksum = sym_checksum->checksum;
+	}
+
+	return 0;
+}
+static struct symbol *first_file_symbol(struct elf *elf)
+{
+	struct symbol *sym;
+
+	for_each_sym(elf, sym)
+		if (is_file_symbol(sym))
+			return sym;
+
+	return NULL;
+}
+
+static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
+{
+	for_each_sym_continue(elf, sym)
+		if (is_file_symbol(sym))
+			return sym;
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
+		"CSWTCH.",
+	};
+
+	if (!is_object_symbol(sym) || !is_local_symbol(sym))
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
+static bool is_special_section(struct section *sec)
+{
+	static const char * const specials[] = {
+		".altinstructions",
+		".smp_locks",
+		"__bug_table",
+		"__ex_table",
+		"__jump_table",
+		"__mcount_loc",
+		/*
+		 * .static_call_sites is generated by "objtool --static-call"
+		 * which will run again later at livepatch module link time.
+		 * So one might be forgiven for thinking it doesn't need to be
+		 * extracted here.
+		 *
+		 * However, when run on modules, objtool blocks access to
+		 * unexported static call keys.
+		 *
+		 * So extract it here to inherit the non-module preferential
+		 * treatment.  The later static call processing will be skipped
+		 * when it sees this section already exists.
+		 */
+		".static_call_sites",
+	};
+
+	static const char * const non_special_discards[] = {
+		".discard.addressable",
+		SYM_CHECKSUM_SEC,
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(specials); i++)
+		if (!strcmp(sec->name, specials[i]))
+			return true;
+
+	/* Most .discard sections are special */
+	for (int i = 0; i < ARRAY_SIZE(non_special_discards); i++)
+		if (!strcmp(sec->name, non_special_discards[i]))
+			return false;
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
+	for (int i = 0; i < ARRAY_SIZE(specials_aux); i++)
+		if (!strcmp(sec->name, specials_aux[i]))
+			return true;
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
+	return is_file_symbol(sym) ||
+	       is_null_symbol(sym) ||
+	       is_section_symbol(sym) ||
+	       is_prefix_symbol(sym) ||
+	       is_uncorrelated_static_local(sym) ||
+	       is_string_section(sym->sec) ||
+	       is_special_section(sym->sec) ||
+	       is_special_section_aux(sym->sec) ||
+	       strstarts(sym->name, "__UNIQUE_ID") ||
+	       strstarts(sym->name, "__initcall__");
+}
+
+/*
+ * For each symbol in the original kernel, find its corresponding "twin" in the
+ * patched kernel.
+ */
+static void correlate_symbols(struct elf *elf1, struct elf *elf2)
+{
+	struct symbol *file1_sym, *file2_sym;
+	struct symbol *sym1, *sym2;
+
+	/* Correlate locals */
+	for (file1_sym = first_file_symbol(elf1),
+	     file2_sym = first_file_symbol(elf2); ;
+	     file1_sym = next_file_symbol(elf1, file1_sym),
+	     file2_sym = next_file_symbol(elf2, file2_sym)) {
+
+		if (!file1_sym && file2_sym)
+			ERROR("FILE symbol mismatch: NULL != %s", file2_sym->name);
+
+		if (file1_sym && !file2_sym)
+			ERROR("FILE symbol mismatch: %s != NULL", file1_sym->name);
+
+		if (!file1_sym)
+			break;
+
+		if (strcmp(file1_sym->name, file2_sym->name))
+			ERROR("FILE symbol mismatch: %s != %s",file1_sym->name, file2_sym->name);
+
+		file1_sym->twin = file2_sym;
+		file2_sym->twin = file1_sym;
+
+		sym1 = file1_sym;
+
+		for_each_sym_continue(elf1, sym1) {
+			if (is_file_symbol(sym1) || !is_local_symbol(sym1))
+				break;
+
+			if (dont_correlate(sym1))
+				continue;
+
+			sym2 = file2_sym;
+			for_each_sym_continue(elf2, sym2) {
+				if (is_file_symbol(sym2) || !is_local_symbol(sym2))
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
+	for_each_sym(elf1, sym1) {
+		if (sym1->bind == STB_LOCAL)
+			continue;
+
+		sym2 = find_global_symbol_by_name(elf2, sym1->name);
+
+		if (sym2 && !sym2->twin && !strcmp(sym1->name, sym2->name)) {
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+		}
+	}
+
+	for_each_sym(elf1, sym1) {
+		if (sym1->twin || dont_correlate(sym1))
+			continue;
+		WARN("no correlation: %s", sym1->name);
+	}
+}
+
+/* "sympos" is used by livepatch to disambiguate duplicate symbol names */
+static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
+{
+	unsigned long sympos = 0, nr_matches = 0;
+	bool has_dup = false;
+	struct symbol *s;
+
+	if (sym->bind != STB_LOCAL)
+		return 0;
+
+	for_each_sym(elf, s) {
+		if (!strcmp(s->name, sym->name)) {
+			nr_matches++;
+			if (s == sym)
+				sympos = nr_matches;
+			else
+				has_dup = true;
+		}
+	}
+
+	if (!sympos)
+		ERROR("can't find sympos for %s", sym->name);
+
+	return has_dup ? sympos : 0;
+}
+
+static void clone_sym_relocs(struct elfs *e, struct symbol *sym_patched);
+
+static struct symbol *__clone_symbol(struct elf *elf, struct symbol *sym_patched,
+				     bool data_too)
+{
+	struct section *sec = NULL;
+	unsigned long offset = 0;
+	struct symbol *sym;
+
+	if (data_too && sym_has_section(sym_patched)) {
+		struct section *sec_patched = sym_patched->sec;
+
+		sec = find_section_by_name(elf, sec_patched->name);
+		if (!sec)
+			sec = elf_create_section(elf, sec_patched->name, 0,
+						 sec_patched->sh.sh_entsize,
+						 sec_patched->sh.sh_type,
+						 sec_patched->sh.sh_addralign,
+						 sec_patched->sh.sh_flags);
+
+		if (is_string_section(sym_patched->sec)) {
+			sym = elf_create_section_symbol(elf, sec);
+			goto sym_created;
+		}
+
+		if (!is_section_symbol(sym_patched))
+			offset = sec_size(sec);
+
+		if (sym_patched->len || is_section_symbol(sym_patched)) {
+			void *data = NULL;
+			size_t size;
+
+			// bss doesn't have data
+			if (sym_patched->sec->data->d_buf)
+				data = sym_patched->sec->data->d_buf + sym_patched->offset;
+
+			if (is_section_symbol(sym_patched))
+				size = sec_size(sym_patched->sec);
+			else
+				size = sym_patched->len;
+
+			elf_add_data(elf, sec, data, size);
+		}
+	}
+
+	sym = elf_create_symbol(elf, sym_patched->name, sec, sym_patched->bind,
+				sym_patched->type, offset, sym_patched->len);
+
+sym_created:
+	sym_patched->clone = sym;
+	sym->clone = sym_patched;
+
+	return sym;
+}
+
+/*
+ * Copy a symbol to the output object, optionally including its data and
+ * relocations.
+ */
+static struct symbol *clone_symbol(struct elfs *e, struct symbol *sym_patched,
+				   bool data_too)
+{
+	if (sym_patched->clone)
+		return sym_patched->clone;
+
+	/* Clone prefix symbol */
+	if (data_too && is_function_symbol(sym_patched) && sym_patched->offset) {
+		struct symbol *pfx_patched;
+
+		pfx_patched = sec_prev_sym(sym_patched->sec, sym_patched);
+
+		if (pfx_patched && is_prefix_symbol(pfx_patched))
+			__clone_symbol(e->out, pfx_patched, true);
+	}
+
+	__clone_symbol(e->out, sym_patched, data_too);
+
+	if (data_too)
+		clone_sym_relocs(e, sym_patched);
+
+	return sym_patched->clone;
+}
+
+/*
+ * Copy all changed functions (and their dependencies) from the patched object
+ * to the output object.
+ */
+static void clone_changed_functions(struct elfs *e)
+{
+	struct symbol *sym_orig, *sym_patched;
+
+	/* Find changed functions */
+	for_each_sym(e->orig, sym_orig) {
+		if (!is_function_symbol(sym_orig) || is_prefix_symbol(sym_orig))
+			continue;
+
+		if (!sym_orig->twin)
+			continue;
+
+		if (sym_orig->checksum != sym_orig->twin->checksum) {
+			printf("%s: changed: %s\n", Objname, sym_orig->name);
+			sym_orig->twin->changed = 1;
+		}
+	}
+
+	/* Find added functions */
+	for_each_sym(e->patched, sym_patched) {
+		if (!is_function_symbol(sym_patched) || is_prefix_symbol(sym_patched))
+			continue;
+
+		if (!sym_patched->twin) {
+			sym_patched->added = 1;
+			printf("%s: added: %s\n", Objname, sym_patched->name);
+		}
+	}
+
+	/* Clone changed and added functions */
+	for_each_sym(e->patched, sym_patched) {
+		if (sym_patched->changed || sym_patched->added)
+			clone_symbol(e, sym_patched, true);
+	}
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
+	if (is_string_section(sec))
+		return true;
+
+	/*
+	 * .rodata has mostly anonymous data so there's no way to determine the
+	 * length of a needed reference.  just copy the whole section.
+	 */
+	if (!strcmp(sec->name, ".rodata"))
+		return true;
+
+	/* UBSAN anonymous data */
+	if (strstarts(sec->name, ".data..Lubsan"))
+		return true;
+
+	return false;
+}
+
+static bool is_reloc_allowed(struct reloc *reloc)
+{
+	return section_reference_needed(reloc->sym->sec) ==
+	       is_section_symbol(reloc->sym);
+}
+
+static struct export *find_export(struct elf *elf, struct symbol *sym)
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
+	struct section  *sec;
+	char *name;
+
+	sec = find_section_by_name(e->orig, ".modinfo");
+	if (!sec)
+		ERROR("missing .modinfo section");
+
+	name = memmem(sec->data, sec_size(sec), "\0name=", 6);
+	if (name)
+		return name + 6;
+
+	name = strdup(e->orig->name);
+	ERROR_ON(!name, "strdup");
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
+	static const char *modname;
+
+	if (modname)
+		return modname;
+
+	modname = __find_modname(e);
+	return modname;
+}
+
+static bool klp_reloc_needed(struct elf *elf_patched, struct reloc *reloc_patched)
+{
+	struct symbol *sym_patched = reloc_patched->sym;
+	struct export *export;
+
+	/* no external symbol to reference */
+	if (dont_correlate(sym_patched))
+		return false;
+
+	/* For cloned functions, a regular reloc will do. */
+	if (sym_patched->changed || sym_patched->added)
+		return false;
+
+	/*
+	 * If exported by a module, it has to be a klp reloc.  Thanks to the
+	 * clusterfoot that is late module patching, the patch module is
+	 * allowed to be loaded before any modules it depends on.
+	 *
+	 * If exported by vmlinux, a normal reloc will work.
+	 */
+	export = find_export(elf_patched, sym_patched);
+	if (export)
+		return strcmp(export->mod, "vmlinux");
+
+	if (!sym_patched->twin) {
+		/*
+		 * Presumably the symbol and its reference were added by the
+		 * patch.  The symbol could be defined in this .o or in another
+		 * .o in the patch module.
+		 *
+		 * This should be checked *after* the exports, for the case
+		 * where the patch adds a reference to an exported symbol.
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
+	if (!sec->sym)
+		elf_create_section_symbol(elf, sec);
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
+static void clone_reloc_klp(struct elfs *e, struct reloc *reloc_patched,
+			    struct section *sec, unsigned long offset,
+			    struct export *export)
+{
+	struct symbol *sym_patched = reloc_patched->sym;
+	s64 addend = reloc_addend(reloc_patched);
+	const char *sym_modname, *sym_orig_name;
+	static struct section *klp_relocs;
+	struct symbol *sym, *klp_sym;
+	unsigned long klp_reloc_off;
+	char sym_name[SYM_NAME_LEN];
+	struct klp_reloc klp_reloc;
+	unsigned long sympos;
+
+	if (!sym_patched->twin)
+		ERROR("unexpected klp reloc for new symbol %s", sym_patched->name);
+
+	/*
+	 * First, copy the original reloc and symbol as-is so objtool will be
+	 * able to process the code correctly during module link time.  This
+	 * relocation will be disabled later by cmd_klp_link().
+	 */
+
+	sym = sym_patched->clone;
+	if (!sym) {
+		sym = elf_create_klp_symbol(e->out, sym_patched->name,
+					    sym_patched->bind,
+					    sym_patched->type);
+		sym_patched->clone = sym;
+		sym->clone = sym_patched;
+	}
+
+	elf_create_reloc(e->out, sec, offset, sym, addend, reloc_type(reloc_patched));
+
+	/*
+	 * Second, create the klp symbol.
+	 */
+
+	if (export) {
+		sym_modname = export->mod;
+		sym_orig_name = export->sym;
+		sympos = 0;
+	} else {
+		sym_modname = find_modname(e);
+		sym_orig_name = sym_patched->twin->name;
+		sympos = find_sympos(e->orig, sym_patched->twin);
+	}
+
+	/* symbol format: .klp.sym.modname.sym_name,sympos */
+	snprintf(sym_name, SYM_NAME_LEN, KLP_SYM_PREFIX "%s.%s,%ld",
+		 sym_modname, sym_orig_name, sympos);
+
+	klp_sym = find_symbol_by_name(e->out, sym_name);
+	if (!klp_sym)
+		klp_sym = elf_create_klp_symbol(e->out, sym_name,
+						sym_patched->bind,
+						sym_patched->type);
+
+	/*
+	 * Third, create the .klp_relocs entry, which will be converted to an
+	 * actual klp rela by cmd_klp_link().
+	 *
+	 * This intermediate step is necessary to prevent corruption by the
+	 * linker, which doesn't know how to properly handle two rela sections
+	 * applying to the same base section.
+	 */
+
+	if (!klp_relocs)
+		klp_relocs = elf_create_section(e->out, KLP_RELOCS_SEC, 0,
+						0, SHT_PROGBITS, 8, SHF_ALLOC);
+
+	klp_reloc_off = sec_size(klp_relocs);
+	memset(&klp_reloc, 0, sizeof(klp_reloc));
+
+	klp_reloc.type = reloc_type(reloc_patched);
+	elf_add_data(e->out, klp_relocs, &klp_reloc, sizeof(klp_reloc));
+
+	/* klp_reloc.offset */
+	if (!sec->sym)
+		elf_create_section_symbol(e->out, sec);
+	elf_create_reloc(e->out, klp_relocs,
+			 klp_reloc_off + offsetof(struct klp_reloc, offset),
+			 sec->sym, offset, R_ABS64);
+
+	/* klp_reloc.sym */
+	elf_create_reloc(e->out, klp_relocs,
+			 klp_reloc_off + offsetof(struct klp_reloc, sym),
+			 klp_sym, addend, R_ABS64);
+
+}
+
+/* Copy a reloc and its symbol to the output object */
+static void clone_reloc(struct elfs *e, struct reloc *reloc_patched,
+			struct section *sec, unsigned long offset)
+{
+	struct symbol *sym_patched = reloc_patched->sym;
+	struct export *export = find_export(e->out, sym_patched);
+	s64 addend = reloc_addend(reloc_patched);
+	struct symbol *sym;
+
+	if (!is_reloc_allowed(reloc_patched))
+		ERROR_FUNC(reloc_patched->sec->base, reloc_offset(reloc_patched),
+			   "missing symbol for reference to %s+0x%lx",
+			   sym_patched->name, addend);
+
+	if (klp_reloc_needed(e->patched, reloc_patched)) {
+		clone_reloc_klp(e, reloc_patched, sec, offset, export);
+		return;
+	}
+
+	sym = clone_symbol(e, sym_patched, !export);
+
+	if (is_string_section(sym_patched->sec))
+		addend = elf_add_string(e->out, sym->sec,
+					reloc_patched->sym->sec->data->d_buf + addend);
+
+	elf_create_reloc(e->out, sec, offset, sym, addend, reloc_type(reloc_patched));
+}
+
+/* Copy all relocs needed for a symbol's contents */
+static void clone_sym_relocs(struct elfs *e, struct symbol *sym_patched)
+{
+	struct section *rsec_patched = sym_patched->sec->rsec;
+	struct reloc *reloc_patched;
+	unsigned long start, end;
+	struct symbol *sym;
+
+	sym = sym_patched->clone;
+	if (!sym)
+		ERROR("no clone for %s", sym_patched->name);
+
+	if (!rsec_patched)
+		return;
+
+	if (!is_section_symbol(sym_patched) && !sym_patched->len)
+		return;
+
+	if (is_string_section(sym_patched->sec))
+		return;
+
+	if (is_section_symbol(sym_patched)) {
+		start = 0;
+		end = sec_size(sym_patched->sec);
+	} else {
+		start = sym_patched->offset;
+		end = start + sym_patched->len;
+	}
+
+	for_each_reloc(rsec_patched, reloc_patched) {
+		unsigned long offset;
+
+		if (reloc_offset(reloc_patched) < start ||
+		    reloc_offset(reloc_patched) >= end)
+			continue;
+
+		convert_reloc_sym(e->patched, reloc_patched);
+
+		offset = sym->offset + (reloc_offset(reloc_patched) - sym_patched->offset);
+
+		clone_reloc(e, reloc_patched, sym->sec, offset);
+	}
+}
+
+/* Keep a special section entry if it references an included function */
+static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
+{
+	struct reloc *reloc;
+
+	if (is_section_symbol(sym))
+		return false;
+
+	for_each_reloc(sym->sec->rsec, reloc) {
+		unsigned long reloc_off = reloc_offset(reloc);
+
+		if (convert_reloc_sym(elf, reloc))
+			continue;
+
+		if (reloc_off >= sym->offset && reloc_off < sym->offset + sym->len &&
+		    is_function_symbol(reloc->sym) &&
+		    (reloc->sym->changed || reloc->sym->added))
+			return true;
+	}
+
+	return false;
+}
+
+static unsigned int reloc_size(struct reloc *reloc)
+{
+	switch (reloc_type(reloc)) {
+
+	case R_X86_64_PC32:
+	case R_X86_64_32:
+		return 4;
+
+	case R_X86_64_64:
+	case R_X86_64_PC64:
+		return 8;
+
+	default:
+		ERROR("unknown reloc type");
+	}
+}
+
+static void clone_special_section(struct elfs *e, struct section *sec_patched)
+{
+	unsigned long off_patched, off_out;
+	struct reloc *reloc_patched;
+	struct symbol *sym_patched;
+	bool has_syms = false;
+	struct section *sec;
+
+	/*
+	 * Some special sections are composed of an array of structs, where
+	 * each array entry has its own fake symbol denoting its location and
+	 * size.  Copy all entries (both data and relocs) referencing an
+	 * included function.
+	 */
+	off_patched = 0;
+	sec_for_each_sym(sec_patched, sym_patched) {
+		if (!is_object_symbol(sym_patched))
+			continue;
+		has_syms = true;
+
+		if (off_patched != sym_patched->offset)
+			ERROR_FUNC(sec_patched, off_patched, "special section symbol gap");
+
+		off_patched = sym_patched->offset + sym_patched->len;
+
+		if (!should_keep_special_sym(e->patched, sym_patched))
+			continue;
+
+		clone_symbol(e, sym_patched, true);
+	}
+
+	if (has_syms)
+		return;
+
+	/*
+	 * Some special sections are just a simple array of pointers.  Copy all
+	 * relocs referencing included functions.
+	 */
+	off_patched = 0;
+	off_out = 0;
+	sec = NULL;
+	for_each_reloc(sec_patched->rsec, reloc_patched) {
+		unsigned int rel_size = reloc_size(reloc_patched);
+
+		if (off_patched != reloc_offset(reloc_patched))
+			ERROR("special section reloc gap - does it need fake symbols?");
+
+		off_patched += rel_size;
+
+		if (convert_reloc_sym(e->patched, reloc_patched))
+			continue;
+
+		if (!reloc_patched->sym->changed && !reloc_patched->sym->added)
+			continue;
+
+		if (!sec) {
+			sec = find_section_by_name(e->out, sec_patched->name);
+			if (sec)
+				ERROR("why does %s already exist?", sec_patched->name);
+
+			sec = elf_create_section(e->out, sec_patched->name, 0,
+						 sec_patched->sh.sh_entsize,
+						 sec_patched->sh.sh_type,
+						 sec_patched->sh.sh_addralign,
+						 sec_patched->sh.sh_flags);
+		}
+
+		elf_add_data(e->out, sec, NULL, rel_size);
+		clone_reloc(e, reloc_patched, sec, off_out);
+		off_out += rel_size;
+	}
+}
+
+/* Extract only the needed bits from special sections */
+static void clone_special_sections(struct elfs *e)
+{
+	struct section *sec_patched;
+
+	for_each_sec(e->patched, sec_patched) {
+		if (is_special_section(sec_patched))
+			clone_special_section(e, sec_patched);
+	}
+}
+
+/*
+ * Create __klp_objects and __klp_funcs sections which are intermediate
+ * sections provided as input to the patch module's init code (module.c) for
+ * building the 'struct klp_patch' needed for the livepatch API.
+ */
+static void create_klp_sections(struct elfs *e)
+{
+	size_t obj_size  = sizeof(struct klp_object_ext);
+	size_t func_size = sizeof(struct klp_func_ext);
+	struct section *obj_sec, *funcs_sec, *str_sec;
+	struct symbol *funcs_sym, *str_sym, *sym;
+	const char *modname = find_modname(e);
+	char sym_name[SYM_NAME_LEN];
+	unsigned int nr_funcs = 0;
+	void *obj_data;
+	s64 addend;
+
+	obj_sec  = elf_create_section_pair(e->out, KLP_OBJECTS_SEC, obj_size, 0, 0);
+
+	funcs_sec = elf_create_section_pair(e->out, KLP_FUNCS_SEC, func_size, 0, 0);
+	funcs_sym = elf_create_section_symbol(e->out, funcs_sec);
+
+	str_sec = elf_create_section(e->out, KLP_STRINGS_SEC, 0, 0,
+				     SHT_PROGBITS, 1,
+				     SHF_ALLOC | SHF_STRINGS | SHF_MERGE);
+	elf_add_string(e->out, str_sec, "");
+	str_sym = elf_create_section_symbol(e->out, str_sec);
+
+	/* allocate klp_object_ext */
+	obj_data = elf_add_data(e->out, obj_sec, NULL, obj_size);
+
+	/* klp_object_ext.name */
+	if (strcmp(modname, "vmlinux")) {
+		addend = elf_add_string(e->out, str_sec, modname);
+		elf_create_reloc(e->out, obj_sec,
+				 offsetof(struct klp_object_ext, name),
+				 str_sym, addend, R_ABS64);
+	}
+
+	/* klp_object_ext.funcs */
+	elf_create_reloc(e->out, obj_sec, offsetof(struct klp_object_ext, funcs),
+			 funcs_sym, 0, R_ABS64);
+
+	for_each_sym(e->out, sym) {
+		unsigned long offset = nr_funcs * func_size;
+		unsigned long sympos;
+		void *func_data;
+
+		if (!sym->clone || !sym->clone->changed || !is_function_symbol(sym))
+			continue;
+
+		/* allocate klp_func_ext */
+		func_data = elf_add_data(e->out, funcs_sec, NULL, func_size);
+
+		/* klp_func_ext.old_name */
+		addend = elf_add_string(e->out, str_sec, sym->clone->twin->name);
+		elf_create_reloc(e->out, funcs_sec,
+				 offset + offsetof(struct klp_func_ext, old_name),
+				 str_sym, addend, R_ABS64);
+
+		/* klp_func_ext.new_func */
+		elf_create_reloc(e->out, funcs_sec,
+				 offset + offsetof(struct klp_func_ext, new_func),
+				 sym, 0, R_ABS64);
+
+		/* klp_func_ext.sympos */
+		BUILD_BUG_ON(sizeof(sympos) != sizeof_field(struct klp_func_ext, sympos));
+		sympos = find_sympos(e->orig, sym->clone->twin);
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
+	snprintf(sym_name, SYM_NAME_LEN, KLP_PRE_PATCH_PREFIX "%s", modname);
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		elf_create_reloc(e->out, obj_sec,
+				 offsetof(struct klp_object_ext, callbacks) +
+				 offsetof(struct klp_callbacks, pre_patch),
+				 reloc->sym, reloc_addend(reloc), R_ABS64);
+	}
+
+	snprintf(sym_name, SYM_NAME_LEN, KLP_POST_PATCH_PREFIX "%s", modname);
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		elf_create_reloc(e->out, obj_sec,
+				 offsetof(struct klp_object_ext, callbacks) +
+				 offsetof(struct klp_callbacks, post_patch),
+				 reloc->sym, reloc_addend(reloc), R_ABS64);
+	}
+
+	snprintf(sym_name, SYM_NAME_LEN, KLP_PRE_UNPATCH_PREFIX "%s", modname);
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		elf_create_reloc(e->out, obj_sec,
+				 offsetof(struct klp_object_ext, callbacks) +
+				 offsetof(struct klp_callbacks, pre_unpatch),
+				 reloc->sym, reloc_addend(reloc), R_ABS64);
+	}
+
+	snprintf(sym_name, SYM_NAME_LEN, KLP_POST_UNPATCH_PREFIX "%s", modname);
+	sym = find_symbol_by_name(e->out, sym_name);
+	if (sym) {
+		struct reloc *reloc;
+
+		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
+
+		elf_create_reloc(e->out, obj_sec,
+				 offsetof(struct klp_object_ext, callbacks) +
+				 offsetof(struct klp_callbacks, post_unpatch),
+				 reloc->sym, reloc_addend(reloc), R_ABS64);
+	}
+}
+
+int cmd_klp_diff(int argc, const char **argv)
+{
+	struct elf *elf_orig, *elf_patched, *elf_out;
+	struct elfs e;
+
+	argc--;
+	argv++;
+
+	if (argc != 3) {
+		fprintf(stderr, "usage: objtool diff <in1.o> <in2.o> <out.o>\n");
+		return -1;
+	}
+
+	elf_orig = elf_open_read(argv[0], O_RDONLY);
+	elf_patched = elf_open_read(argv[1], O_RDONLY);
+
+	Objname = basename(Objname);
+
+	read_exports();
+
+	read_sym_checksums(elf_orig);
+	read_sym_checksums(elf_patched);
+
+	correlate_symbols(elf_orig, elf_patched);
+
+	elf_out = elf_create_file(&elf_orig->ehdr, argv[2]);
+
+	e.orig		= elf_orig;
+	e.patched	= elf_patched;
+	e.out		= elf_out;
+
+	clone_changed_functions(&e);
+
+	clone_special_sections(&e);
+
+	create_klp_sections(&e);
+
+	elf_write(elf_out);
+	return 0;
+}
+
diff --git a/tools/objtool/klp-link.c b/tools/objtool/klp-link.c
new file mode 100644
index 000000000000..0b42a79c8215
--- /dev/null
+++ b/tools/objtool/klp-link.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+#include <fcntl.h>
+#include <gelf.h>
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/klp.h>
+#include <linux/livepatch_ext.h>
+
+/*
+ * This runs on the livepatch module after all other linking has been done.  It
+ * converts the intermediate __klp_relocs section into proper klp relocs to be
+ * processed by livepatch.  This needs to run last to avoid linker wreckage.
+ * Linkers don't tend to handle the "two rela sections for a single base
+ * section" case very well.
+ */
+int cmd_klp_link(int argc, const char **argv)
+{
+	struct section *symtab, *klp_relocs;
+	struct elf *elf;
+
+	argc--;
+	argv++;
+
+	if (argc != 1) {
+		fprintf(stderr, "%d\n", argc);
+		fprintf(stderr, "usage: objtool link <file.ko>\n");
+		return -1;
+	}
+
+	elf = elf_open_read(argv[0], O_RDWR);
+
+	klp_relocs = find_section_by_name(elf, KLP_RELOCS_SEC);
+	if (!klp_relocs)
+		return 0;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab)
+		ERROR("missing .symtab");
+
+	for (int i = 0; i < sec_size(klp_relocs) / sizeof(struct klp_reloc); i++) {
+		struct klp_reloc *klp_reloc;
+		unsigned long klp_reloc_off;
+		struct section *sec, *tmp, *klp_rsec;
+		unsigned long offset;
+		struct reloc *reloc;
+		char sym_modname[64];
+		char rsec_name[SEC_NAME_LEN];
+		u64 addend;
+		struct symbol *sym, *klp_sym;
+
+		klp_reloc_off = i * sizeof(*klp_reloc);
+		klp_reloc = klp_relocs->data->d_buf + klp_reloc_off;
+
+		/*
+		 * Read __klp_relocs entry:
+		 */
+
+		/* klp_reloc.sec_offset */
+		reloc = find_reloc_by_dest(elf, klp_relocs,
+					   klp_reloc_off + offsetof(struct klp_reloc, offset));
+		ERROR_ON(!reloc, "malformed " KLP_RELOCS_SEC " section");
+
+		sec = reloc->sym->sec;
+		offset = reloc_addend(reloc);
+
+		/* klp_reloc.sym */
+		reloc = find_reloc_by_dest(elf, klp_relocs,
+					   klp_reloc_off + offsetof(struct klp_reloc, sym));
+		ERROR_ON(!reloc, "malformed " KLP_RELOCS_SEC " section");
+
+		klp_sym = reloc->sym;
+		addend = reloc_addend(reloc);
+
+		/* symbol format: .klp.sym.modname.sym_name,sympos */
+		sscanf(klp_sym->name + strlen(KLP_SYM_PREFIX), "%55[^.]", sym_modname);
+
+		/*
+		 * Create klp reloc:
+		 */
+
+		/* section format: .klp.rela.sec_objname.section_name */
+		snprintf(rsec_name, SEC_NAME_LEN, KLP_RELOC_SEC_PREFIX "%s.%s",
+			 sym_modname, sec->name);
+		klp_rsec = find_section_by_name(elf, rsec_name);
+
+		if (!klp_rsec) {
+			klp_rsec = elf_create_section(elf, rsec_name, 0,
+						      elf_rela_size(elf),
+						      SHT_RELA, elf_addr_size(elf),
+						      SHF_ALLOC | SHF_INFO_LINK | SHF_RELA_LIVEPATCH);
+
+			klp_rsec->sh.sh_link = symtab->idx;
+			klp_rsec->sh.sh_info = sec->idx;
+			klp_rsec->base = sec;
+		}
+
+		tmp = sec->rsec;
+		sec->rsec = klp_rsec;
+		elf_create_reloc(elf, sec, offset, klp_sym, addend, klp_reloc->type);
+		sec->rsec = tmp;
+
+		klp_sym->sym.st_shndx = SHN_LIVEPATCH;
+		gelf_update_sym(symtab->data, klp_sym->idx, &klp_sym->sym);
+
+		/*
+		 * Disable original non-klp reloc by converting it to R_*_NONE:
+		 */
+
+		reloc = find_reloc_by_dest(elf, sec, offset);
+		sym = reloc->sym;
+		sym->sym.st_shndx = SHN_LIVEPATCH;
+		set_reloc_type(elf, reloc, 0);
+		gelf_update_sym(symtab->data, sym->idx, &sym->sym);
+	}
+
+	elf_write(elf);
+
+	return 0;
+}
diff --git a/tools/objtool/klp.c b/tools/objtool/klp.c
new file mode 100644
index 000000000000..fc871108060e
--- /dev/null
+++ b/tools/objtool/klp.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
+ */
+
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
+	{ "diff",		"Generate binary diff of two object files",			cmd_klp_diff, },
+	{ "link",		"Finalize klp symbols/relocations after module linking",	cmd_klp_link, },
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
+		fprintf(stderr,"  %s\t%s\n", cmd->name, cmd->description);
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
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index 06f7e518b8a7..75ff32ab0368 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -122,5 +122,11 @@ int main(int argc, const char **argv)
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
index 81d120d05442..873ce93f9993 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -16,6 +16,7 @@ arch/x86/include/asm/orc_types.h
 arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
+include/linux/livepatch_ext.h
 include/linux/static_call_types.h
 "
 
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index 426fdf0b7548..7e1858885fd6 100644
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
2.45.2


