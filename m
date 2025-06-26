Return-Path: <live-patching+bounces-1566-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 225F8AEAB4C
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B5E47B5646
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A5B2749E4;
	Thu, 26 Jun 2025 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QA6W2fFf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD5D273D86;
	Thu, 26 Jun 2025 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982196; cv=none; b=iQ9QO3FhdgIyQ9/F+IvZGY1+TrLWU4At2Dks+ftnSub9qL0SQpgqO4pxpFhe3s/+JWKtWcRYTZLQuAfRHsGsBUdkRYe3pgk9n9ZMydbYsVXQnG7RW0gtErHXJbx0queGnfnCBeux/Rj7YOLsLzeqVr9jZbZWHsI6tLy8RSBFtB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982196; c=relaxed/simple;
	bh=g2ykIRJXn2F98taSetM8H8hBvjwsSmrWejMVYGnyZz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7GF4vi5PS4bjEcE4fOibnZoKQTOQgiAakYXpSt+nDo4fabGUDL3r2kWAgfNHzV1r6r9rSkMItUK/uUblYS1TlqggjiGD0Jxfco6oKnHQmGr+0edknA8Ne06YHMsdKviDyTBWnb7uB4dkd1+TElzLk2R54/1gg7gHkc7t3IhCAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QA6W2fFf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDE9C4CEF1;
	Thu, 26 Jun 2025 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982196;
	bh=g2ykIRJXn2F98taSetM8H8hBvjwsSmrWejMVYGnyZz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QA6W2fFfr9Klaf4bbmQ9OMGW6A5qGndZv9YMy9JijdIi60OVEL2ysyegAptejZSgC
	 iRweKK8QgvuoFhzH6sd97kzNU9AlAABTL3qgDeeslXrIzA4FadtFby0Z65ZbqLTmU8
	 IIgsgS5ZrDpqo9t5n4vG1MF3JtBY8uPfNTSYfU5T8/v14dWsYN7Pa7/BJmKAipxxwd
	 UxprnbV2sxwfMJ7SjRbZnJlApMgQQtmg0DwH0NOOmdpU/wBLgjfRk9u5WvlUBCurqf
	 x5DIC1TQuJtIK6ndACn8DB8Cf9QJuXu4NRfX3UZGSr8vA47H8b1OKndMRhWr8YD16J
	 kP99lmB6bOcQQ==
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
Subject: [PATCH v3 36/64] objtool: Simplify special symbol handling in elf_update_symbol()
Date: Thu, 26 Jun 2025 16:55:23 -0700
Message-ID: <204ebb40c041782c0f0bd6b3d082028e158d054a.1750980517.git.jpoimboe@kernel.org>
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

!sym->sec isn't actually a thing: even STT_UNDEF and other special
symbol types belong to NULL section 0.

Simplify the initialization of 'shndx' accordingly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 1bb86151243a..4e274197bcd6 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -634,7 +634,7 @@ static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 static int elf_update_symbol(struct elf *elf, struct section *symtab,
 			     struct section *symtab_shndx, struct symbol *sym)
 {
-	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
+	Elf32_Word shndx;
 	Elf_Data *symtab_data = NULL, *shndx_data = NULL;
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
@@ -642,8 +642,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
 				sym->sym.st_shndx != SHN_XINDEX;
 
-	if (is_special_shndx)
-		shndx = sym->sym.st_shndx;
+	shndx = is_special_shndx ? sym->sym.st_shndx : sym->sec->idx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
-- 
2.49.0


