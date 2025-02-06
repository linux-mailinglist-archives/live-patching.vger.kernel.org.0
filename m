Return-Path: <live-patching+bounces-1119-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D13BCA29ED6
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 03:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24D8E3A7F5B
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 02:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5B4126C16;
	Thu,  6 Feb 2025 02:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9TM/wU6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F32AC17;
	Thu,  6 Feb 2025 02:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738809350; cv=none; b=Oo44+o+g2noyDngPfUBrqQN03mNIWaFVjkFzgCLMTNYhyJ/Vbzb7wsQF+XyBleulBD5A5N3PFsJkomzguVIC2mStPFtUAjMcSaDRlDTe31sOg8jRjHiRhG5mopwpcO3PLMZIgVtWpV+uTKbiG0B5B2+0NTgqYYczfdlR8z/dW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738809350; c=relaxed/simple;
	bh=GYxfoo7ZBm6mTIjU4Y7seLQNtLz4FhrxLT8K9eLqyt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fvQphcRpBHlmKSke8vTtUlNggjQ3iKAepNrLabD1kyXq9NnNZElBUM6N7Y1IBebfLvW0kEmQbxaHqH4tKER56w8sk87Auo5y9ke/q8vKkvXkVCd3US5xiOnKXzEf7eHSoqdXXGTYKhmK53ppzCeOzGhTUrGXVhyb1WGFO5pulGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F9TM/wU6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6dd420f82e2so6416926d6.1;
        Wed, 05 Feb 2025 18:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738809347; x=1739414147; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLi4zif5mqTQDl3T2SO7WuK6aO29RyLcLRZTs8ORW80=;
        b=F9TM/wU6ncioWtXkPaPdaSyBYbFoBKAJRfflrwMBu9j5LY8xTruwwSPBvtei/Iq/OV
         kDxzE4KlAofZrnR53P7ATS4EQYw6eyssVGyK2LunWljXH/5qTw1QEnHSqVx6lUzIcz65
         ++W/A/K++aVvJLymbnVfxliowd6KmM3dCJv0QSG9m+/tbVKh+IWYDbg8s8cbeDp6hMj1
         iR0NOtEPPC5TmWukquVsJ7mvPvX846rfjokO3ZpRaCT0V3189XywpJaeZZvSyOtsf3DP
         9qqBqnWb0PNKSa9Cie65Z507lh2i4dcAf8H232tMxu6syERz+BEnRPBNa85RoPtetSst
         7S1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738809347; x=1739414147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MLi4zif5mqTQDl3T2SO7WuK6aO29RyLcLRZTs8ORW80=;
        b=IIahdDHekYW3C8QXOfGAOkz20NowAW6zrLUX7YG/c/KtiWlb6y6w8YTy638cLyFyOA
         7rd5nm5A+OeUKy1sYWQ86PLAOCL6Gd0NyE7jUyNlC57NLpncipg5tXt3JvSbsGinBVM/
         1Pfn/gTcuWF9OQHlT4rPqB/VZbDU1OOqZslHy++z2r+ql6BRd0+JL+zYjc1J8zQCw5SA
         LPW6QRbOL67yQBPvmjD5GIQm7CbkB1x/nKs23qW5pmOvssUxM1ZpsFXBP3jpgeaz0QkH
         zlIbccx3EQ7e0uLoBsP/5M2zUuwfQNbWNvVAaGKS0jMDv5LqomcG8Z4qU1QlJfl0Lk2d
         dZgg==
X-Forwarded-Encrypted: i=1; AJvYcCWN1qX8JNSHq0N+uaO3g5q4qBz/mv1Pgv+qlArL9GUfXt0/swJcHrRMAukdPEI/Aj+hqmDfNESOZ23agfo=@vger.kernel.org, AJvYcCXLAdyzVnhbvS6yWSMzL3DQUiDmdEfPdDe6lH5sBIrEO2JguHzvPtwSH7xhLPhr7OPs7HcgVPxPCZisB6n7EA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3ONw0/yNXGl+0H9qMtPqsTEpwFysWnXnA6bHefC3pGD3ggzaM
	UH9LBkyg3hvWZOy1PFEj8XKq/AFJaTarFQRhg4Q0DxMHX0VDqz/2I92zhOEXIcPqWmaPMkaPTMZ
	VE5lad8TWvC7KWYxZGOQ898OG4aY=
X-Gm-Gg: ASbGncuIzMiT3pJ6Npa/7ZMIJ0b10twQKPMh3mKHlXubicvVZDrvG4YBb1L92tXcP7V
	E+Qcdjs8Lfw5kW6J+arBJtOH5cE73Ja0czLLdmCKXmAbbo+cJplZJ/68BLfZcaWfTDm85foCrrQ
	8=
X-Google-Smtp-Source: AGHT+IHsoUXN3inN8ktMOVimyacNePTc4ICmj3KMYGqnked3c0oW71IUHwynTOyQXNuYhCHOxPnvdRIstLmzggY9erw=
X-Received: by 2002:a05:6214:252f:b0:6d8:8d87:e5b4 with SMTP id
 6a1803df08f44-6e42fbb8f9dmr81394326d6.19.1738809347586; Wed, 05 Feb 2025
 18:35:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz> <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
 <Z6IUcbeCSAzlZEGP@pathway.suse.cz> <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>
 <Z6OLvQ6KlVeuOkoO@pathway.suse.cz>
In-Reply-To: <Z6OLvQ6KlVeuOkoO@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 6 Feb 2025 10:35:11 +0800
X-Gm-Features: AWEUYZkljzn9UYPZgTB3spCJqskFhAEedfDcaRDsLR-Mi-zXJ59hitCjT4qYxWs
Message-ID: <CALOAHbCJRce9-VYNgUO5szU4kMSktXyvkY9+ZFX_kyVXeoQ1ig@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 12:03=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Wed 2025-02-05 10:54:47, Yafang Shao wrote:
> > On Tue, Feb 4, 2025 at 9:21=E2=80=AFPM Petr Mladek <pmladek@suse.com> w=
rote:
> > >
> > > On Mon 2025-01-27 23:34:50, Yafang Shao wrote:
> > > > On Mon, Jan 27, 2025 at 10:31=E2=80=AFPM Petr Mladek <pmladek@suse.=
com> wrote:
> > > > >
> > > > > On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> > > > > > The atomic replace livepatch mechanism was introduced to handle=
 scenarios
> > > > > > where we want to unload a specific livepatch without unloading =
others.
> > > > > > However, its current implementation has significant shortcoming=
s, making
> > > > > > it less than ideal in practice. Below are the key downsides:
> > > > >
> > > > > [...]
> > > > >
> > > > > > In the hybrid mode:
> > > > > >
> > > > > > - Specific livepatches can be marked as "non-replaceable" to en=
sure they
> > > > > >   remain active and unaffected during replacements.
> > > > > >
> > > > > > - Other livepatches can be marked as "replaceable," allowing ta=
rgeted
> > > > > >   replacements of only those patches.
> > > > > >
> > > > > > This selective approach would reduce unnecessary transitions, l=
ower the
> > > > > > risk of temporary patch loss, and mitigate performance issues d=
uring
> > > > > > livepatch replacement.
> > > > > >
> > > > > > --- a/kernel/livepatch/core.c
> > > > > > +++ b/kernel/livepatch/core.c
> > > > > > @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *p=
atch)
> > > > > >               klp_for_each_object(old_patch, old_obj) {
> > > > > >                       int err;
> > > > > >
> > > > > > +                     if (!old_patch->replaceable)
> > > > > > +                             continue;
> > > > >
> > > > > This is one example where things might get very complicated.
> > > >
> > > > Why does this example even exist in the first place?
> > > > If hybrid mode is enabled, this scenario could have been avoided en=
tirely.
> > >
> >
> > You have many questions, but it seems you haven=E2=80=99t taken the tim=
e to read even
> > a single line of this patchset. I=E2=80=99ll try to address them to sav=
e you some time.
>
> What?

Apologies if my words offended you.

>
> > > How exactly this scenario could be avoided, please?
> > >
> > > In the real life, livepatches are used to fix many bugs.
> > > And every bug is fixed by livepatching several functions.
> > >
> > > Fix1 livepatches: funcA
> > > Fix2 livepatches: funcA, funcB
> > > Fix3 livepatches: funcB
> > >
> > > How would you handle this with the hybrid model?
> >
> > In your scenario, each Fix will replace the applied livepatches, so
> > they must be set to replaceable.
> > To clarify the hybrid model, I'll illustrate it with the following Fixe=
s:
> >
> > Fix1 livepatches: funcA
> > Fix2  livepatches: funcC
> > Fix3 livepatches: funcA, funcB
>
> How does look the livepatched FuncA here?
> Does it contain changes only for Fix3?
> Or is it cummulative livepatches_funA includes both Fix1 + Fix3?

It is cumulative livepatches_funA includes both Fix1 + Fix3.

>
> > Fix4  livepatches: funcD
> > Fix5 livepatches: funcB
> >
> > Each FixN represents a single /sys/kernel/livepatch/FixN.
> > By default, all Fixes are set to non-replaceable.
> >
> > Step-by-step process:
> > 1. Loading Fix1
> >    Loaded Fixes: Fix1
> > 2. Loading Fix2
> >    Loaded Fixes: Fix1 Fix2
> > 3. Loading Fix3
> >     Before loading, set Fix1 to replaceable and replace it with Fix3,
> > which is a cumulative patch of Fix1 and Fix3.
>
> Who will modify the "replaceable" flag of "Fix1"? Userspace or kernel?

Userspace scripts. Modify it before loading a new one.

>
> How the livepatch modules would get installed/removed to/from the
> filesystem?

It doesn't make any difference.

>
> We (SUSE) distribute the livepatches using RPM packages. Every new
> version of the livepatch module is packaged in a RPM package with
> the same name and higher version. A post install script loads
> the module into the kernel and removes disabled livepatch modules.

Similar to us.

>
> The package update causes that the new version of the livepatch module
> is enabled and the old version is removed. And also the old version
> of the module and is removed from the filesystem together with the old
> version of the RPM package.
>
> This matches the behavior of the atomic replace. There is always only
> one version of the livepatch RPM package installed and only one
> livepatch module loaded/enabled. And when it works correcly then
> the version of the installed package matches the version of the loaded
> livepatch module.
>
> This might be hard to achieve with the hybrid model. Every livepatch
> module would need to be packaged in a separate (different name)
> RPM package.

Before switching to atomic replace, we packaged all the livepatch
modules into a single RPM. The RPM installation handled them quite
well.

> And some userspace service would need to clean up both
> kernel modules and livepatch RPM packages (remove the unused ones).
>
> This might add a lot of extra complexity.

It's not that complex=E2=80=94just like what we did before atomic replaceme=
nt
was enabled.

>
> >     Loaded Fixes:  Fix2 Fix3
> > 4. Loading Fix4
> >     Loaded Fixes:  Fix2 Fix3 Fix4
> > 5. Loading Fix5
> >     Similar to Step 3, set Fix3 to replaceable and replace it with Fix5=
.
> >     Loaded Fixes:  Fix2 Fix4 Fix5
>
> Let's imagine another situation:
>
> Fix1 livepatches: funcA, funcB
> Fix2  livepatches: funcB, funcC
> Fix3 livepatches: funcA, funcC
>
> Variant A:
>
>  1. Loading Fix1
>     Loaded Fixes: Fix1
>     In use:: funcA_fix1, funcB_fix1
>
>  2. Loading Fix2
>     Loaded Fixes: Fix1 Fix2
>     In use: funcA_fix1, funcB_fix2, funcC_fix2
>
>  3. Loading Fix3
>     Loaded Fixes: Fix2 Fix3
>     In use: funcA_fix3, funcB_fix2, funcC_fix3
>
>     This will be correct only when:
>
>         + funcA_fix3 contains both changes from Fix1 and Fix3
>         + funcC_fix3 contains both changes from Fix2 and Fix3
>
>
> Variant B:
>
>  1. Loading Fix1
>     Loaded Fixes: Fix1
>     In use:: funcA_fix1, funcB_fix1
>
>  2. Loading Fix2 (fails from some reason or is skipped)
>     Loaded Fixes: Fix1
>     In use:: funcA_fix1, funcB_fix1
>
>  3. Loading Fix3
>     Loaded Fixes: Fix1 Fix2
>     In use: funcA_fix3, funcB_fix1, funcC_fix3
>
>     This will be correct only when:
>
>         + funcA_fix3 contains both changes from Fix1 and Fix3
>             and stays funcB_fix1 is compatible with funcA_fix3
>         + funcC_fix3 contains changes only from Fix3,
>             it must be compatible with the original funcB because
>
> I want to say that this would work only when all livepatches
> are loaded in the right order. Otherwise, it might break
> the system.
>
> How do you want to ensure this?

As we discussed earlier, if there=E2=80=99s an overlap between two
livepatches, we merge them into a cumulative patch and replace the old
one.

>
> Is it really that easy?
>
> > 3. Loading Fix3
> >     Before loading, set Fix1 to replaceable and replace it with Fix3,
>
> > This hybrid model ensures that irrelevant Fixes remain unaffected
> > during replacements.
>
> It makes some some now. But IMHO, it is not as easy as it looks.
> The complexity is in details.
>
> > >
> > > Which fix will be handled by livepatches installed in parallel?
> > > Which fix will be handled by atomic replace?
> > > How would you keep it consistent?
> > >
> > > How would it work when there are hundreds of fixes and thousands
> > > of livepatched functions?
> >
> > The key point is that if a new Fix modifies a function already changed
> > by previous Fixes, all the affected old Fixes should be set to
> > replaceable, merged into the new Fix, and then the old Fixes should be
> > replaced with the new one.
>
> As I tried to explain above. This might be hard to use in practice.
>
> We would either need to enforce loading all livepatches in the right
> order. It might be hard to make it user friendly.
>
> Or it would need a lot of extra code which would ensure that only
> compatible livepatches can be loaded.

That=E2=80=99s related to the configuration. If you decide to use it, you
should familiarize yourself with the best practices. Once you
understand those, it becomes much simpler and less complex.

BTW, based on my experience, the likelihood of overlapping between two
livepatches is very low in real production environments. I haven=E2=80=99t
encountered that case so far in our production servers.

--=20
Regards
Yafang

