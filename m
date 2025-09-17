Return-Path: <live-patching+bounces-1693-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA59B80DF4
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FAB4583640
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7E833B494;
	Wed, 17 Sep 2025 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyzQqZ+2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAC433B486;
	Wed, 17 Sep 2025 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125083; cv=none; b=ltmbPlqblxAZGy5SR6nzToPYAe17rSxTeijKZF24XM4qScfBaTA+kaCu44iofpQcOfSsyE1ydocXluyJL/rSXCZgqFNttDfqrVUOM3N12BwP0uGaeuFomyV+VydZiqFqk+Ur5dHBe6s6DBWpJgdMyTIt1P6CFmLQJQxrMrASl04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125083; c=relaxed/simple;
	bh=PRBPCxERgUtbuF0xmeswmTOcYV9YnIksrP1nzGFTJpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSJ+z67VL5YsUGOjDhz8XfYioAwLC2xrenn5oDPAzhUsKRV4bOVBTQl0k8l5608Dzf0vhFRIVXAFVFxIHqGaH0BRC6qefnzuc9AjbcBntd1faZQEOlqB1IRZ4u67HOj4TiQuB9+NwHwTu2N57VE7f7lM1Ps74ZygwYQMizLI/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyzQqZ+2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC62C4CEFF;
	Wed, 17 Sep 2025 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125083;
	bh=PRBPCxERgUtbuF0xmeswmTOcYV9YnIksrP1nzGFTJpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyzQqZ+24RxHlf0z5FvFWvse/rYnT38FSfK3p+ce4/gD7Z2Ar9KxNMvs1dIsQpBUZ
	 mbty+Hi9NNQ3/IILC6D0rfH+cBqAXMUolo+KJL8P0E//WVog61l1Zu1OeUfJQ881D2
	 vWExl9tX4I77sweSBCM0AFdWOrl1KqL94yfm9yCbzDEmfxLzC7eRy3NJ5LN0cfPx2F
	 FUeQe5qHNsVXq/ojU2U2iYXVqApjhEU9f+zcv8j+LE+ashJedHDYphNeCwJb2zfLT0
	 ePSmNo5sRegYLh186MEvsaGdcY7E1LlIMtSACPvOI1zG+6eVVcwZmKzClCtvSdZV1y
	 QbJN4kr2WKN7w==
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
Subject: [PATCH v4 38/63] objtool: Simplify special symbol handling in elf_update_symbol()
Date: Wed, 17 Sep 2025 09:03:46 -0700
Message-ID: <dc0b1388e7a0a25a86c2a2238e216e63066829b2.1758067943.git.jpoimboe@kernel.org>
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

!sym->sec isn't actually a thing: even STT_UNDEF and other special
symbol types belong to NULL section 0.

Simplify the initialization of 'shndx' accordingly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 775d017b1b79b..c35726a47c07c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -637,7 +637,7 @@ static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 static int elf_update_symbol(struct elf *elf, struct section *symtab,
 			     struct section *symtab_shndx, struct symbol *sym)
 {
-	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
+	Elf32_Word shndx;
 	Elf_Data *symtab_data = NULL, *shndx_data = NULL;
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
@@ -645,8 +645,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
 				sym->sym.st_shndx != SHN_XINDEX;
 
-	if (is_special_shndx)
-		shndx = sym->sym.st_shndx;
+	shndx = is_special_shndx ? sym->sym.st_shndx : sym->sec->idx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
-- 
2.50.0


