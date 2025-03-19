Return-Path: <live-patching+bounces-1301-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7885A68404
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 04:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F7E9189D57C
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 03:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F60C24E4C7;
	Wed, 19 Mar 2025 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f62a7Y7e"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65429A2;
	Wed, 19 Mar 2025 03:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742356744; cv=none; b=Fd2zJD4iakQa6gE94zN2KBNZSVycY8OgZX56FrSVizb4AIxFTnwW0Ma8/zS1zwsSlMz4TI+l3vMZ7aqobUOkXguxqGjVY8H5g7SVU52211aupxkv7Xpv2yHBaBaKN6H30ztCobe+FOXM1x2evp6GSC/lNQKtKZYuuYpT0Kd8TNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742356744; c=relaxed/simple;
	bh=nJdePGolDOxThuT4ThxqJ1hMOvDDzgOCApbzNq/083I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtPl8O8g/tx0nLmCGLJ+NunckGa3MhOJCEOc431DGtCUl9s3P8uhmYLzF7l7sd+hC4V5dXD7vSPkBcppc6EYZoSp2GXD4xpfapEcg2ONjTa4x2MOzka5ke00FhIAdLko4L2SA2LgDHVGqP6u11MqJGThP/6Lw2aJSTKnfJZf/08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f62a7Y7e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDBC4CEF0;
	Wed, 19 Mar 2025 03:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742356743;
	bh=nJdePGolDOxThuT4ThxqJ1hMOvDDzgOCApbzNq/083I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f62a7Y7eQEz8j24i1zwa4EnttCuxmn4ead+oTqajI3jCk6BrPUsMktAAG/S4RJoXB
	 2y8C+Tw4Ab48scWnjlZy5UTpdde3/ri7v5V/0ArG+7z2VDMe3QBq2U/cZQONwSXx1k
	 LgFxVBqvOd4tPrgIpHwNkRyhPKIKdnSQ7onxIDdEox50Z1qy+J9oIwpnCN1OHW5hrg
	 ubtDzTk+bNlbjJohh61xOTTsmv6ZOajJFSTYTFhig6Q1iGIddZuA9Cq9U4kFNeknHq
	 86FwywN5VdHHxuJpb/3vEA/wvKKTx09i9N7usXotXuT3kIAfSZBHei+hC6tCLHdMTG
	 3m0sl7tp80vwQ==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d58908c43fso242985ab.0;
        Tue, 18 Mar 2025 20:59:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWdpJGcsmyBqpXp1WhVdtVk3Y8ljAp4/jegU/z/CHayzloYBSgOdcha6zoasc/XlY5QBmIrQodZKVUqL8/2nEP8zw==@vger.kernel.org, AJvYcCXBdyGz6DX4DUQIXhSTUiI7VWT9xEWptcbwHNTsRyKMhPsR5brCYRpOdgB/a/JMIPgxon4ZlLG2KgfZExM=@vger.kernel.org, AJvYcCXLUVqrShjUfDCHjzFToIwmoPKP2vy2xI5WR6SWnBwwteK6abPtOTvM9QurtdIM2T27nDmvzBfhWanny0K2AA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBFcyAJH/lJO0hQlfYtd2p9aGYKunltPOtILM65R23w96TW4u4
	Qv6kXDa9Sucs3C1iy3cvHaojNHeJIMemiDvFLL9YTM5qGIaTZuhUfAGqHBrBfVw2nP7DFVM4lYO
	Ju8DEflpFPEDFHD8bBgKI3EBhWWU=
X-Google-Smtp-Source: AGHT+IGhlzOUomoHZuyt8hTr9krnohQDGxaTZPrFGMMN4mUZ/OdCXyZ4UpJNV9IGF0TuiKDCHyPwaobT5UyUdnL7UCY=
X-Received: by 2002:a92:c246:0:b0:3d3:f64a:38b9 with SMTP id
 e9e14a558f8ab-3d586ba4e4amr12677985ab.15.1742356743031; Tue, 18 Mar 2025
 20:59:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308012742.3208215-1-song@kernel.org> <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
 <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
 <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
 <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com> <pym6gfbapfy6qlmduszjk6tf2oc2fv4rtxgwjgex7bwlgpfwvs@bkt7qfmf7rc4>
In-Reply-To: <pym6gfbapfy6qlmduszjk6tf2oc2fv4rtxgwjgex7bwlgpfwvs@bkt7qfmf7rc4>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 20:58:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6_ZA+V_5JK+xy4v3pyQ-kaZzUooxO=4L+c95fHaW38ig@mail.gmail.com>
X-Gm-Features: AQ5f1JqUKV77-11Llcj708ejD78WXiysKYghH5KgEYTc37jjnaWgIAoDKjabSdQ
Message-ID: <CAPhsuW6_ZA+V_5JK+xy4v3pyQ-kaZzUooxO=4L+c95fHaW38ig@mail.gmail.com>
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

On Tue, Mar 18, 2025 at 6:03=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Mar 18, 2025 at 04:38:20PM -0700, Song Liu wrote:
> > On Tue, Mar 18, 2025 at 4:00=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >   - even in the -ENOENT case the unreliable bit has already been set
> > >     right before the call to kunwind_next_frame_record_meta().
> >
> > For this one, do you mean we set state->common.unreliable, but
> > failed to propagate it to data.unreliable?
>
> Hm, I hadn't noticed that.  That code is quite the maze.
>
> It's unfortunate there are two separate 'unreliable' variables.  It
> looks like consume_state() is the only way they get synced?
>
> How does that work if kunwind_next() returns an error and skips
> consume_state()?  Or if kunwind_recover_return_address() returns an
> error to kunwind_next()?
>
> What I actually meant was the following:
>
>   do_kunwind()
>     kunwind_next()
>       kunwind_next_frame_record()
>         state->common.unreliable =3D true;
>         kunwind_next_frame_record_meta()
>           return -ENOENT;
>
> Notice that in the success case (-ENOENT), unreliable has already been
> set.
>
> Actually I think it would be much simpler to just propagate -ENOENT down
> the call chain.  Then no 'unreliable' bits needed.

Yeah, I was thinking about something like this. This is actually quite
similar to my original RFC version.

On a closer look, I think we also need some logic in unwind_find_stack()
so that we can see when the unwinder hits the exception boundary. For
this reason, we may still need unwind_state.unreliable. I will look into
fixing this and send v2.

Thanks,
Song

>
> Like so (instead of original patch):
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index c9fe3e7566a6..5713fad567c5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -276,6 +276,7 @@ config ARM64
>         select HAVE_SOFTIRQ_ON_OWN_STACK
>         select USER_STACKTRACE_SUPPORT
>         select VDSO_GETRANDOM
> +       select HAVE_RELIABLE_STACKTRACE
>         help
>           ARM 64-bit (AArch64) Linux support.
>
> @@ -2509,4 +2510,3 @@ endmenu # "CPU Power Management"
>  source "drivers/acpi/Kconfig"
>
>  source "arch/arm64/kvm/Kconfig"
> -
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrac=
e.c
> index 1d9d51d7627f..e227da842bc3 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -277,22 +277,28 @@ kunwind_next(struct kunwind_state *state)
>
>  typedef bool (*kunwind_consume_fn)(const struct kunwind_state *state, vo=
id *cookie);
>
> -static __always_inline void
> +static __always_inline int
>  do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state=
,
>            void *cookie)
>  {
> -       if (kunwind_recover_return_address(state))
> -               return;
> +       int ret;
> +
> +       ret =3D kunwind_recover_return_address(state);
> +       if (ret)
> +               return ret;
>
>         while (1) {
>                 int ret;
>
>                 if (!consume_state(state, cookie))
> -                       break;
> +                       return -EINVAL;
> +
>                 ret =3D kunwind_next(state);
> -               if (ret < 0)
> -                       break;
> +               if (ret)
> +                       return ret;
>         }
> +
> +       return -EINVAL;
>  }
>
>  /*
> @@ -324,7 +330,7 @@ do_kunwind(struct kunwind_state *state, kunwind_consu=
me_fn consume_state,
>                         : stackinfo_get_unknown();              \
>         })
>
> -static __always_inline void
> +static __always_inline int
>  kunwind_stack_walk(kunwind_consume_fn consume_state,
>                    void *cookie, struct task_struct *task,
>                    struct pt_regs *regs)
> @@ -352,7 +358,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
>
>         if (regs) {
>                 if (task !=3D current)
> -                       return;
> +                       return -EINVAL;
>                 kunwind_init_from_regs(&state, regs);
>         } else if (task =3D=3D current) {
>                 kunwind_init_from_caller(&state);
> @@ -360,7 +366,7 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
>                 kunwind_init_from_task(&state, task);
>         }
>
> -       do_kunwind(&state, consume_state, cookie);
> +       return do_kunwind(&state, consume_state, cookie);
>  }
>
>  struct kunwind_consume_entry_data {
> @@ -387,6 +393,25 @@ noinline noinstr void arch_stack_walk(stack_trace_co=
nsume_fn consume_entry,
>         kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs)=
;
>  }
>
> +noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn con=
sume_entry,
> +                       void *cookie, struct task_struct *task)
> +{
> +       int ret;
> +       struct kunwind_consume_entry_data data =3D {
> +               .consume_entry =3D consume_entry,
> +               .cookie =3D cookie,
> +       };
> +
> +       ret =3D kunwind_stack_walk(arch_kunwind_consume_entry, &data, tas=
k, NULL);
> +       if (ret) {
> +               if (ret =3D=3D -ENOENT)
> +                       return 0;
> +               return ret;
> +       }
> +
> +       return -EINVAL;
> +}
> +
>  struct bpf_unwind_consume_entry_data {
>         bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
>         void *cookie;

