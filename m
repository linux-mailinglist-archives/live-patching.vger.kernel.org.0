Return-Path: <live-patching+bounces-1398-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69534AB1E1B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CED15542418
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B849125F96B;
	Fri,  9 May 2025 20:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzdCprVN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA03298998;
	Fri,  9 May 2025 20:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821892; cv=none; b=kva6unK4skBPQuva4MSR751CMiNlE6cr/HBrT1OgSkbZZvcYIJO33r3Ylf7WdUGyyxHOOvwz2n9Th7c2RvBOna1FDReWjgLbFjNmVJTdLv1KmGE9izgCxu7Md9RR7LYHtAx53W0gfTJ9uGkKaHsZ8S1v4mauLBJEwmpkbizTGiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821892; c=relaxed/simple;
	bh=zsZfauCU6GgJ9tzyyCAWCfFGv5Mky/g31a415oAov7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlLh/dK8l5URWKEl9+ZSG3abL+6/+f+vcIo3TK4H2RNlQN4VOrvtVRYRJU2q1F1ihAm98XQee0BJ5Gw69ExKZHWnZRQIlfoEAW+OvBydZRxk9z0JFCO+swkbHz5bNF89GQCqfJBbjAllYezp0Eraz2p6qWbKLDs/P/pyxMbCqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzdCprVN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4544C4CEE9;
	Fri,  9 May 2025 20:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821892;
	bh=zsZfauCU6GgJ9tzyyCAWCfFGv5Mky/g31a415oAov7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzdCprVNi4eZPUsvPKMacTyN6dpgv1uyU01kh4ag1+4qiqiVIjqmuiOQtsvTZlLBa
	 fvDEpoG5hlUt52OuBL6dwfHRpEBuaAksphi2TG+wEbYG/LjQ+BgarhcgJ2WA9nHrmL
	 JVsEkEqvSU8zFNucIhTgVeSxXdhfRNgPszHxet4YXqRVucCKTZGHB5mtFUHVX+26Q0
	 dUGS4BHGgCg7AjR9DkaYbv4E4zrngpC3KDgU1EUiDJbWNt67G1JmEYSI1Gfn219kMw
	 uC2HLt5XJNFeWWal2rUQqNeDJYhLVQcwN+Q4n8DINwpvIfElY6ZdjKEhTFBm0f8yMZ
	 dIcg1Ea10Vjlg==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 39/62] objtool: Add elf_create_data()
Date: Fri,  9 May 2025 13:17:03 -0700
Message-ID: <d2541a7b787d356c82adcd108ce06d20f22ef6f3.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, refactor
elf_add_string() by adding a new elf_add_data() helper which allows the
adding of arbitrary data to a section.

Make both interfaces public so they can be used by the upcoming klp diff
code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 66 ++++++++++++++++++++---------
 tools/objtool/include/objtool/elf.h | 10 +++--
 2 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c38b109f441f..1b5528065df7 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -18,10 +18,11 @@
 #include <errno.h>
 #include <linux/interval_tree_generic.h>
 #include <objtool/builtin.h>
-
 #include <objtool/elf.h>
 #include <objtool/warn.h>
 
+#define ALIGN_UP(x, align_to) (((x) + ((align_to)-1)) & ~((align_to)-1))
+
 static inline u32 str_hash(const char *str)
 {
 	return jhash(str, strlen(str), 0);
@@ -761,8 +762,6 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	return 0;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
-
 struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 struct section *sec, unsigned int bind,
 				 unsigned int type, unsigned long offset,
@@ -1098,11 +1097,9 @@ struct elf *elf_open_read(const char *name, int flags)
 	return NULL;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
+unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
-	Elf_Data *data;
-	Elf_Scn *s;
-	int len;
+	unsigned int offset;
 
 	if (!strtab)
 		strtab = find_section_by_name(elf, ".strtab");
@@ -1111,28 +1108,59 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
 		return -1;
 	}
 
-	s = elf_getscn(elf->elf, strtab->idx);
+	if (!strtab->sh.sh_addralign) {
+		ERROR("'%s': invalid sh_addralign", strtab->name);
+		return -1;
+	}
+
+	offset = ALIGN_UP(strtab->sh.sh_size, strtab->sh.sh_addralign);
+
+	if (!elf_add_data(elf, strtab, str, strlen(str) + 1))
+		return -1;
+
+	return offset;
+}
+
+void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_t size)
+{
+	unsigned long offset;
+	Elf_Scn *s;
+
+	if (!sec->sh.sh_addralign) {
+		ERROR("'%s': invalid sh_addralign", sec->name);
+		return NULL;
+	}
+
+	s = elf_getscn(elf->elf, sec->idx);
 	if (!s) {
 		ERROR_ELF("elf_getscn");
-		return -1;
+		return NULL;
 	}
 
-	data = elf_newdata(s);
-	if (!data) {
+	sec->data = elf_newdata(s);
+	if (!sec->data) {
 		ERROR_ELF("elf_newdata");
-		return -1;
+		return NULL;
 	}
 
-	data->d_buf = strdup(str);
-	data->d_size = strlen(str) + 1;
-	data->d_align = 1;
+	sec->data->d_buf = calloc(1, size);
+	if (!sec->data->d_buf) {
+		ERROR_GLIBC("calloc");
+		return NULL;
+	}
 
-	len = strtab->sh.sh_size;
-	strtab->sh.sh_size += data->d_size;
+	if (data)
+		memcpy(sec->data->d_buf, data, size);
 
-	mark_sec_changed(elf, strtab, true);
+	sec->data->d_size = size;
+	sec->data->d_align = 1;
 
-	return len;
+	offset = ALIGN_UP(sec->sh.sh_size, sec->sh.sh_addralign);
+	sec->sh.sh_size = offset + size;
+
+	mark_sec_changed(elf, sec, true);
+
+	return sec->data->d_buf;
 }
 
 struct section *elf_create_section(struct elf *elf, const char *name,
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index b366516b119d..fc00f86bedba 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -134,6 +134,10 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
 struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
 					size_t size);
 
+void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
+		   size_t size);
+
+unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long offset,
@@ -147,9 +151,9 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend);
 
-int elf_write_insn(struct elf *elf, struct section *sec,
-		   unsigned long offset, unsigned int len,
-		   const char *insn);
+int elf_write_insn(struct elf *elf, struct section *sec, unsigned long offset,
+		   unsigned int len, const char *insn);
+
 int elf_write(struct elf *elf);
 void elf_close(struct elf *elf);
 
-- 
2.49.0


