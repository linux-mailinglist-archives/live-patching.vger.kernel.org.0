Return-Path: <live-patching+bounces-1542-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C341AAEAB1A
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9781A188E33C
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E651725F980;
	Thu, 26 Jun 2025 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8tV2mza"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A025F793;
	Thu, 26 Jun 2025 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982179; cv=none; b=u3hCXUQGGHFDw/WPoME6SnvPzDzrlsbfnKXkGV+FBEo7DB2agG0lHikXwgFIp4kcgFk5D0eB0DhFZ69gdsWkECHNRxfVLU4Rb1LC3ZY2lQMLUKz/zcSOHKHV6N1cIcsNIKTUszGbDVisaK4L2V0REG24k9mHLCLcQL+BVT9lWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982179; c=relaxed/simple;
	bh=QAQwoFDGTO2//ydxJPnSjPdvJrw2htDOdNuFU1aeSnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ActSDJiRpsZxWKVQFkppZKJw3FCRzjzcxLkJmpt1ER/clwltwJXea9qZsu+TGTN1LDdxQLQ2R0B831xlDYUMMM/yL5IJWIJreJgvWPugOGUmZmpyj6k+y+eSc7wepQWLrJBNAjtm1kGK4hHfsi3CWtJmgFLoUEHf88X018NuOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8tV2mza; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4EAC4CEF0;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982179;
	bh=QAQwoFDGTO2//ydxJPnSjPdvJrw2htDOdNuFU1aeSnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8tV2mzas61f0+eIYuQ3STC2kHFBbiDC6WHSOjxmiuSgI9UnDX+GX3uoNqEz0iC5q
	 8xF6LxbK6nq89hehsdJpDFmyqDsQ8eQwo1D+zf8GhtPAABj2/U5p33iZixErOA1XaF
	 +PRN76usjS8LrBLZYjO3sG0D2fJZLxCH/4PKEf9CMEpUJRPYpZkrJv9D7nKEn6pDzD
	 VEFTDfTU7XHFhU7A0GOuis+x3LtbgI9VAu/8KMjrftIVbGCkyMRvdiYFiLpIAiRRQk
	 9H9gGpxwf4srFc+circKcrUsTqEiK7uA6EHatbDy1JVthYKl3wQCG+rYz8CmwN1BQ8
	 LWkjywRT85qmw==
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
Subject: [PATCH v3 12/64] objtool: Fix broken error handling in read_symbols()
Date: Thu, 26 Jun 2025 16:54:59 -0700
Message-ID: <7b7c07141dee4ebd08c5720c7fbb12a0e212a2a0.1750980517.git.jpoimboe@kernel.org>
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
index 1c1bb2cb960d..b009d9feed76 100644
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
2.49.0


