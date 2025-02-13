Return-Path: <live-patching+bounces-1184-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B70A34E93
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 20:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 731D516D100
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 19:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45E1245B1A;
	Thu, 13 Feb 2025 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F58sqAOP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B8D1FFC59;
	Thu, 13 Feb 2025 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739475755; cv=none; b=eYwyZx5wEdG9Wm5Ajv70380mm+XArNjTz8tLxNWtBVjpe8iQLw6QNU5kb4aulMJaZhlHg9sinEh55KbWDOOlFbJHvqSE3dFNvQWLu+DFK45OnP6Qz+uirqxEyng+NGU23hnN/Q/cZDnTOuSLTyN/z59h6rJGaunjH+klF6zWd5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739475755; c=relaxed/simple;
	bh=zhca3lHw3HGHPYdbqXqIVn9+d+GeoxPMDbYAYuwBREU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HiYSNjMY07LbawdEQSrBbNqal5d2LaAM6jyIZ9pxhCKYglk73eZF3wbczTm++pBsyWDMV8x19mZjqIrtcUS4ubjj2cdiNseAJAZiRll8sk+ZfCc2gPO1VGmWOtZwtEUHM/xW0qrKv/fFe7R6TIFDIJRVtiu5x/OzH+rzGN2t/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F58sqAOP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEBFC4CEEB;
	Thu, 13 Feb 2025 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739475754;
	bh=zhca3lHw3HGHPYdbqXqIVn9+d+GeoxPMDbYAYuwBREU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F58sqAOPUzD1iqPKvsUuTHv9lybwmwlvsyOcWe6mQh+HPB9WgVvuJiWFy+FFtKADI
	 A8lbwZSdi6q/iSISINI0+HyOKB0zkUw85NUFFcOD2F2+QYHdTXPDjSlNz+e2sCUlpa
	 gBYbH3R1qumoytxHxsKkKADtqQqCf5jq3W6bWEFxgwnplaNFd1FLrEaEsRyxHOPqH4
	 PuYkJjF8y9e2t/AZ8qO3cTNaeT/S7NX7poN6uCTbo5xMSAQWy1/g/r5mKzYTn7vUPv
	 U3VLlwsGCyKISxGIsDghahpMGxukWq3Y+wXyKqVSFDcNo8OytXyL9YMpmYkzoIrBnE
	 gGfU2I0TyG9jA==
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cfcf8b7455so9635425ab.3;
        Thu, 13 Feb 2025 11:42:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2S6h6YHizzEteLXOGnH0aZgAznxoRqfPF46CL2r9c0xOzj8dRYItcdoQ1saaabFn3QOOii7y6/YzPoIjRcZjmBw==@vger.kernel.org, AJvYcCX3FtPeMDo6DLfgccXbj0irCULQM9WsVyvVFlO3VYWIR0ul19PR70nrBCNXPiWFAx9GH9hRQ/1RW6lnbCI=@vger.kernel.org, AJvYcCXsC9rfj6uFw/+3uuoUej9BEVnPi05GCwk9ei2bSoT2U22u4s1C3o/zfVca4/vPRuLCmy7jOKbbsdsO8QYqbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLjU+DOYyK0lga2vdXyXQTn1KtLEKAHW4eDHv05H0oK+BRVL+o
	GAx6k+Hpc7c+QDbnMDyUxG74B3HG/Gsq7G9IWwO5YCt33irrfAgqreNVpOSPM573LQ4ZqZ88dB8
	XyLLc9i0tdIoMnuqmD9Z16WacwGk=
X-Google-Smtp-Source: AGHT+IHIbENSDq5CQfP65nDFBkOkSbpX1IICiXpHBzu8dGuTeZ21sZHkLP/NkVnz62zNuV6m+CoRpUcWrEyLrDSzEik=
X-Received: by 2002:a05:6e02:1a4d:b0:3d0:2477:83ec with SMTP id
 e9e14a558f8ab-3d17bfde009mr71824235ab.14.1739475753535; Thu, 13 Feb 2025
 11:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com> <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org> <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pv7tez3ew.fsf@kernel.org>
In-Reply-To: <mb61pv7tez3ew.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Feb 2025 11:42:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6pivqMnuudyqMy3XG4waiQHGt=LzvJfUZtJ2xbennN4A@mail.gmail.com>
X-Gm-Features: AWEUYZkZU3DHZIHWjT3TEVWQVY-TSsGUvKIT-xBdS_Hi3qdY8ySN3-kwjSp89jE
Message-ID: <CAPhsuW6pivqMnuudyqMy3XG4waiQHGt=LzvJfUZtJ2xbennN4A@mail.gmail.com>
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

On Wed, Feb 12, 2025 at 11:53=E2=80=AFPM Puranjay Mohan <puranjay@kernel.or=
g> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > On Wed, Feb 12, 2025 at 11:26=E2=80=AFPM Puranjay Mohan <puranjay@kerne=
l.org> wrote:
> >>
> >> Song Liu <song@kernel.org> writes:
> >>
> >> > On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@ora=
cle.com> wrote:
> >> >>
> >> >> On 2/12/25 3:32 PM, Song Liu wrote:
> >> >> > I run some tests with this set and my RFC set [1]. Most of
> >> >> > the test is done with kpatch-build. I tested both Puranjay's
> >> >> > version [3] and my version [4].
> >> >> >
> >> >> > For gcc 14.2.1, I have seen the following issue with this
> >> >> > test [2]. This happens with both upstream and 6.13.2.
> >> >> > The livepatch loaded fine, but the system spilled out the
> >> >> > following warning quickly.
> >> >> >
> >> >>
> >> >> In presence of the issue
> >> >> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect=
 bad
> >> >> data in SFrame section.  Which may be causing this symptom?
> >> >>
> >> >> To be clear, the issue affects loaded kernel modules.  I cannot tel=
l for
> >> >> certain - is there module loading involved in your test ?
> >> >
> >> > The KLP is a module, I guess that is also affected?
> >> >
> >> > During kpatch-build, we added some logic to drop the .sframe section=
.
> >> > I guess this is wrong, as we need the .sframe section when we apply
> >> > the next KLP. However, I don't think the issue is caused by missing
> >> > .sframe section.
> >>
> >> Hi, I did the same testing and did not get the Warning.
> >>
> >> I am testing on the 6.12.11 kernel with GCC 11.4.1.
> >
> > Could you please also try kernel 6.13.2?
> >
> >> Just to verify, the patch we are testing is:
> >
> > Yes, this is the test patch.
> >>
> >> --- >8 ---
> > [...]
> >> --- 8< ---
> >>
> >> P.S. - I have a downstream patch for create-diff-object to generate .s=
frame sections for
> >> livepatch module, will add it to the PR after some cleanups.
> >
> > Yeah, I think the .sframe section is still needed.
> >
>
> Hi Song,
>
> Can you try with this:
> https://github.com/puranjaymohan/kpatch/tree/arm64_wip
>
> This has the .sframe logic patch, but it looks as if I wrote that code
> in a 30 minute leetcode interview. I need to refactor it before I send
> it for review with the main PR.
>
> Can you test with this branch with your setup?

This branch has the same issue as the other branch.

Song

