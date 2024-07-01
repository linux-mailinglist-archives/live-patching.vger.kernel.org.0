Return-Path: <live-patching+bounces-378-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5735D91E054
	for <lists+live-patching@lfdr.de>; Mon,  1 Jul 2024 15:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73DC71C2247C
	for <lists+live-patching@lfdr.de>; Mon,  1 Jul 2024 13:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A925315D5CC;
	Mon,  1 Jul 2024 13:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZFxPA3i4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9B82D93
	for <live-patching@vger.kernel.org>; Mon,  1 Jul 2024 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719839620; cv=none; b=d6xmgyR8lnyJCDuNzHnzALV7dAXmKDjNEyDRsKBx2E5+bJEzuRsS0hlZ1OZ6MV3McrdQiDXAirtuzwRvjFHGP6HnMUZUuRgci4IIJC2fa/mCOWKMxVEAcurvwfzfAL0Uju8qOJ/SqBfwe/NQCkYbRQrfwKesa+r6JN6zJ8EZP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719839620; c=relaxed/simple;
	bh=X1xqYcKxhEqksta9F6+PAgNFku7VwC9TA9WS5zubs+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3z/X/e3hW9KnM9lJ6UJ3CgdFujBR+wArHbgh2QievA8xfjpIbAnnTX1TZT0HRNb9XdwvO5eJtHbp3nhtXG6DIYvXtwYkhAR7ANcbsO2IM6tZVuC1pSlUfV+ZHJoPSK0nFQAR+XEAbIWy2ujm5k7X1MT2dCos2joXWGR3HHfr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZFxPA3i4; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2eaea28868dso41854371fa.3
        for <live-patching@vger.kernel.org>; Mon, 01 Jul 2024 06:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719839616; x=1720444416; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PMZrss2U3YMCU2gehj174wPWeOrCwWO2m+b4W1tpn9w=;
        b=ZFxPA3i4lZMf+OIEmaZsN1sw6gE2vEmMhUATI24+hSvVe/1HYKXs/qYX6YES1narcY
         rhz6xT99FJi8X0HG5ETcXyzHkqj0C6RjfUmI8KGly3b9Hfz/l2kvfLKiKNWtvlu+bBDK
         pbS71fuIJKaV1gZT+q4nr9SxypzB6Ft5DSHo1dY6TpwFMhGs346yGXLK1DsecTM2T471
         oENTb6UoKhdB6Cmd978Mh5KTEd0hhR3pCN4HqpmYYSJ4TKsTk9vEzq7V1kgPzq5PhimT
         7keVl/OJoPjQbgrG3cvqA4+cCdMrq1Z+mzOrFUN8zniSl+F6z9vZzovlHSA8T2TUVCLg
         RnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719839616; x=1720444416;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PMZrss2U3YMCU2gehj174wPWeOrCwWO2m+b4W1tpn9w=;
        b=geui8OewRdpWZHQwJkKmQKubUVqJa3ox9oxxrhfQgA6hQvdVleWBXvoMzuBwZSmYrp
         8SOwCKwCL9IUP8F7i3rTooo7fuKlwcfLouohLidzl1AGoCR8Z2I5/9mu38nVfr8Ci8lW
         TQABrTdeNR4bO88y3dsgV0h+nfp/nMh/+mXHoAt6FM2tdkupqHOuiMHEVPJi8NOVydVS
         nqr2T+NSWv+6nyhvT5XzG8MKJXVTtJGCGlEoJqyb0rgVf6g4Mf1MToh0yAj8qHPTky8X
         tJ9pD41Le6d9sEOA7E6RnzWOe93cYdmKONypEob3bpfzn2fIYsXvjLMjwcy2V6DMVDMP
         azRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg5N5Rkr17WsjHhPrdJ8VeQYJ5ifIZVec5SR97NE6FYx+9OnDhRBVOn8/6VsYlMw2BAviaH77TgGx+XqUd2acm8z/eWk4gWd0McjF7dA==
X-Gm-Message-State: AOJu0Yzw13TMAiH9I65NplNzT0eJgluVW2Ak8OILN5VSqTy5yOmvzsG3
	puLeskdtPCo7gP1Ov5WTCO+z0+gcjGGBDPbg4opWWmbsJIowAM+uRYMizCn4dJ0=
X-Google-Smtp-Source: AGHT+IF+mb29Cx6OyDWYBUeFAC8VB1iv5b+zJARyMloC2bSs0QHLV080ePtRlc/xmjNtDKtCLGbgfw==
X-Received: by 2002:a05:651c:103a:b0:2eb:eb96:c07d with SMTP id 38308e7fff4ca-2ee5e3936ffmr44184101fa.14.1719839616256;
        Mon, 01 Jul 2024 06:13:36 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70804a9540fsm6393679b3a.216.2024.07.01.06.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 06:13:35 -0700 (PDT)
Date: Mon, 1 Jul 2024 15:13:23 +0200
From: Petr Mladek <pmladek@suse.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com,
	nathan@kernel.org, morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>

On Fri 2024-06-28 10:36:45, Luis Chamberlain wrote:
> On Fri, Jun 28, 2024 at 02:23:49PM +0200, Miroslav Benes wrote:
> > On Fri, 7 Jun 2024, Song Liu wrote:
> > 
> > > Hi Miroslav,
> > > 
> > > Thanks for reviewing the patch!
> > > 
> > > On Fri, Jun 7, 2024 at 6:06 AM Miroslav Benes <mbenes@suse.cz> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Tue, 4 Jun 2024, Song Liu wrote:
> > > >
> > > > > With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<hash>
> > > > > to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
> > > > > without these postfixes. The default symbol lookup also removes these
> > > > > postfixes before comparing symbols.
> > > > >
> > > > > On the other hand, livepatch need to look up symbols with the full names.
> > > > > However, calling kallsyms_on_each_match_symbol with full name (with the
> > > > > postfix) cannot find the symbol(s). As a result, we cannot livepatch
> > > > > kernel functions with .llvm.<hash> postfix or kernel functions that use
> > > > > relocation information to symbols with .llvm.<hash> postfixes.
> > > > >
> > > > > Fix this by calling kallsyms_on_each_match_symbol without the postfix;
> > > > > and then match the full name (with postfix) in klp_match_callback.
> > > > >
> > > > > Signed-off-by: Song Liu <song@kernel.org>
> > > > > ---
> > > > >  include/linux/kallsyms.h | 13 +++++++++++++
> > > > >  kernel/kallsyms.c        | 21 ++++++++++++++++-----
> > > > >  kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
> > > > >  3 files changed, 60 insertions(+), 6 deletions(-)
> > > >
> > > > I do not like much that something which seems to be kallsyms-internal is
> > > > leaked out. You need to export cleanup_symbol_name() and there is now a
> > > > lot of code outside. I would feel much more comfortable if it is all
> > > > hidden from kallsyms users and kept there. Would it be possible?
> > > 
> > > I think it is possible. Currently, kallsyms_on_each_match_symbol matches
> > > symbols without the postfix. We can add a variation or a parameter, so
> > > that it matches the full name with post fix.
> > 
> > I think it might be better.

Also, I agree that we need another variant of kallsyms_on_each_match_symbol()
which would match the full name.

> > Luis, what is your take on this?

[ Luis probably removed too much context here. IMHO, the following
  sentence was talking about another problem in the original mail..

> > If I am not mistaken, there was a patch set to address this. Luis might 
> > remember more.

I believe that Miroslav was talking about
https://lore.kernel.org/all/20231204214635.2916691-1-alessandro.carminati@gmail.com/

It is a patch solving the opposite problem. It allows to match
an exact symbol even when there were more symbols of the same name.
It would allow to get rid of the sympos.


> Yeah this is a real issue outside of CONFIG_LTO_CLANG, Rust modules is
> another example where instead of symbol names they want to use full
> hashes. So, as I hinted to you Sami, can we knock two birds with one stone
> here and move CONFIG_LTO_CLANG to use the same strategy as Rust so we
> have two users instead of just one? Then we resolve this. In fact
> what I suggested was even to allow even non-Rust, and in this case
> even with gcc to enable this world. This gives much more wider scope
> of testing / review / impact of these sorts of changes and world view
> and it would resolve the Rust case, the live patch CONFIG_LTO_CLANG
> world too.

So, you suggest to search the symbols by a hash. Do I get it correctly?

Well, it might bring back the original problem. I mean
the commit 8b8e6b5d3b013b0 ("kallsyms: strip ThinLTO hashes from
static functions") added cleanup_symbol_name() so that user-space
tool do not need to take care of the "unstable" suffix.

So, it seems that we have two use cases:

   1. Some user-space tools want to ignore the extra suffix. I guess
      that it is in the case when the suffix is added only because
      the function was optimized.

      It can't work if there are two different functions of the same
      name. Otherwise, the user-space tool would not know which one
      they are tracing.


   2. There are other use-cases, including livepatching, where we
      want to be 100% sure that we match the right symbol.

      They want to match the full names. They even need to distinguish
      symbols with the same name.


IMHO, we need a separate API for each use-case.

Best Regards,
Petr

