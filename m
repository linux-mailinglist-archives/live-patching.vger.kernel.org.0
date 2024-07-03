Return-Path: <live-patching+bounces-379-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18BFB925332
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 07:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD521F24F1E
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 05:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3944D8AD;
	Wed,  3 Jul 2024 05:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcAqzK/0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540BA49641;
	Wed,  3 Jul 2024 05:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719986204; cv=none; b=bcI//oSnENVoL7XCfYXwz8w+nOfqZmam6XiHiEoNM2nNJCfv3mS/G/vyusvxU3kEnJHCsPxhylv0Wj01uJc4JdU10J2eTUT6baYeXZv4py/aKYR4hLmAPlckUQ5iKfKTmoL5Tz7xPh8gKsOkqgglUzIXYXUTmrt2l83ZLBqq5NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719986204; c=relaxed/simple;
	bh=3kxVvdoDm8FEBPBfT5t+Qc1jF4e1JkZLEA4oaiDz42E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fctqd2TNJEaLvXkUvEsEZwi7bCREk4CabQMjUO4cBr0NNZ/m4P0+lqVqycK3ZXXraNcE9WtJQVlaCNXeDqcM2Vgf5nAK8KySm8I2sUfMTRt5KWMjXetjJAbcJ4xAVNF1btcjaf3DuJcb+t4kux5e2hOlGT0NsqrC04ZQc5XAIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcAqzK/0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46493C32781;
	Wed,  3 Jul 2024 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719986203;
	bh=3kxVvdoDm8FEBPBfT5t+Qc1jF4e1JkZLEA4oaiDz42E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcAqzK/0q1KaY36jNOvmQfa9G+D71+NTHDEA16UFG6/iIJBVLWPS1NMRrktsmFm9M
	 pCnOuvPAYeFsrLnecnmlyP4Ep+uCdym1MdMQHXAIjwk+6w+10CYrPXUVrTrXG5qqkQ
	 Blfw3Bia+D9+VkSJERppK/crJQ1qX+ANC/3BAXxRYZu6zOkntO+158MUz8fZaUeMYN
	 XK5eFlnzEv9fLXnisoRtTIUufzYOQcgxrVvbrhkLtsz2sQg6SL6hW+pvLYfBdwzMhW
	 aRH3RkFR98RSE1ZuTZs59pg3YLu8DuExi89tFa0z6eP9EeZYD56ozV1uql6lYDDKte
	 o+sX+VUFV1I6g==
Date: Tue, 2 Jul 2024 22:56:41 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com, nathan@kernel.org,
	morbo@google.com, justinstitt@google.com,
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Message-ID: <20240703055641.7iugqt6it6pi2xy7@treble>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
 <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZoKrWU7Gif-7M4vL@pathway.suse.cz>

On Mon, Jul 01, 2024 at 03:13:23PM +0200, Petr Mladek wrote:
> So, you suggest to search the symbols by a hash. Do I get it correctly?
> 
> Well, it might bring back the original problem. I mean
> the commit 8b8e6b5d3b013b0 ("kallsyms: strip ThinLTO hashes from
> static functions") added cleanup_symbol_name() so that user-space
> tool do not need to take care of the "unstable" suffix.

Are symbol names really considered user ABI??  That's already broken by
design.  Even without LTO, the toolchain can mangle them for a variety
of reasons.

If a user space tool doesn't want the suffixes, surely it can figure out
a way to deal with that on their own?

> So, it seems that we have two use cases:
> 
>    1. Some user-space tools want to ignore the extra suffix. I guess
>       that it is in the case when the suffix is added only because
>       the function was optimized.
> 
>       It can't work if there are two different functions of the same
>       name. Otherwise, the user-space tool would not know which one
>       they are tracing.
> 
> 
>    2. There are other use-cases, including livepatching, where we
>       want to be 100% sure that we match the right symbol.
> 
>       They want to match the full names. They even need to distinguish
>       symbols with the same name.
> 
> 
> IMHO, we need a separate API for each use-case.

We should just always link with -zunique-symbols so the duplicate
symbols no longer exist.  That would solve a lot of problems.

-- 
Josh

