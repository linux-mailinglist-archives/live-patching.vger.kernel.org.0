Return-Path: <live-patching+bounces-1857-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B675C5F44C
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 21:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3DA474E2860
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 20:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BD02E1F06;
	Fri, 14 Nov 2025 20:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4fXDbT2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675823A99E;
	Fri, 14 Nov 2025 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763152994; cv=none; b=StsyFLiDHhrxdeL6sCrzf0r8oaVvjNLtQcsOSofG52Exa3vJs2ESiH5P1AF0BCGHMi1w9yCWYZKafxIlc/WW91FaeYo74puo5wPP8pV2BF0hRgMRmbqHIvf7Lt5TzYcMR/FbXunHZ55bzoGyepyGOJzsGT74nlZgN4wgPkgMbII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763152994; c=relaxed/simple;
	bh=hhUf+B2d9VcGFwRmQ5aQm1Ejp6+IslPooZHgnmgDPSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lx/e8SICPZ9CNerhu8gx/PM/pwyAXD9jXTsryk/94Bn0m0hj8hK2rL93aclSJi4vZL51ilp4EgCtQgYCZudJELqJRXlVuhPhfioF9iJZlhNIAmMa1xI0iuT1joUokZIbH0CVR16MiBJ/yDdPh0tyfcROkj1v4tgiUDviOom5Axo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4fXDbT2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF75C113D0;
	Fri, 14 Nov 2025 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763152993;
	bh=hhUf+B2d9VcGFwRmQ5aQm1Ejp6+IslPooZHgnmgDPSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m4fXDbT2D4xf3yPDB6fgacFSze3DUYsPJ1VKLUFUzC65Vwgj5oRG1aWyMMjVnDCZj
	 j+Jnm+iOhkDvq3hi05/lvVKKTYOXeP+Z5JMpwx5nogJg+1PpZYgnJCsKsOYVXPjY/P
	 zoAH6Yt+p96NHwvaiTzO1Ov0Vj780f35PsmRe8gknjqbvkY25/K3YEUt6tnQoQnUTI
	 2xgaCF4jNIMwpr4eCzf+nlEtEsa4pbsgvMubxyXHjbRLVqjkY960EtbP2IEofhXJHP
	 SPcSGaql0xliQIyiDRD49I0M9T8NulLOW4cshqNxXZL1eib4ic4T9dTYY9cOUWo7Yn
	 +x46SCABzQ/lw==
Date: Fri, 14 Nov 2025 12:43:10 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Hans de Goede <hansg@kernel.org>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 2/4] media: atomisp: Fix startup() section placement with
 -ffunction-sections
Message-ID: <2a3d4d7fco4szxyrw33lorkhckjq4styfsaljxxwd3v4o42i5z@qdavomj5i2mu>
References: <cover.1762991150.git.jpoimboe@kernel.org>
 <bf8cd823a3f11f64cc82167913be5013c72afa57.1762991150.git.jpoimboe@kernel.org>
 <20251114085657.GR278048@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251114085657.GR278048@noisy.programming.kicks-ass.net>

On Fri, Nov 14, 2025 at 09:56:57AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 12, 2025 at 03:47:49PM -0800, Josh Poimboeuf wrote:
> > When compiling the kernel with -ffunction-sections (e.g., for LTO,
> > livepatch, dead code elimination, AutoFDO, or Propeller), the startup()
> > function gets compiled into the .text.startup section.  In some cases it
> > can even be cloned into .text.startup.constprop.0 or
> > .text.startup.isra.0.
> > 
> > However, the .text.startup and .text.startup.* section names are already
> > reserved for use by the compiler for __attribute__((constructor)) code.
> > 
> 
> Urgh, that's a 'fun' one. Is this not a -ffunction-sections bug? I mean,
> the compiler should never put regular non-reserved user symbols in a
> section it has reserved for itself, right?

Right, so there's no ambiguity *IF* we know in advance whether it was
compiled with -ffunction-sections.  If so, constructor code goes in
.text.startup.*, and startup() goes in .text.startup or
.text.startup.constprop.0 or .text.startup.isra.0.

So it's not really a compiler bug because it's possible to disambiguate
those.

Problem is, we can have some objects compiled with -ffunction-sections,
and some compiled without, in the same kernel.  So the disambiguation
isn't possible at link time, since for example .text.startup could be
startup() with -ffunction-sections, or it could be
__attribute__((constructor)) without -ffunction-sections.

I attempted to describe all that in patch 4.

-- 
Josh

