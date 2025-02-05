Return-Path: <live-patching+bounces-1117-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5237EA295AB
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 17:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5192B1886007
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 16:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3EB18CC1C;
	Wed,  5 Feb 2025 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IBf4Ow/l"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CA017C21C
	for <live-patching@vger.kernel.org>; Wed,  5 Feb 2025 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771398; cv=none; b=GQyqtiJj5hvxXpDphgGS1QPtzPRVp+ipBZND2pnPJyFSoC7SOw5lXU5yw3pSvT2gEMJVHNZIWia9dPsfh4uOtb+3tets+sm4rixsK496p7tjb/Ib9W+aOPiJf578D01j7VX51HiEg3VSntyEkQqUtr0uvg/rLuS6sIsZUu7E3xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771398; c=relaxed/simple;
	bh=/I9bodOOum1qi+yw5e6vSTcQvXL2vgNuqh105IqCHF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoMs0P3I36IY/ycTU3uSZAANpVWjltUzLNbuKVJYaH9yM0Uhhr0xfQoHL5SQINSY4eBITgdoRq1d+PTaJ98oFUy11LrZeuyaCD3s+bVLx0AEtjcYCy8AIj0NNmGV7FtEut8pt7i4QFI3R+7M19mXTYIDO8gm5F4OtSh6NnLfOug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IBf4Ow/l; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaedd529ba1so924799866b.1
        for <live-patching@vger.kernel.org>; Wed, 05 Feb 2025 08:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738771394; x=1739376194; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b2Dnyw/RxLmsfabwG1syRfowM1VSlsvP6Um0OBGBw+A=;
        b=IBf4Ow/lkljdyhLtk8ix1sZRwFMxOuqGo2ytbff7R+7WfpY5pz4hPGqcAWq5kXTzEO
         DSefpq0prRTaGNWtZQHgl/EwqbVv0kzS+9i7mW5JIcJ3rlL0KYn+deUNiug9OrMv8Jsl
         kk45290zKdV2SyDsKOK/32YJB1hItbEgrP4JcnqtaWpN8rUF4MkM0N9jlgrnDivUCKMw
         WQs0RUnc24HkMCYYLmGExvmGePsIfU7VdJjRnXUuGDbrEjY/EkKrXm2+WYjAhiOgqgJb
         3tcop2csJAni94vye/dPv7Rz/nV7Umt3sqHgwdw09P1lzeDMAcQLz9nKIwHZUO2oAr40
         RLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738771394; x=1739376194;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b2Dnyw/RxLmsfabwG1syRfowM1VSlsvP6Um0OBGBw+A=;
        b=gPdGcLq1HtpSrfLfJWh9kwwtXz+TYv6NzouxDBudRLdJ9EwdQS1GrCqk+jq1j8u/E5
         vjcBr3MfwGBmJvWT68PllXu2AKJPPBj4CMWZ8Ah3xiXfiCoK3+eiFEvWF7lFFzH4BHP8
         2Tnvm0DfLKMMdOh7AneW/TLavAIoWaG1O5nqiZG81QM+mK/bALRq7BAiJ7RY8VYzK4QV
         /gO5ua3MCR8l9fIlVq52eJzvgrYfmqbQauguWvt85AtlzISkqBlruzouPru8MGLvCKfG
         PH62qa3Hz/ubkOOy3Fnx6sD9MMxk3WgG1HX5UJq8MdHakNcMVkLTgz/NjqGn14Bp0kuA
         pLJA==
X-Forwarded-Encrypted: i=1; AJvYcCVL2Lh3FTc22qCyQXnnoc9gbJAJSoSwlGOaNro3iyMrzWsBlFUdCXLLuWQnX34e4Qy7BtjF1BGmsvMueAbz@vger.kernel.org
X-Gm-Message-State: AOJu0YxOfjYROce63LXHoF0UORx9+M+u0iZvx2eCeJDkWz/otG/C5TlO
	KSszmDw1trxXoZSzi2Nqj4RECgNT905ZDmussLdywtM0K4bDRigCYIwMg6Wq26Q=
X-Gm-Gg: ASbGnctRVZjmPW10r1mY5s79kYgHH79OaySipNR/+uu8cNugqF13OaNCGNcOHaMVVsk
	QWJPr5k67CHvFf3mzGgHu1c/nZIemKcPAMjyRdmaLgUhz894HnSylsulpCxD3jRf2zgGssXVnQ/
	5oXeMDFMHk4L/2i/LRlKitj81xM2rdI6OVBF0zjxgplItbwZJdu4y7kXdgi5Sh/Kw3MHoGxD/TZ
	w7pfeSyTAX/TAOctJYfSyE6Bo+VRVwAc8n+oCoBdHxGH7XLetaJeKQvJG2naYw4e43iypnkDl7o
	PcDBj0h/dWVoTCJjHA==
X-Google-Smtp-Source: AGHT+IEhzhth1iRS/5lDkEkc+uffYLvkJ/xTNnYqRTVOlBAddvX5E4aEuVGV7RFDknR6c/05kShn3Q==
X-Received: by 2002:a05:6402:3216:b0:5db:e7eb:1b4c with SMTP id 4fb4d7f45d1cf-5dcdb71277bmr10890874a12.10.1738771392978;
        Wed, 05 Feb 2025 08:03:12 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc72405806sm11560551a12.36.2025.02.05.08.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 08:03:12 -0800 (PST)
Date: Wed, 5 Feb 2025 17:03:09 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <Z6OLvQ6KlVeuOkoO@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
 <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
 <Z6IUcbeCSAzlZEGP@pathway.suse.cz>
 <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>

On Wed 2025-02-05 10:54:47, Yafang Shao wrote:
> On Tue, Feb 4, 2025 at 9:21 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Mon 2025-01-27 23:34:50, Yafang Shao wrote:
> > > On Mon, Jan 27, 2025 at 10:31 PM Petr Mladek <pmladek@suse.com> wrote:
> > > >
> > > > On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> > > > > The atomic replace livepatch mechanism was introduced to handle scenarios
> > > > > where we want to unload a specific livepatch without unloading others.
> > > > > However, its current implementation has significant shortcomings, making
> > > > > it less than ideal in practice. Below are the key downsides:
> > > >
> > > > [...]
> > > >
> > > > > In the hybrid mode:
> > > > >
> > > > > - Specific livepatches can be marked as "non-replaceable" to ensure they
> > > > >   remain active and unaffected during replacements.
> > > > >
> > > > > - Other livepatches can be marked as "replaceable," allowing targeted
> > > > >   replacements of only those patches.
> > > > >
> > > > > This selective approach would reduce unnecessary transitions, lower the
> > > > > risk of temporary patch loss, and mitigate performance issues during
> > > > > livepatch replacement.
> > > > >
> > > > > --- a/kernel/livepatch/core.c
> > > > > +++ b/kernel/livepatch/core.c
> > > > > @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch)
> > > > >               klp_for_each_object(old_patch, old_obj) {
> > > > >                       int err;
> > > > >
> > > > > +                     if (!old_patch->replaceable)
> > > > > +                             continue;
> > > >
> > > > This is one example where things might get very complicated.
> > >
> > > Why does this example even exist in the first place?
> > > If hybrid mode is enabled, this scenario could have been avoided entirely.
> >
> 
> You have many questions, but it seems you haven’t taken the time to read even
> a single line of this patchset. I’ll try to address them to save you some time.

What?

> > How exactly this scenario could be avoided, please?
> >
> > In the real life, livepatches are used to fix many bugs.
> > And every bug is fixed by livepatching several functions.
> >
> > Fix1 livepatches: funcA
> > Fix2 livepatches: funcA, funcB
> > Fix3 livepatches: funcB
> >
> > How would you handle this with the hybrid model?
> 
> In your scenario, each Fix will replace the applied livepatches, so
> they must be set to replaceable.
> To clarify the hybrid model, I'll illustrate it with the following Fixes:
> 
> Fix1 livepatches: funcA
> Fix2  livepatches: funcC
> Fix3 livepatches: funcA, funcB

How does look the livepatched FuncA here?
Does it contain changes only for Fix3?
Or is it cummulative livepatches_funA includes both Fix1 + Fix3?

> Fix4  livepatches: funcD
> Fix5 livepatches: funcB
> 
> Each FixN represents a single /sys/kernel/livepatch/FixN.
> By default, all Fixes are set to non-replaceable.
> 
> Step-by-step process:
> 1. Loading Fix1
>    Loaded Fixes: Fix1
> 2. Loading Fix2
>    Loaded Fixes: Fix1 Fix2
> 3. Loading Fix3
>     Before loading, set Fix1 to replaceable and replace it with Fix3,
> which is a cumulative patch of Fix1 and Fix3.

Who will modify the "replaceable" flag of "Fix1"? Userspace or kernel?

How the livepatch modules would get installed/removed to/from the
filesystem?

We (SUSE) distribute the livepatches using RPM packages. Every new
version of the livepatch module is packaged in a RPM package with
the same name and higher version. A post install script loads
the module into the kernel and removes disabled livepatch modules.

The package update causes that the new version of the livepatch module
is enabled and the old version is removed. And also the old version
of the module and is removed from the filesystem together with the old
version of the RPM package.

This matches the behavior of the atomic replace. There is always only
one version of the livepatch RPM package installed and only one
livepatch module loaded/enabled. And when it works correcly then
the version of the installed package matches the version of the loaded
livepatch module.

This might be hard to achieve with the hybrid model. Every livepatch
module would need to be packaged in a separate (different name)
RPM package. And some userspace service would need to clean up both
kernel modules and livepatch RPM packages (remove the unused ones).

This might add a lot of extra complexity.

>     Loaded Fixes:  Fix2 Fix3
> 4. Loading Fix4
>     Loaded Fixes:  Fix2 Fix3 Fix4
> 5. Loading Fix5
>     Similar to Step 3, set Fix3 to replaceable and replace it with Fix5.
>     Loaded Fixes:  Fix2 Fix4 Fix5

Let's imagine another situation:

Fix1 livepatches: funcA, funcB
Fix2  livepatches: funcB, funcC
Fix3 livepatches: funcA, funcC

Variant A:

 1. Loading Fix1
    Loaded Fixes: Fix1
    In use:: funcA_fix1, funcB_fix1

 2. Loading Fix2
    Loaded Fixes: Fix1 Fix2
    In use: funcA_fix1, funcB_fix2, funcC_fix2

 3. Loading Fix3
    Loaded Fixes: Fix2 Fix3
    In use: funcA_fix3, funcB_fix2, funcC_fix3

    This will be correct only when:

	+ funcA_fix3 contains both changes from Fix1 and Fix3
	+ funcC_fix3 contains both changes from Fix2 and Fix3


Variant B:

 1. Loading Fix1
    Loaded Fixes: Fix1
    In use:: funcA_fix1, funcB_fix1

 2. Loading Fix2 (fails from some reason or is skipped)
    Loaded Fixes: Fix1
    In use:: funcA_fix1, funcB_fix1

 3. Loading Fix3
    Loaded Fixes: Fix1 Fix2
    In use: funcA_fix3, funcB_fix1, funcC_fix3

    This will be correct only when:

	+ funcA_fix3 contains both changes from Fix1 and Fix3
	    and stays funcB_fix1 is compatible with funcA_fix3
	+ funcC_fix3 contains changes only from Fix3,
	    it must be compatible with the original funcB because

I want to say that this would work only when all livepatches
are loaded in the right order. Otherwise, it might break
the system.

How do you want to ensure this?

Is it really that easy?

> 3. Loading Fix3
>     Before loading, set Fix1 to replaceable and replace it with Fix3,

> This hybrid model ensures that irrelevant Fixes remain unaffected
> during replacements.

It makes some some now. But IMHO, it is not as easy as it looks.
The complexity is in details.

> >
> > Which fix will be handled by livepatches installed in parallel?
> > Which fix will be handled by atomic replace?
> > How would you keep it consistent?
> >
> > How would it work when there are hundreds of fixes and thousands
> > of livepatched functions?
> 
> The key point is that if a new Fix modifies a function already changed
> by previous Fixes, all the affected old Fixes should be set to
> replaceable, merged into the new Fix, and then the old Fixes should be
> replaced with the new one.

As I tried to explain above. This might be hard to use in practice.

We would either need to enforce loading all livepatches in the right
order. It might be hard to make it user friendly.

Or it would need a lot of extra code which would ensure that only
compatible livepatches can be loaded.

Best Regards,
Petr

