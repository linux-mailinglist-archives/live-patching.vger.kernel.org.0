Return-Path: <live-patching+bounces-376-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DDA91C503
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 19:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4ED52847AD
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 17:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F3F1CCCAC;
	Fri, 28 Jun 2024 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PcXrirVn"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69764CB37;
	Fri, 28 Jun 2024 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719596210; cv=none; b=secOgvDXR6gV2oN9ZwODbwaspbRnJynF3d7oqg7RraXlNpD+9gE7i/mUYDKmXXlOxXizc5SLYtgcH0V/f8HGEioB3NycSTFRqGzKWlEqSZ+uuxImUAzgF+pchewPlDYUpBNVPYWK0VgQHtwlP4UUb7FTyBQrxTICcvZJKMfu0GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719596210; c=relaxed/simple;
	bh=EhZk8ov/+gx8/lrWCRB2HKYFrjU/LYKtTPr2bfFADkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLEzoaE0CpvyiY+lQPLYoJlz6EY7gj2iWvvTOrZSR2scE9X+UzUThJU9NITpPSe9PMO55neH9mjyFZdX76XlPpKUBai5cQaIXqKnr5Nlkar/EPW9qyxEdeJbAdvb6fb6Dype3HYpWuhrAq/qYKvmJhTI9Nlh9UnYpLldRdgRLAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PcXrirVn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=Oedd6VxbM8c0ETZBw+6nJVaIHdNvh+x7QH0mcDQfB2U=; b=PcXrirVnlv4NdeggBI1FIfE26O
	LXErvKkvGhncHmcOBY+1kWkfaJkKeIEaYJpDTAMsbfSJMHYA6U7zFojHE1y6tRWUB93eFZ9UI1ZE1
	snf7aPWYCr/KaJb0/BbxN/khNnOWvNOlr3NolTGZ0W2dQaUCaoqw+Q/6duCECdwNvLdOPP33G2o7g
	QU9k3MUw3X7LAKq3DsXAr25TDR8vQ7FIoLj4SpSsSExg+BZ/1SW83cAtCKTrJ3SWgSuOJFR2BrBxR
	VtDuMbnlz79ek7nJB/KRstJwgqlbRcZajZOqf6ySJPxj4wYBdJ+wS+JVj1UnaakslJMHSWtGxyBEG
	supYSOtA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNFWf-0000000EWKx-24rt;
	Fri, 28 Jun 2024 17:36:46 +0000
Date: Fri, 28 Jun 2024 10:36:45 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>
Cc: Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org,
	morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Jun 28, 2024 at 02:23:49PM +0200, Miroslav Benes wrote:
> On Fri, 7 Jun 2024, Song Liu wrote:
> 
> > Hi Miroslav,
> > 
> > Thanks for reviewing the patch!
> > 
> > On Fri, Jun 7, 2024 at 6:06 AM Miroslav Benes <mbenes@suse.cz> wrote:
> > >
> > > Hi,
> > >
> > > On Tue, 4 Jun 2024, Song Liu wrote:
> > >
> > > > With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<hash>
> > > > to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
> > > > without these postfixes. The default symbol lookup also removes these
> > > > postfixes before comparing symbols.
> > > >
> > > > On the other hand, livepatch need to look up symbols with the full names.
> > > > However, calling kallsyms_on_each_match_symbol with full name (with the
> > > > postfix) cannot find the symbol(s). As a result, we cannot livepatch
> > > > kernel functions with .llvm.<hash> postfix or kernel functions that use
> > > > relocation information to symbols with .llvm.<hash> postfixes.
> > > >
> > > > Fix this by calling kallsyms_on_each_match_symbol without the postfix;
> > > > and then match the full name (with postfix) in klp_match_callback.
> > > >
> > > > Signed-off-by: Song Liu <song@kernel.org>
> > > > ---
> > > >  include/linux/kallsyms.h | 13 +++++++++++++
> > > >  kernel/kallsyms.c        | 21 ++++++++++++++++-----
> > > >  kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
> > > >  3 files changed, 60 insertions(+), 6 deletions(-)
> > >
> > > I do not like much that something which seems to be kallsyms-internal is
> > > leaked out. You need to export cleanup_symbol_name() and there is now a
> > > lot of code outside. I would feel much more comfortable if it is all
> > > hidden from kallsyms users and kept there. Would it be possible?
> > 
> > I think it is possible. Currently, kallsyms_on_each_match_symbol matches
> > symbols without the postfix. We can add a variation or a parameter, so
> > that it matches the full name with post fix.
> 
> I think it might be better.
> 
> Luis, what is your take on this?
> 
> If I am not mistaken, there was a patch set to address this. Luis might 
> remember more.

Yeah this is a real issue outside of CONFIG_LTO_CLANG, Rust modules is
another example where instead of symbol names they want to use full
hashes. So, as I hinted to you Sami, can we knock two birds with one stone
here and move CONFIG_LTO_CLANG to use the same strategy as Rust so we
have two users instead of just one? Then we resolve this. In fact
what I suggested was even to allow even non-Rust, and in this case
even with gcc to enable this world. This gives much more wider scope
of testing / review / impact of these sorts of changes and world view
and it would resolve the Rust case, the live patch CONFIG_LTO_CLANG world too.

Thoughts?

  Luis

