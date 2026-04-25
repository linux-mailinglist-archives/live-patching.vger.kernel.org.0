Return-Path: <live-patching+bounces-2553-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AC2iA6sQ7GktUAAAu9opvQ
	(envelope-from <live-patching+bounces-2553-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:54:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 390BC46456D
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 02:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F9BE300D159
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D91B1DD889;
	Sat, 25 Apr 2026 00:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFLF5L/0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A69E1BD9C9
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777078440; cv=none; b=B2ZlHVnr2XlFtudg9lxgNHktsw91iRINIsct6oNukrlx2gZ0GPh0AM2M5Btp88bgeOasAVrYQIxbYjBBHlhNNsnIzUpd/l6FE7DaIwQbQRKISiY5h4hbx2ZhO2ODusNJ1vOd2tN1Q4aoTWmcGVZbCe6YUHobC+IXxJTRrOnVTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777078440; c=relaxed/simple;
	bh=kliSAN2llaoGcoIsZ1qokNDFYmVJA8Ec0FXU8XxOhWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWdQrPOoyBj+ijdm12LsDkVXvboA1pvpR0Az65t2iI7nW2GUWimKbiJWzokq4qbd45Nd/AHmIVYbXLjb1ZQnv7vLPgNiTsvwOYqiU4R6vwU3dtRc6AHVlpmLiNawBc86PWGSflHVYyo7CycyUfC3afY0fSIdbzNXcAkxZoLwSnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFLF5L/0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFF4C2BCB6
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777078439;
	bh=kliSAN2llaoGcoIsZ1qokNDFYmVJA8Ec0FXU8XxOhWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QFLF5L/0BSw2xkYBuizmPXE7PWxRQWWW0CRn2VjgJ0x+UDWgYQeVtO35O+mr/5uiS
	 6qZl3b2L95yilqCeSHO6hnxC4VZ7KxvE4F7OxXa2dOFe24x2jSZqP5vsqduB8jkTf6
	 b244zoBlcZOEFQHmm8T4NQ9dQd7qKePr5IoZlHqbAuP8mKEalfetOm/hlJRbzwfXEc
	 pUK4GrZoU7hszadwxOwZaL27lHA+9gD5CK77fY6vVqA87lUh6hCI14dV+e9Atav+mz
	 P0gLt3hGNiVQu36HYBSMAMoMW1AQ3vXC442XA9SmfB3ty5Dr+qa5Nc3PmxBv6V4uKy
	 epN7ShoRFHIlw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899a9f445cbso99799036d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 17:53:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8m7HMZoDFfn8Xiy8v11wBz/v+rS268BaSpY8oGwbXdOLgtUXo5SSMW8tMePUbB6LXTkYw4SHTlS5mN2mjT@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx5z0uqgy9rTC56ZiGKSe3QplQIoA0b1QkyRHBgk3pXLqb4h3C
	OViSLqJ5THC0Hu3lO9NSKoTwGaboq31RPis1dBVq5XOK2p3OExz4+Q3q5M1g/ZuQt4eCfR4YFsz
	lzchXV5e3g/eHVjF519cefu+s50C4Iqs=
X-Received: by 2002:ad4:5c81:0:b0:8ae:6587:3d6c with SMTP id
 6a1803df08f44-8b0280eaa5fmr557900116d6.28.1777078438843; Fri, 24 Apr 2026
 17:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 17:53:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
X-Gm-Features: AQROBzAE3bmYe6srgWBQeUZVmbdgFDD4C5X4wjJ5N1yJAPl9AMmQcvcK8MfIZTo
Message-ID: <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
Subject: Re: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 390BC46456D
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
	TAGGED_FROM(0.00)[bounces-2553-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Rewrite the symbol correlation code, using a tiered list of
> deterministic strategies in a loop.  For duplicately named symbols, each
> tier applies a filter with the goal of finding a 1:1 deterministic
> correlation between the original and patched version of the symbol.
>
> Overall this works much better than the existing algorithm, particularly
> with LTO kernels.

I found it is hard to follow all the matching algorithms here. Could you
please add some examples for each case: different levels in find_twin(),
match in find_twin_suffixed(), and match in find_twin_positional()?

Also a few nitpicks below.

> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
[...]
> +static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
> +{
> +       struct symbol *name_last =3D NULL, *scope_last =3D NULL,
> +                     *file_last =3D NULL, *csum_last =3D NULL;
> +       unsigned int name_orig =3D 0, name_patched =3D 0;
> +       unsigned int scope_orig =3D 0, scope_patched =3D 0;
> +       unsigned int file_orig =3D 0, file_patched =3D 0;
> +       unsigned int csum_orig =3D 0, csum_patched =3D 0;
> +       struct symbol *sym2, *match =3D NULL;
> +
> +       /* Count orig candidates */
> +       for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym=
2) {
> +               if (sym2->twin || sym1->type !=3D sym2->type || dont_corr=
elate(sym2) ||
> +                   (!maybe_same_file(sym1, sym2)))
>                         continue;
>
> -               count++;
> -               result =3D sym2;
> +               /* Level 1: name match (widest filter)  */
> +               name_orig++;
> +
> +               /* Level 2: scope (scope changes allowed) */
> +               if (is_tu_local_sym(sym1) !=3D is_tu_local_sym(sym2))

is_tu_local_sym(sym1) is called many times, shall we add a variable
for it?

> +                       continue;
> +               scope_orig++;
> +
> +               /* Level 3: file (scope changes disallowed) */
> +               if (!same_file(sym1, sym2))
> +                       continue;
> +               file_orig++;
> +
> +               /* Level 4: checksum (unchanged symbols) */
> +               if (sym1->len !=3D sym2->len || !sym1->csum.checksum ||
> +                   sym1->csum.checksum !=3D sym2->csum.checksum)
> +                       continue;
> +               csum_orig++;
>         }
>
> -       if (count > 1) {
> -               ERROR("Multiple (%d) correlation candidates for %s", coun=
t, sym->name);
> -               return -1;
> +       /* Count patched candidates */
> +       for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, =
sym2) {
> +               if (sym2->twin || sym1->type !=3D sym2->type || dont_corr=
elate(sym2))
> +                       continue;
> +
> +               /* Level 1 */
> +               if (!maybe_same_file(sym1, sym2))
> +                       continue;

This for_each_sym_by_demangled_name() has two "if () continue" while the
first one has one. Maybe keep them the same (just for symmetry)?

Thanks,
Song

> +               name_patched++;
> +               name_last =3D sym2;
> +

[...]

