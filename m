Return-Path: <live-patching+bounces-2234-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPjkAbBIu2kliQIAu9opvQ
	(envelope-from <live-patching+bounces-2234-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 01:52:00 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEA52C436E
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 01:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB6E530EFA04
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 00:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF632253340;
	Thu, 19 Mar 2026 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUqznDJA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65D1F3D56;
	Thu, 19 Mar 2026 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773881370; cv=none; b=GPfyFUF8IuTjNXON78RmZ0nZAP4uoj6y6PnEotnQHw3X2bEgZgOHyC0qsPbTP2Vkb/x6OkU3JgQv1UdhRx4r+DyUZ5Ek37nw/GRSsr7qt8clv92mCKOVDH0PvyOF9PgWcP/sKjYmCTT2uoOP1a0czemC7VU3aaq95DVGkNfYD4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773881370; c=relaxed/simple;
	bh=ojPX7kAcg1fQ+0xujOOgF0QYzwR67rBBwSvbHwYLXUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQwb6gIwr6zw90XDHbf6HeG8LKNlKkEs3pC3NBI1TXAK+0ypxLp+244c3BsawRXnTggquH9sI7BK6O7xynwOZ3McbXYkbfl81X/5TrrSYkEy3znhJ8U9pxPmf+RDAZNfMrXphyYoPprzpaTwKoZaeBB/oorm1UMfoxH+oU8XAMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUqznDJA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71265C2BC87;
	Thu, 19 Mar 2026 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773881370;
	bh=ojPX7kAcg1fQ+0xujOOgF0QYzwR67rBBwSvbHwYLXUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IUqznDJAB/qRHaqLzniXe1UptuuD9+YjvODekdWxrFDYZVmQ4lagksvCEK7wec7TO
	 TPUHTa2ED1DRKp/z3df4AEP6bTTlBs1ULM13USL20ShsiGgGb/QwHFMunmEEGGlcO2
	 95cuJhilFyjOsU9jzsqLOz1Kz3p4c3z+JbT5ixyE9ZSrrnDspU2skwBtR2U7RRErG2
	 5ZRGqjHxTPY60cJ+rhWIEH2PAFxU6anp4lOyISVWtEtzWjXFbQbo4/W+MKu295mBUV
	 oYR+dgWScJbfS1X8Ld2jcUzF95O619RM+CNRvNPCJVj4OZkKe/VY5GEm1BwikchpWs
	 QXlpfeyAugd+w==
Date: Wed, 18 Mar 2026 17:49:27 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 07/12] kbuild: Only run objtool if there is at least
 one command
Message-ID: <zdipyf26t2gos5dw2gjyzmeg2zm5a67xwr5ozubnhmhllrwgnm@ezdt54coe2bk>
References: <cover.1773787568.git.jpoimboe@kernel.org>
 <42418c5fa73a8876e91b3dfb38fa3f263e39f1c1.1773787568.git.jpoimboe@kernel.org>
 <absC93h6fNgyniD4@derry.ads.avm.de>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <absC93h6fNgyniD4@derry.ads.avm.de>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2234-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5CEA52C436E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 18, 2026 at 08:54:31PM +0100, Nicolas Schier wrote:
> On Tue, Mar 17, 2026 at 03:51:07PM -0700, Josh Poimboeuf wrote:
> > Split the objtool args into commands and options, such that if no
> > commands have been enabled, objtool doesn't run.
> > 
> > This is in preparation in enabling objtool and klp-build for arm64.
> > 
> > Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  arch/x86/boot/startup/Makefile |  2 +-
> >  scripts/Makefile.build         |  4 +--
> >  scripts/Makefile.lib           | 46 ++++++++++++++++++----------------
> >  scripts/Makefile.vmlinux_o     | 15 ++++-------
> >  4 files changed, 33 insertions(+), 34 deletions(-)
> > 
> [...]
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 3652b85be545..8a1bdfdb2fdb 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -277,7 +277,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
> >  is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
> >  
> >  ifdef CONFIG_OBJTOOL
> > -$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
> > +$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y)))
> 
> Please use $(and a,b,c) instead of multiple nested $(if $(a),$(if
> $(b),$(c)); as the last variable (is-single-obj-m) is 'y' or empty, the final 'y' can be
> left-out:
> 
> $(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(delay-objtool),$(is-single-obj-m))

I believe that would break the !delay-objtool case.  The logic needs to
be something like:

if (is-standard-object && objtool-cmds-y) {
	if (delay-objtool) {
		// for delay-objtool, only enable objtool for single-object modules
		$(is-single-obj-m)
	} else {
		// for !delay-objtool, always enable objtool
		y
	}
}

so maybe something like this?

$(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y))

-- 
Josh

