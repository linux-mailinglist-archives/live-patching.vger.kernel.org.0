Return-Path: <live-patching+bounces-349-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 481DD902FBC
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 07:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF7A2B2149C
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 05:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C8726AE8;
	Tue, 11 Jun 2024 05:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJc22cbJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CAD37E
	for <live-patching@vger.kernel.org>; Tue, 11 Jun 2024 05:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718082127; cv=none; b=UbaTaXeiZn4EZ30jnEWfqTAXefACZvMnihBksU8UlCsRAXgLit4m2/VMJy4WOiJohqyxJg7mi/kr7l4apZGP/5fG1c38dO8RhOdNZ70sP7nMALy5V/1x6m+ZDfZwwMEVxguwyPHAOpnTKKu8DOCOQXnsUM8eanpuOvsc3+EMabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718082127; c=relaxed/simple;
	bh=a/N4lnflyAgbAcPGKNqP0QnyMf1ii5AhLwmiJuCGxv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MdIxQG+HGqzqLshSQFl5g2PQyurK/cXD9bAi/LLCcUFnzgVgQt4DBld/+XVEvl3UCH7Nrj1SrcbgR/XoAY4dGOmTuj1ib0orD7kCyhVv+F/z7mP0HZ4/eTaeJKYwwqDJoqhhn1O+2LkEMeWDNZTsGtKvlJaJjmKzmsGtpSrFhxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJc22cbJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D126C4AF49
	for <live-patching@vger.kernel.org>; Tue, 11 Jun 2024 05:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718082126;
	bh=a/N4lnflyAgbAcPGKNqP0QnyMf1ii5AhLwmiJuCGxv8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jJc22cbJGz64NwhXwsVKVijK0Y54LPpdYz5Rv9YZX123H0Nb4xYKI7KRln0yJzdWP
	 mYe8Cqh31PKVHQ1CFvu4RHRiUNb53jH/8KfO8iK6J3ypOjpkr428yl28Ha3r+bMqTg
	 XbUJ6loMRvtiUpDhh7WPz1f/k3+Cdlitss+KKye5IMwYoJs+dB1IG8hq7DOVWTpJGk
	 0YfWkzuaxRm9jo63OojGcuzxMOBzUVGuzicT3mNfXxG/ci3xRuueo7zT8TqJGtfy9g
	 BmOkXuQJBCSRBfOccxtpPHsDsrz+ckFCnsWm0kTY+nT6IuojjyuNfZcTxQvXPd5Y4K
	 QGRUtGI8fgM1Q==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ebd421a931so29481941fa.1
        for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 22:02:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVgj1NwZu7hnB/OUHDgyMzR32oh4i5dsoRqZdcTZRT7GTXnZfcNXuIod3VJBVNAJmCGLjni5NjnPXcN5vao6BZKHt/K61dMiQIchLsUTg==
X-Gm-Message-State: AOJu0YzYWw0bW1r99bDj5md8U8+3LIzd32jyeni6PnK97T04MVDaMyuA
	H0opMn1CcztNkMaqtcCw0e9hU2oN+IFJeIkb7LP8OwGuRsEllFiQTpzMWXJM5MBNHZUM0vX0FpW
	urmrSzfDxYRni1sEjG+tcnEmtnFg=
X-Google-Smtp-Source: AGHT+IFX8C6ixpQvUeP+GLZfLSh+0BEa4YcfLosrMAXYe6c02u7t1eKa69zp2DB9MiIoHBx1xUOsCSZEgbuawysrFHI=
X-Received: by 2002:a2e:8ec8:0:b0:2eb:e76d:895c with SMTP id
 38308e7fff4ca-2ebe76e07cbmr25969301fa.35.1718082124780; Mon, 10 Jun 2024
 22:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
In-Reply-To: <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 22:01:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW60WdB007MBWbmVEuv3CmswgEXcdczmRhm6PxxK0kGPLg@mail.gmail.com>
Message-ID: <CAPhsuW60WdB007MBWbmVEuv3CmswgEXcdczmRhm6PxxK0kGPLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 7:47=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Tue, Jun 11, 2024 at 1:19=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > Hi Yafang,
> >
> > On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > Add "replace" sysfs attribute to show whether a livepatch supports
> > > atomic replace or not.
> >
> > I am curious about the use case here.
>
> We will use this flag to check if there're both atomic replace
> livepatch and non atomic replace livepatch running on a single server
> at the same time. That can happen if we install a new non atomic
> replace livepatch to a server which has already applied an atomic
> replace livepatch.
>
> > AFAICT, the "replace" flag
> > matters _before_ the livepatch is loaded. Once the livepatch is
> > loaded, the "replace" part is already finished. Therefore, I think
> > we really need a way to check the replace flag before loading the
> > .ko file? Maybe in modinfo?
>
> It will be better if we can check it before loading it. However it
> depends on how we build the livepatch ko, right? Take the
> kpatch-build[0] for example, we have to modify the kpatch-build to add
> support for it but we can't ensure all users will use it to build the
> livepatch.

Interesting. I guess we have very different use cases. In our systems,
we don't allow random users to load livepatch.

Thanks for the explanation.
Song

