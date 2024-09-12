Return-Path: <live-patching+bounces-653-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 849ED976E62
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 18:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E5411C21E61
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 16:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2717B13CF86;
	Thu, 12 Sep 2024 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3bagFce"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24824AEF4;
	Thu, 12 Sep 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157157; cv=none; b=e9BAQH7IeUZ5CxkQV6ArIbdRHIWTcixgoGsMhBECXeIdBloDpBEDqgMpkHmkPlJ/noKVKi4raYTBcZ9lypzT0KhzETbRdvI+KCzXxD8UWrTK1ZKeRFNEW15p7oZtwkIVFLHFy9GfulHwGe8yvjJy/gN0cVANci+X+GLtKQkZ0CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157157; c=relaxed/simple;
	bh=fQOouSkv2zthNASAck3SA4+rvvjruOD8E/YA2EEdV30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnxSC3m8B6QkK8LG49RDMp8f5FStwBUyLMdg+Oqil4MxIhbPT2E8j+aD9k+FbWNfU8zfJsuCnI4FngGzevP6rKRWFjpeLZYhNZKcHE6Vj7hfcH0SizQtVuNOFFcMnOiSwu6NIs3Dc3FtuZ5qA3d5jXMvijSZu1D7tngOMwKEOcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3bagFce; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722D3C4CEC4;
	Thu, 12 Sep 2024 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726157156;
	bh=fQOouSkv2zthNASAck3SA4+rvvjruOD8E/YA2EEdV30=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I3bagFceEX0CNn54TD0wirBQRJ2uUD+SpsmPqykhr1NgHe0nAAFpBW+BJCHYnZgzN
	 THdLvAP/yOV08fH6bkjTWlg9ejpYrMxFwZbab/P34FtFgJgdYMWaM/4wcNauISCb9i
	 vfMnBMw5JlMj+T89JFRYUnwtl7LRX2Q5rEbfSi5JRGcxALrIsIneGDPDUwfLHK5+yG
	 FUX6KHSyisBXXRBHVgGD5CmbGTv5Q1VZAG06nEiPj3E/Wd8UAUu9ge4OUwcMxGXcWf
	 igpHKCIgvUouzDjSeyZj2yOi21Xxj3jJYRNTpPed8SletIAxb74xVwnmntsPtwxviR
	 /na0I/Yd+nprQ==
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82cd872755dso48421139f.1;
        Thu, 12 Sep 2024 09:05:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUD/xuMqy5ga3PviBckqz/oBG/0GOpC61+XIDpSAZxZ3Fyw9sIiTb4z80ucgD/ej/KQ42S60AWCvZ6CREY=@vger.kernel.org, AJvYcCWfMRmzYgjkq59Wts6OkOEmoFI5gM3bfxn8s8ESUVT5YwKWn8ue1Eq4BU3hKB0EHQgQ39tTmiCAWB99l3jKkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6o7GyHp9CzGz/UxbXlh2yr8tbWGT+j5x1BF8wTO52K/iemW4S
	q/sAuyXJQNo8v9nHAGpD+py7ZeKz67LvLHCqx5EFeDmlt1LinenEwcO2lLZmOJ++3gGRD/Z04rN
	SlqXDadWSb5PV5x6urTI+ahBi3sw=
X-Google-Smtp-Source: AGHT+IFlya0J66bl/G6b5Dd2/2T9rTqUrlPSYrYUXGfR82Zqd4tOAwc7oFszv4fx9tepFb4FoeHmObfGLpyESsAeXEU=
X-Received: by 2002:a05:6e02:190a:b0:39f:500e:2ffd with SMTP id
 e9e14a558f8ab-3a0849551bfmr34888455ab.19.1726157155724; Thu, 12 Sep 2024
 09:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <ZuGav4txYowDpxqj@pathway.suse.cz>
 <20240911162005.2zbgqrxs3vbjatsv@treble>
In-Reply-To: <20240911162005.2zbgqrxs3vbjatsv@treble>
From: Song Liu <song@kernel.org>
Date: Thu, 12 Sep 2024 09:05:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5GuADzdnsBi9Nx0Rrv2FRnO3c5SwdYA01ZShOCf6RY+A@mail.gmail.com>
Message-ID: <CAPhsuW5GuADzdnsBi9Nx0Rrv2FRnO3c5SwdYA01ZShOCf6RY+A@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	A K M Fazla Mehrab <a.mehrab@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Wed, Sep 11, 2024 at 9:20=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
[...]

> > Do not get me wrong. I do not expect that the upstream variant would
> > be feature complete from the beginning. I just want to get a picture
> > how far it is. The code will be maintained only when it would have
> > users. And it would have users only when it would be comparable or
> > better then kPatch.
>
> I agree it needs to be fully functional before merge, but only for x86.
>
> Red Hat (and Meta?) will start using it as soon as x86 support is ready,
> because IBT/LTO support is needed, which kpatch-build can't handle.

While we (Meta) do have a workaround in kpatch to build livepatch for
kernels built with LTO, we will try to switch to this approach once
the x86 support is ready.

There are also other companies that would like to use LTO+livepatch
combination.

Thanks,
Song

