Return-Path: <live-patching+bounces-2216-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGa0Ij+YuWkJKwIAu9opvQ
	(envelope-from <live-patching+bounces-2216-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:06:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6D32B09C0
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2F34B3066935
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 17:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF5837B002;
	Tue, 17 Mar 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQo/LiJ1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A7A332628;
	Tue, 17 Mar 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769950; cv=none; b=sx65sL2pZ8NHgxI2oPYVBvT9WIoJF6FPwA5lqedqYe5UdyPdkgl6m6TqzDOulF263OrxIJPPT+VdIKJpCM8o3OxoulNPFThYH+CLaanwvXtxI1jsmyvhn+XpMx1NjgP7bL8gaQiHoqZUMZSV/kyCcl1sB+1uvXzE1IVrl74i9No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769950; c=relaxed/simple;
	bh=vnGr8s5RTA6GtfpXH520e+NXEN9z4J7oZSX4YLudI8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aw3RI9Njq/IiDR+5bJi/S4Zu5vkWqXA0rJEoz2vIz5C7HB5Av4HXXcI2gLBWbuJkDdOuRlaWL70rfGm2h2KIHJeEk9EXYQjAwP+ra4fIkjRKo6EUw1SqQuhg7+whV+YEcj/cXuZsfXn7QCPiqDcWWs5VnCIsGsRxP+NxJZV2Y/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQo/LiJ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5666DC4CEF7;
	Tue, 17 Mar 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773769950;
	bh=vnGr8s5RTA6GtfpXH520e+NXEN9z4J7oZSX4YLudI8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CQo/LiJ1zwJxaV+OLsDgcEqYRC4C4LsYLNRqCnIzfrMHc24K+e7hJlnutkptnS7IV
	 LZTFUs9XKCIaLUCmkX5YjQtJwYwrI8GvS3u3rFgsWVHS55fp4bOZ+SpMDL7swWCaL8
	 DDOJA0f8Ux7H0pZIhCEVLB+/6hGKNll0xMc/RJxCg3GL+NuHtr0Mm28xosXhkqLJ9w
	 nWP6LQLT8l2zXi4qXQB9I5WO+uc7+FKSndUX0XLHz1Pciie2cItRPDkiSGNd8RmtoZ
	 ZyzaikxyF2r2prfhp57lrYHdpr9JzHv8acOjJpNglZ0LTwn1izucqYKwRqXIUjyNUe
	 Ta6uKA4i6QbMg==
Date: Tue, 17 Mar 2026 10:52:27 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 14/14] klp-build: Support cross-compilation
Message-ID: <e2yxamlxwif5kxur7thr4x7yp7ppbde6awzm6vomdfkg6auxeq@aaahh3aclf2e>
References: <cover.1772681234.git.jpoimboe@kernel.org>
 <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
 <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
 <xzezfjfb5uttvmg2divzk3toym3qqvkh5c4w2enamsrku342m3@bogfmdj65wql>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xzezfjfb5uttvmg2divzk3toym3qqvkh5c4w2enamsrku342m3@bogfmdj65wql>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2216-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E6D32B09C0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 16, 2026 at 12:15:28PM -0700, Josh Poimboeuf wrote:
> On Wed, Mar 11, 2026 at 04:18:40PM -0700, Song Liu wrote:
> > On Wed, Mar 4, 2026 at 7:32 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > Add support for cross-compilation.  The user must export ARCH, and
> > > either CROSS_COMPILE or LLVM.
> > >
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > >  scripts/livepatch/klp-build | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > > index 809e198a561d..b6c057e2120f 100755
> > > --- a/scripts/livepatch/klp-build
> > > +++ b/scripts/livepatch/klp-build
> > > @@ -404,6 +404,14 @@ validate_patches() {
> > >         revert_patches
> > >  }
> > >
> > > +cross_compile_init() {
> > > +       if [[ -v LLVM ]]; then
> > > +               OBJCOPY=llvm-objcopy
> > > +       else
> > > +               OBJCOPY="${CROSS_COMPILE:-}objcopy"
> > > +       fi
> > > +}
> > 
> > Shall we show a specific warning if
> >   - ARCH is set; and
> >   - ARCH is not the same as (uname -m); and
> >   - neither LLVM nor CROSS_COMPILE is set.
> 
> Yeah, I think that would be a good idea.  Will do that for v2.

So, in general ARCH is complicated.  For example:

 - ARCH=arm64 would never match "uname -m" (aarch64)
 - ARCH=i386 would use the same gcc binary (no cross-compiler needed)
 - I'm sure there are many other edge cases...

Instead of a manual error, it may be simpler to just let the build fail
naturally if the user doesn't set the right ARCH.

Though, I think the check can be improved slightly, as ARCH is a
reasonably good indicator that cross-compiling is happening.  So I can
at least add an ARCH check at the beginning like so?

cross_compile_init() {
	if [[ ! -v ARCH ]]; then
		OBJCOPY=objcopy
		return 0
	fi

	if [[ -v LLVM ]]; then
		OBJCOPY=llvm-objcopy
	else
		OBJCOPY="${CROSS_COMPILE:-}objcopy"
	fi
}

-- 
Josh

