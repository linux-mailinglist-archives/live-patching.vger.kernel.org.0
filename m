Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9606675AAFA
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 11:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjGTJhI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 05:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjGTJgt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 05:36:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2228C3A8D;
        Thu, 20 Jul 2023 02:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RZvdXjx1hZtcZSf74NvFvf8MQ6mexnlAJnPNEN00Cyo=; b=DKTvOeHtImBp0sx+QDcm4M4JsL
        qsSH7Thf3bOAZW38uH+7ZGk+wggvENeAqtgEkqneCUryBAV60eSBqQAQFjBwVc37JLdR7zSULLWbF
        9Y/7Jph8JzC9EpjTCGE1t/Jkris7QZt1pmKUndRam9oV4FcykVnINIbdkfUHbc2As82dvadGGUrDM
        cLWcgSuHODpWt6eHikxFd4RWgMVeEMfbLmZsU5hO5ek+nsWjK5VCPcvLl4VVcXtPuiO74k3YixW3l
        UqCRth0P1jmjFA2WpHeR9sAlifdsFwZmQKF1ijbxZClRfhWefrt8AsKrsraucwvRK9UBsnJopP40i
        StxTQzYg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qMPxB-00FSy1-1K;
        Thu, 20 Jul 2023 09:30:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 699A5300342;
        Thu, 20 Jul 2023 11:28:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 44F092B32666E; Thu, 20 Jul 2023 11:28:07 +0200 (CEST)
Date:   Thu, 20 Jul 2023 11:28:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, Brian Gerst <brgerst@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        alyssa.milburn@linux.intel.com, keescook@chromium.org,
        joao@overdrivepizza.com, tim.c.chen@linux.intel.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86: Rewrite ret_from_fork() in C
Message-ID: <20230720092807.GB3570477@hirez.programming.kicks-ass.net>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
 <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
 <20230719205050.GG3529734@hirez.programming.kicks-ass.net>
 <20230719233111.kqafaqect4v2ehu6@treble>
 <20230720052208.GO4253@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720052208.GO4253@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 20, 2023 at 07:22:08AM +0200, Peter Zijlstra wrote:

> > I'm not sure that would be worth the trouble / cleverness.  The hint is
> > straightforward IMO.
> 
> I tried, it doesn't work, clearly I missed something.

FWIW, I tried the below. That should make user_mode() true for the
kernel thread regset, and while the kernel did boot, it still fails the
livepatch self-test.

The difference seems to be that END_OF_STACK terminates it right there,
while REGS thinks its a valid frame and only terminates on user_mode()
when unwinding one more frame. The frame at REGS clearly isn't very
sane.


diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 72015dba72ab..45a400b16b80 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -232,6 +232,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		 * It does the same kernel frame setup to return to a kernel
 		 * function that a kernel thread does.
 		 */
+		childregs->cs = 3;
 		childregs->sp = 0;
 		childregs->ip = 0;
 		kthread_frame_init(frame, args->fn, args->fn_arg);
