Return-Path: <live-patching+bounces-1105-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A29B5A2661F
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 22:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414083A4774
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 21:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B98020F06B;
	Mon,  3 Feb 2025 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFsOr6Mg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5042578F54;
	Mon,  3 Feb 2025 21:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619630; cv=none; b=qOMTy1so8CkY32+4FjY1VE9QgRqnQRdnC5p/WsxOywdpmm8y2dEtjnwyzva8MzmoFFqVuuakFP6ZEZRmoqR3CJ9q0Ut06atfcJ5hBD/GL+w7MdyUuiBWeBnGxefdifrvsFusz2aF0eP3zRYVy5OqZ5RDHEBWsAvVC6TDeHYJPLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619630; c=relaxed/simple;
	bh=/M+s+z84/VorB78FVfaxyok4y9AAERvmbiXYeqxvIoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S5ivxvgW5JjNS8dpUGOXsgjF6KkErWR0JSEhF4w5cKpx0pGC9Xr0x878EiM0bUAdkqYbkeTia35Af61fA9MN2UXi8QxM9Yr3MVZoH5ENFPSTzCwImYK/yP16QACkIkiKcRQhNJ2A1mMd8RaVnpVjbtua5TEZ2r2nUAxysy9/RZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFsOr6Mg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6720C4CEE7;
	Mon,  3 Feb 2025 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738619629;
	bh=/M+s+z84/VorB78FVfaxyok4y9AAERvmbiXYeqxvIoc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BFsOr6MgjqiZrjcm957vJlHV+h9Oe55SrdVtIlxjOSLxeqbBZHpln0vL8MSc5MVX0
	 hAgx4W6LyMkzWghmkyTDUsOCCxsUa9rQZHmq5UJvBJp3odFbUPgvefagXtemTcF/Ov
	 s/7o9KUfOtozZf2g+/1YPdA06d4IpMg4LlYCHX5feYVb6Y6I9jBG7Qf1/DDgL6rRnf
	 m9paw24QoviHy1tDC937+ZqAC6feF2X5yKtbizcTLeZ413RERbwyfVrbEfnsjV/yyn
	 P09HsoVPG3K+Qxnqusa8kd/AiGASkltMEJSvpKhxOfi7X/zPJrIEdWCZWSu48WtyHr
	 TkoTClNmXHEFw==
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844ee166150so118415939f.2;
        Mon, 03 Feb 2025 13:53:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVW3p+LaUZIxhbMBo1CB3G9pIm/h30wBTS+uL0t3YEDGMm6cUGEMuYqsEu6ajvmvYfxwBPl6FYl4CKOAPStMw==@vger.kernel.org, AJvYcCVwlrqs/0/h7zTVX4AjllwFhJsQDiNquZnjzJxmMAMiEj5nMJyZgKWt3T6kVKk+mDvLodYV998ztwLTuJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKC80HawDnZfIqnVBP58fWbdusFqx8fEaEYhV0KfyHszm5LJkX
	DjFGSyQ6BBT7/6fdwd6j7YIrUAeD+MAyV9fiYz5Gg7Vz/shC0mHtuNQrv54qWeBg+Z2G3ntRNmB
	maKIrhk/OmxrO9vxlMZBKMmHotmw=
X-Google-Smtp-Source: AGHT+IHZXcmSRTXbiFzYo/Uzl/J+DmXvvIImQDyFtR6rXiXEPi7eUBgTr+qVGQBGxoqAQZt9zBd3F7j+bI+bgpG/7Ek=
X-Received: by 2002:a05:6e02:3b01:b0:3d0:10a6:99a3 with SMTP id
 e9e14a558f8ab-3d010a69cb1mr119609545ab.12.1738619628991; Mon, 03 Feb 2025
 13:53:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
In-Reply-To: <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 3 Feb 2025 13:53:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
X-Gm-Features: AWEUYZlPTI8mb73eFY-S02G4hcAiDPopwPf3IM-D9DGzGx5hvQ9nVDgHQF0irMo
Message-ID: <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, 
	jikos@kernel.org, joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 3, 2025 at 1:45=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
[...]
>
> If you=E2=80=99re managing a large fleet of servers, this issue is far fr=
om negligible.
>
> >
> > > Can you provide examples of companies that use atomic replacement at
> > > scale in their production environments?
> >
> > At least SUSE uses it as a solution for its customers. No many problems
> > have been reported since we started ~10 years ago.

We (Meta) always use atomic replacement for our live patches.

>
> Perhaps we=E2=80=99re running different workloads.
> Going back to the original purpose of livepatching: is it designed to add=
ress
> security vulnerabilities, or to deploy new features?
> If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot of room=
 for improvement.

We only use KLP to fix bugs and security vulnerabilities. We do not use
live patches to deploy new features.

Thanks,
Song

