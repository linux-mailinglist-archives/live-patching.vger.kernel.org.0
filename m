Return-Path: <live-patching+bounces-2487-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJCTNE836mk+xAIAu9opvQ
	(envelope-from <live-patching+bounces-2487-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:14:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC7945425F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2D2A300441B
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F91235C1AD;
	Thu, 23 Apr 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D2D0K2qC"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F9D2D0606;
	Thu, 23 Apr 2026 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957251; cv=none; b=sb43BX/QAAR9xOLAr9sTb1qpgjFJZ6qL9Tmb9F+daAywny/mylQoH8uLVKMcYBr9FbiDdSzisOuie04Rdm4btOE2Blfof+XGNbpRRtdzUIY352wlVrFXqqeuy7g2ZtcVto+GoIC08RMWKvBZdMnaH/LkqDguP/XKxRzCJR5HPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957251; c=relaxed/simple;
	bh=Ikr64mjm4USeyX+kb6hxgMnRN51C6nXiktBI1U9h8iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PhtBkcLXFTKKvypfwWIWr+VUR2Eh95CkQeM+euUdch8ZTIhMgFZd9bmTqVXyt4Uh/LcyVx6xAkLx/dnUMy5biia8I3f39mHUYKJ9zP3N4SrnSdFjhHz9EvmynANyvBiWQp8xlYo+iWwnYIVRVRTY8gv64lHOAoG3IG/sSujJjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D2D0K2qC; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NV1XFE+nYfPCWZSkwRuiV7mwNmbpvEI+zieS6GFkG1g=; b=D2D0K2qCwgSuLs8wllyrqWRlYA
	f1Nlt9MCY7tMFMeECjTZarTgIul+mKLruHPCiwKGA4Uo95MAyehK4VZn/PS8n0C/ralAWTAbtnaAb
	sFfdNUezTCaugmU2qALz4lY1+jTpKog0ybD2i4IiyoWCDv0OVuZVhAJSrq6UdU/FGOYqQobbHN59w
	v/MEHmaooVVncbDTPu4wew+gNfNfMcXdmKqQ0Bew2/Ez0FxrvWOjVSK/IRoxnK5YuS/PAFgVxZ47U
	K4Y3ERUteQLuIiAx/wecOs211SW7aJRtHNh8H4upW5s0ekYSj8MWM8zTixR/91mclVFpYlASsj6+S
	rbkt3u6w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFvkl-0000000DK4G-2AeE;
	Thu, 23 Apr 2026 15:14:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4841C3008E2; Thu, 23 Apr 2026 17:14:05 +0200 (CEST)
Date: Thu, 23 Apr 2026 17:14:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 32/48] objtool: Add is_cold_func() helper
Message-ID: <20260423151405.GF1064669@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <8eea11ea7d0efc5fcd2e57a10c4285fe998f0cec.1776916871.git.jpoimboe@kernel.org>
 <20260423083849.GV3126523@noisy.programming.kicks-ass.net>
 <qp7srvaafzmgsh334jeidseax2zgvt2j65iugsru5co3wrm6ka@opizry3c2m6d>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qp7srvaafzmgsh334jeidseax2zgvt2j65iugsru5co3wrm6ka@opizry3c2m6d>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2487-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MAILSPIKE_FAIL(0.00)[2600:3c15:e001:75::12fc:5321:query timed out];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim]
X-Rspamd-Queue-Id: EEC7945425F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 08:12:07AM -0700, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2026 at 10:38:49AM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 22, 2026 at 09:04:00PM -0700, Josh Poimboeuf wrote:
> > 
> > > diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> > > index 00c2389f345f..8a6e1338af97 100644
> > > --- a/tools/objtool/elf.c
> > > +++ b/tools/objtool/elf.c
> > > @@ -586,8 +586,11 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
> > >  	if (strstarts(sym->name, ".klp.sym"))
> > >  		sym->klp = 1;
> > >  
> > > +	sym->pfunc = sym->cfunc = sym;
> > > +
> > >  	if (!sym->klp && !is_sec_sym(sym) && strstr(sym->name, ".cold")) {
> > > -		sym->cold = 1;
> > > +		/* Tell read_symbols() this is a cold subfunction */
> > > +		sym->pfunc = NULL;
> > >  
> > >  		/*
> > >  		 * Clang doesn't mark cold subfunctions as STT_FUNC, which
> > > @@ -596,8 +599,6 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
> > >  		sym->type = STT_FUNC;
> > >  	}
> > >  
> > > -	sym->pfunc = sym->cfunc = sym;
> > > -
> > >  	return 0;
> > >  }
> > 
> > So now the cold subfunction has a NULL parent-function and a
> > child-function that points to the parent?
> > 
> > I'm confused.
> 
> It's a bit clunky.  As the comment implies, 'sym->pfunc = NULL' is a
> signal to it caller read_symbols() that this is a .cold function.  Then,
> after all the symbols have been added, read_symbols() goes and finds the
> parent.
> 
> I think I did it this way because klp-diff.c calls elf_add_symbol() (via
> elf_create_symbol()) and later needs to call is_cold_func() on it.  In
> that case, even though the parent isn't set, it still works because
> is_cold_func() returns true for sym->pfunc != sym;

I'm thinking this needs more comments if it stays like this. Is most
confusing.

