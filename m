Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D3E759F63
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjGSUPu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 16:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGSUPu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 16:15:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8B5F0;
        Wed, 19 Jul 2023 13:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rB+P/56lu7O3zC0LIPSTAOAzaS17JJok0KIPwQYOIXA=; b=kzDXIdZTRsRlJEZwN0EAzp73cE
        dAjEs49RfNesD/Nb7mfd1AWQbPPA3MViGY2fIsFlvWpFc54h2GcXwk6FHikg6no/0xZgnbYAKGs9I
        TW5x9u/xdk+wm4LL0k17MCyaxIf5pI2y+ITO+RAipAC0Y+QdqrXaShDSFzyBLAm07683yNyczPnGa
        glII9ZaClqeAUcTPdMXoHICoT4KMgKfdFU0eumMm0HjK/5Vwc3QjXIdnh8BZhs07RPWIf6JGmvZx0
        D9/Czq/RhA16AVi7oh52z3UyFR0qdscYMWUembMewZ/9ntyW69I0wAqDACOLrfAsLVGYGzMeaAYUh
        /0PgXO1g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMDaE-006R4i-Sh; Wed, 19 Jul 2023 20:15:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 69C0E30049E;
        Wed, 19 Jul 2023 22:15:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4EC8B2CA67A20; Wed, 19 Jul 2023 22:15:38 +0200 (CEST)
Date:   Wed, 19 Jul 2023 22:15:38 +0200
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
Message-ID: <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 19, 2023 at 10:02:22PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 19, 2023 at 05:21:11PM +0200, Petr Mladek wrote:
> 
> > This patch broke livepatching. Kthreads never have a reliable stack.
> > It works when I revert it.
> 
> > > +SYM_CODE_START(ret_from_fork_asm)
> > > +	UNWIND_HINT_REGS
> 
> It works again when I change the above hint to UNWIND_HINT_END_OF_STACK,
> so yeah. Doing this makes objtool unhappy with something else though,
> so I'll go prod at things with something sharp...


The below cures things; Josh, did I miss anything?

---
 arch/x86/entry/entry_64.S | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 91f6818884fa..cfe7882ea9ae 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -285,7 +285,14 @@ SYM_FUNC_END(__switch_to_asm)
  */
 .pushsection .text, "ax"
 SYM_CODE_START(ret_from_fork_asm)
-	UNWIND_HINT_REGS
+	/*
+	 * This is the start of the kernel stack; even through there's a regs
+	 * set at the top, there is no real exception frame and one cannot
+	 * unwind further. This is the end.
+	 *
+	 * This ensures stack unwinds of kernel threads hit a known good state.
+	 */
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR // copy_thread
 	CALL_DEPTH_ACCOUNT
 
@@ -295,6 +302,11 @@ SYM_CODE_START(ret_from_fork_asm)
 	movq	%r12, %rcx		/* fn_arg */
 	call	ret_from_fork
 
+	/*
+	 * Set the stack state to what is expected for the target function
+	 * -- also it is not wrong.
+	 */
+	UNWIND_HINT_REGS
 	jmp	swapgs_restore_regs_and_return_to_usermode
 SYM_CODE_END(ret_from_fork_asm)
 .popsection
