Return-Path: <live-patching+bounces-1559-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B22B7AEAB3E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F5664E3A1B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EFD72737F7;
	Thu, 26 Jun 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZU3dBkR/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360712737EF;
	Thu, 26 Jun 2025 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982192; cv=none; b=dsAQmXpha+oCRaSF+alVxnQijlwE0fsQnj6WD82zQ5n3n70euvb1NPFoIxR1uPAx25/xUjbq1dcnsPPapUJShXwsipuxpOgz6OFBpbY9/9lZ8upJYQ2Kw2X3FCyCO1/UoWwvdjRl5fLgSDENzjnIP+LTGv+nt4xcgOfc9RLtdqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982192; c=relaxed/simple;
	bh=wByVRzEIawJ1dJ2bJAV8lZbrPTb1ty/xmOOvWpWBaWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGKdUVz4bUGj3oMb13+PLdU1KagiID3y1qSX9s8in6TzW4RloZGlP2sX7/DULvXI0bc7F+Ogi7TiLypVpU8huxvsqUcKiSu51TwLrHXJOkhU200PX7eKYkOLhQG72/q3mOJboEQ5iz+Ag8KxzTBEjsQ76SlmpqPWRhNAZxnKQFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZU3dBkR/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40765C4CEF2;
	Thu, 26 Jun 2025 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982191;
	bh=wByVRzEIawJ1dJ2bJAV8lZbrPTb1ty/xmOOvWpWBaWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZU3dBkR/GqML1dI9+8ZMAE8uG77rCVYxoh5yEb9sRY4LiHRFb74gmXC1nr/45NvhJ
	 lEYDaoj8TF+iPI23RDEmuc76rPQ6uvv+ZJroEwQcc/bWLY9HbQLdC3dYCMxdLBF2Wq
	 9Cx4liLugD2ETt+nR6t2xY8Gh4Nk1A+vfA5l82z3w0HoLOEOkvUQw2/5vmm3O5nxgA
	 goCb75FqdQDou/pWpaLz48BdtnJIOZ/v2MXdcjAuuPNGNbsq/NSON/tEq/fGhSKZwd
	 EKnJ3OmubPxcKvlNmoyo5WGaIYj+JHE4hSvuTxdiyXaAtUwPH3H1mhXW122fC5zB6B
	 KbjM8rEDfGN+g==
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
Subject: [PATCH v3 29/64] objtool: Mark prefix functions
Date: Thu, 26 Jun 2025 16:55:16 -0700
Message-ID: <f277ca3e78d662268d6303637b1bba71c2a22b1f.1750980517.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, introduce a flag to
identify __pfx_*() and __cfi_*() functions in advance so they don't need
to be manually identified every time a check is needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 3 +--
 tools/objtool/elf.c                 | 4 ++++
 tools/objtool/include/objtool/elf.h | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 80bafcdb42af..55cc3a2a21c9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3564,8 +3564,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
-			if (!strncmp(func->name, "__cfi_", 6) ||
-			    !strncmp(func->name, "__pfx_", 6))
+			if (is_prefix_func(func))
 				return 0;
 
 			if (file->ignore_unreachables)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 59568381486c..1bb86151243a 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -442,6 +442,10 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
+	if (is_func_sym(sym) &&
+	    (strstarts(sym->name, "__pfx_") || strstarts(sym->name, "__cfi_")))
+		sym->prefix = 1;
+
 	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;
 	sym->pfunc = sym->cfunc = sym;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index f41496b0ad8f..842faec1b9a9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -72,6 +72,7 @@ struct symbol {
 	u8 frame_pointer     : 1;
 	u8 ignore	     : 1;
 	u8 cold		     : 1;
+	u8 prefix	     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
@@ -229,6 +230,11 @@ static inline bool is_local_sym(struct symbol *sym)
 	return sym->bind == STB_LOCAL;
 }
 
+static inline bool is_prefix_func(struct symbol *sym)
+{
+	return is_func_sym(sym) && sym->prefix;
+}
+
 static inline bool is_reloc_sec(struct section *sec)
 {
 	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
-- 
2.49.0


