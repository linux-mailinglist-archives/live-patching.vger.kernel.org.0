Return-Path: <live-patching+bounces-1120-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C457EA29EFF
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 03:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17A8E3A6E16
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 02:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CDC13B5B6;
	Thu,  6 Feb 2025 02:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d86ktGOu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90413CA93;
	Thu,  6 Feb 2025 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738810527; cv=none; b=dPojTQkY18p2LKiJP2le82rj2LhiGaY4DGF9qNpZ4WcVZXnhUb6I9oHwLrDnOPkvpGAF8x61so8gJNyw9toQW1whotIBQye2INuN09Wa5pR7dTV95gGRkpn1k06DdcGyw+dw9xJ9cIZeKdLJaaToFgPia4xE+Yu+3s5uysEV/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738810527; c=relaxed/simple;
	bh=0IqMAB96D4GNBXwqFjKFMh2GI/bTFHwFxbm35HPqJeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GwGkc7W38o5fsvBxGYYwuryBN4CQ0MWlZXKvfCepYKYpahefpr42pVA7TcfRMu37HC7nK1B3FUq7brr+JRfR5wzbD6gy4oX334QEAZrxgLUyP1QCGYIJEs1hTs/zcfhetNZBlWk66Yg4wnXR8UKGu+J/umYl69wXOaGIJVFoUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d86ktGOu; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6e43c9c8d08so170286d6.3;
        Wed, 05 Feb 2025 18:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738810525; x=1739415325; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3GnVWEwVJuG/SEGSdqX/pIt9ooe9OSa2rMvMygSeYjU=;
        b=d86ktGOudIvmJid4NrZ2YkU/sQRSZ0oWmPGiwkpI+4pqGxy04Pb4x5OGzVaBBjika0
         eYOLVKAUcJkeoFWOm8eOpN9LPiBLXNM74RMSMV1MUzEdvR1lTWWaYhGjpJRjtVuVRO7P
         eHNmucbK9YztGccSepx68csFTcwEiKWZKwAvWtn4lAu1n0qzTP3vbZ2dAriXo5C8VWFA
         NSGcrnC1+H3PjB/sokl7/zMfcAY7AU1MdWXjfJ9+ZTQcUUy0J/1A7VivX1uhyZIxQSyX
         DcKxzMUAu1zxfh2RefjzXDJ5+4/x0B0kD5jAi8Jje1p4VNsUGJu0FPyvzevWdLHdOU/I
         QMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738810525; x=1739415325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3GnVWEwVJuG/SEGSdqX/pIt9ooe9OSa2rMvMygSeYjU=;
        b=r59m9tizaJEBPFukVWBgci7I626fUFruvCwY4NXJFjPa7OpHPr6+5Lde1p9cF5DiK4
         C6sHHDN6VWVj+Oq7TjXeeeSf5MXqK+dXDXSx9bplIrNJASnboNVLg0E2BP67TQG18QO8
         ukGD9zYwbIIegVbk6/BXm+mduLR67j2GIE46/x+YQyzvYOyHIYtOmLcD21tB0HW0zhRY
         gN1FhsnX2lj4KlpF9+H2q2DnWFqn7/yHB82Tdt2kPq3b3l/8WBf4NvjwwMDIFhdOpneV
         P2RpFC6PiSVGNjl1H1Em2h2XvN6RUHDPGNzPFmbF9XbJRpbKbCeeC732bDGEd1OKvWtm
         Cckw==
X-Forwarded-Encrypted: i=1; AJvYcCUaI99SXTy/1OK6PAcmlSUEY+FF1rChdRxtoW5JZ479Eqf49hN4WP4gucr5MDMXa1tpA3+CS2lFBldUlko=@vger.kernel.org, AJvYcCXQ1cDUKd/S45ykodrdJrOqOy/8up+0prrLaBiZ0aNWSo/EMbM3PG8KlM6Qmsb/MVUj3bNkTyD0DvrZKW2YVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr/S/0y5YNnrqUDXJ67CWVJVe9BMSaxI2/4QNIiB5CEiZ/FalV
	kip6VdJuCVvv89dKx6JEt+KdUo4irJyv13TAOzyelDgzCEFlcl0hG/9vdwdHZf6Z8det1RP+azP
	SlUTMubTGLDNMIW7vQW3gPMAP8gc=
X-Gm-Gg: ASbGncuf31JMH28g28/6CAejTBPXr6Y0pd15GdpA5fplpqV/IpGwoi3I16zw6GFKciq
	ytnxSSE+nKydEOpf9p3/I/03p6jwT0ixUOmSkVoSvsHsRKq1jfsRH+uYFzZqSta8X66nhKZQsII
	g=
X-Google-Smtp-Source: AGHT+IFnv9nwIe8WbvJxONCw6hGNFmT+1viZkV7PuwG+b/q0AG4Qdd1/cXv434UnBGYNHt+rihHL2okY+4imeF4Vfwo=
X-Received: by 2002:a05:6214:3187:b0:6d8:7db7:1f2e with SMTP id
 6a1803df08f44-6e42fb84041mr73343336d6.14.1738810525030; Wed, 05 Feb 2025
 18:55:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com> <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
In-Reply-To: <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 6 Feb 2025 10:54:48 +0800
X-Gm-Features: AWEUYZlSDMT40qCXMCOXCovx5qjIMu_uPCwIwpyaiGy-rEp5XExnQmswscAerxY
Message-ID: <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Song Liu <song@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 1:59=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Wed, Feb 5, 2025 at 6:43=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Tue, Feb 4, 2025 at 5:53=E2=80=AFAM Song Liu <song@kernel.org> wrote=
:
> > >
> > > On Mon, Feb 3, 2025 at 1:45=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > [...]
> > > >
> > > > If you=E2=80=99re managing a large fleet of servers, this issue is =
far from negligible.
> > > >
> > > > >
> > > > > > Can you provide examples of companies that use atomic replaceme=
nt at
> > > > > > scale in their production environments?
> > > > >
> > > > > At least SUSE uses it as a solution for its customers. No many pr=
oblems
> > > > > have been reported since we started ~10 years ago.
> > >
> > > We (Meta) always use atomic replacement for our live patches.
> > >
> > > >
> > > > Perhaps we=E2=80=99re running different workloads.
> > > > Going back to the original purpose of livepatching: is it designed =
to address
> > > > security vulnerabilities, or to deploy new features?
> > > > If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot o=
f room for improvement.
> > >
> > > We only use KLP to fix bugs and security vulnerabilities. We do not u=
se
> > > live patches to deploy new features.
> >
> > +BPF
> >
> > Hello Song,
> >
> > Since bpf_fexit also uses trampolines, I was curious about what would
> > happen if I attached do_exit() to fexit. Unfortunately, it triggers a
> > bug in BPF as well. The BPF program is as follows:
> >
> > SEC("fexit/do_exit")
> > int fexit_do_exit
> > {
> >     return 0;
> > }
> >
> > After the fexit program exits, the trampoline is still left over:
> >
> > $ bpftool  link show  <<<< nothing output
> > $ grep "bpf_trampoline_[0-9]" /proc/kallsyms
> > ffffffffc04cb000 t bpf_trampoline_6442526459    [bpf]
>
> I think we should first understand why the trampoline is not
> freed.

IIUC, the fexit works as follows,

  bpf_trampoline
    + __bpf_tramp_enter
       + percpu_ref_get(&tr->pcref);

    + call do_exit()

    + __bpf_tramp_exit
       + percpu_ref_put(&tr->pcref);

Since do_exit() never returns, the refcnt of the trampoline image is
never decremented, preventing it from being freed.

>
> > We could either add functions annotated as "__noreturn" to the deny
> > list for fexit as follows, or we could explore a more generic
> > solution, such as embedding the "noreturn" information into the BTF
> > and extracting it when attaching fexit.
>
> I personally don't think this is really necessary. It is good to have.
> But a reasonable user should not expect noreturn function to
> generate fexit events.

If we don't plan to fix it, we should clearly document it to guide
users and advise them against using it.

--
Regards
Yafang

