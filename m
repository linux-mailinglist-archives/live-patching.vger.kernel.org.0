Return-Path: <live-patching+bounces-1377-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D4EAB1DEA
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1AC3B5F77
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB24C26771B;
	Fri,  9 May 2025 20:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMb7fGMp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1502676CD;
	Fri,  9 May 2025 20:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821876; cv=none; b=W+WuJAu0W/Wo2nUsbNyrJh1ejn+++cvVhO/hPoL39thBjZQZIxSW87pE2IlJGvj/o8KHzo9zx0MH+Fh/Um56bylsrqiEVjqrXA1cFVibb/Iu/Gl2yuisPCx1TXRi/UBaN37930SEG/u3TPstuKylwpXP0QOXaNX8Ux4Z9mV8+a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821876; c=relaxed/simple;
	bh=VqG6g//chpaS3lqzskCigvBXnHLMqfE7+a/jSGlD9vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANvuxjYWdhtMXdZSjaknxVrLBJmcy+8g0t4Bq4/hDnF4ONHoFqKCCLUK+XrW1kVtIm8NY9ON8CSICZspMpWtO95mk363V6TlkRwa0vt5J20n0MPZjlgZg3AWfKau2AKRWb76uQXyRGzDJ+mBjG4ywGdvoRqqEsSm4fcswUCXWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMb7fGMp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007B7C4CEEE;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821876;
	bh=VqG6g//chpaS3lqzskCigvBXnHLMqfE7+a/jSGlD9vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMb7fGMpYwhyePF081JqcTo/4y8jWmBr5IW0ozT1/Jn080uC6Nj6OXhvwjchbxF5A
	 1G/Z1H5d9dklMfp2pYNJZkAE15gOuqKSloRB1FgbY7lK/Ve18HbvZTwttbEGPD2DMr
	 XRri7hQvCT0CGqpey/D+KS2iCoy2lm3EjWOdIVa15+TXr0sQpsa9h2X76rLgG3BVCP
	 f/YJVBW9rPYZxqEO2QY5+OMJ7zqNI84GyBwuTl9Pjtze3iS+/fcc2EC014yGXf7yWb
	 j4D3aBCGjwA78/PcciWAzlZTN+TMXnaAOKgGYVjqRjNx2J+cT8jM/Fnc1jI/HHUNa2
	 HhQiApwzac5Qw==
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
Subject: [PATCH v2 18/62] objtool: Fix x86 addend calculation
Date: Fri,  9 May 2025 13:16:42 -0700
Message-ID: <8064f40394e9f0438a36f53f54e3b56f8e5b5365.1746821544.git.jpoimboe@kernel.org>
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

On x86, arch_dest_reloc_offset() hardcodes the addend adjustment to
four, but the actual adjustment depends on the relocation type.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c |  4 ++--
 tools/objtool/arch/powerpc/decode.c   |  4 ++--
 tools/objtool/arch/x86/decode.c       | 15 +++++++++++++--
 tools/objtool/check.c                 | 13 ++++---------
 tools/objtool/include/objtool/arch.h  |  2 +-
 5 files changed, 22 insertions(+), 16 deletions(-)

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
index 331b9a744410..771ad24e49ee 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -68,9 +68,20 @@ bool arch_callee_saved_reg(unsigned char reg)
 	}
 }
 
-unsigned long arch_dest_reloc_offset(int addend)
+s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
-	return addend + 4;
+	s64 addend = reloc_addend(reloc);
+
+	switch (reloc_type(reloc)) {
+	case R_X86_64_PC32:
+	case R_X86_64_PLT32:
+		addend += insn->offset + insn->len - reloc_offset(reloc);
+		break;
+	default:
+		break;
+	}
+
+	return addend;
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3a411064fa34..ea4e0facd21b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1502,7 +1502,7 @@ static int add_jump_destinations(struct objtool_file *file)
 			dest_off = arch_jump_destination(insn);
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 		} else if (reloc->sym->retpoline_thunk) {
 			ret = add_retpoline_call(file, insn);
 			if (ret)
@@ -1672,7 +1672,7 @@ static int add_call_destinations(struct objtool_file *file)
 			}
 
 		} else if (reloc->sym->type == STT_SECTION) {
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
+			dest_off = arch_insn_adjusted_addend(insn, reloc);
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest) {
 				ERROR_INSN(insn, "can't find call dest symbol at %s+0x%lx",
@@ -3348,7 +3348,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	if (!reloc || strcmp(reloc->sym->name, "pv_ops"))
 		return false;
 
-	idx = (arch_dest_reloc_offset(reloc_addend(reloc)) / sizeof(void *));
+	idx = (arch_insn_adjusted_addend(insn, reloc) / sizeof(void *));
 
 	if (file->pv_ops[idx].clean)
 		return true;
@@ -4396,12 +4396,7 @@ static int validate_ibt_insn(struct objtool_file *file, struct instruction *insn
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


