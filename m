Return-Path: <live-patching+bounces-1216-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64190A3A547
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 19:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BE40161A65
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 18:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340B617A2E5;
	Tue, 18 Feb 2025 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgGuMCdm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0452F17A2E0;
	Tue, 18 Feb 2025 18:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902823; cv=none; b=ZIkUl9eUMXkz1u2BY83RZ6KxVn1+7hXB08Yu8qRBLaJkKzc1raVxshQMgtD1373rDTTeeS3Pm63TdEOHcUeRVqr0TVaBG2MrU/R3RL7RSyiW0f4qARhDAixGPjhe59psUbn0xCmeZ3q1/Goxvjzj9f91oD+xicdksXGwT/OBf38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902823; c=relaxed/simple;
	bh=i7uUtXNMjRRNoE/sjgLWfCiLhOArRyzd5/y7ZwlSfj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RKyqRvJUTD2ouKTDVZdkI3u5ADzV780nRfm8VvnktsfTmHCwzRif2NmoSSanjbFq04flDbRAeUanFIGXonet9OEqa+bfTfOM33tlXJk0SzP+s5vSibCpilLxnBNUXfzw1lx79fLNWlOs16oHvD0zuBJwNxrfWjAmIO46q37U4Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgGuMCdm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76440C4CEE2;
	Tue, 18 Feb 2025 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739902822;
	bh=i7uUtXNMjRRNoE/sjgLWfCiLhOArRyzd5/y7ZwlSfj4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KgGuMCdmekrrFynqBUDp1X5Q9NtJeSK02ZZNNDaJdCAbFbHAkoj0sPqbKLttEmOOp
	 s8XKsQbwT11tCFcQWPMKqvou9HudFfgK7xJR9zufjeiRnt+Xo2QdchF4tIhAD8uICm
	 0AV36YNFydtvK4lGWt4a0FB9qGc1YatXESm1W/aEbq28paLxFGcy6CKs9WCCiKpqVF
	 6+HuMeN3wsbpNaQ7RGsxZiDR/caGUnrTsiB95ZDqAF9J2wWbzHD4xXyqMTgKegMBt2
	 kh+6d5SeCfrgIBjvQlNHtwrvgH2w9jWPqY+mT1L3IPclBt19w1sdOQeX2IJrEPcdYD
	 y8Y44dkXsRARw==
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso17706135ab.1;
        Tue, 18 Feb 2025 10:20:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVB5KNB5kJHYJYGJqB1zQOB/Ge8xOZMMA4g1gUpI4VHEML9nrx12Rm5hD7uBgYXpSZ005ljGi2GIDmqeAr9QJEdXA==@vger.kernel.org, AJvYcCWQAK06vczp9+l5ccsMHScF0f/sDND8+hwcc7TVPEKymIjafT9VEJNmhnddnR9X/3oeAE1y/lJpSaTUtFE6yw==@vger.kernel.org, AJvYcCXzyadJt56X+r3SQj8QFmjNLelHpuX1S4pH+RkTIh2tyye1lA3w7ikEqJT/hkrXMLkoAHqHebepEfQ5zAA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Se8Tn2izN4qTCm4aYcNHgdTzIso4yDkpgySXChviTWIj/fv1
	TU4YmgP84y4LmiN44sdf41qHW943OAO+LYIwqmLezDAvarppFfuS+i61t72ssLid94mkHQBpu6M
	FhXFfRWOMZv3mNJIJ+CZfgE7h7sE=
X-Google-Smtp-Source: AGHT+IG4FlnOX9Ql40omkJN+vWGOP3w/LrBrVI6Sr0U3JqnUmjReG7wWo0B7SUJhaMSh92+XkCiuQ91zPpqQH/rpcXM=
X-Received: by 2002:a05:6e02:2408:b0:3d0:4e2b:9bbb with SMTP id
 e9e14a558f8ab-3d2809580eemr158857095ab.21.1739902821943; Tue, 18 Feb 2025
 10:20:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250213024507.mvjkalvyqsxihp54@jpoimboe> <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org> <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe> <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe> <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe> <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
 <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe>
In-Reply-To: <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Feb 2025 10:20:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
X-Gm-Features: AWEUYZnvvDqTb1fovYfGDRE0ySlLJoOtPvngjhwXWpFfc6v9eHqvdMBDZzElWF0
Message-ID: <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Mon, Feb 17, 2025 at 10:37=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Mon, Feb 17, 2025 at 08:38:22PM -0800, Song Liu wrote:
> > On Fri, Feb 14, 2025 at 3:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > > Poking around the arm64 module code, arch/arm64/kernel/module-plts.c
> > > is looking at all the relocations in order to set up the PLT.  That a=
lso
> > > needs to be done for klp relas, or are your patches already doing tha=
t?
> >
> > I don't think either version (this set and my RFC) added logic for PLT.
> > There is some rela logic on the kpatch-build side. But I am not sure
> > whether it is sufficient.
>
> The klp relas looked ok.  I didn't see any signs of kpatch-build doing
> anything wrong.  AFAICT the problem is that module-plts.c creates PLT
> entries for regular relas but not klp relas.

In my tests (with printk) module-plts.c processes the .
klp.rela.vmlinux..text.copy_process section just like any other .rela.*
sections. Do we need special handling of the klp.rela.* sections?

Thanks,
Song

