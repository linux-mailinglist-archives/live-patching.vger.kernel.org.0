Return-Path: <live-patching+bounces-1118-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80757A29836
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 18:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DE2E1887842
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 17:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778D61FC0EB;
	Wed,  5 Feb 2025 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0iEBmLS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4AB1519AD;
	Wed,  5 Feb 2025 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778380; cv=none; b=VzOqOgWHDX01hkWXVTrV/Zlu5Ulq0StP18IVrVUDAkVbpqiWrsjk4Lv+7p0KgaYynHHJtcZHEzWRi5MIHyVNHX2dhVxA+MNyOYpy1wJHfTbkJkDYwfs/7ZYd1TLqrJfvGbHmbTmyLT4kOWTLAAPGvDbbRt5N+N5JAYNmQTSc0T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778380; c=relaxed/simple;
	bh=d/ncfLhirm1SzUCcvJRbgrlDISq4qKX8Z31nBH9wVp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rwybuVZ8jPplo/pSRsSCBB2kWtT/ASNqQ/71tISwtuPg5oJKarlDkXORYBGVpWHXBQ1GkmChd/W9Xb33+HY5XpCt7dVioto/39myf995sRPEZ/9mYaKzlljxNX0z8Qwop9ZA5XU5rNJHx9zc4fNOe0FHZPJPfC2dqACaVVTtTM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0iEBmLS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EE3C4CEE9;
	Wed,  5 Feb 2025 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738778379;
	bh=d/ncfLhirm1SzUCcvJRbgrlDISq4qKX8Z31nBH9wVp0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s0iEBmLSWPsc69rmoXUYoPrJ84IGC9rhr4vFHe7oBKGUjFjcb7j/2hGR+3Y2tf5IO
	 dtY2MSC+Tca/FV2TIfi+1lw5oGu6wBAbDIK7ayU1nx4hbnlpXhteVHJ2MMu/zMEUpv
	 3uwXW3NaLE39LnIKm8a2sGi65/LGa3ujSX3BINiFKxJKSL3CWvLjGE8kKMKeo1Jma4
	 qeCMM+MyLICwcRbXMDKTyZVQr7tFifp6wzlJnhBX9XU0LbNE27F8cchpvsHFA26fTj
	 JYuFTlSRBWedidVQdbaY19UXwmG2Xyayk0J7NE8HPgdmSUfBWRm4X/aUz1FSkEK06K
	 Jgd0krfoafd7Q==
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d04d767d3aso11332265ab.2;
        Wed, 05 Feb 2025 09:59:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYJ5oMrziHP1fHgRKs4qROOA6VmYBq7dWwsElq0UZvCZqAJRtFChy6yjjW1HdCGcE21tCPSPS50m4JRjEkaw==@vger.kernel.org, AJvYcCUj6ioGAfYUG1w193kA72lOHSEYSM2pVjuIqtvtsYBJLrdhXE/Gl5O204y2Gn7T0F01GrDK4ZDmZ0pyr+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVKNITtPzpcq33sAT7G4GX5j0qkiIgjAtJ+7x8slPJ0uvr7CC9
	dKzcujWF8idZJz9JFrRXIixT3GDtTztMpr3XzcL6fXRWJ/zbPeyA5SswkjYiBZZY9Ch1B+N3qfw
	ykC+wNfUATgYtZLpwqi8ECU3cliw=
X-Google-Smtp-Source: AGHT+IHxnrrlP8lTVjIAionLGzfbEycFUWCaTe8sMGWKukqmhdK2GkhnggL8NXpVNzz6zvFZYxb+/1SIODifxNql9Mg=
X-Received: by 2002:a05:6e02:1d1d:b0:3d0:28d3:e4ba with SMTP id
 e9e14a558f8ab-3d04f917ccamr34423415ab.18.1738778378925; Wed, 05 Feb 2025
 09:59:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com> <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
In-Reply-To: <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Wed, 5 Feb 2025 09:59:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
X-Gm-Features: AWEUYZk3v2MJ4U19GNvPDP61l38zFfek7GS3xv_pglWI5KifR2MidcH72DyIR9A
Message-ID: <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf <bpf@vger.kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 6:43=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Tue, Feb 4, 2025 at 5:53=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Feb 3, 2025 at 1:45=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > [...]
> > >
> > > If you=E2=80=99re managing a large fleet of servers, this issue is fa=
r from negligible.
> > >
> > > >
> > > > > Can you provide examples of companies that use atomic replacement=
 at
> > > > > scale in their production environments?
> > > >
> > > > At least SUSE uses it as a solution for its customers. No many prob=
lems
> > > > have been reported since we started ~10 years ago.
> >
> > We (Meta) always use atomic replacement for our live patches.
> >
> > >
> > > Perhaps we=E2=80=99re running different workloads.
> > > Going back to the original purpose of livepatching: is it designed to=
 address
> > > security vulnerabilities, or to deploy new features?
> > > If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot of =
room for improvement.
> >
> > We only use KLP to fix bugs and security vulnerabilities. We do not use
> > live patches to deploy new features.
>
> +BPF
>
> Hello Song,
>
> Since bpf_fexit also uses trampolines, I was curious about what would
> happen if I attached do_exit() to fexit. Unfortunately, it triggers a
> bug in BPF as well. The BPF program is as follows:
>
> SEC("fexit/do_exit")
> int fexit_do_exit
> {
>     return 0;
> }
>
> After the fexit program exits, the trampoline is still left over:
>
> $ bpftool  link show  <<<< nothing output
> $ grep "bpf_trampoline_[0-9]" /proc/kallsyms
> ffffffffc04cb000 t bpf_trampoline_6442526459    [bpf]

I think we should first understand why the trampoline is not
freed.

> We could either add functions annotated as "__noreturn" to the deny
> list for fexit as follows, or we could explore a more generic
> solution, such as embedding the "noreturn" information into the BTF
> and extracting it when attaching fexit.

I personally don't think this is really necessary. It is good to have.
But a reasonable user should not expect noreturn function to
generate fexit events.

Thanks,
Song

> Any thoughts?
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d77abb87ffb1..37192888473c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -22742,6 +22742,13 @@ BTF_ID(func, __rcu_read_unlock)
>  #endif
>  BTF_SET_END(btf_id_deny)
>
> +BTF_SET_START(fexit_deny)
> +BTF_ID_UNUSED
> +/* do_exit never returns */
> +/* TODO: Add other functions annotated with __noreturn or figure out
> a generic solution */
> +BTF_ID(func, do_exit)
> +BTF_SET_END(fexit_deny)
> +
>  static bool can_be_sleepable(struct bpf_prog *prog)
>  {
>         if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
> @@ -22830,6 +22837,9 @@ static int check_attach_btf_id(struct
> bpf_verifier_env *env)
>         } else if (prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
>                    btf_id_set_contains(&btf_id_deny, btf_id)) {
>                 return -EINVAL;
> +       } else if (prog->expected_attach_type =3D=3D BPF_TRACE_FEXIT &&
> +                  btf_id_set_contains(&fexit_deny, btf_id)) {
> +               return -EINVAL;
>         }
>
>         key =3D bpf_trampoline_compute_key(tgt_prog,
> prog->aux->attach_btf, btf_id);

