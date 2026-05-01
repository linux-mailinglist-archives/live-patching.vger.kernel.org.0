Return-Path: <live-patching+bounces-2636-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACJHD7Qo9Gki+wEAu9opvQ
	(envelope-from <live-patching+bounces-2636-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:14:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D42524AA286
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23C883027136
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFA3331214;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3ZQrewg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491532BEC5E;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608539; cv=none; b=qTrBxvasx3qtvF772kcT8lSMPZ61En+ID947shpphyV/H0eDz9H1Y+UaqyIO7XKalkDKpnYFj5UwWuqzNvd84XiR68vyvNrZe40RkwC5oxWKPLEW10TtQA+ru1q+J3cRWhoibkJl6wH2M/vh9aMsysJ+jKRnvRWKT7DgF746qEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608539; c=relaxed/simple;
	bh=V5TjeaqIbFUsUWMkQqGV72vDZ7Ol+bs9z/fXO0pU1+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvmJT8M5fjnegqpEui1oCqVA5+4ltrQpu6r6nrakApsgHGGYF0OeTWIbXCf4pYsCtId5pZnHZwoHsgn9yLZow50C3LKYKsT4JPnfisVtbA4JqEdHMQENCKzWU8RIjVoxMwJe5cI60ftGjaiW+1QhhDfZem8+BFibzyyQe0A3e9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3ZQrewg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0BFC2BCB8;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608539;
	bh=V5TjeaqIbFUsUWMkQqGV72vDZ7Ol+bs9z/fXO0pU1+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3ZQrewg1+24PfF9O2o7ZS4Da3AwZypkKVRPn+XQRCYfkLX9BNHbv6ZBOIRQFMfWu
	 HHjQNOPj2ytQmul5n2+Yyn1/XcJ5bvsqL6mNG2c2wNtsct2LlHpnfo5y+Jh3k2TC/K
	 o9cl9T/+jjYfGu3GSV8/OMGAlzCftV+w4XYOd4zpPMNn8w0NH7pIwzOi7J3rd5PyC5
	 /KIJUEz72V/wUJEMArPtoXUMwjglKOO3xuw9p8JuMkeTPSF99+SFsI4kwTGNrmva3H
	 ZAdBq7xy7XNIswkUmEpsWlijcpcf9kYGOKG8qzfotkI4ZPd/2JFMjbPNYJIy0zqFoG
	 D3J+Zb/eVnADA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 19/53] objtool/klp: Fix pointer comparisons for rodata objects
Date: Thu, 30 Apr 2026 21:08:07 -0700
Message-ID: <07de8098fd8981321baab0ff552f65aa2cfc31ec.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: D42524AA286
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2636-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

klp-diff treats all rodata as uncorrelated, so any reference to it uses
a duplicated copy rather than using a KLP reloc.

For the contents of the data itself, a duplicated copy is fine.
However, pointer comparisons (e.g., f->f_op == &foo_ops) are broken.

Fix it by correlating non-anonymous rodata objects.

Also, use a new find_symbol_containing_inclusive() helper for matching
the end of a symbol so bounds calculations don't get broken, for the
case where an array or other symbol's ending address is used as part of
a bounds calculation.

While these are really two distinct changes, they need to be done in the
same patch so as to avoid introducing bisection regressions.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 14 ++++++++++++++
 tools/objtool/include/objtool/elf.h |  1 +
 tools/objtool/klp-diff.c            | 15 +++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 87c6e00749c6..5a20dab683dd 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -207,6 +207,20 @@ struct symbol *find_symbol_containing(const struct section *sec, unsigned long o
 	return sym ? sym->alias : NULL;
 }
 
+/*
+ * Also match the symbol end address which can be used for a bounds comparison.
+ */
+struct symbol *find_symbol_containing_inclusive(const struct section *sec,
+						unsigned long offset)
+{
+	struct symbol *sym = find_symbol_containing(sec, offset);
+
+	if (!sym && offset)
+		sym = find_symbol_containing(sec, offset - 1);
+
+	return sym;
+}
+
 /*
  * Returns size of hole starting at @offset.
  */
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index ab5f7017ec34..8a543cea43b9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -211,6 +211,7 @@ struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
+struct symbol *find_symbol_containing_inclusive(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 78633c9b68eb..bf37c652188b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -386,6 +386,7 @@ static bool dont_correlate(struct symbol *sym)
 	       is_uncorrelated_static_local(sym) ||
 	       is_local_label(sym) ||
 	       is_string_sec(sym->sec) ||
+	       (is_rodata_sec(sym->sec) && !is_object_sym(sym)) ||
 	       is_initcall_sym(sym) ||
 	       is_addressable_sym(sym) ||
 	       is_special_section(sym->sec) ||
@@ -979,7 +980,7 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 		goto found_sym;
 
 	/* No dedicated section; find the symbol manually */
-	sym = find_symbol_containing(sec, arch_adjusted_addend(reloc));
+	sym = find_symbol_containing_inclusive(sec, arch_adjusted_addend(reloc));
 	if (!sym) {
 		/*
 		 * This is presumably an .altinstr_replacement section which is
@@ -988,6 +989,17 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 		if (!sec_size(sec))
 			return 1;
 
+		/*
+		 * .rodata is a mixed bag of named objects and anonymous data.
+		 *
+		 * Convert section symbol references to named object symbols
+		 * when possible, to preserve pointer identity for const
+		 * structs like file_operations.  Otherwise a section symbol is
+		 * fine.
+		 */
+		if (is_rodata_sec(sec))
+			return 0;
+
 		/*
 		 * This can happen for special section references to weak code
 		 * whose symbol has been stripped by the linker.
@@ -1009,7 +1021,6 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 static bool is_uncorrelated_section(struct section *sec)
 {
 	return is_string_sec(sec) ||
-	       strstarts(sec->name, ".rodata") ||
 	       strstarts(sec->name, ".data..Lubsan") ||		/* GCC */
 	       strstarts(sec->name, ".data..L__unnamed_");	/* Clang */
 }
-- 
2.53.0


