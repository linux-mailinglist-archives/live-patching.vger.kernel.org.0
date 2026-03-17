Return-Path: <live-patching+bounces-2229-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Hq1B9DbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2229-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:55:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F1D2B347A
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2A4A3192171
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE163A641E;
	Tue, 17 Mar 2026 22:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O05cfDTO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150F93A6EE0;
	Tue, 17 Mar 2026 22:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787898; cv=none; b=kidDNeSFBadMn9GnV2pxkKxyS88jdbt0EGP9Xy5aMPDbBMQIwd8IjVOKMhnCzqRX1bl2KHGIf4C6okw+5Y13aNdF148il3OoeY/IPuiqWZGzuUuHCGAr+m0nSWeI3JgrnN0MZhFNEpb9ceuBzEFMjJ99IVhkd2zq8gPcZjdi6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787898; c=relaxed/simple;
	bh=R5UiZpTiDDGQeFvx+x5fyQyw1CckBBaOg4b13Rc2GFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5wsdjCFiBrPagGlL7v5qPKXAbDb8NI9dwml+OXbsetkt3BtZw3eA4bmBBMpySgbZX+5ovB4aRrZuFNEzoYex5pmo8GKlp4+gGeFXsE3R0yzr6NfgsAk9UNLYgMYmcR9j3UsDCcrs0Atnbd3s0SLxotcdRrmdUdXCJOu1+SI+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O05cfDTO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16372C2BC9E;
	Tue, 17 Mar 2026 22:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787897;
	bh=R5UiZpTiDDGQeFvx+x5fyQyw1CckBBaOg4b13Rc2GFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O05cfDTOoUN0o/a5xAMBqeA6JBv53owzUYaz7WqDnkXpa361njl5XUGAkFaMMp3u+
	 9uteSon8YEXqmi+jXEe1qpNPaCBqv4N/2HWOLQAP1ZR5U9HilJnpk5b9lQ8QQS3qP/
	 AchOaEvUekQtgTWU2jBME/yHKvRBqBZXm3g53CQc/XrVVXNtflKnNHmV0OgBHYTRu4
	 M6WvQGBAlW8nS2eVCAG1S3aDOLmpnJvxUofX1XOWQdqs3mxsyhHEZNZJq0Zq/4uvNs
	 7O2cyuQ2IV5vDquka3y+dNWifbssa+Kb/l7nm05PpS9XT5ALSB0X6RcXdggHJgc9cA
	 UFb656RNfSzPw==
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
Subject: [PATCH v2 09/12] objtool: Allow empty alternatives
Date: Tue, 17 Mar 2026 15:51:09 -0700
Message-ID: <1d74ee9e31727870266ffb69ce0d6a4a40b8e99a.1773787568.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2229-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 71F1D2B347A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

arm64 can have empty alternatives, which are effectively no-ops.  Ignore
them.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6e33a29bd3ed..7297fb87f876 100644
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


