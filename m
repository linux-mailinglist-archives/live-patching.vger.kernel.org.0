Return-Path: <live-patching+bounces-1387-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5EFAB1DFF
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E71EA07CDE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9370528ECFB;
	Fri,  9 May 2025 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKJV+B3B"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0EF28E59B;
	Fri,  9 May 2025 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821885; cv=none; b=EzQEm+AMPbwDLrblywMoD3bmaJ+K5d8NjSS5eevQ8FrzfwAoASBtb/g84Jgf9vRCZKDUSUWJivqtXKAbsWZkCjyGRMXDKgooRHd5TQQ45B2zzX582MzMBETCx6BLxwb23xHG0wQD89xy2I1M5PFjbR1PkMaQWF+ivpUrQBIR5IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821885; c=relaxed/simple;
	bh=1NbDwtOv3dS3yl1dXnXeu8RsvtrlV1MtT1kj2eujlVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIY8AK3s7J2ZeMpuNNi2ymasiS/4xXmE2XZa6RkNYnhkruMT4fZdZBTJvl/KsFo3MtDBYjo845X/VlBdIUYZKbcY7t2c7H5YsAl0Seouv1ZUgD3nohBETaE2g+0JYyd2NEKBwrO369BpDVNJz9ce253gptaL/nuJQ2aVEIBG2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKJV+B3B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD06BC4CEF0;
	Fri,  9 May 2025 20:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821885;
	bh=1NbDwtOv3dS3yl1dXnXeu8RsvtrlV1MtT1kj2eujlVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKJV+B3Buuf73rnysN7EBXD06v+LEqWPJQKH3PayyjPdZWCWS8Y9byr0yvA2h33mZ
	 DCQuLYq9+yyX9AU8EYT/PsDYB289JmqhGoM+s/6PKgsISiOMVf1mR2KXoFVOrWXLEf
	 Zww/r04mS76V42T4iMRfb8SFXmmWmIHQS8JU+yMIQD2QMcouCm40TUKzhlIAwYordI
	 c5gxrzxBQNy53buyYQm+VfAxPkqiase6LEufgx1r28IP9jaj6DJzzvuL7OmFCRPRjK
	 jJhTwB32bE/vRJKFh3s6V7bZ6GCwb9yigS/YdvSibuZ78BrcvOYqdH9xHSN7MLLXoh
	 7SfF+wH0amUUw==
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
Subject: [PATCH v2 29/62] objtool: Mark prefix functions
Date: Fri,  9 May 2025 13:16:53 -0700
Message-ID: <c4233972de0b0f2e6c94d4a225c953748d7c446b.1746821544.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, introduce a flag to
identify __pfx_*() and __cfi_*() functions in advance so they don't need
to be manually identified every time a check is needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 3 +--
 tools/objtool/elf.c                 | 5 +++++
 tools/objtool/include/objtool/elf.h | 6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index a2a025ec57e8..6b2e57d9aaf8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3601,8 +3601,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
-			if (!strncmp(func->name, "__cfi_", 6) ||
-			    !strncmp(func->name, "__pfx_", 6))
+			if (is_prefix_func(func))
 				return 0;
 
 			if (file->ignore_unreachables)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 59568381486c..9a1fc0392b7f 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -442,6 +442,11 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
+	if (is_func_sym(sym) && sym->len == 16 &&
+	    (strstarts(sym->name, "__pfx") || strstarts(sym->name, "__cfi_")))
+		sym->prefix = 1;
+
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


