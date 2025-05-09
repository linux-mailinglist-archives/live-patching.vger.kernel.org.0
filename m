Return-Path: <live-patching+bounces-1395-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 143A6AB1E15
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4EAD50060B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE07A29825A;
	Fri,  9 May 2025 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrY2HN0C"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6457298253;
	Fri,  9 May 2025 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821890; cv=none; b=UN30cq3gWsev2NWDB/+xx1nQG7nNhBnaStwsfZoBT93ObG2gJL1XaYeWf/1Q58FKqXgbVfOEVcmWPpmdtgMh3s1xR0KpGkPf0QdXan2ojIhYPG8L7Vfc37QX/x7KMK7vbHDWuhb9LhorGFv4kkFPALWj36mK2YWcHzPxki1C4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821890; c=relaxed/simple;
	bh=z4MYmIyWMxc7ZB5anV6CPYR4FLSO8k77Eu2uXj6imDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV8QX+7uz5smAmtuUN+92x2b5hdePGvHzSqEn8RuWCidLea/8tihxb+t1bblM2AX4FVtolLZOxXbTivcW0kDAmL4qM0DC4n+O7EB9D1VKxECLgHRWtS/gF57oVeZFxmTW8JIv67mx1acKvaOqTXOMON2eblIfoW5h78oEQD8ZTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrY2HN0C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3E2C4CEEE;
	Fri,  9 May 2025 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821890;
	bh=z4MYmIyWMxc7ZB5anV6CPYR4FLSO8k77Eu2uXj6imDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrY2HN0CxT8sA/PhcO4YeRnnl/EAZjGwNJ61iNF4bWOD49MIfdYboyxLj6pLMjtXC
	 ha/c5qeglSI9DDBkuoL/n9sAcL0RvHiJPDoT47ffUBQ+lYJLszpqrq54zFW1QMq4DO
	 00OcsLQb2BSuHIpkrLFB5K+ZWaFXD0jdvCRO9eojdsTGdXbXDOj6NYEciMsQZ2oW9m
	 P7CBoXfJzg6N+W/6/xyd9XT7GR7d9wFouWgz2qM5suZ/efoD5m4andPsyNipJLgJa6
	 LDfx8GCrEXFNYS9nPMsBoy0bFk3qXDOf5hebpAwi+QrjNJ2M7MRCH+3RcCNPtIGxxb
	 UxiEgBYJln7EA==
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
Subject: [PATCH v2 36/62] objtool: Simplify special symbol handling in elf_update_symbol()
Date: Fri,  9 May 2025 13:17:00 -0700
Message-ID: <8026f424659bc6a9b1b90ed88b1d377d80a8e0b0.1746821544.git.jpoimboe@kernel.org>
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

!sym->sec isn't actually a thing: even STT_UNDEF and other special
symbol types belong to NULL section 0.

Simplify the initialization of 'shndx' accordingly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 9a1fc0392b7f..859d677e172c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -635,7 +635,7 @@ static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 static int elf_update_symbol(struct elf *elf, struct section *symtab,
 			     struct section *symtab_shndx, struct symbol *sym)
 {
-	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
+	Elf32_Word shndx;
 	Elf_Data *symtab_data = NULL, *shndx_data = NULL;
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
@@ -643,8 +643,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
 				sym->sym.st_shndx != SHN_XINDEX;
 
-	if (is_special_shndx)
-		shndx = sym->sym.st_shndx;
+	shndx = is_special_shndx ? sym->sym.st_shndx : sym->sec->idx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
-- 
2.49.0


