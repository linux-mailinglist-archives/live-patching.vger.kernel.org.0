Return-Path: <live-patching+bounces-554-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A933D969292
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BB92B22CAA
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094011D6186;
	Tue,  3 Sep 2024 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHONwC1X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D224C1D54FD;
	Tue,  3 Sep 2024 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336039; cv=none; b=Bi7vFhtTR59glBiLDWcWrgb/u3ZTw6HdIwsdfaGF9HkBZc8o68HOh0ujrPpRRLQkMLD0L141WqHjjm3+rwBAeYVbeXOfw+dnGSDGgiyAuYxUvIxsRwoTwnfvsxw5RB637QkLoDjte/aet8y97XpxklbMoH79HJdBsYbfQIJrpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336039; c=relaxed/simple;
	bh=dzKVrdzTcHSO61YSnRdTuu8RumHoQqa7Gn5nYXj8C5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lavnL/31j3Qr8tsJ+LEZ3hYzs+zJn8jTvTPIQCrOw+sWOOM9EUTLX9FVBZCXnnoQfT4jSPIgIuTfMcpKoc9d7Rf8mZjUhasa6YzQX6strxm3E/lgjUIN4v5HCjIrVOm2Dth+yjdBItudeg1TjV6FwWkMWFSQdCtXJIqYmYdKA0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHONwC1X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1302DC4CECC;
	Tue,  3 Sep 2024 04:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336039;
	bh=dzKVrdzTcHSO61YSnRdTuu8RumHoQqa7Gn5nYXj8C5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHONwC1XuyQHnkdrm1PmBYct7yxb00XIXmHeADwkm2YnI5DjmdHmHLnBNutcNpg2O
	 Hcoezj4bLXCDfIxY9agxSJwIr1hPU41+eFaXI1/NBfm6B3qDTgcF8ViSKSsYH+r8YI
	 Si1d73vbKk4JxUJTUt5A5xfigeSI7mNw2GKnaCVRQqq8K1gcRsfC+51Jc8T3E2bprt
	 1tf0/uOAigiTaLg+Df57gPdK9C0DiD9S+1o7j8xxM3T0PhtDPzUjiDT6tk5uWzqaYU
	 tROn0ijwlIkpe8D0n83uy4Wqe+qdCFkv0Abq29BanEL5ts5rMfblm9epBKFltu552d
	 0Msl55KJDfS6A==
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
Subject: [RFC 20/31] objtool: Add UD1 detection
Date: Mon,  2 Sep 2024 21:00:03 -0700
Message-ID: <20e0e2662239a042a10196e8f240ce596b250ae8.1725334260.git.jpoimboe@kernel.org>
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

A UD1 isn't a BUG and shouldn't be treated like one.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 6b34b058a821..72d55dcd3d7f 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -528,11 +528,19 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 			/* sysenter, sysret */
 			insn->type = INSN_CONTEXT_SWITCH;
 
-		} else if (op2 == 0x0b || op2 == 0xb9) {
+		} else if (op2 == 0x0b) {
 
 			/* ud2 */
 			insn->type = INSN_BUG;
 
+		} else if (op2 == 0xb9) {
+
+			/*
+			 * ud1 - only used for the static call trampoline to
+			 * stop speculation.  Basically used like an int3.
+			 */
+			insn->type = INSN_TRAP;
+
 		} else if (op2 == 0x0d || op2 == 0x1f) {
 
 			/* nopl/nopw */
-- 
2.45.2


