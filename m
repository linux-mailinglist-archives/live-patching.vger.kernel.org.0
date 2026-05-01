Return-Path: <live-patching+bounces-2643-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLOxGHEo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2643-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:13:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B6C4AA239
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C59D303FFF8
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF7D346A0D;
	Fri,  1 May 2026 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heUOuFNp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4E2BEC5E;
	Fri,  1 May 2026 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608542; cv=none; b=dXiI6wrEdRTr/PQE2azJwpWnHDt8dYQnTujNit7YluDFDmiMzU0cU3V4v4qVNee1xBo3lJOdgXpAUMnYlulrWi6XMTUXhd2zDKVGrvwQ2vND6cVC6m7hOuu27iGH91ehO3Hz7QG4a01UwtF2baDnvNTC1g9If1BSp1C6GOGQMss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608542; c=relaxed/simple;
	bh=duf4Qn4jJibidhGOYvdLIG55cwmiQxtfrqGHJsT9MI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUc3QVm7cCl9pGh+5c/G6HNkIjoMBGPMENYpxUA5A4QRDgpIh0vYdjGTzpdtxWBilZ0C/ZwS4XmKPcRaXbefN6P6xaOasCQBoVoGMDAkYIx7w711Et1kmG0Eh3G8LXY9Y+81sVN0eJYRbH4WNlgWrxHvYAZ3mdz9/P3fCYRr8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heUOuFNp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFB0C2BCB9;
	Fri,  1 May 2026 04:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608542;
	bh=duf4Qn4jJibidhGOYvdLIG55cwmiQxtfrqGHJsT9MI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heUOuFNpMZ4giusmbiwvQMEYgGCCrvYJVn4rCc1jJUCICMgx0V6J1/sryF6XAG6y/
	 /qr91Nzkk4eAVN01XUvqHFyCMe3e9yqvxnrq4O7MnCTCSMFiMelw3xs92l3VkpP1A9
	 3Ltf31K8+5TXrVgd/7syuA9zWQMpaGCBkdaTzccjx0RqL8I6+ws7CObMJTCBqvQcSU
	 xcZqB5jjp5rh/xB//KnCHeDOHYJTve10d0f8LXn20TiV5wF2WgZ+NbNvVNOs6hci30
	 O7uckESwNZPrP1mvhGWCNL2zG/ngGQcv+ucaHFChzJbRPqnKutzsNSSSuSRbPZ0+67
	 Wv+rW0D+plRNQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 26/53] klp-build: Validate patch file existence
Date: Thu, 30 Apr 2026 21:08:14 -0700
Message-ID: <bf425d6ce20445e059a3e63e43ccf49231fe560c.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: D3B6C4AA239
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2643-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:email]

Make sure all patch files actually exist.  Otherwise there can be
confusing errors later.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 68d61b72f39a..13709d20e295 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -157,6 +157,7 @@ process_args() {
 	local short
 	local long
 	local args
+	local patch
 
 	short="hfj:o:vdS:T"
 	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
@@ -235,6 +236,10 @@ process_args() {
 
 	KEEP_TMP="$keep_tmp"
 	PATCHES=("$@")
+
+	for patch in "${PATCHES[@]}"; do
+		[[ -f "$patch" ]] || die "$patch doesn't exist"
+	done
 }
 
 # temporarily disable xtrace for especially verbose code
-- 
2.53.0


