Return-Path: <live-patching+bounces-1669-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA66B80D7F
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 472817B8F53
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFF72FCBEF;
	Wed, 17 Sep 2025 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8NXzAi0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FAC2FC893;
	Wed, 17 Sep 2025 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125066; cv=none; b=PVZM1MFfu+/ler6wUtALwTsU5FkdyBnSTAKZEifTCrJbhexFb5mzAm6F8WofJqvEnjWc93tfbaw4j0d+pfeGOWpK9TMWjpgyAuqAHvuXeBF07go12BLegDTW38J7YaPDBwPX9RL0IXD3FuqjraMWR6j+xkj49Z5gUghbMJOepoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125066; c=relaxed/simple;
	bh=UAC7YfOY8kDiTF/m9XxVFIYLjPWX7E0ESYXVEJ+Kn1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8F7cIc7zGvdEZ4A+qbzAxkXbquGTR/k0pZQqRsu1wdgYAh918r7DqJm/BM4GwE5jp7SDszLhJmJD9t7sKH08ZjeCXYeozb4xA3UCvoNY8I2VnQ1KOgWpX9YJqaD74TtJtAdhgTW4Bg4pTJ+TqLK5biR2bhH+lCu28MrLaH7kME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8NXzAi0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A377DC4CEE7;
	Wed, 17 Sep 2025 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125066;
	bh=UAC7YfOY8kDiTF/m9XxVFIYLjPWX7E0ESYXVEJ+Kn1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8NXzAi0LzMDTXP7B54IAoZHfTuA0hGLA9mKZhKPGto2nJS7blwtASfAyP1gGEGcQ
	 Ih9YbZlnr+/JESXMlTpBsr/hFmfC+SYKwFubvEV9l/qQCKZhQlwTOhlRXhOdwOMir0
	 ntqesYTyePYKevss8ll52e1gcibVFAwXf86FQRIg1ongMl1D1CarzqyBynM3mktnoa
	 jSckt487xqLttKWn2mzStx5UIUV96eGj8VirwPz4Z1hptPAhXTmZ43vTjQ0kztCGws
	 Y7WD/JF6YsROYVHXJO397nnbg2E20RLOsLhLLhipYML8AIWBqs2yUyuVgPCONx/YrH
	 bQUou5xVOQi9Q==
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
Subject: [PATCH v4 14/63] objtool: Fix broken error handling in read_symbols()
Date: Wed, 17 Sep 2025 09:03:22 -0700
Message-ID: <842152d67abf24d2b4f51eb7286c86d19639b06b.1758067942.git.jpoimboe@kernel.org>
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

The free(sym) call in the read_symbols() error path is fundamentally
broken: 'sym' doesn't point to any allocated block.  If triggered,
things would go from bad to worse.

Remove the free() and simplify the error paths.  Freeing memory isn't
necessary here anyway, these are fatal errors which lead to an immediate
exit().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 1c1bb2cb960da..b009d9feed760 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -492,14 +492,14 @@ static int read_symbols(struct elf *elf)
 		if (!gelf_getsymshndx(symtab->data, shndx_data, i, &sym->sym,
 				      &shndx)) {
 			ERROR_ELF("gelf_getsymshndx");
-			goto err;
+			return -1;
 		}
 
 		sym->name = elf_strptr(elf->elf, symtab->sh.sh_link,
 				       sym->sym.st_name);
 		if (!sym->name) {
 			ERROR_ELF("elf_strptr");
-			goto err;
+			return -1;
 		}
 
 		if ((sym->sym.st_shndx > SHN_UNDEF &&
@@ -511,7 +511,7 @@ static int read_symbols(struct elf *elf)
 			sym->sec = find_section_by_index(elf, shndx);
 			if (!sym->sec) {
 				ERROR("couldn't find section for symbol %s", sym->name);
-				goto err;
+				return -1;
 			}
 			if (GELF_ST_TYPE(sym->sym.st_info) == STT_SECTION) {
 				sym->name = sym->sec->name;
@@ -581,10 +581,6 @@ static int read_symbols(struct elf *elf)
 	}
 
 	return 0;
-
-err:
-	free(sym);
-	return -1;
 }
 
 static int mark_group_syms(struct elf *elf)
-- 
2.50.0


