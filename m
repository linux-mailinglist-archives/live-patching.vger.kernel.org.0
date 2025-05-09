Return-Path: <live-patching+bounces-1369-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 470F9AB1DDE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B32391C23F09
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12192638A0;
	Fri,  9 May 2025 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="py1ZUo96"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A2262FF3;
	Fri,  9 May 2025 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821871; cv=none; b=bcrDsxKiM5OEz4GnD393OV1PwDZmXtJOsCJXb7mfhid/L2+PREh+GFcwgxGZG7BQFoSdGHekhfaH9P1WK3H5ErtKeRiu/mOuAluDwmkSgUG9MJEDWgCIhnHEP89Mnl9VA4qxgKyDAjZzfj08aJPSWHXmLLl/bBlp1fJraQ3nmD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821871; c=relaxed/simple;
	bh=68/5Prs0aj5PVNoTeZpDaBIYAjvhkFM/hSAYUYosuTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjNc7AznBd7kkYmH85Vge3qCacr/+o/VbOJD/DJnj9Z3CFYMp21fDWOqfi2Ao3+ScflRL4fYjONKv/ysxVsOCLmXODawZKaG7FXOg6IuHP9aNcAV0ZjxX5JkbWj/1veCNoVOt9E2yTDM/x17eHY8oPFIk2yff9O3gaYt4Qt1t2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=py1ZUo96; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA29C4CEF2;
	Fri,  9 May 2025 20:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821871;
	bh=68/5Prs0aj5PVNoTeZpDaBIYAjvhkFM/hSAYUYosuTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py1ZUo96UHrV4ZCWTxXXdoDulRJ9IZKrXIYFtAbTtYolygJ+UOTomw5WN1nSy0zVh
	 sAyDkwIS3tTtcKmo5XtfCJcHXv8niPqh+uNeZxuj0keRZ4yJJ8+TRWvuXwckRN3eig
	 T1H067BPMHX9IeKKzfdfNJr8UnXvRjh1yGHyHVRx1R4y21tgu18Zt0ruTy6QIHQob6
	 sU1C+jOnJCPADyCXEeAjbwC70uoN8zuwEhAaLQN3SnWHcpg6d91tro1styD7tMaWWx
	 SPM61Vt9LEa1otwxZr0EDRPMiUVTXTlfGX421FOKJY47TwMb4VMJ5gbQdUXoTVDxQv
	 AD46xbPLfPAGQ==
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
Subject: [PATCH v2 10/62] x86/alternative: Refactor INT3 call emulation selftest
Date: Fri,  9 May 2025 13:16:34 -0700
Message-ID: <517fdaa3f187c9a69d6aac8c8b7526776b99f96d.1746821544.git.jpoimboe@kernel.org>
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
index ddbc303e41e3..ec220e53cb52 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1899,21 +1899,34 @@ int alternatives_text_reserved(void *start, void *end)
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
 
@@ -1922,7 +1935,7 @@ extern void int3_selftest_ip(void); /* defined in asm below */
 static int __init
 int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
 {
-	unsigned long selftest = (unsigned long)&int3_selftest_ip;
+	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
 
@@ -1937,7 +1950,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -1953,19 +1966,11 @@ static noinline void __init int3_selftest(void)
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


