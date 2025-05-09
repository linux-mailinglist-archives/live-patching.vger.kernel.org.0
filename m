Return-Path: <live-patching+bounces-1381-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE755AB1DF7
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 663981C2151D
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC52269830;
	Fri,  9 May 2025 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQ03SHtK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25526980E;
	Fri,  9 May 2025 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821880; cv=none; b=OvtuwwUTyUq5gxkCvl0ciy/OwGJtALiA0BY9ALwSArmKGukDsb10dmn4TrsJMx1f6Rk/dqvcnhUY2VuRM0XrnAQJ9K5OsC5BbVJcRp/QLMssg1cCh7fCtukaGEQPNZUDCxzLzuU/0VA0UCv+hrvh0HlArZKogmFEiFrSmI8cTOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821880; c=relaxed/simple;
	bh=6A4iq+crR8Jurs2zPxbRg8Rnbuntyd2oRV/t83dZ+Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urxwa3LN5EFC/TrdTrUMkNZZMii1uZi6SBB7vtGycJ2DSBPq5ksKPWNQVB3O4NCAsnbVMAHtJWvIEbHWYgC2pWsvSfy+8gnMBhMWbFVpuQJ2Gx1RUT3PgcWyzFwCR0HeP9fn/yBxidbcZsXwdZtFsFs+syobh73FuVBNyJHuJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQ03SHtK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C744DC4CEF1;
	Fri,  9 May 2025 20:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821879;
	bh=6A4iq+crR8Jurs2zPxbRg8Rnbuntyd2oRV/t83dZ+Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ03SHtKVVm46U+jyHySD6743IwOUXcFRYhE9cSw0E5wprG7zsw7zYtZGPUCYUaV2
	 oE+WN/yLBiJ+hwcxyJgNP39FU4N4lyExQw3Z/IpztANYWOmtoiKQvx2SYYG++e2amg
	 ISNsvk9sPdW1Qo0WmHCIsoUWjz8vngYrdweEGkP+KZS+RYAMc0EXOPmut0J3wI6uiY
	 q+R8dskfHheJajNmyTxhfGECwqv9poL4PBsfmtuXFZKW4fQUUgMAprEBgwnDaxDAAP
	 pWT29n+nEOLf1ZLHtLxQlM3ulAPAzEtcwWyM3soKkjY6Kqlkn7MXX1hWt6JaNwP8vI
	 ENiaJ0MWj0PZQ==
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
Subject: [PATCH v2 22/62] objtool: Const string cleanup
Date: Fri,  9 May 2025 13:16:46 -0700
Message-ID: <de1151fa7a5461f7a0cce722b21318541a97dd17.1746821544.git.jpoimboe@kernel.org>
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

Use 'const char *' where applicable.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c | 2 +-
 tools/objtool/arch/powerpc/decode.c   | 2 +-
 tools/objtool/arch/x86/decode.c       | 2 +-
 tools/objtool/elf.c                   | 6 +++---
 tools/objtool/include/objtool/arch.h  | 2 +-
 tools/objtool/include/objtool/elf.h   | 6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index 330671d88c59..7b38718d782a 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -7,7 +7,7 @@
 #include <linux/objtool_types.h>
 #include <arch/elf.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "_mcount");
 }
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index 9b17885e6cba..d4cb02120a6b 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -9,7 +9,7 @@
 #include <objtool/builtin.h>
 #include <objtool/endianness.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "_mcount");
 }
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 7bb8bad22b8a..cdf385e54c69 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -23,7 +23,7 @@
 #include <objtool/builtin.h>
 #include <arch/elf.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "__fentry__");
 }
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d7fb3d0b05cf..2ea6d591c3c2 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -853,7 +853,7 @@ elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str);
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct symbol *
 elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
@@ -1086,7 +1086,7 @@ struct elf *elf_open_read(const char *name, int flags)
 	return NULL;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
 	Elf_Data *data;
 	Elf_Scn *s;
@@ -1111,7 +1111,7 @@ static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
 		return -1;
 	}
 
-	data->d_buf = str;
+	data->d_buf = strdup(str);
 	data->d_size = strlen(str) + 1;
 	data->d_align = 1;
 
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index cd1776c35b13..07729a240159 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -71,7 +71,7 @@ struct stack_op {
 
 struct instruction;
 
-int arch_ftrace_match(char *name);
+int arch_ftrace_match(const char *name);
 
 void arch_initial_func_cfi_state(struct cfi_init_state *state);
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 0a2fa3ac0079..0f9adfe8e852 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -40,7 +40,7 @@ struct section {
 	struct section *base, *rsec;
 	struct symbol *sym;
 	Elf_Data *data;
-	char *name;
+	const char *name;
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
 	struct reloc *relocs;
@@ -53,7 +53,7 @@ struct symbol {
 	struct elf_hash_node name_hash;
 	GElf_Sym sym;
 	struct section *sec;
-	char *name;
+	const char *name;
 	unsigned int idx, len;
 	unsigned long offset;
 	unsigned long __subtree_last;
@@ -87,7 +87,7 @@ struct elf {
 	GElf_Ehdr ehdr;
 	int fd;
 	bool changed;
-	char *name;
+	const char *name;
 	unsigned int num_files;
 	struct list_head sections;
 	unsigned long num_relocs;
-- 
2.49.0


