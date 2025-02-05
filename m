Return-Path: <live-patching+bounces-1113-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 373AFA28235
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 03:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C1A43A06FC
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 02:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB0F2116EB;
	Wed,  5 Feb 2025 02:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiubrqWP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C324425A65E;
	Wed,  5 Feb 2025 02:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724126; cv=none; b=ofW1ajTsQ9RFBA7bg5ht+7kN08zwvUbjyeAYjMwt3kUFSOi9LxlHquKmXASvF/kW7T2vT/o0oShj4QaYxQMBGNzqV3vOrd6//LMnDJR+KQtOccsg1mGS6i8D4lG0fltD2pUljjvvQ0bqcfMaWqN5EMTc5PTfCcTzyGavqdEqExo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724126; c=relaxed/simple;
	bh=/V/Zjz8kIHTNtZepNSRxcBEK1+xm8jlcLRBoKPJwAJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ap8Upq+1XKH62RvLYp0RbIzLVj39yTtvpydhwJBgZQH3+N0YqdeiHITdmDfmphdkXn2bir3+TsgQbPPRUk7+21zbqce5XxDvLCWPyjsICX4mnmp4Kay5+zf4iKDvkVM4CEbKxBz0dQha+JmR3ELdEDZlWivf0MADjlxg9Ulm1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BiubrqWP; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7b6e9586b82so544900085a.1;
        Tue, 04 Feb 2025 18:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738724123; x=1739328923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PtLKwDOyG5ssKF/2Ji6TsEWHluRVJXZzIL3UD18keGw=;
        b=BiubrqWPbbOGJtGTga40E8q7ZE7Az24uFQF0RBuqOh4pZUFjKhBSHUvumDgUrTcwkb
         LP9fIDQ6Vx+TyhiF/0NBweoo3au5u1c2ihVBPn6nHp3iNrRTcibrTU4aekt1M36Mhzj4
         aT+jexvlDCpybbRUeRPob41mJVLf7RMAWxsFtjzjQdma+QuESQqw9HP6PsnQFVuON9Fk
         ih+T4MxMFhuv+XaD7Pcj0yZ9jTrNBzYd8EvXh1Aq0tcpNVVFfDchSlLDI5k3n64GVmv/
         1rr7cqZuVWLtKFrWuCbZ5AbF803z8VKb73d87SPpAmyr1tFuGqubBxIbFhsfzFjaCIOn
         /q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738724123; x=1739328923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtLKwDOyG5ssKF/2Ji6TsEWHluRVJXZzIL3UD18keGw=;
        b=eUSCfez/JNqpe0FNCFM9ImZZrcIf1AdTTHm8BNOqZg3FK+0XdIKjQHoDdca0WPdAQu
         K9xbITuFQrMAe7m3Oj16uTcPs5TnXSY9/NdpDM6ef0Y5EpCKqYtXU/RP65gQFGqGyJ/R
         QMa1P5ujnEU7T+BQ/wwbV4vqMqRfpYr7FKDLg7YXuLXrISEh/74eTzVWTQbh432Frp9y
         ybGN48+GDzEXID8pRH2rZPt9DwwrvSNpTiMbfnVGflyK9hxJH12rRQivXWnuB0fJkR+Z
         8VSfdhcW6kaIQuinwpJ8zA31awfaKHIlGU0lFK2VnCTY2LmVNvUNlteHJMnGopBhEIFx
         TJtg==
X-Forwarded-Encrypted: i=1; AJvYcCWptWv+Xkk7DqErhW9qkCE7bMVmpY4Yn2/dRztZPiRaxoMWnf1PMiQXBndmZFBGhAimdQpKw5Hm2+/B7brKFA==@vger.kernel.org, AJvYcCXOUS5PQixQAe6RR2fCtPrba5TRF/Q2U5NaA5v+sHGm3fJ5HfQ5HY90Ef2P90YidywnI3W9XiRBYqfIGU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWhPm7/yQcC67NelCwprZyoEXcU68R8tAEwImcd/KWglImgSgh
	7Mso0PedrlonuAdRCSgpcVWYTcvyxTtWu2YIU2SagvRDzBIWzZZtZ8/ZBPJKBSvapC1nlUrTsDm
	az7oUBZEZ3H1E2T+K8tmMXjCnf8E=
X-Gm-Gg: ASbGncsTgc1QrFubxWy0wkCEMZ3H3z1Ut5gj9dfwTY6JJ8yVY4nHzwqq3oTOWzNbyGM
	qn4v6FVVsF+tNULozvCur4dnhrbcMLm8T2A8O5YKZssfS97+oQnkMTiAbHj2z8w7iy3SXHhAcps
	8=
X-Google-Smtp-Source: AGHT+IHGCL4ookUzuGz8uWVm/jjfExcvqWstIF16/t1IbqN06yPmRlvLLgmV/lkGx91z+Pey2btDKbYBashYhwVdKg8=
X-Received: by 2002:a05:620a:410e:b0:7b6:f34b:cdd2 with SMTP id
 af79cd13be357-7c03a04b810mr197896485a.53.1738724123511; Tue, 04 Feb 2025
 18:55:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz> <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
 <Z6IUcbeCSAzlZEGP@pathway.suse.cz>
In-Reply-To: <Z6IUcbeCSAzlZEGP@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 5 Feb 2025 10:54:47 +0800
X-Gm-Features: AWEUYZnC4hhtTeL3gZNIEwfBI1_Hl4vmuI4VMUT9NQO--gGLqdOyyHp3CE42e_U
Message-ID: <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 9:21=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Mon 2025-01-27 23:34:50, Yafang Shao wrote:
> > On Mon, Jan 27, 2025 at 10:31=E2=80=AFPM Petr Mladek <pmladek@suse.com>=
 wrote:
> > >
> > > On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> > > > The atomic replace livepatch mechanism was introduced to handle sce=
narios
> > > > where we want to unload a specific livepatch without unloading othe=
rs.
> > > > However, its current implementation has significant shortcomings, m=
aking
> > > > it less than ideal in practice. Below are the key downsides:
> > >
> > > [...]
> > >
> > > > In the hybrid mode:
> > > >
> > > > - Specific livepatches can be marked as "non-replaceable" to ensure=
 they
> > > >   remain active and unaffected during replacements.
> > > >
> > > > - Other livepatches can be marked as "replaceable," allowing target=
ed
> > > >   replacements of only those patches.
> > > >
> > > > This selective approach would reduce unnecessary transitions, lower=
 the
> > > > risk of temporary patch loss, and mitigate performance issues durin=
g
> > > > livepatch replacement.
> > > >
> > > > --- a/kernel/livepatch/core.c
> > > > +++ b/kernel/livepatch/core.c
> > > > @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch=
)
> > > >               klp_for_each_object(old_patch, old_obj) {
> > > >                       int err;
> > > >
> > > > +                     if (!old_patch->replaceable)
> > > > +                             continue;
> > >
> > > This is one example where things might get very complicated.
> >
> > Why does this example even exist in the first place?
> > If hybrid mode is enabled, this scenario could have been avoided entire=
ly.
>

You have many questions, but it seems you haven=E2=80=99t taken the time to=
 read even
a single line of this patchset. I=E2=80=99ll try to address them to save yo=
u some time.

> How exactly this scenario could be avoided, please?
>
> In the real life, livepatches are used to fix many bugs.
> And every bug is fixed by livepatching several functions.
>
> Fix1 livepatches: funcA
> Fix2 livepatches: funcA, funcB
> Fix3 livepatches: funcB
>
> How would you handle this with the hybrid model?

In your scenario, each Fix will replace the applied livepatches, so
they must be set to replaceable.
To clarify the hybrid model, I'll illustrate it with the following Fixes:

Fix1 livepatches: funcA
Fix2  livepatches: funcC
Fix3 livepatches: funcA, funcB
Fix4  livepatches: funcD
Fix5 livepatches: funcB

Each FixN represents a single /sys/kernel/livepatch/FixN.
By default, all Fixes are set to non-replaceable.

Step-by-step process:
1. Loading Fix1
   Loaded Fixes: Fix1
2. Loading Fix2
   Loaded Fixes: Fix1 Fix2
3. Loading Fix3
    Before loading, set Fix1 to replaceable and replace it with Fix3,
which is a cumulative patch of Fix1 and Fix3.
    Loaded Fixes:  Fix2 Fix3
4. Loading Fix4
    Loaded Fixes:  Fix2 Fix3 Fix4
5. Loading Fix5
    Similar to Step 3, set Fix3 to replaceable and replace it with Fix5.
    Loaded Fixes:  Fix2 Fix4 Fix5

This hybrid model ensures that irrelevant Fixes remain unaffected
during replacements.

>
> Which fix will be handled by livepatches installed in parallel?
> Which fix will be handled by atomic replace?
> How would you keep it consistent?
>
> How would it work when there are hundreds of fixes and thousands
> of livepatched functions?

The key point is that if a new Fix modifies a function already changed
by previous Fixes, all the affected old Fixes should be set to
replaceable, merged into the new Fix, and then the old Fixes should be
replaced with the new one.

>
> Where exactly is the advantage of the hybrid model?

That can be seen as a form of "deferred replacement"=E2=80=94in other words=
,
only replacing the old Fixes when absolutely necessary. This approach
can significantly reduce unnecessary work.

>
> > >
> > > The same function might be livepatched by more livepatches, see
> > > ops->func_stack. For example, let's have funcA and three livepatches:
> > > a
> > >   + lp1:
> > >         .replace =3D false,
> > >         .non-replace =3D true,
> > >         .func =3D {
> > >                         .old_name =3D "funcA",
> > >                         .new_func =3D lp1_funcA,
> > >                 }, { }
> > >
> > >   + lp2:
> > >         .replace =3D false,
> > >         .non-replace =3D false,
> > >         .func =3D {
> > >                         .old_name =3D "funcA",
> > >                         .new_func =3D lp2_funcA,
> > >                 },{
> > >                         .old_name =3D "funcB",
> > >                         .new_func =3D lp2_funcB,
> > >                 }, { }
> > >
> > >
> > >   + lp3:
> > >         .replace =3D true,
> > >         .non-replace =3D false,
> > >         .func =3D {
> > >                         .old_name =3D "funcB",
> > >                         .new_func =3D lp3_funcB,
> > >                 }, { }
> > >
> > >
> > > Now, apply lp1:
> > >
> > >       + funcA() gets redirected to lp1_funcA()
> > >
> > > Then, apply lp2
> > >
> > >       + funcA() gets redirected to lp2_funcA()
> > >
> > > Finally, apply lp3:
> > >
> > >       + The proposed code would add "nop()" for
> > >         funcA() because it exists in lp2 and does not exist in lp3.
> > >
> > >       + funcA() will get redirected to the original code
> > >         because of the nop() during transition
> > >
> > >       + nop() will get removed in klp_complete_transition() and
> > >         funcA() will get suddenly redirected to lp1_funcA()
> > >         because it will still be on ops->func_stack even
> > >         after the "nop" and lp2_funcA() gets removed.
> > >
> > >            =3D> The entire system will start using another funcA
> > >               implementation at some random time
> > >
> > >            =3D> this would violate the consistency model
> > >
> > >
> > > The proper solution might be tricky:
> > >
> > > 1. We would need to detect this situation and do _not_ add
> > >    the "nop" for lp3 and funcA().
> > >
> > > 2. We would need a more complicate code for handling the task states.
> > >
> > >    klp_update_patch_state() sets task->patch_state using
> > >    the global "klp_target_state". But in the above example,
> > >    when enabling lp3:
> > >
> > >     + funcA would need to get transitioned _backward_:
> > >          KLP_TRANSITION_PATCHED -> KLP_TRANSITION_UNPATCHED
> > >       , so that it goes on ops->func_stack:
> > >          lp2_funcA -> lp1->funcA
> > >
> > >    while:
> > >
> > >     + funcA would need to get transitioned forward:
> > >          KLP_TRANSITION_UNPATCHED -> KLP_TRANSITION_PATCHED
> > >       , so that it goes on ops->func_stack:
> > >          lp2_funcB -> lp3->funcB
> > >
> > >
> > > =3D> the hybrid mode would complicate the life for both livepatch
> > >    creators/maintainers and kernel code developers/maintainers.
> > >
> >
> > I don=E2=80=99t believe they should be held responsible for poor
> > configurations. These settings could have been avoided from the start.
> > There are countless tunable knobs in the system=E2=80=94should we try t=
o
> > accommodate every possible combination? No, that=E2=80=99s not how syst=
ems are
> > designed to operate. Instead, we should identify and follow best
> > practices to ensure optimal functionality.
>
> I am sorry but I do not understand the above paragraph at all.
>
> Livepatches modify functions.
> How is it related to system configuration or tunable knobs?

/sys/kernel/livepatch/FixN/replaceable is a tunable knob.

+static struct kobj_attribute replaceable_kobj_attr =3D __ATTR_RW(replaceab=
le);

> What best practices are you talking, please?

As mentioned earlier.

--
Regards
Yafang

