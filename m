Return-Path: <live-patching+bounces-1708-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6CCB80E48
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 481881C26CDB
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6843408F2;
	Wed, 17 Sep 2025 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB/AKL0n"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0BD3408EA;
	Wed, 17 Sep 2025 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125094; cv=none; b=RMBZ8BZbS6RIgLkYap+waWRAtLEgB4Olb/Vl4wFnISXlihVer56tEsp89CYgfJx6U+gYXFRHd5ygPirbqECpN7ChiR6P9U/D5nTH+MGYV4P6KRINRFM45y0gZWe2anASvhvQsWWUgV5KF5glE+fzJOXAVLJ+QFD7bgrPjEz73Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125094; c=relaxed/simple;
	bh=f+d5/opUeHIzeWvAnntxRC6Lxf5pkrf2VMoZgb2M5UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAFVfAEJc8Q6kmkXbm0gPUJOHoXFBjNrrndzrBJM+RQiFGOxkbITVqr73G0yp/n3piy8saG1KIr/iv78OxoISx2ZL9klsKhqWWvfmuMtAetFPRPuRSG/twEGtFFyJgk56VXNY6OkDMz9SLV5xyqk0ivSLi0M86KzSQ7J8PGyEpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB/AKL0n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4D0C4CEFA;
	Wed, 17 Sep 2025 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125094;
	bh=f+d5/opUeHIzeWvAnntxRC6Lxf5pkrf2VMoZgb2M5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB/AKL0nymjYpUNVqyUks3SpGdl1Qb6ZBDQ9Kpa2IHV5+RZxadkSNoQWqpS5WPnnE
	 3xbI9CQADT9/AjUG/RBK2n74DxVgQsmF6WrZf0FaAuVBUEGcf6k/dCj3bNUBcIVhE7
	 Ij9Co+7WbAqRJ593JHaKpre23teBFBfz0v7VfE0l0Vavz+jm+WWaLyqs4JWBq8w80b
	 AC0VuYhcfKA47TRib/I1o2rXKt/aDLcqivwOFKLjKDL0yPXnc9mCd8AbXL64ax5SU+
	 ReBF1Xem6HctITCfc5kqjOUKCIKE1QFW8/hx3BFkRl7yP2YAqAXshZt6YaYb38ytLR
	 PefbHamOFnAqg==
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
Subject: [PATCH v4 53/63] objtool/klp: Add post-link subcommand to finalize livepatch modules
Date: Wed, 17 Sep 2025 09:04:01 -0700
Message-ID: <767ac75feefd72cb7644f317359b38389e941299.1758067943.git.jpoimboe@kernel.org>
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

Livepatch needs some ELF magic which linkers don't like:

  - Two relocation sections (.rela*, .klp.rela*) for the same text
    section.

  - Use of SHN_LIVEPATCH to mark livepatch symbols.

Unfortunately linkers tend to mangle such things.  To work around that,
klp diff generates a linker-compliant intermediate binary which encodes
the relevant KLP section/reloc/symbol metadata.

After module linking, the .ko then needs to be converted to an actual
livepatch module.  Introduce a new klp post-link subcommand to do so.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Build                 |   2 +-
 tools/objtool/builtin-klp.c         |   1 +
 tools/objtool/include/objtool/klp.h |   4 +
 tools/objtool/klp-post-link.c       | 168 ++++++++++++++++++++++++++++
 4 files changed, 174 insertions(+), 1 deletion(-)
 create mode 100644 tools/objtool/klp-post-link.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 0b01657671d7f..8cd71b9a5eef1 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -9,7 +9,7 @@ objtool-y += elf.o
 objtool-y += objtool.o
 
 objtool-$(BUILD_ORC) += orc_gen.o orc_dump.o
-objtool-$(BUILD_KLP) += builtin-klp.o klp-diff.o
+objtool-$(BUILD_KLP) += builtin-klp.o klp-diff.o klp-post-link.o
 
 objtool-y += libstring.o
 objtool-y += libctype.o
diff --git a/tools/objtool/builtin-klp.c b/tools/objtool/builtin-klp.c
index 9b13dd1182af1..56d5a5b92f725 100644
--- a/tools/objtool/builtin-klp.c
+++ b/tools/objtool/builtin-klp.c
@@ -14,6 +14,7 @@ struct subcmd {
 
 static struct subcmd subcmds[] = {
 	{ "diff",		"Generate binary diff of two object files",		cmd_klp_diff, },
+	{ "post-link",		"Finalize klp symbols/relocs after module linking",	cmd_klp_post_link, },
 };
 
 static void cmd_klp_usage(void)
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index 07928fac059b5..ad830a7ce55b6 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -2,6 +2,9 @@
 #ifndef _OBJTOOL_KLP_H
 #define _OBJTOOL_KLP_H
 
+#define SHF_RELA_LIVEPATCH	0x00100000
+#define SHN_LIVEPATCH		0xff20
+
 /*
  * __klp_objects and __klp_funcs are created by klp diff and used by the patch
  * module init code to build the klp_patch, klp_object and klp_func structs
@@ -27,5 +30,6 @@ struct klp_reloc {
 };
 
 int cmd_klp_diff(int argc, const char **argv);
+int cmd_klp_post_link(int argc, const char **argv);
 
 #endif /* _OBJTOOL_KLP_H */
diff --git a/tools/objtool/klp-post-link.c b/tools/objtool/klp-post-link.c
new file mode 100644
index 0000000000000..c013e39957b11
--- /dev/null
+++ b/tools/objtool/klp-post-link.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Read the intermediate KLP reloc/symbol representations created by klp diff
+ * and convert them to the proper format required by livepatch.  This needs to
+ * run last to avoid linker wreckage.  Linkers don't tend to handle the "two
+ * rela sections for a single base section" case very well, nor do they like
+ * SHN_LIVEPATCH.
+ *
+ * This is the final tool in the livepatch module generation pipeline:
+ *
+ *   kernel builds -> objtool klp diff -> module link -> objtool klp post-link
+ */
+
+#include <fcntl.h>
+#include <gelf.h>
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/klp.h>
+#include <objtool/util.h>
+#include <linux/livepatch_external.h>
+
+static int fix_klp_relocs(struct elf *elf)
+{
+	struct section *symtab, *klp_relocs;
+
+	klp_relocs = find_section_by_name(elf, KLP_RELOCS_SEC);
+	if (!klp_relocs)
+		return 0;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		ERROR("missing .symtab");
+		return -1;
+	}
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
+		 * Read __klp_relocs[i]:
+		 */
+
+		/* klp_reloc.sec_offset */
+		reloc = find_reloc_by_dest(elf, klp_relocs,
+					   klp_reloc_off + offsetof(struct klp_reloc, offset));
+		if (!reloc) {
+			ERROR("malformed " KLP_RELOCS_SEC " section");
+			return -1;
+		}
+
+		sec = reloc->sym->sec;
+		offset = reloc_addend(reloc);
+
+		/* klp_reloc.sym */
+		reloc = find_reloc_by_dest(elf, klp_relocs,
+					   klp_reloc_off + offsetof(struct klp_reloc, sym));
+		if (!reloc) {
+			ERROR("malformed " KLP_RELOCS_SEC " section");
+			return -1;
+		}
+
+		klp_sym = reloc->sym;
+		addend = reloc_addend(reloc);
+
+		/* symbol format: .klp.sym.modname.sym_name,sympos */
+		if (sscanf(klp_sym->name + strlen(KLP_SYM_PREFIX), "%55[^.]", sym_modname) != 1)
+			ERROR("can't find modname in klp symbol '%s'", klp_sym->name);
+
+		/*
+		 * Create the KLP rela:
+		 */
+
+		/* section format: .klp.rela.sec_objname.section_name */
+		if (snprintf_check(rsec_name, SEC_NAME_LEN,
+				   KLP_RELOC_SEC_PREFIX "%s.%s",
+				   sym_modname, sec->name))
+			return -1;
+
+		klp_rsec = find_section_by_name(elf, rsec_name);
+		if (!klp_rsec) {
+			klp_rsec = elf_create_section(elf, rsec_name, 0,
+						      elf_rela_size(elf),
+						      SHT_RELA, elf_addr_size(elf),
+						      SHF_ALLOC | SHF_INFO_LINK | SHF_RELA_LIVEPATCH);
+			if (!klp_rsec)
+				return -1;
+
+			klp_rsec->sh.sh_link = symtab->idx;
+			klp_rsec->sh.sh_info = sec->idx;
+			klp_rsec->base = sec;
+		}
+
+		tmp = sec->rsec;
+		sec->rsec = klp_rsec;
+		if (!elf_create_reloc(elf, sec, offset, klp_sym, addend, klp_reloc->type))
+			return -1;
+		sec->rsec = tmp;
+
+		/*
+		 * Fix up the corresponding KLP symbol:
+		 */
+
+		klp_sym->sym.st_shndx = SHN_LIVEPATCH;
+		if (!gelf_update_sym(symtab->data, klp_sym->idx, &klp_sym->sym)) {
+			ERROR_ELF("gelf_update_sym");
+			return -1;
+		}
+
+		/*
+		 * Disable the original non-KLP reloc by converting it to R_*_NONE:
+		 */
+
+		reloc = find_reloc_by_dest(elf, sec, offset);
+		sym = reloc->sym;
+		sym->sym.st_shndx = SHN_LIVEPATCH;
+		set_reloc_type(elf, reloc, 0);
+		if (!gelf_update_sym(symtab->data, sym->idx, &sym->sym)) {
+			ERROR_ELF("gelf_update_sym");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This runs on the livepatch module after all other linking has been done.  It
+ * converts the intermediate __klp_relocs section into proper KLP relocs to be
+ * processed by livepatch.  This needs to run last to avoid linker wreckage.
+ * Linkers don't tend to handle the "two rela sections for a single base
+ * section" case very well, nor do they appreciate SHN_LIVEPATCH.
+ */
+int cmd_klp_post_link(int argc, const char **argv)
+{
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
+	if (!elf)
+		return -1;
+
+	if (fix_klp_relocs(elf))
+		return -1;
+
+	if (elf_write(elf))
+		return -1;
+
+	return elf_close(elf);
+}
-- 
2.50.0


