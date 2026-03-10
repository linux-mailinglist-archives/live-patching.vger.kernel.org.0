Return-Path: <live-patching+bounces-2165-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFdkDuZIsGnFhgIAu9opvQ
	(envelope-from <live-patching+bounces-2165-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 17:37:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BA1254F1E
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 17:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A1FD30A0A6B
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 16:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F22D3AB27D;
	Tue, 10 Mar 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrvPcZ8A"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3263C30C621;
	Tue, 10 Mar 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160074; cv=none; b=gyvldtLpRWl1MEGky0tp3maxlH0D8+WNIqXe11kHnY3HdrzjQNV3yS3VIhPpnrGvLTvu8cJF1jQy8QU4wW/TCwDwlKQ+Cs0LmnNZ0iJOa5UOklw+plQriHXR68aNBLaM+c60z6ggfJzdcbjSqhBhYjgK20ln3OQXL+QH0GmDsY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160074; c=relaxed/simple;
	bh=RHH7v1eYe5/4qeajjOvz7w+sEQrT2JlDgyL8J9bFx8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OP4GlhJ5Vgl4JNVKLplNc1RO7UkY0QOYbgWiHqmqGV19PLZv+9Xz1RSd05+5oUE2A8rE7WzROwP19UzxxM/jtgtH5fwdABtq7adhIgIk8OtaeEHQQ2a0AtZ8cNasdyIpHP+FBswH0kW3QxNQMULBJWYa2h8JM2sUfURSlNMwQBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrvPcZ8A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E02C19425;
	Tue, 10 Mar 2026 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773160073;
	bh=RHH7v1eYe5/4qeajjOvz7w+sEQrT2JlDgyL8J9bFx8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrvPcZ8AMt0Pq8k5pI4uTfCYzDcol4oBN0qwhDnNfsB2cssVCUEsBKVA9YRnaN68r
	 nML0DqrdNlu7E0zRxoWtL9fcf5PWnbUuqvL/uKsAzbHcTomr87bU5pAiKZAReZ0ORT
	 jdpYDacWRXAwKFZ4/XFJKnbaC8hE6VjgFHg6LC7GPcqqtraFcdkfFATF0YrTl6iXKo
	 uc4MyywPPDIwfuJcFed9l0TfUroi92hOTySrV0zMfv11VcfBs2hVvCp0FrAFf8qYxn
	 YZmlZJfLh+bPMOfjkDzTQR+xPFYTnFDY021qg+W3bmREkhlmrjNIQnXhA3lU03GHm4
	 oZaBuSMBP5ucA==
Date: Tue, 10 Mar 2026 09:27:51 -0700
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
Message-ID: <ssvxqrraejznlambdt3yunuteguhu22yef236ngtqnpyhxruc6@bx2dhcbpzrbq>
References: <cover.1772681234.git.jpoimboe@kernel.org>
 <7a1e22454a3fd1d968775c24aa0529a4ec7c5886.1772681234.git.jpoimboe@kernel.org>
 <alpine.LSU.2.21.2603101144410.14672@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2603101144410.14672@pobox.suse.cz>
X-Rspamd-Queue-Id: A5BA1254F1E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2165-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 10, 2026 at 11:47:41AM +0100, Miroslav Benes wrote:
> Hi,
> 
> > @@ -3691,9 +3691,30 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
> >  				 struct instruction *insn)
> >  {
> >  	struct reloc *reloc = insn_reloc(file, insn);
> > +	struct alternative *alt;
> >  	unsigned long offset;
> >  	struct symbol *sym;
> >  
> > +	for (alt = insn->alts; alt; alt = alt->next) {
> > +		struct alt_group *alt_group = alt->insn->alt_group;
> > +
> > +		checksum_update(func, insn, &alt->type, sizeof(alt->type));
> > +
> > +		if (alt_group && alt_group->orig_group) {
> > +			struct instruction *alt_insn;
> > +
> > +			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
> > +
> > +			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
> > +				checksum_update_insn(file, func, alt_insn);
> > +				if (alt_insn == alt_group->last_insn)
> > +					break;
> > +			}
> > +		} else {
> > +			checksum_update(func, insn, &alt->insn->offset, sizeof(alt->insn->offset));
> > +		}
> > +	}
> > +
> 
> does this hunk belong to the patch? Unless I am missing something, it 
> might be worth a separate one.

It belongs, but I should have clarified that in the patch description.

This hunk wasn't needed before because validate_branch() already
iterates all the alternatives, so it was calling checksum_update_insn()
for every instruction in the function, including the alternatives.

Now that it's no longer called by validate_branch(),
checksum_update_insn() has to manually iterate the alternatives.

-- 
Josh

