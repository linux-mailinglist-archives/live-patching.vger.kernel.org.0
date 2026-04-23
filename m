Return-Path: <live-patching+bounces-2493-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AMqHvtH6mkhxgIAu9opvQ
	(envelope-from <live-patching+bounces-2493-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:25:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E85C1454D76
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 523C0304A8A8
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 16:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4283937BE75;
	Thu, 23 Apr 2026 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DecnII9t"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F99029DB6E;
	Thu, 23 Apr 2026 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776961395; cv=none; b=OwIXvVwk8Pztt/51tR8AUECahGv8UjzAPC4Gl27IYCt/amABXrPzI/F7YqggQ4ayxPYmTGiB2ci7EQwcYAVyUBZVMwP7gSXKLysr3rVk4gIGt8sPJUVOxvTR8tat2x4Pet6fdIHVTki5/vafqGTJfS8Ux3BsiwenF4lGXXqy/0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776961395; c=relaxed/simple;
	bh=+b6m9/+XP871sOG/g+8+KQbpe2Vcbt/UNTXZXN0PGnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVORUQbmF5JCW5D4J8rsR9MhJYpvBUU+P1yecm05BWulA+DineWVuGDA+dh/PwgM49Eli5CR5r5znwffj6MnWlZpTZcbbXmSMifGUL35SLex7gZuw7BR6igN/4CxlTD6TJc2STikstBhp2NdcNgZWyxup15kbSBeQ/KU9bmDnvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DecnII9t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A24C2BCAF;
	Thu, 23 Apr 2026 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776961394;
	bh=+b6m9/+XP871sOG/g+8+KQbpe2Vcbt/UNTXZXN0PGnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DecnII9twvKKiiSlp3PfPUKjOANTEKZ0LpySTWZt7g8/qFCHKoxaT2PZxo9yMl/kT
	 /GkfhHzo17W1iIUIptQGX+6ggGaAFvLfLRKJuyeHfxrzsvnEgmt2wUAuoFWb9zS/Ic
	 bNSBJzaU0T1AG/SXdeA9ldKBLRVQGfF7vsUf7EyrHfEbyHvK065e/iwv9vtvhn8ofT
	 paiTe6Qaut3CN/WPypKHzpaDzQS5o+Igro6rsEJ0cGOHk7z55z2kzLfeAIY/7OC9//
	 Ac8tEs/n9X9+pus1+LEVvfppCZW0aGoB12NOsu3CtjLpMLqoGNLzzOWShFwqlfkBDL
	 1jLedfXPVyOAA==
Date: Thu, 23 Apr 2026 09:23:12 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
 <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2493-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E85C1454D76
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 05:19:25PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 23, 2026 at 08:16:08AM -0700, Josh Poimboeuf wrote:
> > On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:
> > > On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> > > > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > > > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > > > __pfx_ symbols were considered redundant.
> > > > 
> > > > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > > > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > > > the hash and the function entry which have no symbol to claim them.
> > > 
> > > If you force the function alignment to 64 bytes, the prefix will also be
> > > 64bytes, rather than the normal 16.
> > 
> > Sorry, how do you get 64 here?
> 
> DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y

Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
Or a 64-byte pfx for the !CFI case.

> > > > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > > > Without a symbol, unwinders and other tools that symbolize code
> > > > locations misattribute those bytes.
> > > > 
> > > > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > > > CALL_PADDING configs, covering the full padding area regardless of
> > > > whether there's also a __cfi_ symbol.
> > > 
> > > Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> > > __cfi_ symbols to cover the whole prefix?
> > 
> > Yeah, I suppose that would be better, via objtool I presume.
> 
> Yup.

-- 
Josh

