Return-Path: <live-patching+bounces-2467-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIhCJNee6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2467-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3482044CEB5
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B482D32D0FEB
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C07F3DD50B;
	Thu, 23 Apr 2026 04:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ma5VlDf/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5753DCDB4;
	Thu, 23 Apr 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917085; cv=none; b=kNxIw6AEeWBM6IWZ/n5D75dCbrT7Mz5bqaDeCZEf4kaEjP7IMv4uokX+/I8s/+u1bTvjWHfOPhomZTQO4YLEgcvwqJJAFM9FTtRhjGHCGXtzUoLgX89MuV6Z8cMNUm0I9TQM4MJc/MRitROGOWbYUy9h31vbpWcrZSUAr3cWemg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917085; c=relaxed/simple;
	bh=R+8ECy7yKq4jzp8RCvv7108cy8ywNl7MbZrfSymzIeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIid0AU8L36rh2XWByVPWMk/LBAiGHhaWf3pLwTBRQI7Z0yze9idgdb/iudlHSno452w5a9VwRQ3SLJFY9jql9Ak+eEvfWJXd6wYAtecgvsVvyKnl2jRQgcG2s4/QkwKe6XGw5Bc8YN1J5POgAsZgvYnfetKjk0kLZHeUZb/gVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ma5VlDf/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554CFC2BCB4;
	Thu, 23 Apr 2026 04:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917084;
	bh=R+8ECy7yKq4jzp8RCvv7108cy8ywNl7MbZrfSymzIeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ma5VlDf/0OzzM81D5iviwwY4gJCat5drvAU3olfjhiM4V8xAiK/8W2qkI0e2N6LYq
	 nUVC/7ftMTiJ0BKSsMm/2bioCNMtJtBqP6LjBVpVH99hf9aWltvK5FrHMAd9OOXoTq
	 6LHYoL6RpuzE/+v1soZ8jP53Oa1GQZGOWSNl+jX4FX9EGaT11IaqBWncnn1kYVoUCu
	 erYT8wBv/dLdXQ5ALi52JVZfB5LDfcXu8J9ANGsG6Z97L4t9QY1aCgviWY1WEGtLzA
	 cNG2YMHKayBPc6QG6rHO/vUQmcMJLnUhP0naBtRE/Ii7aDc4YyEjs6FThrQREFcwP2
	 5uh8dRjXWjGJw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 40/48] objtool/klp: Calculate object checksums
Date: Wed, 22 Apr 2026 21:04:08 -0700
Message-ID: <084424751bed439249657e1aef6a3d5c4e199680.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2467-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3482044CEB5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Start checksumming data objects in preparation for revamping the
correlation algorithm.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/checksum.h | 43 ++++++++----
 tools/objtool/include/objtool/warn.h     | 29 ++++----
 tools/objtool/klp-checksum.c             | 88 +++++++++++++++++++-----
 tools/objtool/klp-diff.c                 |  2 +-
 4 files changed, 115 insertions(+), 47 deletions(-)

diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index be4eb7dfe6f2..ccaf57c7df38 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -6,28 +6,43 @@
 
 #ifdef BUILD_KLP
 
-static inline void checksum_init(struct symbol *func)
+static inline void checksum_init(struct symbol *sym)
 {
-	if (func && !func->csum.state) {
-		func->csum.state = XXH3_createState();
-		XXH3_64bits_reset(func->csum.state);
+	if (sym && !sym->csum.state) {
+		sym->csum.state = XXH3_createState();
+		XXH3_64bits_reset(sym->csum.state);
 	}
 }
 
-static inline void checksum_update(struct symbol *func,
-				   struct instruction *insn,
-				   const void *data, size_t size)
+static inline void __checksum_update(struct symbol *sym, const void *data,
+				     size_t size)
 {
-	XXH3_64bits_update(func->csum.state, data, size);
-	dbg_checksum(func, insn, XXH3_64bits_digest(func->csum.state));
+	XXH3_64bits_update(sym->csum.state, data, size);
 }
 
-static inline void checksum_finish(struct symbol *func)
+static inline void __checksum_update_insn(struct symbol *sym,
+					  struct instruction *insn,
+					  const void *data, size_t size)
 {
-	if (func && func->csum.state) {
-		func->csum.checksum = XXH3_64bits_digest(func->csum.state);
-		XXH3_freeState(func->csum.state);
-		func->csum.state = NULL;
+	__checksum_update(sym, data, size);
+	dbg_checksum_insn(sym, insn, XXH3_64bits_digest(sym->csum.state));
+}
+
+static inline void __checksum_update_object(struct symbol *sym,
+					    unsigned long offset,
+					    const char *what, const void *data,
+					    size_t size)
+{
+	__checksum_update(sym, data, size);
+	dbg_checksum_object(sym, offset, what, XXH3_64bits_digest(sym->csum.state));
+}
+
+static inline void checksum_finish(struct symbol *sym)
+{
+	if (sym && sym->csum.state) {
+		sym->csum.checksum = XXH3_64bits_digest(sym->csum.state);
+		XXH3_freeState(sym->csum.state);
+		sym->csum.state = NULL;
 	}
 }
 
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index fa8b7d292e83..595ee8009667 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -130,10 +130,22 @@ static inline void unindent(int *unused) { indent--; }
 		objname ? ": " : "",					\
 		##__VA_ARGS__)
 
-#define dbg(args...)							\
+#define dbg_checksum_insn(func, insn, checksum)				\
 ({									\
-	if (unlikely(debug))						\
-		__dbg(args);						\
+	if (unlikely(func->debug_checksum)) {				\
+		char *insn_off = offstr(insn->sec, insn->offset);	\
+		__dbg("checksum: %s(): %s %016llx",			\
+		      func->name, insn_off, (unsigned long long)checksum);\
+		free(insn_off);						\
+	}								\
+})
+
+#define dbg_checksum_object(sym, offset, what, checksum)		\
+({									\
+	if (unlikely(sym->debug_checksum))				\
+		__dbg("checksum: %s+0x%lx: %s %016llx",			\
+		      sym->name, offset, what,				\
+		      (unsigned long long)checksum);			\
 })
 
 #define __dbg_indent(format, ...)					\
@@ -147,15 +159,4 @@ static inline void unindent(int *unused) { indent--; }
 	__dbg_indent(args);						\
 	indent++
 
-#define dbg_checksum(func, insn, checksum)				\
-({									\
-	if (unlikely(insn->sym && insn->sym->pfunc &&			\
-		     insn->sym->pfunc->debug_checksum)) {		\
-		char *insn_off = offstr(insn->sec, insn->offset);	\
-		__dbg("checksum: %s %s %016llx",			\
-		      func->name, insn_off, (unsigned long long)checksum);\
-		free(insn_off);						\
-	}								\
-})
-
 #endif /* _WARN_H */
diff --git a/tools/objtool/klp-checksum.c b/tools/objtool/klp-checksum.c
index e4a910f3211c..adfd02447a45 100644
--- a/tools/objtool/klp-checksum.c
+++ b/tools/objtool/klp-checksum.c
@@ -35,7 +35,7 @@ static int checksum_debug_init(struct objtool_file *file)
 			*comma = '\0';
 
 		for_each_sym_by_name(file->elf, s, sym) {
-			if (!is_func_sym(sym))
+			if (!is_func_sym(sym) && !is_object_sym(sym))
 				continue;
 			sym->debug_checksum = 1;
 			found = true;
@@ -66,14 +66,14 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 	if (insn->fake)
 		return;
 
-	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+	__checksum_update_insn(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
 
 	if (!reloc) {
 		struct symbol *call_dest = insn_call_dest(insn);
 
 		if (call_dest)
-			checksum_update(func, insn, call_dest->demangled_name,
-					strlen(call_dest->demangled_name));
+			__checksum_update_insn(func, insn, call_dest->demangled_name,
+					       strlen(call_dest->demangled_name));
 		goto alts;
 	}
 
@@ -84,7 +84,7 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 		char *str;
 
 		str = sym->sec->data->d_buf + sym->offset + offset;
-		checksum_update(func, insn, str, strlen(str));
+		__checksum_update_insn(func, insn, str, strlen(str));
 		goto alts;
 	}
 
@@ -96,8 +96,9 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 		offset -= sym->offset;
 	}
 
-	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
-	checksum_update(func, insn, &offset, sizeof(offset));
+	__checksum_update_insn(func, insn, sym->demangled_name,
+			       strlen(sym->demangled_name));
+	__checksum_update_insn(func, insn, &offset, sizeof(offset));
 
 alts:
 	for (alt = insn->alts; alt; alt = alt->next) {
@@ -108,12 +109,13 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 			break;
 		in_alt = true;
 
-		checksum_update(func, insn, &alt->type, sizeof(alt->type));
+		__checksum_update_insn(func, insn, &alt->type,
+				       sizeof(alt->type));
 
 		if (alt_group && alt_group->orig_group) {
 			struct instruction *alt_insn;
 
-			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
+			__checksum_update_insn(func, insn, &alt_group->feature,sizeof(alt_group->feature));
 
 			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
 				checksum_update_insn(file, func, alt_insn);
@@ -128,31 +130,81 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 	}
 }
 
+static void checksum_update_object(struct objtool_file *file, struct symbol *sym)
+{
+	struct reloc *reloc;
+
+	__checksum_update_object(sym, 0, "len", &sym->len, sizeof(sym->len));
+
+	if (sym->sec->data->d_buf)
+		__checksum_update_object(sym, 0, "data",
+					 sym->sec->data->d_buf + sym->offset,
+					 sym->len);
+
+	sym_for_each_reloc(file->elf, sym, reloc) {
+		struct symbol *target = reloc->sym;
+		s64 offset;
+
+		offset = reloc_addend(reloc);
+
+		if (is_string_sec(target->sec)) {
+			char *str;
+
+			str = target->sec->data->d_buf + target->offset + offset;
+			__checksum_update_object(sym, reloc_offset(reloc),
+						 "reloc string", str, strlen(str));
+			continue;
+		}
+
+		if (is_sec_sym(target)) {
+			target = find_symbol_containing(reloc->sym->sec, offset);
+			if (!target)
+				continue;
+
+			offset -= target->offset;
+		}
+
+		__checksum_update_object(sym, reloc_offset(reloc), "reloc name",
+					 target->demangled_name,
+					 strlen(target->demangled_name));
+		__checksum_update_object(sym, reloc_offset(reloc), "reloc addend",
+					 &offset, sizeof(offset));
+	}
+}
+
 int calculate_checksums(struct objtool_file *file)
 {
 	struct instruction *insn;
-	struct symbol *func;
+	struct symbol *sym;
 
 	if (checksum_debug_init(file))
 		return -1;
 
-	for_each_sym(file->elf, func) {
+	for_each_sym(file->elf, sym) {
+
 		/*
 		 * Skip cold subfunctions and aliases: they share the
 		 * parent's checksum via func_for_each_insn() which
 		 * follows func->cfunc into the cold subfunction.
 		 */
-		if (!is_func_sym(func) || is_cold_func(func) ||
-		    is_alias_sym(func) || !func->len)
+		if (is_cold_func(sym) || is_alias_sym(sym) || !sym->len ||
+		    !sym->sec || !sym->sec->data)
 			continue;
 
-		checksum_init(func);
+		if (is_func_sym(sym)) {
+			checksum_init(sym);
+			func_for_each_insn(file, sym, insn)
+				checksum_update_insn(file, sym, insn);
+			checksum_finish(sym);
 
-		func_for_each_insn(file, func, insn)
-			checksum_update_insn(file, func, insn);
+		} else if (is_object_sym(sym)) {
+			checksum_init(sym);
+			checksum_update_object(file, sym);
+			checksum_finish(sym);
+		}
 
-		checksum_finish(func);
 	}
+
 	return 0;
 }
 
@@ -213,7 +265,7 @@ int cmd_klp_checksum(int argc, const char **argv)
 	int ret;
 
 	const struct option options[] = {
-		OPT_STRING(0,	"debug-checksum", &opts.debug_checksum,	"funcs", "enable checksum debug output"),
+		OPT_STRING(0,	"debug-checksum", &opts.debug_checksum,	"syms", "enable checksum debug output"),
 		OPT_BOOLEAN(0,	"dry-run", &opts.dryrun, "don't write modifications"),
 		OPT_END(),
 	};
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 33e401b85001..8d64d4c691cb 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -201,7 +201,7 @@ static int read_sym_checksums(struct elf *elf)
 			return -1;
 		}
 
-		if (is_func_sym(sym))
+		if (is_func_sym(sym) || is_object_sym(sym))
 			sym->csum.checksum = sym_checksum->checksum;
 	}
 
-- 
2.53.0


