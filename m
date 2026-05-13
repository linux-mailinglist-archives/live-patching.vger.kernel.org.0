Return-Path: <live-patching+bounces-2796-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGZOCfEsBGodFAIAu9opvQ
	(envelope-from <live-patching+bounces-2796-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 09:49:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A70952EF5E
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 09:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6836930C3832
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 07:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E892B3A759E;
	Wed, 13 May 2026 07:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qbR0S3kA"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7A3298CA3;
	Wed, 13 May 2026 07:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658438; cv=none; b=KNyhjkEX4Gw0hFPQyXCmpVsMuQnUzx86uxqPjQr9VdkH1M13aN+e4dLZsL4pQDQ+Ak57Jp282lmrA9uGWD5XCiiA8FfVRGPhf/vX663Bw6i3kyJllyCrAirQ/QeKuWH/wtULFuAvB0vkZIPEgmRGrVW6bBQmN30AL/6MMTcEb9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658438; c=relaxed/simple;
	bh=qn5GA6lY9PvflO9P8xrWta1ntoOX5i4amwqf2P97V+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6J3pavMpUWrbYE/E4AfV2POJx0qagdEcgaML8s9nPGzjP5vX90sGA6g/D+jMcQincZgj0jBQnyxC8EpV59H7W+J9e2AiMzmuqsHMo+MtXhddiE0uU+Juu3A7iH7ZUXDZpu7GWwQkzcUJOUNlltbd8Dcamh7La2m40F90M9OmYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qbR0S3kA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LcRidvPYK4SO7i56E+hQhDbVPy+f03hM5L256hH5oME=; b=qbR0S3kAm6llWeUeMKwomhF0XS
	I22RSCSnSYpbg1AqWvFYjst3OLm2eT0pKt043WxfiC0EpSY0ufZRZYYqc3FLxS1poQCG2EWWhD+Qd
	PGh3k9S0UkSVnBR0VUqw3+Jd796MAUfsBwPbCXvARk9KjbUmpS75xsFhUBeSmVsAam9kc/6nBqTma
	MTUFIbgTG3teZ1a5xrb7to8gf33EX8ZVmt+TSj2M+B2BEmdjHaEhKSgk5sCCeaFLu6V5DpKeDpNRM
	DQ71RiEgd93DY15XZD5jB4hmcuiGIOvN/hxqeoCfHlne4TXZdkm0ETThnfJbdRX5tJ8rm4zsRcvzg
	8MrHMqdA==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN4JF-0000000BDsk-0592;
	Wed, 13 May 2026 07:47:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CC0A0300BDE; Wed, 13 May 2026 09:37:11 +0200 (CEST)
Date: Wed, 13 May 2026 09:37:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/21] objtool: Allow empty alternatives
Message-ID: <20260513073711.GI1889694@noisy.programming.kicks-ass.net>
References: <cover.1778642120.git.jpoimboe@kernel.org>
 <3c474673ec5ddc9f27fbf5ddb1fd0f66ef6a779f.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c474673ec5ddc9f27fbf5ddb1fd0f66ef6a779f.1778642120.git.jpoimboe@kernel.org>
X-Rspamd-Queue-Id: 9A70952EF5E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2796-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid,infradead.org:dkim]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 08:33:45PM -0700, Josh Poimboeuf wrote:
> arm64 can have empty alternatives, which are effectively no-ops.  Ignore
> them.  While at it, fix a memory leak.

How does this happen?

