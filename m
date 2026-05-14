Return-Path: <live-patching+bounces-2819-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FyiC189BmqmggIAu9opvQ
	(envelope-from <live-patching+bounces-2819-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:23:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FC0547038
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71D5C30382A5
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 21:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48913B2FCE;
	Thu, 14 May 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnZRMLGb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7833ACA49
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778793648; cv=none; b=DAYTXSwPR0bL16Mf/3+fDmuD4WOxeqJX76QPNxD43/EYIIabs4oIIugMGXBd4twQQjW+8tygreywaqgcxvMqYr/twfB565/VIsUXC0nSub3fN0pWDgY4zFRJO9fu/RtVscRX67JocVrrqMKIbQN2E673GGv2K7agFUV7NUcaITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778793648; c=relaxed/simple;
	bh=84ssf85RHyd57W/mX4XadrQEfKmAMsHwjpfUq65pAX4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W8oVHMoWYn1YDRfhiPCZBLWVBxTsOeOhiG9o643pTeL7QsAkDn+1tnkqFtQqpO/3GpqonwnK/05fc2/FfgsIGXNdHf9HOzw1Oz5Hg3836xpRMm6odQ/tC+zZYDUGXy9XQpV2z2DDrVKcMSHzpdxKlrcjrnOeiPET9T/h0M7ivns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnZRMLGb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5431CC2BCB3;
	Thu, 14 May 2026 21:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778793648;
	bh=84ssf85RHyd57W/mX4XadrQEfKmAMsHwjpfUq65pAX4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=QnZRMLGbW+PJ47jjRL6R3eO4/zph6ycJjmHrhEomMQr2E2KZTsO184/T75hwy8S3w
	 UebTTZZk+l3NyYcB0cO8/D/TlYHX8Biwz/NyipqKfVUW83x8HqElM+GjZCjsJEfCxh
	 eCuZ1MWnAiz0urDmpgSgB1Kz62f7rgxsnvn4A6txSb/Jx/iDNn8/fsebF9Vp+fw4Lc
	 Zib6yhTwct/LGRWPNmY5DxvTYGSH1QgzDYaiARQHT+a2sCBYCTYEAspNNz9lkGs92h
	 r8x+wVVexzI54fW5XQEOAvQ8wQHWH4xsWCvGMwBSeQDxHjyHAQBhTBXy9n8KugS4Ye
	 AP9XJMNrxdpMg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 4/4] livepatch/klp-build: add basic out-of-tree module
 patching support
Reply-To: sashiko-reviews@lists.linux.dev
To: live-patching@vger.kernel.org
Cc: "Petr Mladek" <pmladek@suse.com>, "Miroslav Benes" <mbenes@suse.cz>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Song Liu" <song@kernel.org>
In-Reply-To: <20260512221102.2720763-5-joe.lawrence@redhat.com>
References: <20260512221102.2720763-5-joe.lawrence@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 21:20:47 +0000
Message-Id: <20260514212048.5431CC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 82FC0547038
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sashiko.dev:url,lists.linux.dev:replyto];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2819-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The script hardcodes the temporary directory (klp-tmp) and defau=
lt output file to the kernel root directory ($PWD), which breaks building o=
ut-of-tree modules against read-only system headers.
- [Medium] The commit message incorrectly states that 'make modules_prepare=
' is sufficient to prepare the kernel tree for out-of-tree patching.
--

commit c21e20dbe33c0ce1976f54b57ae6fc8cea53b65b
Author: Joe Lawrence <joe.lawrence@redhat.com>

livepatch/klp-build: add basic out-of-tree module patching support

This commit introduces a module-dir option to klp-build to support
generating livepatches for out-of-tree kernel modules. It performs two
builds of the out-of-tree module to generate the original and patched
objects.

>     klp-build is currently limited to patching in-tree kernel modules.
>     Introduce a -M/--module-dir option to enable livepatch generation for
>     basic out-of-tree (OOT) modules.  This requires the associated kernel
>     tree to be pre-configured (e.g., 'make modules_prepare').

The commit message states that running 'make modules_prepare' is
sufficient to prepare the tree. Is this description accurate?

Looking at do_init(), the script explicitly checks for Module.symvers:

[[ -f "$PWD/Module.symvers" ]] ||
    die "kernel must be built first (no Module.symvers in $PWD)"

Running 'make modules_prepare' on a clean kernel source tree prepares
configuration and headers but does not generate Module.symvers.

Could the commit message be updated to clarify that a full build is
required?

> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index c4a7acf8edc3f..aef3b47db4f24 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build

[ ... ]

> @@ -433,8 +451,6 @@ validate_patches() {
>  }
> =20
>  do_init() {
> -	# We're not yet smart enough to handle anything other than in-tree
> -	# builds in pwd.
>  	[[ ! "$PWD" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kern=
el root directory"

[ ... ]

> +	if [[ -n "$MODULE_DIR" ]]; then
> +		[[ -d "$MODULE_DIR" ]] || die "module directory not found: $MODULE_DIR"
> +		MODULE_DIR=3D"$(realpath "$MODULE_DIR")"
> +		[[ -f "$MODULE_DIR/Kbuild" || -f "$MODULE_DIR/Makefile" ]] ||
> +			die "no Kbuild or Makefile in $MODULE_DIR"
> +		[[ -f "$PWD/Module.symvers" ]] ||
> +			die "kernel must be built first (no Module.symvers in $PWD)"
> +	fi
> +
>  	(( SHORT_CIRCUIT <=3D 1 )) && rm -rf "$TMP_DIR"
>  	mkdir -p "$TMP_DIR"

Does creating the temporary directory in the kernel root directory cause
permission regressions when building out-of-tree modules?

Out-of-tree modules are often built against system-installed kernel headers,
which are typically read-only for standard users. Since the script mandates
running from the kernel root directory, creating the temporary working
directory and default output file inside the present working directory will
cause permission denied errors.

Could the script use the module directory or a user-specified path for
temporary files and the default output instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260512221102.2720=
763-1-joe.lawrence@redhat.com?part=3D4

