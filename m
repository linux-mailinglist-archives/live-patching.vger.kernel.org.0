Return-Path: <live-patching+bounces-1190-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 252A4A353F4
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 02:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5D64188FB6F
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 01:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E1584FAD;
	Fri, 14 Feb 2025 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIrX+yVY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C641E502;
	Fri, 14 Feb 2025 01:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739498339; cv=none; b=ADE6urtNouMfyMKDfaO9F/gf/pNbHyYfwiOy1sa7YFotCFWoHwR53eC6gk0VyWHAAXuyvhXFItG8dgiiIc5hSrVy1a3sAe0Tp7TxZKZagykhZ+hxS2N9iYldaYSUVUyRyIXzK/W9ZOtyiF+fxETMKK0LSJkJ64XYgDN+JTuisIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739498339; c=relaxed/simple;
	bh=AtX4TcfqYpcyFBoqwkZl/9Tr2hyNSYfyQ73TsT0oaxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UJLxJH05+g+fXBCl+Mcme2vfo7xRbTbHjI8Qwce/jtmT/q0KVrW/jx29wQRScoF6HbBPPHye8gnrwduKCIOj/2V3Fa9AnFoKwLtkuSsbcafNPCGLSzSaPvdR2eNDMaBq2OYdQe2bzKqOC0HcyvUSkcgRVj6QjuJiOccNzgFG9S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIrX+yVY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE8C4AF09;
	Fri, 14 Feb 2025 01:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739498338;
	bh=AtX4TcfqYpcyFBoqwkZl/9Tr2hyNSYfyQ73TsT0oaxY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jIrX+yVYWf1RwTCwUJj45RkaeiCeljgDw36fV1NgqYFjAkzl4tA844QxIw5V5h/8v
	 2vMo389vb32CV0lTnK0lke6FeQOMPajW64imBOxkDerHs+CcZi+/TmETRwZhfut9yX
	 GQEbgyQLD2hwF3WQmwJWpfE0I+EO0SOkySN2hIMRL9M5ytO2P5BVxxIHhXECx8zPTl
	 L0O1ys9thxERhTMz0P1BVXn/aiyl2f2JO9389OYuLZNgsPcrLczEFu7MMJopqnFasm
	 HKY8MVmp6bvwuJu4g9BfGmbZMM3eh7jQwg6B2PHm6RCxQBvlby5KOw5COjmqJ7vhEp
	 ByCaRaveCOMhg==
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8551c57cb8aso27379539f.3;
        Thu, 13 Feb 2025 17:58:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV76IAtzyPhTxaTGC8nHYJGgH3asPU4uTSwmFriJIHzzehUqMeejSak/zsPih5aLUkf9Hi4+rePyDbtjmFVcg==@vger.kernel.org, AJvYcCWdRUIjkdazyixJQyOfq8LfT/HCDClv3CMnJfWpFnlK+3Bl8+qHnepZFuCI9bpecXMPZ9pc4bAjZZs1/3avpEZBHw==@vger.kernel.org, AJvYcCXcVJLiUfwE8CE1+tDiU1F32pIPDlXO84CogcU7TFQu/K7gbgiHal1hOerH2bpCHnr+xaQxDZS5MeCcqCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy56uhdRT/ZbjlUZW4uY5nvbWADontoHqm9nrbriEL/LTt7SVrq
	3Esw7GdrBZUiecmScGQxQT4IVR+wq2nk0zT5zNat9Pd9lxlAGTRb44lShkShZbn4Y6kmfOUA9AR
	nj3RGJD47O+Gi6kPesehaAJ+8bbg=
X-Google-Smtp-Source: AGHT+IEqPgzO3lIvmSnLrOqQOZvaJ4xeAqJ3kVghhzVWZb4fCDChRFA3LLGruPGAyM1QQHijD9esbVZGX8Xo8nR1bnE=
X-Received: by 2002:a05:6e02:184b:b0:3cf:cd3c:bdfd with SMTP id
 e9e14a558f8ab-3d18c23caa4mr42155035ab.12.1739498337729; Thu, 13 Feb 2025
 17:58:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com> <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org> <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org> <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
 <mb61pr0411o57.fsf@kernel.org>
In-Reply-To: <mb61pr0411o57.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Feb 2025 17:58:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
X-Gm-Features: AWEUYZkpF5BMZbHzv8MzSiy1Gtx3WEyGX_vqexyd5VIB8KHI8VbVKVkNRfn3dfk
Message-ID: <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 2:22=E2=80=AFPM Puranjay Mohan <puranjay@kernel.org=
> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > On Thu, Feb 13, 2025 at 12:38=E2=80=AFAM Puranjay Mohan <puranjay@kerne=
l.org> wrote:
> > [...]
> >>
> >> P.S. - The livepatch doesn't have copy_process() but only copy_signal(=
),
> >> yours had copy_process() somehow.
> >
> > In my build, copy_signal is inlined to copy_process, unless I add noinl=
ine.
> > If I do add noinline, the issue will not reproduce.
> >
> > I tried more combinations. The issue doesn't reproduce if I either
> > 1) add noinline to copy_signal, so we are not patching the whole
> >    copy_process function;
> > or
> > 2) Switch compiler from gcc 14.2.1 to gcc 11.5.0.
> >
> > So it appears something in gcc 14.2.1 is causing live patch to fail
> > for copy_process().
>
> So, can you test your RFC set (without SFRAME) with gcc 14.2.1, so we
> can be sure that it is not a sframe problem?
>
> And about having the .sframe section in the livepatch module, I realised
> that this set doesn't include support for reading/using sframe data from
> any module(livepatches included), so the patch I added for generating
> .sframe in kpatch is irrelevant because it is a no-op with the current se=
tup.

Puranjay,

Could you please try the following?

1. Use gcc 11.4.1;
2. Add __always_inline to copy_signal();
3. Build kernel, and livepatch with the same test (we need to
    add __always_inline to the .patch file).
4. Run gdb livepatch-xxx.ko
5. In gdb do disassemble copy_process.

In my tests, both gcc-14.2.1 and gcc-11.5.0 generated a .ko file
that looks weird in gdb-disassemble. Specifically, readels shows
copy_process is about 5.5kB, but gdb-disassemble only shows
140 bytes or so for copy_process. clang doesn't seem to have
this problem.

I am really curious whether you have the same problem in your
setup.

Thanks,
Song

