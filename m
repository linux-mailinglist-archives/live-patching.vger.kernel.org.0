Return-Path: <live-patching+bounces-2641-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFICEjMo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2641-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B581F4AA1B7
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CDCDD3075879
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF2933F58F;
	Fri,  1 May 2026 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lN+wb+17"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B5833E37C;
	Fri,  1 May 2026 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608541; cv=none; b=jkGLn6N+vPDe4yY90OW67S3i//zT0zEjZ0uA41vx+PUcDMNRJYhw/Rwrc1TfMNUEEtx4maL40ROOSD9rwqtSxUOc1GDWk3HOucaC+7+l6a6rjz7CVjhEnNfceBT+QBHu1Odt3sQUYBQjYe4cvh7/wQz/IA4YvvbbckGth/7u5hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608541; c=relaxed/simple;
	bh=0cgE2+HLfMAXuXxdci20y5BlxGcfiybyyBZ+oUe/nZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnx/tXnAp5l338MhQvbMlHWi6tJD6xcX2lxl9A4kf8t53sicVKbaR9gQ+mxWmWdk1HXSaw2NKk3IdFafDSW9Miw0WEG8LVXNa54tDYseRBEnFfNcmumxXvB6/jkVZfU8fkdjNzoLYT9QX7fPR2uhlsIPgFRpsXhfKalGl4+yIdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lN+wb+17; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12DC2BCB7;
	Fri,  1 May 2026 04:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608541;
	bh=0cgE2+HLfMAXuXxdci20y5BlxGcfiybyyBZ+oUe/nZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN+wb+17MN3nRa4zLaUb/Rj4rT39PqGXVVTCF15WkwYVTM/AD59HljCJQL+LrpA6E
	 +f9fPw4jvgFzKkUoL3Lf9RJSbev//L5rFxJ2jTFst6j01wewfxBS2zDe11BnFlFUHY
	 w6pa3Fl6oWBJdRaW1ICIdpJxgbdDHVevxq8TbLay9CcCfsvm3Q8LmAmMburnOTbEOa
	 Ydw2/T+mudR/dP/mb1COZW1gpvhPauSARYbZZtFLYqwcivGSohK3UvB/KFw3fE8WA1
	 ITIk+U/an1iTrBKMb91MBBYhBZ22Nkw0Aqw3jrY6kZd5A6SS94LZw7Dv4yhmY5B+JT
	 j37BpXTlGTKPQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 23/53] klp-build: Fix hang on out-of-date .config
Date: Thu, 30 Apr 2026 21:08:11 -0700
Message-ID: <5e2a75b8ce5120bbbec6c8e992f1d3c772b8e5d5.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: B581F4AA1B7
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
	TAGGED_FROM(0.00)[bounces-2641-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

If .config is out of date with the kernel source, 'make syncconfig'
hangs while waiting for user input on new config options.  Detect the
mismatch and return an error.

Fixes: 6f93f7b06810 ("livepatch/klp-build: Fix inconsistent kernel version")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 0ad7e6631314..e19d93b78fcb 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -306,7 +306,12 @@ set_kernelversion() {
 
 	stash_file "$file"
 
-	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make -s kernelrelease)"
+	if [[ -n "$(make -s listnewconfig 2>/dev/null)" ]]; then
+		die ".config mismatch, check your .config or run 'make olddefconfig'"
+	fi
+	make syncconfig &>/dev/null || die "make syncconfig failed"
+
+	kernelrelease="$(make -s kernelrelease)"
 	[[ -z "$kernelrelease" ]] && die "failed to get kernel version"
 
 	sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
-- 
2.53.0


