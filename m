Return-Path: <live-patching+bounces-1137-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BCFA2D36B
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 04:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7B253A7619
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 03:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C8C15442A;
	Sat,  8 Feb 2025 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVabV/Cl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3765F148304;
	Sat,  8 Feb 2025 03:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738984145; cv=none; b=J6M/C3jxRGl7zD2/SHFnipg/uz5T4+qZYFhzBkiE0BGclqvlYUOBgc/odpZ8UbviqRKOhi864lkP5S1bYloPITjNewvjWV4gTAbESwe9EXLwx0v8+ieIf41QyjDnB/z8xUW/KWaWGVNiE0v6k5uwxNIPChAnRUi2d+EPL1Ebkkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738984145; c=relaxed/simple;
	bh=ofDvLGx7sq+kInFYWlX8yE60Q+Mgm9OuU3FUILJQnk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/Kphg1iQUu1P3Sq94VwIeMJHosmrGlj6dvHuntXjCNTP1y/U1Qe4TkZKrbdbCC3FxRyJr6hFIYk+YAoawmW5mhToANEGgrd8Cv4r4ubuVQusvJfH7kVr4gsA9O17pNOdgIXfu9O6AT56twYE+zAzDtO/+SmGDsPvjFh8Nlchfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVabV/Cl; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d8e8445219so20585416d6.0;
        Fri, 07 Feb 2025 19:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738984143; x=1739588943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9U76cEBfI1UHtV6D6Vz28mrAYWaz3j1rHldFxs84ES0=;
        b=jVabV/Clk7Mxz626CYiZXQJD8l6dT2l35O/dCxXooyH6VYMYQJDwECfJDWMYFE4aQp
         l1c0/Y7Ov6UA8dpMxK6z3ZyLO2+mHV/jBEGEbsVtQSkocy4gUHPFftKlMP7zGy8fRy1c
         6XwlTVOGnCLEuvpNDDSfMo09q1WRZRV8wsB/A5j07HmQYBi2WEbu4cUTn/c90/c2KVOb
         qu+qzDyrK6qFaznIeWzxlOc+Jk/eAlmfY2WNtSMpHT8cd0zKxPJBNZks6613ZgCe+DlO
         ucLPDUsMMgYvykVWG6PUmAV7QRpMQpogdewCRzW9lCTlXqaIlMLdL9lrktQY3f5NwzCY
         DgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738984143; x=1739588943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9U76cEBfI1UHtV6D6Vz28mrAYWaz3j1rHldFxs84ES0=;
        b=rypbqeiAxWIS8u3ycx3dL9JYhVax7kSJo9Ol8Ut29vNGh74Kh0sfBZF6YfjtQacW41
         TMy3KFDkWYnuZeU/cc5odk550EeZVmkSJq+GcvTsuVulyzP8Z5jlNfiwTPpPfoisRJg6
         6nNVdzG1Zt68ozZJP0X4fexypjtOJfJWlSpzUSo1alkV8bGkANQ34jc2jrOjEWb2PtMi
         7QGSzSqPg0ybo2zQasciXd5cGqkM9YIJzWDSmUAsszYPi0jH1W4OT5HiVxkB9rT0TcwZ
         iwsffYqt54zM+2TWMUiWrl20Oqm/DWzJPYFJVVfxE32plXz0Gl7xfB8WMbgNrcLqCksb
         FpoA==
X-Forwarded-Encrypted: i=1; AJvYcCX85bTstZ447EmCBKpjZSajFUcSPTFNKq0hDPs7u6R2yr4Wilv4WF4CQvMul4iqUjVoSuMAf2jBgGy1Sag=@vger.kernel.org, AJvYcCXIhijhQCTWYW7ljX11C921rc3W9ikiCX8OElAMJDn5vpgQ76HhNwzZe0L4QPW/3adp9s9+yF59Hczw9YL/xw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy860mrC/CFSZprI0wxhGLakXF09xIwXa28Xvl8nr6XzopeJl1M
	gXdpgQEYZ2p56+pf1nGS9mDBRDsK1cG830G1M4a/DRV/8E4TEPQWP3RZPx85AzzYkWYEoFStkIW
	YIuFrfdkZ/vMpN6f+5hdh8h1banA=
X-Gm-Gg: ASbGncsm+kZ2GnM68D43QXHMs/2DuqzK3sI4UOvGM0nB8kzc+FrZihVl2qyevv3yZ5t
	CYj5OVMpZmYC9sh9HUTSW/h3NzZs5qFrrhObA5kcF0L7ua4kwuuKBP4rq1cd4RgDrCx+a6ZhY+k
	M=
X-Google-Smtp-Source: AGHT+IGYTELQ4m72h1+I1k3Az7uCWDdg+2uPxfeyIkL01EELYsAIoYxN6UjTRarLN0ejtUj2YXUdbq9FcOG1/2WCnwg=
X-Received: by 2002:a05:6214:76f:b0:6d8:9e16:d07e with SMTP id
 6a1803df08f44-6e4455bafabmr83006706d6.4.1738984142950; Fri, 07 Feb 2025
 19:09:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz> <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
 <Z6IUcbeCSAzlZEGP@pathway.suse.cz> <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>
 <Z6OLvQ6KlVeuOkoO@pathway.suse.cz> <CALOAHbCJRce9-VYNgUO5szU4kMSktXyvkY9+ZFX_kyVXeoQ1ig@mail.gmail.com>
 <Z6YRhjQA4wkBxP0v@pathway.suse.cz>
In-Reply-To: <Z6YRhjQA4wkBxP0v@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Feb 2025 11:08:18 +0800
X-Gm-Features: AWEUYZlDX5gC0CCZMyWE0H1RoBN-tQtx183movD8tDQ31GMCClbyt3eXWRlSa34
Message-ID: <CALOAHbBiio2H5MiAA+QvUeZNKJXuNs0f9GRqf9cCv+N+fZnx+w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 9:58=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Thu 2025-02-06 10:35:11, Yafang Shao wrote:
> > On Thu, Feb 6, 2025 at 12:03=E2=80=AFAM Petr Mladek <pmladek@suse.com> =
wrote:
> > >
> > > On Wed 2025-02-05 10:54:47, Yafang Shao wrote:
> > > > On Tue, Feb 4, 2025 at 9:21=E2=80=AFPM Petr Mladek <pmladek@suse.co=
m> wrote:
> > > > >
> > > > > On Mon 2025-01-27 23:34:50, Yafang Shao wrote:
>
> I am not sure if you still would want the hybrid model.

I believe the ability to selectively replace specific livepatches will
be a highly valuable feature.

> It is possible that the timeout in klp_try_complete_transition()
> would remove the hardlockup watchdog warnings, see
> https://lore.kernel.org/r/Z6Tmqro6CSm0h-E3@pathway.suse.cz
>
> I reply to this mail just for record because there were some
> unanswered questions...
>
> > > > To clarify the hybrid model, I'll illustrate it with the following =
Fixes:
> > > >
> > > > Fix1 livepatches: funcA
> > > > Fix2  livepatches: funcC
> > > > Fix3 livepatches: funcA, funcB
> > >
> > > How does look the livepatched FuncA here?
> > > Does it contain changes only for Fix3?
> > > Or is it cummulative livepatches_funA includes both Fix1 + Fix3?
> >
> > It is cumulative livepatches_funA includes both Fix1 + Fix3.
>
> It makes sense.
>
> I have missed this in the previous mail. I see it there now (after
> re-reading). But trick was somehow encrypted in long sentences.
>
>
> > > > Fix4  livepatches: funcD
> > > > Fix5 livepatches: funcB
> > > >
> > > > Each FixN represents a single /sys/kernel/livepatch/FixN.
> > > > By default, all Fixes are set to non-replaceable.
> > > >
> > > > Step-by-step process:
> > > > 1. Loading Fix1
> > > >    Loaded Fixes: Fix1
> > > > 2. Loading Fix2
> > > >    Loaded Fixes: Fix1 Fix2
> > > > 3. Loading Fix3
> > > >     Before loading, set Fix1 to replaceable and replace it with Fix=
3,
> > > > which is a cumulative patch of Fix1 and Fix3.
> > >
> > > Who will modify the "replaceable" flag of "Fix1"? Userspace or kernel=
?
> >
> > Userspace scripts. Modify it before loading a new one.
>
> This is one mine concern. Such a usespace script would be
> more complex for the the hybrid model then for cumulative livepatches.
> Any user of the hybrid model would have their own scripts
> and eventual bugs.

In the old model, we maintained a large script to deploy individual
livepatches. In the atomic replace model, we maintain another complex
script to deploy cumulative livepatches. We always end up creating our
own scripts to adapt to the complexities of the production
environment.

>
> Anyway, the more possibilities there more ways to break things
> and the more complicated is to debug eventual problems.

We still have some servers running the old 4.19 kernel, with over 20
livepatches deployed. These livepatches are managed using the old
model since the atomic replace model isn't supported yet. The
maintenance of these livepatches has been running smoothly with user
scripts. Things would be much simpler if we could rely on user scripts
to handle this process.

>
> If anyone would still like the hybrid model then I would like
> to enforce some safe behavior from the kernel. I mean to do
> as much as possible in the common (kernel) code.
>
> I have the following ideas:
>
>   1. Allow to load a livepatch with .replace enabled only when
>      all conflicting[*] livepatches are allowed to be replaced.

Makes sense.

>
>   2. Automatically replace all conflicting[*] livepatches.

Makes sense.

>
>   3. Allow to define a list of to-be-replaced livepatches
>      into struct patch.

Seems like a great idea.

>
>
> The 1st or 2nd idea would make the hybrid model more safe.
>
> The 2nd idea would even work without the .replaceable flag.
>
> The 3rd idea would allow to replace even non-conflicting[*]
> patches.
>
> [*] I would define that two livepatches are "conflicting" when
>     at least one function is modified by both of them. e.g.
>
>         + Patch1: funcA, funcB   \
>         + Patch2: funcC, funcD   - non-conflicting
>
>         + Patch1: funcA, funcB          \
>         + Patch2:        funcB, funcC   - conflicting
>
>     Or a bit weaker definition. Two patches are "conflicting"
>     when the new livepatch provides only partial replacement
>     for already livepatch functions, .e.g.
>
>         + Patch1: funcA, funcB                \
>         + Patch2:               funcC, funcD  - non-conflicting anyway
>
>         + Patch1: funcA, funcB          - Patch1 can't replace Patch2 (co=
nflict)
>         + Patch2: funcA, funcB, funcC   - Patch2 can replace Patch1 (no c=
onflict)
>
>         + Patch1: funcA, funcB          \
>         + Patch2:        funcB, funcC   - conflicting anyway
>
>
> Especially, the automatic replacement of conflicting patches might
> make the hybrid model safe and easier to use. And it would resolve
> most of my fears with this approach.

Many thanks for your suggestion. It=E2=80=99s been incredibly helpful. I=E2=
=80=99ll
definitely give it some thought.

--=20
Regards
Yafang

