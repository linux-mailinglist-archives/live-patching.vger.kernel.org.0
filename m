Return-Path: <live-patching+bounces-2616-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCsoCyVt82lf2gEAu9opvQ
	(envelope-from <live-patching+bounces-2616-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 16:54:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE31B4A44A3
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 16:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 407A03017C00
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 14:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9997942EECE;
	Thu, 30 Apr 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsQvX5my"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A213BA25C;
	Thu, 30 Apr 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777560806; cv=none; b=Pc0btyilswekxPgXV++hD7F+JsqCM9bfM+8Jlo7bOnrdZdRczuvAmbjrElMhp5/88z0oEF07uIsWUENKSg7S8IMZgtYw0UgGiONNeP1cUjPcraBxPrj4NOLl+xcwKuxvaE9fPvfuLGVqb8JXRrzw/zc3DgY/OAraqindEMcyaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777560806; c=relaxed/simple;
	bh=aabHYQnU0VgK38gZ78iM846QRJyUGNMNhhs5dafz8Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIOMiI2QXeWoyfWfX0X71QhsFZ4aTY8i8NHFa+nhgri4DatIKljoEO1fSglBARRtbA+DWabZK40dA0+Je4TJLFG14/kXKQL4llriVODvYrGGn9O0XZuu8eorPZa+t7usdoIlGZjEJ63i4tfChqAC0Kc1GK9bsm+eoiDFbO/cfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsQvX5my; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41975C2BCB3;
	Thu, 30 Apr 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777560806;
	bh=aabHYQnU0VgK38gZ78iM846QRJyUGNMNhhs5dafz8Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GsQvX5myc7YToZls9+nyOjZ9FCMquGG0x2LKr3jVqFu90y9pSKYfPUkU8rX2LfV/t
	 CV4m8hasAXErkBsDbQQjF9WuA+7hipumz4wSZaRaH7s40+NEcj/wowbN2MYEKt3JjQ
	 FX0W1ds2L2USeGvhhF0JpuDNqhODZTWAYp3gKyyrhCLQGkpPMOexS1D3pjv3+xE7PU
	 IWdUMVM6EiLaG/VWUfb31f++qTXM8pmyHVzHcbSGNB1jQ0P/yHMVReSx/PX0qwPiBU
	 2CBJjNUlWkn0JggcgDHOUCnKC+ye+kfX7sGTC9FtMsNkgD88cZnJgKY7b+TK4OrQ0i
	 oEFX7LehjNyGA==
Date: Thu, 30 Apr 2026 07:53:23 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
Message-ID: <z5njxpewtwl4m3drovmqykouqmwon3klnsvs6ypa63jym7t2ic@nonc2g73yvs3>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
 <abm7sbrlshe23ccholc5q67idnvuackxfy34thnpvyeiglafwe@cdtxtdi3zenv>
 <CAPhsuW5H47o59-Np_Uj1xP5V5wFj7KeVEaiDUoTGki=uxrbGDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW5H47o59-Np_Uj1xP5V5wFj7KeVEaiDUoTGki=uxrbGDQ@mail.gmail.com>
X-Rspamd-Queue-Id: BE31B4A44A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2616-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

On Tue, Apr 28, 2026 at 09:50:46PM +0100, Song Liu wrote:
> On Tue, Apr 28, 2026 at 5:23 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> [...]
> > > Also a few nitpicks below.
> > >
> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > > ---
> > > [...]
> > > > +static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
> > > > +{
> > > > +       struct symbol *name_last = NULL, *scope_last = NULL,
> > > > +                     *file_last = NULL, *csum_last = NULL;
> > > > +       unsigned int name_orig = 0, name_patched = 0;
> > > > +       unsigned int scope_orig = 0, scope_patched = 0;
> > > > +       unsigned int file_orig = 0, file_patched = 0;
> > > > +       unsigned int csum_orig = 0, csum_patched = 0;
> > > > +       struct symbol *sym2, *match = NULL;
> > > > +
> > > > +       /* Count orig candidates */
> > > > +       for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
> > > > +               if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
> > > > +                   (!maybe_same_file(sym1, sym2)))
> > > >                         continue;
> > > >
> > > > -               count++;
> > > > -               result = sym2;
> > > > +               /* Level 1: name match (widest filter)  */
> > > > +               name_orig++;
> > > > +
> > > > +               /* Level 2: scope (scope changes allowed) */
> > > > +               if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2))
> > >
> > > is_tu_local_sym(sym1) is called many times, shall we add a variable
> > > for it?
> >
> > Unless it's actually a performance issue I'd prefer not to add yet
> > another bit to struct symbol.
> 
> We don't need to add it to struct symbol, a local variable for sym1
> will be good. No need for sym2.
> 
> IOW, we have something like
> 
> bool sym1_is_local = is_tu_local_sym(sym1);
> ...
> if (sym1_is_local != is_tu_local_sym(sym2))

I'd rather keep it the way it is for readability, the compiler should be
able to recognize the sym1 value doesn't change and calculate its value
once.

-- 
Josh

