Return-Path: <live-patching+bounces-1209-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C1F5A36805
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 23:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12C311719F9
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 22:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF401DF242;
	Fri, 14 Feb 2025 22:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLHVRHFS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2109E1DC9AC;
	Fri, 14 Feb 2025 22:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739570670; cv=none; b=gBIJa3JjnPHJIF0R39y73eKMi7n+KcEfvCakearngX/7v7VXpydUqGw1e9Y87XFdAMkcPxNwMl7eVj9bWmDsXaNJVzMrCVIyR2zOH7GMXvbp7ksAgFpoQRinsxVq43E/KwaA10khGuAwve2YU09ts90hkI6fP74nx1VjBMdY+Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739570670; c=relaxed/simple;
	bh=8tx0cT67YSI1VPWBaLCgbv3IPwa8Ok1vayoF+KkWQtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=au4zdT8luEhz9JjQIgZzHRxkYpJgUPrMCniqmEhU6mtc2SPn9RHKGcQZ+IGrsgHeEwlGAnMs4ERXEzszHjlR3mX1QsHlj9NF0ZTzbsnkcPhajlEo1gNDUk+PM4plk5V7zJWA53noO0fKz2MMfUFeY6WsTgKnJbefPp388A6/1BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLHVRHFS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB24C4CEE7;
	Fri, 14 Feb 2025 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739570669;
	bh=8tx0cT67YSI1VPWBaLCgbv3IPwa8Ok1vayoF+KkWQtI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uLHVRHFS26xxsnGrAv0qqSL+eQvw3BD89SEWx3gGRYKyABEdZwtczWKALmyPcnktM
	 YVZAh6qTRU/1M6JnTGy3tq2Ijwg7k9bUumfrrTVQ8GUj0VBgGLKk6EU8jOC9dmajce
	 dVxMac/mKAfvX+RI450cNQu1kZBEpyhjDbJQd+aZH9D3vf/zMbx2gtpyhIXe6daWtB
	 uJj99Ee2rmka68jrI92rBe4vGBAnPjz2FL2cicKUCUJxdPelNWjH6KLC1qekJKlGeo
	 PuK/ld8z4MlK3ooaNQO0R2GHj8Ar0kMyEzOVJHY0Y2vkQRY/G6z+eAaP2S9evcjfsE
	 ckmJF1LYrNEpg==
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d18f97e98aso16423495ab.3;
        Fri, 14 Feb 2025 14:04:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVZMwyeWAVCbNABsvRp0cia+TZgXv9qI5SyADYa9Zw30qXBlM1Pru4Poe8QHpKI3rjQgyrLS2/qe1BnXyaXSw==@vger.kernel.org, AJvYcCWuG1C9JgrtOjjk4lT6TaEJ1CL81v8cLWfknS5Zqwu/NcYKY5ESrscYgyvSHid/EiXOhXAOEgkzKF0lZlA=@vger.kernel.org, AJvYcCXHkI8dK3riQqXC6g1Wtyufn3qCPX9KE6yp1/4dUD6jKXoVcng8mxFi4moqKq3mQIWUNVJsopULvxEO27UXg1ZR5g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrsa1ZFipMPjIVsrgkaQhKc9nGswyrn6drTKoMjSvYxLk6xOWQ
	onpZRWkrDg253IwAI0fGC90r0qKgFhX+gHN79/rK7IaxUhkZsy4T0qvmtnhOtC/IouKzlM/kEKq
	CljmqvgkchQ7tpOKokf8oYPDH14E=
X-Google-Smtp-Source: AGHT+IGm2i4EXICEpW9bgwkPPolWAFKP9xL/quKy8NddqTVnLPh4rbcjf52ksHT5lD1Rnl/XKRrm4e1eyWcKs15JiNU=
X-Received: by 2002:a92:c24d:0:b0:3cf:bb6e:3065 with SMTP id
 e9e14a558f8ab-3d279694a2emr9486645ab.0.1739570668959; Fri, 14 Feb 2025
 14:04:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe> <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe> <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org> <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe> <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe>
In-Reply-To: <20250214193400.j4hp45jlufihv5eh@jpoimboe>
From: Song Liu <song@kernel.org>
Date: Fri, 14 Feb 2025 14:04:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
X-Gm-Features: AWEUYZmS9RgABXm_Z225NGGKzm18Fgmh_MxPC45lJBV_7EfAVM8AuVs83nd2IRc
Message-ID: <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
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

Hi Josh,

On Fri, Feb 14, 2025 at 11:34=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Fri, Feb 14, 2025 at 09:51:41AM -0800, Song Liu wrote:
> > > Ignorant arm64 question: is the module's text further away from slab
> > > memory than vmlinux text, thus requiring a different instruction (or
> > > GOT/TOC) to access memory further away in the address space?
> >
> > It appears to me the module text is very close to vmlinux text:
> >
> > vmlinux: ffff8000800b4b68 T copy_process
> > module: ffff80007b0f06d0 t copy_process [livepatch_always_inline_specia=
l_static]
>
> Hm... the only other thing I can think of is that the klp relas might be
> wrong somewhere.  If you share patched.o and .ko files from the same
> build I could take a look.

A tarball with these files is available here:

https://drive.google.com/file/d/1ONB1tC9oK-Z5ShmSXneqWLTjJgC5Xq-C/view?usp=
=3Ddrive_link

> BTW, I realized the wrong function size shown in the WARNING stack trace
> is probably just due to a kallsyms quirk.  It calculates a symbol's size
> by subtracting its start address from the next symbol's start address.
> It doesn't actually use the ELF symbol size.  So the next symbol after
> copy_process() in the loaded module's address space might just be far
> away.

Yeah, I also think kallsyms logic was the issue here. So it is not the same
as the gdb-disassembly issue.

> That kallsyms issue has caused other headaches.  It really needs to be
> fixed to use the actual ELF symbol size.

Maybe we should have a "module_text_end" symbol?

Thanks,
Song

