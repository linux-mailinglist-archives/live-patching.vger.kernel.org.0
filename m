Return-Path: <live-patching+bounces-1415-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0605AB1E3A
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEA99A01216
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F03429A9D3;
	Fri,  9 May 2025 20:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZIBN9zH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241BC29AAEB;
	Fri,  9 May 2025 20:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821905; cv=none; b=AqFaYdLWxG52zJixBiNOYhyv24urBwAUdvfv5/wro9IOw2W9jiiEMy7i8WiUdHUH1sC1snE7nn+RD2KV8m07HH+AVtCigekJUsV8vogNoyF7k2djDcluryX3lEL49zrxVErKZjn5Zwer2ccZPmhsQu4A02dAhlxhhtEDtncaZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821905; c=relaxed/simple;
	bh=iNTRpBq9KLho7r5MiQ2IzJKM2/5WdHdwn8puwfQIvvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo0+azVvShsefftoDUd6MddjELZ2nnkiuwRLAdWVgqzeBRpGZuh1Cl2Vb8JN8+bchpr9eUrXmr8hxaAXNeTsoF0KVyf0884PETb178XUkQGfshBY5BN4zeB9Nz7xxv1e7R7lM7RpC1e2BZ1zHAW++N148vb4Rn73oebutDxuZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZIBN9zH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3448C4CEE9;
	Fri,  9 May 2025 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821904;
	bh=iNTRpBq9KLho7r5MiQ2IzJKM2/5WdHdwn8puwfQIvvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZIBN9zHCJe+uAanE2vUybr8PO2kYEt3PY82bWKVr8+Q5ezTxInme/a8NXhHp/yY8
	 8hRjfmorYsAgdLSwdsY3VZBURwmNu0uP01WwCeZFLhLZVap0m/L3wDEv1EXuQzgoQl
	 vTvGRv+TSMmrPOC4M3O+Gyp6i+pbRct8mPjiSaL5V/8Z16j7mVmQh0grzFbpO/fEF7
	 QaB0R9wyKDO9iZGbYYNBrEFDjmw26BhuCQjfR59M11/oYXZnsq3cAa63t6mmjzqR2Z
	 2PdT/Rpw/6t0h1UXczu5m4gOPVqa0OhzzZOlHXscJAuP2Im7+FwXaVuufsQMkAO1TK
	 PA6GASwBMi6ow==
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
Subject: [PATCH v2 56/62] objtool: Add base objtool support for livepatch modules
Date: Fri,  9 May 2025 13:17:20 -0700
Message-ID: <ed05aca9028fa80d9f48ee88ebb80dc90c6a4194.1746821544.git.jpoimboe@kernel.org>
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

In preparation for klp-build, enable "classic" objtool to work on
livepatch modules:

  - Avoid duplicate symbol/section warnings for prefix symbols and the
    .static_call_sites and __mcount_loc sections which may have already
    been extracted by klp diff.

  - Add __klp_funcs to the IBT function pointer section whitelist.

  - Prevent KLP symbols from getting incorrectly classified as cold
    subfunctions.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                   | 44 +++++++++++++++++++++----
 tools/objtool/elf.c                     |  4 ++-
 tools/objtool/include/objtool/elf.h     |  1 +
 tools/objtool/include/objtool/objtool.h |  2 +-
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index bc9bc37efa55..5bd1b8d000bd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
  */
 
+#define _GNU_SOURCE /* memmem() */
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
@@ -627,6 +628,20 @@ static int init_pv_ops(struct objtool_file *file)
 	return 0;
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
+	return memmem(sec->data->d_buf, sec_size(sec), "\0livepatch=Y", 12);
+}
+
 static int create_static_call_sections(struct objtool_file *file)
 {
 	struct static_call_site *site;
@@ -638,7 +653,12 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
-		if (!opts.dryrun)
+		/*
+		 * Livepatch modules may have already extracted the static call
+		 * site entries to take advantage of vmlinux static call
+		 * privileges.
+		 */
+		if (!!opts.dryrun || !file->klp)
 			WARN("file already has .static_call_sites section, skipping");
 
 		return 0;
@@ -684,7 +704,7 @@ static int create_static_call_sections(struct objtool_file *file)
 
 		key_sym = find_symbol_by_name(file->elf, tmp);
 		if (!key_sym) {
-			if (!opts.module) {
+			if (!opts.module || file->klp) {
 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
 				return -1;
 			}
@@ -911,7 +931,11 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, "__mcount_loc");
 	if (sec) {
-		if (!opts.dryrun)
+		/*
+		 * Livepatch modules have already extracted their __mcount_loc
+		 * entries to cover the !CONFIG_FTRACE_MCOUNT_USE_OBJTOOL case.
+		 */
+		if (!opts.dryrun && !file->klp)
 			WARN("file already has __mcount_loc section, skipping");
 
 		return 0;
@@ -2612,6 +2636,8 @@ static int decode_sections(struct objtool_file *file)
 {
 	int ret;
 
+	file->klp = is_livepatch_module(file);
+
 	mark_rodata(file);
 
 	ret = init_pv_ops(file);
@@ -4285,8 +4311,13 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 		if (offset < opts.prefix)
 			continue;
 
+		/*
+		 * Ignore attempts to make duplicate symbols in livepatch
+		 * modules.  They've already extracted the prefix symbols
+		 * except for the newly compiled init.c.
+		 */
 		sym_pfx = elf_create_prefix_symbol(file->elf, func, opts.prefix);
-		if (!sym_pfx) {
+		if (!sym_pfx && !file->klp) {
 			WARN("duplicate prefix symbol for %s\n", func->name);
 			return -1;
 		}
@@ -4621,6 +4652,7 @@ static int validate_ibt(struct objtool_file *file)
 		    !strncmp(sec->name, ".debug", 6)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
+		    !strcmp(sec->name, ".kcfi_traps")			||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
@@ -4630,12 +4662,12 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, "__bug_table")			||
 		    !strcmp(sec->name, "__ex_table")			||
 		    !strcmp(sec->name, "__jump_table")			||
+		    !strcmp(sec->name, "__klp_funcs")			||
 		    !strcmp(sec->name, "__mcount_loc")			||
-		    !strcmp(sec->name, ".kcfi_traps")			||
 		    !strcmp(sec->name, ".llvm.call-graph-profile")	||
 		    !strcmp(sec->name, ".llvm_bb_addr_map")		||
 		    !strcmp(sec->name, "__tracepoints")			||
-		    strstr(sec->name, "__patchable_function_entries"))
+		    !strcmp(sec->name, "__patchable_function_entries"))
 			continue;
 
 		for_each_reloc(sec->rsec, reloc)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index de1d8554d979..ae1c852ff8d8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -496,8 +496,10 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 	    (strstarts(sym->name, "__pfx") || strstarts(sym->name, "__cfi_")))
 		sym->prefix = 1;
 
+	if (strstarts(sym->name, ".klp.sym"))
+		sym->klp = 1;
 
-	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
+	if (!sym->klp && is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 1bf9c0a1112d..adfe508f96f5 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -84,6 +84,7 @@ struct symbol {
 	u8 debug_checksum    : 1;
 	u8 changed	     : 1;
 	u8 included	     : 1;
+	u8 klp		     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 37e9fe4492d6..731965a742e9 100644
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
-- 
2.49.0


