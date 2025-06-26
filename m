Return-Path: <live-patching+bounces-1584-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC025AEAB77
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D8EB3BBD1A
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55A7292908;
	Thu, 26 Jun 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8s8Gp1s"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBBE291C07;
	Thu, 26 Jun 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982209; cv=none; b=cKPNNicXn/hKZ+mYRbb1tBnaY7bzCv1ipyt6LYMmj6lARB3blwREyachS/d1A6WTHVh98Q2pGbVFUMM9nTIVgU0qDklHQNzWqUA5csKVo+RUlISXbbTL2dFbrFcnI3VBybsOndN67conpvbTn+erO83SEmFidHiVOAuN3nWM5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982209; c=relaxed/simple;
	bh=eEmQq2ds1/lGftOS4JeEnlI4qoMacWd88ONXZxwga4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6kSMUEa4QDpYTeX1r4oqULvM+s/s0TqmlMEO0vuxYQuwO7m8SjSomfNI05tn/Z8R7ouJeZyk8LZxVfCS1kVbACofhDU8yQLIUWQQxkO0qMxFXkCDcAAhPyufyEM/bwLqBjI2WQjjekw7NewOEfCI8MepcX7RhXBh+g4QqV8Ey8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8s8Gp1s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01CBC4CEF5;
	Thu, 26 Jun 2025 23:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982209;
	bh=eEmQq2ds1/lGftOS4JeEnlI4qoMacWd88ONXZxwga4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8s8Gp1sGAVT6p+06zsB4wPOtinFCKnxNY6wgUTwhKKqjMCuinlH5Dr/DOKXimQlm
	 UkG/m1EkjbQhz10HGX2tQ4RTNaMr+mjby/OT5b6sXDwUh9BTYUP1i2BcAf+eh09pPh
	 XvjFeCYFWp0nRnB2vkAVh9SAuBcYKeG8e/I2AD5BrNdk19DNcfI3Li1SvPiZ3cV8qS
	 LELyya1/6GDddcZkksA+HNZGu3ioLPpvS0IRfs60yWAmvQsCZ6Pji5RaNLVBgjNz70
	 8qMgJCDijJOp4Drdplikdp+zdHSKGMHCkpEsRCVjcX1Kf+xv4lFWqUkSJBf4m672Jw
	 awoI2Lst+YRCA==
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
Subject: [PATCH v3 54/64] objtool/klp: Add post-link subcommand to finalize livepatch modules
Date: Thu, 26 Jun 2025 16:55:41 -0700
Message-ID: <543b435b521c4bd65dd2c3efced892a5a22a7ef4.1750980517.git.jpoimboe@kernel.org>
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
index 0b01657671d7..8cd71b9a5eef 100644
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
index 9b13dd1182af..56d5a5b92f72 100644
--- a/tools/objtool/builtin-klp.c
+++ b/tools/objtool/builtin-klp.c
@@ -14,6 +14,7 @@ struct subcmd {
 
 static struct subcmd subcmds[] = {
 	{ "diff",		"Generate binary diff of two object files",		cmd_klp_diff, },
+	{ "post-link",		"Finalize klp symbols/relocs after module linking",	cmd_klp_post_link, },
 };
 
 static void cmd_klp_usage(void)
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index 07928fac059b..ad830a7ce55b 100644
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
index 000000000000..c013e39957b1
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
2.49.0


