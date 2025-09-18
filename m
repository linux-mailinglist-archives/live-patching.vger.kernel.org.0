Return-Path: <live-patching+bounces-1720-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73684B83B8E
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 11:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D3204A763C
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 09:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8103A2FFDC6;
	Thu, 18 Sep 2025 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDHTxIw7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4972FF644
	for <live-patching@vger.kernel.org>; Thu, 18 Sep 2025 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758186873; cv=none; b=EXPJ+UEA12MyT63qATkKAtQH1s3SKlCZPAtv95OmNWamnTi1vU2H6Xqxz4JC/8m7ynaGFMsNIkcB1ANBQ4xHMBPcfCOHms64TIpbEYiugIetE87dOH2+XhaJrG2HLDVwtjt87ZZz1NkF/+gVWeQPTnPgqwAWGL2V1+t6qYMrr6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758186873; c=relaxed/simple;
	bh=GU5aVhSSXpMnY3Nj89JQ3GLJp6CGYNfWRvVTeDhHpyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3te0ncZGV96qchAxwQpid9G0cs3gZG+4hinbK9CTfd+ygRc6Kbut7CY71fPmST3YOLPsY4JnXv4wilsDYhxPHm0qpmImrwaMqCNh0r3qg3JhC3KxEcvu6w3yZMisLETotL2D9Asvuyh/kISgFcQdJASWy+Scdb+AZ08IWiSw2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDHTxIw7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D16EC4CEF7
	for <live-patching@vger.kernel.org>; Thu, 18 Sep 2025 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758186873;
	bh=GU5aVhSSXpMnY3Nj89JQ3GLJp6CGYNfWRvVTeDhHpyU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XDHTxIw7akXSeCd/6giZZN/EAt0R0GTTlgV8enplzm7SaERhP1HEeN+pZ9tCCwJXx
	 PZu7fwkAHzTwUVdL480d09AvH8gp+9ocf3kzauUZadgVa/AFh0I7wZJzm3L5La/weH
	 cgIMoqkpQtBfUF1b3sYCDlpcavGJKijlHNbO5JLbMt1kOpVeP9mqKF7Y69Lxg0cCIT
	 Xf7iJSWCK3696D7IFyWNLVEBQn2zc660kn4KuT6kYHnTZd91Z/UIBB8L/fDuoAFlJT
	 +6k+q0PyY38TGXrIgdBXKCUV96pbf6IGYeNsHICIXaABgKJEv6tjqtlVA9FvXBVTyP
	 UMt+ASqVOU/Rw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b0473327e70so128159466b.3
        for <live-patching@vger.kernel.org>; Thu, 18 Sep 2025 02:14:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVCJi3GOJtTyFBmwwGJYk2CIgfW4c+8pLF4qw+wA8WMUd9RNQtCAdDc6Y4Zla+dwHsHNR7FTjolPcktFtMF@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv1OB9Q2wYxumPpLquEDtwawWDZ07NdBUn14vsmbkPjZfUMChu
	+WwcnU0+lpnEDrukPb/qMzivEerP4P7S2iKk/FiIHRl64USImSTcDMuaQ6bZ4QNhoh7VOGMMxhD
	dg1MsqkKWcUcuOqsmfb+ccSCT6AFhPFY=
X-Google-Smtp-Source: AGHT+IF1BjXj0ZvF7mFwzpXfamZnsfZVnnhQOoLa3JpgQAVAsKAIPCGthRx+T49FvQxBTK2pZaT9a6cJBVcJy9ub2no=
X-Received: by 2002:a17:907:7ea0:b0:b04:3d7b:ad43 with SMTP id
 a640c23a62f3a-b1bb8ca599amr612012266b.40.1758186871662; Thu, 18 Sep 2025
 02:14:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916093509.17306-1-yangtiezhu@loongson.cn>
In-Reply-To: <20250916093509.17306-1-yangtiezhu@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 18 Sep 2025 17:14:19 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5qBQyVX+h8is8w52Vi15EBcGfByrawPz6sGTkRELWZVw@mail.gmail.com>
X-Gm-Features: AS18NWCF5A_ggky4Y36CkYbZfHI2uT8b9CtWO_QYbecJRYeJ8nY8o6Wj8hseLyE
Message-ID: <CAAhV-H5qBQyVX+h8is8w52Vi15EBcGfByrawPz6sGTkRELWZVw@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: Fix unreliable stack for live patching
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Xi Zhang <zhangxi@kylinos.cn>, live-patching@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Tue, Sep 16, 2025 at 5:35=E2=80=AFPM Tiezhu Yang <yangtiezhu@loongson.cn=
> wrote:
>
> When testing the kernel live patching with "modprobe livepatch-sample",
> there is a timeout over 15 seconds from "starting patching transition"
> to "patching complete", dmesg shows "unreliable stack" for user tasks
> in debug mode, here is one of the messages:
>
>   livepatch: klp_try_switch_task: bash:1193 has an unreliable stack
>
> The "unreliable stack" is because it can not unwind from do_syscall()
> to its previous frame handle_syscall(), it should use fp to find the
> original stack top due to secondary stack in do_syscall(), but fp is
> not used for some other functions, then fp can not be restored by the
> next frame of do_syscall(), so it is necessary to save fp if task is
> not current to get the stack top of do_syscall().
>
> Here are the call chains:
>
>   klp_enable_patch()
>     klp_try_complete_transition()
>       klp_try_switch_task()
>         klp_check_and_switch_task()
>           klp_check_stack()
>             stack_trace_save_tsk_reliable()
>               arch_stack_walk_reliable()
>
> When executing "rmmod livepatch-sample", there exists the similar issue.
> With this patch, it takes a short time for patching and unpatching.
>
> Before:
>
>   # modprobe livepatch-sample
>   # dmesg -T | tail -3
>   [Sat Sep  6 11:00:20 2025] livepatch: 'livepatch_sample': starting patc=
hing transition
>   [Sat Sep  6 11:00:35 2025] livepatch: signaling remaining tasks
>   [Sat Sep  6 11:00:36 2025] livepatch: 'livepatch_sample': patching comp=
lete
>
>   # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
>   # rmmod livepatch_sample
>   rmmod: ERROR: Module livepatch_sample is in use
>   # rmmod livepatch_sample
>   # dmesg -T | tail -3
>   [Sat Sep  6 11:06:05 2025] livepatch: 'livepatch_sample': starting unpa=
tching transition
>   [Sat Sep  6 11:06:20 2025] livepatch: signaling remaining tasks
>   [Sat Sep  6 11:06:21 2025] livepatch: 'livepatch_sample': unpatching co=
mplete
>
> After:
>
>   # modprobe livepatch-sample
>   # dmesg -T | tail -2
>   [Tue Sep 16 16:19:30 2025] livepatch: 'livepatch_sample': starting patc=
hing transition
>   [Tue Sep 16 16:19:31 2025] livepatch: 'livepatch_sample': patching comp=
lete
>
>   # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
>   # rmmod livepatch_sample
>   # dmesg -T | tail -2
>   [Tue Sep 16 16:19:36 2025] livepatch: 'livepatch_sample': starting unpa=
tching transition
>   [Tue Sep 16 16:19:37 2025] livepatch: 'livepatch_sample': unpatching co=
mplete
>
> Cc: stable@vger.kernel.org # v6.9+
> Fixes: 199cc14cb4f1 ("LoongArch: Add kernel livepatching support")
> Reported-by: Xi Zhang <zhangxi@kylinos.cn>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  arch/loongarch/kernel/stacktrace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/s=
tacktrace.c
> index 9a038d1070d7..387dc4d3c486 100644
> --- a/arch/loongarch/kernel/stacktrace.c
> +++ b/arch/loongarch/kernel/stacktrace.c
> @@ -51,12 +51,13 @@ int arch_stack_walk_reliable(stack_trace_consume_fn c=
onsume_entry,
>         if (task =3D=3D current) {
>                 regs->regs[3] =3D (unsigned long)__builtin_frame_address(=
0);
>                 regs->csr_era =3D (unsigned long)__builtin_return_address=
(0);
> +               regs->regs[22] =3D 0;
>         } else {
>                 regs->regs[3] =3D thread_saved_fp(task);
>                 regs->csr_era =3D thread_saved_ra(task);
> +               regs->regs[22] =3D task->thread.reg22;
>         }
>         regs->regs[1] =3D 0;
> -       regs->regs[22] =3D 0;
>
>         for (unwind_start(&state, task, regs);
>              !unwind_done(&state) && !unwind_error(&state); unwind_next_f=
rame(&state)) {
> --
> 2.42.0
>

