Return-Path: <live-patching+bounces-2453-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NH2GWad6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2453-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D168F44CDEB
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 620BB3099541
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB653D9DB6;
	Thu, 23 Apr 2026 04:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgRKYwn7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A09D3D9DAF;
	Thu, 23 Apr 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917077; cv=none; b=joOjGXuapogl5rpfDH7GE763CoOvAgRNEFvnp0LxTY66gyYD1cKKaiP4J+P84JdviBGe6bMDFZkB2uIOSBtaihRB/g/y1BW8brEkKv1eA7/6/eFqk5lbItog+JX/yrlRtFnmRXA3BV4nxXZXREqCuv+1CLMWhtJg6x99YqiE0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917077; c=relaxed/simple;
	bh=wnpusLmivo25BkT7sUHXFVVaM+q/AHUvZQDgUKM6pzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5okGyH60jorg/A89TvzISgcl9PCDoc1+M07eCMr9ST3ySjt2hq9rjlnHqlPJ/z953oWpSwiYrCE3LqV30KReHAMJs0FoZ2J4vDaN9GD37v0SF7YFmx4fwClO4Q/Equ1Zz1FFevLYLkrX+v2iHEE5ys1nbsuQvsLruFOO2JenhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgRKYwn7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595DCC2BCB5;
	Thu, 23 Apr 2026 04:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917076;
	bh=wnpusLmivo25BkT7sUHXFVVaM+q/AHUvZQDgUKM6pzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgRKYwn7zuHMyDCME2tVM0CJiWFcCyJzmQ1f8KCQj6EXk4/ZH/K9giih0e+aCvZG0
	 EIteuUCtIoETM1+9Qr67jApBQU/dAtUNmvnD9zPmO534+3g6DcbD/AtdArXIYBaqgo
	 5dN+VSrU5HN8l/4yAWvxIxnEJaAqTQvMCMYe4M31CNMWoqz376unCK/ifTdeU0iDvQ
	 Kklpl/2CqG9q4YzUm1ZckHFImbtcYR9Lnp5DjFWqsUVTUKH7eeNJ1oZiYimhBDxGoW
	 9ya7xYNpObRrUKzGWx4eso0S/oE2X+/w5sTQ6eL4c+xHx0BBftsXorKfHSsie09LrY
	 nWkvzyOw+5avw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 26/48] objtool/klp: Don't set sym->file for section symbols
Date: Wed, 22 Apr 2026 21:03:54 -0700
Message-ID: <a051f7f3c6adb479cabe0b4e1f08552f1412583e.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2453-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D168F44CDEB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Section symbols aren't grouped after their corresponding FILE symbols.
Their sym->file should really be NULL rather than whatever random FILE
happened to be last.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c4cb371e72b2..00c2389f345f 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -680,7 +680,7 @@ static int read_symbols(struct elf *elf)
 
 		if (is_file_sym(sym))
 			file = sym;
-		else if (sym->bind == STB_LOCAL)
+		else if (sym->bind == STB_LOCAL && !is_sec_sym(sym))
 			sym->file = file;
 	}
 
-- 
2.53.0


