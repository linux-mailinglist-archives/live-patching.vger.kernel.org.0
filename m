Return-Path: <live-patching+bounces-1665-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D26FFB80D5B
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC392A4D71
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46392FB623;
	Wed, 17 Sep 2025 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM1pFhw8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6C827875C;
	Wed, 17 Sep 2025 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125063; cv=none; b=Z6PqkjgG718S8A65pQJTcP3BjZC5vs7pXFvyzI883k/e7/zZd+kV2DwRGwrA1Is9mn2yKVgzcerXBV/+2WvKxqpcQ3lly6lwKDNLfUUZFGuzbtNguFZjir3MDElZ3DPYpY5e3DGDpBqyagHXL/w85Yr0L3H1SP4JHQyyiInHzyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125063; c=relaxed/simple;
	bh=eHw0u6kn/e6VWlDUX7+51egTO7nADQPtQ5LmQ4ML06Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDgy5GKkDo9ujGFl5EA24bJDazLW3Mp1DEUR6k4Tmx22GLDOfgYLkkiDmHFIHW9xRBDWOvR86kqMngOkrr+SUMG7/ANKyakEUh7/iVoD0Q1tLxGICysDzr6FNX45mk6K/M/JU+s0lJ6gzrQTaZFI/AOAuf5YNPxcXiGI0oKeECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OM1pFhw8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C572BC19421;
	Wed, 17 Sep 2025 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125063;
	bh=eHw0u6kn/e6VWlDUX7+51egTO7nADQPtQ5LmQ4ML06Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM1pFhw8q6gShh4qAiGYO5IYrvhr80DkYXOapti0woV45TFRpxV8s84DfGw3tnRCW
	 e9zhOF7ttNdRowHlwd9OI7mx88NYODXbPrkgBtzR/8D9OaBJWpkk/1EzBULNZNUqlJ
	 KmwG7V7+jhQKuswk++eStTK8uoobDUSO17NT8haat2d8UF/GGQrfWCdmY3n1mIIPIX
	 6LTateE28PYDre7gM6fUvz0zGvctqfgj+MHmOW9uExI30zdjSb4uApd4FJz5j/m5+c
	 w7vHXFFsS7nuaYSx/k5+gVcUv4pOscD6I/GrmFgKM6PVF80aFJqCquPQdQTva6iBH9
	 dGafaZCRQuDQw==
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
Subject: [PATCH v4 10/63] x86/alternative: Refactor INT3 call emulation selftest
Date: Wed, 17 Sep 2025 09:03:18 -0700
Message-ID: <5568a50fd9cb11435e18c05a9841cd88a4d664ac.1758067942.git.jpoimboe@kernel.org>
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
index 69fb818df2eed..9e7f03172a227 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2244,21 +2244,34 @@ int alternatives_text_reserved(void *start, void *end)
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
 
@@ -2267,7 +2280,7 @@ extern void int3_selftest_ip(void); /* defined in asm below */
 static int __init
 int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
 {
-	unsigned long selftest = (unsigned long)&int3_selftest_ip;
+	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
 
@@ -2282,7 +2295,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -2298,19 +2311,11 @@ static noinline void __init int3_selftest(void)
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
2.50.0


