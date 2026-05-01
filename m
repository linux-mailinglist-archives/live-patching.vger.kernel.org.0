Return-Path: <live-patching+bounces-2633-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EQVE6sn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2633-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A4F4AA112
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 43BD3301C3DF
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE45E3242D7;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwrgLeB/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC04322C88;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608537; cv=none; b=lp7uutNxbO5xTkx9wOOjVSjKMJchYhYh7gEC1sXZnlRGY5CdYtiFA1wE+SO0d/OOcOpbjkQ81YLx0r8RWH9GYib3EJELb0jkE3a64S6DuFfNs3UiQ21oyrPWUO9NzFNglMNDgtqVITdvsxCKPmqUhWLtrebUNH0zyuaFxxk2mGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608537; c=relaxed/simple;
	bh=EDtmbPEuWLU6hPRugmbzubNjPHNatHodc8G92yCghyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAUEtZFx40RSHnGzNmWQpxGZ06pSTyCbkArrjJAZNMZH3/Cq8JpfU3nMm1gWEAh9ACJ9uRdX/rLLSBFMFsdFT3VxSr1neR/FmKOzwAmniL+IMgIlhW30hBQAgahhSD5mdaV+3iAEbcoJlY0JS9WWQbqEIDVWLu9ulAqA0bb9gQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwrgLeB/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB13C2BCB7;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608537;
	bh=EDtmbPEuWLU6hPRugmbzubNjPHNatHodc8G92yCghyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwrgLeB/GQssweY1OnM/53JyxBSjI6RVMzj4r972uDlK2psn5AQoUDuzsPWkV6VaK
	 y0zu+unBqOuX+sw7V+zQIH+5Vh+Inj3+9FzJot1N8T3TZ0PvavCZ3IzzK/xO+X4bY+
	 YanT3iU/mmebqgIfMObrUXE9gBZ4MQzA9bOlyLwQx5vqHtvB5mT6MyY7xgTuyVwQdF
	 wSo08tjqdODsjSgAIsKRvFVCh4hHIckTCvaYSDFyHau/PsYBp+cxrn7Jp9aiVRG/na
	 vvPDBKTewbfYOUWd7biFYJQdKdyaJQ3gkcD+BwqaxBUY3o878tocLqJsI76lNikE9/
	 TgYIx0uFNuTZQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 15/53] objtool/klp: Fix kCFI trap handling
Date: Thu, 30 Apr 2026 21:08:03 -0700
Message-ID: <d1c817ed4914235042f13d69b495f87120be2ea5.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 83A4F4AA112
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2633-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

.kcfi_traps contains references to kCFI trap instruction locations.
When a KCFI type check fails at an indirect call, the trap handler looks
up the faulting address in this section.

Add it to the special sections list so the entries get extracted for the
changed functions they reference.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 42970b38728f..dd0e51dfc621 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -291,6 +291,7 @@ static bool is_special_section(struct section *sec)
 {
 	static const char * const specials[] = {
 		".altinstructions",
+		".kcfi_traps",
 		".smp_locks",
 		"__bug_table",
 		"__ex_table",
-- 
2.53.0


