Return-Path: <live-patching+bounces-1855-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAD1C5C1C0
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 09:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BFF2C34CD6A
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 08:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033282FCC1E;
	Fri, 14 Nov 2025 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I369wdp5"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1ED2DCBF8;
	Fri, 14 Nov 2025 08:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110627; cv=none; b=iudiCjeuVug5JyhEszPCWZdYwHwYSNOx+pMc5MRXkB6VJzqU5F4VW4HXs5Rmzd1vDlMFM6XOQLOv/b7bLkFaZwuKwD/0HtJ03XF7yEE2b+lU2VhVfadB7wRNZ8e89cp2IOaTD9rKVGh+/jGPzqsGcozIDub7NflVR/ibUTsuXzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110627; c=relaxed/simple;
	bh=wGaGYdyTF8KavI209FyjqxT2jec0brG7w0mGLiPJG9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLzIi3Ds8mMXAcbozVz5fn0HB0mZlLievHQf0Z8LSO4B3Kj9f1Fe4cnVz4wV3Ft1/+zFjRp3iPfxuvH6ZchmtSqvRkVb3OQEPy3ilXNVeaLhYlzqLWX7Gd+Sdjp+S88l6eYVPRVjbFBGhFqmOkGAlSkwKMfbb1GqoCIsKtpGp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I369wdp5; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bJGpc6Q/Uzl0XHX80MBfsV6KQX2eGjEqpGE2KxiZsQE=; b=I369wdp5CYc50uRNtu3sS4LRIo
	4yFwJn6VzMxZwTA3Z3ngMk6kjgfRjcP+tiE19vWSuMVpdE/tR0Q4cqDHBQnu0yVC93iSInjjWO90Z
	RCvy6/y0fEJj73oAqZPjciDeQbioPxSNElLf8MfhR2+GLHgmcAuKrvvHkTVVYZDgvI3GQrGnrkhay
	WYsqWaJKbnfMYreqR7FleyvKixrJZk3j5hL/w5ZCAlTRfW5Q5nZ2htexjNl7eFyCJeWFAYQb4DlP6
	SB8jfd7AWwzgab+MwBUYyzjzoLVzgj7XskWXo2GJAtRUXS5j2p00HP04UjjvdUjKoKJXRaZ4DwH4I
	adE8+fFA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJokN-000000027sO-35aP;
	Fri, 14 Nov 2025 08:01:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 05DE430029E; Fri, 14 Nov 2025 09:56:58 +0100 (CET)
Date: Fri, 14 Nov 2025 09:56:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 2/4] media: atomisp: Fix startup() section placement with
 -ffunction-sections
Message-ID: <20251114085657.GR278048@noisy.programming.kicks-ass.net>
References: <cover.1762991150.git.jpoimboe@kernel.org>
 <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>

On Wed, Nov 12, 2025 at 03:47:49PM -0800, Josh Poimboeuf wrote:
> When compiling the kernel with -ffunction-sections (e.g., for LTO,
> livepatch, dead code elimination, AutoFDO, or Propeller), the startup()
> function gets compiled into the .text.startup section.  In some cases it
> can even be cloned into .text.startup.constprop.0 or
> .text.startup.isra.0.
> 
> However, the .text.startup and .text.startup.* section names are already
> reserved for use by the compiler for __attribute__((constructor)) code.
> 

Urgh, that's a 'fun' one. Is this not a -ffunction-sections bug? I mean,
the compiler should never put regular non-reserved user symbols in a
section it has reserved for itself, right?

