Return-Path: <live-patching+bounces-2490-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DwZJYc46mnRxAIAu9opvQ
	(envelope-from <live-patching+bounces-2490-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:19:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EED45432D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA746301651F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 15:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD10318B83;
	Thu, 23 Apr 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gB9P730T"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5499D30BF4F;
	Thu, 23 Apr 2026 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957571; cv=none; b=PPmISd8ZI9GebzN6DyKoRk1oKU7BupXVENaYQcmQtocRdsgzGdIS042oY8bw+4ms+xlWh1yYVgeIYx//qBgWWwZNq71oY+dhTQ3b07syTjbtE6QiihDb4ojwjvj3MPEyVR01Em4EBASWsmUc+P4Tqw5y0zxTjFHavGNRdN5/PF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957571; c=relaxed/simple;
	bh=xLdhCHzK0qhh895tiH+PrNCQqUn8sEJGEZ/QJudAGyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU5pXzxje3R+YYiYgrrL2Qj9/NG9jDzinfjyKoVNs2NQT4ddsHjOwH933LhORkwjjL29zx1NYsHvL5hPfGAx+NjqHKGt7nep61VnGK9A3NN3GceqxbdDDf6q7fZ213BUwr7yTYGJf2lBtdWuG3nB6TjoQlfvVjF9nrUmYqAzuiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gB9P730T; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KEbxdxd/K5ZOp5eyrFavFYIWr7+oDdmJDLdjrIIU/2s=; b=gB9P730TB1J/4wB6vB6+LNBZDA
	VJe2qddjM6+QS/Edg/4OwTHk8jdjmVNqFdA+iing4IJVYxcDTQjNHG4LUjLLfeZg97e9vpBB5WOa9
	df7Y9V2MDnuW+s/TSotrigR5Tqc7ROUqdAxz7YQfC3l3tuhMxJ+GJ2QUPzrZkbSwE/bVXkHhF2S0+
	kCAnbNZ7weRXWC7Kmyc4c51oR1hxI8RKbeUx5wJ0F3Ivv1bfbuo9e2GXiZEDzi/s6vByMtibOfwy8
	tRTiV4KyP/3dm7Y2MEzaadPPnf8uXMcojxnyc3fyXA8GzR3uQflCqQ4Bld7tiw0+dRyVwocacVEUu
	q2O6k3Ww==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFvpu-0000000DeT8-3BzX;
	Thu, 23 Apr 2026 15:19:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 47CE23008E2; Thu, 23 Apr 2026 17:19:25 +0200 (CEST)
Date: Thu, 23 Apr 2026 17:19:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2490-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,infradead.org:dkim,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: 39EED45432D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 08:16:08AM -0700, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> > > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > > __pfx_ symbols were considered redundant.
> > > 
> > > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > > the hash and the function entry which have no symbol to claim them.
> > 
> > If you force the function alignment to 64 bytes, the prefix will also be
> > 64bytes, rather than the normal 16.
> 
> Sorry, how do you get 64 here?

DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y

> > > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > > Without a symbol, unwinders and other tools that symbolize code
> > > locations misattribute those bytes.
> > > 
> > > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > > CALL_PADDING configs, covering the full padding area regardless of
> > > whether there's also a __cfi_ symbol.
> > 
> > Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> > __cfi_ symbols to cover the whole prefix?
> 
> Yeah, I suppose that would be better, via objtool I presume.

Yup.

