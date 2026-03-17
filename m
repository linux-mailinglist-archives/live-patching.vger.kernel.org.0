Return-Path: <live-patching+bounces-2215-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PVYN82UuWkJKwIAu9opvQ
	(envelope-from <live-patching+bounces-2215-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 18:52:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4112B0455
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 18:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF2773320034
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 17:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98544320CCF;
	Tue, 17 Mar 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cvbw3MJi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7614C2D73B8;
	Tue, 17 Mar 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768085; cv=none; b=aYSsbADXJLKlunrbdr4ntac/RPzVy3Df4hU++m8w64XOKGZs+8jvNOwTBcVB/YCXzKt19MPK7QFLZXpF9E6g4RwvfaJDRnQoX0oK+UBQHJ9hr28J6huJWXa3NeNz9v0javp+hSUnASd9AMr+N2QpLliNJnNAX9xnpaE3CXuQc/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768085; c=relaxed/simple;
	bh=IVGSJM4LoIWwlPtv0GpUpx6vGDQ9JIgeGDNFN88Xd50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6cKkCTI96jYLMzQ6uVCAt8QNAfjaV9y7RecxI2fVSay6zJAhN1nJx6QvWPy9z45u7YdLDLqm/6fp6e8U381x13d4yrzWdYmLii3YwkvWsEH5xH33kBYWzMC2ftqZ8lG4Ej8o9SL9t95zuSQX6nWwjKvVtyvQ1kY7E+X/lKJyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cvbw3MJi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F05C2BCB1;
	Tue, 17 Mar 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773768085;
	bh=IVGSJM4LoIWwlPtv0GpUpx6vGDQ9JIgeGDNFN88Xd50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cvbw3MJivK1a7TY6KXu52jnmTTZwyvvg/0OorfvWUOHY9IRHuSlsqXJS29zGSdIX6
	 38MCIGzqHytjPGYJAMDzFZWCv3ShrWgSqTcAj+S3vlOKJoQkEBPTC1hqUzlEIC+bsc
	 nb4W9QuYuDrggQX6ZUvpoXlQFQLVg4BgDKY/NJprf2FTbyDo6Mezy9Yjn7ZsKmMW7C
	 T8D1ZGABtrNm2JRopipcU+Uu92hGYI2Db88NDF1q1+g6BTHoObrr6Pi0jKWk77+h9u
	 ZZsRftAMuryD7MB2GmpdDuTAouAZrVktWgWFywtIF375FN/jQTkbMWkSIhtFghXdlD
	 U1xQoB44fKTRw==
Date: Tue, 17 Mar 2026 10:21:22 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 07/14] objtool: Extricate checksum calculation from
 validate_branch()
Message-ID: <77f2cxfdnnddygnzrwmq5krnpvhfln4hnvyscnhays25vojt3y@noahb2i2sakg>
References: <cover.1772681234.git.jpoimboe@kernel.org>
 <7a1e22454a3fd1d968775c24aa0529a4ec7c5886.1772681234.git.jpoimboe@kernel.org>
 <alpine.LSU.2.21.2603101144410.14672@pobox.suse.cz>
 <ssvxqrraejznlambdt3yunuteguhu22yef236ngtqnpyhxruc6@bx2dhcbpzrbq>
 <alpine.LSU.2.21.2603110916110.19933@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2603110916110.19933@pobox.suse.cz>
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
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2215-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7A4112B0455
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 11, 2026 at 09:24:22AM +0100, Miroslav Benes wrote:
> On Tue, 10 Mar 2026, Josh Poimboeuf wrote:
> 
> > On Tue, Mar 10, 2026 at 11:47:41AM +0100, Miroslav Benes wrote:
> > > Hi,
> > > 
> > > > @@ -3691,9 +3691,30 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
> > > >  				 struct instruction *insn)
> > > >  {
> > > >  	struct reloc *reloc = insn_reloc(file, insn);
> > > > +	struct alternative *alt;
> > > >  	unsigned long offset;
> > > >  	struct symbol *sym;
> > > >  
> > > > +	for (alt = insn->alts; alt; alt = alt->next) {
> > > > +		struct alt_group *alt_group = alt->insn->alt_group;
> > > > +
> > > > +		checksum_update(func, insn, &alt->type, sizeof(alt->type));
> > > > +
> > > > +		if (alt_group && alt_group->orig_group) {
> > > > +			struct instruction *alt_insn;
> > > > +
> > > > +			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
> > > > +
> > > > +			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
> > > > +				checksum_update_insn(file, func, alt_insn);
> > > > +				if (alt_insn == alt_group->last_insn)
> > > > +					break;
> > > > +			}
> > > > +		} else {
> > > > +			checksum_update(func, insn, &alt->insn->offset, sizeof(alt->insn->offset));
> > > > +		}
> > > > +	}
> > > > +
> > > 
> > > does this hunk belong to the patch? Unless I am missing something, it 
> > > might be worth a separate one.
> > 
> > It belongs, but I should have clarified that in the patch description.
> > 
> > This hunk wasn't needed before because validate_branch() already
> > iterates all the alternatives, so it was calling checksum_update_insn()
> > for every instruction in the function, including the alternatives.
> > 
> > Now that it's no longer called by validate_branch(),
> > checksum_update_insn() has to manually iterate the alternatives.
> 
> After writing the email I had a suspicion it must have been something like 
> above but failed to find it. Now I see that next_insn_to_validate() called 
> in do_validate_branch() handles exactly that. Thanks for the pointer. The 
> patch looks good to me then (and the rest as well as far as I can judge).

Actually, next_insn_to_validate() helps with an edge case for directing
code flow from the end of an alternative back to the original code.

The code which traverses the alternatives is in validate_insn():

	if (insn->alts) {
		for (alt = insn->alts; alt; alt = alt->next) {
			TRACE_ALT_BEGIN(insn, alt, alt_name);
			ret = validate_branch(file, func, alt->insn, *statep);
			TRACE_ALT_END(insn, alt, alt_name);
			if (ret) {
				BT_INSN(insn, "(alt)");
				return ret;
			}
		}
		TRACE_ALT_INFO_NOADDR(insn, "/ ", "DEFAULT");
	}

> I must admit that objtool has gotten so complex that I have a hard time to 
> track everything in the code :).

The code hasn't changed *too* much, it's just that validate_branch() got
split up more when the tracing code went in, so things are organized a
bit differently.  Most of that code is now in validate_insn().

-- 
Josh

