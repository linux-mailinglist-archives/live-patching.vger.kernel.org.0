Return-Path: <live-patching+bounces-2135-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMpJJUQJqmmVJwEAu9opvQ
	(envelope-from <live-patching+bounces-2135-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 23:52:52 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B90821919F
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 23:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8F023008899
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 22:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506423644DF;
	Thu,  5 Mar 2026 22:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAIHlcpy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0B43644AD
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 22:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772751168; cv=none; b=Z1uf+IS/Z2Olf4SaLoiQlK6dEgdszWTl3DI535GPFj2VWBU7U++NKFmgGpSceVhTIICiAP9luv8R/ufBKiuvO8guhBIn9YhsRwP5OZIeE3fWw6gzJrCu7RMv8z4ggrM5obhHlFa5AWNV5m+0RKFgpfb0pJchhFZFJaDqaDipAnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772751168; c=relaxed/simple;
	bh=FVe//pnJ0EgWryp4YYuf6Ui0we8/6pznhDfjkgJK0Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txefeeyFBn2PFjyvs2t3gKtyd3Ryh6i9NneR87B/9RvmDejEJL9fTpJrUny5Cxl5nk7ZonTmT46udwbBOKvPByQBkquGE6xQeevcV3iDjL1z82iW5x9rznXuUmRxomOyH5gnhdvh4TDu1UIhiCSgolF9wD6Nd40COVAPGljeaxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAIHlcpy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2248C116C6;
	Thu,  5 Mar 2026 22:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772751167;
	bh=FVe//pnJ0EgWryp4YYuf6Ui0we8/6pznhDfjkgJK0Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JAIHlcpyjAkFPLybeev3GKB9y1s41j6TohrWyvrpBWf/x8T2AdMzJDopNz8XDgz8S
	 cW3+x9P04tU0WYjdU+uGAfCgQ7PgihVByUjxNtW5I985XcOHnm+ZNq53UaMr5cL60N
	 TYH3CYfXrId+tgH2mwrkm5XPm8BKZI1qbyrlrzL9ODWJkfuxYXRHQ9wBoPStrFdbTN
	 3+C+2hZfzHjEJay0WaaQ18lGhzElprmTvMeczLFt33iINuQKWtYbM91ecXld85iZhF
	 xS6ruruwHIJv+qLn8GXYJM6kAxyjMa46ehfZx5B1jGEqSwKSly8eRVc62FBYZTNCoZ
	 QGn6E1I7uKc0w==
Date: Thu, 5 Mar 2026 14:52:46 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: [PATCH] klp-build: Fix inconsistent kernel version
Message-ID: <noyyhysipjm6aw4td6q4mg6n4c637unfgmkn35otopu3rbqugj@ekzuix6lsb6p>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
 <aaZFUL_yCS3_wHnd@redhat.com>
 <w6uwlcdd7eb247lj4r5khrliiymbpapshmaror3x3olfaamj6a@4ukxobzqj7fo>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <w6uwlcdd7eb247lj4r5khrliiymbpapshmaror3x3olfaamj6a@4ukxobzqj7fo>
X-Rspamd-Queue-Id: 0B90821919F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2135-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

If .config hasn't been synced with auto.conf, any recent changes to
CONFIG_LOCALVERSION* may not get reflected in the kernel version name.

Use "make syncconfig" to force them to sync, and "make kernelrelease" to
get the version instead of having to construct it manually.

Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for generating livepatch modules")
Closes: https://lore.kernel.org/20260217160645.3434685-10-joe.lawrence@redhat.com
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 809e198a561d..72f05c40b9f8 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -285,15 +285,14 @@ set_module_name() {
 # application from appending it with '+' due to a dirty git working tree.
 set_kernelversion() {
 	local file="$SRC/scripts/setlocalversion"
-	local localversion
+	local kernelrelease
 
 	stash_file "$file"
 
-	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
-	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
-	[[ -z "$localversion" ]] && die "setlocalversion failed"
+	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make kernelrelease)"
+	[[ -z "$kernelrelease" ]] && die "failed to get kernel version"
 
-	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
+	sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
 }
 
 get_patch_files() {
-- 
2.53.0


