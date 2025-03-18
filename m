Return-Path: <live-patching+bounces-1299-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E67AA680CE
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 00:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 352213B50A6
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 23:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1F32080EA;
	Tue, 18 Mar 2025 23:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfg4eMKC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA5E207E04;
	Tue, 18 Mar 2025 23:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742341112; cv=none; b=LT2W3axZ3r9lPJJYziGIC8T6XncIpB83B8JQKibBFrR7/wGZqcMd0vM9njk1ZiZYCg3DXCbr6aYuLZXXG0g2UljaGZ6HzwSDHcDcj3k3Yotbm3D2y6MR4h64pZcUo/aRts3MHjIupoFgGTq/6RYbNtIeAamSevK82Pj3T/i3CFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742341112; c=relaxed/simple;
	bh=0sQP/zy1cL6eeBuTAfDEdObSUHX4VZnFu6uuqYNdUys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLzoJiqU2ddO8VoVMIuV/DdxCAdqVHfN40GZmF7rdsg22JgGDjA/KRjyVufVPwamH9+pyWLkop4c/O3gCP2nHr5E1tdcdoCKJupTkODbUY+ONnQNsWIahFk1uVV91eNItzURBNBFsp8kz6ynTHjkJy/o1zUNxsVf0rUrsC5/azI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfg4eMKC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD41C4CEEF;
	Tue, 18 Mar 2025 23:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742341111;
	bh=0sQP/zy1cL6eeBuTAfDEdObSUHX4VZnFu6uuqYNdUys=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cfg4eMKC+MvpNTaYUMsIXAGN85HMvYj07b54oSwplDmlPdo66jG0+4aukWogfuiQ2
	 me93orZHwD6lCeq1K2z+7g4eD/GBytmoCeXKUZSts6BeW8qLbNioCMcLpd5L4k/hbB
	 rXJooKVhyfeUQXcqm8/t9S8kyiABpbKIo73tgFqDR4P7uapJ2UKA4ATlIvOcquc65w
	 f4XLS0K6pHO1m2LCupXR5f6gDxNzsXtmgnELfQKWUOtIbCEG90ha/Y0mruSQsh+VD3
	 z/97bkWuWTAD9oYrIYOehuFa7JF0IFpWgHK3QhQSN1CpSXJGcDdf2mBlg97cAe6Dxe
	 1FnxfrNK0Z/nQ==
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d4502ca096so15961735ab.0;
        Tue, 18 Mar 2025 16:38:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV5Lxu3QSLSDd4Xzxgg5EDIa3nre/IAyXH9IBR4Cc8TIBT2zT2KLkUI+HMlm6gz7AgJP2X/H6lo2AsXABQ=@vger.kernel.org, AJvYcCV7DGncjyLS+cPrj4lNNJWE7V2vDCZXLVvEYwlo1jYZQM6uoaSrdMCJlrk72ypdhrN9guY9agLrGDl7Xw2dMQ==@vger.kernel.org, AJvYcCVeEnv7iKJ+xrzwX1OWFW6+/3FoUXjQ5hPr3S3gekRjxjVAGDBNhERGaaY44eyPRhzM5krUB+Ba6pceqlEE6QnugA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yylw/GVrNzESvcABJdRqYm0vlD4CdN+KB5UgIUeWn+aPPJK+3XA
	9f/56ywA0AHYkLg19864DSySNAE//hWpQsJuIDIVP6imd4VKecQlkJh2gp4qN+/LMHj4Djw96tS
	XWMo3Gkr0DIAIgcyB8b8Bk9Iciio=
X-Google-Smtp-Source: AGHT+IHS3zxaZCTk4uR7+SQt6Hjo61e5reTYmle1fxQ8GKm4FJb/GLNLIm9puqPCgCkzg8mO2W7H5OI9Xo6AifIFdRk=
X-Received: by 2002:a05:6e02:1d17:b0:3d3:ced4:db9b with SMTP id
 e9e14a558f8ab-3d586b22364mr6299555ab.5.1742341111256; Tue, 18 Mar 2025
 16:38:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308012742.3208215-1-song@kernel.org> <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
 <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com> <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
In-Reply-To: <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 16:38:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com>
X-Gm-Features: AQ5f1JrnxVeS0Z8vx1n1BCVHGIXjcVuS53wswCJJXs_3YpwJGWyuN8X5JtywC-A
Message-ID: <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, mark.rutland@arm.com, 
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 4:00=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Mar 18, 2025 at 01:14:40PM -0700, Song Liu wrote:
> > >
> > > See for example all the error conditions in the x86 version of
> > > arch_stack_walk_reliable() and in arch/x86/kernel/unwind_frame.c.
> >
> > I guess I missed this part:
> >
> > diff --git i/arch/arm64/kernel/stacktrace.c w/arch/arm64/kernel/stacktr=
ace.c
> > index 69d0567a0c38..3bb8e3ea4c4b 100644
> > --- i/arch/arm64/kernel/stacktrace.c
> > +++ w/arch/arm64/kernel/stacktrace.c
> > @@ -268,6 +268,8 @@ kunwind_next(struct kunwind_state *state)
> >         case KUNWIND_SOURCE_TASK:
> >         case KUNWIND_SOURCE_REGS_PC:
> >                 err =3D kunwind_next_frame_record(state);
> > +               if (err && err !=3D -ENOENT)
> > +                       state->common.unreliable =3D true;
> >                 break;
> >         default:
> >                 err =3D -EINVAL;
>
> I still see some issues:
>
>   - do_kunwind() -> kunwind_recover_return_address() can fail
>
>   - do_kunwind() -> consume_state() can fail

Great points! I have got the following:

diff --git i/arch/arm64/kernel/stacktrace.c w/arch/arm64/kernel/stacktrace.=
c
index 69d0567a0c38..852e4b322209 100644
--- i/arch/arm64/kernel/stacktrace.c
+++ w/arch/arm64/kernel/stacktrace.c
@@ -139,6 +139,7 @@ kunwind_recover_return_address(struct kunwind_state *st=
ate)
                                                (void *)state->common.fp);
                if (state->common.pc =3D=3D orig_pc) {
                        WARN_ON_ONCE(state->task =3D=3D current);
+                       state->common.unreliable =3D true;
                        return -EINVAL;
                }
                state->common.pc =3D orig_pc;
@@ -268,6 +269,8 @@ kunwind_next(struct kunwind_state *state)
        case KUNWIND_SOURCE_TASK:
        case KUNWIND_SOURCE_REGS_PC:
                err =3D kunwind_next_frame_record(state);
+               if (err && err !=3D -ENOENT)
+                       state->common.unreliable =3D true;
                break;
        default:
                err =3D -EINVAL;
@@ -404,12 +407,16 @@ static __always_inline bool
 arch_kunwind_reliable_consume_entry(const struct kunwind_state
*state, void *cookie)
 {
        struct kunwind_reliable_consume_entry_data *data =3D cookie;
+       bool ret;

        if (state->common.unreliable) {
                data->unreliable =3D true;
                return false;
        }
-       return data->consume_entry(data->cookie, state->common.pc);
+       ret =3D data->consume_entry(data->cookie, state->common.pc);
+       if (!ret)
+               data->unreliable =3D true;
+       return ret;
 }

 noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn
consume_entry,


>   - even in the -ENOENT case the unreliable bit has already been set
>     right before the call to kunwind_next_frame_record_meta().

For this one, do you mean we set state->common.unreliable, but
failed to propagate it to data.unreliable?

Thanks,
Song

