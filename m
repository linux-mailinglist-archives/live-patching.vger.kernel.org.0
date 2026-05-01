Return-Path: <live-patching+bounces-2662-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DTxHQEq9GlA+wEAu9opvQ
	(envelope-from <live-patching+bounces-2662-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8364AA3FA
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 04C17305DB7A
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9CF37472F;
	Fri,  1 May 2026 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BED08QUJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39960374192;
	Fri,  1 May 2026 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608552; cv=none; b=EDQJkmwIEg/VMrhDW3zg9p/sJCfVvldV7O48dXLMuB94v7NA1guC7x4YIA9c5lWyvyYYXrerpA9lhLqe9aOu6DgDR7JX++WuZBkOUR47RkrFlRte7nytBFW54KnA+Q9B2LwTvBhNw9b3Mnw8nURCMaQQ2UdDA/00eeEx0jR/Th0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608552; c=relaxed/simple;
	bh=ZOp4lg30bCe82KO2EegcVeytW9zoOZI2TN07/1MGzQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRGOvdf1dvljUaDqnVrmGkYfRkBtUGyjoU+hpENTkS+7s9nL76hT/Xbq14TwOyGE+YGTya9rMueybAmpS8GujgPYqx26F93ujs5YSCtLpk1z+l06Yds/d3VPj7y+8hPLrQYdCrdeGI5DJ152Lt8nAW8V71xpSvna6n18U7QBRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BED08QUJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1043C2BCB8;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608551;
	bh=ZOp4lg30bCe82KO2EegcVeytW9zoOZI2TN07/1MGzQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BED08QUJMr/JoUNZ9HkaIengOy0/vx2H2zX7ar9L3DO2z4gcvHXWsOIhPBE544Jr3
	 LbyBtJGWZnleJI4ruFSXGOqk4TlKqZQIiFU3xcyZmsxUR6s4f5fIkBtnib0WsGPsSX
	 nIKF3aKrKe6P335GxSTSU214sl39aDCEXsp6aI7xL7eytmelw/djuiG1iSXum/Asvs
	 1Eikh10j1BM5DEQ0oG1LGTJECvZsEKXL7SrU2kbkGhWtM1pjODnlL440pV3xpv8r/u
	 DjjDFzgyE77mHdM5+LFXbSgsueGEd0lWP00I6SMNOmj0NnabZknq6Y/bPNZCj3DYtn
	 Nrf8BL7LAcAnw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 45/53] objtool/klp: Calculate object checksums
Date: Thu, 30 Apr 2026 21:08:33 -0700
Message-ID: <88ebcc903a3c534f2c7d35b95f62d845105d40af.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD8364AA3FA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2662-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Start checksumming data objects in preparation for revamping the
correlation algorithm.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/checksum.h | 44 ++++++++----
 tools/objtool/include/objtool/warn.h     | 29 ++++----
 tools/objtool/klp-checksum.c             | 89 +++++++++++++++++++-----
 tools/objtool/klp-diff.c                 |  2 +-
 4 files changed, 117 insertions(+), 47 deletions(-)

diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index be4eb7dfe6f2..d46293f54716 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -6,28 +6,44 @@
 
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
+	__checksum_update(sym, &offset, sizeof(offset));
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
index e4a910f3211c..19653dbe109d 100644
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
@@ -128,31 +130,82 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
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
+		unsigned long sym_offset = reloc_offset(reloc) - sym->offset;
+		struct symbol *target = reloc->sym;
+		s64 offset;
+
+		offset = reloc_addend(reloc);
+
+		if (is_string_sec(target->sec)) {
+			char *str;
+
+			str = target->sec->data->d_buf + target->offset + offset;
+			__checksum_update_object(sym, sym_offset,
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
+		__checksum_update_object(sym, sym_offset, "reloc name",
+					 target->demangled_name,
+					 strlen(target->demangled_name));
+		__checksum_update_object(sym, sym_offset, "reloc addend",
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
 
@@ -213,7 +266,7 @@ int cmd_klp_checksum(int argc, const char **argv)
 	int ret;
 
 	const struct option options[] = {
-		OPT_STRING(0,	"debug-checksum", &opts.debug_checksum,	"funcs", "enable checksum debug output"),
+		OPT_STRING(0,	"debug-checksum", &opts.debug_checksum,	"syms", "enable checksum debug output"),
 		OPT_BOOLEAN(0,	"dry-run", &opts.dryrun, "don't write modifications"),
 		OPT_END(),
 	};
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 95359ad336bb..5f13d759e02f 100644
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


