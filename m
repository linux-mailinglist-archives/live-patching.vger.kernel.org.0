Return-Path: <live-patching+bounces-1188-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3745FA35237
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 00:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C78511889410
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 23:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187B51C84A9;
	Thu, 13 Feb 2025 23:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLvcnPJY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB218C924;
	Thu, 13 Feb 2025 23:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739489659; cv=none; b=NyMb9PedBAcUxjHxuk9+oP/lyZ+PgvxOKSoGdBCKSGmVjqqOQSU53uFqQzi9v9bq3olWZ/7TO9FXY3vjqMNvvCH9BcVL6e2rMXiKvC8SErQe8CZOZVvTYvf1M9uBc/oxUDcs4qvsfC2OvCSAHetx4GXrqj8kHomo8a3ST2pBw00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739489659; c=relaxed/simple;
	bh=N1peFMfD7vTD/DRcLqn0vJS+BR6mrfRHxFGLN+VrLow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vFcIBgQnkm0+ACCUCMQjeWmH+d1leoTr2dcptYTW9XJ19uoiXKLJxStU52HA7pDIq/dfAQ0hMn7vq4EGWA2d6jS4/0e5mgOmseoogZnfrZWnekf6t6rDAzayh/HZQFN9Sn9csai77nqqdYatkmhVAR3+NhEss9/w0oXYIpm3VQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLvcnPJY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9ADC4CEE6;
	Thu, 13 Feb 2025 23:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739489658;
	bh=N1peFMfD7vTD/DRcLqn0vJS+BR6mrfRHxFGLN+VrLow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MLvcnPJYwq2TuORYaw1/ML8+YCaWUgLgFCcZ7doHINjH4PxQSZgvT3c8s4ETClKPv
	 NAGTXBjLwXrrl2mPgwYjhtnWMUrLHmVqlEbjG0JTiFmJaGuXBfZZmTDZtrM6hIsDGr
	 vL28499mUY1S2ydy4iAKtiO0YGJYJJcHe8tGbZ82pgMy+iIJa0MRSSfNfPWCYIPn0M
	 Q4Oaul3kG5QInzMCdZ4u4OY8OYlAqs4DrEhf+PsiK0rslpAZ+ASavWBV6bl9Ouv3Z8
	 nPIB4UpyH/B9Rdc7aJIcNkryK/Tw49y8n/6UOH2X87M1iEi09uRH1a9fSyMjRzBz/Z
	 zomhVi+XKletg==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d149f4c64aso3734585ab.0;
        Thu, 13 Feb 2025 15:34:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU1XANFv5ph0BL8hZ8E7/t+ifDAE4fJnqBqfMR+qkLRKffhO+kEucAwDQKVbQ2GwVjLGNt8CBPBXcaVTx3I8g==@vger.kernel.org, AJvYcCUK9YYWen3dh+z5BuaxYSnoFSr4NCe83inAqQJkvJ7JRWl01+24gu+K/jQSiUt9f/PxrUTUuvop2uqFNibLDYlw/A==@vger.kernel.org, AJvYcCV12rKqMS/bgoC2tB1BnNPZ5dfyBXBfVQazTaWyrwz3jkvgVqmtprm8OV971hg48u3DCqmjATfj7NfDlXk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztdrz8m+rUm6BSVCmeGgGNqQLfUNEBFu5ewuHMzH0OC8UIWTFL
	bRboZ0n3ee1Ay1Oey3X/Cu3TjfLAc1lfIUtX5t2FAlTXAb0lusO7DZvNBBocVUb9NdegqQ/OjFv
	upZ6LYBmDJ+xvY5rM4J3b9xhmJwo=
X-Google-Smtp-Source: AGHT+IG1rQV0yKmTd4ign51tXVmFd/3I3khtaLBM2gfno63cBPOt8//ZZKniEPA4RSgy4RfCpeSumDMFlaJlHY9wbAw=
X-Received: by 2002:a05:6e02:1a61:b0:3a7:8720:9de5 with SMTP id
 e9e14a558f8ab-3d17bdff43fmr80793525ab.1.1739489657616; Thu, 13 Feb 2025
 15:34:17 -0800 (PST)
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
Date: Thu, 13 Feb 2025 15:34:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6C77if9-_j2sywHE4ZT3JUOAoDNiepiJPrRWCf8OAojA@mail.gmail.com>
X-Gm-Features: AWEUYZnvF8YgL5a3ClR7_9YRs3GII1KO5ROPdxeyhHjRsChKmRJielirplxSTbQ
Message-ID: <CAPhsuW6C77if9-_j2sywHE4ZT3JUOAoDNiepiJPrRWCf8OAojA@mail.gmail.com>
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

My RFC set is the same. No issue with gcc 11.5.0; but hits the same
WARNING with gcc 14.2.1. My previous tests are all with clang. I didn't
see a similar issue there.

> And about having the .sframe section in the livepatch module, I realised
> that this set doesn't include support for reading/using sframe data from
> any module(livepatches included), so the patch I added for generating
> .sframe in kpatch is irrelevant because it is a no-op with the current se=
tup.

Agreed, this issue should be irrelevant to the .sframe section in the .ko f=
ile.

Thanks,
Song

