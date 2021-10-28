Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66C643E0EA
	for <lists+live-patching@lfdr.de>; Thu, 28 Oct 2021 14:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJ1M1U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Oct 2021 08:27:20 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:41035 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhJ1M1U (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Oct 2021 08:27:20 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Hg4Vr1nryz9sT4;
        Thu, 28 Oct 2021 14:24:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g1IAStAKYEEo; Thu, 28 Oct 2021 14:24:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Hg4Vl6129z9sTG;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id AC44B8B794;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id s4wV9EDYhJfg; Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.232.214])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2FBFD8B78C;
        Thu, 28 Oct 2021 14:24:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1) with ESMTPS id 19SCO7gP194392
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:24:07 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1/Submit) id 19SCO74x194391;
        Thu, 28 Oct 2021 14:24:07 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: [PATCH v1 2/5] powerpc/ftrace: No need to read LR from stack in _mcount()
Date:   Thu, 28 Oct 2021 14:24:02 +0200
Message-Id: <24a3ba7db388537c44a038026f926d885372e6d3.1635423081.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635423081.git.christophe.leroy@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1635423843; l=1773; s=20211009; h=from:subject:message-id; bh=BdgcxgTnhLIQz+nFCg438ZdJlGpUJGv35y1aicj1AGk=; b=OQDvBxfJM6arTMja8VXsBuAHwTfB589E+cNZpkX8AmZBoTGmSV0VjxkW4braPU2V3ZXFmuIareBJ 1cSqV0G/Ck1dzwV0GqIVSeuABBpJBOMCkxWpsANCFpPmjv/F7Hi+
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

All functions calling _mcount do it exactly the same way, with the
following sequence of instructions:

	c07de788:       7c 08 02 a6     mflr    r0
	c07de78c:       90 01 00 04     stw     r0,4(r1)
	c07de790:       4b 84 13 65     bl      c001faf4 <_mcount>

Allthough LR is pushed on stack, it is still in r0 while entering
_mcount().

Function arguments are in r3-r10, so r11 and r12 are still available
at that point.

Do like PPC64 and use r12 to move LR into CTR, so that r0 is preserved
and doesn't need to be restored from the stack.

While at it, bring back the EXPORT_SYMBOL at the end of _mcount.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/kernel/trace/ftrace_32.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/trace/ftrace_32.S b/arch/powerpc/kernel/trace/ftrace_32.S
index e023ae59c429..c7d57124cc59 100644
--- a/arch/powerpc/kernel/trace/ftrace_32.S
+++ b/arch/powerpc/kernel/trace/ftrace_32.S
@@ -14,16 +14,16 @@ _GLOBAL(mcount)
 _GLOBAL(_mcount)
 	/*
 	 * It is required that _mcount on PPC32 must preserve the
-	 * link register. But we have r0 to play with. We use r0
+	 * link register. But we have r12 to play with. We use r12
 	 * to push the return address back to the caller of mcount
 	 * into the ctr register, restore the link register and
 	 * then jump back using the ctr register.
 	 */
-	mflr	r0
-	mtctr	r0
-	lwz	r0, 4(r1)
+	mflr	r12
+	mtctr	r12
 	mtlr	r0
 	bctr
+EXPORT_SYMBOL(_mcount)
 
 _GLOBAL(ftrace_caller)
 	MCOUNT_SAVE_FRAME
@@ -43,7 +43,6 @@ _GLOBAL(ftrace_graph_stub)
 	/* old link register ends up in ctr reg */
 	bctr
 
-EXPORT_SYMBOL(_mcount)
 
 _GLOBAL(ftrace_stub)
 	blr
-- 
2.31.1

