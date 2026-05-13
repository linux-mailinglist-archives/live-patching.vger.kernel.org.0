Return-Path: <live-patching+bounces-2764-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yKCGM1fyA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2764-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:39:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC3852CD69
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A675F310A0D8
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FF93A48CA;
	Wed, 13 May 2026 03:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncUO3Z32"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B9639C637;
	Wed, 13 May 2026 03:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643278; cv=none; b=inhXyp9jHWFVQxdOVkcrVnXY1JCVb2D49V9nGpGwI1XSWo4057WmYajqFAG4dCRvGbWhagxW70QvBisc2jwnGHjDNgp+0WRXqi8QkMm3uGWzQFgid/nM47MovmIL69KZ9JYrKlEVRTcVnRQ5B9xmxK17lHItZ/tq9KVaFhMtQ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643278; c=relaxed/simple;
	bh=lYQ1yov6GYXVE+5pFJSvbDLFJ5lLXCdGtVTWLqgmeuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqEfCtHEXpvjFz2n65P2q315+GH7D1Rrvax6TCxlWAy8WOAnBjuZonujLXAZAUcQ0JRXj0+zs3xxZcQQv94CWYtRVxc/QCED6TZAsLJNjIk6oAFO03PUXnVm3hbAB4MKJbQQG6C8Bajgg7Kh37F/pfO57EnuUHg3RMzAieURXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncUO3Z32; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D32C2BCC9;
	Wed, 13 May 2026 03:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643278;
	bh=lYQ1yov6GYXVE+5pFJSvbDLFJ5lLXCdGtVTWLqgmeuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncUO3Z32AbCA3N67e+bLhuW1dnvX0NQjy8olIzxmFBg+0bPjrMcNu0YF6dkAtue9L
	 ki4CmckhNSZTSQps7z/m/oqN+kRw4sVVYZWOlE67k0U53hsYcyo2Zy7lkEwA194nzD
	 e1rUTJkVPsoB1Qk1L5vr/1IagUXAy7mPYABMJcccHC0yP6myPwj7diAgZydR6JJxYV
	 TDoNDG9TaWcpTjCfQ11W4HbQjqOhBSz+tbvEk6FiMdgqhFyCsrfcM8SrUdMy2Z4sYi
	 p9JB7/eom2Ck4C3MoiDqc+h5JWS+1+R7wp98F/LDjVlfO5I4S9Fs/I5k3PE5CpGbyE
	 FPkPPhuQSHenw==
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
Subject: [PATCH v3 13/21] objtool: Reuse string references
Date: Tue, 12 May 2026 20:33:47 -0700
Message-ID: <8881010b54f07432929acb8e704cd6ffcc835318.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 7AC3852CD69
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
	TAGGED_FROM(0.00)[bounces-2764-lists,live-patching=lfdr.de];
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

For duplicate strings, elf_add_string() just blindly adds duplicates.

That can be a problem for arm64 which often uses two consecutive
instructions (and corresponding relocations) to put an address into a
register, like:

  d8:   90000001        adrp    x1, 0 <meminfo_proc_show>       d8: R_AARCH64_ADR_PREL_PG_HI21  .rodata.meminfo_proc_show.str1.8
  dc:   91000021        add     x1, x1, #0x0    dc: R_AARCH64_ADD_ABS_LO12_NC   .rodata.meminfo_proc_show.str1.8

Referencing two different addresses in the ADRP+ADD pair would corrupt
the memory access.  Avoid that by detecting and reusing duplicates when
cloning string relocs.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 29 +++++++++++++++++++++++------
 tools/objtool/include/objtool/elf.h |  3 ++-
 tools/objtool/klp-diff.c            |  4 +++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index e09bb0a63be35..065ccfeb98288 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1366,9 +1366,27 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 	return elf;
 }
 
-unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
+int elf_find_string(struct elf *elf, struct section *strtab, const char *str)
 {
-	unsigned int offset;
+	char *d_buf;
+	int i;
+
+	if (!strtab->data)
+		return -1;
+
+	d_buf = strtab->data->d_buf;
+
+	for (i = 0; i < strtab->data->d_size; i += strlen(d_buf + i) + 1) {
+		if (!strcmp(d_buf + i, str))
+			return i;
+	}
+
+	return -1;
+}
+
+int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
+{
+	void *data;
 
 	if (!strtab)
 		strtab = find_section_by_name(elf, ".strtab");
@@ -1382,12 +1400,11 @@ unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char
 		return -1;
 	}
 
-	offset = ALIGN(sec_size(strtab), strtab->sh.sh_addralign);
-
-	if (!elf_add_data(elf, strtab, str, strlen(str) + 1))
+	data = elf_add_data(elf, strtab, str, strlen(str) + 1);
+	if (!data)
 		return -1;
 
-	return offset;
+	return data - strtab->data->d_buf;
 }
 
 void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_t size)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 0801fcad516bb..d895023674673 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -187,7 +187,8 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
 void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
 		   size_t size);
 
-unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
+int elf_find_string(struct elf *elf, struct section *strtab, const char *str);
+int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
 			       unsigned long offset, struct symbol *sym,
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 6a1cec57dc6a3..6957292e455e4 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1509,7 +1509,9 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 
 		__dbg_clone("\"%s\"", escape_str(str));
 
-		addend = elf_add_string(e->out, out_sym->sec, str);
+		addend = elf_find_string(e->out, out_sym->sec, str);
+		if (addend == -1)
+			addend = elf_add_string(e->out, out_sym->sec, str);
 		if (addend == -1)
 			return -1;
 	}
-- 
2.53.0


