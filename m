Return-Path: <live-patching+bounces-1464-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2816AC43AC
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9352618948EC
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4671DD9AD;
	Mon, 26 May 2025 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dYk3FSZo"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061371C5F06;
	Mon, 26 May 2025 18:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748283794; cv=none; b=UbqKb0J1nW0S+OXskbwKWNCdnSwj11z9xzIMlEYgJTlmSFDvu3xC9Tc/b+27bGxzf/8/dVfxofBhUL2VQb9DoT8w7Ah3pi6dIW46o7fzrUno7Bi6wj41mfFQG/w/wi617H8RkMkj0UPfwCl/t8sGA1/0vvnKNqp0j3Xc893vQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748283794; c=relaxed/simple;
	bh=/ZivUZ2jD6VS6PcDRw4zkoytgj+gbfKu/YNw1XBjkiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pn11iTJv4qtG7wAA3C8a4DVoKzyl9nYmpUOJnk1wo8WA96ucE1OIG3EQluS0tP8fK20+vRxnf4UfDPE76qeLC16wXzk4Y4uVAV+0yNGVxajHn9NOMqeUSvyW5AenQhQ/Jr847ihevE/gXU3ScOtZmQSZ/LnQPxkjVKTS0Lka/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dYk3FSZo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W2+meQg3To1cGOpAlWAssGTDKsq8XRcAsog4lNXiHUg=; b=dYk3FSZoKfLFaF/6VQNaUpXU4X
	3PkeJVRqb6YpYM5ZSb+UGFMFHVI99ZftEJ2yY4HUfeq2MAExwFlBQKuv46dNs14If/A14CC/fOW7U
	mkSd02GgMnPl8y5/IShphTfLywoHhr7S/zcQGClPNsNypqnb+8IInO9n0MJbERTyazm1+SsEUY2Rz
	hXGOs/g6UfmMOYYIJ4f2up8An5OL9gvQ89OZU5XTFBjm1q/LERWx6Z3Uelr/Q+GYTR53+nFx5YAzq
	Hs4a+c1Ylcam3zM5N0rGEBffymFcl7BKYxbCdy+LVHeykBdB1OqN8cuOO7WGcR0KFUXOtTn6df19L
	uRWauITw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJcTU-0000000BgE4-3P99;
	Mon, 26 May 2025 18:23:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E2D6B300472; Mon, 26 May 2025 20:22:59 +0200 (CEST)
Date: Mon, 26 May 2025 20:22:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <20250526182259.GP24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:

> Without '-ffunction-sections -fdata-sections', reliable object diffing
> would be infeasible due to toolchain limitations:
> 
>   - For intra-file+intra-section references, the compiler might
>     occasionally generated hard-coded instruction offsets instead of
>     relocations.
> 
>   - Section-symbol-based references can be ambiguous:
> 
>     - Overlapping or zero-length symbols create ambiguity as to which
>       symbol is being referenced.
> 
>     - A reference to the end of a symbol (e.g., checking array bounds)
>       can be misinterpreted as a reference to the next symbol, or vice
>       versa.
> 
> A potential future alternative to '-ffunction-sections -fdata-sections'
> would be to introduce a toolchain option that forces symbol-based
> (non-section) relocations.

Urgh.. So the first issue we can fix with objtool, but the ambiguous
cases are indeed very hard to fix up in post.

Did you already talk to toolchain people about this?

