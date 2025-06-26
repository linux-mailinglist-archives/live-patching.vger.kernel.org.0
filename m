Return-Path: <live-patching+bounces-1585-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA257AEAB70
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB843189A474
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB02292B4E;
	Thu, 26 Jun 2025 23:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIKYamDH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B1292B3C;
	Thu, 26 Jun 2025 23:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982210; cv=none; b=m8JWxvoeByJeFKZqu+sOQGiy5LtIoK10vl3vQSEUDzXTnfSfKeMlTAAXIv3ePTiGw8/k6+AbOs83cvxtyhGZiOYxq8ZpHJV7D1YDK2osJLzSvt2QTgi+Y+7SL2c4NJVnrdP/EyZX8xm3WZKIudyS/WORqErRyviwV9t00zdwUwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982210; c=relaxed/simple;
	bh=/xGi9COk+ZnVu46zgiRD2b7IH7osphec+CjhQcPjHEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAE8IwNQSESourNyFH7yVirStsLHtW0aUvx9KQCqrIl9s1/Xp5r0wW8mZuck5xR0t/jZQX3hewa7pq37rfby2wpw/L9PvSR4EcdA7Y0Ftw6POC/oYfU7QUFDsYGJDXSbd7dklI/cVDGgVTJUJL87XGv2QGGw5O86YQBKlVBnWjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIKYamDH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F0BC4CEF1;
	Thu, 26 Jun 2025 23:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982210;
	bh=/xGi9COk+ZnVu46zgiRD2b7IH7osphec+CjhQcPjHEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIKYamDH4yCCLz3AlCt38aq/jCOrLsmOITMaRszmUW9n5rdtMQmx4tg1Zxsqpqncj
	 II8V7xS8zplL8ZCBZOcjycr3UxSkWoKsfZKivK/AoNarOXV73dGXGmKdLW1wXFG/V4
	 5kxFssFfMESKSs4WUiC5sJ2HXMck7e9V1iuziLLuBTUz5YEUAyeGA+2FCNtBlRk2LV
	 KcBtHkVL+UqBuC6hMj9LmiSz4ZlIijG7fX0L9enUQcWNDIPHfy0jC5jXAF49dP0R6J
	 qBFzwHm9+jHX8EF64mf38kmOC7uCKf8l3C2RFcvcBB7cLQ7gSJTLZ7rLh6pcEaixai
	 LldYXVHtdnqCw==
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
Subject: [PATCH v3 55/64] objtool: Disallow duplicate prefix symbols
Date: Thu, 26 Jun 2025 16:55:42 -0700
Message-ID: <4173bb38e7e056d7aa64bae2885b4f710aca9125.1750980517.git.jpoimboe@kernel.org>
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

In preparation for adding objtool 'check' support for analyzing
livepatch modules, error out if a duplicate prefix symbol is attempted.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 12 +++++++++++-
 tools/objtool/elf.c                 |  9 +++++++++
 tools/objtool/include/objtool/elf.h |  3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9d1f545279a6..c6c99e3fb76f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4221,6 +4221,7 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
 	     prev = prev_insn_same_sec(file, prev)) {
+		struct symbol *sym_pfx;
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
@@ -4234,7 +4235,12 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
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
 
@@ -4270,6 +4276,10 @@ static int add_prefix_symbols(struct objtool_file *file)
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
index 16c8d36afe4e..383183e9cf2d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -945,11 +945,20 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
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
index 903cbcb84e6b..c2a744afd5d5 100644
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


