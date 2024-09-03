Return-Path: <live-patching+bounces-557-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E43969296
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB92A1C20CF1
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF0C1D67A3;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyCqSnga"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245AB1D2F52;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336041; cv=none; b=Dr1ly6mn9+Li+1B1CLtOegIXGalah8drNECEibSeeAlJ0ve6eTPrdnt0lOqOu5KzcOOwG0OLIIUoJ6Fo31yXm4XT+fnnaHwDE5PWasg8s/wimS3FShqiwl15CcFFybXoEtz81/xR0U4KXC2P/CYAKnc6zo8f2YiFn5Jg+dwd9M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336041; c=relaxed/simple;
	bh=mTzu1+CtgHG6mSPrVj5zmYy4j+KYldxKNu+MHa7dpDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfTgfP9ylrZE28Iq/2BVf5nu1+q3Y417LmDMDEuyGm0LXEhZCuXlu6acYHJn517R8OWguD8EofD9d6kkFQ0ewSK8T/wMKKZZ9MjQSGuLTkwbCXCgtJlhn1JpokV2IesEdgGgb9dx97xkdJ+3VjbMccExbcDQy47d71mtIXURpck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyCqSnga; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F92C4CEC5;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336041;
	bh=mTzu1+CtgHG6mSPrVj5zmYy4j+KYldxKNu+MHa7dpDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyCqSngaSWpeL2IoAalav9kXFFqviQ8D/ljLAWZKt3Vei5UJ1OUimL/63RluqehtS
	 NRWf2CvZq6GiXC1l094ffFuqtzb3+QlkQU4cSHjb3Wrt/7Yt5bqiCIRclCDSskurcp
	 bjAIbLYRtXcRQVvQphcHvq+ad5y66uQBXeFPRgF9PKypZ4eUDPG6BY49ONItdZDgd0
	 P7FgTBAq/tZHKfCOZ9n7dcyYqHpb4bfplnqYes1rtfv1RZkke0JAnGJnWvOlv31bl5
	 33Mkz3Wtc42CeR9O8SRv4DmZ6hPv4DUFoaaIu2SQLMiMFiMNArk678z/azLZiD64Nx
	 Lkk1XLAJ3MK3g==
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
Subject: [RFC 23/31] objtool: Handle __pa_symbol() relocations
Date: Mon,  2 Sep 2024 21:00:06 -0700
Message-ID: <9b5ebea4361ec1a5471b6b2e86d6657b5685c72d.1725334260.git.jpoimboe@kernel.org>
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

A relocation created by __pa_symbol() has a large addend referring to a
physical address.  Convert it to back its virtual form before
calculating the addend.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index afebd67d9b9d..5468fd15f380 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -67,6 +67,17 @@ bool arch_callee_saved_reg(unsigned char reg)
 	}
 }
 
+/* undo the effects of __pa_symbol() if necessary */
+static unsigned long phys_to_virt(unsigned long pa)
+{
+	s64 va = pa;
+
+	if (va > 0)
+		va &= ~(0x80000000);
+
+	return va;
+}
+
 s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
 	s64 addend = reloc_addend(reloc);
@@ -80,7 +91,7 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 		break;
 	}
 
-	return addend;
+	return phys_to_virt(addend);
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
-- 
2.45.2


