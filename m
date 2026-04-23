Return-Path: <live-patching+bounces-2439-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPZJN8Ga6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2439-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:06:25 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83BBF44CB1F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7225D3012857
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0294C3D4127;
	Thu, 23 Apr 2026 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBXE0E2c"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC763D4114;
	Thu, 23 Apr 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917069; cv=none; b=uVXgBVkW9rOoPB6HJScdEu94vXZRoCLYrwZaF7Syrc0IYr1Mxs7aBhPWmC2eNSVBQgfPNy/B7oCBNWw/GMULjzafVbBepAPCx3CFusL1/iyadMWGGFx+AmwSYoO9hp+tyt/F4BJIinZoW09J/+z3y3JwcJuTJYhLCLseHb345fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917069; c=relaxed/simple;
	bh=bzJBvGoGyO4TnHZ5apFVQzs3GCgFKmm9Wup3gNMX+ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlUSHRnL7encXhNXUfxMsGw/VzcHXxu1sI0nxB9ZtrD4JYWbVvPrLgf3V1FeMqH0AafGXruIqsIfKygmWOuHjH6hjh/fankAfIzoo54UHHQu4Ym1yQqT+1tFN9/bntylyOR2RFtrD/89xFt+o9zS5haVSCNbFsEsmG7/YgBCPwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBXE0E2c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAC5C2BCB4;
	Thu, 23 Apr 2026 04:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917069;
	bh=bzJBvGoGyO4TnHZ5apFVQzs3GCgFKmm9Wup3gNMX+ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBXE0E2ccU6hLStbQ1hi8YCScxAKPS0AjcS/vST+KZglJdttIsUu34fhYQXX03WKA
	 EL/VWpNFh74xEsFiuZWJWGL1C3E8LK7ULuB3Sdu4gRrmGW3EDSnTKx3oHkFXKyoZd4
	 IEZ0cIlS1soOGWCXsTVp2ry0wR/2CVZK6qVJruZeQQ4Uz9CU4Prxg8s4xqeDj5SWYA
	 /6R+3Fi3ZP/G8osKzKGWFYxhFR5/qdyqoKIEx0PhuUDjWl9iJvwyevog2jPeGsuJdy
	 uVLFJ8Le/hA57JSTq9xT72RSLIblEuKc+ATLXbe9DooVU/noau+aVILc/GcZELxcuD
	 WqZTsH4n8Dftw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 12/48] objtool/klp: Fix cloning of zero-length section symbols
Date: Wed, 22 Apr 2026 21:03:40 -0700
Message-ID: <2a02cb0d5de7a60f5ef135dac071c93f6303bd82.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2439-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 83BBF44CB1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fix NULL dereference when cloning a symbol from an empty section.
sec->data is only populated for sections with non-zero size.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 7f6f86117394..3303664a39d7 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -696,7 +696,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 			size_t size;
 
 			/* bss doesn't have data */
-			if (patched_sym->sec->data->d_buf)
+			if (patched_sym->sec->data && patched_sym->sec->data->d_buf)
 				data = patched_sym->sec->data->d_buf + patched_sym->offset;
 
 			if (is_sec_sym(patched_sym))
-- 
2.53.0


