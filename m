Return-Path: <live-patching+bounces-1189-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1407CA3524C
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 00:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B095C16B05B
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 23:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED8E1C84CD;
	Thu, 13 Feb 2025 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9L6Hg/j"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F474275419;
	Thu, 13 Feb 2025 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739490477; cv=none; b=tTX4xvzb+kzdvEcsUU7/J6nkLBjknPxPxcev3KHsvQyYCB750dh5haBkVBwou0xn/cQwV0FEZ4/PHk+Ez2vyoisHpRp0dcmTM8H1nGLvSBrB3Qdq676ZtFrn45jb3tSJWQwJhxahVqzzuNUmyIMLfaEkorW9V/teIQ5kpiakzGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739490477; c=relaxed/simple;
	bh=5SJx2c5idPtQ+TpjdTaSRIBI12bZOmVEX8rAfHtVvW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jHJgLtL0ooZDIckztgAwE02DBFlwbrdZwm24Qbv81o6PylwTmlXq/QQlrPP4xRKA6C6WLykQpA8azgYp80ZF1IklVFLQ9FuP1/7q153VWOlpSUr0JZDIexXJDurQrmFIAkw5Oy4p2lMLnHuI4SryrB7N4+Ft5nUnzT5+1N9+kDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9L6Hg/j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B824CC4CEE9;
	Thu, 13 Feb 2025 23:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739490475;
	bh=5SJx2c5idPtQ+TpjdTaSRIBI12bZOmVEX8rAfHtVvW0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q9L6Hg/joNGQ78nyawUZS4SzDmRVUbDP6L/zPjOCw1lVUme+kFNL7taPsENVLJW3i
	 ceUQCWD5SM2v1OMt4UJXXrDfOW9U9jxXezJcjR0Cvm6b26i8nb2E+IiOKW1j9aKML2
	 mMYo2du3kTqJfUxnDtM/zmYg8H1/r4el9DEK48eURvvatDPzEghaBtVr7HG6vaUToW
	 Szk/GEMaVbWcBX2Kt4r447kCQUn6YjIpOaRySFQ6VERIbgF+cL+/N+bjnym2dxsgF+
	 ZHI+/wYJwZfk3OfgZyaBLYXweQCZSraBYhYaIlp+44qpugJAAyW/wanLVk0ZMVEq8M
	 nzlix4OlWjtPg==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d19d214f0aso1132045ab.1;
        Thu, 13 Feb 2025 15:47:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV6uUlz5EN1MlwS1c6+v9u82EFtHnbwYooHqm+hoh0BM5UrMRpQnPtFJzLeijgYL8FnUEYa0VzVxOCVrvHsMw==@vger.kernel.org, AJvYcCVy3QHqz6Mjs/85OmXnqsBwMkvtaH/7I+/AcQ+gTnulPEjI65ezgZ44ZXpxtBNCYU6DZjFTNt3kepmQLjp1TGQU9Q==@vger.kernel.org, AJvYcCXtPYMA3zegUohvFWqTSxvBgTBN0pu+ThCu5zXEwaZFS+E+p7Yc5QSMoVgrN30jkFOs7DjumUYA5JnohyU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD4r5IxNHvZrhUDhWsBP8OuedqbdlsMxmdGJV5G9CzWVHIQzfa
	65vrJG+xsqLqHLYUHX4dmweGR9dIDfMmKjEDwqygASRiGPEFofo0paXNzu4W/fDPxbSagVf/DNO
	tvFnKbvLewnTWiZiApM3ctQAgOhY=
X-Google-Smtp-Source: AGHT+IERb3JVMz6pWb90bweOcAh9ut0V3OsQ1ifWR3S6vi2/jG0zXD+AnKlKMrWBqIaF3CVMTic6GM8MIf5ykYA2sq8=
X-Received: by 2002:a05:6e02:1fe8:b0:3cf:bb3e:884c with SMTP id
 e9e14a558f8ab-3d17bfddbd5mr82410445ab.16.1739490475076; Thu, 13 Feb 2025
 15:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe> <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe> <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
In-Reply-To: <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Feb 2025 15:47:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW40ibipv5XbSnf27tEHDgNF7zQ8_o92qH7dGcH_1Rj9zA@mail.gmail.com>
X-Gm-Features: AWEUYZnQ6VFx06Li1Cy7ZO825UOUqK0v69jwOyZGyN4BN3juNeJy7TWbn4ScxCU
Message-ID: <CAPhsuW40ibipv5XbSnf27tEHDgNF7zQ8_o92qH7dGcH_1Rj9zA@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Indu Bhagat <indu.bhagat@oracle.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 3:23=E2=80=AFPM Indu Bhagat <indu.bhagat@oracle.com=
> wrote:
>
> On 2/12/25 11:25 PM, Song Liu wrote:
> > On Wed, Feb 12, 2025 at 6:45=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> >>
> >> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
> >>>>> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static=
]
> >>>>
> >>>> Does that copy_process+0xfdc/0xfd58 resolve to this line in
> >>>> copy_process()?
> >>>>
> >>>>                          refcount_inc(&current->signal->sigcnt);
> >>>>
> >>>> Maybe the klp rela reference to 'current' is bogus, or resolving to =
the
> >>>> wrong address somehow?
> >>>
> >>> It resolves the following line.
> >>>
> >>> p->signal->tty =3D tty_kref_get(current->signal->tty);
> >>>
> >>> I am not quite sure how 'current' should be resolved.
> >>
> >> Hm, on arm64 it looks like the value of 'current' is stored in the
> >> SP_EL0 register.  So I guess that shouldn't need any relocations.
> >>
> >>> The size of copy_process (0xfd58) is wrong. It is only about
> >>> 5.5kB in size. Also, the copy_process function in the .ko file
> >>> looks very broken. I will try a few more things.
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
> >
> > Indu, does this look like an issue with ld?
> >
>
> Sorry for the delay.
>
> Looks like there has been progress since and issue may be elsewhere, but:
>
> FWIW, I looked at the .sframe and .rela.sframe sections here, the data
> does look OK.  I noted that there is no .sframe for copy_process () in
> output.o... I will take a look into it.

That output.o was generated with a version of kpatch-build that blindly
removes all .sframe sections.

Thanks,
Song

