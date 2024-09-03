Return-Path: <live-patching+bounces-536-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98FC696926E
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56199282C26
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACD91CDFD8;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLjARiSH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8015F1CDFCD;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336030; cv=none; b=ZidGj+jBMIAdxtVLaFgM7xSN8EiVYTaaRD+CXZOAqNl6YdGAtJs89ylrkjFd5V7MYnucs/TtKxQcXT8+jOuM3m4vUi9UDOJFL6gAOpA0UZlrktGZ4Bj9FnzEWK/Jdq7e0YjDWL0iLcksxh0OWrJkw0uVFKIXbKYTqUp8WFp3vQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336030; c=relaxed/simple;
	bh=OdbgV1d6SagFMFieLlZ7F3BDtff8ypL3ANe3ldIaiP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baHn0axhe2l1LQup4VIG/JjMeFAS5zzGezsaYE1UmeAnszXcuRfSrcG9rHUeTABcTdRO6vgEimQWwW4TwdC0Bzh04mdXamft45rIBpgfidxLNZmLEgh+85PlhJiDMuQiiQwvEYfb1uBY1mgRO7boz8uAc5WfsRl2hLKgmURA0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLjARiSH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A014EC4CECC;
	Tue,  3 Sep 2024 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336030;
	bh=OdbgV1d6SagFMFieLlZ7F3BDtff8ypL3ANe3ldIaiP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLjARiSHag+1IRFGydMoZumBS5I064mp+8QcARiPbQp6p79PuL0YJox2Mcqlf4YxU
	 ne8H9PlSTx7FlVW2A5e2+UWJMw92YBK7er+t2bC0jypAwI4kvRVU/EajhVKUe1s/Uc
	 1jnKaUZkNUEvBTqiKEgQrdymcx432i5RXNfEeZ5c6tuS+TtKyJCdg74V1q7dCELF2f
	 gOEqgP0rcR7U0i3Pd8PWKqcsd5d0X+6bfN+BlSfaikZZIX5KquLAvL3gzfRytC/MCl
	 O9dzo9Sx9yeQ7ZuOFhx7S5UIHsS53gt39DHNrjREEq5WdwIWBIINobKOfYHIxRrkVQ
	 44TfmqWLWpsgw==
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
Subject: [RFC 02/31] x86/module: Improve relocation error messages
Date: Mon,  2 Sep 2024 20:59:45 -0700
Message-ID: <0e89228c265405d9125a3630c127b51d04f80232.1725334260.git.jpoimboe@kernel.org>
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

Add the section number and reloc index to relocation error messages to
help find the faulty relocation.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/module.c | 15 +++++++++------
 kernel/livepatch/core.c  |  4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 837450b6e882..c09651691dd6 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -96,6 +96,7 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 	DEBUGP("%s relocate section %u to %u\n",
 	       apply ? "Applying" : "Clearing",
 	       relsec, sechdrs[relsec].sh_info);
+
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		size_t size;
 
@@ -147,15 +148,17 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 
 		if (apply) {
 			if (memcmp(loc, &zero, size)) {
-				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
-				       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for sec %u, idx %u, type %d, loc %lx, val %Lx\n",
+				       relsec, i, (int)ELF64_R_TYPE(rel[i].r_info),
+				       (unsigned long)loc, val);
 				return -ENOEXEC;
 			}
 			write(loc, &val, size);
 		} else {
 			if (memcmp(loc, &val, size)) {
-				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
-					(int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for sec %u, idx %u, type %d, loc %lx, val %Lx\n",
+					relsec, i, (int)ELF64_R_TYPE(rel[i].r_info),
+					(unsigned long)loc, val);
 				return -ENOEXEC;
 			}
 			write(loc, &zero, size);
@@ -164,8 +167,8 @@ static int __write_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	pr_err("overflow in relocation type %d val %Lx\n",
-	       (int)ELF64_R_TYPE(rel[i].r_info), val);
+	pr_err("overflow in relocation type %d val %Lx sec %u idx %d\n",
+	       (int)ELF64_R_TYPE(rel[i].r_info), val, relsec, i);
 	pr_err("`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
 	return -ENOEXEC;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..76ffe29934d4 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -219,8 +219,8 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
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
2.45.2


