Return-Path: <live-patching+bounces-1548-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A760AEAB26
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E4D33B3BDD
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E0426B971;
	Thu, 26 Jun 2025 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apNJ/xlr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48326B77E;
	Thu, 26 Jun 2025 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982183; cv=none; b=T5np0sbVQ5+IssxRdKSxfk8PIkxa9Vpd1rq5TTSKpvNF5RDKD3tRg4GA3NcZ3+odsNFxjudL6yUljVJShopiGVmHPbZ3QlzYtZof8ccPrT5/0YASrGexVZw1yfKEfda0q5Q5bDcELcrTYmRDAPm+ASERJsXYbHw8yGf1j9ZDSgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982183; c=relaxed/simple;
	bh=57Cp7OOTI1HWUu68v+N+Y8hyJWq8un0zueXEP3AzfVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhiXAlIUcIYyuT4trjVWW6C3qOjpYc58sPRXPG61Q0wSUsqgx3iXshaEcvsoFllyt50jVoodubX0udV6we9JbGImvj+zJausM5Jj4xTXrggdQmN+t5g0MosC5V2mwUiUDd/9XXs3+id0ULBsvlTklTrj7IXozGD0EmTYvFKrPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apNJ/xlr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDECC4CEF0;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982183;
	bh=57Cp7OOTI1HWUu68v+N+Y8hyJWq8un0zueXEP3AzfVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apNJ/xlrNC1eJ55LuutaK+2tq4hy7gzyvqNYSCE4El4IQNMGc33l6o9wCUA/CIZRx
	 YoSQJslvmWed2R6F3CpZdvKEfNo/K6Wf1NpfnvCFCTb2D/8V78CNjtlOJrVyptNmNm
	 kVMZWv53JDeVDzvf0N8kF9PfeV5MPPeyRur3uyb4R68tVpsdt+j4sLYInDV+zGJadD
	 OMUOPIwlLC3iW4HSW2o/FJruRE5JLgNltKlUcprx5BrTy8c1vLHf/yRzhjbpejIxiZ
	 Ua8h+DYfDaq5Ni6AOaGkMSJYF82bw+wjHqupmkqFNxaX28glfJe9cR6ttpb13cy8uD
	 7xkDFfvoWs9gQ==
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
Subject: [PATCH v3 18/64] objtool: Fix x86 addend calculation
Date: Thu, 26 Jun 2025 16:55:05 -0700
Message-ID: <be28e43710d44248ff7799c312bffa965bc516ab.1750980517.git.jpoimboe@kernel.org>
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
index b6fdc68053cc..330671d88c59 100644
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
index c851c51d4bd3..9b17885e6cba 100644
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
index 98c4713c1b09..f29ab0f3d4a7 100644
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
index 096bb603a67f..fd93cae8b1b9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1498,7 +1498,7 @@ static int add_jump_destinations(struct objtool_file *file)
 			dest_off = arch_jump_destination(insn);
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 		} else if (reloc->sym->retpoline_thunk) {
 			if (add_retpoline_call(file, insn))
 				return -1;
@@ -1517,7 +1517,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		} else if (reloc->sym->sec->idx) {
 			dest_sec = reloc->sym->sec;
 			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc_addend(reloc));
+				   arch_insn_adjusted_addend(insn, reloc);
 		} else {
 			/* non-func asm code jumping to another file */
 			continue;
@@ -1662,7 +1662,7 @@ static int add_call_destinations(struct objtool_file *file)
 			}
 
 		} else if (reloc->sym->type == STT_SECTION) {
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest) {
 				ERROR_INSN(insn, "can't find call dest symbol at %s+0x%lx",
@@ -3311,7 +3311,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	if (!reloc || strcmp(reloc->sym->name, "pv_ops"))
 		return false;
 
-	idx = (arch_dest_reloc_offset(reloc_addend(reloc)) / sizeof(void *));
+	idx = arch_insn_adjusted_addend(insn, reloc) / sizeof(void *);
 
 	if (file->pv_ops[idx].clean)
 		return true;
@@ -4359,12 +4359,7 @@ static int validate_ibt_insn(struct objtool_file *file, struct instruction *insn
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
index 01ef6f415adf..cd1776c35b13 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -83,7 +83,7 @@ bool arch_callee_saved_reg(unsigned char reg);
 
 unsigned long arch_jump_destination(struct instruction *insn);
 
-unsigned long arch_dest_reloc_offset(int addend);
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc);
 
 const char *arch_nop_insn(int len);
 const char *arch_ret_insn(int len);
-- 
2.49.0


