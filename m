Return-Path: <live-patching+bounces-1378-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA26FAB1DF2
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE0021C27FC5
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6921266EE5;
	Fri,  9 May 2025 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onFRhoJ/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DCD25F79A;
	Fri,  9 May 2025 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821877; cv=none; b=uh6DJOrufkg93bEN5/PKFKnlhT+MN5yRiRSpg8WfOT7oVhwVHgi0RYkZDMQMVHHzAHaLEruoiPsTIbtBgMR3YvI2CHsqBln/juX1R0nCKiV5HlUiNVsrSztUFjczMDQZ9z8T2Gspd/hKKnwZfpmFor5eaoUO9DZ4KwnTtTYZjZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821877; c=relaxed/simple;
	bh=zsi/UkUHfX+HCgon4iWgQ8WWU+oyoaWZoqhN5WSCmrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRhPzikHWJQkHf97GhtN0tg7kGlbPlVJFRI2um5LKD9MhHK0GVy3X2eBia25SLfj9lYQexkaNbS0mIvEkftsZu2n6Mgmzo8Ol/Ir8WB3UF7IRxsB2bjx8ygR4IGsGpY4EvREuCOOvbiGLib56Yvssx8JTJPUvdwgsUQObtbTL7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onFRhoJ/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80A4C4CEF1;
	Fri,  9 May 2025 20:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821877;
	bh=zsi/UkUHfX+HCgon4iWgQ8WWU+oyoaWZoqhN5WSCmrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onFRhoJ/ckckXI82v9MLqVOEjPWlNq70aypBmjgCPSawbv26A8LQadR69+VsES1IM
	 /g7S63r4lHVzChcTJVLet/YXDChALrch2F4MlyEJTQ/EOieLGhaBZ6587yVy9BTBjh
	 aZCL16rDOF4kYI955fiuC7+ntGmR9z4QsyVCqiCwqFRHg9OWkdBLgIUyJuuzPH1NRr
	 Z5i+xs/vFidB+oZzkmgxmBTNqwAzcD0MGXbtPiB4ldANpr74F+vuteV08ZZLEDjLkY
	 7HNiNEav7n5nKc4RwCseVIgXrwnfLUeh6d9IPo7L1afoi662Z3/OLISNxKz1zGZ44y
	 EaPvhiZEbISNg==
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
Subject: [PATCH v2 19/62] objtool: Fix __pa_symbol() relocation handling
Date: Fri,  9 May 2025 13:16:43 -0700
Message-ID: <5d629e496710097c648126f3267d769ca3419baf.1746821544.git.jpoimboe@kernel.org>
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

__pa_symbol() generates a relocation which refers to a physical address.
Convert it to back its virtual form before calculating the addend.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 771ad24e49ee..7bb8bad22b8a 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -68,6 +68,17 @@ bool arch_callee_saved_reg(unsigned char reg)
 	}
 }
 
+/* Undo the effects of __pa_symbol() if necessary */
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
@@ -81,7 +92,7 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 		break;
 	}
 
-	return addend;
+	return phys_to_virt(addend);
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
-- 
2.49.0


