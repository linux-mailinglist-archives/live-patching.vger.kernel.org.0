Return-Path: <live-patching+bounces-2489-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0PsAFas56mnYxAIAu9opvQ
	(envelope-from <live-patching+bounces-2489-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:24:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D0D45442C
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4C7230512BA
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 15:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250BB3168FB;
	Thu, 23 Apr 2026 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDbET88W"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258430BF4F;
	Thu, 23 Apr 2026 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957371; cv=none; b=ooLraES985LLknkXVsrHQtlXRW7NvjbhPvnGbMcqHvjeY6gEJLmlBE36TZQG3J3ZLKIGXXuhPqIq+MQfRoriWzLhqE2myKg3U3Y3TTJtAwwb74OjYro6h4ZWvE5YXmlo25FmSzME6gdIlgrtb1ROtCDTzsByiBw0Xm7DpLszQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957371; c=relaxed/simple;
	bh=9ur3pBYY51/KSTtxSE7njwszafMB1Qbxm7+nJddNEFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyrZTBFRFKkKGDoYntSxu9mFVsq0bhIgpyD4hkJPpTcUR+OdxjmmahxEr4SQ8zLd2vjE6m7Xb6zHAMfcjL6m12cqAqQN3CMPo7UCh8vWO3JBbIbLUbD4ERXZgJafqsSnzI2FHCWXKJMbF0aNl7r0W7VIw01ksj4qIspQFg0xiWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDbET88W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF518C2BCAF;
	Thu, 23 Apr 2026 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776957370;
	bh=9ur3pBYY51/KSTtxSE7njwszafMB1Qbxm7+nJddNEFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDbET88Wg3m9m0asCGSRDC4F2WLSiTDQanIMcdp5uNSif1RUnb4cUVDrzOolqGE4y
	 xeIp5pJJyfQNMR6Xt1YFd1yq6emzC7FnxnQ78uWlxvpaOsddQ2bUAqXhES21dyloBc
	 +Q8DiQ2/FjrDP336tNa/iOLUSrOxnpNcd84INBpdVav05+tcUxwGd01k6gBtXETMwj
	 2vl9or7cdpXvA18JVj702SoCEJ5ccfN2RVkpiG9Urxbi93tZXDG08EGwSOghT3Qngz
	 T2rPVaZhm/oqxPgRt5EPPFswuesEadteS7XQWvh9Dt0y6UfYfmTyv+tOSvjVYOKBbG
	 GfsmK6ZJbK2Qw==
Date: Thu, 23 Apr 2026 08:16:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2489-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B5D0D45442C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > __pfx_ symbols were considered redundant.
> > 
> > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > the hash and the function entry which have no symbol to claim them.
> 
> If you force the function alignment to 64 bytes, the prefix will also be
> 64bytes, rather than the normal 16.

Sorry, how do you get 64 here?

> > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > Without a symbol, unwinders and other tools that symbolize code
> > locations misattribute those bytes.
> > 
> > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > CALL_PADDING configs, covering the full padding area regardless of
> > whether there's also a __cfi_ symbol.
> 
> Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> __cfi_ symbols to cover the whole prefix?

Yeah, I suppose that would be better, via objtool I presume.

-- 
Josh

