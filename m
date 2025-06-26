Return-Path: <live-patching+bounces-1549-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62496AEAB29
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CECC11C44BB5
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E120026CE12;
	Thu, 26 Jun 2025 23:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYBP5KGb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E6826C3BE;
	Thu, 26 Jun 2025 23:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982184; cv=none; b=eNYerqW4JLYavANwkoI5EW4Ra51MQdsf1hP8WJOxCeCffDKxMoFlcA+i/HnRoMdRelRDm5DDd6ruguvY4txIZLFHrUrSBLHz5cC1co9EE2+CumoeuYEo2wr7kwQ9CR8WQfQw++IOgcvBCHCDnexVozMjyn8xKBqhZfjaCLU5tv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982184; c=relaxed/simple;
	bh=0M+19xTVOQq+SPVZVJtydW5ocDWMfmuRdwrFRsTmV2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itwCWrbsbrRGnGPkeGBQFZfjailErN6yOjH8TgPK/F3JcLHq+MNbUCPWQLgxj7kTAHN4H0kvDeP42IdXsBi0Jry27DF+fPA0GGcqsFxofSYNHtF9boAbMDNyDY40KuxB4+CUnhRahZQ/GTvdznDCVPu3P1KZD1emQWd/nVGAshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYBP5KGb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B29C4CEF1;
	Thu, 26 Jun 2025 23:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982184;
	bh=0M+19xTVOQq+SPVZVJtydW5ocDWMfmuRdwrFRsTmV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYBP5KGbGQt/iJ0w0fwlWB0b4iWIyoCC4tz+uKbDEsMxL9LKwLhE1IOw3bpa6tIj2
	 Ib/IR5yoYfsalbkZoZOLVUhV9EOXUzCMOLdHVFsZ4jAlVPOifeBdBBJqbXTYNsyZRC
	 90mPh/fhmnQu7lWBLisPcGE7mLcpPqvXO/2VNd4m95JDUobswGqcOhSbb6Dm30grpT
	 iP4BVik3Nz4Dwg2ZVoX3oDWcPq3PCxq8NYOfafG9Ye+twb2ttSbKsro7yGU4oMe3N8
	 NnO0+h5DpkFXk6KV0nkmtoblCSBiGnqroaZZ1KFxUn/V2/WO9moLJLBo0Cok/DkVXZ
	 bWQ8RiW/UwSfg==
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
Subject: [PATCH v3 19/64] objtool: Fix __pa_symbol() relocation handling
Date: Thu, 26 Jun 2025 16:55:06 -0700
Message-ID: <40dd3c7d6ad7b76efa7951cbaa78a5d01e4f173e.1750980517.git.jpoimboe@kernel.org>
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

__pa_symbol() generates a relocation which refers to a physical address.
Convert it to back its virtual form before calculating the addend.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index f29ab0f3d4a7..b10cfa9cd71e 100644
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
@@ -75,7 +86,7 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 	if (arch_pc_relative_reloc(reloc))
 		addend += insn->offset + insn->len - reloc_offset(reloc);
 
-	return addend;
+	return phys_to_virt(addend);
 }
 
 unsigned long arch_jump_destination(struct instruction *insn)
-- 
2.49.0


