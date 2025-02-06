Return-Path: <live-patching+bounces-1123-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E66EDA2AF9D
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 19:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBF401889FC7
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 18:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1119194A67;
	Thu,  6 Feb 2025 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uywgBUB1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF9239577;
	Thu,  6 Feb 2025 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738864863; cv=none; b=K7s+ezuviboqYSix57E/4wSrJkMHbSfYYGxylq0aaqtbn06aqLg/waOEHdpjz9QY/qhHQEfdqyzle70lA35/JcfpjcYmGgoe9QaqvjYf/j2RrT93kRQJkinE8zPiulLBqs3BSDmtZolYKbHowmBu1CsIguIqHlB357S5k/bp6VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738864863; c=relaxed/simple;
	bh=O7VoG24kpLc6opkAfLVI4F/seoZVTWngl8tFxkdBPFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YsGO9Zfm5SzgBNvNf2zHWh5wrvIdK2ZB1bVNQuSs6xLPF+yn3mSBZn828pkKI/7mpYGdZBEH6QFHulgO14x2wSK74eJ6DCaXH1YuHaDhreQpdaT1GYFYJgpyfXEPgP6LIyCtHkKuVAaoKnk2UB6WJnYH6GtTbrUckwJ5MNgBfx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uywgBUB1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75C4C4CEE6;
	Thu,  6 Feb 2025 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738864862;
	bh=O7VoG24kpLc6opkAfLVI4F/seoZVTWngl8tFxkdBPFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uywgBUB1aewnq2M8j3iaWzdT9ghgYhCgOBJesuLHh9LQAWhbnYa4WCM6MK4tySIa/
	 subc8iDouqRqAfkd0NAVpIFBw+g5vTuJTscLLWMvlFXnPvIiiC31ZAC3CbLSsaNVGy
	 1MMRR+AQp+wF+d14hKqDKFq9ItDUNKlqcZI06LM9L0MB595LWCHsJ9iSejxLm0p9IA
	 11XLiWpq4eD5GC/bixaMnEGr5niL6fZmpUmdjPoigKWhfof9Fp4wW7RSwxnYqU4VJW
	 4wSCM28YI9/abs/ZF8TNe920DqFaO3KXIHqVByowOg9CaIl243xlm3wGxLwHpqKhOq
	 vwbiPWt9Ub58Q==
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-854a68f5aeeso27509139f.0;
        Thu, 06 Feb 2025 10:01:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU3kAXyMfPdY/4E5qgwpI1rW1FEjkpyWqN4s+/D0uSX694/U21tZ2vztEOhShUyVfyiGzQuNvPG+JPbBDk=@vger.kernel.org, AJvYcCU6GHGsy2tCJCEj6/iVjdxg2OV9N7vxcTW79zeos7pexvmbczccffJzbPryLIfmZ4TC9MCP65MSyF4D4B6+jA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMfoLv2ZDc8G/zWtZ3fKzTmYr354VPvkSrhZXuTnxz71y4KBzz
	hrQDDZee3gNnsY8EMqlDFQH5RTTqxIQ+nistbCBlTWA5zPz6Hq8TfC1C6MaSFalv3Xhe6V6896j
	WjAqdHqe2/hFyzQnsyAzVARQLjvU=
X-Google-Smtp-Source: AGHT+IHc3CF3qpERKpvkru8HLokQQbkyr5RO7u6PkRygf44hbmn7XI7Fxlsjfh6gv2fDi8ybWs8hEszc1kcGYmfVKcQ=
X-Received: by 2002:a05:6e02:1547:b0:3a7:6566:1e8f with SMTP id
 e9e14a558f8ab-3d04f8f72b2mr64231875ab.16.1738864862128; Thu, 06 Feb 2025
 10:01:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
 <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com> <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
In-Reply-To: <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 6 Feb 2025 10:00:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
X-Gm-Features: AWEUYZmhcEFRQF3o4-YG-4k1WzQo_xoZ_rF7gs6PuIkaa18bSZaq8_oskbkx8EE
Message-ID: <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf <bpf@vger.kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 6:55=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
[...]
> > I think we should first understand why the trampoline is not
> > freed.
>
> IIUC, the fexit works as follows,
>
>   bpf_trampoline
>     + __bpf_tramp_enter
>        + percpu_ref_get(&tr->pcref);
>
>     + call do_exit()
>
>     + __bpf_tramp_exit
>        + percpu_ref_put(&tr->pcref);
>
> Since do_exit() never returns, the refcnt of the trampoline image is
> never decremented, preventing it from being freed.

Thanks for the explanation. In this case, I think it makes sense to
disallow attaching fexit programs on __noreturn functions. I am not
sure what is the best solution for it though.

Thanks,
Song


> >
> > > We could either add functions annotated as "__noreturn" to the deny
> > > list for fexit as follows, or we could explore a more generic
> > > solution, such as embedding the "noreturn" information into the BTF
> > > and extracting it when attaching fexit.
> >
> > I personally don't think this is really necessary. It is good to have.
> > But a reasonable user should not expect noreturn function to
> > generate fexit events.

