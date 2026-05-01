Return-Path: <live-patching+bounces-2634-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNYZO7In9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2634-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7284AA11B
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ABE94301DA44
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D0A32860F;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJyjMQur"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73762FE582;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608538; cv=none; b=Y3MUA+F8d+F6uY3ox9EN+AVpDiZ502Vc3I6DEbrdYXaO4eNz9tdK7Wl3cJvgQXM5wfN51AhKNrfqO+vStrqU/Udc8EAtv0wF4MceGtlZwsbeCjQjxRcj7h3KGE/k+PGRo6v9cES0C5Z+eNDNmMA0w9PFXTg6f/pniHrnE13cz8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608538; c=relaxed/simple;
	bh=Thr4wxf4FdYm4riP7kTt4KLaS2jq2dvObY7uSSp6BGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV9F51WfluO3a3uLvP6XdA7yZ1A5r36ZsFL2dhnpHeEmguJUaLfykHWzWakY8QYj++orgB/JWWB4wZ+wPkUwsgKCswdB95j9HMh9ojTxWEEPAR6v8MAlGhkySzLDo+y+nn0OA6d94AFq447rJZF6V1F9jHyp6wYSqcYdUkgNYdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJyjMQur; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E367C2BCB9;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608537;
	bh=Thr4wxf4FdYm4riP7kTt4KLaS2jq2dvObY7uSSp6BGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJyjMQurpP7bce3TU0VyQPZ2tPmM4SjR54i0OeNfSC7P839ow9w/sT0FTiZPWXr2U
	 msY4oS0SvX+r1c7aTBR9LWdLNztOlLMoFVpWFjmk6io+Hu5OkFqY6LrkuY5PFDtjHk
	 Wn3LWXSXtmNhzrZWtbdYLIQpZXjBL00RLE9gaL2zXvDCfDzOTxb1Azn6UL2iPyknk6
	 CXc1osdacDmOdLw+91gWAmD7E16orh1hj1xuFwcB0zPJBhUjhEUwVcRstNKceI9A+/
	 GjjmZMHNpVmS4BkemyRZ4MA2Y6qgJijW7cLSNEiMsq1vdPGCYMjiZx224W2DyWmh4a
	 ktj9w+is+bl9w==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 16/53] objtool/klp: Fix relocation conversion failures for R_X86_64_NONE
Date: Thu, 30 Apr 2026 21:08:04 -0700
Message-ID: <00a7102c356daf80ebc8af174aa0c45d3cd56c96.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: EF7284AA11B
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
	TAGGED_FROM(0.00)[bounces-2634-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Objtool has some hacks which NOP out certain calls/jumps and replace
their relocations with R_X86_64_NONE.  The klp-diff relocation
extraction code will error out when trying to copy these relocations due
to their negative addend, which would only makes sense for a PC-relative
branch instruction.  Just ignore them.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index dd0e51dfc621..19bc811db396 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1033,6 +1033,9 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
  */
 static int convert_reloc_sym(struct elf *elf, struct reloc *reloc)
 {
+	if (reloc_type(reloc) == R_NONE)
+		return 1;
+
 	if (is_reloc_allowed(reloc))
 		return 0;
 
-- 
2.53.0


