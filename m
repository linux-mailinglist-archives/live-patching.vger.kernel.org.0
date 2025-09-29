Return-Path: <live-patching+bounces-1724-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D8BBAA7E8
	for <lists+live-patching@lfdr.de>; Mon, 29 Sep 2025 21:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155231C5F31
	for <lists+live-patching@lfdr.de>; Mon, 29 Sep 2025 19:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0728C22A4FE;
	Mon, 29 Sep 2025 19:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkPKcsED"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70F21B4236
	for <live-patching@vger.kernel.org>; Mon, 29 Sep 2025 19:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759175180; cv=none; b=o38X2p6KhR5IZ3ouxv4xrOXIpmJHEHB9t9m6RkH5t3X+qx1uXlQr8vsV/4rbGFAsPsI07mI+moqXuAX9/qhi+czTiL3KU6wIgKy3X4dt/HpkJRWTHBB+aHWWJtq4fkVL5occxKckQG8FFi3z9pZsfC7vDx5WplTEU7jzqkYUmSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759175180; c=relaxed/simple;
	bh=5xgACw/2QtBTGS5E48A8ZkKBxvCcMMyg/YYx5RTbWZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aZGE7hAsLMvTgn1ry1amZgfq+PfzpxefP/wyzJ3veXjyo27WAXvFRQeQWK8I02sOKZtKLJ2lrxzydEzfbFbTdIrpccEzRiJnEhZDmfpRQqtOuU2kGjmwyRbKcaq5E/O4U7q9+OEBP9J+UgzF6wSgSdOP+2nd8hblp3GUSG3eQ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkPKcsED; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A9C113D0
	for <live-patching@vger.kernel.org>; Mon, 29 Sep 2025 19:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759175180;
	bh=5xgACw/2QtBTGS5E48A8ZkKBxvCcMMyg/YYx5RTbWZo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PkPKcsEDdrl42hqZxhgQ51kbowAxy2I1qABXeRukWGImWEsqFeKyAVGuh/bDDIR8A
	 mXxAcKVfu2MCT+BrCq6RTWx+hwwZv62dVUTvM3mHST9IiI0W8WS8YIIDgofRO8j/D6
	 UVI178EJJ/s9BiPW/1MtZnV5PFNi/TcdGCEGP6Z3XVOeIj+kjral/DFgukqB4HtHPJ
	 6rjqKCAlQN1yBYe+PeYwtn9TIIdeImPmFyIbZ3eamKH2V6kXYh8dLaF2ISua64X8VQ
	 4SZvixvrbmEbL40qqeQKGHWl/6MZxUVBbrfEdOkO/HtJmjpTzrxr+NZXUuljoPvyXv
	 UEzg0WmurP43w==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-78f30dac856so45573856d6.2
        for <live-patching@vger.kernel.org>; Mon, 29 Sep 2025 12:46:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQlCRUaqbTLSYzp+44jOhVlwiu293/KXj2o1ZanOsTDXWaW1u9jZaGycQlj7agHBmiazs5t6mKkVDKLIUT@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4+9ZGPXl9JGGOOcjZaTe8u0b7pe2q2yU9+6f1gKlRjG4jSEtt
	b+sR3lnbdx6WyFjkIjxRyyq0HQe4jmmfmfvcci6Dpunib9KyBecmYramTO2UNR4ceOnV3MnxoAw
	cF5IsyH4gyly322/AH/PFbO8ailTBNmc=
X-Google-Smtp-Source: AGHT+IEXzouQ9DmgJcWZT4w/k/xSvEVMLKrsyJDlnS9CzAc/UnL6y8E1G2p2BPo9Ogz2x+E7MBxJZTyKfa2vhnR4aJI=
X-Received: by 2002:a05:6214:19cb:b0:820:a83:eaec with SMTP id
 6a1803df08f44-8200a934271mr138124936d6.35.1759175179601; Mon, 29 Sep 2025
 12:46:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
In-Reply-To: <20250904223850.884188-1-dylanbhatch@google.com>
From: Song Liu <song@kernel.org>
Date: Mon, 29 Sep 2025 12:46:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
X-Gm-Features: AS18NWAnkDC8NBecqooALnKp782BPyyRWLT6WeGda5eSChP0CGCqZ4fVHkcf6TA
Message-ID: <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 3:39=E2=80=AFPM Dylan Hatch <dylanbhatch@google.com>=
 wrote:
>
> This patchset implements a generic kernel sframe-based [1] unwinder.
> The main goal is to support reliable stacktraces on arm64.
>
> On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
> required support from objtool: it cannot generate orc unwind tables for
> arm64.
>
> Currently, there's already a sframe unwinder proposed for userspace: [2].
> Since the sframe unwind table algorithm is similar, these two proposals
> could integrate common functionality in the future.
>
> Currently, only GCC supports sframe.
>
> These patches are based on v6.17-rc4 and are available on github [3].
>
> Ref:
> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
> [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.or=
g/
> [3]: https://github.com/dylanbhatch/linux/tree/sframe-v2

I run the following test on this sframe-v2 branch:

bpftrace -e 'kprobe:security_file_open {printf("%s",
kstack);@count+=3D1; if (@count > 1) {exit();}}'

        security_file_open+0
        bpf_prog_eaca355a0dcdca7f_kprobe_security_file_open_1+16641632@./bp=
ftrace.bpf.o:0
        path_openat+1892
        do_filp_open+132
        do_open_execat+84
        alloc_bprm+44
        do_execveat_common.isra.0+116
        __arm64_sys_execve+72
        invoke_syscall+76
        el0_svc_common.constprop.0+68
        do_el0_svc+32
        el0_svc+56
        el0t_64_sync_handler+152
        el0t_64_sync+388

This looks wrong. The right call trace should be:

  do_filp_open
    =3D> path_openat
      =3D> vfs_open
        =3D> do_dentry_open
          =3D> security_file_open
            =3D> bpf_prog_eaca355a0dcdca7f_...

I am not sure whether this is just a problem with the bpf program,
or also with something else.

Thanks,
Song

