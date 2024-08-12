Return-Path: <live-patching+bounces-479-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B62D694F3B9
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 18:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E81E71C215E5
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 16:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265A3186E5E;
	Mon, 12 Aug 2024 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O918mw9a"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAFE186E47;
	Mon, 12 Aug 2024 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479680; cv=none; b=NG0TW+wR6MAMwhh0aFjfVbgq4GG6dOAb0f5jWZ0IIAnq6zVeMoBvOiem1lez3ZLipeSnfBy6l2vd6B6Wk9fTfuwDwEnMUWM6judit/IysMx4lxhNm5QG8mHNWPwkXFD6S5Fxe6BgVjZLRF4krbnSDRFtw8HF8bxWTdAxArb+0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479680; c=relaxed/simple;
	bh=q7lywxpr/YZ3ic0N8DxjmCMjT3WvmnXYK46+bK4R9go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TfpjF9zHHQePrpBang0VbmuEBfhjVAJXqKctrRmxjbOnxrDRFJZ0y0r846OghRDjwT3wPsqLCgvIRzLmNCRh2OCJFnk9jfASeNv9x9HP6x8jKAgZypkGXfFkw6m640GYjFstyfaRXdae0AOxjvxzs48s7XP2SaS2tTXiym0du8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O918mw9a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE251C4AF12;
	Mon, 12 Aug 2024 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723479679;
	bh=q7lywxpr/YZ3ic0N8DxjmCMjT3WvmnXYK46+bK4R9go=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O918mw9aIyuiBomP4feC+9/Wnr+K2CisAuy1PgFAyVbBx5QqEUfvLfg0KHQmdB6OF
	 ttUPPUlsHMg2vwq6QwZ+wdS01YfbqC7Mvxy3FpWApNoig524rRxshzqnbTtIJFXLT1
	 Wb2deaeoHYrZW1+Y3RIcHMyBnnkI6GSfjDD/KOFUsO5TBVvypZq4Wd+ttHL5XGPmBp
	 E5Pw6IBHo9xQHuxmDrnq0sP44MDA5EiqeFLzCFrqTyxVzPLqhKMYzXp6vpmUX5kXJq
	 7ToqX6sSTPw8Lw1J/HXl/YllVYERFMSCJUWH5BaSYOdiS4H8v9i7MBqMrHmboqC4G4
	 Rt9XT7cam69VQ==
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fd640a6454so34297495ad.3;
        Mon, 12 Aug 2024 09:21:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX55DK++VckUj902vRrhopLoAYHxXnuXp8bXjJnL4Zw8jknW4HQI1H/86Wdc/wOIolBmEvBDFZuaxUotredEtniCiyTist/L7TUNe7qrOx9hjnuqEG+lWj3eDzZC/BtUvDzHgynfqfFBcHn6T+lWxhr
X-Gm-Message-State: AOJu0YyXEcEZ3g1IWHWmFeJ5jVmZEYlqsaLoVvMmdR8/Sz8lMnWmeaiz
	O+GTMNjlllKyUcOKhGicj2ZHO0BM0WNSK8Cw2Ph2LYKzImEgOfmeD0MuaWHVqNO8L1/SGA3ToOo
	UjkPjVtkmJ5IbR4g2cgnGC/yTalg=
X-Google-Smtp-Source: AGHT+IHUTx3hyWNDBJhh0g6ZhitS14bpeovi83lfWg7B2UHoE6zydimWrZIbCpyNnoDUmQCDL6eLpW+4E5PVbElB62I=
X-Received: by 2002:a17:902:e5c8:b0:1fb:bd7:f232 with SMTP id
 d9443c01a7336-201ca13c388mr9784015ad.23.1723479679221; Mon, 12 Aug 2024
 09:21:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807220513.3100483-1-song@kernel.org>
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 12 Aug 2024 09:21:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
Message-ID: <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
To: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
	justinstitt@google.com, mcgrof@kernel.org, thunder.leizhen@huawei.com, 
	kees@kernel.org, kernel-team@meta.com, mmaurer@google.com, 
	samitolvanen@google.com, mhiramat@kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi folks,

Do we have more concerns and/or suggestions with this set? If not,
what would be the next step for it?

Thanks,
Song

On Wed, Aug 7, 2024 at 3:05=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly.
>
> Address this by sorting full symbols at build time, and let kallsyms
> lookup APIs to match the symbols exactly.
>
> Changes v2 =3D> v3:
> 1. Remove the _without_suffix APIs, as kprobe will not use them.
>    (Masami Hiramatsu)
>
> v2: https://lore.kernel.org/live-patching/20240802210836.2210140-1-song@k=
ernel.org/T/#u
>
> Changes v1 =3D> v2:
> 1. Update the APIs to remove all .XXX suffixes (v1 only removes .llvm.*).
> 2. Rename the APIs as *_without_suffix. (Masami Hiramatsu)
> 3. Fix another user from kprobe. (Masami Hiramatsu)
> 4. Add tests for the new APIs in kallsyms_selftests.
>
> v1: https://lore.kernel.org/live-patching/20240730005433.3559731-1-song@k=
ernel.org/T/#u
>
> Song Liu (2):
>   kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
>   kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
>
>  kernel/kallsyms.c          | 55 +++++---------------------------------
>  kernel/kallsyms_selftest.c | 22 +--------------
>  scripts/kallsyms.c         | 31 ++-------------------
>  scripts/link-vmlinux.sh    |  4 ---
>  4 files changed, 9 insertions(+), 103 deletions(-)
>
> --
> 2.43.5

