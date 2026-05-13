Return-Path: <live-patching+bounces-2753-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJrDF0vxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2753-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1136252CC66
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8779630254D2
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58F539446F;
	Wed, 13 May 2026 03:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIIHfT85"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28BE3932D5;
	Wed, 13 May 2026 03:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643271; cv=none; b=FwT5ks55Vme62htdNoRe66L8b0GRHJCMhSk+rOWMOgW0UFB5cHqX7JmbbfsovqAVW22zzk3pXzBjwj+klXccnwr0ahI7O6yejSDn+ybnaEDtyNj8I2Cj+ZJwSnf3hmCdG4hqFOL8YMKyFEVBdNYHqbOVVOnmzWo+c1ZvXv+MTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643271; c=relaxed/simple;
	bh=/D2z4LhluhXqyHCGUz6p/RDiGmFitxBUbjhr8ydpie0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr6vxtncxvj9Hz45c62jZgJP/PGqdQ2S5Hp5P1ztGfFXD4aBY8VpdOE0poQUg6vtSXEQWedaw0RMHMC3BxOs++ptf7kHMn/+HQFqe8ROFkhXEA8JVZXUJoAuhGwpxuFu7TCl7ramjhw4WJVuBm/slskD2EVtcQnJqKcQzoWgHso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIIHfT85; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B65BC2BCF7;
	Wed, 13 May 2026 03:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643271;
	bh=/D2z4LhluhXqyHCGUz6p/RDiGmFitxBUbjhr8ydpie0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIIHfT854Lr7qsvx6I7cr5tcMFSOYnHYPsUmlBOOQ12eZ0G9T3SFghvuElI0QqTAV
	 2SLst2YyVIO1f/ZvenQYzJYqR/oV8LI5/GEj7n/hGWaNL6KxmxWXwSHw24BJsHHoz6
	 e2OgjzlFPNrAXLwegFCvo6KF2cyu61LwIX8Bm4kooPJGmoqItKTAdEUrh4Olr0dA4K
	 zOUmYG+BHOMK3fJejkQed26rSkT16Kc94617C4QN3JjjjI7wd97LhqZFTbFIDtbb7+
	 i9PXHoqiMYP2/mIjzf87KMuc5dG8JRc9WUbRdqozAxsJGZKdOOuGVGb91juojVNqX6
	 5dREqsC8NOPAg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 02/21] arm64: Annotate intra-function calls
Date: Tue, 12 May 2026 20:33:36 -0700
Message-ID: <16bdb04ed6653809514d9f060702248b8e587f05.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1136252CC66
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2753-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

In preparation for enabling objtool on arm64, annotate intra-function
calls.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/entry.S       |  2 ++
 arch/arm64/kernel/proton-pack.c | 12 +++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e0db14e9c843a..d4cbdfb23d733 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -10,6 +10,7 @@
 #include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/annotate.h>
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
@@ -705,6 +706,7 @@ alternative_else_nop_endif
 	 * entry onto the return stack and using a RET instruction to
 	 * enter the full-fat kernel vectors.
 	 */
+	ANNOTATE_INTRA_FUNCTION_CALL
 	bl	2f
 	b	.
 2:
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index b3801f532b10b..b63887a1b8234 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -24,6 +24,7 @@
 #include <linux/nospec.h>
 #include <linux/prctl.h>
 #include <linux/sched/task_stack.h>
+#include <linux/annotate.h>
 
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
@@ -245,11 +246,12 @@ static noinstr void qcom_link_stack_sanitisation(void)
 {
 	u64 tmp;
 
-	asm volatile("mov	%0, x30		\n"
-		     ".rept	16		\n"
-		     "bl	. + 4		\n"
-		     ".endr			\n"
-		     "mov	x30, %0		\n"
+	asm volatile("mov	%0, x30			\n"
+		     ".rept	16			\n"
+		     ANNOTATE_INTRA_FUNCTION_CALL "	\n"
+		     "bl	. + 4			\n"
+		     ".endr				\n"
+		     "mov	x30, %0			\n"
 		     : "=&r" (tmp));
 }
 
-- 
2.53.0


