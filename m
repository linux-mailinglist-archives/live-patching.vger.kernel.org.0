Return-Path: <live-patching+bounces-2883-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id foS2M7aWE2p4DwcAu9opvQ
	(envelope-from <live-patching+bounces-2883-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:24:22 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB725C503C
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:24:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9AEE83002B24
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 00:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362AE1A6805;
	Mon, 25 May 2026 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGEYeens"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31D17993;
	Mon, 25 May 2026 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779668658; cv=none; b=Aq4T37Tx8Jbg1q+Mz8PizztulNIHe30/Sjxau6q0kneU5SixaKSZelbl4bA8FT6XWOT0un7mRc3t3AP/EPy5ClGUOJY1P0I8miudRPffUmtd8FdwNNC+MJs7E281E8S7fsW6la3IYKYhuAWmQrqCtn/nRFiBS2lAxYyR3KcAJ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779668658; c=relaxed/simple;
	bh=iAvdNb6M8a+Pw9hBeWWn5yPDZnzYiyHLKHmE8lwGMZs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NMYMop9gPzOUncKe8KRrh9dcZxkbFWG/lQgxj7IXJnwY1JXm2FWPDFvOyyPaAhATFbM2LQM/zHnIy6jSqjO+d5QMtpMIG4cKl/fgqnlU6azYO0a2SvAN3h9LcxH8ZI+Ls30CLUoobpFlFFo3yfmKfTUOOzlYIXxJDMc/oNzbTb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGEYeens; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3A41F000E9;
	Mon, 25 May 2026 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779668656;
	bh=xnl7Gw1dyLrNeHWmc4DlkVh3G7Adi0Kb17RdZbXKT5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XGEYeensuRckssSNIIUKwyIZXde4GZ1q/nA1OxDSR7o+Znb5DmLFOgcPO+PUyVXQr
	 tR4/ZiR43ZYaZECyg+aQzhxOO2ZiMuPoFRGUkn7J/AdWOAbRyhrlNiqN4dZHezl5CZ
	 ZjCwGZzlOGUIqBKIev1HPR2U0jWFRxHNX4hZGh5MB17RpEGwpUNdwbEBst9RoY6f/x
	 9+tYmwENIs1IChNq1OChH82rAJRFbNeK4HpLrkhNoWKpxaZem8V4PMW32w8tVA3rrd
	 MXcHBYBkRL3ZrIutxJuhbkho1pWunskPyyPs27HHbe1L12HQpqizSzxgofUBkEHHfV
	 MfJ9GQJQ7+6TQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] selftests: livepatch: Adapt mod_target module to
 pass on 4.12 kernels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miroslav Benes" <mbenes@suse.cz>, "Shuah Khan" <shuah@kernel.org>, "Petr
 Mladek" <pmladek@suse.com>, "Josh Poimboeuf" <jpoimboe@kernel.org>, "Joe
 Lawrence" <joe.lawrence@redhat.com>, "Jiri Kosina" <jikos@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, "Marcos
 Paulo de Souza" <mpdesouza@suse.com>, marcos@mpdesouza.com, linux-kernel@vger.kernel.org
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-3-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-3-7465de7f741d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 25 May 2026 00:24:15 +0000
Message-Id: <20260525002416.3B3A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2883-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,lists.linux.dev:replyto,sashiko.dev:url,smtp.kernel.org:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 6BB725C503C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `test_klp_mod_target_ops` structure omits the logically requ=
ired `.set` callback, exposing the kernel to a NULL pointer dereference dur=
ing module load.
--

commit 532c1b8c7438f534fd4e3440716ede6cf83efe1c
Author: Marcos Paulo de Souza <mpdesouza@suse.com>

selftests: livepatch: Adapt mod_target module to pass on 4.12 kernels

Use the stable module_param_cb API instead of proc_fs for exposing module
state. This approach is compatible with kernel 4.12 and later.

> diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_=
target.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_targ=
et.c
> index 9643984d24022..1382a266825fb 100644
> --- a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> @@ -5,31 +5,29 @@
[ ... ]
> +static const struct kernel_param_ops test_klp_mod_target_ops =3D {
> +	.get =3D test_klp_mod_target_get,
> +};
> +
> +module_param_cb(klp_mod_arg, &test_klp_mod_target_ops, NULL, 0444);

[Severity: Medium]
Does this code need a .set callback in the kernel_param_ops structure?

When a module parameter is passed during module load, the kernel parses the
arguments using parse_args(), which invokes parse_one() in kernel/params.c.
Because parse_one() unconditionally executes the .set callback without
verifying if it is actually defined, omitting it here leaves the callback
implicitly initialized to NULL.

Could this lead to a NULL pointer dereference and a kernel panic if someone
attempts to set this parameter during module load?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260524-livepatch-=
unload-on-fail-v1-0-7465de7f741d@suse.com?part=3D3

