Return-Path: <live-patching+bounces-1672-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70022B80D7C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD694622CC2
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD1A2FDC44;
	Wed, 17 Sep 2025 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLsAkrXV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735C02FDC31;
	Wed, 17 Sep 2025 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125068; cv=none; b=UujPkPyTe9P9YI39/ZGi19+DeRPbVLRwlGKs1LKUqWXWsTwXgIyjkRyuHPsYpB6F8VvVrZVJp90bXmMsJA/4J4gzvg2MUWWvyUDrj93Jn3ADGUN+pU7Tsd8kDWeylI/UDTCLHFWt3lRuluF2THn2HOotrAiO5ayOdqhVSDCkVsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125068; c=relaxed/simple;
	bh=efn2p2Wdr/0ie3I+NtGudTFtupmrBjPNApuuCg4PIjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M90bFu2mKkdLSNa90TxpLz/eYBZpzHFonUqUeweUOqvILbdkNWnpDz7v+UrYp2tF3rfzcPJez6EXtoiysLu1tek2NxgZC0YEE9DUQMfMatk2azb59oM6hLdCECIsO4VQzKu9U5VS8p/cOgLhxpE7P3UdG5vHVcMfPhSrx3FrzCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLsAkrXV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DC7C4CEE7;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125068;
	bh=efn2p2Wdr/0ie3I+NtGudTFtupmrBjPNApuuCg4PIjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLsAkrXV+Ys5YkS4QIKM4VRoS0LvX7ftsoHTOq3vb1HL40JR4GWKptLSQ0F8ij1LU
	 glTKo8KfHVKkSUko2E9f5YPPftV9IrHyvuGlb7+8/WXb4N+f/Jl/li/i3GcIgUqAJ3
	 9SW79OBSlZlYGfM5L1wOTqUPB8+j8I1/6Pf1+TcOz3VbM/XW6SUzl0TAPX+QBiOfFy
	 Kdi5lfpqRLz5fie3BHeigtyCOjFs05ZEaPaFJ310TLdhRGEJZ81Fkqs3CNUyBPXjY0
	 +YcKneF66d9tGjI9WGYibPwm/sM86iYGwmk5XXq4BZwf9EvgJHUMHiq5Nl0goUBVVC
	 gBh75OySkUxQQ==
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
Subject: [PATCH v4 17/63] objtool: Add empty symbols to the symbol tree again
Date: Wed, 17 Sep 2025 09:03:25 -0700
Message-ID: <457c2e84b81bd6515aaa60ec8e9e0cc892ed7afa.1758067942.git.jpoimboe@kernel.org>
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

The following commit

  5da6aea375cd ("objtool: Fix find_{symbol,func}_containing()")

fixed the issue where overlapping symbols weren't getting sorted
properly in the symbol tree.  Therefore the workaround to skip adding
empty symbols from the following commit

  a2e38dffcd93 ("objtool: Don't add empty symbols to the rbtree")

is no longer needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 19e249f4783cf..a8a78b55d3ece 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -96,7 +96,8 @@ static inline unsigned long __sym_last(struct symbol *s)
 }
 
 INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
-		     __sym_start, __sym_last, static, __sym)
+		     __sym_start, __sym_last, static inline __maybe_unused,
+		     __sym)
 
 #define __sym_for_each(_iter, _tree, _start, _end)			\
 	for (_iter = __sym_iter_first((_tree), (_start), (_end));	\
@@ -440,13 +441,6 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	list_add(&sym->list, entry);
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
-
-	/*
-	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
-	 * can exist within a function, confusing the sorting.
-	 */
-	if (!sym->len)
-		__sym_remove(sym, &sym->sec->symbol_tree);
 }
 
 static int read_symbols(struct elf *elf)
-- 
2.50.0


