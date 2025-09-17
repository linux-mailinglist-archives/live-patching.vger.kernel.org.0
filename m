Return-Path: <live-patching+bounces-1710-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 245B3B80EBB
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59991322F05
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B47343450;
	Wed, 17 Sep 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4BrxalD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B6343448;
	Wed, 17 Sep 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125095; cv=none; b=usj2MBfOiRWQbAR2xma+lrXcvdLOOKFQEOAra62Oiak6nlTcy+zptaBNNc1B6dmN5OyWRnhYhNl7+v/dtBfrbeDa9zsj25ZhDy2LOy0IepyqRcFT3uj/CaLT0oH7KtvTvXS8yF2yKespABt1PS5VJ/TpjBvxmq0i1BqOTIoF3MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125095; c=relaxed/simple;
	bh=ti4BUkcOz5eG2WKiIHMgQ2PdZtOp+xgFxkbmZUuXw8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VW2FfSgh3dgyCZn3Fnm4aqNvQbxTBGr1VEDhNJPbrLJWFPKb/LXPHg1zVJnD/6KzBBguThhq2bRRU5mVv8m4zmMhjsgsPMOi0h+gMenMZtJjaWyzhYgdkmlot+GUBXezkGdxS5aF4WcGPCGOfuL7TimTnr0gew8sUb4XasnBvuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4BrxalD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E94C4CEE7;
	Wed, 17 Sep 2025 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125095;
	bh=ti4BUkcOz5eG2WKiIHMgQ2PdZtOp+xgFxkbmZUuXw8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4BrxalDGausEpWXJ0GUlXPFTTq8048VYyQAKzLZlegINkB4NPr51YJUNd6a6OLaD
	 vme5kohZ9wIFJaI3Ap1KX+VILHSVxewXN6ONxJkMo70kyJ/osIMZZBapk0gPgT96qe
	 iu1mzK77FEclkT37zgFPmCYEH7lQysGR86/DfGqAJFyppm3tOKjUSGM/Jox0mgkIK5
	 ahuWqW5SX77hFpgz5Vz+OZb0OUsiAYMC8o57TDJjYl4R/H3DhvcOQyItiYt1osBAr1
	 Arz49B6Tauyfgj4zAlgGPjXfjBLi8hwB2WKM2KbljtnrRbCb7aNEbLeRvq0i3/ke4v
	 G684lmZAresxg==
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
Subject: [PATCH v4 55/63] objtool: Add base objtool support for livepatch modules
Date: Wed, 17 Sep 2025 09:04:03 -0700
Message-ID: <d37f13f23cf17f20a21d4012c577dc440b747122.1758067943.git.jpoimboe@kernel.org>
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
 tools/objtool/check.c                   | 52 ++++++++++++++++++++++---
 tools/objtool/elf.c                     |  5 ++-
 tools/objtool/include/objtool/elf.h     |  1 +
 tools/objtool/include/objtool/objtool.h |  2 +-
 4 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6a9ce090a2cde..ba591a325d52e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
  */
 
+#define _GNU_SOURCE /* memmem() */
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
@@ -611,6 +612,20 @@ static int init_pv_ops(struct objtool_file *file)
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
@@ -622,7 +637,14 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
-		WARN("file already has .static_call_sites section, skipping");
+		/*
+		 * Livepatch modules may have already extracted the static call
+		 * site entries to take advantage of vmlinux static call
+		 * privileges.
+		 */
+		if (!file->klp)
+			WARN("file already has .static_call_sites section, skipping");
+
 		return 0;
 	}
 
@@ -666,7 +688,7 @@ static int create_static_call_sections(struct objtool_file *file)
 
 		key_sym = find_symbol_by_name(file->elf, tmp);
 		if (!key_sym) {
-			if (!opts.module) {
+			if (!opts.module || file->klp) {
 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
 				return -1;
 			}
@@ -885,7 +907,13 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, "__mcount_loc");
 	if (sec) {
-		WARN("file already has __mcount_loc section, skipping");
+		/*
+		 * Livepatch modules have already extracted their __mcount_loc
+		 * entries to cover the !CONFIG_FTRACE_MCOUNT_USE_OBJTOOL case.
+		 */
+		if (!file->klp)
+			WARN("file already has __mcount_loc section, skipping");
+
 		return 0;
 	}
 
@@ -2579,6 +2607,8 @@ static bool validate_branch_enabled(void)
 
 static int decode_sections(struct objtool_file *file)
 {
+	file->klp = is_livepatch_module(file);
+
 	mark_rodata(file);
 
 	if (init_pv_ops(file))
@@ -4254,6 +4284,9 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
  *   - compiler cloned functions (*.cold, *.part0, etc)
  *   - asm functions created with inline asm or without SYM_FUNC_START()
  *
+ * Also, the function may already have a prefix from a previous objtool run
+ * (livepatch extracted functions, or manually running objtool multiple times).
+ *
  * So return 0 if the NOPs are missing or the function already has a prefix
  * symbol.
  */
@@ -4276,6 +4309,14 @@ static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	if (snprintf_check(name, SYM_NAME_LEN, "__pfx_%s", func->name))
 		return -1;
 
+	if (file->klp) {
+		struct symbol *pfx;
+
+		pfx = find_symbol_by_offset(func->sec, func->offset - opts.prefix);
+		if (pfx && is_prefix_func(pfx) && !strcmp(pfx->name, name))
+			return 0;
+	}
+
 	insn = find_insn(file, func->sec, func->offset);
 	if (!insn) {
 		WARN("%s: can't find starting instruction", func->name);
@@ -4628,6 +4669,7 @@ static int validate_ibt(struct objtool_file *file)
 		    !strncmp(sec->name, ".debug", 6)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
+		    !strcmp(sec->name, ".kcfi_traps")			||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
@@ -4637,12 +4679,12 @@ static int validate_ibt(struct objtool_file *file)
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
index 4bb7ce994b6a7..5feeefc7fc8f8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -499,7 +499,10 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 	     strstarts(sym->name, "__pi___cfi_")))
 		sym->prefix = 1;
 
-	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
+	if (strstarts(sym->name, ".klp.sym"))
+		sym->klp = 1;
+
+	if (!sym->klp && is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 60f844e43c5a2..21d8b825fd8f0 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -88,6 +88,7 @@ struct symbol {
 	u8 debug_checksum    : 1;
 	u8 changed	     : 1;
 	u8 included	     : 1;
+	u8 klp		     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 7f70b41d1b8db..f7051bbe0bcb2 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -28,7 +28,7 @@ struct objtool_file {
 	struct list_head mcount_loc_list;
 	struct list_head endbr_list;
 	struct list_head call_list;
-	bool ignore_unreachables, hints, rodata;
+	bool ignore_unreachables, hints, rodata, klp;
 
 	unsigned int nr_endbr;
 	unsigned int nr_endbr_int;
-- 
2.50.0


