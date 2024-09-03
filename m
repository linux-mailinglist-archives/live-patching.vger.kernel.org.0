Return-Path: <live-patching+bounces-555-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B21E4969295
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E6E51F21DBB
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F1D1D6781;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3zgjR+2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8331F1D61AE;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336040; cv=none; b=byUzh6dmoFUz5Pr3vKMKjfNjCr2sPEjojhO0QRZ8agM7D5Iy6TExyWbd4J6ArqDe9yt5mRt0j8AnaIHzyZRm4+JeAgowtsPPiqVj0KR2kBFIApHveVD7hT0b3BrBahKeoVF8/7oIDdJUmIwfq9AhLXIb2gYIbREcxcrugndzXUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336040; c=relaxed/simple;
	bh=67oHwTiAtqRuquV0JYsJeyGvcVHWHwzQnwQ9KJdp+kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Liik7keeTtXYGNZyeKPCr+rlxrTZ223voELXymz4nj2sc5eu/w/kpCEdnuWcfRk+gKJhULMJ8f5SR+Yb+02fGYOnKSml1xa7tmHp/7le9+J/naBWzpzPJseeHjVM8Ykc5BsGs3qa5HSnLKa+ZKrhncAsVKEgx7gpumu3q24EbMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3zgjR+2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9034FC4CECA;
	Tue,  3 Sep 2024 04:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336039;
	bh=67oHwTiAtqRuquV0JYsJeyGvcVHWHwzQnwQ9KJdp+kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3zgjR+2Ti2BsDWbzA/ISFoOjQbmnSfmLVRUfUa7lSkG7jbTec1f8PV35TNTNWbcW
	 +hD3eylt46m0LdYgBYr4AwRYEVuHz2qI+RRavUE5rUrDedM0RA7bkiWRjGmjv7Oq8y
	 RHfNqSzNKYbw6m2NY/8emLNTBwnmxiJgq5ykm1J1bQSS4w8wOTWrYEABHAjlrQiXxC
	 goXp87tJkWpDNrEsizZD0nhv2wxsaiYMz5H+2axjv9Bum3DDNTagH4in2TdOxlviwI
	 pt4OzfjkqFzT6yg+OGdJ0dhu9tsG5Eap7CpOeMzxXatzg8hnnRutBj7N6PRrO8SaQP
	 hOGHZatboFHZw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 21/31] objtool: Fix x86 addend calcuation
Date: Mon,  2 Sep 2024 21:00:04 -0700
Message-ID: <43433a745f6db5afb513d015a6181bc40be12b4f.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arch_dest_reloc_offset() hard-codes the addend adjustment to 4, which
isn't always true.  In fact it's dependent on the instruction itself.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c |  4 ++--
 tools/objtool/arch/powerpc/decode.c   |  4 ++--
 tools/objtool/arch/x86/decode.c       | 15 +++++++++++++--
 tools/objtool/check.c                 | 13 ++++---------
 tools/objtool/include/objtool/arch.h  |  2 +-
 5 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index ef09996c772e..b5d44d7bce4e 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -20,9 +20,9 @@ unsigned long arch_jump_destination(struct instruction *insn)
 	return insn->offset + (insn->immediate << 2);
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend;
+	return reloc_addend(addend);
 }
 
 bool arch_pc_relative_reloc(struct reloc *reloc)
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index 29e05ad1b8b6..11e59065f1dc 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -14,9 +14,9 @@ int arch_ftrace_match(const char *name)
 	return !strcmp(name, "_mcount");
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend;
+	return reloc_addend(reloc);
 }
 
 bool arch_callee_saved_reg(unsigned char reg)
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 72d55dcd3d7f..afebd67d9b9d 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -67,9 +67,20 @@ bool arch_callee_saved_reg(unsigned char reg)
 	}
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend + 4;
+	s64 addend = reloc_addend(reloc);
+
+	switch (reloc_type(reloc)) {
+	case R_X86_64_PC32:
+	case R_X86_64_PLT32:
+		addend += insn->offset + insn->len - reloc_offset(reloc);
+		break;
+	default:
+		break;
+	}
+
+	return addend;
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 236dc7871f01..3c8d0903dfa7 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1461,7 +1461,7 @@ static void add_jump_destinations(struct objtool_file *file)
 		} else if (sym_has_section(reloc->sym)) {
 			dest_sec = reloc->sym->sec;
 			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc_addend(reloc));
+				   arch_insn_adjusted_addend(insn, reloc);
 		} else {
 			/* External symbol (UNDEF) */
 			dest_sec = NULL;
@@ -1609,7 +1609,7 @@ static void add_call_destinations(struct objtool_file *file)
 				ERROR_INSN(insn, "unsupported call to non-function");
 
 		} else if (is_section_symbol(reloc->sym)) {
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest)
 				ERROR_INSN(insn, "can't find call dest symbol at %s+0x%lx",
@@ -3119,7 +3119,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	if (!reloc || strcmp(reloc->sym->name, "pv_ops"))
 		return false;
 
-	idx = (arch_dest_reloc_offset(reloc_addend(reloc)) / sizeof(void *));
+	idx = (arch_insn_adjusted_addend(insn, reloc) / sizeof(void *));
 
 	if (file->pv_ops[idx].clean)
 		return true;
@@ -4070,12 +4070,7 @@ static int validate_ibt_insn(struct objtool_file *file, struct instruction *insn
 		if (reloc->sym->static_call_tramp)
 			continue;
 
-		off = reloc->sym->offset;
-		if (reloc_type(reloc) == R_X86_64_PC32 ||
-		    reloc_type(reloc) == R_X86_64_PLT32)
-			off += arch_dest_reloc_offset(reloc_addend(reloc));
-		else
-			off += reloc_addend(reloc);
+		off = reloc->sym->offset + arch_insn_adjusted_addend(insn, reloc);
 
 		dest = find_insn(file, reloc->sym->sec, off);
 		if (!dest)
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index f48f5109abb1..14911fdfdc8f 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -81,7 +81,7 @@ bool arch_callee_saved_reg(unsigned char reg);
 
 unsigned long arch_jump_destination(struct instruction *insn);
 
-unsigned long arch_dest_reloc_offset(int addend);
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc);
 
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
-- 
2.45.2


