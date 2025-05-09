Return-Path: <live-patching+bounces-1372-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4144CAB1DE2
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B62B1C227AE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B2726461B;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGiLurQG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D7264609;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821873; cv=none; b=RO2zU1ogITCghOf7iqYUYk7nsNcbUOrx6gDjmmRAuriimeCuI8Xxof+6w4gMmegNAp9b17k35fZxlnHQEgQ9BFjMsbky07z9IKR8/s6u48dHW4E5ED9eOFAluCGPwgfKNwgyUMPOuki2om/EY82m0RRQLo9oUtHUVwlJBZ4EYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821873; c=relaxed/simple;
	bh=QAQwoFDGTO2//ydxJPnSjPdvJrw2htDOdNuFU1aeSnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYBVdrcV+IgpfcxbEJq5iSTKKmy4qgy9ICSGwUBq1of1Q7B78D6tgu+9XmKkk65gp+HrifTuvvcg8LY8fOhQBZLInVs0rNQECXT5vwU9OOMZ7UFnKg29tyVpXNnVTDZR5sWQJIUOz1uMkSBOoQcaUfCzobeqrJ8HyiCpCdT7EVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGiLurQG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAE9C4CEEF;
	Fri,  9 May 2025 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821873;
	bh=QAQwoFDGTO2//ydxJPnSjPdvJrw2htDOdNuFU1aeSnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGiLurQGtAdJZAcD7S6o214GCLdiq9s/FPQIfqbt3AOA8GLYMck9Cxt8fy87rVyAP
	 LiWAnys0Qz2h5EfOdE8niGh/cL3xNyVSNrGcd7AsgNzMtJ0mCKXJlGPZUiaP23ZOKx
	 EpZcvJJkemhgc0kWCVASTeifE4K1eudeauTEafm0RwYO/gsHSYSsWLg/uMvPmFQJcR
	 o5chIPDRX/IkSR9uj1NoQziZV3/+omRWWgHh5ss1l2dMiI9PPdNLquAGuj3JoMe+ic
	 0B6F/tqnsgTEdLjQOJMlVKzDBz1odNK6RrIY9IXJiWANWah7hWpKKh+uBT88iSGvxA
	 2g9HmYh5XqM6w==
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
Subject: [PATCH v2 13/62] objtool: Fix broken error handling in read_symbols()
Date: Fri,  9 May 2025 13:16:37 -0700
Message-ID: <16c0fcf02cdce0b93666e853070086d5e40be0e6.1746821544.git.jpoimboe@kernel.org>
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


