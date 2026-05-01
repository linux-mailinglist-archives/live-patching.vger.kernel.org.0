Return-Path: <live-patching+bounces-2649-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAYyB+co9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2649-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 266944AA2C1
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0FE91303A6AF
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2B83112B2;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtIXwMXo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18FB3101C8;
	Fri,  1 May 2026 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608545; cv=none; b=CAhuccataCevUaea+G7QBlfT2G6gZN9mEqTBAfwg6+Rd+k2WfNQQUVLspwAQQKwmC0gh+1rth0tx7L3SKsO+gIhELx81VVOUBez4WPvJpN+wgcV9LabqFGl8KPuBZxYyORc4gXiMiTeYBhYeQ6XxCGYQBx3TWmxCydJp8TpAppM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608545; c=relaxed/simple;
	bh=f0Ve5bg2CjhT77knL5sFvHMeomh5ZlbAk6fCFX9rZXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dU9nGIZXy2FdbiddUoWi6wRW6pGbKmbK60dixbqUmwCNm8Zlul1fE6ilPDOW5gba4M41327Uvv2Y98aXJLybOigfZ6IG3//8wqJcMNm5cet6C+9Z3e6qzSTcHAsr+iTvaeykYNL5DfjAINJZarM71upqmc0pync5KKYofrAao6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtIXwMXo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17715C2BCB7;
	Fri,  1 May 2026 04:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608543;
	bh=f0Ve5bg2CjhT77knL5sFvHMeomh5ZlbAk6fCFX9rZXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtIXwMXo5VjFnqr/ifRe6z+qLTkDV1Q0T2rxRjYpzomAwk3HJpBVT242wth9KpPcw
	 JGoCWfxiPPbz5YJAF5Fc3d6VOZGPggRBwgrp14BKfuoEMGgPHBeskBm0QXgTEsQy4E
	 zCObEQNgsAhCKUY9vf/BJRF7ikfbtHYfVjiEqy46pHTqpEPdbbKKeOv2VL/JSuUu2q
	 JY/zk57eh5ppgy2UMdYHtSIUYjGoBqf0pL/O1h2iJxMydTPiOGxfuknlwT+jq4XEjc
	 Q5M4UsPA4TKSqPCeB/+0CARF3k0VJqWwAzUiD2NtbjVOSECS3Rv6wk4sgdE71ZJTRE
	 5+3XNA1x2sMIg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 28/53] klp-build: Fix patch cleanup on interrupt
Date: Thu, 30 Apr 2026 21:08:16 -0700
Message-ID: <cfc3c1d5096764d0cd79ef85e833b8ce098f0838.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 266944AA2C1
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
	TAGGED_FROM(0.00)[bounces-2649-lists,live-patching=lfdr.de];
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

If a build error occurs and the user hits Ctrl-C while a large patch is
being reverted during cleanup, the cleanup EXIT trap gets re-triggered
and tries to re-revert the already partially-reverted patch.  That
causes 'patch -R' to repeatedly prompt

  "Unreversed patch detected!  Ignore -R? [n]"

for each already-reverted hunk, with no way to break out.

Fix it by adding '--force' to the patch revert command in
revert_patch(), which causes it to silently ignore already-reverted
hunks.  And ignore errors, as the cleanup is always best-effort.

For similar reasons, add to APPLIED_PATCHES before (rather than after)
applying the patch in apply_patch() so an interrupted apply will also
get cleaned up.

Fixes: d36a7343f4ba ("livepatch/klp-build: switch to GNU patch and recountdiff")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index dc2c5c33d1db..9970e1f274ef 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -384,15 +384,15 @@ apply_patch() {
 		warn "${patch} applied with fuzz"
 	fi
 
-	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 	APPLIED_PATCHES+=("$patch")
+	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 }
 
 revert_patch() {
 	local patch="$1"
 	local tmp=()
 
-	patch -d "$SRC" -p1 -R --silent --no-backup-if-mismatch -r /dev/null < "$patch"
+	patch -d "$SRC" -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
 
 	for p in "${APPLIED_PATCHES[@]}"; do
 		[[ "$p" == "$patch" ]] && continue
-- 
2.53.0


