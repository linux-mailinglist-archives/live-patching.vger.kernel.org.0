Return-Path: <live-patching+bounces-1545-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B01AEAB22
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E06593B25D0
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03343268FED;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CB74pnoD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04A9267AFC;
	Thu, 26 Jun 2025 23:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982181; cv=none; b=E2yE1zjc5ctNislFjeQRcTDgHkqHKRkfLbrm6sEAR7rgpD8EN3fAR94x3mcEE/YvaB8CO9tq4uv29YVVNxKn1tUDhU9hey1tRLXvCpCxm9mgYovzqEjxO05kT+iOSAmHsk0mNcImGU7tW9niqNh68Mj6TR6i4oaxYUq46Np/iPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982181; c=relaxed/simple;
	bh=QfBHWmIVnkYafDr60dzPf4Vjy/KCp+oTkW0957LIfng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7Yz6WjKmSmmMp5Sh40AAAym+C5hXUpNUJ8F2kxTEkfRcOHNlQK40l2eLecdW0f6OCyUywRMPSOMPGk44v7FrvzJJfkbpiUBFhecP97PGYiLdLNSpN8UUWpve4jS3oblLuxhnMgJ/d+yxPh8Z++YbTHQHsGF8Vsp54Fay4Ms7Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CB74pnoD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FBCC4CEF0;
	Thu, 26 Jun 2025 23:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982181;
	bh=QfBHWmIVnkYafDr60dzPf4Vjy/KCp+oTkW0957LIfng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB74pnoDE51uJhDYqvAEFsnNqQGKo281i8tF7MrjNylE3nq+lunRo5IUjnMdmCEnF
	 857EeoGicP0KcXdyYn7rjxOfiIInlf66ejoogVSWg0OCN/WvVqfzSbNj95JApVPLBA
	 sPZANRhGIaBfCUmFj9o8eTlnQ+ZoqgKoIXjL8BFJLhafvTouMfsQGYH5znzc+7Hs3K
	 LWxzEDv0v+BvufkxWWFFS15zZMqCFWtFcCsjGX5jE9f4nUwx45sHYpEefPWZ4rnyYR
	 aeEozcZ3qwPc0GfhaxHFdDksT7TS09hocHLoB+QA+j4uDpFL4pi1xhZKHG4GJqfiS/
	 T3KokYn5k9VNA==
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
Subject: [PATCH v3 15/64] objtool: Add empty symbols to the symbol tree again
Date: Thu, 26 Jun 2025 16:55:02 -0700
Message-ID: <9e858a0ab92dbbab161920dde93090301b52470b.1750980517.git.jpoimboe@kernel.org>
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


