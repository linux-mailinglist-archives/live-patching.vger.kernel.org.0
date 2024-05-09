Return-Path: <live-patching+bounces-261-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C05718C0F0D
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 13:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7330728118F
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 11:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F531131729;
	Thu,  9 May 2024 11:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOIYof+i"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF914A90;
	Thu,  9 May 2024 11:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715255877; cv=none; b=CsG21uJV3WpVb2YayupVh5n2gOEF5hHA0zeS9XK7TI/YYCVDo8MaIQ4HTq6SpzEFjbQcHh7Nb6KOtrUGPSxRx4K4ogNJHJCxRL82LDouz7jtxQwrasy87pWCajyameHhP2V33k8p68dy3G7/jlc39ZFT5hMgwyDcYEHv1SMUmyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715255877; c=relaxed/simple;
	bh=5AxlzhOhqVgjA6GYj8uiwW2Vvpfcuid4NrOWihyKrjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZII0fwtZ1ekJlUAKOcZQPtVSbVeK7yS3aBsLmqA7FSm/pZOw0OietXcqa+RWg9+v8iSJfFiGrSISwItODUqCyc+nxWCRolNOuO7J2LmiLXWRE1EGiRFWKU6n4c9udIHE051nc7Qcc0LA6kqRVxJLb3ZG5MqzwWVzqLUTiA94NM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOIYof+i; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-792c031ffdeso33263485a.2;
        Thu, 09 May 2024 04:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715255874; x=1715860674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQPTd9P260wLT9KzRqd4LGGg2af0O+Fqtt4irMU5VOE=;
        b=OOIYof+iaRMbrSh+BcWRnAD2o6KaAYPsV/6rgJKo1LHFerWllXdqB4cYeN+qxdhbLP
         h6LH/ypTvMBAvyDkpAgk5nOvPtAaNpICs+OvyJk/s/UdAM5MqFKFLWdGThxb4ntM8s7F
         I98S3QcxQT/OMVVe+eBVLVul1UONsCchCu0/BEOtG0eM+khNA2pT0ZYnH6akwix+u4XC
         BRS7lcgeqtYxCqWnz56HLfKg379118ZBlMTY80vWpko39AT+/1hG8AuQTASz731CBXXJ
         7R3+ptUornLOhcmEiSgiTaBh1NWk973LR+i2CWH2gVznPKmXlk+eE4huF59ZLqdaaAIq
         COjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715255874; x=1715860674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQPTd9P260wLT9KzRqd4LGGg2af0O+Fqtt4irMU5VOE=;
        b=rTHXFlaFctoZAZ3XXgborjHJzKf1NqQrQ3nyXnK0y9csypN3h+wre5VRVIK+5jZRxc
         BvRmseEfmzPJloy/1A9G70IgXl0Us7d4s0/9T9JqAktTvOWIZF/UevXL+Fuj9WN39FkI
         yOgg2OP4ksPNQUhmD72GHyxxsQw92V+mn4a0pJa1NtwR9JAG/pNklBvYPzc2NuNf8WqF
         IGXPeAOrZ+oewgLg4dtCiPRxQlLJbbmGXRjadYJ5+Pj/otMkmvTL3M1iPhcyGALvSnk9
         uouBEbLYj0TJyAHhJ7B0bjvXRoLHPpSLHPwFV6JGzApjDUB2sHilgIe7fJHdPsFCApUx
         BfdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7xcjHET+exdLJni74WuzBZDGjYtH6MMeQPqBijEyT6rp7ZEX0LU01B/GhiY+PLcFg2hpzffQ/nsQugexEAJ8u/S3vMjB5jAfTp1l36ncyHFM7Eeo5l1vgiEPRJDnG5Jrd/9Om39fBGVgHhfo=
X-Gm-Message-State: AOJu0YyhZ3VWaeHcKSPqY3O5aogZQWCSfIh+mQyYu2XbpCV2BDRG0r+d
	jXMH/c+EF8wvPEqYLZpdPNS/FFwtp7YNeccPYfPrrWp5bWP0ZC2ltbm7aOzdFyWMd5vdtvoYCRn
	VVT0xdPPw7JBY4az0liUeRu48twQ=
X-Google-Smtp-Source: AGHT+IF5kEh0TCJcKRT8f+Cj8XCW64w9RhHNH2OAKTj2RXyx0wzm6sq0URIOMeRVPL5gBi8EjioVgr3JZEM0vXGuU1M=
X-Received: by 2002:a05:620a:2949:b0:78e:ccd6:be8a with SMTP id
 af79cd13be357-792b285c22emr656685885a.57.1715255874366; Thu, 09 May 2024
 04:57:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240503211434.wce2g4gtpwr73tya@treble> <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble> <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble> <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
 <20240508070308.mk7vnny5d27fo5l6@treble> <CALOAHbCdO+myNZ899CQ6yD24k0xK6ZQtLYxqg4vU53c32Nha4w@mail.gmail.com>
 <20240509052007.jhsnssdoaumxmkbs@treble> <CALOAHbBAQ580+qjxYbc1bNJxZ8wxxDqP3ua__pqKzCg9An3yGA@mail.gmail.com>
 <ZjyiZfC9GqQ4akVJ@pathway>
In-Reply-To: <ZjyiZfC9GqQ4akVJ@pathway>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 9 May 2024 19:57:17 +0800
Message-ID: <CALOAHbD3LLzC7JrYg+K1q-zCUfvdjv7DFYFwXTWUaik0b_aqfw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 9, 2024 at 6:16=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Thu 2024-05-09 13:53:17, Yafang Shao wrote:
> > On Thu, May 9, 2024 at 1:20=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> > >
> > > On Thu, May 09, 2024 at 10:17:43AM +0800, Yafang Shao wrote:
> > > > On Wed, May 8, 2024 at 3:03=E2=80=AFPM Josh Poimboeuf <jpoimboe@ker=
nel.org> wrote:
> > > > >
> > > > > On Wed, May 08, 2024 at 02:01:29PM +0800, Yafang Shao wrote:
> > > > > > On Wed, May 8, 2024 at 1:16=E2=80=AFPM Josh Poimboeuf <jpoimboe=
@kernel.org> wrote:
> > > > > > > If klp_patch.replace is set on the new patch then it will rep=
lace all
> > > > > > > previous patches.
> > > > > >
> > > > > > A scenario exists wherein a user could simultaneously disable a=
 loaded
> > > > > > livepatch, potentially resulting in it not being replaced by th=
e new
> > > > > > patch. While theoretical, this possibility is not entirely
> > > > > > implausible.
> > > > >
> > > > > Why does it matter whether it was replaced, or was disabled befor=
ehand?
> > > > > Either way the end result is the same.
> > > >
> > > > When users disable the livepatch, the corresponding kernel module m=
ay
> > > > sometimes be removed, while other times it remains intact. This
> > > > inconsistency has the potential to confuse users.
> > >
> > > I'm afraid I don't understand.  Can you give an example scenario?
> > >
> >
> > As previously mentioned, this scenario may occur if user-space tools
> > remove all pertinent kernel modules from /sys/livepatch/* while a user
> > attempts to load a new atomic-replace livepatch.
> >
> > For instance:
> >
> > User-A                                                       User-B
> >
> > echo 0 > /sys/livepatch/A/enable              insmod atomic-replace-pat=
ch.ko
> >
> > >From User-A's viewpoint, the A.ko module might sometimes be removed,
> > while at other times it remains intact. The reason is that User-B
> > removed a module that he shouldn't remove.
>
> Why would User-A want to keep the module, please? The livepatches
> could not longer be re-enabled since the commit 958ef1e39d24d6
> ("livepatch: Simplify API by removing registration step") which
> was added in v5.1-rc1.
>
> The only problem might be that User-A can't remove the module
> because it has already been removed by User-B or vice versa.
> Is this really a problem?
>
> Have you seen the problem in practice or is it just theoretical?

It is just theoretical.

>
> Is anyone really combining livepatches with and without atomic
> replace?

I don't know.

Previously, we utilized live patches without atomic-replace
functionality. However, we've now transitioned all patches to support
atomic-replace. It might be beneficial to introduce a
/sys/kernel/livepatch/XXX/replace entry to indicate whether a patch
supports atomic-replace or not


--=20
Regards
Yafang

