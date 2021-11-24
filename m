Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D472945B7F7
	for <lists+live-patching@lfdr.de>; Wed, 24 Nov 2021 11:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhKXKFN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Nov 2021 05:05:13 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33444 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhKXKFM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Nov 2021 05:05:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A4B782193C;
        Wed, 24 Nov 2021 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637748122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZroNNLzxo+RSwP/LAfLapLujiRFHUBN+dcokUEUdb0=;
        b=cCRQjvPbzsP6g91XmrTrYSjjH0E0LUJoPiWPUCMI1ZfFvXIrdbaLW9jipVQ6R59rs48Fa4
        Plv+XbTKuUiDL4ld/Xo97FdJwrGsC6oRctXcZftTacK22bABd0ovF/pZcI4CzTomVb6oit
        uYb+SCefe7HTtGAmvKUGBc7YaA90O60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637748122;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZroNNLzxo+RSwP/LAfLapLujiRFHUBN+dcokUEUdb0=;
        b=bx4SbyNEFlr/uzt9LVMfPNHMgz2HUM4XS/Y61MzsH1sxiaAvP2ZD2Be3u3VEzS8bjQgkSK
        QsvC6foJaWD7rsDg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 48BD6A3B81;
        Wed, 24 Nov 2021 10:02:02 +0000 (UTC)
Date:   Wed, 24 Nov 2021 11:02:02 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Steven Rostedt <rostedt@goodmis.org>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
In-Reply-To: <20211123204039.GC721624@worktop.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.2111241058340.19554@pobox.suse.cz>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com> <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz> <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz> <20211123110320.75990e0b@gandalf.local.home>
 <20211123204039.GC721624@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 23 Nov 2021, Peter Zijlstra wrote:

> On Tue, Nov 23, 2021 at 11:03:20AM -0500, Steven Rostedt wrote:
> > On Tue, 23 Nov 2021 12:39:15 +0100 (CET)
> > Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> > > +++ b/kernel/livepatch/patch.c
> > > @@ -127,15 +127,18 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> > >  /*
> > >   * Convert a function address into the appropriate ftrace location.
> > >   *
> > > - * Usually this is just the address of the function, but on some architectures
> > > - * it's more complicated so allow them to provide a custom behaviour.
> > > + * Usually this is just the address of the function, but there are some
> > > + * exceptions.
> > > + *
> > > + *   * PPC - live patch works only with -mprofile-kernel. In this case,
> > > + *     the ftrace location is always within the first 16 bytes.
> > > + *   * x86_64 with CET/IBT enabled - there is ENDBR instruction at +0 offset.
> > > + *     __fentry__ follows it.
> > >   */
> > > -#ifndef klp_get_ftrace_location
> > > -static unsigned long klp_get_ftrace_location(unsigned long faddr)
> > > +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
> > 
> > Why make this the default function? It should only do this for powerpc and
> > x86 *if* CET/IBT is enabled.

I thought that given it was a slow path anyway, it would be just nice to 
get rid of the special casing. We support only x86, powerpc and s390x 
after all.

And as Peter later pointed out, it would have the benefit to have a check 
even for default version.
 
> Well, only this variant of IBT. Once Joao gets his clang patches
> together we'll probably have it back at +0.
> 
> Something like the below would be more robust, it also gets us something
> grep-able for when the IBT code-gen changes yet again.
> 
> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> index 7c5cc6660e4b..4e683a1aa411 100644
> --- a/arch/x86/include/asm/livepatch.h
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -17,4 +17,13 @@ static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  	ftrace_instruction_pointer_set(fregs, ip);
>  }
>  
> +#define klp_get_ftrace_location klp_get_ftrace_location
> +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
> +{
> +	unsigned long addr = faddr_location(faddr);
> +	if (!addr && IS_ENABLED(CONFIG_X86_IBT))
> +		addr = faddr_location(faddr + 4);
> +	return addr;
> +}
> +
>  #endif /* _ASM_X86_LIVEPATCH_H */
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index fe316c021d73..fd295bbbcbc7 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -133,7 +133,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  #ifndef klp_get_ftrace_location
>  static unsigned long klp_get_ftrace_location(unsigned long faddr)
>  {
> -	return faddr;
> +	return ftrace_location(faddr);
>  }
>  #endif

Yes, this looks nice.

Thanks

Miroslav
