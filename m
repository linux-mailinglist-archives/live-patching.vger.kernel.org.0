Return-Path: <live-patching+bounces-2586-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IM1jJwni8GmoagEAu9opvQ
	(envelope-from <live-patching+bounces-2586-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:36:25 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 43282489112
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1998E30F5AA0
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4484439007;
	Tue, 28 Apr 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqRCq667"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8136F33A029;
	Tue, 28 Apr 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393150; cv=none; b=jIq9NqPD1PwDI15X3H2KJZ3VTTtxoUoOUnqLGrv8xaLuaO0CvrwA1KSvkdzbUXtggikwg09xw597AEDlUi45YwyrdEDZhFrbU4YW4gqFPfZdfpxjaqeY/G2mQFhc720BKDVx2sWigFMF3mdkv4DtPlo1F8CppuJNx3cyNgmEI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393150; c=relaxed/simple;
	bh=sqS5KPFM8Htw+ohlhNlX8lNtmWTxrvAeFxBvKeKMjjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUvFqirn1YNfcp2cVp95QPgDEZhHmEcPIArMZBWQDUbDb03dLylU9xahOi4U1N0+BgXA3d3FIPaEyjgpdSE2+RjhnSMIJa9EoKy3m4Nood8QxyVwciSTnbSmCmtdQ5LCVcJPzKS4yR/gPrzQIkHeMTWOyQcstVtjgnXCGSd4d+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqRCq667; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2B0C2BCAF;
	Tue, 28 Apr 2026 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393150;
	bh=sqS5KPFM8Htw+ohlhNlX8lNtmWTxrvAeFxBvKeKMjjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VqRCq667jm8mzqN8VDptwJ28WdGqQc0WEUVqfnJgucWhWZ+UULc4+klegemB4EIqE
	 +xP6srZSxjosvah/GzlMauAXWW2R/j6QNAXL6h6N/Avi4jVXWoFTidBFfay8gwVAdn
	 wGJK3EIvj/3Gw39LzeAcU7NOW/5KlrE6Bc+ma+xFjt9L7q91vr/up27/qxOWTBXZ93
	 eZv97BpvyWgfZvsBaRzJ7mMa+/53M6nEOcD3JRZ8syTNtUDDKd9MPW0PfxS06oAmHo
	 5LP7+18Pyp4G3OjltYvbjKnHmnEGqeqfEMmOBrdRZeTt7Vx/X2nvdkdjlznRNRpRaE
	 0uNEfA9Gz2UEQ==
Date: Tue, 28 Apr 2026 09:19:07 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 38/48] klp-build: Validate short-circuit prerequisites
Message-ID: <jygegcn3d4efw2xtnl7z4uo7zx4ghzvuv3ref3yxuvccy7ohcc@aunjpiemzmxm>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <338295e0bf3353dd62536df672a2615f72be013b.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW66Mx6RU9NT4nyk7GuN-0Kve6P7YdnM-ke3D2Cx0o0_Kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW66Mx6RU9NT4nyk7GuN-0Kve6P7YdnM-ke3D2Cx0o0_Kw@mail.gmail.com>
X-Rspamd-Queue-Id: 43282489112
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2586-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, Apr 24, 2026 at 05:06:43PM -0700, Song Liu wrote:
> On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > The --short-circuit option implicitly requires that certain directories
> > are already in klp-tmp.  Enforce that to prevent confusing errors.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  scripts/livepatch/klp-build | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index eda690b297cc..b44924d097a5 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -440,6 +440,20 @@ do_init() {
> >         [[ ! "$SRC" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
> >         [[ ! "$OBJ" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
> >
> > +       if (( SHORT_CIRCUIT >= 2 )); then
> > +               [[ -f "$ORIG_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_DIR"
> > +               if (( SHORT_CIRCUIT >= 3 )); then
> > +                       [[ -f "$PATCHED_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_DIR"
> > +                       if (( SHORT_CIRCUIT >= 4 )); then
> > +                               [[ -f "$ORIG_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_CSUM_DIR"
> > +                               [[ -f "$PATCHED_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_CSUM_DIR"
> > +                               if (( SHORT_CIRCUIT >= 5 )); then
> > +                                       [[ -f "$DIFF_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
> > +                               fi
> > +                       fi
> > +               fi
> > +       fi
> > +
> 
> Do we really need these to nest together?

Hm, I suppose flattening is a little less offensive to the eye:


	if (( SHORT_CIRCUIT >= 2 )); then
		[[ -f "$ORIG_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_DIR"
	fi
	if (( SHORT_CIRCUIT >= 3 )); then
		[[ -f "$PATCHED_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_DIR"
	fi
	if (( SHORT_CIRCUIT >= 4 )); then
		[[ -f "$ORIG_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_CSUM_DIR"
		[[ -f "$PATCHED_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_CSUM_DIR"
	fi
	if (( SHORT_CIRCUIT >= 5 )); then
		[[ -f "$DIFF_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
	fi
-- 
Josh

