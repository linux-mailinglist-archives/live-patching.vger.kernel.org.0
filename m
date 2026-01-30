Return-Path: <live-patching+bounces-1938-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJoKJl8NfWkxQAIAu9opvQ
	(envelope-from <live-patching+bounces-1938-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:58:23 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B9DBE48C
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BC688300442F
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C25C3074AE;
	Fri, 30 Jan 2026 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VM79Kr2i"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793AD224AE0
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803098; cv=none; b=uZtZGYm0U2hGnc0osaTotJnQcAwbPKFHuSEfyOtzHsNHAh00+1v/I5O2hggfriBUsnVMG6QcuaCp51f5PZxWseCaiqKXBx78DfsenYwg+zPeWHqTqXNpCViuGboP+rrvFbJ3c5BC6AMr6DrDb7YvVX4onddQJe0nyDLSHPTsFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803098; c=relaxed/simple;
	bh=E8SneLvxDpenyeAoZgmQnmOpQXrYbPr+BEpmqpJ2YRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5G3mIn3Y4CndVE65J+OdHmF/mwenLF3Ktz2mKNIYAhXj+OMybqL1mUOYFSb8rtopcwye/5cvUmce2PU28iRFJZqDyFRzcv6BRsi2EzvChghB+aaa6C49Cn0qqdDtsc0ejfAoVO4RLjcT01SiO1ncqZiyBm1qN0eoiOM6z+V9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VM79Kr2i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28505C2BC87
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769803098;
	bh=E8SneLvxDpenyeAoZgmQnmOpQXrYbPr+BEpmqpJ2YRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VM79Kr2iN+aTBjBaiHb/+lvt5B4rrftv/KLM8QsAL1nkl8ikZLjbIPjG9uWoYY+Ij
	 SZjzPmx9FA+hJXG7bq6Vq0fFvrOh1gsWlLFMDhRBm1zrun7pe52xTgEiE4r4WcmvzX
	 /t8wref6fIW+q/m9f5C0sqJyLwAq5qUWjFLQ7VG7Lebp2fh1B7zjeIVreBXkXnpePu
	 1rev36C5uvWj8a8/iQ1IaqJ18U+hq2oPnfb6CspoPkfwS/GFQl2QjGgS4h/I8zr2nO
	 p7iq1B48J9ZYuNTLiUBs3WKk3LJ+C2awfAPLqE690gPGdsXk8t52QdXcWFKfoJkOz6
	 TttZfPYjW2npg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c6d76b9145so263613085a.2
        for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 11:58:18 -0800 (PST)
X-Gm-Message-State: AOJu0Yw6flDjOMTsMHv/JM1lR3NESBezLmGAb2Lp8IiAkcuo6UnSlahc
	UkRSpUTtlWYqzCPinx8Vn4xAExj5wUCAiq3oJqhcZg8FhBJ4hidWTpIcX2VODvalKlBZ8nqmhzI
	WfJuBRFxWySHXvIDceTOOQZDXhakxxNc=
X-Received: by 2002:a05:620a:4801:b0:8b2:6bdf:3d11 with SMTP id
 af79cd13be357-8c9eb258c51mr587249485a.10.1769803097284; Fri, 30 Jan 2026
 11:58:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com> <20260130175950.1056961-5-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-5-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 30 Jan 2026 11:58:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
X-Gm-Features: AZwV_QjCrxzlVTCq8aFd5mc3qwFjga8ajcxtZic676bBnMoIvRvJyLUZTxYC7es
Message-ID: <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1938-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4B9DBE48C
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 10:00=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
[...]
> @@ -807,6 +906,8 @@ build_patch_module() {
>  process_args "$@"
>  do_init
>
> +maybe_rebase_patches
> +
>  if (( SHORT_CIRCUIT <=3D 1 )); then

I think we should call maybe_rebase_patches within this
if condition.

Thanks,
Song

>         status "Validating patch(es)"
>         validate_patches

