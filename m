Return-Path: <live-patching+bounces-1569-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49871AEAB55
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 062FA5667CD
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308F6274FEA;
	Thu, 26 Jun 2025 23:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrXyQqOO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DFE274FDE;
	Thu, 26 Jun 2025 23:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982199; cv=none; b=tDNOHeajLTzyu86sAQcqpO+8hqQYQJ7WGXn7/z+kkwMllhlrStSmPSeDgyJJ4GRt7neZyB5hV3xI/57VewMN6sKo1TG/GV0NLEEBhQu2Q7XOuGTUnqaGUHlxtdbudjIAShNjyEvGtxIYK/4MnTr5TihL+ccUrtimuRWhInAWoNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982199; c=relaxed/simple;
	bh=YFjpIuy+cdDolJGfH6auTZuPlPXQPBgN7+Za6i/GtdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+iXsbOyNmc/664v5TsgWXFVS1xrGTg+Ucf0Tbvw2fEZiY6Mv4dOPrx+BV6xVqe0kYo6Ilit2KVuTVt+fl6f8qvwYzbJChyscnZUTUhkqWWkhiofz2NuegwNZHuqotB0Y5uqSZIrOPxIg4qPpJH+7D1zPoN/2uS7FsYnHR8WtdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrXyQqOO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6F8C4CEEF;
	Thu, 26 Jun 2025 23:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982198;
	bh=YFjpIuy+cdDolJGfH6auTZuPlPXQPBgN7+Za6i/GtdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrXyQqOO59nfM6h2xq56JzN3TKWesc1RMqwiFby6lPGv+xEgRtFJhWeQeyvjSgCl6
	 rYZdXjbmmxy77vdhhw9iM+OWD0gVADz7abQkr5Yc/JBKD+rkfhK/3KRXmEHkg8hlQ+
	 4Jnq3aqOBOLnt2EV7E2ZsvTUw+MVrJUsTGfBl66838zDMtZTMzp77dgcjX0VZfQh8p
	 J29RhSh1roNXeW4oMC8PWUqcnpmALObQ6+ijhBf8/2jioqj+cTDqOnIZKMzFvPfDQt
	 Wk4tJoyPG/EBHgnXhdaKFTHdU8C4n23a9xyrdRBR5AFuvKM/hmE8pNZQaziKTwSrNo
	 Yz2IYd3AB59xw==
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
Subject: [PATCH v3 39/64] objtool: Add elf_create_data()
Date: Thu, 26 Jun 2025 16:55:26 -0700
Message-ID: <d758b2e764764060977ba216cdd85bbb454f8eb3.1750980517.git.jpoimboe@kernel.org>
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
index 4f56ea426683..535bdcf077d0 100644
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
@@ -760,8 +761,6 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	return 0;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
-
 struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 struct section *sec, unsigned int bind,
 				 unsigned int type, unsigned long offset,
@@ -1097,11 +1096,9 @@ struct elf *elf_open_read(const char *name, int flags)
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
@@ -1110,28 +1107,59 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
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


