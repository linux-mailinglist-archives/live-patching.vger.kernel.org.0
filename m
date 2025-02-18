Return-Path: <live-patching+bounces-1214-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA04A39229
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 05:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3E151882A23
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 04:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E212C1A4F2F;
	Tue, 18 Feb 2025 04:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDx/axSo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9765C81E;
	Tue, 18 Feb 2025 04:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739853514; cv=none; b=hYQjcodOW8LNLog1sqaLq2YkrUfJmob5NHJsUyuWGDHp8VFzEd38VZ9mt+U6aAvIeHFckndfiI0byPjlGGk9kqdEBtJAs9LQAQyli86V7axOkOtKxADFGaHWky26ubtg/SdGvjR6rDvmnsrtZyY1Y8ZwjnkAklgZakq6W5Vp6Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739853514; c=relaxed/simple;
	bh=R5WL6l5L2lq8UY6+qmmUnEdnDls7MHkMUP7LdkFeDvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ei+HNUaWM4/yx7isUwn2eabbzOo/JVkn16Y+9PWPgPMZ3F7Fe20h9A7AqlsAzCtcEgq7g0gTUtG6spxzVZQF5oOwQ2syIavEWkWJkia3cfAaAsVFsehtRQV/2l04+zvd3B6vkcAg+UNKD12mKHjW4f6E2fuNLCUVOpCm8EgTT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDx/axSo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B1C4CEEA;
	Tue, 18 Feb 2025 04:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739853514;
	bh=R5WL6l5L2lq8UY6+qmmUnEdnDls7MHkMUP7LdkFeDvc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MDx/axSoG1prz9+kyo4nEpP9D55JWaxrotjmPAZnT8QuVLetWnvVjeI1lZDGZc7ZM
	 RlhIqVOcN4sqHRSTr4BZx8hHhdJcTGifYhhiaW5xx7t1PQrtyV7GsnrA3ymyteFo2J
	 Tv0cs6jLgJURZN6yiNHvdnLA15wSoZWbJB7qFQOpbIQlsERlvNUQWN0GDAYEwd5EPt
	 /s0IOpV7JmPdD8Ovn9vxN+CpNqSkwXUY2N0o/KzbbQSTJ3ukeiYL63p3aLHHFPC0Vj
	 7lh65v6iOOI4v5cwybsgjyqeIWktlyQWSXS1A2HaDwNU9Kxw9rtZ5Zls+jOSrvlq8Z
	 fmTcX7kPkF9pA==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d2a869d016so1742915ab.0;
        Mon, 17 Feb 2025 20:38:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUu1yYEFLWqYC1gvY2PRaIKuk0SvkPEX9Fdns7nlmfGVFy/X0S0P8qdWxvOTvaWGp8zlYf+K1azzzIjHI8=@vger.kernel.org, AJvYcCXNb3hLqZcsMsbTaUJGqkjQ8rIyLeYrPnNEr8Ohftjgfwd9jt+VTHoo3nWGdtkZn1c+pvmKjIcNbgVmy3khJpj89Q==@vger.kernel.org, AJvYcCXg3QjKcIJX0v8udzknOY3b8QRSGZn11DXoGZRux0yMoKvnlYPzwjQKkKszufpETMeaRXXEBEPHnTkTpjbP5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwN817UiEqtfrLmF0VjbGBfiHz6i9jbfhRgJxVPzGkYYOIF9OQc
	5MFzgp4y1tERgbPQL+e0qGuWvGvgZgVgwdKzi86b4HRKAxmyPpfBnmVM91mjIQnI2BHYbyF17no
	Ofonzvy+QNIfGpFR7CW1MxVmX8ro=
X-Google-Smtp-Source: AGHT+IHyz3t4mh/Ma9CY3+OXJVqMZPpzgMvEGuwkF3lUwUVVyhQca1X5UObepfUOFyqcM4yMYaf+CNnYaOFacvt5kYo=
X-Received: by 2002:a05:6e02:1c2d:b0:3d2:6768:c4fa with SMTP id
 e9e14a558f8ab-3d280981aa8mr106151405ab.21.1739853513240; Mon, 17 Feb 2025
 20:38:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212234946.yuskayyu4gx3ul7m@jpoimboe> <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe> <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org> <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe> <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe> <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe>
In-Reply-To: <20250214232342.5m3hveygqb2qafpp@jpoimboe>
From: Song Liu <song@kernel.org>
Date: Mon, 17 Feb 2025 20:38:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
X-Gm-Features: AWEUYZmWVnAjpZHf_IwjSwk5YFuj0m13-R4_dyEqp579CYDqISJuAOjL8_IVNKE
Message-ID: <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
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

On Fri, Feb 14, 2025 at 3:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Feb 14, 2025 at 02:04:17PM -0800, Song Liu wrote:
> > Hi Josh,
> >
> > On Fri, Feb 14, 2025 at 11:34=E2=80=AFAM Josh Poimboeuf <jpoimboe@kerne=
l.org> wrote:
> > >
> > > On Fri, Feb 14, 2025 at 09:51:41AM -0800, Song Liu wrote:
> > > > > Ignorant arm64 question: is the module's text further away from s=
lab
> > > > > memory than vmlinux text, thus requiring a different instruction =
(or
> > > > > GOT/TOC) to access memory further away in the address space?
> > > >
> > > > It appears to me the module text is very close to vmlinux text:
> > > >
> > > > vmlinux: ffff8000800b4b68 T copy_process
> > > > module: ffff80007b0f06d0 t copy_process [livepatch_always_inline_sp=
ecial_static]
> > >
> > > Hm... the only other thing I can think of is that the klp relas might=
 be
> > > wrong somewhere.  If you share patched.o and .ko files from the same
> > > build I could take a look.
> >
> > A tarball with these files is available here:
> >
> > https://drive.google.com/file/d/1ONB1tC9oK-Z5ShmSXneqWLTjJgC5Xq-C/view?=
usp=3Ddrive_link
>
> Poking around the arm64 module code, arch/arm64/kernel/module-plts.c
> is looking at all the relocations in order to set up the PLT.  That also
> needs to be done for klp relas, or are your patches already doing that?

I don't think either version (this set and my RFC) added logic for PLT.
There is some rela logic on the kpatch-build side. But I am not sure
whether it is sufficient.

Thanks,
Song

