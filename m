Return-Path: <live-patching+bounces-1218-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BE5A3C675
	for <lists+live-patching@lfdr.de>; Wed, 19 Feb 2025 18:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4053B5AB2
	for <lists+live-patching@lfdr.de>; Wed, 19 Feb 2025 17:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3CC2147E0;
	Wed, 19 Feb 2025 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMVJe7fp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B6C2144C8;
	Wed, 19 Feb 2025 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987069; cv=none; b=JlM6bwGhXp/SQ44UkSWwUHQ/RqSUWV46dTRhJv5lPU9gs3SMN3j5zq2G8Y9SFRene7pgBTDDFILMwpsp0wucAm+iVJ+lRfSt4Q/BotbuwncbDOSgc06d42lfZBLk+1MMDFUOZ1a8Pbwnems4ozxyEG/syETNTnfRUYJhzeSkBFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987069; c=relaxed/simple;
	bh=P9559ZQEN05cSHCNws4blnYdv7eulky3QojL+fa+sSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SeUEHuVtnp0RodkjdvrZCbgNOu4SkGA0CyOuSJjg4R9LycOW491TCwBT2ST4TRHsYCmrJ68PSIzigzfeDCEqZi+CuLIBujx5GQW5DbVKVwhSeKRkLsip2IjwCExdn6zf3pNRP7LpwUNH5s+5KootnyxBwLbULVX8x8qjZR8ULu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMVJe7fp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59450C4CEEA;
	Wed, 19 Feb 2025 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739987068;
	bh=P9559ZQEN05cSHCNws4blnYdv7eulky3QojL+fa+sSY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DMVJe7fpqEzub1KPgxZn7wM8lKnowJesFXcu939vXCxxjWNHi/aaSGkjzV2USGA+I
	 czG8H64YjZoKH52M9tfDkVBuMDmORYpf5usSq2BmX5x97cZfcZJE+pB4+rqgp5Kbys
	 /zOwTN4d2ColFs79GZ2JjpaM19AiEL/2hUhWAQGA9i9Q9dHU+X4r+Wf0K5cf2J/rZk
	 m3PQS6GOpT2h6FKx1ZjtZZhD9XIyBmVA+QpsGL8OL6xUHbSdQVLwJnCghE5o+6ds2F
	 yJfGFafxs0NlQ6fMTrCF3hmeLGduHMgTEZLX+ZzHNDrnd9b6WMzVBjYkX47QukCp81
	 KGRyOX85z96fA==
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-8559020a76aso1655339f.2;
        Wed, 19 Feb 2025 09:44:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUL1gtX3Cq/Xtalee5AZ2x1cpAhZrpRcnF9NJZoNmtDevMV2Undrn54Rv8lGbDhvqmEmV6y9gjWAp8547ip8YMhhw==@vger.kernel.org, AJvYcCUW9jmdQjhFwaPY6rHJHitAp3JOh1MvSqjbe9GRvcGVeBtM+tE1d0OY2XWhelUnHgunnn4CE5DsLCVpmG3SBw==@vger.kernel.org, AJvYcCWadrG5YsE/4RfZDmGBiIJ7wl//WdxrQ5Sc9Fw4bTCpvkBUGPvtdfhinUlUZUygQWbQQJYPuSZXaG61Pzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP7CuRlED3WfnDgyCZte5zChJNy7i/blmoOy2o36hP+Q44j7lw
	4wzFruE/yONQ0OYxn/6Z7iKq5o2YuEB3P6fZ+2YP6xEcCZ64elrEc5I+vAmeSI8Tn9Olj5k4TXl
	tv/A/EfpUwgmIwKKiwwXL7+du1f4=
X-Google-Smtp-Source: AGHT+IFqctJDLYt8o9POb825AvbprIhb3/YXU6tj6OURcv7+yyJpYdpSd7sBpONtuh0JXK7WxMebRgB47SmP6H7BRVc=
X-Received: by 2002:a05:6e02:4604:b0:3d2:b34d:a25b with SMTP id
 e9e14a558f8ab-3d2b34da6eamr51053525ab.16.1739987067676; Wed, 19 Feb 2025
 09:44:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <mb61py0yaz3qq.fsf@kernel.org> <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe> <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe> <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe> <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
 <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe> <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
 <20250218184059.iysrvtaoah6e4bu4@jpoimboe>
In-Reply-To: <20250218184059.iysrvtaoah6e4bu4@jpoimboe>
From: Song Liu <song@kernel.org>
Date: Wed, 19 Feb 2025 09:44:16 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
X-Gm-Features: AWEUYZlbvda0ssoST11NMSiSSWWtT-MfCvr9C6FVMAAFHGp3LqVR7dXcnBcn3yI
Message-ID: <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 10:41=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Tue, Feb 18, 2025 at 10:20:10AM -0800, Song Liu wrote:
> > Hi Josh,
> >
> > On Mon, Feb 17, 2025 at 10:37=E2=80=AFPM Josh Poimboeuf <jpoimboe@kerne=
l.org> wrote:
> > >
> > > On Mon, Feb 17, 2025 at 08:38:22PM -0800, Song Liu wrote:
> > > > On Fri, Feb 14, 2025 at 3:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@ke=
rnel.org> wrote:
> > > > > Poking around the arm64 module code, arch/arm64/kernel/module-plt=
s.c
> > > > > is looking at all the relocations in order to set up the PLT.  Th=
at also
> > > > > needs to be done for klp relas, or are your patches already doing=
 that?
> > > >
> > > > I don't think either version (this set and my RFC) added logic for =
PLT.
> > > > There is some rela logic on the kpatch-build side. But I am not sur=
e
> > > > whether it is sufficient.
> > >
> > > The klp relas looked ok.  I didn't see any signs of kpatch-build doin=
g
> > > anything wrong.  AFAICT the problem is that module-plts.c creates PLT
> > > entries for regular relas but not klp relas.
> >
> > In my tests (with printk) module-plts.c processes the .
> > klp.rela.vmlinux..text.copy_process section just like any other .rela.*
> > sections. Do we need special handling of the klp.rela.* sections?
>
> Ok, I see how it works now:
>
> klp_write_section_relocs()
>         apply_relocate_add()
>                 module_emit_plt_entry()
>
> If that code is working correctly then I'm fresh out of ideas...

I tried to dump assembly of copy_process, but couldn't find any
clue. I am wondering whether this is an issue with gcc-14.2.1.

Puranjay, could you please try with a different gcc, like some
version of gcc-14?

Thanks,
Song

