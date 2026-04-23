Return-Path: <live-patching+bounces-2450-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJECMm2b6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2450-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EE744CBA9
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 042783045A99
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5682C3D811C;
	Thu, 23 Apr 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSVM/VpF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327123D8113;
	Thu, 23 Apr 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917075; cv=none; b=GBmL2fxrGPJgbhlK2oL5GNq6e53SS4mGL3tQlt2xegwVIKrZL0mngBUZG6tsrG5DW7E2/E1dX9PylUJpHFGUABKY4p/atGA/544uWFN2my4uvlU9/+3hsSvWag9578HIugFTHgi4/IW1U9BLZDDYtBEGP5sVT6f0ow08V0hHNBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917075; c=relaxed/simple;
	bh=TGQr/sL6V2smG8IwtZoYQMzCjA/Kyq1WZ0Uu4gpZ2LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4Zd1s3BPljo0WLnBpkTTnLSNtTVkYJWwiLUnftFN3r7L7HYmZPxzPX+BimlNMc0r03/rgzNlAXRoteIyIPbH9m5qnNKaUpcPqJsKBAzaKoDmbxX8XjKIOTxkLRt4Bo7u9qRK9fLupfXZ5rdGNH1ISCol9OGWHnY+Cvf/Eh7Wbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSVM/VpF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4A9C2BCB5;
	Thu, 23 Apr 2026 04:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917075;
	bh=TGQr/sL6V2smG8IwtZoYQMzCjA/Kyq1WZ0Uu4gpZ2LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSVM/VpFOYQSTjRv60gqM4wcH0py2/LIg/PfgME1xuxWhZWQBZu/Ke45WLm+npRde
	 euVXo+zZVt6P6yFsFw5DXXimagsZXv22dy4hYcyIT3ysz5YWS6tqYBgzVbItfvkN8X
	 8l48zJUumLXVyhUjXjgpKXbyb52du4DfRZ0SbaRGRk42ETn4WaJwqKHF3CshWemtSg
	 jgouUq+v0AiiV54kWVMkxC+sCLzo/WsVevWEdVIDyNqzqE0Ko8rBA+4e1VZgGZ+xVO
	 tVyLu0PTL7/OJHT3nD3GD7u1u5OfbHeDNP0PDP4mqtV14LVFLYMjIcMbOLwC2IGGdd
	 wlRitBr2NfzTQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 23/48] klp-build: Fix patch cleanup on interrupt
Date: Wed, 22 Apr 2026 21:03:51 -0700
Message-ID: <cc513774c7d5063812c66bac421e56e24fccbc42.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2450-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B5EE744CBA9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index a7f571df7813..60231cf49e5c 100755
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


