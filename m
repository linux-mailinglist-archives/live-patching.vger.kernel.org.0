Return-Path: <live-patching+bounces-1867-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBEFC68691
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 10:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 53FB53800DB
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 09:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DD63148A7;
	Tue, 18 Nov 2025 08:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UiAaGG/T"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB913168FB;
	Tue, 18 Nov 2025 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763456237; cv=none; b=Rtiggo8uSamaE1/ylCaEixTIwviVEwPJUZZbKPRzOpqCa2LmqL7kfP6Km9GPKc7r1SsnOJy0X+tK+aKJhZMSMWloflc3jCbL81ugnCsFskTjG2vGJ5qawGsy6bFevazPBECr++N4muzKTRKMWyPJUCtCeC60G4PThTz9WW/Ik9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763456237; c=relaxed/simple;
	bh=jtF24oqXKV38QAtwB4LIg4K8MLwomoNHbXaOVjRNMXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quypiTuJw+OyXJ4a7Y3KoLWo4utxhCuWmEqtRUUNNRDZPP1Jfq0626tOv/vA5id43BU7otgUiF28zkP5YyiRkczZFCxsEIEkapLp/TCpM3O5YfQrkhvhOIaI7h1+V2YeNKU3PvBccGBxg+zSX87S68wTOdPP3dCz8TY3CZJgomg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UiAaGG/T; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/Y4nswG6J5ULjiEpnCB9DinGbRNrn8YTqX7MUHOf0I8=; b=UiAaGG/T5mrVoFiphxpXWxXkmc
	NXVlSBEuxaBIHX6tMDUoXeSHPqvsSViJ88zqtRU2IaqPFsBCro2+lB7gSh6l1Z0On5gm73ikz1RFk
	hfdqRj1ZHT8ZWYi8jFjPjcoTTVHJRQjqtSzbqk4c6deBUiGG4TQ5I82cf/E+72oQwJmEMGmpzsqS9
	Mdm8n3us7jHP7vR3Da7aif83UNWY6Qnm2gLo3b0huuUm7XhdX6n4epgmhcZ9fl/r7Fv0iO60V2/IX
	E7jqo9vWClkJezF6/Cewn+DKkzQ2UO8DTwtunI+HL9msCvzkRQvIt5VWhCXv2dGgK5P2DNi8omdYI
	GIFZtzNg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLGeo-00000009DRq-3k6o;
	Tue, 18 Nov 2025 08:01:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 20AD630029E; Tue, 18 Nov 2025 09:57:11 +0100 (CET)
Date: Tue, 18 Nov 2025 09:57:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 2/4] media: atomisp: Fix startup() section placement with
 -ffunction-sections
Message-ID: <20251118085711.GL3245006@noisy.programming.kicks-ass.net>
References: <cover.1762991150.git.jpoimboe@kernel.org>
 <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
 <20251114085657.GR278048@noisy.programming.kicks-ass.net>
 <2a3d4d7fco4szxyrw33lorkhckjq4styfsaljxxwd3v4o42i5z@qdavomj5i2mu>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a3d4d7fco4szxyrw33lorkhckjq4styfsaljxxwd3v4o42i5z@qdavomj5i2mu>

On Fri, Nov 14, 2025 at 12:43:10PM -0800, Josh Poimboeuf wrote:
> On Fri, Nov 14, 2025 at 09:56:57AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 12, 2025 at 03:47:49PM -0800, Josh Poimboeuf wrote:
> > > When compiling the kernel with -ffunction-sections (e.g., for LTO,
> > > livepatch, dead code elimination, AutoFDO, or Propeller), the startup()
> > > function gets compiled into the .text.startup section.  In some cases it
> > > can even be cloned into .text.startup.constprop.0 or
> > > .text.startup.isra.0.
> > > 
> > > However, the .text.startup and .text.startup.* section names are already
> > > reserved for use by the compiler for __attribute__((constructor)) code.
> > > 
> > 
> > Urgh, that's a 'fun' one. Is this not a -ffunction-sections bug? I mean,
> > the compiler should never put regular non-reserved user symbols in a
> > section it has reserved for itself, right?
> 
> Right, so there's no ambiguity *IF* we know in advance whether it was
> compiled with -ffunction-sections.  If so, constructor code goes in
> .text.startup.*, and startup() goes in .text.startup or
> .text.startup.constprop.0 or .text.startup.isra.0.
> 
> So it's not really a compiler bug because it's possible to disambiguate
> those.
> 
> Problem is, we can have some objects compiled with -ffunction-sections,
> and some compiled without, in the same kernel.  So the disambiguation
> isn't possible at link time, since for example .text.startup could be
> startup() with -ffunction-sections, or it could be
> __attribute__((constructor)) without -ffunction-sections.
> 
> I attempted to describe all that in patch 4.

Egads, what a mess :-(

