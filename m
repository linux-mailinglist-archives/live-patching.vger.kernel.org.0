Return-Path: <live-patching+bounces-2483-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHQtJRDd6WmNlwIAu9opvQ
	(envelope-from <live-patching+bounces-2483-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:49:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BB344EC30
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82A49302927B
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 08:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27EA3191CF;
	Thu, 23 Apr 2026 08:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mk22bHWv"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E6E3043D5;
	Thu, 23 Apr 2026 08:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934082; cv=none; b=jWR7bGLmUwfDDCoBWL1VOaQ8N1rYKfS3WWa+2NWatIVZ5p+t0or4H3eVIOdKA9xA1DS8JN3IgeaQOfG43LBNdTUVfdfiE/M6nrryP5dr6+fz0k+JAFshhAPZmP2Ex3tU4cLyDESRX70KTxfz72DLstjYJR09QT1hIwW3mlX1dZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934082; c=relaxed/simple;
	bh=WpcDA7CwrGhMl6AO6BWBWnT5S2y7wyeHoeDfi55zX7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKCVYSp5IUwu9151QU6NnvcHNXnTHrWUdzYc65ZpqwHkkpxKtz3PRYRvMpykepsn/SS0meD23Hzv5YJvpoxKISPFvIwR+qxBh0ms5qEQCYGo/Ai6x1mPy0XBRHSjSWqNZEvrpU2amFpJlQX94pvNQ+ET7KMa8NkLhhbfpUMaTXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mk22bHWv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VGBeWZynnTQGaashF82B6Q6ZEghtEoFXDTWh7d5oyHY=; b=Mk22bHWvOjL+1AHBsDJeR5rEkN
	KjLlJgfxiUBwBMyLyyAPbb9emRzmD/PS61JCp8C84v401oKrMCanmYpXirlQFtiMglHZ9Omqqcpka
	ZQTo2r0z3Na4pcPLEAq1uVfpfXbEaVO+pGa5nHK0F4NYn0KWTAkithKTUy9QMhNRDgTNJh4XkWdH+
	fz+KaOUFlKJGhI42edMHbdRsOZx9hlwqMxDX8WEE1ZbpcMQkpGueVlFSng66DzU3DKND80pZPD8wu
	UQgwxWZp5amq0ZsH1BXD7YR12Tk9DDjJDczMeYwyfmYBeJXweu5thdO0JFG/zRk7eacst2tRR1Xm8
	XynYb69g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFpj5-0000000D8Sz-04O0;
	Thu, 23 Apr 2026 08:47:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8C971302186; Thu, 23 Apr 2026 10:47:58 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:47:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2483-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[noisy.programming.kicks-ass.net:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim]
X-Rspamd-Queue-Id: 74BB344EC30
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> __pfx_ symbols were considered redundant.
> 
> However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> the hash and the function entry which have no symbol to claim them.

If you force the function alignment to 64 bytes, the prefix will also be
64bytes, rather than the normal 16.

> The NOPs can be rewritten with call depth tracking thunks at runtime.
> Without a symbol, unwinders and other tools that symbolize code
> locations misattribute those bytes.
> 
> Remove the !CFI guard so objtool creates __pfx_ symbols for all
> CALL_PADDING configs, covering the full padding area regardless of
> whether there's also a __cfi_ symbol.

Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
__cfi_ symbols to cover the whole prefix?

