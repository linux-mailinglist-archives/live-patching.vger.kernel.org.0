Return-Path: <live-patching+bounces-341-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E771900AE4
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 19:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746581C21A7A
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 17:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29F0F19AA63;
	Fri,  7 Jun 2024 17:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRfH1x2m"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0104818059;
	Fri,  7 Jun 2024 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717779600; cv=none; b=JiKjm0NQ6z8JKbeH/N9XbD3DKlv6XyYJWwISolPTfnwrvFguxE0dk8ktfx4+ZYQqUkssExecXaHJEND6sCVuWtQ1LAYTrULcHBEFMDF4kX+1O7gsbYbGabXtzwvhQFVTc48Qg+ieIFDgCbjhdjU44QrnSrZrcBczBjXv+ZcLybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717779600; c=relaxed/simple;
	bh=GBvNsXIMHdMRNwV+HaKNpklwhxJlqMuEiP54hYEuB8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FPDw69SVNByo8nc48xyqIlSfaEcss6uBn23HJK3pskYdL3XlhCdhJB3i6YHI8cbTDjvtKSzUENLce7bl4clru3XfDIf6a/rRibosNoJ1yLmK0WXv3Qji8/8vhsTLgJSHDZl4o1RMNUWNaEGU57PShHWtrPMCDbphTe31fe5vx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRfH1x2m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FFCC32786;
	Fri,  7 Jun 2024 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717779599;
	bh=GBvNsXIMHdMRNwV+HaKNpklwhxJlqMuEiP54hYEuB8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VRfH1x2mAxUen8RyH8MQt6alQ2N21U7F4vG8LddvHQwPG4abxZ90Gk49s72eDKLMf
	 B+coli3INqSjbofZmQ4NZiVmLcIEyxLCnRHrExZuGFwEIBqmkKaHn6DGaghTtMtalW
	 EnkM4W3PfsV6QMW4CH7HpLV4Hn0ppgkfvuM/oZevlwbgfyykUVX+uiRCWJ1R8hIeNP
	 nzan6Q8F7xpiHiikXFk0lkpwQed3Z3BNfyvxt4bBVi8uWjPHUTqrF2Jf9O2h9XubY5
	 dUPbFydqVtoxzEuaLsUZRwuBnimeBSnsk8rfCRIa8NNNdOjIeyFldZYm0c5pJOSMdA
	 XT3zXFRSa3ocQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e72b8931caso24304521fa.0;
        Fri, 07 Jun 2024 09:59:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXU3qsk4bKWukmre2VyOmQ/YWPlUsnrArAJwFBhIZJlFMUAw0Nr5Kg9FKVpCSAlGVyPYgbrikprjhmq5LVzLVEtcOQAkFEcq+48dv/H0IjL5ttFFIZQ4n1zIajq95xEa9RNNgdQd/2OqPeDig==
X-Gm-Message-State: AOJu0YyKnFlLEQq/rp/Co6Afb/AGGBg8PuYMnVrPw/6tSFY1X4o1g0KL
	MkrlgVEccd8TTTYorHiIbViZf4TqSx1IphM3uAId9VvfIVTq9SO91F0k4Re1NQciVKUSwPv+bka
	8pH7QuAi8QzAj4xMd89c9Vfnwk3s=
X-Google-Smtp-Source: AGHT+IG2T51+ixhr6bv9P3DrRoGrciEtqNw7O+SKp06UW/mt1PawrvQmhDXMidxCaCvcH9neI9hpjHW3HfTIO5vY0uY=
X-Received: by 2002:a2e:780b:0:b0:2ea:e9f9:6ac2 with SMTP id
 38308e7fff4ca-2eae9f96be4mr11807711fa.8.1717779597931; Fri, 07 Jun 2024
 09:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz> <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
 <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
From: Song Liu <song@kernel.org>
Date: Fri, 7 Jun 2024 09:59:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4MZ7-UopzbsqhEGzH8FLTK_rTOd05heGOQXm+H7a4a0A@mail.gmail.com>
Message-ID: <CAPhsuW4MZ7-UopzbsqhEGzH8FLTK_rTOd05heGOQXm+H7a4a0A@mail.gmail.com>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>, zhang warden <zhangwarden@gmail.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miroslav,

On Fri, Jun 7, 2024 at 2:07=E2=80=AFAM Miroslav Benes <mbenes@suse.cz> wrot=
e:
>
> Hi,
>
> On Tue, 4 Jun 2024, Song Liu wrote:
>
> > On Tue, May 21, 2024 at 1:04=E2=80=AFAM Petr Mladek <pmladek@suse.com> =
wrote:
> > [...]
> > > >
> > > > Yes, but the information you get is limited compared to what is ava=
ilable
> > > > now. You would obtain the information that a patched function was c=
alled
> > > > but ftrace could also give you the context and more.
> > >
> > > Another motivation to use ftrace for testing is that it does not
> > > affect the performance in production.
> > >
> > > We should keep klp_ftrace_handler() as fast as possible so that we
> > > could livepatch also performance sensitive functions.
> >
> > At LPC last year, we discussed about adding a counter to each
> > klp_func, like:
> >
> > struct klp_func {
> >     ...
> >     u64 __percpu counter;
> >     ...
> > };
> >
> > With some static_key (+ sysctl), this should give us a way to estimate
> > the overhead of livepatch. If we have the counter, this patch is not
> > needed any more. Does this (adding the counter) sound like
> > something we still want to pursue?
>
> It would be better than this patch but given what was mentioned in the
> thread I wonder if it is possible to use ftrace even for this. See
> /sys/kernel/tracing/trace_stat/function*. It already gathers the number o=
f
> hits.

I didn't know about the trace_stat API until today. :) It somehow doesn't
exist on some older kernels. (I haven't debugged it.)

> Would it be sufficient for you? I guess it depends on what the intention
> is. If there is no time limit, klp_func.counter might be better to provid=
e
> some kind of overall statistics (but I am not sure if it has any value)
> and to avoid having ftrace registered on a live patched function for
> infinite period of time. If the intention is to gather data for some
> limited period, trace_stat sounds like much better approach to me.

We don't have very urgent use for this. As we discussed, various tracing
tools are sufficient in most cases. I brought this up in the context of the
"called" entry: if we are really adding a new entry, let's do "counter"
instead of "called".

Thanks,
Song

