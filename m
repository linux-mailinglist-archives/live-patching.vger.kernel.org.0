Return-Path: <live-patching+bounces-587-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A87F96B38F
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE9841F24085
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FEE1547EB;
	Wed,  4 Sep 2024 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PSAF30T1"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E7FC12;
	Wed,  4 Sep 2024 07:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725436401; cv=none; b=ZTJ8YC65fVKMoL6ijoVMddHM5DAnyFouRgMpgIbtaL1hcNR8WHCpF+dIPJjGBeVa3BuFGX52h31MdT/ueXpBU1JrnghexkLVvMbKNkLGcDhn0evTnb6dlZBU4LO5lj0AzB4HZmqrYrqGTXTum5Aiii8CHI5/39e0zrv1bjval/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725436401; c=relaxed/simple;
	bh=/xAKm5UKzMTbbYVOSWXVBmyYpYA9sihdEbzsl/IXnmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTEOKJiJ0GG08w6rVTcevhC1ZrzWs23HGy3R4GL7aMfwIIfQOkHshgvXMic+K3uAw740BwtC0wq/jj4AOZL++k6UgRmQ0JQXs1HzthXCJllS2HsAus1zKThOAPJfZ7x+prbqIFiEAVcT8jMusKGdzkWcNQ3unLtE5tVOhsZUwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PSAF30T1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y2m2XSa0eMafOcEahfOdCWs/9WntdPeN4Fcyu8FOAK8=; b=PSAF30T10WkjcEapl3XsAOK1ox
	6UYBCuCEEJOkd1PoQSqCproPM/WEHEKohL6Iz3pqVXZZBaZZytxLjMMMZ91N7KK/h4Ca5DNW0uv/Y
	JZJ/qwU53DMtUW6qgpj5VhqakBiTOvhUHTzSyO8d+jRYW5pIHqkheqPCTpXzKBeBA2gU5Ij2PGxWX
	fvGIKVZlz88dcZhdxj4ZMSExH6rYhY/ewazXT7/mmCDkCTkN9X85QCqRbogZkjOpDJfyT1Xbwpw62
	zh8md3OaCffUB8lasiYZH/qjr3lkkR58RZHye7iAY4/+EwABVIfJN12q3fUhUpU1oXKFAM7NT1frh
	/jFsUXeg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1slkpH-00000000Wol-1nnm;
	Wed, 04 Sep 2024 07:53:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 94EE4300642; Wed,  4 Sep 2024 09:53:15 +0200 (CEST)
Date: Wed, 4 Sep 2024 09:53:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 07/31] kbuild: Remove "kmod" prefix from __KBUILD_MODNAME
Message-ID: <20240904075315.GC4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d781bcac7ddd4563ed7849b5d644849760ad8109.1725334260.git.jpoimboe@kernel.org>
 <20240903075813.GM4723@noisy.programming.kicks-ass.net>
 <20240904021124.tgzwu3ob37ibjja4@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904021124.tgzwu3ob37ibjja4@treble>

On Tue, Sep 03, 2024 at 07:11:24PM -0700, Josh Poimboeuf wrote:
> On Tue, Sep 03, 2024 at 09:58:13AM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 02, 2024 at 08:59:50PM -0700, Josh Poimboeuf wrote:
> > > Remove the arbitrary "kmod" prefix from __KBUILD_MODNAME and add it back
> > > manually in the __initcall_id() macro.
> > > 
> > > This makes it more consistent, now __KBUILD_MODNAME is just the
> > > non-stringified version of KBUILD_MODNAME.  It will come in handy for
> > > the upcoming "objtool klp diff".
> > > 
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > >  include/linux/init.h | 3 ++-
> > >  scripts/Makefile.lib | 2 +-
> > >  2 files changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/init.h b/include/linux/init.h
> > > index 58cef4c2e59a..b1921f4a7b7e 100644
> > > --- a/include/linux/init.h
> > > +++ b/include/linux/init.h
> > > @@ -206,12 +206,13 @@ extern struct module __this_module;
> > >  
> > >  /* Format: <modname>__<counter>_<line>_<fn> */
> > >  #define __initcall_id(fn)					\
> > > +	__PASTE(kmod_,						\
> > >  	__PASTE(__KBUILD_MODNAME,				\
> > >  	__PASTE(__,						\
> > >  	__PASTE(__COUNTER__,					\
> > >  	__PASTE(_,						\
> > >  	__PASTE(__LINE__,					\
> > > -	__PASTE(_, fn))))))
> > > +	__PASTE(_, fn)))))))
> > 
> > :-(
> 
> Yeah, I was just keeping the existing format here.
> 
> But actually, I strongly prefer it compared to this:
> 
> /* Format: <modname>__<counter>_<line>_<fn> */
> #define __initcall_id(fn)						\
> 	__PASTE(kmod_,							\
> 		__PASTE(__KBUILD_MODNAME,				\
> 			__PASTE(__,					\
> 				__PASTE(__COUNTER__,			\
> 					__PASTE(_,			\
> 						__PASTE(__LINE__,	\
> 							__PASTE(_, fn)))))))
> 
> That gives headaches.  Sure, the vertically aligned version is a bit
> unorthodox but it *much* easier to read if you know how to read it: just
> scan down.
> 
> And the "Format:" comment at the top clarifies the result.

Yeah, I suppose you're right.

