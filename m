Return-Path: <live-patching+bounces-1410-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD69AB1E30
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DA4F50041F
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BC729A32D;
	Fri,  9 May 2025 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUXP/lrD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D0299AB0;
	Fri,  9 May 2025 20:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821901; cv=none; b=TZD1BkF30os0831YUC/qzQkYGsCh3a4lRF+BR/QinWbIUdxQQXJp8IezXXiWBA4vj1iR6jVfsm+GsJE3nXG2jHxSq+LxucEglyR6jcWoOcYwww2UtrIH442h06b+2f8c0r5WJv6eV0qvzOd128zcfZq/rVvOvu4BRxCJMwndOqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821901; c=relaxed/simple;
	bh=1YKYnjLs13Leq2MuzKlp2LCDvypqiGjyWag+THpNkyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUhAnISh9zZhhxOpNK+tyc6Ywed6B9McZAcMwXfrG+eGgGi+bxq7V2pXhyarKRAizDr3PdX5e4sSxOF0NXv4EEJ0kIc9LjHnblZYEquLHiz43xWNsAJs9zPmz4dgcYbLocK3q9mwZ0Jb+Ph1wjxgasGqs2lN1Mgm5+OL8QmYLkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUXP/lrD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8A6C4CEF0;
	Fri,  9 May 2025 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821900;
	bh=1YKYnjLs13Leq2MuzKlp2LCDvypqiGjyWag+THpNkyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUXP/lrDcGtVxvM6uik2kaqEdJzORd/U+fG9ciRUSmbN6WLNYSxYRpC7ldzD0RILF
	 7dGUQs+qGYhKkYxAdJyeO1SWtIxnYyPrfI8lQa6RAFcP2jdPD1qu4ujdVk94o7ncbI
	 vP0ksFH1A4r069Ku9PllnM+v0BeQEJgEj1q1Vx7SuFI/NtB6puMjfvDO5YYLO0hmiB
	 YCNOoGhq2wNJeJci2IB0S1t1GKSFwJl5YcHQVS5IvTvvKr4zSRpT7PJtnkaAjwLSed
	 QbB86ptGslUH3vw7DFpXzono12s1Hu9r3TYSRG7N20QdLa1Ioz7wwrzkUdWNMZ14Nw
	 ObTJVn27glxPQ==
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
Subject: [PATCH v2 51/62] objtool/klp: Add --debug-checksum=<funcs> to show per-instruction checksums
Date: Fri,  9 May 2025 13:17:15 -0700
Message-ID: <7d6a7093e117e7678aee82fedfa6cfad094a46d8.1746821544.git.jpoimboe@kernel.org>
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
index 9bb26138bb56..84918593d935 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -92,6 +92,7 @@ static const struct option check_options[] = {
 
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_STRING(0,		 "debug-checksum", &opts.debug_checksum,  "funcs", "enable checksum debug output"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,		 "link", &opts.link, "object is a linked object"),
 	OPT_BOOLEAN(0,		 "module", &opts.module, "object is part of a kernel module"),
@@ -167,6 +168,11 @@ static bool opts_valid(void)
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
index 4ca4d5190f35..30a5eb725931 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3622,6 +3622,44 @@ static bool skip_alt_group(struct instruction *insn)
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
@@ -4789,6 +4827,10 @@ int check(struct objtool_file *file)
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
index 3ec233406cda..ceabafb43327 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -30,6 +30,7 @@ struct opts {
 
 	/* options: */
 	bool backtrace;
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


