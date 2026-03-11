Return-Path: <live-patching+bounces-2181-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8D5TGY4osWkBrgIAu9opvQ
	(envelope-from <live-patching+bounces-2181-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 09:32:14 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2EA425F5E8
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 09:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DAB28314A928
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 08:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1A236C5A2;
	Wed, 11 Mar 2026 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NmA2pocH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVddPJbl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oeex2kaX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SYobaRbR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E770A347FFE
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773217468; cv=none; b=GUdhFiSRZV1wGNxeMcVn+VsVchfCkiL2J8+ndg1yf+rBEH3YCQNOd7k35ifL8h1cNDBTjc95tZ6J8bkSNdZotngYZWjJwDYbkyuwlW1g9Efh4UL4Usi6f0y+85XQomLSWZgYvXMh2vMCqdncmnRzA0AuONL2X7FAD/WAlr3YtUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773217468; c=relaxed/simple;
	bh=iS5IIxVMgkksHJzdBGPxse68p3o4GOaLOXUVFkQERUI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Z8nIv0EQg+IRa4JINK3FqVmzkalA6xv7a97zxVDS+jxDJj+6DSeu61SaCg/toPHTAG3f1J6xqKO8JCF8fAkhmWoVJT/bsO9Wp3roKmAO23iB+f7FuQ+dYdRVUNu6uPwBu8vucMmscYtjuGVxnGZuK1SrGywzWiMxEceQWDFjR3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NmA2pocH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVddPJbl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oeex2kaX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SYobaRbR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E148E4D252;
	Wed, 11 Mar 2026 08:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773217463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2VDoG4qgirvBquEcLfmlPu2dvl2T+iu1SW8cK79GS8c=;
	b=NmA2pocH2heMkXY5+3NRBkqxyEvl+Wmn/A0IugdEFIvkyQ1BJL5KcH0B8IjpHwYrhXF1qV
	oLl60dcWk9EYvLj/XxD/ZcssNjOyYQ2v/Pn20lsKe6+cqkoDxhnymulC9VtP9Z0RHufitC
	q3e/s+Gd+OvPHEF4hvEt+4m0W0GLjy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773217463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2VDoG4qgirvBquEcLfmlPu2dvl2T+iu1SW8cK79GS8c=;
	b=KVddPJblQmeWPPQdPPrRRdCj6IOiQmWTlsTwkJBXoM0aFlYXsamUidvo+UlCUjRzUgXY1w
	OfLMqTnRKG1Rw0Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773217462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2VDoG4qgirvBquEcLfmlPu2dvl2T+iu1SW8cK79GS8c=;
	b=Oeex2kaXhr0qVjMJKZwyjUZsymTICnNW0et/WGkvadOWt2tggyhqhawNlI7rz1uW++ScLM
	/riJE+H94ehNAFUerHEy2xaV9o5yj6OV3+wzXxW7Rk9lGTv0XGsYdfDUVsRreksIS7+MAE
	u0/3NjcHXzXsvopzNWxAOdixlGpDbdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773217462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2VDoG4qgirvBquEcLfmlPu2dvl2T+iu1SW8cK79GS8c=;
	b=SYobaRbRcdcBzwR8ROiEEmYr9ihgc4AGoS2rBo2sdw2LF+6TTW+67PXO1Ilalijb0m03Dz
	iQ6iIsZi95AVNYAg==
Date: Wed, 11 Mar 2026 09:24:22 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
    Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
    Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 07/14] objtool: Extricate checksum calculation from
 validate_branch()
In-Reply-To: <ssvxqrraejznlambdt3yunuteguhu22yef236ngtqnpyhxruc6@bx2dhcbpzrbq>
Message-ID: <alpine.LSU.2.21.2603110916110.19933@pobox.suse.cz>
References: <cover.1772681234.git.jpoimboe@kernel.org> <7a1e22454a3fd1d968775c24aa0529a4ec7c5886.1772681234.git.jpoimboe@kernel.org> <alpine.LSU.2.21.2603101144410.14672@pobox.suse.cz> <ssvxqrraejznlambdt3yunuteguhu22yef236ngtqnpyhxruc6@bx2dhcbpzrbq>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Queue-Id: D2EA425F5E8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2181-lists,live-patching=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,pobox.suse.cz:mid]
X-Rspamd-Action: no action

On Tue, 10 Mar 2026, Josh Poimboeuf wrote:

> On Tue, Mar 10, 2026 at 11:47:41AM +0100, Miroslav Benes wrote:
> > Hi,
> > 
> > > @@ -3691,9 +3691,30 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
> > >  				 struct instruction *insn)
> > >  {
> > >  	struct reloc *reloc = insn_reloc(file, insn);
> > > +	struct alternative *alt;
> > >  	unsigned long offset;
> > >  	struct symbol *sym;
> > >  
> > > +	for (alt = insn->alts; alt; alt = alt->next) {
> > > +		struct alt_group *alt_group = alt->insn->alt_group;
> > > +
> > > +		checksum_update(func, insn, &alt->type, sizeof(alt->type));
> > > +
> > > +		if (alt_group && alt_group->orig_group) {
> > > +			struct instruction *alt_insn;
> > > +
> > > +			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
> > > +
> > > +			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
> > > +				checksum_update_insn(file, func, alt_insn);
> > > +				if (alt_insn == alt_group->last_insn)
> > > +					break;
> > > +			}
> > > +		} else {
> > > +			checksum_update(func, insn, &alt->insn->offset, sizeof(alt->insn->offset));
> > > +		}
> > > +	}
> > > +
> > 
> > does this hunk belong to the patch? Unless I am missing something, it 
> > might be worth a separate one.
> 
> It belongs, but I should have clarified that in the patch description.
> 
> This hunk wasn't needed before because validate_branch() already
> iterates all the alternatives, so it was calling checksum_update_insn()
> for every instruction in the function, including the alternatives.
> 
> Now that it's no longer called by validate_branch(),
> checksum_update_insn() has to manually iterate the alternatives.

After writing the email I had a suspicion it must have been something like 
above but failed to find it. Now I see that next_insn_to_validate() called 
in do_validate_branch() handles exactly that. Thanks for the pointer. The 
patch looks good to me then (and the rest as well as far as I can judge).

I must admit that objtool has gotten so complex that I have a hard time to 
track everything in the code :).

Regards
Miroslav

