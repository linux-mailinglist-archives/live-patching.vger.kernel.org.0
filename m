Return-Path: <live-patching+bounces-1810-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5E9C0873A
	for <lists+live-patching@lfdr.de>; Sat, 25 Oct 2025 02:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0840F3AFC15
	for <lists+live-patching@lfdr.de>; Sat, 25 Oct 2025 00:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8250B19F115;
	Sat, 25 Oct 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nu3HjmvM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0D9136E3F
	for <live-patching@vger.kernel.org>; Sat, 25 Oct 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761352401; cv=none; b=YXSUpSn3t7a6Rfjn+VdNTWt6qaFRl6FBsixt9/3p8ZOgvgrut/q7Ljkn0Swm+bwQUeat6OdxnW2L7HEgam3CRAprnnQS7xiBv77uUWCV6C8rq0smlFrwNfe+bREZENfv0xZPiOqbNOcBjWqTeKQOnnJ51+ugRd8N/RNkgZMXh5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761352401; c=relaxed/simple;
	bh=PgR7lzU9RlXHT5sK4VOdFxsHQoX+25lTA+URTQprJPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GCKf8+XtyXnolLhY69VEtFSsYsodkS1oodKj1WxeOYGz1CIA3FudfFpgK7Aap8pjcwqML4J3NhL1ojsPbW8PovITEQUzhGmd0E4UAXwTO54gigUGBSVP2G7jGlvabNIB7Aj9Q5TOsBSAIvLLnmEnLcU/dysxsPgxWffITBqBNpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nu3HjmvM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16517C19421
	for <live-patching@vger.kernel.org>; Sat, 25 Oct 2025 00:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761352401;
	bh=PgR7lzU9RlXHT5sK4VOdFxsHQoX+25lTA+URTQprJPU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Nu3HjmvMYw2bBqcxpF+LkUoYKjCaF0ilugj0int+eHn0fY5Mb2/ccFSqjGvdnHyF5
	 4nPNYRzzh/5PADVeoux05YIIRv0ChEyS67ImGtYEKPLujUu2sd2gdjo526GT02vAxD
	 8cpUyBfb6Tu2L9NtF163yyxOYHyUTI1CVlHUDwyBMnUGb8SRZeimS7/+z8QXontzbJ
	 rvCnusjOH3PV0WuHnPveQLdr2WFMwdl6idwc1qJQCXTSov3t1EUfuPEo9QBpjza1vK
	 JynBbij7HahhilXveV1fQbnKnVm5kNlkHyPtQut/LlS3dSnsO9InMw6Nqaf8a9CPia
	 L8JT180vyzPYQ==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-79599d65f75so23137546d6.2
        for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 17:33:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGxBTUuA8GrqVLSi3JkJEhM6/mvxPhxEaRmPIEDIb90MhM/FiYzTOI10jozoWjYsgsAwrKGkm4KGR09ULn@vger.kernel.org
X-Gm-Message-State: AOJu0YwauTHAajQCS2gHdbcyWM5d54oBDLrND6RLIyYKE/y1CWlRym8f
	NHBrW+3JlzsM125gbc+0hoAvQCBFoVpml5bwqnLwQnrGc8oIBvAHKr9wSbs2qBMrpRg11PcaJkG
	Z4Vr1pMvCz0x/3n5fnNYmYDsg6H2E99Y=
X-Google-Smtp-Source: AGHT+IHT9C2MVfE2QgFCOr3nqh2/Dwq2wsY4Lvxnsl+07Ia7Ig9leK6YSyrwqd3getEar74gYWLTQVaTOW7PZfw3sto=
X-Received: by 2002:a05:6214:491:b0:87c:277f:8d38 with SMTP id
 6a1803df08f44-87fb6458d34mr64007316d6.50.1761352400140; Fri, 24 Oct 2025
 17:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024182901.3247573-1-song@kernel.org> <20251024182901.3247573-3-song@kernel.org>
 <20251024201154.392878cd@gandalf.local.home>
In-Reply-To: <20251024201154.392878cd@gandalf.local.home>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Oct 2025 17:33:09 -0700
X-Gmail-Original-Message-ID: <CAHzjS_u3_+2fnFiFuTXBchFumSeS_TjZ32yKeAsKKudBPjXEEQ@mail.gmail.com>
X-Gm-Features: AWmQ_blbqXK0qp086-ih7Y4P857Uz5YViQ9DnjYNZ4-sXHhmnxVBW6VAiaoWxio
Message-ID: <CAHzjS_u3_+2fnFiFuTXBchFumSeS_TjZ32yKeAsKKudBPjXEEQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Song Liu <song@kernel.org>, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org, kernel-team@meta.com, 
	olsajiri@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 5:11=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Fri, 24 Oct 2025 11:29:00 -0700
> Song Liu <song@kernel.org> wrote:
>
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -221,6 +221,13 @@ static int register_fentry(struct bpf_trampoline *=
tr, void *new_addr)
> >
> >       if (tr->func.ftrace_managed) {
> >               ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
> > +             /*
> > +              * Clearing fops->trampoline and fops->NULL is
> > +              * needed by the "goto again" case in
> > +              * bpf_trampoline_update().
> > +              */
> > +             tr->fops->trampoline =3D 0;
> > +             tr->fops->func =3D NULL;
> >               ret =3D register_ftrace_direct(tr->fops, (long)new_addr);
> >       } else {
> >               ret =3D bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_ad=
dr);
>
> I ran these through my own tests and this failed to build:
>
> /work/build/trace/nobackup/linux-test.git/kernel/bpf/trampoline.c: In fun=
ction =E2=80=98register_fentry=E2=80=99:
> /work/build/trace/nobackup/linux-test.git/kernel/bpf/trampoline.c:229:25:=
 error: invalid use of undefined type =E2=80=98struct ftrace_ops=E2=80=99
>   229 |                 tr->fops->trampoline =3D 0;
>       |                         ^~
> /work/build/trace/nobackup/linux-test.git/kernel/bpf/trampoline.c:230:25:=
 error: invalid use of undefined type =E2=80=98struct ftrace_ops=E2=80=99
>   230 |                 tr->fops->func =3D NULL;
>       |                         ^~
>   CC      kernel/trace/rethook.o
> make[5]: *** [/work/build/trace/nobackup/linux-test.git/scripts/Makefile.=
build:287: kernel/bpf/trampoline.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
>
> Config attched.

We need to guard this part with CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS.
The suggestion by AI should also fix this, and give cleaner code.

Thanks,
Song

