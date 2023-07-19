Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5118575A2D7
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjGSXbQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 19:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGSXbQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 19:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595A19D;
        Wed, 19 Jul 2023 16:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB95661877;
        Wed, 19 Jul 2023 23:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984EC433C7;
        Wed, 19 Jul 2023 23:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689809474;
        bh=nIP5gyEY0YLO/0/+3zjFCWyJEEXhcI/AJRJ4WfpyQyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SvZp7drhtHKzINff+lrYfxX2axIKzm3bwzgT3eAEmUOfnIUGiNN+HX7YbcckmXrBa
         Fffo7pFSS/EuDLW0c+fjXMiNVzwqY+ou7e4c7dWQuWHSFQZGqxGpOhvbiFl4R0ambe
         SZ0xEZzUn1L8b3PffGuT06szb7jJC9GRuhRqpegotCLBWaJh0MS+alUFvBBUT/UJol
         j4yMmlaMMMSDr4eX+nWRJfKmbJPIHRmJlNaSaZori8QO5em8YVZw5MCvEN9yWvksFb
         Y6P1L88WteQIrPgRz7dVTwshZsfWKrWArkv9b1+ApHrjPp2nfQsL9Wh54MeeEONmLA
         cK1vwYHagqwyA==
Date:   Wed, 19 Jul 2023 16:31:11 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20230719233111.kqafaqect4v2ehu6@treble>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <20230719200222.GD3529734@hirez.programming.kicks-ass.net>
 <20230719201538.GA3553016@hirez.programming.kicks-ass.net>
 <20230719205050.GG3529734@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230719205050.GG3529734@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 19, 2023 at 10:50:50PM +0200, Peter Zijlstra wrote:
> > The below cures things; Josh, did I miss anything?
> > 
> > ---
> >  arch/x86/entry/entry_64.S | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 91f6818884fa..cfe7882ea9ae 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -285,7 +285,14 @@ SYM_FUNC_END(__switch_to_asm)
> >   */
> >  .pushsection .text, "ax"
> >  SYM_CODE_START(ret_from_fork_asm)
> > -	UNWIND_HINT_REGS
> > +	/*
> > +	 * This is the start of the kernel stack; even through there's a regs
> > +	 * set at the top, there is no real exception frame and one cannot
> > +	 * unwind further. This is the end.
> > +	 *
> > +	 * This ensures stack unwinds of kernel threads hit a known good state.
> > +	 */
> > +	UNWIND_HINT_END_OF_STACK

The comments may be a bit superfluous (to me at least) but the patch
looks fine.

> So unwind_orc.c:unwind_next_frame() will terminate on this hint *or* on
> user_mode(state->regs).
> 
> AFAICT way things are set up in copy_thread(), user_mode() will not be
> true -- after all there is no usermode, the kthread would first have to
> exec() something to create a usermode.
> 
> Yet I'm wondering if perhaps we should spoof the regs to make
> user_mode() true and auto-terminate without this explicit hint.

I'm not sure that would be worth the trouble / cleverness.  The hint is
straightforward IMO.

> Josh, do you remember the rationale for all this?

For what exactly :-)

-- 
Josh
