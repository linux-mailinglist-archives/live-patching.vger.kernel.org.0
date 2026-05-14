Return-Path: <live-patching+bounces-2815-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKpTCfI0BmoIgQIAu9opvQ
	(envelope-from <live-patching+bounces-2815-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:47:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B388F546CE4
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DE2853011E9F
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 20:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA71346E46;
	Thu, 14 May 2026 20:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9/IhVZV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D43F413B
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778791661; cv=none; b=HWTQNg8qWb5gXAmv7Zp4ex2bdZBIZjWURAnKiRThmqs9gcOK8FrPFCPS79dCGA629MALbaG+gHlLzu6RFanNY/Sg2zm1SMZwQ+sCvCLBregOjlULi93fmFUbtBoYkhRghrExSD1bS6Wa7AO5xRu76PYTGaFdDTlmpSj5TnKWvw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778791661; c=relaxed/simple;
	bh=SpTNK/jpbbcjCflRgtJLYpnFQ0FkaMDzt734LcM8Rlw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fnsr+llEDgu5ozBnIb6eQpEPdczgv4nuhEohw5jJlyQiXc91mdBNOIcymUlmelE1N/BtFxh47u3leTVTZHCSY/Rl/NDhyQfA4tvKiZ+sJPvHJLnlJ1gc9FffVYlyeDjASuMJKwNZWsPuB2TwKmWQW/gRgwU5wXfGppM8VY2vfko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9/IhVZV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECCAC2BCB3;
	Thu, 14 May 2026 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778791661;
	bh=SpTNK/jpbbcjCflRgtJLYpnFQ0FkaMDzt734LcM8Rlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=M9/IhVZVjK6g1xk0KLdCbVMiYfJGmxdYD3IYERGe43SQFccqyo1caZxqYGqb7kf+J
	 9ulOR5oF02PzfH0xuLZucjaFQFkGQ1yLatHTklsPwi8qY5js+mP7EJZgs0FS7FFG7E
	 NhWcF7QQsA0UA7BYoB47K9M5HrQqBQlNWpSbPdzgf2pw4gzkLF8nHULnxTBZ5T43la
	 jSEeAHOa0V9ze9mLB3G0xso4058z+4ZIV8S835xzwIQf96Ct0pRO3nujrZBUJwsqBP
	 dZtxXhEoApu+9dLHn1P4rTd7fj99Qmklu/EUbHVK6zvPfewxglYiGgIuzc3o4tKCTT
	 t0jHOWRzQJaIg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 1/4] objtool/klp: add --symvers option to klp diff
Reply-To: sashiko-reviews@lists.linux.dev
To: live-patching@vger.kernel.org
Cc: "Song Liu" <song@kernel.org>, "Petr Mladek" <pmladek@suse.com>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Miroslav Benes" <mbenes@suse.cz>
In-Reply-To: <20260512221102.2720763-2-joe.lawrence@redhat.com>
References: <20260512221102.2720763-2-joe.lawrence@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 20:47:40 +0000
Message-Id: <20260514204741.1ECCAC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: B388F546CE4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:replyto];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2815-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] NULL pointer dereference and crash when the implicitly generated=
 `--no-symvers` option is passed.
- [Medium] The fallback file resolution logic incorrectly concatenates abso=
lute paths to the kernel root directory, resulting in malformed paths and u=
nintended file resolution.
- [Low] Misleading error diagnostics for custom path failures.
--

commit ad4674adedd0ef34b67a931273e6e044219ae8b0
Author: Joe Lawrence <joe.lawrence@redhat.com>

objtool/klp: add --symvers option to klp diff

This commit adds a --symvers (-s) option to klp diff that allows specifying
a custom path to Module.symvers. The change aims to support out-of-tree
module patching by decoupling the tool from the default Module.symvers
location while preserving the existing fallback detection logic.

> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
[ ... ]
> @@ -46,6 +47,7 @@ static const struct option klp_diff_options[] =3D {
>  	OPT_BOOLEAN('d', "debug", &debug, "enable all debug output"),
>  	OPT_BOOLEAN(0, "debug-correlate", &debug_correlate, "enable correlation=
 debug output"),
>  	OPT_BOOLEAN(0, "debug-clone", &debug_clone, "enable cloning debug outpu=
t"),
> +	OPT_STRING('s', "symvers", &symvers_path, "path", "path to Module.symve=
rs (default: Module.symvers)"),

Could this cause a NULL pointer dereference if a user passes --no-symvers?

Since OPT_STRING doesn't include the PARSE_OPT_NONEG flag, the option
parsing machinery will automatically accept --no-symvers and set
symvers_path to NULL. Later in read_exports(), this would result in calling
fopen(NULL, "r").

>  	OPT_END(),
>  };
[ ... ]
> @@ -85,16 +87,15 @@ static char *escape_str(const char *orig)
> =20
>  static int read_exports(void)
>  {
> -	const char *symvers =3D "Module.symvers";
>  	char line[1024], *path =3D NULL;
>  	unsigned int line_num =3D 1;
>  	FILE *file;
> =20
> -	file =3D fopen(symvers, "r");
> +	file =3D fopen(symvers_path, "r");
>  	if (!file) {
> -		path =3D top_level_dir(symvers);
> +		path =3D top_level_dir(symvers_path);

What happens here if the user supplies an absolute path like
/build/out-of-tree/Module.symvers that fails the initial fopen()?

It looks like top_level_dir() will unconditionally append the absolute path
to the kernel root directory, resulting in a malformed path like
/path/to/linux//build/out-of-tree/Module.symvers. Is it intentional to
apply the top-level directory fallback to absolute paths?

>  		if (!path) {
> -			ERROR("can't open '%s', \"objtool diff\" should be run from the kerne=
l tree", symvers);
> +			ERROR("can't open '%s', \"objtool diff\" should be run from the kerne=
l tree", symvers_path);

Since the goal of this patch is to enable out-of-tree module patching, does
this error message still make sense when a custom path is provided?

It might be confusing to tell users they must run from the kernel tree when
they explicitly passed an out-of-tree --symvers path.

Additionally, if the fallback fopen() fails later on, the code calls
ERROR_GLIBC("fopen") which prints "fopen: No such file or directory" without
indicating which path failed. Would it be helpful to include the actual file
path in these error diagnostics?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260512221102.2720=
763-1-joe.lawrence@redhat.com?part=3D1

