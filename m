Return-Path: <live-patching+bounces-1276-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 813D5A600AB
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 20:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F72C189E52C
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 19:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C32D1F0E40;
	Thu, 13 Mar 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oevAoY3+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD41F4FA;
	Thu, 13 Mar 2025 19:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741893069; cv=none; b=furLdIOSToJvGNsJyTOSs781xIBFgz6YWdrMmkIyYNfDghK0fFC+iw0Z21h4J8mytNQVQCKObXXzeEb2nWu8236DiNZ3ARcRD8aoCNObrr/h5hBL46kq0f3utZLbf7qJkzVIPTw30aHgHshsAI6aAeCbp4wlyIErdI+YyU69F6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741893069; c=relaxed/simple;
	bh=Lr25EZkqxsPL3BB3IHuJEFZ8TJ1hBBK49jrHSJx6Gj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAoEw6TlZuwAeSVFqq4JN8Hn7pViS6DIM52N5v/7lc6IZGz515WkHpEbrjc8sM3zeJ5fcBJdj6O6nZAYOpmfSdH8DIsmTHY0HLLMLHuKBRPhZf9ByAg9PD7L5d9Jw8xnsZ2D6Xh9GICmntvwLmv02Pj2AKpHoAMQ6YLj5sHkt4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oevAoY3+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E39C4CEEE;
	Thu, 13 Mar 2025 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741893068;
	bh=Lr25EZkqxsPL3BB3IHuJEFZ8TJ1hBBK49jrHSJx6Gj4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oevAoY3+/xB5VOwPK/1aY6R2CgtAQVmg9qw2dUTMnNz4qVSiKJDy3ZHfRR16qT+/4
	 dVYWCd79CPNwrCz8OQQcQhFRgmsj7YValC4LccajI/xIBupibEPUCGGpLxvczxx4+4
	 FvhaJtKiq/oheQW7uf3JuDTOuTB6lrG+rlxQUHQOHVSUrITYB/SUgcOlnOABelmx5D
	 n3s/daUujbgufdPlIJjDZbu245wCFv368RoC+7bwyNecYdHdq273StjobJAbCMlBSz
	 L++PFLlZ5Swc248DwDwTjIPwxurGSgFPlwmmRoCpRyiS7+PVPn2iWYaK9u8rBTzTKO
	 b1Lxnk6yR14NQ==
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so5495625ab.2;
        Thu, 13 Mar 2025 12:11:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUQKH3IT0t1SfVGM0Zg1AOB9CNIdgYSyuNZujDg7VhOVNISm2LqSklGyYGJa9T5cecVzWsbrYu3K3BN1+0=@vger.kernel.org, AJvYcCVMhSWJWdSOSI0OUM6wGOdPu4Rc8fQBLa/oqGuc/brmdwScNK7biN/R9VKsorX/qpAPI0WFe2wnA3dN/9JRLA==@vger.kernel.org, AJvYcCX5dSGcgHjQhPBB/oWByGbqNe3HD87YLxJRrst0t4JjlGOrj7J2z1WetlU/OupotC2/mVYQZQ3+hYceB5YShqTqvA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7/Q969YAJ0HF1qmGOoVhuq8NZQ9o5FbfxiwQAQtrLZefScJRX
	fqwhOVxkIrhLYz+g5f0ayMC/dmrMlsxwx9vqv/iOZDL45Atya3mIEY6ob6urW0rDlpCiLDt5Ct3
	IefgPwWKDM4Wx9Jabzj3MfxE9iFU=
X-Google-Smtp-Source: AGHT+IGNaR9f/JVYBzHMMBNK+4GBcPFS332kc+pm3ldB4zFS8Anllv7AuVgokgN6kmTde5EZ5Ep8F2WKYTV04VfIU5M=
X-Received: by 2002:a05:6e02:144b:b0:3d4:276:9a1b with SMTP id
 e9e14a558f8ab-3d481783128mr10476285ab.16.1741893067798; Thu, 13 Mar 2025
 12:11:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308012742.3208215-1-song@kernel.org> <20250308012742.3208215-2-song@kernel.org>
 <20250313-angelic-coral-giraffe-dfa4f3@leitao>
In-Reply-To: <20250313-angelic-coral-giraffe-dfa4f3@leitao>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Mar 2025 12:10:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4QjDx1_2xXVjPzy2HueR+ZGb-q=zsn4S-TYSp38Tp-Zg@mail.gmail.com>
X-Gm-Features: AQ5f1JoREMu_L4nvl7y97uDhMFDyg_nK0nvfqGckRS9rsJPlVC_Jg1pGhtp1-gQ
Message-ID: <CAPhsuW4QjDx1_2xXVjPzy2HueR+ZGb-q=zsn4S-TYSp38Tp-Zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
To: Breno Leitao <leitao@debian.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 11:12=E2=80=AFAM Breno Leitao <leitao@debian.org> w=
rote:
>
> On Fri, Mar 07, 2025 at 05:27:41PM -0800, Song Liu wrote:
> > With proper exception boundary detection, it is possible to implment
> > arch_stack_walk_reliable without sframe.
> >
> > Note that, arch_stack_walk_reliable does not guarantee getting reliable
> > stack in all scenarios. Instead, it can reliably detect when the stack
> > trace is not reliable, which is enough to provide reliable livepatching=
.
> >
> > This version has been inspired by Weinan Liu's patch [1].
> >
> > [1] https://lore.kernel.org/live-patching/20250127213310.2496133-7-wnli=
u@google.com/
> > Signed-off-by: Song Liu <song@kernel.org>
>
> Tested-by: Breno Leitao <leitao@debian.org>

Thanks for the testing!

>
> >  arch/arm64/Kconfig                         |  2 +-
> >  arch/arm64/include/asm/stacktrace/common.h |  1 +
> >  arch/arm64/kernel/stacktrace.c             | 44 +++++++++++++++++++++-
> >  3 files changed, 45 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 940343beb3d4..ed4f7bf4a879 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -275,6 +275,7 @@ config ARM64
> >       select HAVE_SOFTIRQ_ON_OWN_STACK
> >       select USER_STACKTRACE_SUPPORT
> >       select VDSO_GETRANDOM
> > +     select HAVE_RELIABLE_STACKTRACE
>
> Can we really mark this is reliable stacktrace?  I am wondering
> if we need an intermediate state (potentially reliable stacktrace?)
> until we have a fully reliable stack unwinder.

AFAICT, we do not expect arch_stack_walk_reliable() to always
return a reliable stack. Instead, it is expected to return -EINVAL if
the stack trace is not reliable. OTOH, arch_stack_walk() doesn't
warn the caller when the stack trace is not reliable. This is exactly
what we need for live patch: we just need to make the patch
transition when the stack trace is reliable and none of the functions
in the stack is being patched. If the stack trace is not reliable, we
will retry the transition at a later time.

Thanks,
Song

