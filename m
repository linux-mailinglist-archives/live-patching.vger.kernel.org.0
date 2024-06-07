Return-Path: <live-patching+bounces-340-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CB1900ACB
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 18:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FE1E28AECB
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 16:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9991993B5;
	Fri,  7 Jun 2024 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liZs/Fpg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AF133CFC;
	Fri,  7 Jun 2024 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717779222; cv=none; b=pEz6TAT73is803x4RD08SKWOkpqTItFbgF1xs1D651NU1UrhRuazZPFxMbDqdSTwEBeHtNK/Ddp1CzmDPwPni3S72raTLi8b68StQuIhHR/61SDwnqp7ECcgR0aczsZQb3G96jA9giM0+0aJLdrDmxokCiDstI9bTIfOaRBkNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717779222; c=relaxed/simple;
	bh=AuzKiSundGz1izubyTxaeCOtAmwYbkm4YXdyJ4strq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QSZ1GyWXaC9Xn3HMHu9IDplBcRQSg+pG6VFkkGmu/JRHsYO7tR8/5SAwO3w2DukH4naX1YNcbuMqjl/HKNkwJCplXHen4bL5Lj2ImiqbQCx21oCWwPFbl15bA4m6DuI5DEeCUbMjjUlhIietcAMbxT0+BxF9RHwE+5yY1lqaVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liZs/Fpg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7F7C2BBFC;
	Fri,  7 Jun 2024 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717779221;
	bh=AuzKiSundGz1izubyTxaeCOtAmwYbkm4YXdyJ4strq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=liZs/FpgUBqXh0i2qRbhpFwXZ8OkUrXzEOV0hiHe9CLS2oZ+b4ZElccNGqhf5bH9U
	 FZ21oo6FnA4bRsVpl5LKfQ0CmxACg2+hYTIDP1RkjB213TIHGyEfRTMQwwK0zXsorc
	 DuRdfEvzhWc/sU2IgziSpZC83MlO+I9jp6JtCJCaaf2SHrvJLpEzWsfBIEKV7q8F96
	 OaHP6r8U4w65NsJf9TwWcUFTcGWh1UGnwzotVBBoW/rP/UZxnPfbyR5Cc9/fAymFgL
	 XWvrgQ7oO7AdMpjfqYccCQOkCEyC60Jh+WiX4Wx1/RP/JdG62SpV7wE8O5ITR8XPqM
	 IUE9PhOWiWcyw==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2e6f2534e41so25840541fa.0;
        Fri, 07 Jun 2024 09:53:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXyvQkPIxfFb7LvKdnqYbKAnGlergi+9pyruHedm3iolVNqby9RacLCY8yhvB3p57peqXs+efStk5iNNHn89zmS5pMb/mb08x2bpi7M
X-Gm-Message-State: AOJu0YyvbufcFM8sNENeTJq9wPIXvjdLxljMk/KE67knTV4XekxxbAMP
	Sd7v3C8gz61vPdh701NfwmUCg66+7MApCIt5JAwTWlR+8xMnf8MtgTLnAHdOFLY73Zg87XiwDt7
	MGGqNRgPyse0aueT0e62qz8LEMj0=
X-Google-Smtp-Source: AGHT+IGGeKeTiVxGtxv1cILFWU3/KO7uYeEPfNpbk5IK2mqZFhhsvaJS+hY5OFDU6j49wyy9HSzuSzmFLQyUOgJuNKo=
X-Received: by 2002:a2e:8609:0:b0:2ea:b908:d82a with SMTP id
 38308e7fff4ca-2eadce4ac69mr19892041fa.29.1717779220298; Fri, 07 Jun 2024
 09:53:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605032120.3179157-1-song@kernel.org> <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
From: Song Liu <song@kernel.org>
Date: Fri, 7 Jun 2024 09:53:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
Message-ID: <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
To: Miroslav Benes <mbenes@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
	joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
	justinstitt@google.com, mcgrof@kernel.org, thunder.leizhen@huawei.com, 
	kees@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miroslav,

Thanks for reviewing the patch!

On Fri, Jun 7, 2024 at 6:06=E2=80=AFAM Miroslav Benes <mbenes@suse.cz> wrot=
e:
>
> Hi,
>
> On Tue, 4 Jun 2024, Song Liu wrote:
>
> > With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<has=
h>
> > to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
> > without these postfixes. The default symbol lookup also removes these
> > postfixes before comparing symbols.
> >
> > On the other hand, livepatch need to look up symbols with the full name=
s.
> > However, calling kallsyms_on_each_match_symbol with full name (with the
> > postfix) cannot find the symbol(s). As a result, we cannot livepatch
> > kernel functions with .llvm.<hash> postfix or kernel functions that use
> > relocation information to symbols with .llvm.<hash> postfixes.
> >
> > Fix this by calling kallsyms_on_each_match_symbol without the postfix;
> > and then match the full name (with postfix) in klp_match_callback.
> >
> > Signed-off-by: Song Liu <song@kernel.org>
> > ---
> >  include/linux/kallsyms.h | 13 +++++++++++++
> >  kernel/kallsyms.c        | 21 ++++++++++++++++-----
> >  kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
> >  3 files changed, 60 insertions(+), 6 deletions(-)
>
> I do not like much that something which seems to be kallsyms-internal is
> leaked out. You need to export cleanup_symbol_name() and there is now a
> lot of code outside. I would feel much more comfortable if it is all
> hidden from kallsyms users and kept there. Would it be possible?

I think it is possible. Currently, kallsyms_on_each_match_symbol matches
symbols without the postfix. We can add a variation or a parameter, so
that it matches the full name with post fix.

> Moreover, isn't there a similar problem for ftrace, kprobes, ebpf,...?

Yes, there is a similar problem with tracing use cases. But the requirement=
s
are not the same:

For livepatch, we have to point to the exact symbol we want to patch or
relocation to. We have sympos API defined to differentiate different symbol=
s
with the same name.

For tracing, some discrepancy is acceptable. AFAICT, there isn't an API
similar to sympos yet. Also, we can play some tricks with tracing. For
example, we can use "uniq symbol + offset" to point a kprobe to one of
the duplicated symbols.

Given livepatch has a well defined API, while the APIs at tracing side
may still change, we can change kallsyms to make sure livepatch side
works. Work on the tracing side can wait.

Thanks,
Song

