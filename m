Return-Path: <live-patching+bounces-2223-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AALQACDbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2223-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:52:16 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9653F2B33A5
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9070230EB4EF
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B313F54CB;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIXLFcFb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119A13EBF2E;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787894; cv=none; b=YZLt6PoihB8GBlolRyWNIn2pxPrN2UOkk8IhwvlguML7kk4QuKGFchb+ZqO3QX6yAnRg5P7k0Wlqvu0ZjKvFyt1MIeMljjnaEhXqjJ+LtDhW6RuwmKSFvOAq30YDEHo/ZFk5I6jna/Huir/8OI5n174i/NedTdEP1pvrZZ/AEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787894; c=relaxed/simple;
	bh=XnVKZDr9XXzDhXGeIbv+VTsNo7kWr53t2t9B4bwhIjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd98A/ertk9IphXNRjeDK2bdl1hDOgRS5xTRapIgl0xKsvt422MG9/OfEXt5QKc57k5i0xcRfsNz3ksLfDAa8c6RAoTXnth+sKRtKmNN96A4yFxGrJcAsmmkiX2gWYGk2Qcv14eNF+pn8x0g9ZuRNjg19zwN779tiYSGQgGFu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIXLFcFb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F1C19425;
	Tue, 17 Mar 2026 22:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787893;
	bh=XnVKZDr9XXzDhXGeIbv+VTsNo7kWr53t2t9B4bwhIjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIXLFcFbAMraX2atbcW3r9Z+fs4ZD/daKD8AiV3tBTBKJ1S50NTymLNUxoszu+aLq
	 kqTLzEm7y//QxjgVbCsaQO8IxziAFguXcL2rNdNo/gaTNkDq9sG3hguBy6NADJgEP2
	 D69XncXOdQ9oMSsDXXkbS38LaQzJGchph9+WgLAGf9GdoGO1EOVRh3ke0CqflRSWnB
	 yapgHfMLJDPcKDFO8lWba2fVQVYqP1DbzSatQ31xhZVCoYHhvSZry6tqy+M/A6pRiY
	 UJaSR73MsQOgP9ueUx8Bvio4GHNWHeUSoWlnBuXxwmEoAjbvS57p9A0c9K0PAkr/RG
	 0QyVKkZYbsSUw==
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
Subject: [PATCH v2 03/12] arm64: Fix EFI linking with -fdata-sections
Date: Tue, 17 Mar 2026 15:51:03 -0700
Message-ID: <a0dcf72b74fadc91ffa2e683c4cdb5e8e2993d44.1773787568.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2223-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9653F2B33A5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When building with func-fdata-sections, the .init.bss section gets split
up into a bunch of .init.bss.<var> sections.  Make sure they get linked
into .init.data.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 2964aad0362e..f825e6a26918 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -269,7 +269,7 @@ SECTIONS
 		INIT_CALLS
 		CON_INITCALL
 		INIT_RAM_FS
-		*(.init.altinstructions .init.bss)	/* from the EFI stub */
+		*(.init.altinstructions .init.bss .init.bss.*)	/* from the EFI stub */
 	}
 	.exit.data : {
 		EXIT_DATA
-- 
2.53.0


