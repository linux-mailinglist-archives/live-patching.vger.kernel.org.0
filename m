Return-Path: <live-patching+bounces-323-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D33108FC2E5
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 07:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10BCD1C21CE2
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 05:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C736613A875;
	Wed,  5 Jun 2024 05:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BO4uEPH9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9872D139D1A;
	Wed,  5 Jun 2024 05:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717563896; cv=none; b=H5zlKuN5bsm8GzztBeufreGfod2POOuE0lNNoT4k5ve2Pi2eG4aZCvnkov3j8YSrQuPhbjtha0/wUiYh2+7HAuSgW1t44d9RYzJaP9Nk1QRaLhe4x6qXB3bJ4/1Ph4Lx5YZ0zaJI3ACA+/50DS4WbhHhHGMNJQvYGnkCNSnm71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717563896; c=relaxed/simple;
	bh=ugc2bykqt55t/VwJ9UCKNtxoLh62vpOWsbk3df+1xH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M1nUqoiTcXfHO1bPLEkHugfxmp2pnTjb+L51mWXfNNRafGFGgB80seCTdGm56jYmojVkqAZkFvl6pFeOKwe0GVh04+4ZPkjlrmZsQlTRTmotzfvnaiqJy+ctssIWAAmSaIwzatfhkE912rsgOG8Z0AbFmNxiOnHPqSIS3j24bWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BO4uEPH9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FCEC4AF09;
	Wed,  5 Jun 2024 05:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717563895;
	bh=ugc2bykqt55t/VwJ9UCKNtxoLh62vpOWsbk3df+1xH8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BO4uEPH9S30Q36KtXilbFbS7FpqzfCeJ79caSMleuh8nfMIv6JUxQJd+gZ7VJYdIY
	 laBjeK9YxSe7E15T7h8ECyGaurxGgpSmjlYjPX61L7kDrmikTK21GfsH/P/HqFSYXU
	 2Jl0MsENBgcqJa5f0QsFh6f7JzwF5V405WtixWokfk7HEgPzNmb264JZo7+nT9hDnl
	 qZakvgykeL/Kx9nIoiH+BiwG9dWQdAy2M8ZgD4BF2N5l6qpWtUdA6kqX9pEe83JtNP
	 oqt//3qVw5RB7jxiBr328wbHCGJ5NxD9ni5DzihtKGhqDqf4ll3+1MP7YRKVgeLWby
	 f+7MCmZygiBJQ==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52b840cfecdso2203703e87.3;
        Tue, 04 Jun 2024 22:04:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUwpxo/1BD+5ej7Cb52Vio/btF9aY5fS+ovpu/fChhh95gdRwoQNQXdrRfPToWup9OPsLo0Aya3lgTItLyPvLvGVWd59RdUmUtCRMbljh3cxuzPKuDLxbwO6J4baaS8ftiU7JrBvv1gYSvSRQ==
X-Gm-Message-State: AOJu0YwtSbsjsqHLxfoX4nRNIpj0JMnqG23R6UN5brD+X8hdqzKuctmS
	XpgXueqOFn6ppoVs/N3A8B3PRyqFC5jtiCAX81IXZg33Oaf+vfipD7RiGX/Fvz+udBvlwgQ8cfV
	bGd8QtK4NkyVEZfBpL2bAuPVyHWY=
X-Google-Smtp-Source: AGHT+IHY11EiYpkwOu8YDTv9BnZRnCOn2vR5KiKFthP+mnlG0hUwouE7lByd4T93E6RTObvl31cEChVwMWi2dwtHmwE=
X-Received: by 2002:a05:6512:402a:b0:520:9df8:f245 with SMTP id
 2adb3069b0e04-52bab4c8f5emr1090876e87.1.1717563894277; Tue, 04 Jun 2024
 22:04:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
In-Reply-To: <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Tue, 4 Jun 2024 22:04:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
Message-ID: <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, zhang warden <zhangwarden@gmail.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 1:04=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
[...]
> >
> > Yes, but the information you get is limited compared to what is availab=
le
> > now. You would obtain the information that a patched function was calle=
d
> > but ftrace could also give you the context and more.
>
> Another motivation to use ftrace for testing is that it does not
> affect the performance in production.
>
> We should keep klp_ftrace_handler() as fast as possible so that we
> could livepatch also performance sensitive functions.

At LPC last year, we discussed about adding a counter to each
klp_func, like:

struct klp_func {
    ...
    u64 __percpu counter;
    ...
};

With some static_key (+ sysctl), this should give us a way to estimate
the overhead of livepatch. If we have the counter, this patch is not
needed any more. Does this (adding the counter) sound like
something we still want to pursue?

Thanks,
Song

