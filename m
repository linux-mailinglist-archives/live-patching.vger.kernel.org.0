Return-Path: <live-patching+bounces-1371-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE3CAB1DE1
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADF2D1C21A9B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A5BD2641DE;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxEHaRkR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5258263F4C;
	Fri,  9 May 2025 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821872; cv=none; b=a/sYZBD4Z00KOPZGKI6a3i108wx224ftds/cfY3vBcABcJ3hRODwR2CA/rZEZiOjJ6DvDsNywLYnM/Y0pwzKtW+Mge3KaUF24D8wQRU6GTbG4LfJljjF9ANhA+iDnUojjCtmgJktHSdj33/K8mA2ssXnLhbvSx+KSJDqj5Fcuf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821872; c=relaxed/simple;
	bh=MkbdHRI47JadcIEFytvf/CtdZC615MAVjwn+3s/CxMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VehHsRXwxvcb/kVmXalyivj8QOrTNYxLj8FfhNM55/jM+VWDBZ2kzLcMTc/SBAPL54uW0sBdRLivlXeLXYIiyGJxEnrrP9Cjc++XEXpJ/YO3Q2H0msHKvyYwQZePmHPCsOzpkiaVTnQHWhWZuJMPiih7KZOxvuQPVg+fzoyt5nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxEHaRkR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE5CC4CEEE;
	Fri,  9 May 2025 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821872;
	bh=MkbdHRI47JadcIEFytvf/CtdZC615MAVjwn+3s/CxMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxEHaRkRrPnlICxhFemKwPPpiU3Fvkwdf0J8FqgkIdICRFQWiDLLvNN+S+Qa1cs3c
	 SyfkdmQi3UkLDMqr9oN5ix0PJAx4WulUwgY+tLGwyg4Zze508b2faKfMsNsv0kx61j
	 SUoy352HqNBLLxCDEB0CmKbuRgV+muYHlBjz9WZVVaszCIqqET6Zg70Ql7qlVq2Rfe
	 tDzvr/sKdZy8J02diXok2JYXKVLNFbJ47ASQJpQlCg5nj2Va5BWb/4wBJ6JwsuWAJs
	 gW7uv1EovI3iroLsTitHsiqVuuuqaon0+LiC2HP7Jns8w4lMqjA2rym3FrcG02K/lt
	 TaPN2Kj2a6FZA==
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
Subject: [PATCH v2 12/62] objtool: Speed up SHT_GROUP reindexing
Date: Fri,  9 May 2025 13:16:36 -0700
Message-ID: <11535adbcbd2c1598dca5aff3cb9eb2a60a3eeda.1746821544.git.jpoimboe@kernel.org>
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

After elf_update_group_sh_info() was introduced, a prototype version of
"objtool klp diff" went from taking ~1s to several minutes, due to
looping almost endlessly in elf_update_group_sh_info() while creating
thousands of local symbols in a file with thousands of sections.

Dramatically improve the performance by marking all symbols' correlated
SHT_GROUP sections while reading the object.  That way there's no need
to search for it every time a symbol gets reindexed.

Fixes: 2cb291596e2c ("objtool: Fix up st_info in COMDAT group section")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 47 ++++++++++++++++++-----------
 tools/objtool/include/objtool/elf.h |  1 +
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index bc24d59360df..1c1bb2cb960d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -587,28 +587,32 @@ static int read_symbols(struct elf *elf)
 	return -1;
 }
 
-/*
- * @sym's idx has changed.  Update the sh_info in group sections.
- */
-static void elf_update_group_sh_info(struct elf *elf, Elf32_Word symtab_idx,
-				     Elf32_Word new_idx, Elf32_Word old_idx)
+static int mark_group_syms(struct elf *elf)
 {
-	struct section *sec;
+	struct section *symtab, *sec;
+	struct symbol *sym;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		ERROR("no .symtab");
+		return -1;
+	}
 
 	list_for_each_entry(sec, &elf->sections, list) {
-		if (sec->sh.sh_type != SHT_GROUP)
-			continue;
-		if (sec->sh.sh_link == symtab_idx &&
-		    sec->sh.sh_info == old_idx) {
-			sec->sh.sh_info = new_idx;
-			mark_sec_changed(elf, sec, true);
-			/*
-			 * Each ELF group should have a unique symbol key.
-			 * Return early on match.
-			 */
-			return;
+		if (sec->sh.sh_type == SHT_GROUP &&
+		    sec->sh.sh_link == symtab->idx) {
+			sym = find_symbol_by_index(elf, sec->sh.sh_info);
+			if (!sym) {
+				ERROR("%s: can't find SHT_GROUP signature symbol",
+				      sec->name);
+				return -1;
+			}
+
+			sym->group_sec = sec;
 		}
 	}
+
+	return 0;
 }
 
 /*
@@ -802,7 +806,11 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 		if (elf_update_sym_relocs(elf, old))
 			return NULL;
 
-		elf_update_group_sh_info(elf, symtab->idx, new_idx, first_non_local);
+		if (old->group_sec) {
+			old->group_sec->sh.sh_info = new_idx;
+			mark_sec_changed(elf, old->group_sec, true);
+		}
+
 		new_idx = first_non_local;
 	}
 
@@ -1075,6 +1083,9 @@ struct elf *elf_open_read(const char *name, int flags)
 	if (read_symbols(elf))
 		goto err;
 
+	if (mark_group_syms(elf))
+		goto err;
+
 	if (read_relocs(elf))
 		goto err;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index c7c4e87ebe88..0a2fa3ac0079 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -72,6 +72,7 @@ struct symbol {
 	u8 ignore	     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
+	struct section *group_sec;
 };
 
 struct reloc {
-- 
2.49.0


