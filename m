Return-Path: <live-patching+bounces-1304-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B54CA698B8
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 20:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31E077A5A63
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 19:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A65320B808;
	Wed, 19 Mar 2025 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hrl4k9Ii"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF011B0F1E;
	Wed, 19 Mar 2025 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742411370; cv=none; b=goEYBLU0QGeQqZ1uGcI2KqIbY4wz85ILiHvvlqVYAlj+DG1+R2sdlxWSKvmHD9MBCyxK1nPEvvGVNAl6uDdro/iElfDV9rgCslUpDfiUnA4OB0H9j0H8tkOgxy/tbr4C/KMu1GMrjmfhsqN4ROlJ7hdcL6ZrZa81CI6BTzrbHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742411370; c=relaxed/simple;
	bh=RBPLjNUl3VIgCUwL55Iwq9ZNU4VRiwiiacFlXXNL+W4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1faetkmenIdQFO0Y1dm56qtMDqKkweZseiKBCaU6RRkd1ADFcAxnEtQqqvpKkx6F7MRs85vexmBLD6pkq7u5IpfA3HGYy7PkY7ezFKTkRynEM3ke131KbrNjyPxjBkl7u4JHe4SApf5H+aWr37HW5WNIlsX57jzlOXs7m8BKXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hrl4k9Ii; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90770C4CEF0;
	Wed, 19 Mar 2025 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742411369;
	bh=RBPLjNUl3VIgCUwL55Iwq9ZNU4VRiwiiacFlXXNL+W4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Hrl4k9IiaQWTGXLYNzGsGpVTwiTprR2dpXOBSflWxjmlY5daYNpEp2lxZCnbKFk6+
	 ZzayEYLw74sTmo4+R9dFMWxnxK7hcPlTLxZwC9JwDAhXBj7owLhB2sHv6rLse3U7m1
	 UAnVW2Jfe3BqAsxAjVPhhcvoekd9AfL8TncAAchtMXRFMpFhylqEb/o0SW8b6C8ylR
	 XstlzHb0ZxXsLYJjR40rm+8mbLqKI+uL5wGu+NLuNUZmmJqvaMZp9lXXaWkhW4/qW6
	 LAkb6YXBVO8dY4KjlHP1NNkNpFdkJKCaJESNJvwqyhuefufYmSwXH1H79M5YyZlOgr
	 zhpTX1/krz0JQ==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so9655ab.2;
        Wed, 19 Mar 2025 12:09:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVc+uJbc36f3k49CVS0canheJxYv4YjLfNUFmWmjy+zxKhPDkT+MOZZ62UdygvKtaCVAPgyBi79V8NF1DcVZg==@vger.kernel.org, AJvYcCVfyN78PG5sZMepd6CT3iqOUs6lZ7ydO8q1jumceDVkiDGycfPuKzIplzYOGeuY61pPA5jshlp1FX/ACQM=@vger.kernel.org, AJvYcCWGD9cibjahAsjangiYqVVUkDlxHEvKMLY1KXGbaxL0xh0nMXebrCdBZT50Q6rsY/VF9etullh/zooJgwrAcmlVMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw12jHC/z1YqVqoYkqI0aJ9c2NJFaC3mf56WtVmKPGxhtW6Qaph
	6dWPNG2AUJFll8Vs14CfB4AxnyozMH2/yFPnjxsK6LD9PiOxsd+q8T/+wM+Pd1g/WUUAK8G5Ohv
	vD3M8ohFdT9RJhnB1v9TjtBEVrgA=
X-Google-Smtp-Source: AGHT+IFtVevrkFABOINXScOOgA9AGRqqqvUFyxFC0ELSxsLQH4NufJFrZAaqO6/fSKhNBd99jfQ6k4rNWb/XcuksXcE=
X-Received: by 2002:a05:6e02:330a:b0:3d4:4134:521a with SMTP id
 e9e14a558f8ab-3d586b4d53cmr48877015ab.12.1742411368864; Wed, 19 Mar 2025
 12:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ifqn5txrr25ffky7lxtnjtb4b2gekq5jy4fmbiwtwfvofb4wgw@py7v7xpzaqxa> <20250319183757.404779-1-wnliu@google.com>
In-Reply-To: <20250319183757.404779-1-wnliu@google.com>
From: Song Liu <song@kernel.org>
Date: Wed, 19 Mar 2025 12:09:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Zz9EaW3+gtp2Ut-8DVB4F=Dacr2btJ8gL0OA4T6bQzA@mail.gmail.com>
X-Gm-Features: AQ5f1JrvMc2DSMYvOGWV-yPMqfIA-IEZUbcWWmGIrNbqZw7eyyDT2c8uUkJ79Rc
Message-ID: <CAPhsuW7Zz9EaW3+gtp2Ut-8DVB4F=Dacr2btJ8gL0OA4T6bQzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
To: Weinan Liu <wnliu@google.com>
Cc: jpoimboe@kernel.org, indu.bhagat@oracle.com, irogers@google.com, 
	joe.lawrence@redhat.com, kernel-team@meta.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2025 at 11:38=E2=80=AFAM Weinan Liu <wnliu@google.com> wrot=
e:
>
> On Tue, Mar 18, 2025 at 10:39=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> >
> > On Tue, Mar 18, 2025 at 08:58:52PM -0700, Song Liu wrote:
> > > On a closer look, I think we also need some logic in unwind_find_stac=
k()
> > > so that we can see when the unwinder hits the exception boundary. For
> > > this reason, we may still need unwind_state.unreliable. I will look i=
nto
> > > fixing this and send v2.
> >
> > Isn't that what FRAME_META_TYPE_PT_REGS is for?
> >
> > Maybe it can just tell kunwind_stack_walk() to set a bit in
> > kunwind_state which tells kunwind_next_frame_record_meta() to quit the
> > unwind early for the FRAME_META_TYPE_PT_REGS case.  That also has the
> > benefit of stopping the unwind as soon as the exception is encounterd.
> >
>
> After reviewing the code flow, it seems like we should treat all -EINVALI=
D
> cases or `FRAME_META_TYPE_PT_REGS` cases as unreliable unwinds.

Agreed with this: all -EINVALID cases or `FRAME_META_TYPE_PT_REGS`
should be unreliable, IIUC.

>
> Would a simplification like the one below work?
> Or we can return a special value for success cases in kunwind_next_regs_p=
c()
>
> ```
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrac=
e.c
> index 69d0567a0c38..0eb69fa6161a 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -296,7 +296,8 @@ do_kunwind(struct kunwind_state *state, kunwind_consu=
me_fn consume_state,
>                 if (!consume_state(state, cookie))
>                         break;
>                 ret =3D kunwind_next(state);
> -               if (ret < 0)
> +               if (ret < 0 || state->source =3D=3D KUNWIND_SOURCE_REGS_P=
C)
> +                       state->common.unreliable =3D true;

I am current leaning toward not using common.unreliable. It seems to add
unnecessary complexity here. But I may change my mind later on.

Thanks,
Song

>                         break;
>         }
>  }
> ```
>
> --
> Weinan

