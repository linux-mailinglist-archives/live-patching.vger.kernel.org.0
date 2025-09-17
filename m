Return-Path: <live-patching+bounces-1676-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C089B80DC1
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0E771657CB
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D3A2FF17A;
	Wed, 17 Sep 2025 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrwcmEyD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604BB2FF166;
	Wed, 17 Sep 2025 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125071; cv=none; b=M5gy9Xwz4oYjYm51PEubjKih1ljxAQ4r/Pdb+XHiFf51izKxQTfWm9sHpQNnc4gSLKdLXPOPGHAWpyjogV1f+wXsUdFJcuaiCj2BOcQzI1slVBtMw/WcEBPUtpLLSzZzEufAeSr6CBmcG5xmYYXR4u5vpnvqOuJgCFaYcc+nN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125071; c=relaxed/simple;
	bh=4piy1gTQzyYDWiZhfA3bm9W8aqv10bKVHBq9Qtkungs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/oC6nLAm96ywH1OSV2ulHnWNHJwwrKo0UCm7A3V43u4LGK5b3oMEL/+SNZAeABV8SFf/330x+KAQaZR6NjuBnqXKyJ1cVW/nzhgIKPJ4XmbL3d0YwqVInxvdbQ5hQ5mhlr4Jd7gv8pGs6Ns3J00FEzYyf3ejOoQvQMX/jP/Fa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrwcmEyD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F9CC4CEFA;
	Wed, 17 Sep 2025 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125071;
	bh=4piy1gTQzyYDWiZhfA3bm9W8aqv10bKVHBq9Qtkungs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrwcmEyDqDQhWqBZWF2l03ufP3oE20PmSE2um0P9CxYGsEbBgInvJty7hhwcMSwAt
	 p7FLiDyo6lWrQRODT6uvNGTBzmsBT+lY+NZzlGum4pDkbrHp4qvmDWxTqwGKoNfQ7g
	 I4DgvC9+TAxMofHPGy+KLVgyOowdWMp08MwqU/JmJEOWzButExxCAfRRFN5620pJvd
	 V09zhXgwtbfWQCYKuSDE3PKWEDGuQe73R+L5ix8DaxkiH9eqfcl1dH0cw6IKKPrtnP
	 bTa0Cqsa7ylGnIWhbvhHXGmnJ3JBOIKgzmyTI6Ws2mxCF7zQt58rxvyic2Xy9mnSbe
	 WPg5D+HkGf7fA==
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
Subject: [PATCH v4 21/63] objtool: Fix __pa_symbol() relocation handling
Date: Wed, 17 Sep 2025 09:03:29 -0700
Message-ID: <504f706576e49dad28fb20268e731e28972f669e.1758067943.git.jpoimboe@kernel.org>
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

__pa_symbol() generates a relocation which refers to a physical address.
Convert it to back its virtual form before calculating the addend.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 6742002a01f55..b10200cc50c99 100644
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
2.50.0


