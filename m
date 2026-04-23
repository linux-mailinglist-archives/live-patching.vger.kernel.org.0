Return-Path: <live-patching+bounces-2455-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YOX2J7mb6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2455-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:10:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8348E44CC18
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9096B3056E25
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8353DA5A0;
	Thu, 23 Apr 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+BEhp90"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF483D8128;
	Thu, 23 Apr 2026 04:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917078; cv=none; b=fGWQuKDgOk9gFMr63IvNSSkqghNyY98WuHU4yWRjg79IpSvWDa+l8zWQj7JTP1hFRNenSnxN34VPW6/XmVUtgv3ge74DFU+ofPGARpV7KU9q/y35S205NDNmkgQgZZWKwiSPBJHWNSj4a6778XF9ywhsho9UJFczVEtjpF51UFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917078; c=relaxed/simple;
	bh=1Yg1WyHHwy/0H2Hyiv4fKLbjE8nOHP0jcAPFhtPhwmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2ICY44874ELcSpywQ4oOcHc2nqpqauBMjEy3qqJALKS8pILYdjGq8TtaJQd/SpH/rewAhZOi3cR1WWv0McAY4y9uHTmWSS5RchyyKvoC7EdfuWi6nBECUKI3jLMYfgd3tjHIt5ysBvEr2rPnln6XRzsf0k6EG7JivMsTYYzlAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+BEhp90; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64267C2BCB5;
	Thu, 23 Apr 2026 04:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917077;
	bh=1Yg1WyHHwy/0H2Hyiv4fKLbjE8nOHP0jcAPFhtPhwmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+BEhp90S2/pTZYmbAeudjUuutJYGuZirc5cLg+dQE4S4ZuENehhW1QJTpUQNa++m
	 rNkNfdXJsjY8xwq0sbGfEyxRZBkYxKCdgt96zw2Eb7bZQmBzIcQfKK/x0k9WDYgTmy
	 xcJVvAjiOMLPbITUAYdwOcGyaKW8pBG0ERNhwTRjDWt4olhtBp/PQLUxfowV3vvqq5
	 8qUfqbtLN4bG1CXK8FFml89FMWqG8fIyQhB/zPtteZES5I7H8Hy0XdUuf1MhOLVaWo
	 i2Iwwo0t0xRNFwekJej30uJwjJM2aXOuPW3pbjHWcIceof96Kpf6rDJvQ4lPhiLZcz
	 8tgJMm8Ld2AXg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 28/48] objtool/klp: Create empty checksum sections for function-less object files
Date: Wed, 22 Apr 2026 21:03:56 -0700
Message-ID: <199a3d975e8e562421edd342b9eda242b4f57a71.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2455-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8348E44CC18
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

If an object file has no functions, objtool has nothing to checksum, so
it doesn't create the .discard.sym_checksum symbol.

Then when 'objtool klp diff' reads symbol checksums, it errors out due
to the missing .discard.sym_checksum section.

Instead, just create an empty checksum section to signal to
read_sym_checksums() that the file has been processed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f14212a8c179..54ceac857979 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1044,9 +1044,6 @@ static int create_sym_checksum_section(struct objtool_file *file)
 		if (sym->csum.checksum)
 			idx++;
 
-	if (!idx)
-		return 0;
-
 	sec = elf_create_section_pair(file->elf, ".discard.sym_checksum", entsize,
 				      idx, idx);
 	if (!sec)
-- 
2.53.0


