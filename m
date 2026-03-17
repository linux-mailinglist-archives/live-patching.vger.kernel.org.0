Return-Path: <live-patching+bounces-2228-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OO1SFAbbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2228-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:50 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 164F52B3379
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2A0D2301FB80
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E343F8E10;
	Tue, 17 Mar 2026 22:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qngo6z11"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FF63F8E06;
	Tue, 17 Mar 2026 22:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787897; cv=none; b=JZPwWnTrPtE+HY33O7ADQBulOXLgoPuMkxp/j/3wWShxQKeCK91+oELXy0EU5yiN0aD5O+o/7Ce8CXIkMk2pKrxxVO6lGVawyAHlqksn9VJ8LDVyXtSsmwMQPV3xyA/uDvhM8v6S37WRSvcUb8S/aLmKoXZmxzfzqz4kKGD8jmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787897; c=relaxed/simple;
	bh=LneP7wGKv2nwzC48EGP/qa4m/tgR04JXHfdr5Hy2OTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqGIIEosVqTBt1jKLpRHD0ljh+/s0qPNXeu42NQjCYIgL9q37nvImz4ErYO1uNInlDJptcAbBA7ummaA2YHXkgiuVtbmXZzpQ29JWFWYqfa379iH0HfxKUHpPD3djVlP1h8vd4IiVBPuBAeRSgwWRjeCflXg6U3CO+qqVQXiwao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qngo6z11; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75822C4CEF7;
	Tue, 17 Mar 2026 22:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787896;
	bh=LneP7wGKv2nwzC48EGP/qa4m/tgR04JXHfdr5Hy2OTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qngo6z11Y9Ew0q/w6MzKc0RDHuzv3zv3tiXXmAii/TUFdqaHGUiE77fX5laBcACdt
	 jBK8X+ZL41ymUm5gnCm4tvn376vpm2pJcgtRELAmhSl7gdxnxq4PCRwODiMjhPJF1G
	 v+lsWta3aS0+zy/Vopw3VMh0ddnhzp6yeJ+PzrOSY+qjni4yG/YrEVvuDOtJ+dW8dy
	 r61VBS8lpeF0XSxQuuHQiqosUWnGyBNdOpzknYHAkClT4p4QeiMuTGKIU9d4FTkpsF
	 hupC261b4CXaULZAnA5st3TPR4D0WnZ9UJTCcJUVlOth7LoPZ8WTBaUyKZ0pwqTrN5
	 HyhiNADADG70A==
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
Subject: [PATCH v2 08/12] objtool: Ignore jumps to the end of the function for non-CFG arches
Date: Tue, 17 Mar 2026 15:51:08 -0700
Message-ID: <f33fa991df5be569476769bcd970a555745028db.1773787568.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2228-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 164F52B3379
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Sometimes Clang arm64 code jumps to the end of the function for UB.
No need to make that an error, arm64 doesn't reverse engineer the CFG
anyway.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d428d63b29c6..6e33a29bd3ed 100644
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


