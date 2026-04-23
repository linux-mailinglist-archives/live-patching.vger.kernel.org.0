Return-Path: <live-patching+bounces-2488-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEE0FEo36mk+xAIAu9opvQ
	(envelope-from <live-patching+bounces-2488-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:14:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A277545425E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9FF04301AAA3
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 15:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7986136D9F5;
	Thu, 23 Apr 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHb2ilM6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D631E853;
	Thu, 23 Apr 2026 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957252; cv=none; b=qPhF173JFO+Fw9zVOjhsLPTelqkhS+d680N1hniy7Zdf+7+Y5u6kabHsuCTSZtHU7DRjWvtgcFloF9/wIhleStIzIxrfWeP36bIPfXk/Yme4BJMDz4M3On2HIKeqs81sjgx843pnLRGKShDWzmotxqzqBf2rY9CyeyO2AvvPKh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957252; c=relaxed/simple;
	bh=vQr1s65g2ELJDvS9HZ/Lah4ukT3lwQqVlMraGeIUW3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTo48PDhiQAks6T/3nvt9TzApoJnr57gBdfKk21hF2wefiHr8pkMlqu/nVY9YlDgfGv6+tq95cLGh2k/Cl5U3TCt9kr45Aq9Ml+Wl6hVJLnego2SS4CrsGZqc1E8/oyuLIdovRm6HAng4Lm7LYBul9IyAJwf9qsKwEi9uIKpZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHb2ilM6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D97C2BCB3;
	Thu, 23 Apr 2026 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776957252;
	bh=vQr1s65g2ELJDvS9HZ/Lah4ukT3lwQqVlMraGeIUW3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HHb2ilM6kJ6jawjSuM5t0pD+3LM5EtbUJjN5C4sVR0eXxKn7/fxRXFVWmJIPa8DCh
	 zvLgZ7Jt48kW6NlLlQkUX/9DxLnM+r4i5uSXYQztvAqvK3xvJgUEooeocnyDhF6eal
	 Q7/rsaSgSrR1fsEO/yXWCxvxT0jh1EzH24gPgtt2LnoBNYgZdGbOyL9KmuL/OKnGvv
	 tv2icsyoy+qqUp7Cv7bvnud174z1eo+p39EI4n0NmNr2ul5xeeTAmIUr/fqFC3cmgO
	 cocvKxf6KXcerphrDz0trKUmjwk8eG7eXDHzP03HKVxp3GJ0w36shUPzf6DUfpLFuS
	 R4jaAXI/W1NhA==
Date: Thu, 23 Apr 2026 08:14:09 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 43/48] objtool: Add insn_sym() helper
Message-ID: <rq3dkjgzrcmj5smj64szi5kwbapwcjj2dga3sdwfokamqvavef@cspvakuhkr25>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <d0762e0bd04d4d93940c212d2b8080bdced0cb29.1776916871.git.jpoimboe@kernel.org>
 <20260423084537.GX3126523@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423084537.GX3126523@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2488-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A277545425E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 10:45:37AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 22, 2026 at 09:04:11PM -0700, Josh Poimboeuf wrote:
> > Alternative replacement instructions awkwardly have insn->sym set to the
> > function they get patched to rather than the symbol (or rather lack
> > thereof) they belong to in the file.
> > 
> > This makes it difficult to know where a given instruction actually
> > lives.
> > 
> > Add a new insn_sym() helper which preserves the existing semantic of
> > insn->sym.  Rename insn->sym to insn->_sym, which contains the actual
> > ELF binary symbol (or NULL, for alternative replacements) an instruction
> > lives in.
> > 
> > The private insn->_sym value will be needed for a subsequent patch.
> > 
> 
> > +/*
> > + * Return the symbol associated with an instruction.  For alternative
> > + * replacements, return the symbol of the original code being replaced rather
> > + * than NULL.  insn->_sym reflects the actual location in the ELF file.
> > + */
> > +static inline struct symbol *insn_sym(struct instruction *insn)
> > +{
> > +	struct symbol *sym = insn->_sym;
> > +
> > +	if (!sym && insn->alt_group && insn->alt_group->orig_group)
> > +		sym = insn->alt_group->orig_group->first_insn->_sym;
> > +
> > +	return sym;
> > +}
> 
> That is a bit of a deref fest -- this does not affect performance
> negatively?

Ha, the "deref fest" only happens for alternative replacement
instructions, so presumably not?

-- 
Josh

