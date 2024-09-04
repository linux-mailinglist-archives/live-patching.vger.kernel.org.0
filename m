Return-Path: <live-patching+bounces-586-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE70A96B316
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70B0B1F21544
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5BE146A79;
	Wed,  4 Sep 2024 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EPzA+7jr"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDF0383A3;
	Wed,  4 Sep 2024 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435781; cv=none; b=TRXTvFYJQv4sCuSIkgGESNAClM8jK/KfCGw2xiVh21E4OdBgggJfhy9w52WaRHD0fvKkHY3kSuB45o6oxbXu9PGHuU/OdamV9J3XiQTQjkVlaB/qVEv8V+w/98fz4RYnT+t7xnL9wIJPOLpawE1yExO/F6KbZL2TbShrN3jdjrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435781; c=relaxed/simple;
	bh=uwBR9gA5n32jGX1WxQS+J1LikbGE2Zea9/SkdZGGd5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxqJUO2I6auYsjd5B8VmBIKxhkr/vZhfMa6Tfo2v92V71EhzT6idqFVU79rBloTgFj15SU3X8jKAwKT6t9O3O4Use5GPlHIZpV4JAGIDnU81cQ//D0/jCEn8LO741WLLLy+JalclQZIRIo/mIt2WTvI6Gbc/bfgLD7HXW9Vozho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EPzA+7jr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oIr5NQctAXvznghKyBIffsWxr2oGkb0ae6NRJ1vU5i0=; b=EPzA+7jrrjbXbLFkZ1goWYvkYC
	ccrJH4YDiy1Bgic6LyCoGzV+nrSC0pRh191rnVzKaZhPdOeSlI5vHKZ+zgl8zkmr3jcF//BqMq5vB
	NFVJpa8/oJF6W8Irp7FVVUllgsPn7LnFh/6ofMnHjAhEl3o41Z0suOmxUtMn4fXfOBknUunpo1jra
	Oe5hruAxqfv3PPyVTUCx5fOQJMNiL/sY1LH5BzXYpk9FmPB8L62EubWDESz0jFJRbMKyXtZgClAm7
	f80kEV0cSPG8BDgCe96oTUAu3Cxb58FHi+pue8rnBSu+aHiFdRZpAsoSs1c4ZfZWCgLfBDD8yQGEK
	jfIZMm2Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1slkfH-00000000AVo-26lb;
	Wed, 04 Sep 2024 07:42:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 67B8B3004AF; Wed,  4 Sep 2024 09:42:54 +0200 (CEST)
Date: Wed, 4 Sep 2024 09:42:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 27/31] objtool: Fix weak symbol detection
Message-ID: <20240904074254.GB4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>
 <20240903082645.GO4723@noisy.programming.kicks-ass.net>
 <20240904035513.cnbkivqibdklzpw2@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904035513.cnbkivqibdklzpw2@treble>

On Tue, Sep 03, 2024 at 08:55:13PM -0700, Josh Poimboeuf wrote:
> On Tue, Sep 03, 2024 at 10:26:45AM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 02, 2024 at 09:00:10PM -0700, Josh Poimboeuf wrote:
> > > @@ -433,9 +433,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> > >  	/*
> > >  	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
> > >  	 * can exist within a function, confusing the sorting.
> > > +	 *
> > > +	 * TODO: is this still true?
> > 
> > a2e38dffcd93 ("objtool: Don't add empty symbols to the rbtree")
> > 
> > I don't think that changed.
> 
> But see two patches back where I fixed a bug in the insertion of
> zero-length symbols.
> 
> I was thinking that might actually be the root cause of the above
> commit.

Aah, yeah, might be. If we can reproduce the original problem, it should
be verifiable.

