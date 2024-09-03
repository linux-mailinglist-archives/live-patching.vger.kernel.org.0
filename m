Return-Path: <live-patching+bounces-544-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA5096927C
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D551A2833F2
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738B61D0482;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF0Kp2+/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5C71CFED2;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336034; cv=none; b=UkjE8SBPwAy34RQf8OFQws1DhAhpzboRustniazYJ7UOMrIltYzV5ofljUY4vnH69GrvX1ilUqmRPHlvPBxTGs/aWCX4IeIg9ue0biwerCx5i4wCrXToDTzydh3cofFce9CT6BlZX3RpdCoXNXKPc3huiRedQTMFqHktGh0TDJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336034; c=relaxed/simple;
	bh=9dCrDC0dI0bCabg/XMOLC9FAJQvbJGfs6BK4o9Tsleo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtHFHbmuRAS9DZm3pKqaCZ81iNr0FRrHNg0izhBccea4sOxiinWsEHL3R5wCHdgP6Pi9z5tMc4fSUqV7KFBkHDJRBWG4NZppF8wWZoFzoKZ03GDug/Zcz4Y8QZmZhn4+cfYRushlFai02Irhhrn6TiTwicsGSkWZeXT0oKw4bS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF0Kp2+/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9135C4CECA;
	Tue,  3 Sep 2024 04:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336034;
	bh=9dCrDC0dI0bCabg/XMOLC9FAJQvbJGfs6BK4o9Tsleo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aF0Kp2+/G7I1VUa+hQVsLmLjc2DnkozVD1qomYO2Wk+DAUVM3T0naSgQavELeSTzt
	 CM9OLiAFtg7ryc8qyeuYuoQxNFp/srOhGTPikmxdySORRzeAd+lYNGaQtpYb+PeCpW
	 zNv0G6rkKXpHtsv2lnrSjrV8P1N4QZyqUgcYO63riVGcdsnM956P4q6JD44ErGxgTF
	 JQD4kpWqupqgaCWUvzVzSx1UKurCB8lqgZDkgjT+e06FKBcLakfyGi3svhGYLoZ2Fs
	 dcNX0c9x6Ji8IY14Qc4KWgfYasQDmvcqaqNMkZkOLgzQCTLr2ibxddaNWHGY6WFOD7
	 NLPsUehmFHYCQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 10/31] objtool: Use 'struct elf' in elf macros
Date: Mon,  2 Sep 2024 20:59:53 -0700
Message-ID: <d9eb524fc9c0f35356d956ce5a2cea4cd8e8714e.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct objtool_file' is specific to the check code and doesn't belong
in the elf code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 22 +++++++++++-----------
 tools/objtool/include/objtool/elf.h |  8 ++++----
 tools/objtool/orc_gen.c             |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index a813a6194c61..06e7b3f5481d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -107,7 +107,7 @@ static struct instruction *prev_insn_same_sym(struct objtool_file *file,
 #define for_each_insn(file, insn)					\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
 	     __fake; __fake = NULL)					\
-		for_each_sec(file, __sec)				\
+		for_each_sec(file->elf, __sec)				\
 			sec_for_each_insn(file, __sec, insn)
 
 #define func_for_each_insn(file, func, insn)				\
@@ -374,7 +374,7 @@ static int decode_instructions(struct objtool_file *file)
 	struct instruction *insn;
 	int ret;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
 		u8 prev_len = 0;
 		u8 idx = 0;
@@ -899,7 +899,7 @@ static int create_cfi_sections(struct objtool_file *file)
 	}
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -915,7 +915,7 @@ static int create_cfi_sections(struct objtool_file *file)
 		return -1;
 
 	idx = 0;
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->type != STT_FUNC)
 			continue;
 
@@ -2198,7 +2198,7 @@ static int add_jump_table_alts(struct objtool_file *file)
 	if (!file->rodata)
 		return 0;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type != STT_FUNC)
 			continue;
 
@@ -2534,7 +2534,7 @@ static int classify_symbols(struct objtool_file *file)
 {
 	struct symbol *func;
 
-	for_each_sym(file, func) {
+	for_each_sym(file->elf, func) {
 		if (func->type == STT_NOTYPE && strstarts(func->name, ".L"))
 			func->local_label = true;
 
@@ -2579,7 +2579,7 @@ static void mark_rodata(struct objtool_file *file)
 	 *
 	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
 	 */
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!strncmp(sec->name, ".rodata", 7) &&
 		    !strstr(sec->name, ".str1.")) {
 			sec->rodata = true;
@@ -4198,7 +4198,7 @@ static int add_prefix_symbols(struct objtool_file *file)
 	struct section *sec;
 	struct symbol *func;
 
-	for_each_sec(file, sec) {
+	for_each_sec(file->elf, sec) {
 		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
 			continue;
 
@@ -4289,7 +4289,7 @@ static int validate_functions(struct objtool_file *file)
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
@@ -4645,7 +4645,7 @@ static int disas_warned_funcs(struct objtool_file *file)
 	struct symbol *sym;
 	char *funcs = NULL, *tmp;
 
-	for_each_sym(file, sym) {
+	for_each_sym(file->elf, sym) {
 		if (sym->warned) {
 			if (!funcs) {
 				funcs = malloc(strlen(sym->name) + 1);
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index a027fc34d605..7524510b5565 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -296,16 +296,16 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 	mark_sec_changed(elf, reloc->sec, true);
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
2.45.2


