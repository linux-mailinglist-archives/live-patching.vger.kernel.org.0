Return-Path: <live-patching+bounces-2119-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJJ8IUn6qGnVzwAAu9opvQ
	(envelope-from <live-patching+bounces-2119-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:36:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FF920A950
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 924C6312A132
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059DB2882B7;
	Thu,  5 Mar 2026 03:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnH7Qa8k"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74452877E8;
	Thu,  5 Mar 2026 03:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681517; cv=none; b=Xh8kSDQnDIIvcYAlWu3VupzHbe11H7USeVngoyYsvwYNvpucWtIPuQZqrejXHsFq4GJ2tYWvOSJenDaae88xKzCw/SBIq4zGt7pNFWmwexEIIb+HdGbH7asY6NAZo7MVxM3S/tdfjpiDxUIPNyREYfyws5qA9PNa4yfcvu7Hm4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681517; c=relaxed/simple;
	bh=sna7ujIJJX2wXpTTTo8a2xChNhDmAoSGFIkZMWk8srk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg5mf1dFqnrdL90s8syIa0D+GgIw8WNCW4taRPrioUcEi8daQZERKAUvXohBLt4+ZUs0mn5BFX5N3OEyXCYrhx108llaYpRAy2/lrO/ckCkKgIT/xl1wJeBDGv1FzK3durStKGMIMXIL1rTWqoTYauNc+9sVEsnlEY50tmLJr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnH7Qa8k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF595C2BCB2;
	Thu,  5 Mar 2026 03:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681517;
	bh=sna7ujIJJX2wXpTTTo8a2xChNhDmAoSGFIkZMWk8srk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnH7Qa8ksu5mf2Gv83mjE9ZsD2k9/WUi6+NShvNbex9IjWIn3FsbOpjntGVs94l6B
	 QzuBnY9D8YVCERpjOgzHblVCNp+ffRlo4EHKVHDd/y2EUiau9BCvyJNRhBX0jdWBSf
	 snR5BLCyVcjqKjLO9YwXX5pRM0MklJCyN6Lnh8rGep5d6GIoe6YXLG3dC1ENAu7t7j
	 l6EN+ZGfOWwAb/dKcgfhy5vtvk7LJqcFSY34MDMHHAyx2PCBnpQWbGR8uITU4L/qgw
	 myvTfGj0zoFTtH7Rln9KExt3KT9/T1v5EgK3ljf2qZSKx85bksHnQf0+ab4yKNfSpu
	 VlaIyS01/c0Kw==
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
Subject: [PATCH 11/14] objtool: Allow empty alternatives
Date: Wed,  4 Mar 2026 19:31:30 -0800
Message-ID: <1af3deb308fd59086b63690c1e7b53586ba3c5e7.1772681234.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: D5FF920A950
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
	TAGGED_FROM(0.00)[bounces-2119-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

arm64 can have empty alternatives, which are effectively no-ops.  Ignore
them.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 23cde2de66b9..036adbd67488 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1994,10 +1994,8 @@ static int add_special_section_alts(struct objtool_file *file)
 		}
 
 		if (special_alt->group) {
-			if (!special_alt->orig_len) {
-				ERROR_INSN(orig_insn, "empty alternative entry");
+			if (!special_alt->orig_len)
 				continue;
-			}
 
 			if (handle_group_alt(file, special_alt, orig_insn, &new_insn))
 				return -1;
-- 
2.53.0


