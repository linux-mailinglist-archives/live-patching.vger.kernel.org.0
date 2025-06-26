Return-Path: <live-patching+bounces-1581-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97503AEAB6F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D18523B9FFC
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35EB28FFE1;
	Thu, 26 Jun 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEjx/U7X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23128FFCD;
	Thu, 26 Jun 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982207; cv=none; b=BpUwRmKltROBw4pNNai0HnoGjVcMa/z2+th/3gxq15UaKESoyJ60R9Fw/5BrxFh3oq1fOJgjWj1LGT7NRwy68qluxJU1spftrcls5M8vIm8yPBgnlONBdqIyYi2NybNO/ea5vUm9IPrhggLgutln1hs7CzN3nL5mTiHXzj8gggg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982207; c=relaxed/simple;
	bh=iAB4PmF8Ue1UmbFWEwdpFocIyqIX3gtRI0157QGOb28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXeG9N2B3cLWPlb6X8NS4gFifoDpPN4Nahonhn2/uA77CwmQapE10pI6JYBCjiSXcjmaVlz8+5lR1pra5ZT+jGbkfRZKQYaC6zVoT/Rfzz+58V2rs6aeHldPDCHjIVRxe/6AL3bY2/J92ZBRSkHkVoGTIdU3wP4NkFeQ9yGTmGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEjx/U7X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B09C4CEEF;
	Thu, 26 Jun 2025 23:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982207;
	bh=iAB4PmF8Ue1UmbFWEwdpFocIyqIX3gtRI0157QGOb28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEjx/U7XDGAionvACIIk01ObVtK3qZeIw0XcNVCs1qSMxqmk5uuP/rg1JWi7uUMpk
	 U7oqwX70ydanM/Rf3YWksnlivMC0RdFmjKpWWW674PEA+vQjkpw+cayFGfowoRXbxm
	 8VNqfbD/vll3UTMDIY+Y9jWZcJhW+pM5SDnsFNVXH39/S14hRUojV+1oQs7x1v8YuH
	 thbmWJVZL+WhIfANqqmzN7Yl2H00vYx8OdrnyvQ/4RKmT9cAXAtLu5e6wjQcnAWEwF
	 PdNcStF8cH/XdlFELqkXCzXALOyGQLrew5cYq9UwPinjmutD3LAMPq9QElV7fTcJj+
	 eYCHbXSl0VL4g==
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
Subject: [PATCH v3 51/64] objtool/klp: Add --debug-checksum=<funcs> to show per-instruction checksums
Date: Thu, 26 Jun 2025 16:55:38 -0700
Message-ID: <545d32e05f6c2634a6fc854ca6246d602f09768a.1750980517.git.jpoimboe@kernel.org>
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

Add a --debug-checksum=<funcs> option to the check subcommand to print
the calculated checksum of each instruction in the given functions.

This is useful for determining where two versions of a function begin to
diverge.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/builtin-check.c            |  6 ++++
 tools/objtool/check.c                    | 42 ++++++++++++++++++++++++
 tools/objtool/include/objtool/builtin.h  |  1 +
 tools/objtool/include/objtool/checksum.h |  1 +
 tools/objtool/include/objtool/elf.h      |  1 +
 tools/objtool/include/objtool/warn.h     | 19 +++++++++++
 6 files changed, 70 insertions(+)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 331c6e1dc04c..cd2c4a387100 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -93,6 +93,7 @@ static const struct option check_options[] = {
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
 	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
+	OPT_STRING(0,		 "debug-checksum", &opts.debug_checksum,  "funcs", "enable checksum debug output"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,		 "link", &opts.link, "object is a linked object"),
 	OPT_BOOLEAN(0,		 "module", &opts.module, "object is part of a kernel module"),
@@ -168,6 +169,11 @@ static bool opts_valid(void)
 	}
 #endif
 
+	if (opts.debug_checksum && !opts.checksum) {
+		ERROR("--debug-checksum requires --checksum");
+		return false;
+	}
+
 	if (opts.checksum		||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index fd7e470f01bd..7e492945e5e5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3587,6 +3587,44 @@ static bool skip_alt_group(struct instruction *insn)
 	return alt_insn->type == INSN_CLAC || alt_insn->type == INSN_STAC;
 }
 
+static int checksum_debug_init(struct objtool_file *file)
+{
+	char *dup, *s;
+
+	if (!opts.debug_checksum)
+		return 0;
+
+	dup = strdup(opts.debug_checksum);
+	if (!dup) {
+		ERROR_GLIBC("strdup");
+		return -1;
+	}
+
+	s = dup;
+	while (*s) {
+		struct symbol *func;
+		char *comma;
+
+		comma = strchr(s, ',');
+		if (comma)
+			*comma = '\0';
+
+		func = find_symbol_by_name(file->elf, s);
+		if (!func || !is_func_sym(func))
+			WARN("--debug-checksum: can't find '%s'", s);
+		else
+			func->debug_checksum = 1;
+
+		if (!comma)
+			break;
+
+		s = comma + 1;
+	}
+
+	free(dup);
+	return 0;
+}
+
 static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
@@ -4753,6 +4791,10 @@ int check(struct objtool_file *file)
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
 
+	ret = checksum_debug_init(file);
+	if (ret)
+		goto out;
+
 	ret = decode_sections(file);
 	if (ret)
 		goto out;
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 06083e8c5c91..92bc7089cfc1 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -31,6 +31,7 @@ struct opts {
 	/* options: */
 	bool backtrace;
 	bool backup;
+	const char *debug_checksum;
 	bool dryrun;
 	bool link;
 	bool mnop;
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 927ca74b5c39..7fe21608722a 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -19,6 +19,7 @@ static inline void checksum_update(struct symbol *func,
 				   const void *data, size_t size)
 {
 	XXH3_64bits_update(func->csum.state, data, size);
+	dbg_checksum(func, insn, XXH3_64bits_digest(func->csum.state));
 }
 
 static inline void checksum_finish(struct symbol *func)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 4d1023fdb700..4cfd09e66cb5 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -78,6 +78,7 @@ struct symbol {
 	u8 ignore	     : 1;
 	u8 cold		     : 1;
 	u8 prefix	     : 1;
+	u8 debug_checksum    : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index cb8fe846d9dd..29173a1368d7 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -102,4 +102,23 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define ERROR_FUNC(sec, offset, format, ...) __WARN_FUNC(ERROR_STR, sec, offset, format, ##__VA_ARGS__)
 #define ERROR_INSN(insn, format, ...) WARN_FUNC(insn->sec, insn->offset, format, ##__VA_ARGS__)
 
+
+#define __dbg(format, ...)						\
+	fprintf(stderr,							\
+		"DEBUG: %s%s" format "\n",				\
+		objname ?: "",						\
+		objname ? ": " : "",					\
+		##__VA_ARGS__)
+
+#define dbg_checksum(func, insn, checksum)				\
+({									\
+	if (unlikely(insn->sym && insn->sym->pfunc &&			\
+		     insn->sym->pfunc->debug_checksum)) {		\
+		char *insn_off = offstr(insn->sec, insn->offset);	\
+		__dbg("checksum: %s %s %016lx",				\
+		      func->name, insn_off, checksum);			\
+		free(insn_off);						\
+	}								\
+})
+
 #endif /* _WARN_H */
-- 
2.49.0


