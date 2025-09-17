Return-Path: <live-patching+bounces-1705-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CA1B80E33
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBFBE620FBE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4F0393DDE;
	Wed, 17 Sep 2025 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0WdyzBy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480DA393DD4;
	Wed, 17 Sep 2025 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125092; cv=none; b=TiUIQjktJK+kdjpNCo8em3tf89cu0IfWcU7236OrGC4xFkUy5Hp85azwp4ScXcD/fM4L2HuqTccy0svrnD67PGxAdpCf0dpqlDOtG8BFnQgtMgyOmuHrS8hTXwjp8uqOmse0B7paCznfaJOyaVDrJKOq2HBceTqPE4diUyY80yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125092; c=relaxed/simple;
	bh=J3oq8lHviyAL82JPpotNOUwJ+UbtKP5S5krn1f4sstU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewGu4BCzNaZg7gbyHO5rOHKH0kBEXncPo3N8N4V950SS5DA/yzpF0L2WPz6Wi8RHJG9piVnnhkCmH5bpL5KRLvcoeWRt6/U3LKTpOF+On4mCBQuWTlJGqBwoZEAAn9IoumMc9gIeVSIkZHA4xzUZtbINqmiioMStRhawyzaGSRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0WdyzBy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F111C4CEFB;
	Wed, 17 Sep 2025 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125091;
	bh=J3oq8lHviyAL82JPpotNOUwJ+UbtKP5S5krn1f4sstU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0WdyzBys9pzD27mbLN4QOOXElRvhHuibkGUoypSkfq+fnEo1wrGIY4t8R3+au8NT
	 kit6FqPmEcypANhcrQpV3FpRWsIgBzehhff+3mNRYwETQ5/5T2WEbKFl02DZuByXkq
	 Xuztte1212bZ1krMKjwHskUrjAGmkOO/4m6QVMSOnei2/L9HxS9sHKce68u0UaNOks
	 s3x87L/aSWxWxjEOv0KSxIXBNq6hxQ8LfE6MR6Bb2/HPX+5ryQQjZMOwOeA2oF/HNb
	 /hd+4FJxod2jHFSSQr6+Cr54Y0kFA3hAhWLJpjeePjyr5PWZj8NBLZIM11E4huKMd4
	 dW5rkfR64YcPA==
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
Subject: [PATCH v4 50/63] objtool/klp: Add --debug-checksum=<funcs> to show per-instruction checksums
Date: Wed, 17 Sep 2025 09:03:58 -0700
Message-ID: <052b0fe5277b99f5640c619d8471e81eaf1fb266.1758067943.git.jpoimboe@kernel.org>
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
index 101f05606a990..b20b0077449b2 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -94,6 +94,7 @@ static const struct option check_options[] = {
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
index fec53407428e2..5eb0c92aa9fe5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3590,6 +3590,44 @@ static bool skip_alt_group(struct instruction *insn)
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
@@ -4828,6 +4866,10 @@ int check(struct objtool_file *file)
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
index 338bdab6b9ad8..cee9fc0318777 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -32,6 +32,7 @@ struct opts {
 	/* options: */
 	bool backtrace;
 	bool backup;
+	const char *debug_checksum;
 	bool dryrun;
 	bool link;
 	bool mnop;
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 927ca74b5c39e..7fe21608722ac 100644
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
index bc7d8a6167f8f..a1f1762f89c49 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -82,6 +82,7 @@ struct symbol {
 	u8 nocfi             : 1;
 	u8 cold		     : 1;
 	u8 prefix	     : 1;
+	u8 debug_checksum    : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index cb8fe846d9ddd..29173a1368d79 100644
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
2.50.0


