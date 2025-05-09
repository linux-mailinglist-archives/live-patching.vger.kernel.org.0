Return-Path: <live-patching+bounces-1376-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5432FAB1DE7
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53D9B7A8696
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FE1266F0A;
	Fri,  9 May 2025 20:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r3fsQtlm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C5F266571;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821876; cv=none; b=lFIt4JxRFp0VoeGPkyCqvFwj/mbBFtPvZt/PBbks+xkyYuXC5DRCrn2SQo3MsnTwekSwg1CMJh6yVB6HewQBXzYb6vMZbz3uuy6L3nfzSPO0lvd4Z3Mmw29Zdv8eiQAFjfpa2ertxLzaDTC4bd2pvYaPkdiA+rFJJoDCFXJzKkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821876; c=relaxed/simple;
	bh=eyn64xsGzqTLQ6AHxWV/CsAkWUQ+4wmQ1jaSVqhPaww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdk4kVMRAfRAdFW6v8/GIjAycMzH4ZjORMna3r3FF0lVoclmhZJ+g06WhfizcY0V4sUXQK8PTt9gwNMidcePm0FbtXn7WlqyXMWkkrq61SbqUv9NnqQTGLeRATJv2Jk1bCDIbE7+1yziHVdAWo44U+uIF1Bux+dm3daV7kdsPGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r3fsQtlm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFE6C4CEF1;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821875;
	bh=eyn64xsGzqTLQ6AHxWV/CsAkWUQ+4wmQ1jaSVqhPaww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3fsQtlmH6G+qIm9AK2vYC35+WtESG6CJNtRcyxGAAwc0AK0PwQO1vp6SF1gJg9sj
	 ZNREa/t6MsS5n6flp8uJuFT6MKUjwG48ZWaMJu5yCniuJ4eoTLM6a8HyybBwLzKGaV
	 1GReDUg3iUeD1HTRlEEX9VDyowJlM2jxYNGRRsQrMeEuM/fdIojASz7z/v58cznhXV
	 7rOdZ9XwzSGS37IoPAl3sWYKL3tFH4e1obmrLPYkLFBYLZkRs+alKchSEQMUuHX03Y
	 Ujz3VshZsyLhHxywL+nrCF/7xKaJPuOYI8ly2YSE/ys3IYIrq9dpduvz7n6TXJ/3sz
	 DBZHZ87wrMssQ==
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
Subject: [PATCH v2 17/62] objtool: Fix weak symbol detection
Date: Fri,  9 May 2025 13:16:41 -0700
Message-ID: <78dc6f9015f7aa8e37b7ce3cebd1a3b899f93e38.1746821544.git.jpoimboe@kernel.org>
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
 tools/include/linux/interval_tree_generic.h | 2 +-
 tools/objtool/elf.c                         | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
index aaa8a0767aa3..c0ec9dbdfbaf 100644
--- a/tools/include/linux/interval_tree_generic.h
+++ b/tools/include/linux/interval_tree_generic.h
@@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
  *   Cond2: start <= ITLAST(node)					      \
  */									      \
 									      \
-static ITSTRUCT *							      \
+ITSTATIC ITSTRUCT *							      \
 ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 {									      \
 	while (true) {							      \
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c024937eb12a..d7fb3d0b05cf 100644
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
2.49.0


