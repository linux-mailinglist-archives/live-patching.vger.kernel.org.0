Return-Path: <live-patching+bounces-2500-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBC4Cqxz6mlAzgIAu9opvQ
	(envelope-from <live-patching+bounces-2500-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:31:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E15456D14
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98145300B77E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 19:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64DA3033C0;
	Thu, 23 Apr 2026 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFXZAaE5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35282BE053;
	Thu, 23 Apr 2026 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972702; cv=none; b=UvvPWpNskbwCGqy4+kM8qdhnol6tuuS6HeUTPfegvlNkKU7Dg16o12fBIfqM22Xm7VpfjI2YlENrN9xsx2KSBAd9Dta05O7RwZT4J0noPdjed0da7wgTGLPkaYrL0oGPaA2+IZW5LmOYtcKTxQRJIYK4SYNwSEonC/PkwAsgYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972702; c=relaxed/simple;
	bh=xblt8A6mf8bxDrLMshsrp4g9LviGZsRMmW4jT3FWtG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDRHFltMzXuNml18GzveT7yIakgeX8HQ/Eb9ayZAYeKR7pKaSOQuOin/tXMN76250NY5MHDoIy/dYppQ5i9d7vno6eD61KDAwRVqoZlO1/SUphrjMmeMJAV7XMmwletwLv13lkV8EFtEveagDkgUDerwsI5xwWKuSuCRXXG9P5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFXZAaE5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D682C2BCAF;
	Thu, 23 Apr 2026 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972702;
	bh=xblt8A6mf8bxDrLMshsrp4g9LviGZsRMmW4jT3FWtG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WFXZAaE5iHbEhHd/Qx2H79pAltub5JuUuS2WG24zYyI+ZlvusMs0wRJw4A7MW9wbi
	 eb+lTcOzta5NU1ATN4QjbfANKwya4+6AXoYpXVFMblh6C/3Gj7Ht8tbL0lqE8RSh77
	 t1UrW+DbOe1iqbtUgbfa+Q2unEUjnK2NZ4XGxRVVpDX3LNuERKAddGbC5EjePBiUYN
	 nR6sM+dHPN9ooGwMTxTLdIwtvaK1v/0T9YzbjYirdBzv4I4ValtVRum8FIeKqXxIax
	 GsdFUhENsvP+lJSt9192JQ0eVnaebSKQRLTDIyClD1sUElpE3M7isGrg0dWwfSnR50
	 WllTQBARiR5Ow==
Date: Thu, 23 Apr 2026 12:31:39 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 04/48] objtool/klp: Ignore __UNIQUE_ID_*() PCI stub
 functions
Message-ID: <gmjxp6lzlwjfdp4gf2nktoqfwrdx4bapf2mnnezo2gjyjj6yqf@if35zh3xa7t6>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-2500-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 97E15456D14
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 12:05:03PM -0700, Song Liu wrote:
> On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > With Clang LTO enabled, DECLARE_PCI_FIXUP_SECTION() uses __UNIQUE_ID()
> > to generate uniquely named wrapper functions, which are being reported
> > as new functions and unnecessarily included in the patch module:
> >
> >   vmlinux.o: new function: __UNIQUE_ID_quirk_f0_vpd_link_661
> >
> > These stub functions only exist to make the compiler happy.  Just ignore
> > them along with any other dont_correlate() symbols.  Note that
> > dont_correlate() already includes prefix functions.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> The actual change appears to be much bigger than the subject line.
> Maybe rephrase it a bit?

Hm, in fact this is a relic from a previous iteration of the patches: it
longer fixes what it claims to fix, as __UNIQUE_ID_ (other than
__ADDRESSABLE()) are now correlated.  The claimed issue actually gets
fixed later by the rewriting of the correlation algorithm.

That said, I still think the below is needed, I just need to rewrite the
commit log.

> 
> > ---
> >  tools/objtool/klp-diff.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> > index 36753eeba58c..ea9ccf8c4ea9 100644
> > --- a/tools/objtool/klp-diff.c
> > +++ b/tools/objtool/klp-diff.c
> > @@ -786,7 +786,7 @@ static int mark_changed_functions(struct elfs *e)
> >
> >         /* Find changed functions */
> >         for_each_sym(e->orig, sym_orig) {
> > -               if (!is_func_sym(sym_orig) || is_prefix_func(sym_orig))
> > +               if (!is_func_sym(sym_orig) || dont_correlate(sym_orig))
> >                         continue;
> >
> >                 patched_sym = sym_orig->twin;
> > @@ -802,7 +802,7 @@ static int mark_changed_functions(struct elfs *e)
> >
> >         /* Find added functions and print them */
> >         for_each_sym(e->patched, patched_sym) {
> > -               if (!is_func_sym(patched_sym) || is_prefix_func(patched_sym))
> > +               if (!is_func_sym(patched_sym) || dont_correlate(patched_sym))
> >                         continue;
> >
> >                 if (!patched_sym->twin) {
> > --
> > 2.53.0
> >

-- 
Josh

