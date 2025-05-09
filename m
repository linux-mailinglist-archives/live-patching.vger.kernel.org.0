Return-Path: <live-patching+bounces-1374-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3B8AB1DEB
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11E7A1C2393E
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2825F265CDF;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJvMAO3z"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C09265CB9;
	Fri,  9 May 2025 20:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821875; cv=none; b=c2OCL1XTVrHeNwMj4WXOLe7IuQWrlKKOcwJ5C08p5f7ud/jh39mvQHqgcxAG9lorpoFxFtmNWucdDAsIsUXIVdD+omhz0PnordcGWXgNqdaZ8xY/FratBkJX7dM4LWylz2+lGYC0S+XovYL6vYbr5wMCLs/4KpNnCjLhRRlLMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821875; c=relaxed/simple;
	bh=QfBHWmIVnkYafDr60dzPf4Vjy/KCp+oTkW0957LIfng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbN9vrA8G/0a+PE5PuVRXpHug2wA0PFggqyo7Cta8athfrN7qGvCKEbicBssb4bInpSinhBjeSoIIy4jBJfmBCkXCWXAKQfpx4UdessFXGWbYoc74eDfnVUi8uRV3i+Wea4eMa/Hn8hRAUpjMHMtetHsWhCMI48fyRRj1LH9tIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJvMAO3z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9E0C4CEEF;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821874;
	bh=QfBHWmIVnkYafDr60dzPf4Vjy/KCp+oTkW0957LIfng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJvMAO3zcihhCwssP6aTeWAnDn0ezcG7bxjjWGUmjAOOyykXwctuDaghCK6QMnAJf
	 EtDYpfEQOA7DPUdd5AZyBvTQpqPm8TMJYSfJkcUmTLf9hzDrleWcywvm7s+FJw64GS
	 /rzTP9qZS3S6bqlUDRzIRBMRrWeCWjRYaM7MAwmqa10q1H1adCI1/3ieqbSPlbVEer
	 ofIPMQ1Zb0ja6i9bg8p2bH5qlodgaeT4u7byBYFUmFukVUxEXcxhHOL7dZ4tIaRuhf
	 QFvPWdPOjRRm2wCr034SNxqIsd4WReQ8GgosWvX9/JVD3oBdQfqw8eHXeExc32vJYa
	 Q+RgS340OSHSA==
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
Subject: [PATCH v2 15/62] objtool: Add empty symbols to the symbol tree again
Date: Fri,  9 May 2025 13:16:39 -0700
Message-ID: <a47646ab877c2a48dc930ca02ea0a52fe4745fa3.1746821544.git.jpoimboe@kernel.org>
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
index 19e249f4783c..a8a78b55d3ec 100644
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
2.49.0


