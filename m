Return-Path: <live-patching+bounces-535-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E2796926B
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61AD5282BE8
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F4D1CDFAE;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBvgJqZY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4AA1CCEEC;
	Tue,  3 Sep 2024 04:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336030; cv=none; b=Rnqx4oSVjve3+oKAEcB8WN+07LdvOEx/88AxlTlhunelb3FBsd4L71fznZalgffKHEqVtl0DJWcSAHk85zLLMXs4yTFcrFaOxI7YKPNJW9cUDLTOKn1WWpcWN77WeI4L8iiBgus8imN+vn0BKvR+5EMcEdBgZWTK26O5Dl5DlvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336030; c=relaxed/simple;
	bh=JEag57dK28BIYne3Wua4KqbjKLoJ1F9duI+dzY3ghqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTJIkcnJIBDV6ntW6qiW/rHuhSv/D4JkY1JP0NGJYLo0xjq8t4etmnJnEUa06x/5j06BD5KN6LA7ex7zfkouiNsfwYQ/WjCOZNxaTNyAcilsApcfp6uzKgr56XUiRPqWOSCZkrckLxhr2/mZry3AH/YrX+g3zpqMeWkxd9holsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBvgJqZY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2309DC4CEC9;
	Tue,  3 Sep 2024 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336029;
	bh=JEag57dK28BIYne3Wua4KqbjKLoJ1F9duI+dzY3ghqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBvgJqZYJ+iofZadXi9Id5oRzvNCiDGAF4PIlXI7SorgqaHaBKF29YPMXZEcElBLo
	 LmgPCdPgoc9OrrYh3a0JGzcajK2O131yD+x5Lp9Fp4plh9EshzObeItDyWQhILPoGj
	 Zc7lrls+ju3c3KS16euDNho2p2/+Nr8vDqGS1PcJlwGb0dsB1xFUijRuQ8lJW4ugeJ
	 eFL4ykHG3p72Vrr4K3YnoaSUKMurU+4S9U+vt/daMOeH/WiA2Dbc66zNQfPCb7B2pH
	 JruvME7FmHwrtpDhcGehCtZTDnAK32OUZFANGNYDDJSQi1SPbcunY9OU/wen+uw/dr
	 Yh6JRaULJQU6Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 01/31] x86/alternative: Refactor INT3 call emulation selftest
Date: Mon,  2 Sep 2024 20:59:44 -0700
Message-ID: <e2cb3a22107bb3aac4bd346cd3cc8ce6443bb870.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
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
symbol(), which can confuse tooling like objtool.

Fix those issues by slightly reworking the functionality and moving
int3_selftest_ip() to a separate asm function.  While at it, improve the
naming.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/alternative.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 89de61243272..56fca5e6ba23 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1546,21 +1546,34 @@ int alternatives_text_reserved(void *start, void *end)
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
 
@@ -1569,7 +1582,7 @@ extern void int3_selftest_ip(void); /* defined in asm below */
 static int __init
 int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
 {
-	unsigned long selftest = (unsigned long)&int3_selftest_ip;
+	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
 
@@ -1584,7 +1597,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -1600,19 +1613,11 @@ static noinline void __init int3_selftest(void)
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
2.45.2


