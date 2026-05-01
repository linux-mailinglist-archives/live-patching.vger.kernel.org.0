Return-Path: <live-patching+bounces-2690-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPJQABrd9GmfFQIAu9opvQ
	(envelope-from <live-patching+bounces-2690-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 19:04:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E51724AE47F
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 19:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D514930028CB
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 17:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F5A3019DC;
	Fri,  1 May 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFYlO83p"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9959463;
	Fri,  1 May 2026 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777655059; cv=none; b=j06gNnxd3TXIfKQUvGxxVZVBjp+B11qC0W/PefvKbaClKVf7sIsFI77uZPsVEZanSMOQBJehYxrNvnUjvty1tYDCDuRsFTTsdfRWfRGP2yYegIhtQAizMfvAIh5r20LqdO2W6LIuewGF7XEjC44oLfs8hnUIbNpgkgDhPVuo2eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777655059; c=relaxed/simple;
	bh=iGBXVlGLQPzGSgQE1Rx5wjqZqpDlwNH5pH0ZMvYx7Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2VL4fl9pwvSjpLSTg1xCBbliirL7BP8MlvsnCdea0JZpt7hl2jis4vSC0hME4blfFuKQTvwVaZJ/uf89hcdMZgAKJt6IwK4cNNH+kBMNmuqlq10uSeOYK9w6GaeoYPOSfJQQSOHrMQPdqmyjv078ZdIXZ/cO9oPrCriqhRjHTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFYlO83p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64CAC2BCB4;
	Fri,  1 May 2026 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777655058;
	bh=iGBXVlGLQPzGSgQE1Rx5wjqZqpDlwNH5pH0ZMvYx7Zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GFYlO83pnPS5sjkAU+4GI2XuWhI6FeA4lJHP70RvnN3pEmYft5dS6rjoJbo57V82z
	 zs+QmwCb/0ie6xBPUEBy/7cmueBGHM8pH9t1hxzp2RehauRnc+gbtaZSTEIqZ/a/Rg
	 brNR6UINAWM8eJHgs8P/fP0Hjx/Zf/0sXO6TFJr5154aHZlAI0Mg6zxMWgjILFYA1A
	 Ujf69yzkAF2Pez7Ty5XFXZP+FuCUhjCkYBulVS2owBNXhekhAKIOdFrF8E+GUMZxSH
	 wcQSj3X6xtdJZPWA9ZvNOQGyYMYIwKlINXOn8wDKlBROb9dSUgBTzRlgBV/LUfsxgF
	 JEMUNOVTme60A==
Date: Fri, 1 May 2026 10:04:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 20/53] objtool/klp: Don't correlate .rodata.cst*
 constant pool objects
Message-ID: <yd3becobjg77p7yylqqgmrdznkejvwbdzojzxk5lqlsihp4377@d6yfaqstriec>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <80d6f8df4db610a6c9f68031dc0153f04814f2fa.1777575752.git.jpoimboe@kernel.org>
 <CAPhsuW7wAG1MEb2xVxFLN2V_BG4KddhKRXaL9LPxWEP2DUFAJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW7wAG1MEb2xVxFLN2V_BG4KddhKRXaL9LPxWEP2DUFAJQ@mail.gmail.com>
X-Rspamd-Queue-Id: E51724AE47F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2690-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Fri, May 01, 2026 at 11:37:49AM +0100, Song Liu wrote:
> > +/*
> > + * Some .rodata is anonymous and can't be correlated due to there being no
> > + * symbol names.
> > + *
> > + * The .rodata.cst* sections aren't technically anonymous, they're SHF_MERGE
> > + * constant pool sections containing small fixed-size data (lookup tables,
> > + * bitmasks) which are only read by value, so pointer equivalence isn't needed.
> > + * They are typically referenced by UBSAN data sections.
> > + */
> > +static bool is_anonymous_rodata(struct symbol *sym)
> > +{
> > +       return is_rodata_sec(sym->sec) &&
> > +              (!is_object_sym(sym) || strstarts(sym->sec->name, ".rodata.cst"));
> > +}
> > +
> >  /*
> >   * These symbols should never be correlated, so their local patched versions
> >   * are used instead of linking to the originals.
> > @@ -386,7 +401,7 @@ static bool dont_correlate(struct symbol *sym)
> >                is_uncorrelated_static_local(sym) ||
> >                is_local_label(sym) ||
> >                is_string_sec(sym->sec) ||
> > -              (is_rodata_sec(sym->sec) && !is_object_sym(sym)) ||
> ^^^^
> This line was added in 19/53. Maybe we can merge 19 and 20?

I think I'd prefer to keep them separate as they are two distinct issues
related to rodata: pointer equivalence (patch 19) and UBSAN mergeable
constants (patch 20).

-- 
Josh

