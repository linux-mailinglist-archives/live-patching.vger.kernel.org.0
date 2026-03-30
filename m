Return-Path: <live-patching+bounces-2269-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mH3UAbzcymkQAwYAu9opvQ
	(envelope-from <live-patching+bounces-2269-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 22:27:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 745FD360F33
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 22:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F2823017FB6
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 20:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539863806D2;
	Mon, 30 Mar 2026 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMacDWh5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDBC2BE7DC;
	Mon, 30 Mar 2026 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774902455; cv=none; b=GZRKyZG0lvWcYDnqoObsSyee4L1/joWGb/M2my9ZY/E69Dj/Gb5315Jz9KT9VTB4AMQCw5GFiuHHlhReEmvcygLA57pb7ZxTdPPCujmTWCTZnQg+kEIHJCDc/ZT2ypjCR8m85w1k20/87lGJ33/W+l7BUslMjInYsNhyGDJeAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774902455; c=relaxed/simple;
	bh=g+gwsR+gNrNm22Hp+EF93Bvvi9OTcgbAaxyzqRzDwLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSIvDcsbEwnYyNhSXkFK8jkDgI4mbU+1bCAwLOh1V79p9d7AMGjgEB0TuFeaFuPKQT/40csUeHunnw3xixpltiJ2IL/GEsLXgmxeh3jv3JFABkvXrUYIwPFywSvNecAy/gIJLlZxkxjRmPE978YL7xzNGRbd5Gw4k1k0hxNaLFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMacDWh5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CDDC4CEF7;
	Mon, 30 Mar 2026 20:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774902454;
	bh=g+gwsR+gNrNm22Hp+EF93Bvvi9OTcgbAaxyzqRzDwLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EMacDWh57ISefa8yBdpmiZ6lgzX1NTVvuvP6ITKNfuPWEiwh9eGPoLwcfrLMehPI9
	 Vz/xrAn03fVZc8uabw9zlPDGpgk+4FKfDVOc+Bw+88JEmM87JjWYwxTdc20AUemzWs
	 NsBGQPscOB4otw2Ul6ElWnVRvnNjL6Lsq04SY/LvuIB5lwrh9D53nW0LQEyD0xHaGe
	 nSs2GAKe5ZfP9L2sfEzgYYho8vXVYiR0b97bgufZyv87QNCfg6n4ozoH2q2e51mW+m
	 Dz3K/lzFkEbSSLsbf40rpi4vfqP6EIBjvoblp3yK/tHyn6X4YSl7pNdIF/IPJXmEfE
	 o6THgOpNDYqhA==
Date: Mon, 30 Mar 2026 20:49:20 +0200
From: Nicolas Schier <nsc@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 07/12] kbuild: Only run objtool if there is at least
 one command
Message-ID: <acrFsFFBVOzPYl_C@levanger>
References: <cover.1773787568.git.jpoimboe@kernel.org>
 <42418c5fa73a8876e91b3dfb38fa3f263e39f1c1.1773787568.git.jpoimboe@kernel.org>
 <absC93h6fNgyniD4@derry.ads.avm.de>
 <zdipyf26t2gos5dw2gjyzmeg2zm5a67xwr5ozubnhmhllrwgnm@ezdt54coe2bk>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zdipyf26t2gos5dw2gjyzmeg2zm5a67xwr5ozubnhmhllrwgnm@ezdt54coe2bk>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2269-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nsc@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 745FD360F33
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 18, 2026 at 05:49:27PM -0700, Josh Poimboeuf wrote:
> On Wed, Mar 18, 2026 at 08:54:31PM +0100, Nicolas Schier wrote:
> > On Tue, Mar 17, 2026 at 03:51:07PM -0700, Josh Poimboeuf wrote:
> > > Split the objtool args into commands and options, such that if no
> > > commands have been enabled, objtool doesn't run.
> > > 
> > > This is in preparation in enabling objtool and klp-build for arm64.
> > > 
> > > Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> > > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > >  arch/x86/boot/startup/Makefile |  2 +-
> > >  scripts/Makefile.build         |  4 +--
> > >  scripts/Makefile.lib           | 46 ++++++++++++++++++----------------
> > >  scripts/Makefile.vmlinux_o     | 15 ++++-------
> > >  4 files changed, 33 insertions(+), 34 deletions(-)
> > > 
> > [...]
> > > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > > index 3652b85be545..8a1bdfdb2fdb 100644
> > > --- a/scripts/Makefile.build
> > > +++ b/scripts/Makefile.build
> > > @@ -277,7 +277,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
> > >  is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
> > >  
> > >  ifdef CONFIG_OBJTOOL
> > > -$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
> > > +$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y)))
> > 
> > Please use $(and a,b,c) instead of multiple nested $(if $(a),$(if
> > $(b),$(c)); as the last variable (is-single-obj-m) is 'y' or empty, the final 'y' can be
> > left-out:
> > 
> > $(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(delay-objtool),$(is-single-obj-m))
> 
> I believe that would break the !delay-objtool case.  The logic needs to
> be something like:
> 
> if (is-standard-object && objtool-cmds-y) {
> 	if (delay-objtool) {
> 		// for delay-objtool, only enable objtool for single-object modules
> 		$(is-single-obj-m)
> 	} else {
> 		// for !delay-objtool, always enable objtool
> 		y
> 	}
> }
> 
> so maybe something like this?
> 
> $(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y))

sorry for the delay!  Yes, I overlooked the !delay-objtool.  That line
looks good to me, thanks!


-- 
Nicolas

