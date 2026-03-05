Return-Path: <live-patching+bounces-2143-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OAUyBLgOqmngKQEAu9opvQ
	(envelope-from <live-patching+bounces-2143-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:08 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B22B219379
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F9983028C1D
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2D0366059;
	Thu,  5 Mar 2026 23:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="op8TMNcY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DF6283FC3
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752565; cv=none; b=rIFiZnAsHxoAt/qUfapqNmuW4utVFhBj4Gv9IyQ5YI/ppzxWlWzJP4/mQRutGXvkC0tsukF+b2jDgltoEvwXhHoVMdgQuOxnHMpMLfhtGZkWa401Gyp37BzAJiJvRr+ulaGWEJ7oSVK1s5r2g73WqdZRG/f29wCC/vu8tqrY+AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752565; c=relaxed/simple;
	bh=KfDNUoWmMHO+sbnCDQarMeJPmXHidaQYyN0lYmPQelc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF2DJh0HhNo7jO6QSP+XYjiWWQAht7ifk/LH3oGivSB/AAWKbJ7IprHi79CGBk4Rd0Crvhfu6F4lQgrlwY5MYVxVYdoLhOf9Kg8P2nKtcIoP0+4Yca5c7eE4/rqQcRdHCrBiZ/cEqzFMswiF8/upoRVQlhsnLYMFlho1Lb1JMv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=op8TMNcY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2D9C19423;
	Thu,  5 Mar 2026 23:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752564;
	bh=KfDNUoWmMHO+sbnCDQarMeJPmXHidaQYyN0lYmPQelc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op8TMNcYicr6Z1LW5bO4Dh8VoqCGjZIe/qf7425VMJ7uvfVH5mAvin/edBfAkq5sw
	 dJUpm5oOWcbGNY+adFwBbitV+//+0ZVcMWYphUwPpcYfRgeGtJo2E2cWuVzN6MVWYZ
	 2wy1cpnGEk9gxBHWixQ5FQD5P9G+NQAflpmpyXrNAdezDuaxCJQ+69qVLPJPtlYq7c
	 zkPpOnrcDlN5XbLkA+usijjdhvl9goqNDe7cjxrge56S4Y1Oqf79lAQDJWSF7UpdF+
	 XP4+05H8P1OKojHUdesYLrLduNlCGFUSmd7LUuR7mSQQYIc64tpQBHW/Fs12UMpPJE
	 xJ5+M+t5+bKag==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v4 6/7] objtool/klp: Match symbols based on demangled_name for global variables
Date: Thu,  5 Mar 2026 15:15:30 -0800
Message-ID: <20260305231531.3847295-7-song@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260305231531.3847295-1-song@kernel.org>
References: <20260305231531.3847295-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B22B219379
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2143-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

correlate_symbols() will always try to match full name first. If there is
no match, try match only demangled_name.

In very rare cases, it is possible to have multiple foo.llvm.<hash> in
the same kernel. Whenever there is ambiguity like this, fail the klp diff.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c                 | 13 +++++++
 tools/objtool/include/objtool/elf.h |  3 ++
 tools/objtool/klp-diff.c            | 57 +++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 51e6267cdf8d..ef4affd6e45e 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -323,6 +323,19 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
+void iterate_global_symbol_by_demangled_name(const struct elf *elf,
+					     const char *demangled_name,
+					     void (*process)(struct symbol *sym, void *data),
+					     void *data)
+{
+	struct symbol *sym;
+
+	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
+		if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
+			process(sym, data);
+	}
+}
+
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e12c516bd320..25573e5af76e 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -186,6 +186,9 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
+void iterate_global_symbol_by_demangled_name(const struct elf *elf, const char *demangled_name,
+					     void (*process)(struct symbol *sym, void *data),
+					     void *data);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 57606bc3390a..92043da0ed0b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -355,6 +355,46 @@ static bool dont_correlate(struct symbol *sym)
 	       strstarts(sym->name, "__initcall__");
 }
 
+struct process_demangled_name_data {
+	struct symbol *ret;
+	int count;
+};
+
+static void process_demangled_name(struct symbol *sym, void *d)
+{
+	struct process_demangled_name_data *data = d;
+
+	if (sym->twin)
+		return;
+
+	data->count++;
+	data->ret = sym;
+}
+
+/*
+ * When there is no full name match, try match demangled_name. This would
+ * match original foo.llvm.123 to patched foo.llvm.456.
+ *
+ * Note that, in very rare cases, it is possible to have multiple
+ * foo.llvm.<hash> in the same kernel. When this happens, report error and
+ * fail the diff.
+ */
+static int find_global_symbol_by_demangled_name(struct elf *elf, struct symbol *sym,
+						struct symbol **out_sym)
+{
+	struct process_demangled_name_data data = {};
+
+	iterate_global_symbol_by_demangled_name(elf, sym->demangled_name,
+						process_demangled_name,
+						&data);
+	if (data.count > 1) {
+		ERROR("Multiple (%d) correlation candidates for %s", data.count, sym->name);
+		return -1;
+	}
+	*out_sym = data.ret;
+	return 0;
+}
+
 /*
  * For each symbol in the original kernel, find its corresponding "twin" in the
  * patched kernel.
@@ -453,6 +493,23 @@ static int correlate_symbols(struct elfs *e)
 			continue;
 
 		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+		if (sym2 && !sym2->twin) {
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+		}
+	}
+
+	/*
+	 * Correlate globals with demangled_name.
+	 * A separate loop is needed because we want to finish all the
+	 * full name correlations first.
+	 */
+	for_each_sym(e->orig, sym1) {
+		if (sym1->bind == STB_LOCAL || sym1->twin)
+			continue;
+
+		if (find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
+			return -1;
 
 		if (sym2 && !sym2->twin) {
 			sym1->twin = sym2;
-- 
2.52.0


