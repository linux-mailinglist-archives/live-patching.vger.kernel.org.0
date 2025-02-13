Return-Path: <live-patching+bounces-1173-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D08A338FC
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 08:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B20787A31EB
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 07:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E3420A5DA;
	Thu, 13 Feb 2025 07:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jpt3COTj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C222080C4;
	Thu, 13 Feb 2025 07:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739432277; cv=none; b=ZHdfCowOOhP7IBBaAkr1GTWGbuqKLGBgmqeq1QrYm/L8rk/Bfe5elp+y7OhpGhcUKrRkqMOiktUfYPGUfRoExkAYg22RMocxkyRn/xsJe8dN7qKnfnJW/ZjiYSqTF/FsH79aWmgE9zu069ymRVBGYhR7sDTTY4oAhrwk22aQkD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739432277; c=relaxed/simple;
	bh=ac/bcOZbWbtdspcakhbcX4BAflMcQ4DC4KBda2XPhJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxFzjgl6AIKmXZCfS8AwE7t5bpMvhE1rfCRMy+y+cXzvZRUxYqCDu/7gHRVfP8UsyUqzYBUGDyCUTKQ061E/hcjgEtNRg/KOVBKtzDG6kpFuzDw+VodlTYTWTBgVtLGDiheEt22DDOsJf2UAmQdplv9bX1qjKLHbv70nr1WVAhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jpt3COTj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B3FC4CEE9;
	Thu, 13 Feb 2025 07:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739432277;
	bh=ac/bcOZbWbtdspcakhbcX4BAflMcQ4DC4KBda2XPhJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Jpt3COTj5XIqRj8J7FxBblUc9kDMm4lJbL4O4GCl5+ohj4pqjv/UN731yoBqwchw7
	 JuIfqTeNDybpFBi9Ata79PsjgswsSXElAXlkfAVq+uRdXJcDMVZBmnmJYKqj1wFjt3
	 KcApdUI1oQWh5Mck2srm6DlSQXRMYRXSNkxJSk3TBHUd24cBxVOfoTa2Y+18hD5xu9
	 4V9OmKWKZLJSzV90XWw8tNnu74Fpd9WSUGiw68sHyh7m/GYz21QaDcDk3o+FW1FMBh
	 jtXacZmwOzWiQKBfMPi7saO1i8UH1ql5joM4OQlJ1HiFlTM5V82q9HpjVIVhumWov+
	 gFL8JA/VJyslg==
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3cfc8772469so1762445ab.3;
        Wed, 12 Feb 2025 23:37:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUAUGdOuz03DOlMBnYQQMMOVUKG2e4P5k7pvkq2zm7PIXmXI9Mh7mLFfD9NAX7pinglqaDBkBYnj59faHMw5cOxCQ==@vger.kernel.org, AJvYcCVtiwJZydhnFQOZ2xBrvaUpKpZ7/Ig9BEr764JQikHiQ6U84QiONqQL5YB0Daculrv89W2FdcA099zZ+Mk=@vger.kernel.org, AJvYcCXFnJy8/nAgUXZoMZCmF43aX4+MoEztCza0hSOBo9FrYCucAm5FtzLiYPeZvgJm+JKlxypHo2UkTuh0eK1Uow==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxe0Ln2z1Nb2mi9rKGjUVbSpxGidWiy4tRO9nHPZg1q0xU4NaL
	wmqjs5u8oaqKEgnpvdo4zMffrQrWkcWisIq1uLE5clqSjSXhV44S3UQRIk0pW127qRsNNUX1SjU
	x0YpsRYMv36eGZGS9xThP6OJ9us4=
X-Google-Smtp-Source: AGHT+IHsfPIAl5hWCRvJ1RKIS5xF1B4fT6O5wPSPAgwQ1k7iv1KYLuzpzwKngS9b2X7ne3vqVq5fZ0x4mohFd5XnnGk=
X-Received: by 2002:a05:6e02:12cf:b0:3d0:24c0:bd4d with SMTP id
 e9e14a558f8ab-3d17bff94f9mr64954095ab.18.1739432276328; Wed, 12 Feb 2025
 23:37:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com> <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
In-Reply-To: <mb61p1pw21f0v.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 12 Feb 2025 23:37:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
X-Gm-Features: AWEUYZk1153uVA612siWVvTvz5oIJTx1LSxyHmzFbrXM3DQ11Kv4ihFu9Sq_1wM
Message-ID: <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
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

On Wed, Feb 12, 2025 at 11:26=E2=80=AFPM Puranjay Mohan <puranjay@kernel.or=
g> wrote:
>
> Song Liu <song@kernel.org> writes:
>
> > On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@oracle=
.com> wrote:
> >>
> >> On 2/12/25 3:32 PM, Song Liu wrote:
> >> > I run some tests with this set and my RFC set [1]. Most of
> >> > the test is done with kpatch-build. I tested both Puranjay's
> >> > version [3] and my version [4].
> >> >
> >> > For gcc 14.2.1, I have seen the following issue with this
> >> > test [2]. This happens with both upstream and 6.13.2.
> >> > The livepatch loaded fine, but the system spilled out the
> >> > following warning quickly.
> >> >
> >>
> >> In presence of the issue
> >> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect ba=
d
> >> data in SFrame section.  Which may be causing this symptom?
> >>
> >> To be clear, the issue affects loaded kernel modules.  I cannot tell f=
or
> >> certain - is there module loading involved in your test ?
> >
> > The KLP is a module, I guess that is also affected?
> >
> > During kpatch-build, we added some logic to drop the .sframe section.
> > I guess this is wrong, as we need the .sframe section when we apply
> > the next KLP. However, I don't think the issue is caused by missing
> > .sframe section.
>
> Hi, I did the same testing and did not get the Warning.
>
> I am testing on the 6.12.11 kernel with GCC 11.4.1.

Could you please also try kernel 6.13.2?

> Just to verify, the patch we are testing is:

Yes, this is the test patch.
>
> --- >8 ---
[...]
> --- 8< ---
>
> P.S. - I have a downstream patch for create-diff-object to generate .sfra=
me sections for
> livepatch module, will add it to the PR after some cleanups.

Yeah, I think the .sframe section is still needed.

Thanks,
Song

