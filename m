Return-Path: <live-patching+bounces-1540-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C70E1AEAB16
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 646711C44397
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8283B25B30D;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKHoIv+q"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E5924A061;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982178; cv=none; b=fOIEet9zZx9F4EW+Gj7M5EiAbTdHNUF4eOSWn66p3h9b2Id3xSenrUrXNS/Y7O7sJy/1nhajggEMt46GPNPJgxbCaTD+u3DFMrZMdY/zStkOUrTl4Zn1OILNwqLyjuAxM98adliU79AiooISWD5aZKZTCHNvKZa8s3xv40BhFyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982178; c=relaxed/simple;
	bh=7iDLdpvwAdVD2fSGLdr4rv0JsZashmlV1YL2edneIcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmot3yu0vriMeTjIcJWf9oXJ1x325hoadtt8u7HMJBFSguhNb/WI57fQILDDpZnElmEtqKb6yFG6y2QXxZiBJ4jmhMQ77wRWxsOnXWenmUt3n2fIBpZOOJOdpv1Eg3jejgVFKl5GnGJsszJhJVcVO2aouILJpBihmcFV/yReGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKHoIv+q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F184C4CEF3;
	Thu, 26 Jun 2025 23:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982177;
	bh=7iDLdpvwAdVD2fSGLdr4rv0JsZashmlV1YL2edneIcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKHoIv+qtf8z/1py8aY4/NC/O8aR6Gp4qVF4IWyPKWmtUtTsnFY8fQ39aIeE7Jl+v
	 XhyRfSBG6ROWasZAjZRDEmIWOF1RkIO/2MVqb6lzv3QJZWDtEhFNuZRCubNOiJJfbL
	 GVo/53v41z+0uvpMtE65dy5etHsbABxUaelnHBb6NKJ/m2+uPwTehLvhy9m3tF3YFq
	 QyV/4YJvW5xMcfaP4csAsUBPl2G69jMMViRtn0N8mI1ylfEjIeu09AFIZ8gLNe7xs5
	 dsXVjz3rRt+iuGAiNfquV0nKzDDQ6uVMUGmJjN2yrCvBH51JlWgQrqOWTOkWQYTCCN
	 z9NIHSuSzZ8pg==
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
Subject: [PATCH v3 10/64] x86/alternative: Refactor INT3 call emulation selftest
Date: Thu, 26 Jun 2025 16:54:57 -0700
Message-ID: <eb5078c9b057c1349bc284dbaedc20efb256d9c6.1750980517.git.jpoimboe@kernel.org>
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

The INT3 call emulation selftest is a bit fragile as it relies on the
compiler not inserting any extra instructions before the
int3_selftest_ip() definition.

Also, the int3_selftest_ip() symbol overlaps with the int3_selftest
symbol(), which can confuse objtool.

Fix those issues by slightly reworking the functionality and moving
int3_selftest_ip() to a separate asm function.  While at it, improve the
naming.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/alternative.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ea1d984166cd..bacd6c157626 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2223,21 +2223,34 @@ int alternatives_text_reserved(void *start, void *end)
  * See entry_{32,64}.S for more details.
  */
 
-/*
- * We define the int3_magic() function in assembly to control the calling
- * convention such that we can 'call' it from assembly.
- */
-
-extern void int3_magic(unsigned int *ptr); /* defined in asm */
+extern void int3_selftest_asm(unsigned int *ptr);
 
 asm (
 "	.pushsection	.init.text, \"ax\", @progbits\n"
-"	.type		int3_magic, @function\n"
-"int3_magic:\n"
+"	.type		int3_selftest_asm, @function\n"
+"int3_selftest_asm:\n"
 	ANNOTATE_NOENDBR
-"	movl	$1, (%" _ASM_ARG1 ")\n"
+	/*
+	 * INT3 padded with NOP to CALL_INSN_SIZE. The INT3 triggers an
+	 * exception, then the int3_exception_nb notifier emulates a call to
+	 * int3_selftest_callee().
+	 */
+"	int3; nop; nop; nop; nop\n"
 	ASM_RET
-"	.size		int3_magic, .-int3_magic\n"
+"	.size		int3_selftest_asm, . - int3_selftest_asm\n"
+"	.popsection\n"
+);
+
+extern void int3_selftest_callee(unsigned int *ptr);
+
+asm (
+"	.pushsection	.init.text, \"ax\", @progbits\n"
+"	.type		int3_selftest_callee, @function\n"
+"int3_selftest_callee:\n"
+	ANNOTATE_NOENDBR
+"	movl	$0x1234, (%" _ASM_ARG1 ")\n"
+	ASM_RET
+"	.size		int3_selftest_callee, . - int3_selftest_callee\n"
 "	.popsection\n"
 );
 
@@ -2246,7 +2259,7 @@ extern void int3_selftest_ip(void); /* defined in asm below */
 static int __init
 int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
 {
-	unsigned long selftest = (unsigned long)&int3_selftest_ip;
+	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
 
@@ -2261,7 +2274,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -2277,19 +2290,11 @@ static noinline void __init int3_selftest(void)
 	BUG_ON(register_die_notifier(&int3_exception_nb));
 
 	/*
-	 * Basically: int3_magic(&val); but really complicated :-)
-	 *
-	 * INT3 padded with NOP to CALL_INSN_SIZE. The int3_exception_nb
-	 * notifier above will emulate CALL for us.
+	 * Basically: int3_selftest_callee(&val); but really complicated :-)
 	 */
-	asm volatile ("int3_selftest_ip:\n\t"
-		      ANNOTATE_NOENDBR
-		      "    int3; nop; nop; nop; nop\n\t"
-		      : ASM_CALL_CONSTRAINT
-		      : __ASM_SEL_RAW(a, D) (&val)
-		      : "memory");
+	int3_selftest_asm(&val);
 
-	BUG_ON(val != 1);
+	BUG_ON(val != 0x1234);
 
 	unregister_die_notifier(&int3_exception_nb);
 }
-- 
2.49.0


