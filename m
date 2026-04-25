Return-Path: <live-patching+bounces-2551-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHELCqYF7GlbTwAAu9opvQ
	(envelope-from <live-patching+bounces-2551-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:07:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CE1464315
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0041300E70F
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D6C1C01;
	Sat, 25 Apr 2026 00:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPDOx4DK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DB71397
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777075617; cv=none; b=dbb+06r7Ya6OTUNXNRrEL59j2OuFoVL4yH5EJ8EeaimZq8De2q5ONwXT7w/cq9EI7X3Wah5vClsXcOKleVe/Ff7Dt9olXCr+U7idT9V94Kgl6JUG7HPJXks/UYDeQpvy7YFpfmgte/JEApN162I45aTZuncjtTW0bLObdqE6iM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777075617; c=relaxed/simple;
	bh=YuUmyv53QdWU8vgkQQPsXl4nGiMMd9siQ1BOqkQDnnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A5Sqrp1ywM01nv+q5SPxp0FQAnzRASglaTUfrf1cQQ6LPc0ZrJyXxeEJE+YLCn6ptp0tjpGCEX7iDQGM/E3Fgvtr1k/dYA2mK8fz9hjGKdpI99/PnTdNaqJG0pZvb8rb2DMBlcEbEcJbTvZzsX1v+NvBBGmv/1NI27VZIqwgjM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vPDOx4DK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5AAC2BCB6
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777075617;
	bh=YuUmyv53QdWU8vgkQQPsXl4nGiMMd9siQ1BOqkQDnnU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vPDOx4DKvpfSRmQG6N/6EcU7nreFasZucnP+QRWto3PZLl1vcNpHiHBxyAWNRAeMP
	 0/HiQy2ENTgH7mQG1NbVU4CcUlCIpm1RULDPe2RDDVr+f67ZB+wOhQ5/IdDNdfn+zR
	 zVYfPEdBnL94xFiq1l7MCDIzakWDUtPWCcG/GDJCvzdTimCslxkKDv6Jp02wl6SUO/
	 mFMz+YiW5EPEptWWXc69/wnFOTQyeBmgLrjERhnoPUbbO2agYDSKwROibnV/PYOoaT
	 O8gzaNB0+eECHlmp4Gug3J6kMkVMdpKcRvU8i6QEnIKv7G5KaSsXeJ7hQIc3KWGKjq
	 kAXgpXBkwDURA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ef2118b478so457464285a.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 17:06:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/9WgZ/b2dy/TrSi85dEiszUUpqZEklTnQZ3T9xOU3+1dH+17Mj8uYfBQPTN3ieGYS4OWVp7qkmZGbEb0/k@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2zJxqoZqlb8WKc3Xoaj/anhENof7BmeSfYkqUE/A6z8bBkwvQ
	F231ok2P2gSX7lClzeRCA/lyoMi/xchibvdSEsCqPR2Sls7Jswlw4Lj5XD+RHZX56qgfVAmpP75
	71znzn8uINrWaDwvhjbM93fIM538u0Os=
X-Received: by 2002:a05:620a:4089:b0:8d5:bb98:f3f3 with SMTP id
 af79cd13be357-8e78f82cf44mr5021270685a.15.1777075616575; Fri, 24 Apr 2026
 17:06:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <338295e0bf3353dd62536df672a2615f72be013b.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <338295e0bf3353dd62536df672a2615f72be013b.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 17:06:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW66Mx6RU9NT4nyk7GuN-0Kve6P7YdnM-ke3D2Cx0o0_Kw@mail.gmail.com>
X-Gm-Features: AQROBzDP3OZ39R0XkUMuKNdLwMQzxl53RUmGM5B7EINvGgdtZNLnWshYMdC1WnM
Message-ID: <CAPhsuW66Mx6RU9NT4nyk7GuN-0Kve6P7YdnM-ke3D2Cx0o0_Kw@mail.gmail.com>
Subject: Re: [PATCH 38/48] klp-build: Validate short-circuit prerequisites
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69CE1464315
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2551-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> The --short-circuit option implicitly requires that certain directories
> are already in klp-tmp.  Enforce that to prevent confusing errors.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/livepatch/klp-build | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index eda690b297cc..b44924d097a5 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -440,6 +440,20 @@ do_init() {
>         [[ ! "$SRC" -ef "$SCRIPT_DIR/../.." ]] && die "please run from th=
e kernel root directory"
>         [[ ! "$OBJ" -ef "$SCRIPT_DIR/../.." ]] && die "please run from th=
e kernel root directory"
>
> +       if (( SHORT_CIRCUIT >=3D 2 )); then
> +               [[ -f "$ORIG_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT =
requires completed $ORIG_DIR"
> +               if (( SHORT_CIRCUIT >=3D 3 )); then
> +                       [[ -f "$PATCHED_DIR/.complete" ]] || die "-S $SHO=
RT_CIRCUIT requires completed $PATCHED_DIR"
> +                       if (( SHORT_CIRCUIT >=3D 4 )); then
> +                               [[ -f "$ORIG_CSUM_DIR/.complete" ]] || di=
e "-S $SHORT_CIRCUIT requires completed $ORIG_CSUM_DIR"
> +                               [[ -f "$PATCHED_CSUM_DIR/.complete" ]] ||=
 die "-S $SHORT_CIRCUIT requires completed $PATCHED_CSUM_DIR"
> +                               if (( SHORT_CIRCUIT >=3D 5 )); then
> +                                       [[ -f "$DIFF_DIR/.complete" ]] ||=
 die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
> +                               fi
> +                       fi
> +               fi
> +       fi
> +

Do we really need these to nest together?

Thanks,
Song

>         (( SHORT_CIRCUIT <=3D 1 )) && rm -rf "$TMP_DIR"
>         mkdir -p "$TMP_DIR"
>
> @@ -601,6 +615,7 @@ copy_orig_objects() {
>
>         mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
>         touch "$TIMESTAMP"
> +       touch "$ORIG_DIR/.complete"
>  }
[...]

