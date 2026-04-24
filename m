Return-Path: <live-patching+bounces-2515-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKRcI1tT62nkKwAAu9opvQ
	(envelope-from <live-patching+bounces-2515-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 13:26:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C43D45DAF1
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 13:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 727DD30022F1
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC7377EAC;
	Fri, 24 Apr 2026 11:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hz+L8RJd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bgmd/BxP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hz+L8RJd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bgmd/BxP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013453AEF28
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777029976; cv=none; b=s7b1XQ+xXWgup07K/mLOmI8dkzdu1CQktvbqwv3etNCaRoXFxsTNTagOSZlYA5ugug6yaiBfvHurmcTI06jcG4SWJWFB1xJp0Phk/VZDFQnuUQvmk9s2by6lZyZ84mzhH2EpOEbS4wIuruYz9PdP/eMiCKy3HY9srNdR/lvZA2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777029976; c=relaxed/simple;
	bh=X1RzfpWR3lhLI4fkc8ugUMaDV5zheKpf6xTvHhjKdYw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jMnvWYRpuXFWb+1oTmw2NybCMSAOwTNTx3Jf+I7jLh3+1nXUCCYFFo3e6Wwla3bOOGkp1XWpupZ/2brihMm1WYEEZiZmAouDK9ZZiJiREoDUCoe07YoudG/laZ5L6/LVOTB4m7Vx7+x3DvSxwG+AnJd+tSEoT/DpAZ3wjuZH320=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hz+L8RJd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bgmd/BxP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hz+L8RJd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bgmd/BxP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 483C36A807;
	Fri, 24 Apr 2026 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777029973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ijwsl8uYdJWK1YrmizQQeKEPnVtORJtdNR8MbPrWWLI=;
	b=hz+L8RJdIncF0Y/KS1uxfQFxtLLC2NKMYXR9s/3xi5d4EPjbndW3ox9MW4FtgM78WseytQ
	LtViEEOaFLUXTCjF8u3gyLLvFyJH7goGbHUJUwGY5LH1OF2TwQkJNmVxMzf64zphrnqvWe
	lF8v7WSfp9WdB/VwX1/G54NjsnhKg1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777029973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ijwsl8uYdJWK1YrmizQQeKEPnVtORJtdNR8MbPrWWLI=;
	b=bgmd/BxPYHIoYza8AB1db94YI0duVpfFb4coPfmv/y0gIncrJFEm7Tz8Od6r/mL7imLEL0
	Q8mS78mhdRcbh1DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777029973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ijwsl8uYdJWK1YrmizQQeKEPnVtORJtdNR8MbPrWWLI=;
	b=hz+L8RJdIncF0Y/KS1uxfQFxtLLC2NKMYXR9s/3xi5d4EPjbndW3ox9MW4FtgM78WseytQ
	LtViEEOaFLUXTCjF8u3gyLLvFyJH7goGbHUJUwGY5LH1OF2TwQkJNmVxMzf64zphrnqvWe
	lF8v7WSfp9WdB/VwX1/G54NjsnhKg1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777029973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ijwsl8uYdJWK1YrmizQQeKEPnVtORJtdNR8MbPrWWLI=;
	b=bgmd/BxPYHIoYza8AB1db94YI0duVpfFb4coPfmv/y0gIncrJFEm7Tz8Od6r/mL7imLEL0
	Q8mS78mhdRcbh1DA==
Date: Fri, 24 Apr 2026 13:26:13 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: Song Liu <song@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 04/48] objtool/klp: Ignore __UNIQUE_ID_*() PCI stub
 functions
In-Reply-To: <l6spha5o4wl5ksczovjwxghb5lhe4parswxhtzk2ac4inxmmhc@h2hiehwqkgmx>
Message-ID: <alpine.LSU.2.21.2604241325550.25696@pobox.suse.cz>
References: <cover.1776916871.git.jpoimboe@kernel.org> <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org> <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com> <gmjxp6lzlwjfdp4gf2nktoqfwrdx4bapf2mnnezo2gjyjj6yqf@if35zh3xa7t6>
 <CAPhsuW6VWk43z+BYCYRxo56w-4VKw8W3nmvVfCLh=ouN7a2Cqg@mail.gmail.com> <l6spha5o4wl5ksczovjwxghb5lhe4parswxhtzk2ac4inxmmhc@h2hiehwqkgmx>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-2146828000-2109205470-1777029973=:25696"
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 2C43D45DAF1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2515-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+,1:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,pobox.suse.cz:mid]

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-2109205470-1777029973=:25696
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 23 Apr 2026, Josh Poimboeuf wrote:

> On Thu, Apr 23, 2026 at 02:33:00PM -0700, Song Liu wrote:
> > On Thu, Apr 23, 2026 at 12:31 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Thu, Apr 23, 2026 at 12:05:03PM -0700, Song Liu wrote:
> > > > On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > > >
> > > > > With Clang LTO enabled, DECLARE_PCI_FIXUP_SECTION() uses __UNIQUE_ID()
> > > > > to generate uniquely named wrapper functions, which are being reported
> > > > > as new functions and unnecessarily included in the patch module:
> > > > >
> > > > >   vmlinux.o: new function: __UNIQUE_ID_quirk_f0_vpd_link_661
> > > > >
> > > > > These stub functions only exist to make the compiler happy.  Just ignore
> > > > > them along with any other dont_correlate() symbols.  Note that
> > > > > dont_correlate() already includes prefix functions.
> > > > >
> > > > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > >
> > > > The actual change appears to be much bigger than the subject line.
> > > > Maybe rephrase it a bit?
> > >
> > > Hm, in fact this is a relic from a previous iteration of the patches: it
> > > longer fixes what it claims to fix, as __UNIQUE_ID_ (other than
> > > __ADDRESSABLE()) are now correlated.  The claimed issue actually gets
> > > fixed later by the rewriting of the correlation algorithm.
> > >
> > > That said, I still think the below is needed, I just need to rewrite the
> > > commit log.
> > 
> > Agreed.
> 
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> Subject: [PATCH] objtool/klp: Don't report uncorrelated functions as new
> 
> Clang LTO uses __UNIQUE_ID() to generate some uniquely named wrapper
> functions, like initstubs.  If they're uncorrelated, prevent them from
> being reported as new functions and included unnecessarily.
> 
> Note that dont_correlate() already includes prefix functions, so prefix
> functions are still being ignored here.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M
---2146828000-2109205470-1777029973=:25696--

