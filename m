Return-Path: <live-patching+bounces-1103-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8665EA25636
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 10:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8CD33A99F7
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 09:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67E71FF7DA;
	Mon,  3 Feb 2025 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWmu7Vzk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEBE1FF7A1;
	Mon,  3 Feb 2025 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738575931; cv=none; b=FoE/L77Hm2XbN6VV2WZdzc1OItiIPsDhNxhl+8tqur6/librOw43ZWi/dzLqlGN84bODs0BBVHk3QUyzM/xNZiy8i1frBXNc85nILqKkNoJzdKVRVUs9WzyvTojJ7yMxynroVJ/MC4HJXmNFcX5ZbQZxCgHkxrvJBmDtLQVIk4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738575931; c=relaxed/simple;
	bh=fIgcGBvqDbLq7kS0K19wxfiPZ79yRpz1C2hfr9gQqoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SsV9UT64tkWg+Jla8KmONuqVy1pEmhckhxnis8kMT9V3Hqu/krPWC6yREjo6PA+cBuVz4BZf0Echb4DBIIGOp/ICyxfpfzptmaBFOF1Oi/37IkRoLMi2nOrgwBIBxVapt4jS4RtBMIqx2xR328qpVPPYKTmJ5MfWjf21A2709/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWmu7Vzk; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6dd5c544813so42950246d6.1;
        Mon, 03 Feb 2025 01:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738575929; x=1739180729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yI5g0smySPHHeVACX7JhK2ZoaTHZN0JQLDEIzqW27Mg=;
        b=HWmu7VzkUk8pmA+qNa/Je0OsBBpX1C7823v52GwvU6nR3VRHPE6bplgMygKx1LggQJ
         lMR0jZjzySOptUiBmAFw658Nwsqjrb6mFJ7O8UNBW1t5htNq8z4k82E793nvKwS+jNbF
         LC2PCSIhj0ADc4Gif+5PRDNSeN1CwMmslPsr5DJlhRCX0p8NvF5sGMKi/1sj2e9bB0cH
         cjIf5WlfaqeoNI6O6cemwUfFYSMpv2ERSuxEKLOqN5xZudP1FpgbMylYUKGvVQLEJVra
         H+J0ehAnDjj2+9FpsCQYyI1OQBqIFmWhoy+zijwnfPEfhbrWRq1DLiJHWTNoAF+hs5qV
         38Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738575929; x=1739180729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yI5g0smySPHHeVACX7JhK2ZoaTHZN0JQLDEIzqW27Mg=;
        b=ljGuoXmidsTUunNWoYaJA00Tk+23mLWlxvarXxNb6/sfkBP/Gbhoi2QddrQ1tmw+Xi
         FY2r7uqUr21626tm2/dwxuBjROFvcob4G3q7KLc+QPl/KsJ6UBGF0KDnMaSFgBj4gg5b
         l97NmS4H2c3Qvuw7NR1dW8RfBzu1hSsEygX/LtHK6aCzSQuK/airRZfjUnuF4F1hEBdR
         8hoob+DOB0G0YGqVujRiB77zhy323t1iineknkXTiPBldGJpAzYEkUVWMB91S1gOLzfX
         UTUjByIOaovcVABxeV70Rv1Myqgwp/70pAjNmyJO2s+x1U4BYKoXELZuKH3g/tvoyC46
         Xx3A==
X-Forwarded-Encrypted: i=1; AJvYcCU9BONob8/7RaQhCF84bNO2JfuiOCd9/XR8vUdThvecKagQLXHdp80mms3Cpgu8eBicrIWbkXoDdAlC1HAa2A==@vger.kernel.org, AJvYcCXtd8UOzSBTx+Avpka2hSg4tGmsvlu8mRVJsMhKjef1GEPjNn/nwNVZbLJfw98IeOo+rYw1ZGF/r9slfyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVVDDpJ8WqOFoWpsGwS9GrAaHmyWwYieUfj9ARejdMOQce6doI
	lk0i4uWbX76Ra05dXgZE/p/wo7pp96rF4VZ73M2YKk80BAv3FGQ57I2ufxsTn8VOUK8YH5DUnXG
	zeEFc15LJ+DF3c3eBknzUSogWWvo=
X-Gm-Gg: ASbGncsixFoKMnx6owF1Lp8nx4jrGj+OijG2wTzjKTEuAfxN9EPkaY2dTMiueJT7D+9
	5byl5r48dQzI8Fbf3johJuedQbVnrUVj33nRuT3Z9drr3apFbhnLF5lhQHZoGVmShGvJUXZ7Obo
	A=
X-Google-Smtp-Source: AGHT+IGvMyY5kE20lb9+gjNPiN+ok4bJSat72WlIS8jV/PsJPNHLlUf8lp/DCJcxYGgnhJ7QrxM5+XhiWUOVzLO2aUM=
X-Received: by 2002:ad4:5c63:0:b0:6d8:7ed4:3367 with SMTP id
 6a1803df08f44-6e243bfa9cbmr344740486d6.19.1738575928886; Mon, 03 Feb 2025
 01:45:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com> <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 3 Feb 2025 17:44:52 +0800
X-Gm-Features: AWEUYZkgVAbCEEqv9xLAAam3naI3QqVSMewJrFrQ8C5LyjSMOMVLC7GGoXuY--I
Message-ID: <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2025 at 9:18=E2=80=AFPM Miroslav Benes <mbenes@suse.cz> wro=
te:
>
> > >
> > >   + What exactly is meant by frequent replacements (busy loop?, once =
a minute?)
> >
> > The script:
> >
> > #!/bin/bash
> > while true; do
> >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> >         ./apply_livepatch_61.sh # it will sleep 5s
> >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> >         ./apply_livepatch_61.sh  # it will sleep 5s
> > done
>
> A live patch application is a slowpath. It is expected not to run
> frequently (in a relative sense).

The frequency isn=E2=80=99t the main concern here; _scalability_ is the key=
 issue.
Running livepatches once per day (a relatively low frequency) across all of=
 our
production servers (hundreds of thousands) isn=E2=80=99t feasible. Instead,=
 we need to
periodically run tests on a subset of test servers.


> If you stress it like this, it is quite
> expected that it will have an impact. Especially on a large busy system.

It seems you agree that the current atomic-replace process lacks scalabilit=
y.
When deploying a livepatch across a large fleet of servers, it=E2=80=99s im=
possible to
ensure that the servers are idle, as their workloads are constantly varying=
 and
are not deterministic.

The challenges are very different when managing 1K servers versus 1M server=
s.
Similarly, the issues differ significantly between patching a single
function and
patching 100 functions, especially when some of those functions are critica=
l.
That=E2=80=99s what scalability is all about.

Since we transitioned from the old livepatch mode to the new
atomic-replace mode,
our SREs have consistently reported that one or more servers become
stalled during
the upgrade (replacement).

>
> > >
> > > > Other potential risks may also arise
> > > >   due to inconsistencies or race conditions during transitions.
> > >
> > > What inconsistencies and race conditions you have in mind, please?
> >
> > I have explained it at
> > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/=
T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> >
> >  klp_ftrace_handler
> >       if (unlikely(func->transition)) {
> >           WARN_ON_ONCE(patch_state =3D=3D KLP_UNDEFINED);
> >   }
> >
> > Why is WARN_ON_ONCE() placed here? What issues have we encountered in t=
he past
> > that led to the decision to add this warning?
>
> A safety measure for something which really should not happen.

Unfortunately, this issue occurs during my stress tests.

>
> > > The main advantage of the atomic replace is simplify the maintenance
> > > and debugging.
> >
> > Is it worth the high overhead on production servers?
>
> Yes, because the overhead once a live patch is applied is negligible.

If you=E2=80=99re managing a large fleet of servers, this issue is far from=
 negligible.

>
> > Can you provide examples of companies that use atomic replacement at
> > scale in their production environments?
>
> At least SUSE uses it as a solution for its customers. No many problems
> have been reported since we started ~10 years ago.

Perhaps we=E2=80=99re running different workloads.
Going back to the original purpose of livepatching: is it designed to addre=
ss
security vulnerabilities, or to deploy new features?
If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot of room f=
or improvement.

--=20
Regards
Yafang

