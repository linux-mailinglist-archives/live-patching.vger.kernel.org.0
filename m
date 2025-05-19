Return-Path: <live-patching+bounces-1437-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81395ABBE6A
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 14:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E28917E838
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 12:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3125C27932E;
	Mon, 19 May 2025 12:57:35 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A46278E60;
	Mon, 19 May 2025 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747659455; cv=none; b=RY9hXLCOm24hPKpG5Kr8WlC8Z2unopalnvpRnLTDeaZBuv2AWPdt6gU1z2sE4BdODHMK3hFgAe8QhaCSqd6Ta65MkC0l0URBZ6n/IIN7LuV/lTWzheOaNmwF06K1eyfqjQUgkTN7mQ5Ed88ALQlIOGMZzJrmnlemsWlcDMvsNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747659455; c=relaxed/simple;
	bh=gXpTYgvGTAJG68tcffNCQMuQVt48NcFXktn/s8H7oeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGLpy1Mc10o1ChR1BxgyImE010B4NhYfbCGMFv2oHBS32JDCWF01abetKGBgKp9jycR+T2o343rdJYb9ibSrGI3NFroWkhKZfnbX3WHEPrsCR9BUXm2KI6EBLQzEyL2dNP4EkNgq7SYvIRebFGvbRJy3iYCt5/BX2pOULLMiT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 309091655;
	Mon, 19 May 2025 05:57:19 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64BCE3F6A8;
	Mon, 19 May 2025 05:57:29 -0700 (PDT)
Date: Mon, 19 May 2025 13:57:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Song Liu <song@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org, indu.bhagat@oracle.com,
	puranjay@kernel.org, wnliu@google.com, irogers@google.com,
	joe.lawrence@redhat.com, jpoimboe@kernel.org, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Message-ID: <aCsqsyjvD72YXtOJ@J2N7QTR9R3>
References: <20250320171559.3423224-1-song@kernel.org>
 <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
 <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>

On Fri, May 16, 2025 at 09:53:36AM -0700, Song Liu wrote:
> On Thu, Apr 10, 2025 at 8:17 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> [...]
> > >
> > > [1] https://lore.kernel.org/live-patching/20250127213310.2496133-1-wnliu@google.com/
> > > [2] https://lore.kernel.org/live-patching/20250129232936.1795412-1-song@kernel.org/
> > > [3] https://sourceware.org/bugzilla/show_bug.cgi?id=32589
> > > [4] https://lore.kernel.org/linux-arm-kernel/20241017092538.1859841-1-mark.rutland@arm.com/
> > >
> > > Changes v2 => v3:
> > > 1. Remove a redundant check for -ENOENT. (Josh Poimboeuf)
> > > 2. Add Tested-by and Acked-by on v1. (I forgot to add them in v2.)
> >
> > The approach and both patches look reasonable:
> >
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> >
> > Is anyone, Arm people, Mark, against pushing this into linux-next,
> > please?
> 
> Ping.
> 
> ARM folks, please share your thoughts on this work. To fully support
> livepatching of kernel modules, we also need [1]. We hope we can
> land this in the 6.16 kernel.

Hi; apologies for the delay -- my time had been consumed by
FPSIMD/SVE/SME fixes and related non-upstream stuff for the last few
weeks, and now I'm catching up.

For the stacktrace side, I'm happy with enabling this without sframe,
and I hase some minor nits which we can either fix up now or as a
follow-up. I'll cover those in another reply, and chase up the module /
code-patching bit shortly.

Mark.

> Thanks,
> Song
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20250412010940.1686376-1-dylanbhatch@google.com/

