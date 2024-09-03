Return-Path: <live-patching+bounces-569-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 289F09696F5
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 10:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ADF61C238A3
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 08:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C887220126C;
	Tue,  3 Sep 2024 08:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n7luagoU"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBC21A3AB6;
	Tue,  3 Sep 2024 08:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352010; cv=none; b=hMLLUEzRfZsBmNBvAAqxJmO4FOqqEVTdLZDjdxwzcDzAnDbvubsVGbqMk5JhTMArfqG+8sHnyqjYpnUixKL/mTPKo99nxgVpxDfsTBs2LvNzSajFw+Z0RIKZUM17IVNP6qLUML17mVBBUm4EDAWdAi3CSFlbRYZ9Nt8uLL/h1is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352010; c=relaxed/simple;
	bh=cWKo71idxa+YnNjrFO7QIf29Y7rhjeQH2k7fm2C5nFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEFbjLLS5loJwxUppyFWf1p9tAOa1tXvz4HOvK5a2+qr0fnr3acWfSFSEZXYOkw7py40L1zwm5QZUi4LdMuqobZgz5Zz/nBCYFiJcLfgt70OqRCnlxbacsuhD4+vhntWMAZMmaq+YCV8l0AaBC/RExj+V4our0Q27iWBQuVVqC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n7luagoU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ovpuf2rR+PbFJR3PtoRUS4pojZwzFuKB3HzItsV64sw=; b=n7luagoUKTm6z0U1LWnMqAVE5k
	eu1zgfnEDU4HJTcBMt2/OVlgXoI3fRqrDMKB7pCOVMPUZPZvjmBge+OnHft+cmoNB1c8INvWgjrtW
	tjlQ31dCN3Ssl7toOHDy9/NEG7EzQ7AsBa1+tK9N/2+dV04yc23y36RLoIt4Ja1p5WpGCwXWzcqgc
	NEkkRr1eVmakzHNMeM9PCw8DsZstPw2IU2eCYC5QriLoYfGAFd3vorRp/hLITa5hhZ0dVCaUuXFoE
	uePxZyvOFWcBdUc2+84a6E2c+JXC+JUNfXGiv8o7l4UE6ywFohBoyuxHHnEwINvZxaY52HKBXw9Wz
	pG2lL41Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1slOs9-00000007wss-2a2B;
	Tue, 03 Sep 2024 08:26:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 458FA300390; Tue,  3 Sep 2024 10:26:45 +0200 (CEST)
Date: Tue, 3 Sep 2024 10:26:45 +0200
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
Message-ID: <20240903082645.GO4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 09:00:10PM -0700, Josh Poimboeuf wrote:
> @@ -433,9 +433,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
>  	/*
>  	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
>  	 * can exist within a function, confusing the sorting.
> +	 *
> +	 * TODO: is this still true?

a2e38dffcd93 ("objtool: Don't add empty symbols to the rbtree")

I don't think that changed.

