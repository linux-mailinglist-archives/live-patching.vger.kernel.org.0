Return-Path: <live-patching+bounces-2754-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCU1DnzxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2754-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:35:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9268952CCA1
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C3CA3083456
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FA0397323;
	Wed, 13 May 2026 03:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNxtfagA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC7395AE3;
	Wed, 13 May 2026 03:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643272; cv=none; b=rU7WPwFBF1YIt3APZPO4Dj4u+1VapqVa1m/wM8Q2I237uYHmwSRHOitTv1EZ3BlS1Bdwkr+ZHrzccRdSF/G4+s/hnei1YG4h9y08x3jiAY4y+4nATfxQloUxCsmS4ZMgSWrb3W7bqKaQL2jgRDyPKmomjsYJgM4VV2toB7Dypuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643272; c=relaxed/simple;
	bh=LhHK0lCryH3GfUbhtNycvw/+YpO/Fwf9dWZJEbuG8Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieo9X8oKkLpke4oqyL5hmkyWNHwvvuLgtUSNGEty81Ln2SvcdLuO898iuCC8ervLoalfvzoa8ea+9z7JkNqGXod6cxm270cfEZwo4JXv1u0lr3LWprBbcCrRAtUJAu+EFzpxRpiRUhPNbOOv6DQAtZp67S7iVYM1i/UdmWBqr2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNxtfagA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8992C2BCC9;
	Wed, 13 May 2026 03:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643272;
	bh=LhHK0lCryH3GfUbhtNycvw/+YpO/Fwf9dWZJEbuG8Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNxtfagASYgYVYf1umkw+kM2WaikjdPtSOls1zGgc03ZsJiT9PFu2l8y1CWdDS/r0
	 KcYXbYeQkvoNFIDyvxRqbSmKa5kaQDL2+94KzG1ZqzDTQ2iNFMDb3ytwVxz0fzTFbT
	 w9OtedfmjwJHTR2cDz+vJCJ9BJw+IY32/pHZvo+RqOZ2U9kFwHQl9gpSZRS8AQ7WXk
	 x+Y7Cf198wdLgHWYjrQnrpKCGy3dmLOnlYhEX1PSis/Cd1b0EWkOgtCrs5axbGf1LB
	 UJNEOIkwyzk6MMDhbieMpPa4BsUO8llqizoEIWXfZ02sNUxy/vU8uTb430nzBeENMh
	 jNVc0uQ70vviw==
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
Subject: [PATCH v3 03/21] arm64: Fix EFI linking with -fdata-sections
Date: Tue, 12 May 2026 20:33:37 -0700
Message-ID: <1e5281cfb9a7daec8283e46e2879be8ec468713c.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 9268952CCA1
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2754-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
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
X-Rspamd-Action: no action

When building with -fdata-sections, the .init.bss section gets split up
into a bunch of .init.bss.<var> sections.  Make sure they get linked
into .init.data.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e1ac876200a3d..1ad7e3dba460a 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -281,7 +281,7 @@ SECTIONS
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


