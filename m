Return-Path: <live-patching+bounces-2436-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEsSE/6a6Wm0egIAu9opvQ
	(envelope-from <live-patching+bounces-2436-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:07:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 405E344CB50
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 068BC3014936
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85213D349C;
	Thu, 23 Apr 2026 04:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZhHZrol"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C2935E937;
	Thu, 23 Apr 2026 04:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917068; cv=none; b=AoB358XFiJpQjpfyq/QR9Ib/Y+eeTXJ2p76VqOWqR8o/YEmmD45890QbmufD6koUz/cGfM8TQ/fbsSsljewu87E2llbbgk/iv3sotYfIDnAbYk8M7UDi2GJbrCfNtj4fd4Kww/f6m3zfxlFBxmEzMKm8OPigi1Fp4wrYJI69TLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917068; c=relaxed/simple;
	bh=IJ9wumKXfu5EvewV2eGErMj5akhjS9yL+uKUgD0DKhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+Grybzxj1l1wIct9m3P9iM7JguFm+FDe7ydHMxqCBi2SsyQHIi+mq2eO8m0tY2IPD+urwrrxEXjqWNtFyqNqgT0CPR2C07LYVM1g0jIqwqcsbCtJDXhLu8eHP+h2PikkVL+3DWDH5lvabrnlyacrfcOsS59PeCOfuoKusVYQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZhHZrol; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C289AC2BCB4;
	Thu, 23 Apr 2026 04:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917068;
	bh=IJ9wumKXfu5EvewV2eGErMj5akhjS9yL+uKUgD0DKhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZhHZrolGJo0ZQrnW/m+WlJu5aSIOPOhdKFKrBwsV7HhYqL42UWZfp+V/4r9NE1t4
	 BVT5Om4jp/Z3tCdX2QeC3N7CVxlHKwI/VhnBwzK7UP2wKERKbwr8fDK/zWNHWKSzyk
	 RD4jSv59JN6CeFR7hP3v215QZYnBGfGZTLzB1QFOTNaAoPADpkCojGD6JG6qKiljqa
	 2/9Ad51x3d3lu/idNCHDVeWPEQ5FWqnXr//7wj8ClgCzQR4Vo1rLng1jPDzMgwMnJs
	 DCDXDQ3MuXUmJr5aAJQbJkdMV5Y/L4F/0yDjNZPChnSHVi+qVfBTW3Vl0I06jchWzO
	 uezoqqefncqaw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 09/48] objtool/klp: Fix create_fake_symbols() skipping entsize-based sections
Date: Wed, 22 Apr 2026 21:03:37 -0700
Message-ID: <e10231fce5d8f3f17e4cc7a396a4a8e8d791f994.1776916871.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2436-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 405E344CB50
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Joe Lawrence <joe.lawrence@redhat.com>

create_fake_symbols() has two phases: creating symbols from
ANNOTATE_DATA_SPECIAL entries, and a fallback that uses sh_entsize for
special sections like .static_call_sites.

When .discard.annotate_data is absent, the function returns early,
skipping the entsize fallback and silently allowing unsupported
module-local static call keys through.

Fix it by jumping to the entsize phase instead of returning early.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Assisted-by: Claude:claude-4-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 022522cd9b6c..767716766d41 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1375,7 +1375,7 @@ static int create_fake_symbols(struct elf *elf)
 
 	sec = find_section_by_name(elf, ".discard.annotate_data");
 	if (!sec || !sec->rsec)
-		return 0;
+		goto entsize;
 
 	for_each_reloc(sec->rsec, reloc) {
 		unsigned long offset, size;
@@ -1407,7 +1407,7 @@ static int create_fake_symbols(struct elf *elf)
 	/*
 	 * 2) Make symbols for sh_entsize, and simple arrays of pointers:
 	 */
-
+entsize:
 	for_each_sec(elf, sec) {
 		unsigned int entry_size;
 		unsigned long offset;
-- 
2.53.0


