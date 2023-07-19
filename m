Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA91759F30
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 22:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjGSUCr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGSUCq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 16:02:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D71FDF;
        Wed, 19 Jul 2023 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/LoiVdXFFT7LO9YmsZUcNPfwRVnkM9wKImwKWJoAejg=; b=cRKaWBiMlfzyoOy8f2LZzODpEd
        +9mFResKM26+NvFN8Ei3BmKR67jaMDguB8YsmgOp8cWlyml87xshEp5o2886SNCvOYwwCYYXC6hCF
        s02QH7Hb81ltEhBk1r4O2A4M0JCZK6y0mWatjoxxLwx5pp5qysIqf8QSh6iIklPS41ypAFZTnwywt
        edYAIwbQKlChxfrcQvBJWrAQb/RWwbbC/yeaJGOMu+7foRywQY0Vk4yvbmEEUHMlQyti+xD9OkaDR
        I6mPGcC2mcJGv0t8NgA1DbUBDXVIRJyrJ1y1DKiZKTmLjGfPquOoI8koQDTJpSK4EhPw8vJAmSkp/
        oDxQ6Esw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMDNR-006QUy-1a; Wed, 19 Jul 2023 20:02:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E057030007E;
        Wed, 19 Jul 2023 22:02:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BE04026AA535B; Wed, 19 Jul 2023 22:02:22 +0200 (CEST)
Date:   Wed, 19 Jul 2023 22:02:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
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
Message-ID: <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLf_Z5dCSm7zKDel@alley>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 19, 2023 at 05:21:11PM +0200, Petr Mladek wrote:

> This patch broke livepatching. Kthreads never have a reliable stack.
> It works when I revert it.

> > +SYM_CODE_START(ret_from_fork_asm)
> > +	UNWIND_HINT_REGS

It works again when I change the above hint to UNWIND_HINT_END_OF_STACK,
so yeah. Doing this makes objtool unhappy with something else though,
so I'll go prod at things with something sharp...

Thanks!

> >  	ANNOTATE_NOENDBR // copy_thread
> >  	CALL_DEPTH_ACCOUNT
> >  
> > +	movq	%rax, %rdi		/* prev */
> > +	movq	%rsp, %rsi		/* regs */
> > +	movq	%rbx, %rdx		/* fn */
> > +	movq	%r12, %rcx		/* fn_arg */
> > +	call	ret_from_fork
> >  
> > +SYM_CODE_END(ret_from_fork_asm)
