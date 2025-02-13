Return-Path: <live-patching+bounces-1183-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2351A34E8D
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 20:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C99616D141
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 19:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5B724A048;
	Thu, 13 Feb 2025 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8uFnfRO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB1E245B1B;
	Thu, 13 Feb 2025 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739475656; cv=none; b=LllbnK5Svsg9s3QNLZjwYxkxdEiXe/ZnK3yP+23wxocCqSsyBN57T9uirAroEVoTe8gzU/Ae+A5eZD+BMV51aEf16RE5RsC0uPkwmivop9utx8FGLAKu2WBLTchDXWjDxzyKvnJSptD3wpwIeVJVjB3JWxdAqXYU91WArLMXqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739475656; c=relaxed/simple;
	bh=2fD/8NcdfM1XFbfMLJwPpFgwUB/k7cAYGRhasfPcpQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TY/U5k2i5bvyFPw2eANE4G24Az2yffZvthn4gx7I2ASZowaHJzy/agCB/wK3tA5iYSThPrkhJBFk8jz6UfsIyEnVmtmHAPT54+TJxO8qFK3IeaWhHWVrqeSqZJHzfhWUoBSwQrPpjgRD5R2CGvZaVLsM/gazRlSicTGKkA6vxAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8uFnfRO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE15C4AF0B;
	Thu, 13 Feb 2025 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739475655;
	bh=2fD/8NcdfM1XFbfMLJwPpFgwUB/k7cAYGRhasfPcpQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H8uFnfROeMJpAeSDmyUkDIVWosH2ICc28ajPKK3oO2cVTP4saSj/Jxpk1Il/cz+/R
	 DG8UBXzjBNXDGb07I+nxpw5t4+Az5MXk9bFeZHXyIcDO9oA5CWf+FwLneFU0Ze5QmI
	 KNR/Gyv04bJfehFfRA9/GNJDToYqZSZ1QNEO3lQS7k1MdjEcjqtnvkZ/TnjDiXVp22
	 /YP+WpUNHYvOcjjHxQZjKGcIiKgDhXt6iQkj+LZ41LPCDLtlbPW4WBz66iDXu6zCQq
	 X9xuH6VO5fLgtZL1Ut0K98Q+pKj0RGOtg6nozKkEmm9PA/eqbOkdaP+KH1s4dDcOdE
	 jLRel+GaosQuw==
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d03ac846a7so4038935ab.2;
        Thu, 13 Feb 2025 11:40:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVKQL6O1FRUb19Qeh10qdoQ6UepnWlTFPs0/VUibaLdscMOp3Qn7dJJnMg7pgrRCv9OjFuLLIjhU8DyD7+B8g==@vger.kernel.org, AJvYcCW9eXK+7d6JSrtg3L8CQj1Wm9RT/HtCSpODAPoNew2wfvsHov7Jc3L12RLJbArHGPMh37bMcTBXOwILqoE=@vger.kernel.org, AJvYcCXK2OOU53OtgBYrucSKNpSRjoMKxHt8o8pOLGfBhJUyk9YhhQCU4bBi4WdS7qPOAdgBCsjyL+NZaJ5gspQOPY7Mhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVws3WbqmOobVHU++zX+LUEuOb+bT8YudhhEk8M0Nrh+TrjSLq
	RX3BUTdgwJJvWnAW43eTWPyEFoVug8aymBZbCgGt3Ajol8sLoVxWe2tFF6ZSIuUFCIofjJiXi+H
	eHy5mBIsiPIFtxba5/V5spA0f4Ew=
X-Google-Smtp-Source: AGHT+IF+5ylYJUZMlWYWg/QDJ6Iijw0EymWMIzglKMEAh/hwvS5o8pbwP7TnThM1fM/rhQGM0ldnxer/uBQ+WAhXQyY=
X-Received: by 2002:a05:6e02:17ce:b0:3d0:24c0:bd3e with SMTP id
 e9e14a558f8ab-3d17be19829mr79268695ab.7.1739475654602; Thu, 13 Feb 2025
 11:40:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe> <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe> <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org>
In-Reply-To: <mb61py0yaz3qq.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Feb 2025 11:40:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
X-Gm-Features: AWEUYZleA2B0b6poFrS6Aosm-qV1fwd6duC3JQfY8JcX-3-CY1Sgbtn8ypNzvx0
Message-ID: <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 11:46=E2=80=AFPM Puranjay Mohan <puranjay@kernel.or=
g> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > On Wed, Feb 12, 2025 at 6:45=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> >>
> >> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
> >> > > > [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_sta=
tic]
> >> > >
> >> > > Does that copy_process+0xfdc/0xfd58 resolve to this line in
> >> > > copy_process()?
> >> > >
> >> > >                         refcount_inc(&current->signal->sigcnt);
> >> > >
> >> > > Maybe the klp rela reference to 'current' is bogus, or resolving t=
o the
> >> > > wrong address somehow?
> >> >
> >> > It resolves the following line.
> >> >
> >> > p->signal->tty =3D tty_kref_get(current->signal->tty);
> >> >
> >> > I am not quite sure how 'current' should be resolved.
> >>
> >> Hm, on arm64 it looks like the value of 'current' is stored in the
> >> SP_EL0 register.  So I guess that shouldn't need any relocations.
> >>
> >> > The size of copy_process (0xfd58) is wrong. It is only about
> >> > 5.5kB in size. Also, the copy_process function in the .ko file
> >> > looks very broken. I will try a few more things.
> >
> > When I try each step of kpatch-build, the copy_process function
> > looks reasonable (according to gdb-disassemble) in fork.o and
> > output.o. However, copy_process looks weird in livepatch-special-static=
.o,
> > which is generated by ld:
> >
> > ld -EL  -maarch64linux -z norelro -z noexecstack
> > --no-warn-rwx-segments -T ././kpatch.lds  -r -o
> > livepatch-special-static.o ./patch-hook.o ./output.o
> >
> > I have attached these files to the email. I am not sure whether
> > the email server will let them through.
>
> I think, I am missing something here,
>
> I did :
>
> objdump -Dr livepatch-special-static.o | less
>
> and
>
> objdump -Dr output.o | less
>
> and the disassembly of copy_process() looks exactly same.

Yeah, objdump does show the same disassembly. However, if
I open the file with gdb, and do "disassemble copy_process",
the one in livepatch-special-static.o looks very weird.

Thanks,
Song

