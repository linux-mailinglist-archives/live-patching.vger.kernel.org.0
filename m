Return-Path: <live-patching+bounces-1674-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB7EB80DB5
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1B8541DF9
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162FE2FE565;
	Wed, 17 Sep 2025 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8mirm2a"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34082FE077;
	Wed, 17 Sep 2025 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125070; cv=none; b=uLX+gnFP5SLmagodQogi/sULFbvatC65PvqZE6HzRjqd5WpeCInpfJIQ8G756PMflaFtmLJHt5p886tBVwXHohI6P9BVxzf69u9KySh40CZjxx7DfLdLuDEhcXnrGCIx1Fdz/mm7gL/7utp+zVjgO/u+IEl01hBYdTIgxPP+pP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125070; c=relaxed/simple;
	bh=fqNYx9+NO/8GphX8rTDKtMRJSZgsgsbDmbQ0J4YjN5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c26pBiLi+kcSUu2/1bjaMF8cM1Jckr18NmzpyLviolgvUJWQHnd3JCnm1rl8TwKaMo5Bzz03kZyhbDSNtaFlrmpQCmsftGtp+hdBQA8njyyndaWRQm9Yp6LKgYaaxkyp4h5rBAD2rrlgKxHbEPKfHHEZ97+N6di0thO8rFlC3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8mirm2a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9BFC4CEFB;
	Wed, 17 Sep 2025 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125069;
	bh=fqNYx9+NO/8GphX8rTDKtMRJSZgsgsbDmbQ0J4YjN5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8mirm2a0Kw7AQWpEjx8vokEq/t1WDwcaDwL6F4vhwLQ7lk4LqYLoJdETItnKnhmr
	 bk7I2KOE6dVrFCuRuinCUtdFW8cLPmlL70x/VXihRodpbBmF79IehP3gl/ijKgB0UM
	 0MrUvKPYlg/KJ5fMHkzDrB7rPb4FDEDVzUuFii3pMqwsM7bHX5SHrRzhrjU4BCZQbH
	 hCfdhiNsaXzxxV7mrAeMlUGVEelhRa+4AKM4iNMuyLIDLqK8jsMhrkYS1EnuCNIO7Z
	 pdqtywGHZXRpLR8MYpkRf1Sg1akX+0ySdzRAkFdz2AKnzZfO6WOXP3BNnhamhChlEF
	 jXQslMeHgyXRg==
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
Subject: [PATCH v4 19/63] objtool: Fix weak symbol detection
Date: Wed, 17 Sep 2025 09:03:27 -0700
Message-ID: <e6667f985a2d93db64f24122822ea1ca95409530.1758067943.git.jpoimboe@kernel.org>
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

find_symbol_hole_containing() fails to find a symbol hole (aka stripped
weak symbol) if its section has no symbols before the hole.  This breaks
weak symbol detection if -ffunction-sections is enabled.

Fix that by allowing the interval tree to contain section symbols, which
are always at offset zero for a given section.

Fixes a bunch of (-ffunction-sections) warnings like:

  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x10: unreachable instruction

Fixes: 4adb23686795 ("objtool: Ignore extra-symbol code")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c024937eb12a2..d7fb3d0b05cf1 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -109,7 +109,7 @@ struct symbol_hole {
 };
 
 /*
- * Find !section symbol where @offset is after it.
+ * Find the last symbol before @offset.
  */
 static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 {
@@ -120,8 +120,7 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 		return -1;
 
 	if (sh->key >= s->offset + s->len) {
-		if (s->type != STT_SECTION)
-			sh->sym = s;
+		sh->sym = s;
 		return 1;
 	}
 
@@ -428,7 +427,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
+		if (iter->offset == sym->offset && iter->type == sym->type &&
+		    iter->len == sym->len)
 			iter->alias = sym;
 	}
 
-- 
2.50.0


