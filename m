Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408A775A56D
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 07:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjGTFWg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 01:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGTFWf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 01:22:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E621710;
        Wed, 19 Jul 2023 22:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s57Opk6b0bNX8mn2+UgCeeEZ8NdfAgz5xgbafB6twJY=; b=XJQM9DEpRZVxAYds4ZQDpT9M3A
        1IXnYbR4myMJDom6EN4MgEKpmQE6/jYsrP/Ex4SYeV9hESlCN1pyHO2rtrn18Gt3AR+usNC6xi+2O
        0s7v5pKLSw0ZZA198XHdbCkbfvz8pNpkPHSnZ/Vz7rn//biaPb0YaHzk1UZ006fqfRh+ixzS1TVGH
        /wfNTiGCPmXjVMXNg3PFLsrLSi5PorJrj5tRJG0SzImUs1mPw1QkL5JDG7ffDzWQLz8VnYrmvxKm2
        kW6fiHSWKehDJuoAaND8eoFk+Sd5d2Lm5GNqFM5Kn/aXL7AJTnTPVAqr/fDXTQ4IQn8HGWooL/zTh
        q00hwCrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qMM77-00FJM2-1f;
        Thu, 20 Jul 2023 05:22:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5D892300346;
        Thu, 20 Jul 2023 07:22:08 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 461B92B326660; Thu, 20 Jul 2023 07:22:08 +0200 (CEST)
Date:   Thu, 20 Jul 2023 07:22:08 +0200
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
Message-ID: <20230720052208.GO4253@hirez.programming.kicks-ass.net>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
 <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
 <20230719205050.GG3529734@hirez.programming.kicks-ass.net>
 <20230719233111.kqafaqect4v2ehu6@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719233111.kqafaqect4v2ehu6@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 19, 2023 at 04:31:11PM -0700, Josh Poimboeuf wrote:
> On Wed, Jul 19, 2023 at 10:50:50PM +0200, Peter Zijlstra wrote:
> > > The below cures things; Josh, did I miss anything?
> > > 
> > > ---
> > >  arch/x86/entry/entry_64.S | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > > index 91f6818884fa..cfe7882ea9ae 100644
> > > --- a/arch/x86/entry/entry_64.S
> > > +++ b/arch/x86/entry/entry_64.S
> > > @@ -285,7 +285,14 @@ SYM_FUNC_END(__switch_to_asm)
> > >   */
> > >  .pushsection .text, "ax"
> > >  SYM_CODE_START(ret_from_fork_asm)
> > > -	UNWIND_HINT_REGS
> > > +	/*
> > > +	 * This is the start of the kernel stack; even through there's a regs
> > > +	 * set at the top, there is no real exception frame and one cannot
> > > +	 * unwind further. This is the end.
> > > +	 *
> > > +	 * This ensures stack unwinds of kernel threads hit a known good state.
> > > +	 */
> > > +	UNWIND_HINT_END_OF_STACK
> 
> The comments may be a bit superfluous (to me at least) but the patch
> looks fine.

Right, well, it took me a minute to figure out how it was all supposed
to work, I figured I'd stick a comment on it.

The bit I missed is that if you reach the return-to-user part, you will
actually have user_mode() true on the regset.

> > So unwind_orc.c:unwind_next_frame() will terminate on this hint *or* on
> > user_mode(state->regs).
> > 
> > AFAICT way things are set up in copy_thread(), user_mode() will not be
> > true -- after all there is no usermode, the kthread would first have to
> > exec() something to create a usermode.
> > 
> > Yet I'm wondering if perhaps we should spoof the regs to make
> > user_mode() true and auto-terminate without this explicit hint.
> 
> I'm not sure that would be worth the trouble / cleverness.  The hint is
> straightforward IMO.

I tried, it doesn't work, clearly I missed something.
