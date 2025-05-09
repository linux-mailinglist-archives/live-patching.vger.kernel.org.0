Return-Path: <live-patching+bounces-1362-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFA1AB1DCD
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88F0F4C6BFE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B66F25F7A9;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDfdI0+3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE3925F79D;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821866; cv=none; b=VIC/uChrvXQNWBCO4j48M1ZkB2tDbQ2OGKN+a+YF5iYx7GZaZuStX7HS7rWsFbYQY9DuUKWrFBQsh8nsMVnV2WQRk5vWm4SClLe9Lr9TkKFhZiKzj3dw4mLyyeZI8xSYRI5tKfVIUFSNGbVJsyOcGfEOdC2mS7LcKEdattMq3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821866; c=relaxed/simple;
	bh=YunupWvf1Grsy+KVLlB9E51u4IP/VSauVQ+LZWaBxJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy93DeKOTBavmVUyf5T3RW6WoDPztpiaK5XbIdpszSLbmMx45TmgToDshuLtJ9UIuWfFVvo2/YT5lxg9/i0BbYGuzkgByNmzXa7nji4JL/hxsQSwGfmVbZNXeSq8M7CjsDrA+pLnHO6+cKtpZ/Zjyh+/qYn6SUY8QazXJeWXc+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDfdI0+3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E88C4CEF0;
	Fri,  9 May 2025 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821865;
	bh=YunupWvf1Grsy+KVLlB9E51u4IP/VSauVQ+LZWaBxJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDfdI0+3vErMoqOzN3uzoKfgVhhuL/5JPZHkZLKWF4yAHc1Eu6JF1hQstNDdwyRAC
	 f1cRJR4S15YMN0RvmeFQUwcNctvcmP7CMUFrtduMNMcHywBY749HUxj6Ze31BJp1Mb
	 DZeJm4z9NC8cXCnRg001sOQ5mHQXoI9loZHnF7WRUYaOkX9zinrg02HgnPk7/zk35N
	 u+db1icUbfWAtjy7YgB3Uj+PXgUSBunvJSi0Mivgyjfbi79RywgTam4I0Mr07RHZzx
	 AV8z9bShOBLqbg21Et44rq1Xe7ebNBgKBtTSZaedP8OHVGRZElKCzonOocjyJ9liVU
	 dJCVXJZAWfguA==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 03/62] x86/module: Improve relocation error messages
Date: Fri,  9 May 2025 13:16:27 -0700
Message-ID: <9a93844560bef1c6c5aa3121c454fc32316bb120.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
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
index 231d6326d1fd..ff64f3c6642b 100644
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


