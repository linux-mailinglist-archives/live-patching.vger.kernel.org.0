Return-Path: <live-patching+bounces-589-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D16E96B3E9
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 10:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B690E1F22A9C
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 08:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CB7155735;
	Wed,  4 Sep 2024 08:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rbap1gwj"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F108F52F70;
	Wed,  4 Sep 2024 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725437326; cv=none; b=oRMj/juFZNKZW00KMu6mi0aeOUawPSoWgf8A5t0PcFYNDAo6wxcUJETkH8g9oYu362eVSwtMWmmwxSS4c32H1lUGFLbS9gzFK2iATS27+qR7JwNWjNtEqBt5JZN7Fi9jUp1LGcS/PzSslM0pbOVvc+qr4xLpd7uCjm6j/EmRsdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725437326; c=relaxed/simple;
	bh=60XKJBFQrNzMhkirdD2qis5gFKmyYkDScKZTst23+Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zbc5SoMp49EUkbV0/bm6tFhsMkXAfJopOGMAKOGrsBtGWRi7D8UKRHxOBcZ+EpSBZqQNkgehaEvUxxHyjWjozEMrzeB+oYGD/0yTybhwtyye1eUN0fiYPnJSWljCMXv0nAWhLCa/TvmF04Q82FY91GddYLfdK7Hh194aHKoZSd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rbap1gwj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jda6kdkrlX1mijI27UzNrN49mCGupQmlGIn58DXJZPU=; b=Rbap1gwjxDKmEX54KIL3907rSS
	tgC+gEqNWP6z7ut4FcRHXo9cnC6hsj3Jt0b/TfKgQIhfTjy14GvIpW1KUkDtWqKRLjzHZQPkec6hQ
	QujMs7A9bnDzrPfSKrzUG/CgqQFA1V+15ShZuqjp1hZLAQ8avDvTwtAefVBHkAaqK2M2ezR+Q83Ro
	EeytOF9clvS/T6qsaDsiTcmu6Jr7p/fPWDaC7KwUF3AeAsKVOEKLpOZ7WfaArR/C4mrI99+Lhtocu
	HJPdLLQU4TekVx7yfy9tMCwVMhC+JMO/1XrB83oqLRz6Di8V/VyRY5Sbyp2b+iSueDaSWZ2QwQMrp
	AqQQrB3w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sll4D-00000000Xr3-1PmP;
	Wed, 04 Sep 2024 08:08:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3CB97300642; Wed,  4 Sep 2024 10:08:42 +0200 (CEST)
Date: Wed, 4 Sep 2024 10:08:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240904080842.GE4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904042829.tkcpql65cxgzvhpx@treble>

On Tue, Sep 03, 2024 at 09:28:29PM -0700, Josh Poimboeuf wrote:
> On Tue, Sep 03, 2024 at 10:29:09AM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 02, 2024 at 09:00:11PM -0700, Josh Poimboeuf wrote:
> > > Create a symbol for each special section entry.  This helps objtool
> > > extract needed entries.
> > 
> > A little more explanation would be nice,..
> 
> Indeed!
> 
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> Subject: [PATCH] x86/alternative: Create symbols for special section entries
> 
> The kernel has a myriad of special sections including __bug_table,
> .altinstructions, etc.  Each has its own distinct format, though each is
> more or less an array of structs or pointers.
> 
> When creating a livepatch module, objtool extracts a subset of functions
> out of the original object file and into a new one.  For that to work
> properly, it also needs to extract a subset of each special section's
> entries.  Specifically, it should only extract those entries which
> reference the extracted functions.
> 
> One way to achieve that would be to hardcode intimate knowledge about
> each special section and its entry sizes.  That's less than ideal,
> especially for cases like .altinstr_replacement which has variable-sized
> "structs" which are described by another section.
> 
> Take a more generic approach: for the "array of structs" style sections,
> annotate each struct entry with a symbol containing the entry.  This
> makes it easy for tooling to parse the data and avoids the fragility of
> hardcoding section details.
> 
> (For the "array of pointers" style sections, no symbol is needed, as the
> format is already self-evident.)

(so someone went and touched a ton of the alternative code recently,
this is going to need a rebase)

This generates a metric ton of symbols and I'm not seeing you touch
kallsyms.c, do we want to explicitly drop these from a --all-symbols
build? I don't think it makes sense to have them in the final image,
right?


