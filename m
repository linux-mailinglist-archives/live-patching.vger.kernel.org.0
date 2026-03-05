Return-Path: <live-patching+bounces-2118-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDWSEzb6qGnVzwAAu9opvQ
	(envelope-from <live-patching+bounces-2118-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:36:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF72520A941
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ADCFB304A6E1
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10677280A51;
	Thu,  5 Mar 2026 03:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbeqmIyq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2E27A92E;
	Thu,  5 Mar 2026 03:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681517; cv=none; b=dvafqRvOSSCIULbq+96b/1xCGemNoM5XnYRQP71q88R4bYekS/WS+/fhEgp1JSVDY4G+NI2TcW4Oya7ai9mFvn+5jPMmJvQJMQBmi/sIVWc2k//iU/5fpFtdhSoKsZ06ktZmXK+65PgjM04cj2HINzsmR+VZdlVZ6c0+2UxAGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681517; c=relaxed/simple;
	bh=NbzuW+7uujyEcZZ30AyHwoJE50Su+M8O/JLaUCgVuZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUuZwD85tKqzJ7fKVrpNfvJhPGR7skcRgJkcIsBJdrdZequjQBDsKhM6gZ/7OMmyKFJBzZPxYxw3ZyLV2pJDnq/fJBEwtR50x0dzeoCWRygBBBEmqRhgoUI4RvR/+OwB69COD7B0qyYzUbqqYPR1AtsdT9f22IDROZ+2N5yUMcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbeqmIyq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AF2C2BCB1;
	Thu,  5 Mar 2026 03:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681516;
	bh=NbzuW+7uujyEcZZ30AyHwoJE50Su+M8O/JLaUCgVuZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbeqmIyqV/ay83Ax51Gnb91by92icM4HeckvCSg7fd5//tXpXxY1HC8pfFb+VxIgB
	 mKpJtzzZEyUsZEntGsvM+LiTA2/dwgGVbrkRKx20sQLXEtlIKwl/VZb5HAtA8XXCaY
	 LIL8NZcbFooJ+11aFaXszGpQQlJWbhVKOeHbhqT2woGkqFe3yl4RoQE15CLNDY84xa
	 sbNZO7VDXSRfKMPQH3u/5bciI/yV1YbWoFs0Im2Dvkkd97yq3vbyl9gb4OkTMr52DY
	 QuQ7cVZ4dKMjpjTmuvqMSGrH84GkVszXcQMT8RZ3ReR0BeuaSyyEFPNtWVyFQxtt1d
	 Ja+0ZRFwtqerA==
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
Subject: [PATCH 10/14] objtool: Ignore jumps to the end of the function for non-CFG arches
Date: Wed,  4 Mar 2026 19:31:29 -0800
Message-ID: <4aaa59736860f593e18e5978ebd56e04e4deea9d.1772681234.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: BF72520A941
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
	TAGGED_FROM(0.00)[bounces-2118-lists,live-patching=lfdr.de];
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

Sometimes Clang arm64 code jumps to the end of the function for UB.
No need to make that an error, arm64 doesn't reverse engineer the CFG
anyway.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f73cf1382e5c..23cde2de66b9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1630,10 +1630,12 @@ static int add_jump_destinations(struct objtool_file *file)
 			/*
 			 * GCOV/KCOV dead code can jump to the end of
 			 * the function/section.
+			 *
+			 * Clang on arm64 also does this sometimes for
+			 * undefined behavior.
 			 */
-			if (file->ignore_unreachables && func &&
-			    dest_sec == insn->sec &&
-			    dest_off == func->offset + func->len)
+			if ((file->ignore_unreachables || (!opts.stackval && !opts.orc)) &&
+			    func && dest_sec == insn->sec && dest_off == func->offset + func->len)
 				continue;
 
 			ERROR_INSN(insn, "can't find jump dest instruction at %s",
-- 
2.53.0


