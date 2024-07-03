Return-Path: <live-patching+bounces-381-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81FD99264DB
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 17:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37B361F23451
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 15:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C8A1119A;
	Wed,  3 Jul 2024 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q1P8l0nZ"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1FE522F;
	Wed,  3 Jul 2024 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720020636; cv=none; b=qaVH3Ef9w86BM4cL7HCJVRadzH4S2sZsUrzAY91f9vlMXcJTmF+g0HBSHXA2bvgwAcSDXJ0DYe812Y3VU1GFVfLuSwe+oT6BNBfMsHVhchuFr9gXdt2EzoBMhAmmAGTdZukUDj3yLmzFhu1FOO+1sX6IqkcHDJoQgFahk4DsSAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720020636; c=relaxed/simple;
	bh=8bOWBHkjVoAwGSn9nwmSK86pe9A0lVwAvovb0StNCrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRE95CSMgR7m+ie17uAbxxt+WZrOCKRM8Qr6aGxWGrlw3Njl8gBNW7XfMsq6mS0xht7hJIFu4RNkMNj0CLJLq+xXc1RMmeAqFsihr4MNyGc7gL59GHY5IT4l+iXAS4+72OZIYste/PL/ySf46IB/tYmMqIu3SBoHN0TMdtW59eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q1P8l0nZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zcWcmvAw1YBOX10IyvPiRZDRC1NoT/GGhdbFumF76t8=; b=q1P8l0nZvZ3ZmyRQoh8eXHd0q5
	PJpP/d/AHm+OZzKEk3EBSEiTplw+g1aR16vRroiIu/rYYIK4TOy8lKQw86u2zMSW09B98jrdfEEa/
	J5KqfqN1ymmEeEJGLvzWuGRiL3rsWTNFSI7EHLkMG9mPgfEDYSYtqaEyACOCNbqbxcqxFrIK+6EAB
	2pWyVoglf5KX7KFDrRHC7Hos8JdK8FupCU9J/GuTJEOImpoCY1nqqIpdfXcaYkqOOY+K2VssQp23c
	Fk2qNKG7+6SZ029q1b6dxBkVSltpv5zsBMDrMT6Ol9UoiDYa0cKrDokq20G8a11jZgndsqx+6XbR/
	w6aqeyYQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sP1wH-0000000AgNa-49ZW;
	Wed, 03 Jul 2024 15:30:34 +0000
Date: Wed, 3 Jul 2024 08:30:33 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com, nathan@kernel.org,
	morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <ZoVumd-b4CaRu5nW@bombadil.infradead.org>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
 <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
 <20240703055641.7iugqt6it6pi2xy7@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703055641.7iugqt6it6pi2xy7@treble>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Jul 02, 2024 at 10:56:41PM -0700, Josh Poimboeuf wrote:
> On Mon, Jul 01, 2024 at 03:13:23PM +0200, Petr Mladek wrote:
> > So, you suggest to search the symbols by a hash. Do I get it correctly?

I meant, that in the Rust world the symbols go over the allowed limit,
and so an alternative for them is to just use a hash. What I'm
suggesting is for a new kconfig option where that world is the
new one, so that they have to also do the proper userspace tooling
for it. Without that, I don't see it as properly tested or scalable.
And if we're gonna have that option for Rust for modules, then it begs
the question if this can be used by other users.

> > Well, it might bring back the original problem. I mean
> > the commit 8b8e6b5d3b013b0 ("kallsyms: strip ThinLTO hashes from
> > static functions") added cleanup_symbol_name() so that user-space
> > tool do not need to take care of the "unstable" suffix.
> 
> Are symbol names really considered user ABI??  That's already broken by
> design.  Even without LTO, the toolchain can mangle them for a variety
> of reasons.
> 
> If a user space tool doesn't want the suffixes, surely it can figure out
> a way to deal with that on their own?
> 
> > So, it seems that we have two use cases:
> > 
> >    1. Some user-space tools want to ignore the extra suffix. I guess
> >       that it is in the case when the suffix is added only because
> >       the function was optimized.
> > 
> >       It can't work if there are two different functions of the same
> >       name. Otherwise, the user-space tool would not know which one
> >       they are tracing.
> > 
> > 
> >    2. There are other use-cases, including livepatching, where we
> >       want to be 100% sure that we match the right symbol.
> > 
> >       They want to match the full names. They even need to distinguish
> >       symbols with the same name.
> > 
> > 
> > IMHO, we need a separate API for each use-case.
> 
> We should just always link with -zunique-symbols so the duplicate
> symbols no longer exist.  That would solve a lot of problems.

While it might solve this other issue, it doesn't solve the rust module
long symbol name issue.

  Luis

