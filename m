Return-Path: <live-patching+bounces-1219-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC7FA3D091
	for <lists+live-patching@lfdr.de>; Thu, 20 Feb 2025 05:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3706E1897B38
	for <lists+live-patching@lfdr.de>; Thu, 20 Feb 2025 04:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF751DE885;
	Thu, 20 Feb 2025 04:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nP+223Dg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC11C6FF0;
	Thu, 20 Feb 2025 04:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740027021; cv=none; b=FeOEfgPo/ZpA2W+lFc0ipKwFKw7gwVq5iPNEF6WAH8/ncq2Y/MHkv5kQEIVzvUQ+3UPp4gcmccql6cLnBOcDTfD8XD8cQtmS7cqErOxxxsQfYFtqS6t5uvAbtBy1hAg2EqoVMQd8MxKm+5qX4pdDK7EB6wBqkKCil36VOEXZXfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740027021; c=relaxed/simple;
	bh=DChsqJxyhk9Qb++DKf4IK7huS/p4MfkPjmtyZ6XO9js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rfb6sUeR+xuztGMhcfS+jn0MIiy5QxB8QeyRVouvWHKDAt8PhtmIMsSb5hd+b1M7a0XUF7fSdZdEsZdWrkq67EvcGTBcUhWpI699XESrMqs4zCBFZ3BvNlkgL78ThQAB46Egs2m8ExuIpeiPr/2AiLesGzkjFZUo09twBz50UR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nP+223Dg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6EBC4CEE4;
	Thu, 20 Feb 2025 04:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740027021;
	bh=DChsqJxyhk9Qb++DKf4IK7huS/p4MfkPjmtyZ6XO9js=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nP+223DgdDPahbAQ/DMXBozdKBtmAmqyHVZZOCIXrTjHNpLPnj9v/iVAnaoc4O063
	 /VfV+oY/blczgW8J9LtkS74fQwMLNW2/MUqmx+LUZ8FHrkakWSdyAwiVmQb+M84Y4e
	 a6HqCB5xJya2PA0f7gRJSkwF003yW7bIaUBJUgR+Mw12mAvQYd1mMx2WnRRLOFCvAR
	 uXhAk/EJ4Yt4SKdXOUROLVyAVqe8H0ikze9rmMw1M4lozHjJvS9wgPs73BV1aybClo
	 7OyKG0sk67gmwM7L6HQ84TSQd1429nLBVYT4dEOpYliA9yWd58y5FTuhd3eV8iSA2J
	 01bBXEp+OpgDA==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-84a012f7232so50523939f.0;
        Wed, 19 Feb 2025 20:50:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU8hTRsmJmF2GFdaoicRD3+boGuh0QBKiNHDJxCDIfI5jmaCZcsa6XVMsIWO2fzo9I233dfOrlbGm7ESe6JwbcaxA==@vger.kernel.org, AJvYcCVSN8MG8WdKbAB8VO6GZ4KEQXVfFygWZx6BZKLlUulJGYbSVTwNePqujukWfSgThzRB7NN3ThVpdBS07kDTEg==@vger.kernel.org, AJvYcCW+9Z8qRM4jD8p98Ut0fU7XsMBr9WBD7JRR1uD2g1wfWEz6ZbfQ3wnE8FVEOrhovA/sMVkm2uinS54TQz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkPM14QJY0KecOpP+JkJg8keLljLhAWFMtK2uq7F46h7skp9IC
	nHhLI7GUunNcojp8WlcGN1tQ9dZmssrp7x7PkV8NmV9BBfYl/Bznp2Y3YLVT2a9nFQNbsASwWnN
	va0KjiVWVFhF6Ydj1gIKLDrEFSwY=
X-Google-Smtp-Source: AGHT+IFmWHJqCH3cbGZFDUcUNaqY2YTVIZFU+S/p3lJ7fDhtdz4X9utFFcRlkYoxykMFF9n+u9RVTHFBVZQiXijHiZw=
X-Received: by 2002:a05:6e02:1aac:b0:3cf:b2ca:39b7 with SMTP id
 e9e14a558f8ab-3d2c012111amr17570615ab.3.1740027020282; Wed, 19 Feb 2025
 20:50:20 -0800 (PST)
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
 <20250218184059.iysrvtaoah6e4bu4@jpoimboe> <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Wed, 19 Feb 2025 20:50:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW57xpR1YZqENvDr0vNZGVrq4+LUzPRA-wZipurTTy7MmA@mail.gmail.com>
X-Gm-Features: AWEUYZluMaezOMmQQsAYtgK7LIHyb4dDUrt3IKavp2g_tW1sQiOH2SDEzUiEu6I
Message-ID: <CAPhsuW57xpR1YZqENvDr0vNZGVrq4+LUzPRA-wZipurTTy7MmA@mail.gmail.com>
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

On Wed, Feb 19, 2025 at 9:44=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Tue, Feb 18, 2025 at 10:41=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> >
> > On Tue, Feb 18, 2025 at 10:20:10AM -0800, Song Liu wrote:
> > > Hi Josh,
> > >
> > > On Mon, Feb 17, 2025 at 10:37=E2=80=AFPM Josh Poimboeuf <jpoimboe@ker=
nel.org> wrote:
> > > >
> > > > On Mon, Feb 17, 2025 at 08:38:22PM -0800, Song Liu wrote:
> > > > > On Fri, Feb 14, 2025 at 3:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@=
kernel.org> wrote:
> > > > > > Poking around the arm64 module code, arch/arm64/kernel/module-p=
lts.c
> > > > > > is looking at all the relocations in order to set up the PLT.  =
That also
> > > > > > needs to be done for klp relas, or are your patches already doi=
ng that?
> > > > >
> > > > > I don't think either version (this set and my RFC) added logic fo=
r PLT.
> > > > > There is some rela logic on the kpatch-build side. But I am not s=
ure
> > > > > whether it is sufficient.
> > > >
> > > > The klp relas looked ok.  I didn't see any signs of kpatch-build do=
ing
> > > > anything wrong.  AFAICT the problem is that module-plts.c creates P=
LT
> > > > entries for regular relas but not klp relas.
> > >
> > > In my tests (with printk) module-plts.c processes the .
> > > klp.rela.vmlinux..text.copy_process section just like any other .rela=
.*
> > > sections. Do we need special handling of the klp.rela.* sections?
> >
> > Ok, I see how it works now:
> >
> > klp_write_section_relocs()
> >         apply_relocate_add()
> >                 module_emit_plt_entry()
> >
> > If that code is working correctly then I'm fresh out of ideas...
>
> I tried to dump assembly of copy_process, but couldn't find any
> clue. I am wondering whether this is an issue with gcc-14.2.1.
>
> Puranjay, could you please try with a different gcc, like some
> version of gcc-14?

I figured out why this is broken with gcc-14.

The stack trace points to tty_kref_get(), which is eventually
a __refcount_add(). With gcc, there are multiple of constprop
versions of the function.

$ readelf -s -W vmlinux | grep __refcount_add
 19747: ffff800080872eb0   104 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0
 20153: ffff80008001fcd8    88 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0
 36428: ffff800080e62ac0   100 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0
 45055: ffff8000800bf130   100 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0
 54823: ffff8000801c2a40   100 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0
180848: ffff8000810a8cb0   100 FUNC    LOCAL  DEFAULT    2
__refcount_add.constprop.0

The problem is, with gcc-14, these symbols are NOT sorted by
their addresses. OTOH, the order in kallsyms is like:

[root@(none) /test-klp]# grep __refcount_add /proc/kallsyms
ffff80008001fcd8 t __refcount_add.constprop.0
ffff8000800bf130 t __refcount_add.constprop.0
ffff8000801c2a40 t __refcount_add.constprop.0
ffff800080872eb0 t __refcount_add.constprop.0
ffff800080e62ac0 t __refcount_add.constprop.0
ffff8000810a8cb0 t __refcount_add.constprop.0

kpatch-build uses readelf to get the symtab, and then calculate
proper sympos based on this symtab. However, this sympos
is different when the kernel applies this KLP. In this case,
copy_process calls ffff8000800bf130. kpatch-build gives
sympos of 4, based on the output of readelf, but ffff8000800bf130
is actually at position 2 in kallsyms.

gcc-11, OTOH, doesn't have this problem with readelf.

Indu, is this behavior (symbols with same name are not in
sorted order from readelf -s) expected? Or is this a bug?
I am using this gcc:

$ gcc --version
gcc (GCC) 14.2.1 20240801 (Red Hat 14.2.1-1)
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Thanks,
Song

