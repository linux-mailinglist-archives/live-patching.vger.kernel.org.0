Return-Path: <live-patching+bounces-377-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A227291C6A4
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 21:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30C921F25595
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 19:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8390076F1B;
	Fri, 28 Jun 2024 19:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QMBLAbpL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DE76C61
	for <live-patching@vger.kernel.org>; Fri, 28 Jun 2024 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719603143; cv=none; b=uQK654hYwKX85QYkx3betAYG2iV9mDB5xM1uSvhjn6HWOCKqrj4Am3MNcLfLYcYOMurZtYDvvxgKQIqd5SzDuyuVWWAmRS/wo0k0iJanemTvDsUKqSjZVsRtwdNINGlJyqvnj6W0udor8fUrH9yHWuY0vemh6f5znrU1dxXRs4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719603143; c=relaxed/simple;
	bh=1HqrwTCmBM2QNc7VGlQFZsVPZqZRSu5LZL0/UULSrWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9oGTs/kxgrpgHg56NeJ3uLCLf/XPuTm5tc8AiOrmbwnYJYXv1mddA5jPMvJcrCdno2TUnPFEAxEaR9FHiHbKorYbHQ8Y9cFxjIdzY17K1Nr8erf5k1tCUKPFN9tepX/9/kZvVTfIuSC3pfyhZJZjvaGoNVovaCkpj/gsasaT+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QMBLAbpL; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-48c2d353b01so308334137.2
        for <live-patching@vger.kernel.org>; Fri, 28 Jun 2024 12:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719603141; x=1720207941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HqrwTCmBM2QNc7VGlQFZsVPZqZRSu5LZL0/UULSrWo=;
        b=QMBLAbpLXUupuoORh4TZwel+BlFq9znns5VndS3e0a8mreR6fuxlY75CNqaEl/M0rP
         /K/EbAPkaHlEuVdwJ+kVIFyM+YlLzULv4GjpC3wnkWX11J7IAs36DhSXTKlPB4aXjudd
         8xySkNooUIfgC4wDYMgXycb8B8L7yr7gpgCGAE8Df5KtAwWhMFbsuEBiF8IaxntFdx/o
         Zz0Vroccm60oUIsFK7H9stoId5szFLBI2GOLd05brAVPecqdZ4Z0qpDLFfjIy0/3jcgo
         G9AYFm2fUsNALWCGWhyySH1RLrVsPJptJnU7QWwiEKkf8rnCNenTsd3wtc2C11NH8vtz
         wvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719603141; x=1720207941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HqrwTCmBM2QNc7VGlQFZsVPZqZRSu5LZL0/UULSrWo=;
        b=jrZXv/f11T+zOEBtWENh5Uo60oXxPm0Rostn2+nP+ovDkK7/sjrMb8DcERhyhKBJYl
         NzQQQm2dVjm5DpcGVyuBux42hxGP4wKbdvqZargPhxXUSvyFleb1cUtQXFkrwrutFWln
         f/XjLgyLniieVyrKkiU9gMwK/ApclAvecy4lvI4nwiS6YFrUhwxtwQlhIGAVrNYKQ/2I
         cpVcLbToE0GEmQiS5GqKHVvx7WIR7f9qs78hl/vgHXPl9bbTZmq5Re980z2okRA/7Poc
         RFjTQbfYCyKGLCZy5mi4i3f3+167kz4l3Gs1c9L9NhdaxvYrk3vAICDkrkTFpJ8t01Tr
         HO1A==
X-Forwarded-Encrypted: i=1; AJvYcCWGkhucrseQrl8YDUKGI3F5JT5N6Z/YuVOr0Q+RwRsYAZ53vuS+OxnvYeiEIF3UupNCK0hkZ4upEGCYKczSLP2Z/RDGgE//sg+xDiXeXQ==
X-Gm-Message-State: AOJu0YxVdlQ8EATmcD3dCdI7hrre1fJSycXvfFi+MZH5IihJkxcnir2X
	4EdxUWhhehV13rj+1m/RNi1xE7BnEtT6/39yLlEy9wH5XZXl1OfzEtJKaNakyM7p5z8yxrQedpj
	0MH3vdtN/HSDkFE8uNLPzi6fRt9kkVhZf8eXv
X-Google-Smtp-Source: AGHT+IHoV8+BvKNf866lBkiCwD56oFKk4cG0nxGVQQGPfld/KkxwQwgZ/sgUtLg001bSDg6+n89z9/3+KUnVimZFfaA=
X-Received: by 2002:a05:6102:3968:b0:48f:4416:dd59 with SMTP id
 ada2fe7eead31-48f52b9ac8bmr17232450137.33.1719603140695; Fri, 28 Jun 2024
 12:32:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605032120.3179157-1-song@kernel.org> <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz> <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
In-Reply-To: <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 28 Jun 2024 12:31:41 -0700
Message-ID: <CABCJKucLzNB+kd5UEOzUrTU36_vgtPVb-rQyf_d0kNtNjh2UkA@mail.gmail.com>
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, Song Liu <song@kernel.org>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
	pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org, 
	morbo@google.com, justinstitt@google.com, thunder.leizhen@huawei.com, 
	kees@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Fri, Jun 28, 2024 at 10:36=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> On Fri, Jun 28, 2024 at 02:23:49PM +0200, Miroslav Benes wrote:
> > On Fri, 7 Jun 2024, Song Liu wrote:
> >
> > > Hi Miroslav,
> > >
> > > Thanks for reviewing the patch!
> > >
> > > I think it is possible. Currently, kallsyms_on_each_match_symbol matc=
hes
> > > symbols without the postfix. We can add a variation or a parameter, s=
o
> > > that it matches the full name with post fix.
> >
> > I think it might be better.
> >
> > Luis, what is your take on this?
> >
> > If I am not mistaken, there was a patch set to address this. Luis might
> > remember more.
>
> Yeah this is a real issue outside of CONFIG_LTO_CLANG, Rust modules is
> another example where instead of symbol names they want to use full
> hashes. So, as I hinted to you Sami, can we knock two birds with one ston=
e
> here and move CONFIG_LTO_CLANG to use the same strategy as Rust so we
> have two users instead of just one?

I'm all for finding generic solutions, but perhaps I've missed the
patch set Miroslav mentioned because I'm not quite sure how these
problems are related.

LTO makes duplicate symbol names globally unique by appending a
postfix to them, which complicates looking up symbols by name. Rust,
on the other hand, has a problem with CONFIG_MODVERSIONS because the
long symbol names it generates cannot fit in the small buffer in
struct modversion_info. The only reason we proposed storing a
cryptographic hash in modversion_info was to avoid breaking userspace
tools that parse this data structure, but AFAIK nobody wants to use
hashed symbol names anywhere else. In fact, if there's a better
solution for addressing modversion_info limitations, I would be happy
not to hash anything.

Sami

