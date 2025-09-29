Return-Path: <live-patching+bounces-1725-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E04BAA88A
	for <lists+live-patching@lfdr.de>; Mon, 29 Sep 2025 21:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 058B2189E897
	for <lists+live-patching@lfdr.de>; Mon, 29 Sep 2025 19:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD4C24501B;
	Mon, 29 Sep 2025 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAlBh20B"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4905A241C8C
	for <live-patching@vger.kernel.org>; Mon, 29 Sep 2025 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759175749; cv=none; b=Fy2i6xwQnEFndOAJwDPWmJ+OmgU2O07EcRddokHgMT/Tqdj4u178H+ZGTdeD0ns0ooLmi6SLWrU4VXVxHM7bIJL93htjx0/CetaLxwQ6L0d4ePFMiznSKYOQ0J1HogxmHFAuOCIHczX83HtH2h3zG9NQ87m1czDNOwiHLcO+Eow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759175749; c=relaxed/simple;
	bh=RO76/f9CYEMfPMQPTUBiSF3Nm+ZZmO0CK1pt0ht+BNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhgQRsxNY0d8kyYo8aGz5VUsRRnTSKp8Dz0iunUS82d2vmwuua9xw6rr6m46LS+cK0abISAzLsFaC9uY0JBORKM3B+lbLo1hL6GGiwSPwy6ZMgSK7SyVBOUR1JtAWmzCyWzNNryJsCN0fP/+a8zUpsFnxPseQ9TKXD2RClx7+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAlBh20B; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-36295d53a10so45198291fa.0
        for <live-patching@vger.kernel.org>; Mon, 29 Sep 2025 12:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759175745; x=1759780545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FOl60H4bs8OomkAN24CFvRC0ueG1po3QRTP8yk1rSI=;
        b=VAlBh20B3P3dm7CaEIn3O06+vQyVZ81bdMTSHJwHkvFx85Kild20mRtqc3F+5YFVV4
         p8b721ZkYWEXmHrSFUofFk2NE0x5xJ/KvdmxM7kn4aMgXfR5Bmi9yrNeBlUUBB1rIXKd
         C/J1DNYw8N+cEXYdjf8gYLFSr7Nqg2pDUPkJHA74qb+iY4N9XiaY3krplvntGSbX14Rt
         XOXkyClREo9RrOy3dLOtLOMW0II0nem+QstrB8lj6/bl5A7JkoJrtmv13m+v5/AhrXb0
         EWt7hsxbHGqeAvze5wWBwZM5x84yD0NyOYbBDvRg3q2uoFrM3c/oAhEWVZT/vJDerbdl
         2s8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759175745; x=1759780545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FOl60H4bs8OomkAN24CFvRC0ueG1po3QRTP8yk1rSI=;
        b=sQNXVWkLMxjfJRoWRu+x8tjAynwyrykxVvHSC4LFvm9FO0aAXthVyBMwgjZAFYjyjZ
         Ew54CInZwrj0+ufJBk2JCXKV9QmYt2KHJrWMwRH/Y+BnDn0DMLwXN7gv/yTslv341fv4
         4WnB/ZL/zVaZBmP6ROXXvIvCIJB0M7myjnuXSDudRpoINBp5N3TFm8241nqVb43M1jRl
         DXD+aiJmor/yBWWP0IY4wxALxcAu17bKPeJfnj82KugIB9SPHqdiAkylq8zfxqx/YSyu
         mxSOP6wsre9WzINmlG/QU2LpdFm7Jl8KxEE1KnPcUi49W1X77e27wUBsew2s5oa3rKyf
         R5gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjwGcPpBQ3y1AyPusvytqUMpkQp9UY+B/Xc3YxAlgSR6Oqz67H6rKTtRrr7YLOeIIxA4KZ3f81p3s0wbsS@vger.kernel.org
X-Gm-Message-State: AOJu0YxRuH2xFAvyhDTabS2LfDyAsuxHoWIi5ePAH/U0g3i0+YHTzgz0
	jTOJHAYSCRQF9/eAToCJ3H1Z1Z5H3lVTSRyfXJWUxfhnPnE/jwoPyWvZR1otXuyOr+quyVBh7CO
	NeXzu0GiC4TgcNkdV3n9zUGDPGk3zf4o=
X-Gm-Gg: ASbGnctevqh736+dpVmQQerrCoszYPKKLFwufy0BwLKlTxO61BcZJP2qrVMIGaAL9mB
	/wD5cPBhz8H8FL1JX3FvH7Q4bbMTT/PkUVOGzWRL7qHlPgyo9HAN5eqJOxv01pwp4XwIrMzFann
	xnViTznCuYPmC+f4RRyFTXfjqp71bwHjPRc1bDOD4iVX6t7/1YgPWM6JtfBbNq94/C+OvWjNash
	BdihQ==
X-Google-Smtp-Source: AGHT+IErP2gRQ6ZD56twcKHZTwT0kBevF4fdnA1y+SJ74LG1tfUzYR0s+sNt2FXIYbc5oOC4PL8X1Gg/KiynFJqey6Y=
X-Received: by 2002:a05:651c:4414:10b0:372:8cce:2360 with SMTP id
 38308e7fff4ca-3728cce261cmr18756371fa.14.1759175745085; Mon, 29 Sep 2025
 12:55:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com> <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
In-Reply-To: <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Mon, 29 Sep 2025 21:55:34 +0200
X-Gm-Features: AS18NWAIi9DineMp-TgEBH0HLfNcuGGToX7Qfv23-1VNL-wNOdBAfvSptWoYjzE
Message-ID: <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Song Liu <song@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 9:46=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Thu, Sep 4, 2025 at 3:39=E2=80=AFPM Dylan Hatch <dylanbhatch@google.co=
m> wrote:
> >
> > This patchset implements a generic kernel sframe-based [1] unwinder.
> > The main goal is to support reliable stacktraces on arm64.
> >
> > On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
> > required support from objtool: it cannot generate orc unwind tables for
> > arm64.
> >
> > Currently, there's already a sframe unwinder proposed for userspace: [2=
].
> > Since the sframe unwind table algorithm is similar, these two proposals
> > could integrate common functionality in the future.
> >
> > Currently, only GCC supports sframe.
> >
> > These patches are based on v6.17-rc4 and are available on github [3].
> >
> > Ref:
> > [1]: https://sourceware.org/binutils/docs/sframe-spec.html
> > [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.=
org/
> > [3]: https://github.com/dylanbhatch/linux/tree/sframe-v2
>
> I run the following test on this sframe-v2 branch:
>
> bpftrace -e 'kprobe:security_file_open {printf("%s",
> kstack);@count+=3D1; if (@count > 1) {exit();}}'
>
>         security_file_open+0
>         bpf_prog_eaca355a0dcdca7f_kprobe_security_file_open_1+16641632@./=
bpftrace.bpf.o:0
>         path_openat+1892
>         do_filp_open+132
>         do_open_execat+84
>         alloc_bprm+44
>         do_execveat_common.isra.0+116
>         __arm64_sys_execve+72
>         invoke_syscall+76
>         el0_svc_common.constprop.0+68
>         do_el0_svc+32
>         el0_svc+56
>         el0t_64_sync_handler+152
>         el0t_64_sync+388
>
> This looks wrong. The right call trace should be:
>
>   do_filp_open
>     =3D> path_openat
>       =3D> vfs_open
>         =3D> do_dentry_open
>           =3D> security_file_open
>             =3D> bpf_prog_eaca355a0dcdca7f_...
>
> I am not sure whether this is just a problem with the bpf program,
> or also with something else.

I will try to debug this more but am just curious about BPF's
interactions with sframe.
The sframe data for bpf programs doesn't exist, so we would need to
add that support
and that wouldn't be trivial, given the BPF programs are JITed.

Thanks,
Puranjay

