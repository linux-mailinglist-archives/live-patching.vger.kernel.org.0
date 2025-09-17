Return-Path: <live-patching+bounces-1682-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0BAB80DAF
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EFC014E3582
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D046314D14;
	Wed, 17 Sep 2025 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaN887tQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DF1314D0C;
	Wed, 17 Sep 2025 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125076; cv=none; b=p13bUh+cFVvfWqz7A9UpQRLZ1FrpCJsmGU4O5haJbBsIqdpNYDn8GiHfC/FWIch85Se5XE84ykXCtCawR+Z0EJgvX7AvKGYHhlAgJ2ywoaYuVwifX3vS/wlMfRIaxN3Bh5vloZ1lxjUtQXhBMTi/DLH7+d3lRUq2O+sWxB2ToTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125076; c=relaxed/simple;
	bh=Kzm/ybXuqXssCQ+yoHHUupms5xtrFy9asAnvw1c9f24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXLkFfzRoAoILeYjhbvTekSM31fGhz8dN6PijestwKzb1vo82Tngshn1bL4pdlp9QoUta5maqeYhGUN14v2r0Q+dP2SvxZ+uLqiR6YyBiRGQGb3RCI6u34A5rDUH51yDtX/CIi0Fz+xQVeX2jqTWflXmGInG95mf5ONbJqLlsXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaN887tQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB2C4CEE7;
	Wed, 17 Sep 2025 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125075;
	bh=Kzm/ybXuqXssCQ+yoHHUupms5xtrFy9asAnvw1c9f24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaN887tQa4GLhsM4yuJ/ir1mLbWVp1d0IDwRTCGxXwiS1WBhnvV8TsStxVQ8zl7Jy
	 iLN+PH2SoXjMgVZLd90DA1UKpaacu7vtoeN6qW3t6E6kZG8fI3FMoQg+pe096BdE0J
	 FUXzA6y1p8i2lZ/K9CVGjB4SPC8AEwN6H3LhnluSveH5buk64RLY5r5JyFu7OfT7q2
	 hpeX6orTvpc3KHu1mkabPkqVLFnLzRwAdLLurrTzFIMMGmSlQ5hHhfIQEifLIuQsb7
	 UsF46CJkPZMq57Meyezvvo6Uhx2gwjEr95UGjwQkpYQQ9SX8EpU1BbcYnXZC3cuiOT
	 vh5A6E1Nwbn9g==
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
Subject: [PATCH v4 27/63] objtool: Convert elf iterator macros to use 'struct elf'
Date: Wed, 17 Sep 2025 09:03:35 -0700
Message-ID: <8c031e52d0b23d987e59488f8c0add80344c5770.1758067943.git.jpoimboe@kernel.org>
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

'struct objtool_file' is specific to the check code and doesn't belong
in the elf code which is supposed to be objtool_file-agnostic.  Convert
the elf iterator macros to use 'struct elf' instead.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 24 ++++++++++++------------
 tools/objtool/include/objtool/elf.h |  8 ++++----
 tools/objtool/orc_gen.c             |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 253d52205616a..6923be1b7cf34 100644
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
@@ -431,7 +431,7 @@ static int decode_instructions(struct objtool_file *file)
 	unsigned long offset;
 	struct instruction *insn;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
 		u8 prev_len = 0;
 		u8 idx = 0;
@@ -857,7 +857,7 @@ static int create_cfi_sections(struct objtool_file *file)
 	}
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -873,7 +873,7 @@ static int create_cfi_sections(struct objtool_file *file)
 		return -1;
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -2145,7 +2145,7 @@ static int add_jump_table_alts(struct objtool_file *file)
 	if (!file->rodata)
 		return 0;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type != STT_FUNC)
 			continue;
 
@@ -2461,7 +2461,7 @@ static int classify_symbols(struct objtool_file *file)
 {
 	struct symbol *func;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type == STT_NOTYPE && strstarts(func->name, ".L"))
 			func->local_label = true;
 
@@ -2506,7 +2506,7 @@ static void mark_rodata(struct objtool_file *file)
 	 *
 	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
 	 */
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if ((!strncmp(sec->name, ".rodata", 7) &&
 		     !strstr(sec->name, ".str1.")) ||
 		    !strncmp(sec->name, ".data.rel.ro", 12)) {
@@ -4187,7 +4187,7 @@ static int add_prefix_symbols(struct objtool_file *file)
 	struct section *sec;
 	struct symbol *func;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
 			continue;
 
@@ -4279,7 +4279,7 @@ static int validate_functions(struct objtool_file *file)
 	struct section *sec;
 	int warnings = 0;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
 			continue;
 
@@ -4458,7 +4458,7 @@ static int validate_ibt(struct objtool_file *file)
 	for_each_insn(file, insn)
 		warnings += validate_ibt_insn(file, insn);
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 
 		/* Already done by validate_ibt_insn() */
 		if (sec->sh.sh_flags & SHF_EXECINSTR)
@@ -4619,7 +4619,7 @@ static void disas_warned_funcs(struct objtool_file *file)
 	struct symbol *sym;
 	char *funcs = NULL, *tmp;
 
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->warned) {
 			if (!funcs) {
 				funcs = malloc(strlen(sym->name) + 1);
@@ -4659,7 +4659,7 @@ static int check_abs_references(struct objtool_file *file)
 	struct reloc *reloc;
 	int ret = 0;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		/* absolute references in non-loadable sections are fine */
 		if (!(sec->sh.sh_flags & SHF_ALLOC))
 			continue;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 74ce454790f4d..4d5f27b497249 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -325,16 +325,16 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
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
index 922e6aac7cea7..6eff3d6a125c2 100644
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
2.50.0


