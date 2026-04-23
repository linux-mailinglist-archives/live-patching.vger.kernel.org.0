Return-Path: <live-patching+bounces-2443-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOYEDXqb6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2443-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4429144CBB1
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 336C9302344A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F243F3D5670;
	Thu, 23 Apr 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7YtDtnh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC423D4125;
	Thu, 23 Apr 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917071; cv=none; b=CjGsYeMWmvCbGqjrpL3XRqWuAs4SYetwdMo7L9RfnfpcD53kHnequuO9MwaIO+oj0ntnNB3YPnZ5HLXFU9cUPIicvXWNPgu0V7LB7+AcSznNBVmTh+HLpbWGpV90OyUs9TSmpPjw7fo186FwrmuX8RBfxhid871521TgeGhr7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917071; c=relaxed/simple;
	bh=vt25iPC4lRsFBzlUwIK2gTOLg/NqXONtzBsE6CA3csA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXvXW/3seY8NQ3Dlo8Gm1ikuEmitU/tQV2betkSchAPcjBOtTzNKUarlVFfzIhuiNyrwsUQ4jzWgQva/NiXImmow3K18E2HcfP/+FFpnuD79M6ZbCTg2uC0/jrPBCl5OLcKyr+THeaqQXH3o4y7h5QzeNupwjMNVulROGXVxfAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7YtDtnh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CADC2BCB7;
	Thu, 23 Apr 2026 04:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917071;
	bh=vt25iPC4lRsFBzlUwIK2gTOLg/NqXONtzBsE6CA3csA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7YtDtnhNFfWXg6YUcDXazyDy9KiR+fXE2zvSw3qwVRT9/u2bjvG3171N/a6x/2c4
	 3oghwh/CnhTLxWwoCh+pqIYGQPTBtlW2tv/1gtDWe/C1kYRu7B7PEFgSUeUqXA0vCu
	 4vGR9FB1OAIY/ysST9Cp8LZqjZJjqDNCBCLzN1cba96SnfUo6zYulpm9edm+KXHRXl
	 MjVaVin0jgVXPFovWErTMNbq+4O96HIo92rfbXfbVBYidbTv4jdq8fppOXStehNPKJ
	 RSgsOyDOPeDKOdGrenkvuIFcGMS+686oP0BKfxJPK9X/FYvyTkLgBnQhjeHnfdLJ9S
	 OiUK+b7W7mPoQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 16/48] objtool/klp: Fix relocation conversion failures for R_X86_64_NONE
Date: Wed, 22 Apr 2026 21:03:44 -0700
Message-ID: <2779114efd74a9dd9f1e78076e1b9e3a5273de73.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2443-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 4429144CBB1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Objtool has some hacks which NOP out certain calls/jumps and replace
their relocations with R_X86_64_NONE.  The klp-diff relocation
extraction code will error out when trying to copy these relocations due
to their negative addend, which would only makes sense for a PC-relative
branch instruction.  Just ignore them.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a8b9a1441e7e..57d2af98a33c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1048,6 +1048,9 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
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


