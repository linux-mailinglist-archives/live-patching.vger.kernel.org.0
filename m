Return-Path: <live-patching+bounces-1091-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCF3A23386
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 18:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C029E3A69EF
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 17:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259381F03C5;
	Thu, 30 Jan 2025 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNKhAu7m"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6E51EBFE2;
	Thu, 30 Jan 2025 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259972; cv=none; b=f+GKyvPyAM3x8rvVxbk7nze7IhG5eBNEg51lEZfZQY0rGCmQlU/eHRqZ/t9auMx1h4X21XF05VY9+RlM6ZKPC2r4FPHKjGQCvYJf6qGfJERSp1ue+H/vn5nN0PfXHgcnPg5KT42RCmjLE2o7QkoYcjsCgIgeay3+f3vVttEX+IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259972; c=relaxed/simple;
	bh=BihflpWwQ9KIFupBmfTlZk9iajbzPlVGJYalKJ9g6Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2ihGKgSD8eAobmAzWkTQoAZzSMRRoSXkd5TpemAngT9aznjHp22zzOy07j7RvRm4v7DKuKMRVW26IFItAyg+iEbMax/DD2pK78i0D9ZSz4AZu2MVeGjVPE6TJ7uZscZKQoU1T3zyjWpu0gEgF0JsW9ekYGLOOJo+e4YdA2u47E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNKhAu7m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B73CC4CEE7;
	Thu, 30 Jan 2025 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738259971;
	bh=BihflpWwQ9KIFupBmfTlZk9iajbzPlVGJYalKJ9g6Pk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sNKhAu7mexAuXWA/I+U75npBZk7p68nMcM/dvkLcJKrdpJOZiNjUCfF0KSWSPPt4n
	 T7DSVqB1Sc+gxZseBbO+Swuya7Qs1eTfwaI4VxC7M1QS7cGnosaRMPJ1POkthVQjh9
	 vleMtBEBr9w93jWTrlG0ysMRJK6TLSttd6yesomRYfpT3AJ6WpGA51bBD7Umzvr+/a
	 RGSZ4mgLijx2tD7Soe7HcujGZkg2eEl7nSLeoy5RILpRCta73FCK2CLSMQ6eLZmiEC
	 tTDGg3EswdG3epeLhA15AHAnsd170R9yMDObfK1vH5e54mI1RWCEYDEFuvaLm1Z5sd
	 ULxhbLfNrzlqQ==
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d008738e03so11388125ab.3;
        Thu, 30 Jan 2025 09:59:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUS+i+x3/VdEstDI97V80sqZSJP+XDi4g4d8sApLBHSwGvZwDbi6LYRuBhGQG6eBmbPaJc1B45sLZ/iA9uw0s3inw==@vger.kernel.org, AJvYcCWigIaq4CL2PNJtj1SpPdy+X20NBhpfJonrz9y8+z8t84swKGAdHX+J4koauZceVT0pwTjdvl9T/X3I12U=@vger.kernel.org, AJvYcCXVD+Tu4whdjQDLfqZ0quUomTCUb1ebM3qkThscOyIgiNkBWjmTsz84FE1doD2rpbzA6R50rxBC954zpq/1uA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFWR+2kccVq3n4w73B4VyydmFakWG+qh8edJvq0/OjQXa9Ssep
	ItVaM+5JXKYoINTsttINRPjMw34zchlYxb/viwo5WbKxfBCwK+Wt2WY9PvyNQFJbj0wW+Edg/k8
	E/eYdByFpRm+oTd7pre1jYKfXbMc=
X-Google-Smtp-Source: AGHT+IHqVa57JGKmzgGGwdcIHANv+XQ3iMnue5+klM/H8VOXEra8cGpRyLQvVhgP6gOisOaz6JFvFMv76Hp7i/h93bc=
X-Received: by 2002:a05:6e02:1aa7:b0:3cf:cc8d:489b with SMTP id
 e9e14a558f8ab-3cffe4367c5mr65685805ab.14.1738259970707; Thu, 30 Jan 2025
 09:59:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Jan 2025 09:59:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4UrhaYKj6pbAC9Cq1ZW+igFrA284nnCFsVdKdOfRpi6w@mail.gmail.com>
X-Gm-Features: AWEUYZlJCyUyotQGicS3KuHjVI929vPaHTc5pUA_VMHHRA5VJ3vgRlFuLho9PXk
Message-ID: <CAPhsuW4UrhaYKj6pbAC9Cq1ZW+igFrA284nnCFsVdKdOfRpi6w@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Weinan Liu <wnliu@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I missed this set before sending my RFC set. If this set works well, we
won't need the other set. I will give this one a try.

Thanks,
Song

On Mon, Jan 27, 2025 at 1:33=E2=80=AFPM Weinan Liu <wnliu@google.com> wrote=
:
>
> This patchset implements a generic kernel sframe-based [1] unwinder.
> The main goal is to support reliable stacktraces on arm64.
>
> On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
> required support from objtool: it cannot generate orc unwind tables for
> arm64.
>
> Currently, there's already a sframe unwinder proposed for userspace: [2].
> Since the sframe unwind table algorithm is similar, these two proposal
> could integrate common functionality in the future.
>
> There are some incomplete features or challenges:
>   - The unwinder doesn't yet work with kernel modules. The `start_addr` o=
f
>     FRE from kernel modules doesn't appear correct, preventing us from
>     unwinding functions from kernel modules.
>   - Currently, only GCC supports sframe.
>
> Ref:
> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
> [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.or=
g/
>
> Madhavan T. Venkataraman (1):
>   arm64: Define TIF_PATCH_PENDING for livepatch
>
> Weinan Liu (7):
>   unwind: build kernel with sframe info
>   arm64: entry: add unwind info for various kernel entries
>   unwind: add sframe v2 header
>   unwind: Implement generic sframe unwinder library
>   unwind: arm64: Add sframe unwinder on arm64
>   unwind: arm64: add reliable stacktrace support for arm64
>   arm64: Enable livepatch for ARM64
>
>  Makefile                                   |   6 +
>  arch/Kconfig                               |   8 +
>  arch/arm64/Kconfig                         |   3 +
>  arch/arm64/Kconfig.debug                   |  10 +
>  arch/arm64/include/asm/stacktrace/common.h |   6 +
>  arch/arm64/include/asm/thread_info.h       |   4 +-
>  arch/arm64/kernel/entry-common.c           |   4 +
>  arch/arm64/kernel/entry.S                  |  10 +
>  arch/arm64/kernel/setup.c                  |   2 +
>  arch/arm64/kernel/stacktrace.c             | 102 ++++++++++
>  include/asm-generic/vmlinux.lds.h          |  12 ++
>  include/linux/sframe_lookup.h              |  43 +++++
>  kernel/Makefile                            |   1 +
>  kernel/sframe.h                            | 215 +++++++++++++++++++++
>  kernel/sframe_lookup.c                     | 196 +++++++++++++++++++
>  15 files changed, 621 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/sframe_lookup.h
>  create mode 100644 kernel/sframe.h
>  create mode 100644 kernel/sframe_lookup.c
>
> --
> 2.48.1.262.g85cc9f2d1e-goog
>
>

