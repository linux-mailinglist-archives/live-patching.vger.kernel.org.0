Return-Path: <live-patching+bounces-1547-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC114AEAB24
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 277D417004D
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DB126B776;
	Thu, 26 Jun 2025 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2AGTTBr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6C26B767;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982183; cv=none; b=aqRT+4hxCBawNOiWl1yvqBlkKK9cu8hGHN7fJrc4uX68Vb+nHEk6DFG4X2qc8luSTOQyKlrDtrvOPmEKCDVKChvtlunYrfxbv/i3sWs05x+loWsci8suOozNqq+FR2og58ZuF6eHbRX6ppGyMWnq0j/cWwvvANyfgXDKLsVuR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982183; c=relaxed/simple;
	bh=eyn64xsGzqTLQ6AHxWV/CsAkWUQ+4wmQ1jaSVqhPaww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQCu3lMKZQDQEcVIydAl2i4pjeuy55FImVHg5auBWllsO6TI61xBHliQYXlz3e1btljxNiQOFGpD5zbM/Dfu+p7vMj2vEOj7IALkybOlA4x3JD9IlsWtKTk6UJr7p5WK7emKfe+YF0P6RTP6YypijtqiOr+j9+8+zop4kyKxh0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2AGTTBr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4599AC4CEEF;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982182;
	bh=eyn64xsGzqTLQ6AHxWV/CsAkWUQ+4wmQ1jaSVqhPaww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2AGTTBrmYKl9DafkBT2k6OJieetdUDmMgRtXooGZB8IxRzrI85j0JRjPdvjwBoEa
	 NDZRGhosqNPCSSZZKxOl5AencTgBGSui8I6dtLssM5wTTLRRENM5GI4CR48ptx/4Nh
	 iiE8ZXQLcCwarYNta1oJ1gJvCuwgWSwsVwGexprL6QCYuT7l9b0IW/dgv4ckVx6Ro8
	 2JmCgcutHozuBN/sp0AB9iPSHGDam4JmVvZLEebG2/48TizSoeZxF55+ymJ633VgFA
	 U1n8yCOpFVbUXlkpD14u1Gx+LnQ97KnQTYMytujyaHk3mxgDn53Okp2Tlq6UOJOnlp
	 EhPszFl7w959g==
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
Subject: [PATCH v3 17/64] objtool: Fix weak symbol detection
Date: Thu, 26 Jun 2025 16:55:04 -0700
Message-ID: <19b1efe3f1f6bac2268497e609d833903aa99599.1750980517.git.jpoimboe@kernel.org>
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


