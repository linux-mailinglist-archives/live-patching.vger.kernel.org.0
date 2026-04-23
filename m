Return-Path: <live-patching+bounces-2494-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOPCMs9K6mkhxgIAu9opvQ
	(envelope-from <live-patching+bounces-2494-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:37:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2359F454FD0
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F2A930125E7
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 16:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAE036308C;
	Thu, 23 Apr 2026 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="doxoulaP"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544563783B1;
	Thu, 23 Apr 2026 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776961747; cv=none; b=mmvSk2uqffH2kVwXeCb4s72RCxjFJEuFX9ZPzeOdivn3n3KCBBeG26qPCxdAbGzJQPVPOLZgiLfIyICg2D8nPXjjohesKZGHa/WMHovOnlu+u5nb2/Fnl9JuxK76Wcw6tzpfRFYbifrNdcvmuX+da72ALsRiQYWB0LhqmWUsrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776961747; c=relaxed/simple;
	bh=yTDft1bjK9Ndz3SbAethx49RRrBo8V21uI8sdOBK7G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeIS/T9buNXsD2ppPuz/q2GJ/9V/PAAo19ECBfDYUM6pFKtRM+2YaoEDf2xx0WEg45sL0DVVj11Pbjy3MwilXlTKxTC5zWr7gWN13xlMd4963npwAXlqWIg+lAC6EIIOUipGY80GUhNglMQuEt6a6OcT9T7i+7xXzubJ9FwkvZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=doxoulaP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bSNXi6++adOUxDdiKHQeejGWmSJ+dhIwo0tBAHZhjTo=; b=doxoulaP+yhTSmPjFKEVwj8saG
	Be/7RKNG9i53Il8PDZDnr1Lys/e/blHVId3MSPKbh+6EuHvvQJtkN5UhdQ4xfguMv8oOL8mrofrFf
	sStS4gz0RuAau6Lroly2H3z6lUOO02keKAC67q0dOHq8SLPdl5geoJ/LSI74w++N6DEnw7ZGmvYQR
	T3zHv4ZbupS8eYd1/jeUnyptgDr8QS58vWCiqYT0mJ8AGCHZeaZLnZX34M8U9FnDXGkLNRqToQIcf
	C4zGbBSmis6g2WABpYpXnXCAknBNbT02tNMfNYV1s6z/O/NbYmnKfAXw7uULyTZWGQQEItR2XhmI5
	d8CM8+Tw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFwvH-0000000DjKw-00sL;
	Thu, 23 Apr 2026 16:29:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8873E300E8B; Thu, 23 Apr 2026 18:29:02 +0200 (CEST)
Date: Thu, 23 Apr 2026 18:29:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <20260423162902.GC641209@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
 <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
 <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2494-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 2359F454FD0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 09:23:12AM -0700, Josh Poimboeuf wrote:

> > > Sorry, how do you get 64 here?
> > 
> > DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y
> 
> Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
> Or a 64-byte pfx for the !CFI case.

Just so.

