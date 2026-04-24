Return-Path: <live-patching+bounces-2532-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLb/OhDm62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2532-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:52:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5537B46395B
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5D6B300D31F
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036383469E7;
	Fri, 24 Apr 2026 21:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UP38PNk2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0F314D34
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067526; cv=none; b=EqbMaB4tX5rp5iJA7VNsT1A7XFRrrKRqe/j+YeuL571Vem29v5iHM9G4GyjzFbbm4CAlpTxeHMd00HzAJSN6Wud/6GUzVOx2ZMR0iAcGJfmTwWILYLB293ADLxgKpm7G/PhNBLWczIn7YKCcgnDEZk1dP1UEgislEP9X5Opt4VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067526; c=relaxed/simple;
	bh=+/t7ivuP2AdtcjOMZN6uu5lBKEGEEAahlYMGH/LYDcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=afIYTyDKsqxHynaIBsILO+9VyqNIrVs++PIAFRq75HF8qUkzlwhwoBl0AYYkmoUvaNzhln7ZNOFkMaDok1XchE8o6H1EzlrAXcKmwI42rCu2vS2xPbEmls+HW7qPuBqyhlDRe1VemwpzVJBVdnA2/NzdCvfSBCFNhFU9GIGsLZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UP38PNk2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787D7C2BCB0
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067526;
	bh=+/t7ivuP2AdtcjOMZN6uu5lBKEGEEAahlYMGH/LYDcM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UP38PNk2hm3ga4OERA9r0Mu9fNneR2/9uFD5cil1t1xL+jJmwbfnhdRw6sCMZsI23
	 wal0jZPuFwQKUlzAlsv7TAkGJdNtCEnHIn3tKgSx5zvumo3jUHDL1cjZSpTBD5IY5q
	 OCQ7WHz7bM9UsMPn2hY3Qv3SIu82aEvd6QUkCPDk+IUs+8fmZRzTj8SovNdcvPDDIW
	 dQDVUQJcEmsZd2gg+CzcHeLL+NvX0nV1C75hYL7QRR0uHuEyJ4si1sDxmw8qqZCUKu
	 9BX9q4NdmEr8K1ii5eYwv4q93lQt/A7MsHM4RMTVyUOJj6/xRkf3+9zkktprkdlg20
	 yas4EVHdZYLHw==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899a5db525cso65624666d6.3
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:52:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8/xf9v6AMNZSVwjwyfOP4mSrd6RNZm8YHqhasRwBEpJpCZytPdqlbvHttMTuVn94M7zssEoKQixWTosd+B@vger.kernel.org
X-Gm-Message-State: AOJu0YxX9kXt6o6rumF8T2Lhuh7h3PlGoZn7M8WNMAsLje93VwKYEpR/
	FyLJP8OiVNcVdQU8lxDGuAksmwfZdptUWY52NtDVwiqNxxcDj2zxDhK4/5a5KW8/h06kvKVQTqg
	CtzoEHyp99kMRC0ynXtTHjHPUJIPAWB4=
X-Received: by 2002:a05:6214:2c03:b0:8ac:b7f1:adf2 with SMTP id
 6a1803df08f44-8b02804585fmr531498816d6.12.1777067525658; Fri, 24 Apr 2026
 14:52:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <1b3add71a35ff83fc9653c2c872b811cfd5629a3.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <1b3add71a35ff83fc9653c2c872b811cfd5629a3.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:51:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7c44JzDX8Q6PgYAeigSFWTuEnuvgG88ABDdMNmPY6Oiw@mail.gmail.com>
X-Gm-Features: AQROBzAH6mGtdxIH0dg1PUmYFHMS-cEwyIZTRhdMtq-TqRG7kBakLSuJMYXeF5A
Message-ID: <CAPhsuW7c44JzDX8Q6PgYAeigSFWTuEnuvgG88ABDdMNmPY6Oiw@mail.gmail.com>
Subject: Re: [PATCH 18/48] klp-build: Fix hang on out-of-date .config
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5537B46395B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2532-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> If .config is out of date with the kernel source, 'make syncconfig'
> hangs while waiting for user input on new config options.  Detect the
> mismatch and return an error.
>
> Fixes: 6f93f7b06810 ("livepatch/klp-build: Fix inconsistent kernel versio=
n")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/livepatch/klp-build | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 0ad7e6631314..81b35fc10877 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -306,7 +306,12 @@ set_kernelversion() {
>
>         stash_file "$file"
>
> -       kernelrelease=3D"$(cd "$SRC" && make syncconfig &>/dev/null && ma=
ke -s kernelrelease)"
> +       if [[ -n "$(make -s listnewconfig 2>/dev/null)" ]]; then
> +               die ".config mismatch, check your .config or run 'make ol=
ddefconfig'"
> +       fi
> +       make syncconfig &>/dev/null || die "make syncconfig failed"
> +
> +       kernelrelease=3D"$(cd "$SRC" && make -s kernelrelease)"

Do we really need cd "$SRC" here? If so, we need it before
all the make commands, right?

Thanks,
Song

>         [[ -z "$kernelrelease" ]] && die "failed to get kernel version"
>
>         sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
> --
> 2.53.0
>
>

