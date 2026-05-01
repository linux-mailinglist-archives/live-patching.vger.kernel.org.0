Return-Path: <live-patching+bounces-2653-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4CZlIC8p9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2653-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:16:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 835A94AA2F4
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9756230445DA
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E573361DA2;
	Fri,  1 May 2026 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QB5oC6EX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6DA3612E2;
	Fri,  1 May 2026 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608547; cv=none; b=HXgSJsqpvRPOh1lt74/nL850YxyAlusmR+doBdLG3zamwmMvYO/GUEcN0FID+5AjApPxxs2zvx65kZFB1e3bxibaP/DQ6v9gXrMb+a9dZzSnqliQwJorHMxu7Sc1GPljeJBDJzk5mCsNG26ZH4BSNP3mIULxe3cBunIakQ7zOk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608547; c=relaxed/simple;
	bh=A20AvTEi6L7BTg1dmFVmmAv0wnARcCkDo3eAoHGEx18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAjtPUjx/Aw3vhtBngDIOPLRCd1tqVamb7WsO7HzmH7j7A3Sf+5vABkV0mksGkQy5aiMNE3uqDkt5G9BMg0ro4RqGaDaf+hTyFjqPEwUubxGsEvFz9KVCQ1OVnBfZzxbjrmGli4iQugsFTR3Xg0faO2zvZa0fUqAr6VpWy79f3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QB5oC6EX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA183C2BCB7;
	Fri,  1 May 2026 04:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608547;
	bh=A20AvTEi6L7BTg1dmFVmmAv0wnARcCkDo3eAoHGEx18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB5oC6EXQuZuIm1Lm526qA7zPBS/EdBCRZasdGQirjZkD187LtH4hegD3QrY4Uuzx
	 WzCcAx2hkcR4WD4BalX17dCnMQSllG2/1xu/SSo1aOF2ovxPP9uWykEKz6hiebv1ut
	 RIu9XTRi0tybY9uggfR0AN+ZyzMuHEvSmiVAJmJCAfKX1j35/8v/qhyn7cn83ORRbr
	 vRHSWqRY3uk/RbCYFaegcmGTQHKwcl4X+DSdrOe0RH9zU70Ytp8+9unQXduyTnTKsA
	 l7F4a3w9TE/n6Bi18MNCGzjO2qH8iIcNZKvkVN+uyyBGr7ch7KQW7RMkVkZ1rNm4vw
	 Pu1kE8716wpKw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 36/53] objtool/klp: Handle Clang .data..Lanon anonymous data sections
Date: Thu, 30 Apr 2026 21:08:24 -0700
Message-ID: <a51923df411316860fd18a0db85fdf465d36ddb0.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 835A94AA2F4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2653-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Clang generates anonymous data sections named .data..Lanon.<hash>.
These need section-symbol references in the same way as .data..Lubsan
(GCC) and .data..L__unnamed_ (Clang UBSAN) sections.  Without this,
convert_reloc_sym() fails when processing relocations that reference
these sections.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 463b6daa5234..7e58ef36f805 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1030,14 +1030,15 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 }
 
 /*
- * Sections with anonymous or uncorrelated data (strings, UBSAN data)
- * need section symbol references.
+ * Sections with anonymous or uncorrelated data (strings, UBSAN data, Clang
+ * anonymous constants) need section symbol references.
  */
 static bool is_uncorrelated_section(struct section *sec)
 {
 	return is_string_sec(sec) ||
 	       strstarts(sec->name, ".data..Lubsan") ||		/* GCC */
-	       strstarts(sec->name, ".data..L__unnamed_");	/* Clang */
+	       strstarts(sec->name, ".data..L__unnamed_") ||	/* Clang */
+	       strstarts(sec->name, ".data..Lanon.");		/* Clang */
 }
 
 /*
-- 
2.53.0


