Return-Path: <live-patching+bounces-1533-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DEA3AEAB07
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AF163AFFA8
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0FA22D4C5;
	Thu, 26 Jun 2025 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA94Od6F"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2012D22B8D0;
	Thu, 26 Jun 2025 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982173; cv=none; b=DbRbnKxqwMaXtrPIGo0o5aGjLMMt4XItTzAV4RBl8+R1n0kO2sTNEydiU+C4kww533gdid4h3DrCK2nkyCtSqzmydGpf82hI4oargDnX3ZL66eXeVeixnReeO6pYtf1BlX/8m/fbH0teFV9BEr49oCocWgkZKFqSkR4vLN3Ajko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982173; c=relaxed/simple;
	bh=wI6EQsCuLuHHdOGXRztbTp25t3w3fj2/pmoQea516xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV7snU1oqrjuolaadM5PUTVf5JSXADObbiuJsmGmve9roR7IwJjnNX46OPyv54szu6hciXh1LIVmYbE8021fCJWXV2A2wzSZ/ciS2ckFd3hrBT4EPiy+k66aV9Bu57QY/cWLiyZdI7EOOq5BiFdCXPE/k5epcU8I+y2LmYCQM9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA94Od6F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEDEC4CEEB;
	Thu, 26 Jun 2025 23:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982173;
	bh=wI6EQsCuLuHHdOGXRztbTp25t3w3fj2/pmoQea516xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA94Od6FtxSapviR46R0HZcuu3Ew5kgcPWCb3+NjSGYXAJtrbvAQpePOdlsTs91xR
	 yq3xx2qF8nCxhx6SH7eac9nM3008SHeXwkTTzo/tE4w2U3Ku5D2mNnHhPA/yCHtNlC
	 8W6l2DrbADhLWBO9tH7lkxXkssqTj823W6SfjSr2ZDYEctGpdCdfgGfNPh9eRwhhQY
	 eLyJPm2yNl6Jp98dxiuY5adI/Nk/ltJUrLJ9sZDqz508pI2lf1wD+lAqtVDsuxzF+k
	 qT+v9PkRduAraPne8iGoOKp3tgfawVbZae9bjbdNm/jJm9Q+0Jkw7UGFw3cqxNzZ+Q
	 gpaM1ZLfvgusQ==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 03/64] x86/module: Improve relocation error messages
Date: Thu, 26 Jun 2025 16:54:50 -0700
Message-ID: <338c7914256a8b208d77291d65368cb5ef6e464b.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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
index 0ffbae902e2f..11c45ce42694 100644
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
index 0e73fac55f8e..7e443c2cf7d4 100644
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
2.49.0


