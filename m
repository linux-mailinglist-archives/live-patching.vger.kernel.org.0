Return-Path: <live-patching+bounces-1555-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B05AEAB31
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CA2D4E3B63
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A417271479;
	Thu, 26 Jun 2025 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vL57/HMQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A1E26FD91;
	Thu, 26 Jun 2025 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982189; cv=none; b=Hf4u5OLSJWYyUC83T0q4KXy8O9eDEevcw24ZshX/5GE38Bl2LCvx7FK2VpPMd3iF3Af1+HmGYY3Oax/sYIAbE55rGck7xry71axz+i3vFjUml+8/uRtPpdt4EZc+ZQqoR4DLOwQr62/kXbvljLxhXRoX77F0S9rpbW5oa1Z7E1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982189; c=relaxed/simple;
	bh=U16hYH1bA4/F8v2Ymz0QRMDejwkvJtPrvMNWAf55RbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKbZYNr/+/QdEOSRScsfJa3tJ2e/M1ooaytbc5WNlIk3NCBNJXbmItqQFzHk6EF546bFxaf6NQLLTd6d2vzzjcUIznB6lIf+kxDXJoyLEJTtYCnSUTPdKDsd0ytDyVQeMmwirkB7U40qJ+U0t2icrAPblp/dE3D9j9AXyCj43VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vL57/HMQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F12C4CEEF;
	Thu, 26 Jun 2025 23:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982188;
	bh=U16hYH1bA4/F8v2Ymz0QRMDejwkvJtPrvMNWAf55RbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL57/HMQl3wVtvKVs2/yqGHwWXWzlzy7rURoZ6P+11IJ5Go7KLjAY1a9Z+y7mn4uj
	 sXwviTSL5wOtehBhAHn04sDlVxuFwBRP1pG5h3vSZZCitIOPHfTM5SG4vL56FMzYnB
	 edeKkXA6WynAWjCACnqdc9XYVOHQupzuRtyJxmcq0rVGvWKl/7L/cn3SmPoualK2Nh
	 T7L5f17KtWR0euzJm1SlzyAFGKGh/Fjc57YS0E0x0wfxjNxg4aKhBoq/1tsVNBgabW
	 ktte3gJi9W57RM8wCGsTllAEdEj1DSnDZryCnTgOGOQL2XHayNeVjncB7zkGUmY/3L
	 ZcgOdB+KQXeNw==
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
Subject: [PATCH v3 25/64] objtool: Convert elf iterator macros to use 'struct elf'
Date: Thu, 26 Jun 2025 16:55:12 -0700
Message-ID: <20cc3419a20de60a9325d2459d8fd753a5c751cb.1750980517.git.jpoimboe@kernel.org>
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

'struct objtool_file' is specific to the check code and doesn't belong
in the elf code which is supposed to be objtool_file-agnostic.  Convert
the elf iterator macros to use 'struct elf' instead.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 22 +++++++++++-----------
 tools/objtool/include/objtool/elf.h |  8 ++++----
 tools/objtool/orc_gen.c             |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 61e44b927b99..ec11fd29398b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -106,7 +106,7 @@ static struct instruction *prev_insn_same_sym(struct objtool_file *file,
 #define for_each_insn(file, insn)					\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
 	     __fake; __fake = NULL)					\
-		for_each_sec(file, __sec)				\
+		for_each_sec(file->elf, __sec)				\
 			sec_for_each_insn(file, __sec, insn)
 
 #define func_for_each_insn(file, func, insn)				\
@@ -430,7 +430,7 @@ static int decode_instructions(struct objtool_file *file)
 	unsigned long offset;
 	struct instruction *insn;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
 		u8 prev_len = 0;
 		u8 idx = 0;
@@ -856,7 +856,7 @@ static int create_cfi_sections(struct objtool_file *file)
 	}
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -872,7 +872,7 @@ static int create_cfi_sections(struct objtool_file *file)
 		return -1;
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -2144,7 +2144,7 @@ static int add_jump_table_alts(struct objtool_file *file)
 	if (!file->rodata)
 		return 0;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type != STT_FUNC)
 			continue;
 
@@ -2448,7 +2448,7 @@ static int classify_symbols(struct objtool_file *file)
 {
 	struct symbol *func;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type == STT_NOTYPE && strstarts(func->name, ".L"))
 			func->local_label = true;
 
@@ -2493,7 +2493,7 @@ static void mark_rodata(struct objtool_file *file)
 	 *
 	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
 	 */
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if ((!strncmp(sec->name, ".rodata", 7) &&
 		     !strstr(sec->name, ".str1.")) ||
 		    !strncmp(sec->name, ".data.rel.ro", 12)) {
@@ -4141,7 +4141,7 @@ static int add_prefix_symbols(struct objtool_file *file)
 	struct section *sec;
 	struct symbol *func;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
 			continue;
 
@@ -4233,7 +4233,7 @@ static int validate_functions(struct objtool_file *file)
 	struct section *sec;
 	int warnings = 0;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
 			continue;
 
@@ -4412,7 +4412,7 @@ static int validate_ibt(struct objtool_file *file)
 	for_each_insn(file, insn)
 		warnings += validate_ibt_insn(file, insn);
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 
 		/* Already done by validate_ibt_insn() */
 		if (sec->sh.sh_flags & SHF_EXECINSTR)
@@ -4573,7 +4573,7 @@ static void disas_warned_funcs(struct objtool_file *file)
 	struct symbol *sym;
 	char *funcs = NULL, *tmp;
 
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->warned) {
 			if (!funcs) {
 				funcs = malloc(strlen(sym->name) + 1);
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 0f9adfe8e852..fcea9338c687 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -324,16 +324,16 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 	reloc->_sym_next_reloc = (unsigned long)next | bit;
 }
 
-#define for_each_sec(file, sec)						\
-	list_for_each_entry(sec, &file->elf->sections, list)
+#define for_each_sec(elf, sec)						\
+	list_for_each_entry(sec, &elf->sections, list)
 
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
-#define for_each_sym(file, sym)						\
+#define for_each_sym(elf, sym)						\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
 	     __fake; __fake = NULL)					\
-		for_each_sec(file, __sec)				\
+		for_each_sec(elf, __sec)				\
 			sec_for_each_sym(__sec, sym)
 
 #define for_each_reloc(rsec, reloc)					\
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 922e6aac7cea..6eff3d6a125c 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -57,7 +57,7 @@ int orc_create(struct objtool_file *file)
 
 	/* Build a deduplicated list of ORC entries: */
 	INIT_LIST_HEAD(&orc_list);
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		struct orc_entry orc, prev_orc = {0};
 		struct instruction *insn;
 		bool empty = true;
-- 
2.49.0


