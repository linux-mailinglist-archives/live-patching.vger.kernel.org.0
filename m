Return-Path: <live-patching+bounces-2762-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cG7gNjzyA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2762-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:38:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8890C52CD4A
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE9E130FD9E8
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273213A3E8C;
	Wed, 13 May 2026 03:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOASekOA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C73A3E65;
	Wed, 13 May 2026 03:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643278; cv=none; b=TZKlMhvdK8lWJvXJ4JRte8s6prUcBHGjkG3j4Ze33Brd+90ZClJdzSsKQ0t1/4OT3ozIdSqrDr13qkkrjISOSnttDoEpitH5ymvQP2vHlWlxa1wIneyzWU+d4/nbc8otKS0b5U6qNVU87MglIyTPu7S0jK0ri2Q14zINvCm28aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643278; c=relaxed/simple;
	bh=Ny02yZ3OX6brRIw4EOBZjdfKy5OscDww5EM574zM+io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB/XIc+6pUkC/v6d6q2iIGY9ilSysGYF9DGFkgaZvrMG4Ib6SCWsY1CdKlpCwKvzXVB9m/rbBAhbAMTE8o5CIb2nKW3o9SnGetWOgszGCRz0vJ/3AWIScw2wIVQHWm2Rjdc+nl+n1bMs9NX0GXqg7IZ53bFSRpP5Vi0g1HSV0js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOASekOA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA11C2BCFA;
	Wed, 13 May 2026 03:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643277;
	bh=Ny02yZ3OX6brRIw4EOBZjdfKy5OscDww5EM574zM+io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOASekOAsmnOnYUmzF3F+Q0rRFnHaxnhe3S+uBgM0liO5vZQPGbIqBpvBzG4KKg9/
	 jnY/29NBFmI4u41tRozrForv8RHWrFaln1nTDDjCX/EU9hlb5ad/s1F2QON9m73xdL
	 UotJbBTnOOECnE1upsjSGWRsz0JMvRTm89zKzeMZUqFUKEE/s8sXmC2ajZ0RnoDz0X
	 D6MpI5ZyCFcvvzNmoLvNznW4UBpz0yhPxzO0R9Z4L2CbUZk2zw+6Z0LSrThnLl7C5q
	 RdEkFOvJL9pPsGB8ppbNiFJUhxBpVDmMaKlgb8ZTz6chBTcV0uhXegtB8YhWVcCiH4
	 kM6cKVD5ZbZew==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 12/21] objtool: Refactor elf_add_data() to use a growable data buffer
Date: Tue, 12 May 2026 20:33:46 -0700
Message-ID: <a0fe2363d017a2833e98ae50de797fe55c2796a4.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8890C52CD4A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2762-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Instead of calling elf_newdata() for each new piece of data with its own
separate buffer, keep it all in the same growable buffer so the
section's entire data can be accessed if needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 123 ++++++++++++++--------------
 tools/objtool/include/objtool/elf.h |  13 ++-
 2 files changed, 71 insertions(+), 65 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 33c95a74a51bd..e09bb0a63be35 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1134,9 +1134,6 @@ static int read_relocs(struct elf *elf)
 
 		rsec->base->rsec = rsec;
 
-		/* nr_alloc_relocs=0: libelf owns d_buf */
-		rsec->nr_alloc_relocs = 0;
-
 		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(*reloc));
 		if (!rsec->relocs) {
 			ERROR_GLIBC("calloc");
@@ -1395,7 +1392,7 @@ unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char
 
 void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_t size)
 {
-	unsigned long offset;
+	unsigned long offset, size_old, size_new, alloc_size_old, alloc_size_new;
 	Elf_Scn *s;
 
 	if (!sec->sh.sh_addralign) {
@@ -1409,30 +1406,55 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
 		return NULL;
 	}
 
-	sec->data = elf_newdata(s);
 	if (!sec->data) {
-		ERROR_ELF("elf_newdata");
-		return NULL;
+		sec->data = elf_newdata(s);
+		if (!sec->data) {
+			ERROR_ELF("elf_newdata");
+			return NULL;
+		}
+
+		sec->data->d_align = sec->sh.sh_addralign;
 	}
 
-	sec->data->d_buf = calloc(1, size);
-	if (!sec->data->d_buf) {
-		ERROR_GLIBC("calloc");
-		return NULL;
+	size_old = sec->data->d_size;
+	offset = ALIGN(size_old, sec->sh.sh_addralign);
+	size_new = offset + size;
+
+	if (!sec->data_overallocated)
+		alloc_size_old = size_old;
+	else
+		alloc_size_old = max(64UL, roundup_pow_of_two(size_old ? : 1));
+
+	alloc_size_new = max(64UL, roundup_pow_of_two(size_new ? : 1));
+
+	if (alloc_size_new > alloc_size_old) {
+		void *orig_buf = sec->data->d_buf;
+
+		sec->data->d_buf = calloc(1, alloc_size_new);
+		if (!sec->data->d_buf) {
+			ERROR_GLIBC("calloc");
+			return NULL;
+		}
+
+		if (size_old)
+			memcpy(sec->data->d_buf, orig_buf, size_old);
+
+		if (orig_buf && sec->data_owned)
+			free(orig_buf);
+
+		sec->data_owned = 1;
+		sec->data_overallocated = 1;
 	}
 
 	if (data)
-		memcpy(sec->data->d_buf, data, size);
-
-	sec->data->d_size = size;
-	sec->data->d_align = sec->sh.sh_addralign;
-
-	offset = ALIGN(sec_size(sec), sec->sh.sh_addralign);
-	sec->sh.sh_size = offset + size;
+		memcpy(sec->data->d_buf + offset, data, size);
+	else
+		memset(sec->data->d_buf + offset, 0, size);
 
+	sec->data->d_size = size_new;
+	sec->sh.sh_size = size_new;
 	mark_sec_changed(elf, sec, true);
-
-	return sec->data->d_buf;
+	return sec->data->d_buf + offset;
 }
 
 struct section *elf_create_section(struct elf *elf, const char *name,
@@ -1483,6 +1505,8 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 			ERROR_GLIBC("calloc");
 			return NULL;
 		}
+
+		sec->data_owned = 1;
 	}
 
 	if (!gelf_getshdr(s, &sec->sh)) {
@@ -1533,60 +1557,33 @@ static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
 	struct reloc *old_relocs, *old_relocs_end, *new_relocs;
 	unsigned int nr_relocs_old = sec_num_entries(rsec);
 	unsigned int nr_relocs_new = nr_relocs_old + 1;
-	unsigned long nr_alloc;
+	unsigned long nr_alloc_old = 0, nr_alloc_new;
 	struct symbol *sym;
 
-	if (!rsec->data) {
-		rsec->data = elf_newdata(elf_getscn(elf->elf, rsec->idx));
-		if (!rsec->data) {
-			ERROR_ELF("elf_newdata");
-			return -1;
-		}
+	if (!elf_add_data(elf, rsec, NULL, elf_rela_size(elf)))
+		return -1;
 
-		rsec->data->d_align = 1;
-		rsec->data->d_type = ELF_T_RELA;
-		rsec->data->d_buf = NULL;
-	}
+	rsec->data->d_type = ELF_T_RELA;
 
-	rsec->data->d_size = nr_relocs_new * elf_rela_size(elf);
-	rsec->sh.sh_size   = rsec->data->d_size;
+	if (rsec->relocs_overallocated)
+		nr_alloc_old = max(64UL, roundup_pow_of_two(nr_relocs_old ? : 1));
+	else
+		nr_alloc_old = nr_relocs_old;
 
-	nr_alloc = max(64UL, roundup_pow_of_two(nr_relocs_new));
-	if (nr_alloc <= rsec->nr_alloc_relocs)
+	nr_alloc_new = max(64UL, roundup_pow_of_two(nr_relocs_new ? : 1));
+
+	if (nr_alloc_old == nr_alloc_new)
 		return 0;
 
-	if (rsec->data->d_buf && !rsec->nr_alloc_relocs) {
-		void *orig_buf = rsec->data->d_buf;
-
-		/*
-		 * The original d_buf is owned by libelf so it can't be
-		 * realloced.
-		 */
-		rsec->data->d_buf = malloc(nr_alloc * elf_rela_size(elf));
-		if (!rsec->data->d_buf) {
-			ERROR_GLIBC("malloc");
-			return -1;
-		}
-		memcpy(rsec->data->d_buf, orig_buf,
-		       nr_relocs_old * elf_rela_size(elf));
-	} else {
-		rsec->data->d_buf = realloc(rsec->data->d_buf,
-					    nr_alloc * elf_rela_size(elf));
-		if (!rsec->data->d_buf) {
-			ERROR_GLIBC("realloc");
-			return -1;
-		}
-	}
-
-	rsec->nr_alloc_relocs = nr_alloc;
-
-	old_relocs = rsec->relocs;
-	new_relocs = calloc(nr_alloc, sizeof(struct reloc));
+	new_relocs = calloc(nr_alloc_new, sizeof(struct reloc));
 	if (!new_relocs) {
 		ERROR_GLIBC("calloc");
 		return -1;
 	}
 
+	rsec->relocs_overallocated = 1;
+
+	old_relocs = rsec->relocs;
 	if (!old_relocs)
 		goto done;
 
@@ -1631,6 +1628,7 @@ static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
 	}
 
 	free(old_relocs);
+
 done:
 	rsec->relocs = new_relocs;
 	return 0;
@@ -1660,7 +1658,6 @@ struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
 	if (nr_relocs) {
 		rsec->data->d_type = ELF_T_RELA;
 
-		rsec->nr_alloc_relocs = nr_relocs;
 		rsec->relocs = calloc(nr_relocs, sizeof(struct reloc));
 		if (!rsec->relocs) {
 			ERROR_GLIBC("calloc");
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index d9c44df9cc76a..0801fcad516bb 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -58,9 +58,18 @@ struct section {
 	Elf_Data *data;
 	const char *name;
 	int idx;
-	bool _changed, text, rodata, noinstr, init, truncate;
+	u32 _changed			: 1,
+	    text			: 1,
+	    rodata			: 1,
+	    noinstr			: 1,
+	    init			: 1,
+	    truncate			: 1,
+	    data_owned			: 1,
+	    data_overallocated		: 1,
+	    relocs_overallocated	: 1;
+	    /* 23 bit hole */
+
 	struct reloc *relocs;
-	unsigned long nr_alloc_relocs;
 	struct section *twin;
 };
 
-- 
2.53.0


