Return-Path: <live-patching+bounces-2457-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gBmQK6ee6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2457-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 142AD44CE98
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CF7D30DAF2C
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC063DA5DF;
	Thu, 23 Apr 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1CyKk4T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5233D9054;
	Thu, 23 Apr 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917078; cv=none; b=C41vCt4c/ns9BQz6tJ8PFutRAVPLM/+SphJfrjEw3DNe0pzZtUfJMJS+ZSUHo7WZVNYGjO3S1IEPHOoln+9jyhaRZDUrsHqZx6av2KifCXLyR8ybMAuSBNdrLg6oNRbd5Hj0lgK49A6Qr8u6T1t4LJCHtjqYl/dFad+vkuaRgIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917078; c=relaxed/simple;
	bh=KwniOSZKrmfZmefhKpGgVT9FoHPJ4cAvLoUrNHUDbJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO52PT6ER0O2NvemCwnJ5oL/KSSnMIdHUNQwvkuKXi41bvdz+HEFfzSHtKgvGLyCwTIWgu1/CDxjtyCXYVr8wA0mi3DgzIgQ9xd6srVxH5dc1E1MA5Y/EvZt8pxBvrqKaA4kSe4WpW4pVn+SS8Oje9/AAZK9e0d/u24914YBym0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1CyKk4T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61996C2BCB2;
	Thu, 23 Apr 2026 04:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917078;
	bh=KwniOSZKrmfZmefhKpGgVT9FoHPJ4cAvLoUrNHUDbJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1CyKk4THXKlJgNsmI0gbgKN8TZTwhCka7ORFxagTbgY21eNJKGH4Q/2+fWGDTaSs
	 DeTRt3sF7mzTUNZm4/bK4ytEAqtQ7ztlfMNYGr3DcD+/S6zR7h3VAgWqe5Qx18sybC
	 rdEqw0JXaIhlO7Zcnk9WDctDIOnEpVa3mDkW5PdRiuRzrH8/xk6Ifgmnrjfx2TXDEv
	 1f+3EgMbAjdVKRlUorcCeimSerbNAuo5aRVOuhNzEKAIs43LQPeRlCFfQh3DlOccub
	 JcZ+PtgBF8pUT1w7xk/cRdxjGcAsYVzhUZkB2HQ42bPyNi/9IQZQX3YVOxJxbLF03Z
	 IoXlSwPDCWSfA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 30/48] objtool/klp: Handle Clang .data..Lanon anonymous data sections
Date: Wed, 22 Apr 2026 21:03:58 -0700
Message-ID: <11a0af398f5ebd591e87f3f8627bbf512260549a.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2457-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 142AD44CE98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Clang generates anonymous data sections named .data..Lanon.<hash>.
These need section-symbol references in the same way as .data..Lubsan
(GCC) and .data..L__unnamed_ (Clang UBSAN) sections.  Without this,
convert_reloc_sym() fails when processing relocations that reference
these sections.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 57d2af98a33c..1951a8b2df44 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -873,9 +873,10 @@ static bool section_reference_needed(struct section *sec)
 	if (strstarts(sec->name, ".rodata"))
 		return true;
 
-	/* UBSAN anonymous data */
+	/* Anonymous data (UBSAN, Clang anonymous constants, etc.) */
 	if (strstarts(sec->name, ".data..Lubsan") ||	/* GCC */
-	    strstarts(sec->name, ".data..L__unnamed_"))	/* Clang */
+	    strstarts(sec->name, ".data..L__unnamed_") ||	/* Clang */
+	    strstarts(sec->name, ".data..Lanon."))	/* Clang */
 		return true;
 
 	return false;
-- 
2.53.0


