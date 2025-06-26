Return-Path: <live-patching+bounces-1586-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D086AEAB75
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7FF14A1C77
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93689293C4C;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qT1bGcem"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681F8235C17;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982211; cv=none; b=EqTIf8ibMAAaqI4WLaHwEnKgSfonmmqAA5SIJGuGLasNVWn5EL5SfK1t3NUbL8cNxP/uA1pYy68XAbLqucQwTKO1KtuogjrVpHPzBWskpmYGYJ/iwjN/rNI8z0176yBi0JTOOFQtKgFOI7aDEGuqnqK5G6mk1Z81ud3K6ZaIMnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982211; c=relaxed/simple;
	bh=VXqwGELhvBppXS9Y+OxD5QQxGhtLxEoBSvtvok1uXGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV9eRa3L2X9XS6qxCxgQftoLHUmn8deMYZ6cx+d+OFZhQJ6pJDSdDF/EeH29FEmNNJcH5rT7FRiX7YTO3Pru2bw0ONbsETnw49UW8rilhAWg3p/xtY/va09Y8MoOrgOPWNyZwoEr8GbPmOYN3oDgxw1hExZ+okH0ZPT/9odEQxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qT1bGcem; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BA4C4CEEF;
	Thu, 26 Jun 2025 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982210;
	bh=VXqwGELhvBppXS9Y+OxD5QQxGhtLxEoBSvtvok1uXGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT1bGcem2MtfnMm9my/N6Fl/CQ5+ysGv2qlaOkHZhNGN+r2ji8zpMZ2uWroEU9OeX
	 RKMAPN/ek5gk3q/HGhuAjKEX5D0qOwzCuPLiGvC4B3ChYOKzXZZHxXbpzUNy82z5my
	 DHddDeYaZxSfA5S9zbHMnar/vI/wRjliLg0P9suHS5M3wAhMgqQVWQyxF9bqIDmgoW
	 hAk5xSTb2rqkN+PUXFLYs4tLFsP6i+Ng8lyuuv4ZjguzctYKBRkkLvExGH9/OtAgNn
	 xESJwqqLKynAfgU0SSLduvwG7yWN6BTbiAHUGvlWR9O6TR3BV6Ku2Ww7iaezuacI6g
	 tTK+NXEwqX+wA==
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
Subject: [PATCH v3 56/64] objtool: Add base objtool support for livepatch modules
Date: Thu, 26 Jun 2025 16:55:43 -0700
Message-ID: <55fe04b73123ef5029beeabebf14028d153467a1.1750980517.git.jpoimboe@kernel.org>
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
 tools/objtool/check.c                   | 48 +++++++++++++++++++++----
 tools/objtool/elf.c                     |  5 ++-
 tools/objtool/include/objtool/elf.h     |  1 +
 tools/objtool/include/objtool/objtool.h |  2 +-
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c6c99e3fb76f..1eb6489ae459 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
  */
 
+#define _GNU_SOURCE /* memmem() */
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
@@ -610,6 +611,20 @@ static int init_pv_ops(struct objtool_file *file)
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
@@ -621,7 +636,14 @@ static int create_static_call_sections(struct objtool_file *file)
 
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
 
@@ -672,7 +694,7 @@ static int create_static_call_sections(struct objtool_file *file)
 
 		key_sym = find_symbol_by_name(file->elf, tmp);
 		if (!key_sym) {
-			if (!opts.module) {
+			if (!opts.module || file->klp) {
 				ERROR("static_call: can't find static_call_key symbol: %s", tmp);
 				return -1;
 			}
@@ -891,7 +913,13 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
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
 
@@ -2575,6 +2603,8 @@ static bool validate_branch_enabled(void)
 
 static int decode_sections(struct objtool_file *file)
 {
+	file->klp = is_livepatch_module(file);
+
 	mark_rodata(file);
 
 	if (init_pv_ops(file))
@@ -4235,8 +4265,13 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
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
@@ -4571,6 +4606,7 @@ static int validate_ibt(struct objtool_file *file)
 		    !strncmp(sec->name, ".debug", 6)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
+		    !strcmp(sec->name, ".kcfi_traps")			||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
@@ -4580,12 +4616,12 @@ static int validate_ibt(struct objtool_file *file)
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
index 383183e9cf2d..f9eed5d50de5 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -496,7 +496,10 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 	    (strstarts(sym->name, "__pfx_") || strstarts(sym->name, "__cfi_")))
 		sym->prefix = 1;
 
-	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
+	if (strstarts(sym->name, ".klp.sym"))
+		sym->klp = 1;
+
+	if (!sym->klp && is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index c2a744afd5d5..1212f81f40e0 100644
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


