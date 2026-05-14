Return-Path: <live-patching+bounces-2818-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KzPJFU6Bmo3ggIAu9opvQ
	(envelope-from <live-patching+bounces-2818-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:10:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DF7546F14
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2129301378B
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 21:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4654B38B7B0;
	Thu, 14 May 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3HVZ7O7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232803F413B
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778793043; cv=none; b=PgYdhuzSutXfmHFvrg4riF2pN0gEKXpND4DCiDAjYM3cLTkZgfTJotrFKAMQqniDq/hNmdAJrC6v4QNU9jYQecFuVZTzrwOAxUrAPk9bpx5ojxEyuD6tdXtOn1HsgBzdMjC+64roGvK6LZWIgN67VogOC6sf5Y968+WpJgfQhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778793043; c=relaxed/simple;
	bh=Dy82oTzSFlOiHWW7bC3IpK62IBpi/Ly9xelLwyC5gqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XaBS181WT+6sr1oYnveNPCjSHNx5mANbIWaD7dr4z/Rmf5EwnXGmbnpUN9n3Nt+vS2ppnlIkeF3r0MJv61wssLToN/EfAj3mxz20p2T/Dk6RCz+Sm/uxCr31IG418Bgsv5Cb7zaTFUEOnhDZZcDA6t8FjPQAHgrg+X6Dv9J3Tag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3HVZ7O7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96E8C2BCB3;
	Thu, 14 May 2026 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778793043;
	bh=Dy82oTzSFlOiHWW7bC3IpK62IBpi/Ly9xelLwyC5gqQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=Z3HVZ7O7trJpkppq3faNIt4ZZdTY9srL4FxGk2tmMKw0l9SWc6eq68ZmblNmoB5UF
	 6jupXTyteyf4e3Xywa75+mZv0/AalioNMeYruHi5EXnay83jjYchpz0VUHYdKvIdUF
	 X7dzqGBrureMD+H6HLVZE/OXXB0O6QNhgRgM5OAESRg6Kw1UMLqSCYJvJfnuCfxmZr
	 ttH0Jx80eoeqj9shcpNIC1dfoQhDnbY1i8itSgLXQQG3pPulGegbqg8vsZA++9uAuS
	 hOyUIJROMipZe4MXWha5NG4vdnTizvWPtpyc4G66uldQ/0Cl4EiWsuYGPLSCrJB1D8
	 hMMLCunx0ZkJg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 3/4] objtool/klp: add --arch option to display target
 architecture
Reply-To: sashiko-reviews@lists.linux.dev
To: live-patching@vger.kernel.org
Cc: "Song Liu" <song@kernel.org>, "Petr Mladek" <pmladek@suse.com>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Miroslav Benes" <mbenes@suse.cz>
In-Reply-To: <20260512221102.2720763-4-joe.lawrence@redhat.com>
References: <20260512221102.2720763-4-joe.lawrence@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 21:10:42 +0000
Message-Id: <20260514211042.C96E8C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: F0DF7546F14
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sashiko.dev:url,smtp.kernel.org:mid];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2818-lists,live-patching=lfdr.de];
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

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `--arch` option is inaccessible on non-x86 architectures bec=
ause the `klp` subcommand is conditionally compiled only for x86.
--

commit bd45d7b713ebb8e72f88be16df165f29efd9fc96
Author: Joe Lawrence <joe.lawrence@redhat.com>

objtool/klp: add --arch option to display target architecture

This commit adds an --arch option to the klp diff subcommand to print the
target architecture objtool was compiled for. This allows scripts to verify
compatibility before processing object files.

> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
[ ... ]
> @@ -44,6 +44,7 @@ static const char * const klp_diff_usage[] =3D {
> =20
>  static const struct option klp_diff_options[] =3D {
>  	OPT_GROUP("Options:"),
> +	OPT_BOOLEAN('a', "arch", &show_arch, "display target architecture"),
>  	OPT_BOOLEAN('d', "debug", &debug, "enable all debug output"),

Since the klp subcommand is conditionally compiled and only enabled for x86
architectures, will this option be accessible on other architectures?

According to the objtool Makefile, ARCH_HAS_KLP is strictly set to y
only when SRCARCH is x86. For all other architectures, BUILD_KLP is
disabled. This means that on non-x86 architectures, invoking
objtool klp diff --arch will fall back to the weak stub, returning an
"objtool: klp not implemented" error instead of printing the
architecture.

Since the architecture is a global property of the binary, would it make
more sense to expose this via a global flag like objtool --arch instead of
restricting it to the klp subcommand?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260512221102.2720=
763-1-joe.lawrence@redhat.com?part=3D3

