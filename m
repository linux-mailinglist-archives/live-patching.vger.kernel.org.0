Return-Path: <live-patching+bounces-1658-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7A7B80D37
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98FC57B156E
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E572F8BF3;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLcnRz8W"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB9A2F8BDA;
	Wed, 17 Sep 2025 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125059; cv=none; b=fEbDik5BWMI0MOQPeC3eH4uYfWmt1S88XWzjFcx53oc9G3ivdrCevbhJ2D/H6YAYNPRyN0BKcwmxuvaZ/4Tgd7xmd9BEFOzZh94MY5FzqL8fvzUZs1diiiA3Rp4y7sJtEnMvXLLT9F/WJTF0VQ+v9JWQv5g9XYevihORM31LRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125059; c=relaxed/simple;
	bh=RQybw1fumGyVhHslCFCuRhNEASOrXXvaIx0FvYmfnu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXUpKM+Qol90+U4NjBgC29g2gIaA+bgRacdafQixtj3nJaWbOWJ3t3pFxw+WnoKjoCdp3+4Mrr1HdSx+cCQcQ1Odpu014eFhOffPi9WQF4K2zXIC0v6W7DohTP3PeS4HlOBlqb4f07Oc15IDf6uxVeO7yeGBRK24Ve9Voc08CqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLcnRz8W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43CCC4CEE7;
	Wed, 17 Sep 2025 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125058;
	bh=RQybw1fumGyVhHslCFCuRhNEASOrXXvaIx0FvYmfnu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLcnRz8WGUFknYFf9ln0hWWaomuaKWbttbWteuUpmgnlqdH327RAwp+/mK/tOu02a
	 OjQnzrgCGYAK0Y+RfuCAEiSEAaXnx2PSME9LjGdl00HQZJmVsX4U4XBKjtyqTddGg2
	 m89fqRgawJ3RBeiaL33UmVAIJ3BsuLCnkE005ursDUBCuceRrm1WEfRBVJGh5L4yhw
	 E5rlBCPVHdGkem2VMbtLPhq1+s+ecL+JW0CEq/BEfW9ndYdQ9xMfffynNhnoCOOHi0
	 gT2juhvvABjqvyQ+BvTEU46AS/eOoC5S28RP00OzxNUbtKumvRj2QlFxVQxwjm/xUz
	 gayTyH00rgs8w==
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
Subject: [PATCH v4 03/63] x86/module: Improve relocation error messages
Date: Wed, 17 Sep 2025 09:03:11 -0700
Message-ID: <22b641d3a1a35a0711076104e3285ff4634f35e1.1758067942.git.jpoimboe@kernel.org>
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

Add the section number and reloc index to relocation error messages to
help find the faulty relocation.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/module.c | 15 +++++++++------
 kernel/livepatch/core.c  |  4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 0ffbae902e2fe..11c45ce42694c 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -97,6 +97,7 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 	DEBUGP("%s relocate section %u to %u\n",
 	       apply ? "Applying" : "Clearing",
 	       relsec, sechdrs[relsec].sh_info);
+
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		size_t size;
 
@@ -162,15 +163,17 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 
 		if (apply) {
 			if (memcmp(loc, &zero, size)) {
-				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
-				       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for sec %u, idx %u, type %d, loc %lx, val %llx\n",
+				       relsec, i, (int)ELF64_R_TYPE(rel[i].r_info),
+				       (unsigned long)loc, val);
 				return -ENOEXEC;
 			}
 			write(loc, &val, size);
 		} else {
 			if (memcmp(loc, &val, size)) {
-				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
-					(int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for sec %u, idx %u, type %d, loc %lx, val %llx\n",
+					relsec, i, (int)ELF64_R_TYPE(rel[i].r_info),
+					(unsigned long)loc, val);
 				return -ENOEXEC;
 			}
 			write(loc, &zero, size);
@@ -179,8 +182,8 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	pr_err("overflow in relocation type %d val %Lx\n",
-	       (int)ELF64_R_TYPE(rel[i].r_info), val);
+	pr_err("overflow in relocation type %d val %llx sec %u idx %d\n",
+	       (int)ELF64_R_TYPE(rel[i].r_info), val, relsec, i);
 	pr_err("`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
 	return -ENOEXEC;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0e73fac55f8eb..7e443c2cf7d48 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -217,8 +217,8 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
 		sym = (Elf_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
 		if (sym->st_shndx != SHN_LIVEPATCH) {
-			pr_err("symbol %s is not marked as a livepatch symbol\n",
-			       strtab + sym->st_name);
+			pr_err("symbol %s at rela sec %u idx %d is not marked as a livepatch symbol\n",
+			       strtab + sym->st_name, symndx, i);
 			return -EINVAL;
 		}
 
-- 
2.50.0


