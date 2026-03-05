Return-Path: <live-patching+bounces-2112-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCBqF5L5qGnVzwAAu9opvQ
	(envelope-from <live-patching+bounces-2112-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:33:38 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB1820A8F4
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8EDE730AA88B
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10B327FB18;
	Thu,  5 Mar 2026 03:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mf1Z2e4t"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEC327E1C5;
	Thu,  5 Mar 2026 03:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681508; cv=none; b=P1htqUlXqZG483OI0VnMDCpyiLPPNxZS1pLuMZdijEjRq4/7k1AsEYOj7g+OfPzO7C60k7rZhy3R9E5ojm11afm/0hm8qMsN+XCwk0FMY4jp/X9qY/cQf9P5Nxp2eJmxEQ09L2aHczrq8YpnBPsK9yGp9K1bNuaTwjyOKo6pQ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681508; c=relaxed/simple;
	bh=ZlgKzEodeo2h7xrj6+yOcZaTPgylpV+16ZQbZgUDqcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgCfLF6NSzHXLTQlMJ5Ir4ul7snVf+5szdXfk2mylATx/j2euOrok8JhFbYVtCYqQPXVV8nj417+tXKK8/mwabTggy3LLg0GStGnOq+/zrK7qm5xp5bdomqz7a7Cytptj7lyX8kd7sqXpkkC0hu+GwZAkW7F+u55my7OOiTqdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mf1Z2e4t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF69C2BCB0;
	Thu,  5 Mar 2026 03:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681508;
	bh=ZlgKzEodeo2h7xrj6+yOcZaTPgylpV+16ZQbZgUDqcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mf1Z2e4tuic6+UzuCaVI+uWZg38Ul6M59lDO7FSFfzX7kdZdGwNm7SDFVjxF+roSe
	 qXH+rL5lueLltX36zmxf2bbqFxYrjDDPg2fyx7xXtjtq99NSMhP+1BizHKTpe3aFvf
	 EgkW+EDCmDNY/Sz94H639/MruYVzjqWVGUb2dKRYgK7ZcypU9vMXGuAUHWxQzwEUJJ
	 lyLXjkNlM2O9AR2ppkUwb+KNSmBxDpAVPcoqvJyYo/RD6gieLRWNS54aV17A6eb5oq
	 OpnGvKyDzMJMkhvYX+J8G/Dg9GMAUJXu0PcV+AtUw8h98nYswEY8r97EKMRW+KDpDQ
	 IVcFZYAfVaYQQ==
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
Subject: [PATCH 04/14] arm64: head: Move boot header to .head.data
Date: Wed,  4 Mar 2026 19:31:23 -0800
Message-ID: <ec379ccc31c1bf49d918228eaa1ca016e99f267c.1772681234.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772681234.git.jpoimboe@kernel.org>
References: <cover.1772681234.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCB1820A8F4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2112-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The arm64 boot header is mostly data.  Move it to a data section to
prevent objtool and other tools from trying to disassemble it.  The
final linked result is the same.

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
index eeb070f330bd..51a0e5974f41 100644
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


