Return-Path: <live-patching+bounces-2222-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OI1tJwvbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2222-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 372ED2B3380
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30FA530D2D46
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BB23E7171;
	Tue, 17 Mar 2026 22:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7ngc1os"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF703E6DFE;
	Tue, 17 Mar 2026 22:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787893; cv=none; b=hK8TOpyrqQ6ZeiRs4lwQMJtTkXuwhHVXYfsXBMRZsgKq4aBRsOllWjBBqc5RLes19w+WwUhdev1eAsjTYw/cU3McjdZ8iv11n07Nai5+l5gWXV0su6/W7B7lcoRGjAskKsI+RPXBiEWfnJOQRerFy9ZWp0zO1k5e08FgUDcwT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787893; c=relaxed/simple;
	bh=W1WxiHbuvXgUL/GnkhyKUEAdymsHY0Opyqu1xOqSq/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKei3Phd4ZXatsuYoIMKmrN8KWfI9wcgz8+f9umYs+sbaz8sNKfKXK+IkaFKd7tE1oWm6NoFvzcMAtz4N/Qw6ladBDL2ctT8ruIxvyVh9A6PxSbNbjV2tkHV9QvW07CdqQDp6xVAUYNfJtUVFoYTb1liPihbAe2q7Wc8X6af25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7ngc1os; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD522C4CEF7;
	Tue, 17 Mar 2026 22:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787893;
	bh=W1WxiHbuvXgUL/GnkhyKUEAdymsHY0Opyqu1xOqSq/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7ngc1osjOIco43BFhUtLp/DIzLkOHFDFV+nx47wIDWCw6gIbjjSTRd6CLV8NdBMa
	 6l67mCiRx8lBOK5RN4xfJELW5Qf4FSoabnC0rua2yK+TL4H5Hpk0WMwQ5a15Jw6woj
	 rkV9WKrQcr3Yvu+VWEDLr5iaxIaiEzlWvrVdN02BFPnasdHFdJDThvzsi6bYvLI988
	 YfmgRPIJ1ugL7fCiNCL0e5JIVj+A+7lb/7kYGeheud3n8CtNUu+npm7sc0FztMfOQ/
	 u2ZIcn7gnkMQ8ZyGI830V2JDgb0d61Xpbl0QJUU3Z2950Fz7yvAdHPMiU/y5PnVzV0
	 nVWfXKoXBZqPA==
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
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 02/12] arm64: head: Move boot header to .head.data
Date: Tue, 17 Mar 2026 15:51:02 -0700
Message-ID: <63e5cf00cb5636d1315754a264ff90175820ec65.1773787568.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773787568.git.jpoimboe@kernel.org>
References: <cover.1773787568.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2222-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 372ED2B3380
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The arm64 boot header is mostly data.  Move it to a data section to
prevent objtool and other tools from trying to disassemble it.  The
final linked result is the same.

Acked-by: Song Liu <song@kernel.or
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/head.S          | 2 +-
 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/init.h              | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 87a822e5c4ca..0681c6e50859 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -54,7 +54,7 @@
  * that are useful before the MMU is enabled. The allocations are described
  * in the entry routines.
  */
-	__HEAD
+	__HEADDATA
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1e1580febe4b..f82f170a97eb 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -663,7 +663,7 @@
 		__static_call_text_end = .;
 
 /* Section used for early init (in .S files) */
-#define HEAD_TEXT  KEEP(*(.head.text))
+#define HEAD_TEXT  KEEP(*(.head.data .head.text))
 
 #define HEAD_TEXT_SECTION							\
 	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
diff --git a/include/linux/init.h b/include/linux/init.h
index 40331923b9f4..91e16f3205e2 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -90,6 +90,7 @@
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
+#define __HEADDATA	.section	".head.data","aw"
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
-- 
2.53.0


