Return-Path: <live-patching+bounces-1970-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /knQBr9Qgmn9SAMAu9opvQ
	(envelope-from <live-patching+bounces-1970-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 20:47:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B89DE417
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 20:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94C3C3016EC4
	for <lists+live-patching@lfdr.de>; Tue,  3 Feb 2026 19:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E8928750C;
	Tue,  3 Feb 2026 19:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLU591Mx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E22821CA13
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 19:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770148026; cv=none; b=Thdtu8XXRyD/EOOlllh3EdAgp7+TT6WFHuVenRyKkhpMPH5vpGcdvkQA27xElFPi7QX8Yc+EKpjHEMYsx2pNerjbPeixBrkM6yah57PQYYQKSuvl4IXGzfxtpdcUjfgHoR/Cv2TqH4A3U5gppvcP4uVCinm4ReCx0QYob8UihrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770148026; c=relaxed/simple;
	bh=JDkedLKGlNDWC9dXLU4s4kQod//P+2aUbb8GcusFdXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QihuM6b3R6U2go/5hn0+dVqr2CGeO/ucgMk8PbbQg2vdzVWFCJZrl7Ups4TkFFyCl0u4ju4CTZ9Z6SLYRUkjmZ8WpibpVckq07TStm16lQsDaStlt1ofJvWDzeWknUomrMfY0tpvqp5g4ajZ4nDqFlgjHB9nlgO3gOR+ihvkGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLU591Mx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5A9C116D0;
	Tue,  3 Feb 2026 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770148025;
	bh=JDkedLKGlNDWC9dXLU4s4kQod//P+2aUbb8GcusFdXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLU591MxQ6WUAXgBoBs4E+Rf7uig5C9XhpqEfmdrQm71633nP5txcdYOiqFJ+YETE
	 ZXekW5oiNs82pvol+0u0QnZ6PF5g3a01+BD3axSMWnLlVOR5iZTQ3Suw8VAABZ3I4/
	 iQlJUXCJPzj/uuqGr+AShT2yNn+yK8C/mhgNb+DGN2ooF8jD3nSyOUcnhV5M9Iht5k
	 NUVrPd6fWKxEcYG558Rql0ZZAZ4/PUPWUyOGgm6jcSap1qi9V4RgmyEsel0kwhYn+i
	 kD9Y0rF6wRpWwhNpe1QvT1QP19I2X/IgparWLlzMoh+21AG+1Z9V5vh3h+PH4NXffB
	 /e259OEAWRn4Q==
Date: Tue, 3 Feb 2026 11:47:03 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
Message-ID: <rusx7q6nt5qirdwssle4f75scevay3halgqdo2xtvlgaj6bxjh@gvwhdg37cm6e>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
 <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
 <aX0W0JWRkLbuQpGY@redhat.com>
 <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
 <72pzjkj4vnp2vp4ekbj3wnjr62yuywk67tavzn27zetmkg2tjh@nkpihey5cc3g>
 <604a8b96-47f2-4986-b602-c7bdf3de7cca@redhat.com>
 <CAPhsuW4oQfWTPd7jQKhd8Ff-9gWW9GMKyA9HpUCxF2F0KXecEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4oQfWTPd7jQKhd8Ff-9gWW9GMKyA9HpUCxF2F0KXecEA@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1970-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A0B89DE417
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:53:04AM -0800, Song Liu wrote:
> On Tue, Feb 3, 2026 at 8:45 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> [...]
> > > Or at least validate_patches() could be replaced with
> > > check_unsupported_patches(), as the apply/revert test wouldn't be needed
> > > since the actual apply/revert would happen immediately after that in
> > > fix_patches().
> > >
> >
> > Currently fix_patches runs in short-circuit step (2) after building the
> > original kernel.  But what if the user runs:
> >
> >  $ klp-build -T 0001.patch
> >  $ klp-build -S 2 0002.patch
> 
> On one hand, I think this is a user mistake that we need the users
> to avoid by themselves. If the user do
> 
>    $ klp-build -T 0001.patch
>    $ klp-build -S 3 0002.patch
> 
> Even when 0001.patch and 0002.patch are totally valid, the end
> result will be very confusing (it is the result of 0001.patch, not 0002).

Right, I consider it a power tool, use at your own discretion...
starting at step 2 overwrites the previous step 2.

> > If we move fix_patches() to step (1) to fail fast and eliminate a
> > redundant apply/revert, aren't we then going to miss it if the user
> > jumps to step (2)?

fix_patches() would still *conceptually* be part of step 2.  But as an
implementation detail (so that it fail fasts with a bad patch), step 2
would be split into two phases: before step 1 and after step 1.

if (( SHORT_CIRCUIT <= 2 )); then
	# validate and fix patches
fi

if (( SHORT_CIRCUIT <= 1 )); then
	# build orig kernel
fi

if (( SHORT_CIRCUIT <= 2 )); then
	# apply patches and build patched kernel
fi

> > Is there a way to check without actually doing it if we're going to
> > build the original kernel first?
> >
> > And while we're here, doesn't this mean that we're currently not running
> > validate_patches() when skipping to step (2)?

No, it would still run for -S2, see above.

> On the other hand, I guess we can always run fix_patches. If any
> -S is given, we compare the fixed new patches against fixed saved
> patches. If they are not identical, we fail fast.

I don't think that's worth the trouble.  If you want to change the
patches, re-run step 2.  Otherwise, just skip to step 3 or 4 (where the
patch argument just gets ignored).  Again, just a power tool for those
of us who are impatient ;-)

-- 
Josh

