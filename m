Return-Path: <live-patching+bounces-1696-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC81B80E5A
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B65A01670E5
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACB833BB35;
	Wed, 17 Sep 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZu0TzfK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261133BB1B;
	Wed, 17 Sep 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125085; cv=none; b=ZqsscrewlFPjOZEfqHyBPLkhIOHAQbkU7cQcTnaHHzPN2fJ+xZMgKcd1v2dewa79kk0cnvw9hQ7tB+0VfBaDtmQnB/uTerl5oQ1JZxxvERUniUqfiSYl3HQ5JyjYUfTERSOu0RyBkxByo0ezTd5sECYBg4vlI7PxuCNkomyb73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125085; c=relaxed/simple;
	bh=FgIvGpVZakcg8IguTcsU9AOcCapCCTCRPw/skBs75RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fH9d3t40LQdfQtto/VX6jKERk5L5VnhiLC5uOkReaIYXLdL3eSDm7dF/safx1NFfg3vsooMJKpve6tGJn21XHjpeMcSAdI5Bwv0a8e1H1rvjCM0/1P1dcSQ3GOMP1ER88z2kqCivHq7MTbSaKeGcwKE2Q5fDYpK4VMX9Fa25VDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZu0TzfK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA726C4CEFA;
	Wed, 17 Sep 2025 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125085;
	bh=FgIvGpVZakcg8IguTcsU9AOcCapCCTCRPw/skBs75RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZu0TzfKO+AwVGWfmhfJ4zFSz1JEZn7V/el/y7b9UEPNTJx5VgWac43Jb7Lv/G4jv
	 tzRcVfsq7oDbMGokP3hDB5LKmaWcrDzJKy2NRab9XPUjDfATeA95D7Ne+xSDdaX4Rb
	 ZHCT885dpOkRUFfH5CU8eGvWHfVGC1pYedxLtMs6ERZHNQ48XZZ4E+zCx8HROuovWI
	 2djbq5HMlH+J+aD0z3j6mKTgQMFT0d74r3kLWytcAKUy0MQBH69zgmz6aNQ51kKARm
	 GDJRjWQCidKpKQyQBttXFSvj/W2zFkfuWInNnE145AAlwisUpzRaJUu4qCnbAZ5LLb
	 zCYJ3jx3YekGQ==
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
Subject: [PATCH v4 41/63] objtool: Add elf_create_data()
Date: Wed, 17 Sep 2025 09:03:49 -0700
Message-ID: <070460cea4fa260aefafcaee741ecffaf40097ff.1758067943.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, refactor
elf_add_string() by adding a new elf_add_data() helper which allows the
adding of arbitrary data to a section.

Make both interfaces global so they can be used by the upcoming klp diff
code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 66 ++++++++++++++++++++---------
 tools/objtool/include/objtool/elf.h | 10 +++--
 2 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 7a7e63c7153f4..117a1b5915a14 100644
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
@@ -763,8 +764,6 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	return 0;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
-
 struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 struct section *sec, unsigned int bind,
 				 unsigned int type, unsigned long offset,
@@ -1100,11 +1099,9 @@ struct elf *elf_open_read(const char *name, int flags)
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
@@ -1113,28 +1110,59 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
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
index badb10926d1e9..0d9aeefb6d124 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -135,6 +135,10 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
 struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
 					size_t size);
 
+void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
+		   size_t size);
+
+unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long offset,
@@ -148,9 +152,9 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
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
2.50.0


