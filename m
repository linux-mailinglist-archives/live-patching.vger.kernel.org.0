Return-Path: <live-patching+bounces-588-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B81296B39C
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5C551F22684
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9996416EC19;
	Wed,  4 Sep 2024 07:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m4+La8y+"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1211B16E886;
	Wed,  4 Sep 2024 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725436484; cv=none; b=UviWgfsXM635aAesPTEtPFGn8bd3BVESqVhs5g3UZOCoznxUctMZxZ5eLcssZDxIhMu35B2BVvIeQc1eUCYOXUgoDhOQO99OBS5cEtb5dPz3OPG3AonRIyRBBi63rWOhpX+6ZeqL1XYgCikydiT4v4fFKvGN8MWhlGs9S0jQ3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725436484; c=relaxed/simple;
	bh=B3WKefeYNK0fHWwsG4Ect5mAFLxMvkP/5ZCHvWxq54Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1ti7J7JU69rOQEn3v09AsgevQdr0nw6rkUeH4M58wegEIyvxIOSrKQb4nIche/PJ/lLHJmyob+43SAI/dxn6JieUb/K1GR68YKU7+c19zlG/Eb6NNl0dPP7hYxTHHKQBaKOYsnjg+3GPwDg0pFcrmGM42gOCdJdEZpIOGfkhNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m4+La8y+; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kB6cbogSGnXAcC485KPPWQrTZQLJiozS3TCDlxmwCkw=; b=m4+La8y+HTssXekrVvWG3sq9Q7
	P3nkJ4YtrNeTDjoTESxt01kvRc1SZXTg6HOS5hPJyyq1kuat0723y9d0UKvMizT6N1cSYOrDqPNpe
	zTp/LN8fCHbLjov/jwGY93aklB9EItxyFr7hTuKaxh3edfNmF3ufrRgcvMYZiOCFsFYh1/oe+iH9E
	TCU1n/D7+TcOMTz94AsyCGdW47yFVxbZJTug8NXxpKxEVHJldiEtvK3+TExlDi7w4+Q2uRFkzkO79
	TYWSDlA/+Xb69Up4nrlAJ0htaABS+jKJ2Ppe31ZCXaWX4hDZ/l+bbMTS29vlh0Al9oysS9SfGu0uw
	s11EeSKg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1slkqX-00000000AcH-2r2h;
	Wed, 04 Sep 2024 07:54:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 560A730083E; Wed,  4 Sep 2024 09:54:33 +0200 (CEST)
Date: Wed, 4 Sep 2024 09:54:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 29/31] objtool: Calculate function checksums
Message-ID: <20240904075433.GD4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ffe8cd49f291ab710573616ae1d9ff762405287e.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffe8cd49f291ab710573616ae1d9ff762405287e.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 09:00:12PM -0700, Josh Poimboeuf wrote:
> Calculate per-function checksums based on the functions' content and
> relocations.  This will enable objtool to do binary diffs.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/Makefile.lib                    |   1 +
>  tools/objtool/Makefile                  |   7 +-
>  tools/objtool/builtin-check.c           |   1 +
>  tools/objtool/check.c                   | 137 +++++++++++++++++++++++-
>  tools/objtool/elf.c                     |  31 ++++++
>  tools/objtool/include/objtool/builtin.h |   3 +-
>  tools/objtool/include/objtool/check.h   |   5 +-
>  tools/objtool/include/objtool/elf.h     |  11 +-
>  tools/objtool/include/objtool/objtool.h |   2 +
>  9 files changed, 188 insertions(+), 10 deletions(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 8411e3d53938..9f4708702ef7 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -265,6 +265,7 @@ ifdef CONFIG_OBJTOOL
>  
>  objtool := $(objtree)/tools/objtool/objtool
>  
> +objtool-args-$(CONFIG_LIVEPATCH)			+= --sym-checksum
>  objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
>  objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
>  objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
> diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
> index bf7f7f84ac62..6833804ca419 100644
> --- a/tools/objtool/Makefile
> +++ b/tools/objtool/Makefile
> @@ -21,6 +21,9 @@ OBJTOOL_IN := $(OBJTOOL)-in.o
>  LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
>  LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
>  
> +LIBXXHASH_FLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null)
> +LIBXXHASH_LIBS  := $(shell $(HOSTPKG_CONFIG) libxxhash --libs 2>/dev/null || echo -lxxhash)

This was not installed on my system and I got a nasty build fail. Should
we make all this depend on CONFIG_LIVEPATCH or force world+dog to
install this as yet another kernel build dependency?

