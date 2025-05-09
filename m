Return-Path: <live-patching+bounces-1414-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 978A6AB1E36
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CED39161A8D
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E87829A9EE;
	Fri,  9 May 2025 20:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFsUZOVR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E8129A9E6;
	Fri,  9 May 2025 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821904; cv=none; b=rOC8T0wGBiytRBfgIjjpmj4uA1aCSrCy6uJHQMAn999N1CVQk/2fWFzb6KJpOQvs1fYZpWvDxz1m6Lw/tZbjTxbV/jfBYKuKpVdiTKByI5AEDYyapfssz5V4asawkm3oK744NgU3cTDRm88aKqbjxXIk2FUhy23uGTYwOL6qVg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821904; c=relaxed/simple;
	bh=q9hs8SL1tf9ITX/Y15AxbLLDH2L8NCjoM7DGgCW/bxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPUUvp2IyZ11U4kE0OqWov3ovz3cCyQRel0YHmeBx0+3JBRtCVSJQyQHjkLMITVdOxb9Z89XrFvq3nt4QZG0OkjhbPj+Bm6IKw0Mz782r94eOYIGW1x+hZVMZ4m5y/CzB6qG1uJTWUK7lGcTT9uGSxhOFQwiI0SOntSUD8i9Y6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFsUZOVR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4542AC4CEEE;
	Fri,  9 May 2025 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821903;
	bh=q9hs8SL1tf9ITX/Y15AxbLLDH2L8NCjoM7DGgCW/bxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFsUZOVROaHNjJdmAoytDuzRj0fjRsDLZUgDLchBhC3DhiNjRihlYHzI7Mp7io+2b
	 XOai4pJ/7zXZ6543zaq7Mxj/s5mdnWlH9Sb56TSApkrEx/raBpInSx3qSj09f2K4il
	 EubTH+ORPw5DvyOBjvB5CfulHExHkJKLF7YNLIfYQGmSm0GgIJldtGgyN1LLP9qNNw
	 mNBp0wU9oI8aHRY8LfHmWlU21cMUPFrVOMDBbTuJfdEDUtQHvy94HVPdgwNp5bA6jo
	 e9jPQTG6/4vNC23qL/ilZBrlfTNHbNRX3Gr7L04qHE1PTD28uh1ZOdgh9WJcUREOOQ
	 99O6MOJjTl2+A==
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
Subject: [PATCH v2 55/62] objtool: Disallow duplicate prefix symbols
Date: Fri,  9 May 2025 13:17:19 -0700
Message-ID: <23e6ec37b579514e13ca33f08c6f1eaba9958d6d.1746821544.git.jpoimboe@kernel.org>
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

In preparation for adding objtool 'check' support for analyzing
livepatch modules, error out if a duplicate prefix symbol is attempted.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 12 +++++++++++-
 tools/objtool/elf.c                 |  9 +++++++++
 tools/objtool/include/objtool/elf.h |  3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 30a5eb725931..bc9bc37efa55 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4271,6 +4271,7 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
 	     prev = prev_insn_same_sec(file, prev)) {
+		struct symbol *sym_pfx;
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
@@ -4284,7 +4285,12 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 		if (offset < opts.prefix)
 			continue;
 
-		elf_create_prefix_symbol(file->elf, func, opts.prefix);
+		sym_pfx = elf_create_prefix_symbol(file->elf, func, opts.prefix);
+		if (!sym_pfx) {
+			WARN("duplicate prefix symbol for %s\n", func->name);
+			return -1;
+		}
+
 		break;
 	}
 
@@ -4320,6 +4326,10 @@ static int add_prefix_symbols(struct objtool_file *file)
 			if (!is_func_sym(func))
 				continue;
 
+			/*
+			 * Ignore this error on purpose, there are valid
+			 * reasons for this to fail.
+			 */
 			add_prefix_symbol(file, func);
 		}
 	}
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 645f7ac12869..de1d8554d979 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -946,11 +946,20 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
 	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
 	char name[SYM_NAME_LEN];
 	unsigned long offset;
+	struct symbol *sym;
 
 	snprintf(name, namelen, "__pfx_%s", orig->name);
 
+	sym = orig;
 	offset = orig->sym.st_value - size;
 
+	sec_for_each_sym_continue_reverse(orig->sec, sym) {
+		if (sym->offset < offset)
+			break;
+		if (sym->offset == offset && !strcmp(sym->name, name))
+			return NULL;
+	}
+
 	return elf_create_symbol(elf, name, orig->sec,
 				 GELF_ST_BIND(orig->sym.st_info),
 				 GELF_ST_TYPE(orig->sym.st_info),
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index f62ac8081f27..1bf9c0a1112d 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -443,6 +443,9 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
+#define sec_for_each_sym_continue_reverse(sec, sym)			\
+	list_for_each_entry_continue_reverse(sym, &sec->symbol_list, list)
+
 #define sec_prev_sym(sym)						\
 	sym->sec && sym->list.prev != &sym->sec->symbol_list ?		\
 	list_prev_entry(sym, list) : NULL
-- 
2.49.0


