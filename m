Return-Path: <live-patching+bounces-1686-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 488C0B80DC4
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E85A11C20D40
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A689321293;
	Wed, 17 Sep 2025 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q25cwFah"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2C32128E;
	Wed, 17 Sep 2025 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125078; cv=none; b=he0MS0lAxAXr7SiNj+ZZKLup2xgRM/9YGFH7MvlQlg5YOXH79S7+tc9ypTZHXTZPmyryDZsig/VTMdenwI1/vwT5bU1kogCYxr4Ifm4ijdojQLkP9ZUagokfjOOiP9KoUQGTQC11x7DEQWD9MoBVvTqY8etisxngGIbporyiVDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125078; c=relaxed/simple;
	bh=U74mUGlcIZiGmxDx88PewjKubjVGN+wR6J2XOkiJ5tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahMkWhLId61TPllX8121E/LEfIhG+RScRh7QGuOAZJg9JhPOghsqMGQa3cgztKnxU4cSDEP4z5vu1jtk13laMsJYBf2xygxiSDl73Z/oCqVp9bH34blT6AHwudSFALjuC/atFBLHcCSBOGPeUN34kWe6JR9yxeOTBi5nBnS2s/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q25cwFah; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BB4C4CEFB;
	Wed, 17 Sep 2025 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125078;
	bh=U74mUGlcIZiGmxDx88PewjKubjVGN+wR6J2XOkiJ5tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q25cwFahFS1a9AssZ3aWCVXOMQirCeDtykEytOwh/h4lMaMjq5Y07CSaLQMhLPglF
	 8vxGt3MsOuLolyP9GNx6XG7l7jDup/BXsjMBs2PEXrTbbw3dUlwF5LYkleV6lKBqfi
	 wtijHEGGQ3ZOxKlj99zJqykU3qawz+NgzwkqubPe0QJ7r4jVb/cyv5KMLYVZ5H/K1J
	 pyfDC0ztmoKj6zNZWMnGnDvx1wNyfb5vtPMnnIVBDe+0cTeY8UgmWx/KSIWrIxG4bb
	 T7U+sDgcB3PV94XGQLqfKu7l0EvVzyFzzYQdFrhrTl9/a4sVT9d4TrsoJY6Y1QBgUA
	 wX3WD7X+v/QYw==
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
Subject: [PATCH v4 31/63] objtool: Mark prefix functions
Date: Wed, 17 Sep 2025 09:03:39 -0700
Message-ID: <c4e61dc8954c14e80cbed9800e0d7399ae4c7289.1758067943.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, introduce a flag to
identify __pfx_*() and __cfi_*() functions in advance so they don't need
to be manually identified every time a check is needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 5 +----
 tools/objtool/elf.c                 | 7 +++++++
 tools/objtool/include/objtool/elf.h | 6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 57e3b0cde19f2..6f7ed34aea43e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3577,10 +3577,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
-			if (!strncmp(func->name, "__cfi_", 6) ||
-			    !strncmp(func->name, "__pfx_", 6) ||
-			    !strncmp(func->name, "__pi___cfi_", 11) ||
-			    !strncmp(func->name, "__pi___pfx_", 11))
+			if (is_prefix_func(func))
 				return 0;
 
 			if (file->ignore_unreachables)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 59568381486c9..775d017b1b79b 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -442,6 +442,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
+	if (is_func_sym(sym) &&
+	    (strstarts(sym->name, "__pfx_") ||
+	     strstarts(sym->name, "__cfi_") ||
+	     strstarts(sym->name, "__pi___pfx_") ||
+	     strstarts(sym->name, "__pi___cfi_")))
+		sym->prefix = 1;
+
 	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index dbadcc88a3b26..79edf82e76ddf 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -73,6 +73,7 @@ struct symbol {
 	u8 ignore	     : 1;
 	u8 nocfi             : 1;
 	u8 cold		     : 1;
+	u8 prefix	     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
@@ -230,6 +231,11 @@ static inline bool is_local_sym(struct symbol *sym)
 	return sym->bind == STB_LOCAL;
 }
 
+static inline bool is_prefix_func(struct symbol *sym)
+{
+	return sym->prefix;
+}
+
 static inline bool is_reloc_sec(struct section *sec)
 {
 	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
-- 
2.50.0


