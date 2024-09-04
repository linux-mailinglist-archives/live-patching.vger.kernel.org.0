Return-Path: <live-patching+bounces-574-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD6596AE72
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 04:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD7CBB21474
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 02:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E860D2EB1D;
	Wed,  4 Sep 2024 02:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib1luiq+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC656FBF0;
	Wed,  4 Sep 2024 02:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725415886; cv=none; b=V5DNaYpJTxSomCX6XNx7AyOCimJ7LLD2RU+F/yNSDpVtA2TFUYy96jJwaCNuW0acO7HOe9U+1Dm7Yxs5cenpGHbIjrkp+4U4QEpsndVBQL0Ru8/LE1V60i2QWtSzoxHsQm+ny5m6FHtFnSNLRWxxU4SV6wL+Z4osgxYzJ5keCfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725415886; c=relaxed/simple;
	bh=1xQ+7BUFWciBdVgi+nCuCW7fyZdp9QMyqAi9rHDi3zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umD6EpZPo+DCUAETReC3LbGVI6/mx1CiVCRco2FBF5idJMpyieGWyFEJwRVegRh3t+1EBQJwvxI78NuEkvFzgFLDd9WsCrxraAOmzUwjtl4Fr8AZPhAgGp6Dt6JNV67EgbmrLVbnZcMdrqjzzg3s3Ow7R4al3JWHTptDq0RE/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib1luiq+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E741EC4CEC4;
	Wed,  4 Sep 2024 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725415886;
	bh=1xQ+7BUFWciBdVgi+nCuCW7fyZdp9QMyqAi9rHDi3zE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ib1luiq+a9w0vZwxaLgw38hCThePUyiml3eNjRiZsVEj8fDMNBIA7Pa9mY6Nma8VV
	 CTZKmFV57fIPxt+hGXcshMEuYbxc3FhDVyqk3ssrLtJXw/wPnsIIq+WqlTvhry/uwc
	 qFMeJ1BE1jgT0CDV3/XGdj5QLsRWwO3ZWFUXnkqj4eRyHs8+prpFeoN+E/CQ4TBKUz
	 Hqw05Ps7GcPPUfZ/7DbEv0Db5puoIKiMIxFKhoUgynvR51VG6OC0x5YJvT9F3QyWIk
	 aK3t54FmgdaDzUvzzpj5PvVP16B3o5mJMNemU6nWWSGo0EdDMAX1/ievk6L0NYmwNg
	 fghYbckmfoStw==
Date: Tue, 3 Sep 2024 19:11:24 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 07/31] kbuild: Remove "kmod" prefix from __KBUILD_MODNAME
Message-ID: <20240904021124.tgzwu3ob37ibjja4@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d781bcac7ddd4563ed7849b5d644849760ad8109.1725334260.git.jpoimboe@kernel.org>
 <20240903075813.GM4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240903075813.GM4723@noisy.programming.kicks-ass.net>

On Tue, Sep 03, 2024 at 09:58:13AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 02, 2024 at 08:59:50PM -0700, Josh Poimboeuf wrote:
> > Remove the arbitrary "kmod" prefix from __KBUILD_MODNAME and add it back
> > manually in the __initcall_id() macro.
> > 
> > This makes it more consistent, now __KBUILD_MODNAME is just the
> > non-stringified version of KBUILD_MODNAME.  It will come in handy for
> > the upcoming "objtool klp diff".
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  include/linux/init.h | 3 ++-
> >  scripts/Makefile.lib | 2 +-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/init.h b/include/linux/init.h
> > index 58cef4c2e59a..b1921f4a7b7e 100644
> > --- a/include/linux/init.h
> > +++ b/include/linux/init.h
> > @@ -206,12 +206,13 @@ extern struct module __this_module;
> >  
> >  /* Format: <modname>__<counter>_<line>_<fn> */
> >  #define __initcall_id(fn)					\
> > +	__PASTE(kmod_,						\
> >  	__PASTE(__KBUILD_MODNAME,				\
> >  	__PASTE(__,						\
> >  	__PASTE(__COUNTER__,					\
> >  	__PASTE(_,						\
> >  	__PASTE(__LINE__,					\
> > -	__PASTE(_, fn))))))
> > +	__PASTE(_, fn)))))))
> 
> :-(

Yeah, I was just keeping the existing format here.

But actually, I strongly prefer it compared to this:

/* Format: <modname>__<counter>_<line>_<fn> */
#define __initcall_id(fn)						\
	__PASTE(kmod_,							\
		__PASTE(__KBUILD_MODNAME,				\
			__PASTE(__,					\
				__PASTE(__COUNTER__,			\
					__PASTE(_,			\
						__PASTE(__LINE__,	\
							__PASTE(_, fn)))))))

That gives headaches.  Sure, the vertically aligned version is a bit
unorthodox but it *much* easier to read if you know how to read it: just
scan down.

And the "Format:" comment at the top clarifies the result.

-- 
Josh

