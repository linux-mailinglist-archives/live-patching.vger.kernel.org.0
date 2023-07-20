Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEE175A8EF
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 10:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjGTISU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 04:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbjGTISN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 04:18:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C622110;
        Thu, 20 Jul 2023 01:18:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DB4AA20591;
        Thu, 20 Jul 2023 08:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689841090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bakGv9Jv+bdxPDti8XSEFYOJsCrMiKQKDta5ejzJogk=;
        b=I9QdlyZZmePqAQ1F9P4UuEPE85g3jdZCE8ZbGSEneDoJEP00uQmgjNYWskzoymeaCrbtJd
        u6U9uAQMEKJorM1jytlT6Jx+qv8s0pjidzjiOGxmgQ1blAw5ucYDCdirB+8X5iYScuGA4p
        A40figLyPsCDnq6tEl1GRguutqPDXLI=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6039D2C142;
        Thu, 20 Jul 2023 08:18:09 +0000 (UTC)
Date:   Thu, 20 Jul 2023 10:18:05 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Brian Gerst <brgerst@gmail.com>, jpoimboe@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        alyssa.milburn@linux.intel.com, keescook@chromium.org,
        joao@overdrivepizza.com, tim.c.chen@linux.intel.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86: Rewrite ret_from_fork() in C
Message-ID: <ZLjtvSXVm4gBd-s_@alley>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
 <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-07-19 22:15:38, Peter Zijlstra wrote:
> On Wed, Jul 19, 2023 at 10:02:22PM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 19, 2023 at 05:21:11PM +0200, Petr Mladek wrote:
> > 
> > > This patch broke livepatching. Kthreads never have a reliable stack.
> > > It works when I revert it.
> > 
> > > > +SYM_CODE_START(ret_from_fork_asm)
> > > > +	UNWIND_HINT_REGS
> > 
> > It works again when I change the above hint to UNWIND_HINT_END_OF_STACK,
> > so yeah. Doing this makes objtool unhappy with something else though,
> > so I'll go prod at things with something sharp...
> 
> 
> The below cures things; Josh, did I miss anything?

I can confirm that it solved the problem. Feel free to use:

Tested-by: Petr Mladek <pmladek@suse.com>

Thanks a lot for the quick fix.

Best Regards,
Petr

> ---
>  arch/x86/entry/entry_64.S | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 91f6818884fa..cfe7882ea9ae 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -285,7 +285,14 @@ SYM_FUNC_END(__switch_to_asm)
>   */
>  .pushsection .text, "ax"
>  SYM_CODE_START(ret_from_fork_asm)
> -	UNWIND_HINT_REGS
> +	/*
> +	 * This is the start of the kernel stack; even through there's a regs
> +	 * set at the top, there is no real exception frame and one cannot
> +	 * unwind further. This is the end.
> +	 *
> +	 * This ensures stack unwinds of kernel threads hit a known good state.
> +	 */
> +	UNWIND_HINT_END_OF_STACK
>  	ANNOTATE_NOENDBR // copy_thread
>  	CALL_DEPTH_ACCOUNT
>  
> @@ -295,6 +302,11 @@ SYM_CODE_START(ret_from_fork_asm)
>  	movq	%r12, %rcx		/* fn_arg */
>  	call	ret_from_fork
>  
> +	/*
> +	 * Set the stack state to what is expected for the target function
> +	 * -- also it is not wrong.
> +	 */
> +	UNWIND_HINT_REGS
>  	jmp	swapgs_restore_regs_and_return_to_usermode
>  SYM_CODE_END(ret_from_fork_asm)
>  .popsection
