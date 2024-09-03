Return-Path: <live-patching+bounces-556-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86396969294
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B966D1C225CF
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD571D6784;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D580FoCP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922CB1D61B4;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336040; cv=none; b=BdQoZ71+yIJBGSym/wr5nlSCfDu2r0/WT66cFL/Ln7akF8uvPwup1GjvTZ+O7GQggI0WWwn0b7/C26nD2rSjc0GWOutILe5pkpa9Xnp1+f3L+QRrlrkdAfKFcZjQ/ZfuDkHJ36HzYfPKeyDC2tTIVnjQm1CSwXO+24cek+OrpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336040; c=relaxed/simple;
	bh=K51ZKKek6YNwqc2KmzuJq5BxCeSmLBBJ3r1dJblKcf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umhWJP0CqX7W0jOMetjdd9j5hzbXepOc0Qjzd5vf3dL/i9rNU9OD2H/CJYGHjvixAi/p/2Srd3ExzTpZyLv4h4wp/Z6Jj59inae+6jqG/1Q6svJhAx/ADp6ZxjrWhRSU1i0ZY9aEGhRwGfmPp8H5CL4hJ6tWBl98VM7287tUzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D580FoCP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194F4C4CEC7;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336040;
	bh=K51ZKKek6YNwqc2KmzuJq5BxCeSmLBBJ3r1dJblKcf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D580FoCP7B1SrYC6jLwS/tc6+JhsvVMSsPDF9QUluKX/ENwtHXVIERXvCuUEASrsk
	 tOk496q0Q3YpG17t4wD1I8pHxAmIhL1LaPEUsN0SjDeDXwIhg9k+T8vjUI7fc96dZI
	 XEo9+Ds4UeEBd1WJPDfgnXW9kpLdSb1cKmLR2mipGF3+/FthrA+bd+nqMibdrIEzyB
	 YzoOEYiUjRIlCcwYHLXhXS/usqNHwvoLYqSo7DXFFhKVaPs75/CcnR8diEab2vKqxv
	 QspsXpCQ+gbHqCudddoIe0xbKjTGQ4GlhIOgAuc/roiBMPcZgkCdCPe2YJRu7iNEtH
	 dfSuQWpZ0cTrw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 22/31] objtool: Make find_symbol_containing() less arbitrary
Date: Mon,  2 Sep 2024 21:00:05 -0700
Message-ID: <aec794961ec4bea48d47b4ff8da33072c3eba31f.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the rare case of overlapping symbols, find_symbol_containing() just
returns the first one it finds.  Make it less arbitrary by returning the
smallest symbol with size > 0.

Eventually we should consider making such overlapping symbols illegal.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 7f89b0a99886..49528e7835aa 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -195,14 +195,29 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset)
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset)
 {
 	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
-	struct symbol *iter;
+	struct symbol *sym = NULL, *tmp;
 
-	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->type != STT_SECTION)
-			return iter;
+	__sym_for_each(tmp, tree, offset, offset) {
+		if (tmp->len) {
+			if (!sym) {
+				sym = tmp;
+				continue;
+			}
+
+			if (sym->offset != tmp->offset || sym->len != tmp->len) {
+				/*
+				 * In the rare case of overlapping symbols,
+				 * pick the smaller one.
+				 *
+				 * TODO: outlaw overlapping symbols
+				 */
+				if (tmp->len < sym->len)
+					sym = tmp;
+			}
+		}
 	}
 
-	return NULL;
+	return sym;
 }
 
 /*
-- 
2.45.2


