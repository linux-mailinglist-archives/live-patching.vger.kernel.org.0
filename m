Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3727A45A4C7
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbhKWOOH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 09:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237539AbhKWOOE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 09:14:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF85C061714
        for <live-patching@vger.kernel.org>; Tue, 23 Nov 2021 06:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aBbGOlFSI3pTN1smXAls9OGsIIb85iRdJsqBoMIcYO8=; b=kwrBtYk+g92hpagGqSzuYhnGqa
        r2g69+ilD9fgqI/Cf+GO7o0v3IOpXnxnqke5ytuugdozM8t3uloEA/sGvrjFfcZ2fj5o3YMoblZdK
        hlzsX4sXEMWmrG/ayZhRBzFovy4HY+jWCbxV0LW+HcM7/IypXuO2Xqu5NLm0XH7Sqd01uKUkycYV6
        yqCkQgeqWbZIC09A/8sJfJMEbFA8EEEe4NobgU3mQZCU4RZFqv67Ggl2b4yu2tzGSWua/aEPCoLou
        gj0ufXoxteLl5gGZ4BtxjacN0Kohcuay3NmwXrUiRgzJYhtGmsF0+I8wj35LJCTpRNYVbwwFVq7Z5
        00aJbr6g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mpWVS-00F58I-4E; Tue, 23 Nov 2021 14:10:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2A62E300230;
        Tue, 23 Nov 2021 15:10:46 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 10CD42C36EB84; Tue, 23 Nov 2021 15:10:46 +0100 (CET)
Date:   Tue, 23 Nov 2021 15:10:46 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     joao@overdrivepizza.com, nstange@suse.de, pmladek@suse.cz,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
Message-ID: <YZz2ZvfxoLbxL8r6@hirez.programming.kicks-ass.net>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
 <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 23, 2021 at 12:39:15PM +0100, Miroslav Benes wrote:

> Ok. And we would need something like the following for the livepatch (not 
> even compile tested).
> 
> ---
> 
> diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
> index 4fe018cc207b..7b9dcd51af32 100644
> --- a/arch/powerpc/include/asm/livepatch.h
> +++ b/arch/powerpc/include/asm/livepatch.h
> @@ -19,16 +19,6 @@ static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  	regs_set_return_ip(regs, ip);
>  }
>  
> -#define klp_get_ftrace_location klp_get_ftrace_location
> -static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
> -{
> -	/*
> -	 * Live patch works only with -mprofile-kernel on PPC. In this case,
> -	 * the ftrace location is always within the first 16 bytes.
> -	 */
> -	return ftrace_location_range(faddr, faddr + 16);
> -}
> -
>  static inline void klp_init_thread_info(struct task_struct *p)
>  {
>  	/* + 1 to account for STACK_END_MAGIC */
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index fe316c021d73..81cd9235e160 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -127,15 +127,18 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  /*
>   * Convert a function address into the appropriate ftrace location.
>   *
> - * Usually this is just the address of the function, but on some architectures
> - * it's more complicated so allow them to provide a custom behaviour.
> + * Usually this is just the address of the function, but there are some
> + * exceptions.
> + *
> + *   * PPC - live patch works only with -mprofile-kernel. In this case,
> + *     the ftrace location is always within the first 16 bytes.
> + *   * x86_64 with CET/IBT enabled - there is ENDBR instruction at +0 offset.
> + *     __fentry__ follows it.
>   */
> -#ifndef klp_get_ftrace_location
> -static unsigned long klp_get_ftrace_location(unsigned long faddr)
> +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
>  {
> -	return faddr;
> +	return ftrace_location_range(faddr, faddr + 16);
>  }
> -#endif

Agreed, in fact, it should have called at least ftrace_location()
before, as a sanity check the address is in fact a listed fentry site.

I wonder though, given ftrace_cmp_recs() what the behaviour is if
there's two fentry sites within those 16 bytes... I don't think it will
uniquely return the leftmost one, so that might need some thinking.

Consider:

foo:
	endbr
	call __fentry__
	ret;
bar:
	endbr
	call __fentry__
	...

then both sites are within 16 bytes of one another.
