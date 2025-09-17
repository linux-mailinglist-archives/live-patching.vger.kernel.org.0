Return-Path: <live-patching+bounces-1675-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACE1B80D8E
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3F3B1C21EDE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57EA2FE593;
	Wed, 17 Sep 2025 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HK2LNZ9k"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA4F2FE578;
	Wed, 17 Sep 2025 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125070; cv=none; b=fM6Nd3PSj6Zx8czdUhoOxM2X4xRsTRWBNJXJ+2RAk4NCsQlrJh+HeNnvu+/d1RcV3dWEwnzeB2fiMfLjxd0RZO3T9+UdrddqcDHzjh0ptgLYzRNY5DfJav7fNrNh0czmjt17iPnxvz5Iyjblz+Ck343ZaoLIChpST5dQYOkn8cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125070; c=relaxed/simple;
	bh=tENY8UpReDpCrnzhzEcKFJHSyHeiXRre36scAd19kMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwdGi1txAcR6Rztr896bDsKtn50lM8Y1q3WWuvIzowfcKufXu0Jlsxfr9EpqD0FZN10A7lvrRUMq62hNl9wpD6Pdx04JrKmxqYh1NFqP3ATj6kw3FpDC2TI9JtV80X1QAPauDFft0jXMhnAKwWJFYJPRvUGj8YyzTGx81umh03A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HK2LNZ9k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC667C4CEF7;
	Wed, 17 Sep 2025 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125070;
	bh=tENY8UpReDpCrnzhzEcKFJHSyHeiXRre36scAd19kMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK2LNZ9kY5NyuBkPkrZc5+ez3LDIW44zLvWv6m3n1q1mWfy4g8vLic9+ZWA/qXUzJ
	 bvbWCL+42eTwYo0XB4RMpn6GQzHunDsCS3j4Zyd+cK0axJdh1ZzSCizcIiKYnndK+2
	 nMMxd2Zue00Dip0i1J3xSLZFN1lbu/vuSP6j3CylNOAyn76QQ3rFTukifVX9XF4EJa
	 ROunF+GIF5sK+L2ZYlBQLZry4MIQt882Z1+n2xtFMc0h0qG9HWDpk23kpRStMYfo8K
	 12xzz4VAWbV/zQt3ZKFAtTr2EMKEr43RxPQ7H0H9noB5PyyLy8B1zJ2iDzMG2du53c
	 5SHF4vQgE+byA==
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
Subject: [PATCH v4 20/63] objtool: Fix x86 addend calculation
Date: Wed, 17 Sep 2025 09:03:28 -0700
Message-ID: <f17f8e7d1b666c2c548789ab456f58721cae6b88.1758067943.git.jpoimboe@kernel.org>
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

On x86, arch_dest_reloc_offset() hardcodes the addend adjustment to
four, but the actual adjustment depends on the relocation type.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c |  4 ++--
 tools/objtool/arch/powerpc/decode.c   |  4 ++--
 tools/objtool/arch/x86/decode.c       |  9 +++++++--
 tools/objtool/check.c                 | 15 +++++----------
 tools/objtool/include/objtool/arch.h  |  2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index b6fdc68053cc4..330671d88c590 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -17,9 +17,9 @@ unsigned long arch_jump_destination(struct instruction *insn)
 	return insn->offset + (insn->immediate << 2);
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend;
+	return reloc_addend(reloc);
 }
 
 bool arch_pc_relative_reloc(struct reloc *reloc)
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index c851c51d4bd35..9b17885e6cba6 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -14,9 +14,9 @@ int arch_ftrace_match(char *name)
 	return !strcmp(name, "_mcount");
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend;
+	return reloc_addend(reloc);
 }
 
 bool arch_callee_saved_reg(unsigned char reg)
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 0ad5cc70ecbe7..6742002a01f55 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -68,9 +68,14 @@ bool arch_callee_saved_reg(unsigned char reg)
 	}
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend + 4;
+	s64 addend = reloc_addend(reloc);
+
+	if (arch_pc_relative_reloc(reloc))
+		addend += insn->offset + insn->len - reloc_offset(reloc);
+
+	return addend;
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index dbdbbddd01ecb..1165dd1669f0b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1499,7 +1499,7 @@ static int add_jump_destinations(struct objtool_file *file)
 			dest_off = arch_jump_destination(insn);
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 		} else if (reloc->sym->retpoline_thunk) {
 			if (add_retpoline_call(file, insn))
 				return -1;
@@ -1518,7 +1518,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		} else if (reloc->sym->sec->idx) {
 			dest_sec = reloc->sym->sec;
 			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc_addend(reloc));
+				   arch_insn_adjusted_addend(insn, reloc);
 		} else {
 			/* non-func asm code jumping to another file */
 			continue;
@@ -1663,7 +1663,7 @@ static int add_call_destinations(struct objtool_file *file)
 			}
 
 		} else if (reloc->sym->type == STT_SECTION) {
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest) {
 				ERROR_INSN(insn, "can't find call dest symbol at %s+0x%lx",
@@ -3324,7 +3324,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	if (!reloc || strcmp(reloc->sym->name, "pv_ops"))
 		return false;
 
-	idx = (arch_dest_reloc_offset(reloc_addend(reloc)) / sizeof(void *));
+	idx = arch_insn_adjusted_addend(insn, reloc) / sizeof(void *);
 
 	if (file->pv_ops[idx].clean)
 		return true;
@@ -4405,12 +4405,7 @@ static int validate_ibt_insn(struct objtool_file *file, struct instruction *insn
 					      reloc_offset(reloc) + 1,
 					      (insn->offset + insn->len) - (reloc_offset(reloc) + 1))) {
 
-		off = reloc->sym->offset;
-		if (reloc_type(reloc) == R_X86_64_PC32 ||
-		    reloc_type(reloc) == R_X86_64_PLT32)
-			off += arch_dest_reloc_offset(reloc_addend(reloc));
-		else
-			off += reloc_addend(reloc);
+		off = reloc->sym->offset + arch_insn_adjusted_addend(insn, reloc);
 
 		dest = find_insn(file, reloc->sym->sec, off);
 		if (!dest)
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index be33c7b43180a..68664625a4671 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -83,7 +83,7 @@ bool arch_callee_saved_reg(unsigned char reg);
 
 unsigned long arch_jump_destination(struct instruction *insn);
 
-unsigned long arch_dest_reloc_offset(int addend);
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc);
 
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
-- 
2.50.0


