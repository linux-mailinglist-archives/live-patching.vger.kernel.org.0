Return-Path: <live-patching+bounces-1957-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAdWLhPWfmmrfQIAu9opvQ
	(envelope-from <live-patching+bounces-1957-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 01 Feb 2026 05:26:59 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D38C4E7D
	for <lists+live-patching@lfdr.de>; Sun, 01 Feb 2026 05:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBE1C301387A
	for <lists+live-patching@lfdr.de>; Sun,  1 Feb 2026 04:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7162E27934B;
	Sun,  1 Feb 2026 04:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhwyaxmz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2AB148850
	for <live-patching@vger.kernel.org>; Sun,  1 Feb 2026 04:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769920015; cv=none; b=YUbMD3wRZ68lKmtUOcOwzgC+cHxn6y98KOUsfPEB+eUuTAEbWuyQak1nFCQSDoE6JMYCW7zegU/31bepZNhHdvhnvtyiua0gIA5DVjgg180fSfoLxvCoEHnmeZxkdsOFYh3vtb9ebdnmeG79wF19b6/xLCtQHuQ6BiEljhJKqSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769920015; c=relaxed/simple;
	bh=I0DrqKc1uQ8zLNC8XwIzk+ArnWUm3cm6FP8Txa/v4l0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uRMDzv4+BrmQ4bflDP9xdIu0h7BwjzlXN1M2wZqi0bU3NOuO29NRL0XoF9+1d+rSkY6aKOa51tX4EDbWdGm7pHsze3SSXeBlc1+ypfCHerDjh3rMmlA2ORsdaIF4GZgRfZHv5EmxopKzPk5HUBWxSlZZ1E5aBoOHF3GN5NS4mlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhwyaxmz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF802C19425
	for <live-patching@vger.kernel.org>; Sun,  1 Feb 2026 04:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769920014;
	bh=I0DrqKc1uQ8zLNC8XwIzk+ArnWUm3cm6FP8Txa/v4l0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lhwyaxmz/6/yEiZ9PI8IA8wLOOqaKeXQxod+IawElJKFdgsEZEoZ6e+Exd5p+/oos
	 7V2EYRgrYU1DRZFlROPT2PNdcbu/qcAqOxkb4/gr3bdqWKxmftuZHE4Ba4j5o3n+Pz
	 Y9RUe6zR6qnz9IxtneOJNXAfBNGqpEbSBXdv/pqI30MzONnLQaQW7btaoFGdmJZq+t
	 WEm0iiywf7b91yEbuU6ULlCS+WHMrf8Yl17ytz7fVqQV2Vrvu7s2rpNXOz28AAkKOv
	 L/eImu22+jRaKsgIeZpo9as0HnzNEnA/YZO05cldTg1k/20p3ofglpqh1G/qCXlhyh
	 Gix5qJlb10gxA==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-502a789834fso30958951cf.2
        for <live-patching@vger.kernel.org>; Sat, 31 Jan 2026 20:26:54 -0800 (PST)
X-Gm-Message-State: AOJu0YyGbVlDuiSirWnzOHyLDkQAKpNQcUbgQMnOLls3kwiKCTBKL49f
	gCQ4I/UfTMNOSyvxKb+vf6n6bkUokxIHJjzd4XnCovZrA+jwj+qJ3KUsUk3tnOHNjYFSzXc9vUE
	j3heP4EGttSM6Mzxr5TqHhKc/F+OIkcY=
X-Received: by 2002:a05:622a:15d4:b0:4ee:1c10:729f with SMTP id
 d75a77b69052e-505d21ce048mr92027581cf.35.1769920013985; Sat, 31 Jan 2026
 20:26:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130203912.2494181-1-song@kernel.org> <2ngp5g3ogtin57nytfvbiq2nh6nfy5qxdianll5eme24owsyj5@a4bxxfkobnwc>
In-Reply-To: <2ngp5g3ogtin57nytfvbiq2nh6nfy5qxdianll5eme24owsyj5@a4bxxfkobnwc>
From: Song Liu <song@kernel.org>
Date: Sat, 31 Jan 2026 20:26:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7wB=DsU3Wt3BvAp03NOoAySx7kKcKm5R0ySwe3-+3LJQ@mail.gmail.com>
X-Gm-Features: AZwV_QgLozZaBgqN9reGaeOiNQLikL5-Ay9nG3pI1kAzfw3BrCPnKNOMehRmhOM
Message-ID: <CAPhsuW7wB=DsU3Wt3BvAp03NOoAySx7kKcKm5R0ySwe3-+3LJQ@mail.gmail.com>
Subject: Re: [PATCH] klp-build: Do not warn "no correlation" for __irf_[start|end]
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1957-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 24D38C4E7D
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 6:27=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
[...]
> It's a bit worrisome that Clang is stripping FILE entries and moving
> symbols, but I looked at the symbol table for a thin LTO vmlinux.o and
> it only seems to have stripped this one FILE symbol for initramfs_data.o
> and made its symbols orphans.  Presumably because this file only has
> data and no code.
>
> I actually think the warning is valid.  We should try to correlate those
> pre-FILE symbols, otherwise things like klp_reloc_needed() might not
> work as intended.
>
> Does the below patch work instead?

Yes, this does look better. Let's ship this version.

Thanks,
Song

>
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index d94531e3f64e..ea292ebe217f 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -364,11 +364,40 @@ static int correlate_symbols(struct elfs *e)
>         struct symbol *file1_sym, *file2_sym;
>         struct symbol *sym1, *sym2;
>
> -       /* Correlate locals */
> -       for (file1_sym =3D first_file_symbol(e->orig),
> -            file2_sym =3D first_file_symbol(e->patched); ;
> -            file1_sym =3D next_file_symbol(e->orig, file1_sym),
> -            file2_sym =3D next_file_symbol(e->patched, file2_sym)) {
> +       file1_sym =3D first_file_symbol(e->orig);
> +       file2_sym =3D first_file_symbol(e->patched);
> +
> +       /*
> +        * Correlate any locals before the first FILE symbol.  This has b=
een
> +        * seen when LTO inexplicably strips the initramfs_data.o FILE sy=
mbol
> +        * due to the file only containing data and no code.
> +        */
> +       for_each_sym(e->orig, sym1) {
> +               if (sym1 =3D=3D file1_sym || !is_local_sym(sym1))
> +                       break;
> +
> +               if (dont_correlate(sym1))
> +                       continue;
> +
> +               for_each_sym(e->patched, sym2) {
> +                       if (sym2 =3D=3D file2_sym || !is_local_sym(sym2))
> +                               break;
> +
> +                       if (sym2->twin || dont_correlate(sym2))
> +                               continue;
> +
> +                       if (strcmp(sym1->demangled_name, sym2->demangled_=
name))
> +                               continue;
> +
> +                       sym1->twin =3D sym2;
> +                       sym2->twin =3D sym1;
> +                       break;
> +               }
> +       }
> +
> +       /* Correlate locals after the first FILE symbol */
> +       for (; ; file1_sym =3D next_file_symbol(e->orig, file1_sym),
> +                file2_sym =3D next_file_symbol(e->patched, file2_sym)) {
>
>                 if (!file1_sym && file2_sym) {
>                         ERROR("FILE symbol mismatch: NULL !=3D %s", file2=
_sym->name);

