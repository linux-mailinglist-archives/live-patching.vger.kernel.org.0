Return-Path: <live-patching+bounces-1552-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 163E7AEAB32
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BD8218A0006
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2745626FA59;
	Thu, 26 Jun 2025 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur76Iqqg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361526E710;
	Thu, 26 Jun 2025 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982187; cv=none; b=mOMBWKtonSQjsZqR/xl5F2DYHvkbFEq9MuR9RcTZwrWkcl6Wpkm9G7An02BwYqNuB5zR89w2/xeEk/eNKlXHMKXuhd5VUmx4w7Piy/SJuzmXj6zmZboETJA2F447QR1RQKMckqYs4D/Ua/M22Jvsvt2pVuJHcGESAP1S5JhxqNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982187; c=relaxed/simple;
	bh=MscpO23fEuPBjsKVaKB08eXZit2NRpFZ8npj2d29Vls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoAm0Tez4tGdKCoC8UhiLi4RqU5v2qoOAkt1S7AcMxywiX6+e+pgTVR1ivh8cUXRNgpz8C/Lqkb/oCbgIBerIboj8EdV0nJuQBJJZOs+g+4/4PSJnMD1j+LXk4H2gi9vUJb1VEKszUuk1DIA7qMMz97Px05oHp7verHlEyMHtgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur76Iqqg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5341BC4CEEB;
	Thu, 26 Jun 2025 23:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982186;
	bh=MscpO23fEuPBjsKVaKB08eXZit2NRpFZ8npj2d29Vls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ur76IqqgdneNXOEjmgfRojSckhK1OWn0p7CKRv1CdcjjW+cj1I9tJHK0A9vN4x0ek
	 n00DRKnxipZCN0oMxgLGEhctl8aGmlgXtEH6gRT+1ETqI/agYn6rro3lmfc0+8C1KQ
	 cWhEmUe2Nz9neNCpfDiDGGuuUfPS7mt+LaWyMsDhIgstrLVxtmVenms9deMmsEq/ck
	 fwf0Tyl7jz6pXo7g0OPdCnIrjyk0i/f2o3LS6h0Fz3B5WB7pJsejzv0+1Dhb1gE7UF
	 XDRfbAkG+ojwjg8j7rdh18aoryes2o3Iiod+74qVgH72fYrzZ0KTFI75uIz+73B2r4
	 yrgx4xj4cb5YQ==
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
Subject: [PATCH v3 22/64] objtool: Const string cleanup
Date: Thu, 26 Jun 2025 16:55:09 -0700
Message-ID: <27078775d1de24c686354d68d2061e81a69e2bb8.1750980517.git.jpoimboe@kernel.org>
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
index b10cfa9cd71e..36a65cecada3 100644
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


