Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3436E2AA1
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDNTa2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 15:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjDNTa1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 15:30:27 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA26C46B7
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 12:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G+ip9xR3bRZ/udKWInDXdIF72wKoYzHxij3arZNrrYc=; b=JnDLeXL1sTBDsQrfVJj2L6EIGh
        6KZ0YqFBg/aMtLLw6aYwkCDb05S1nOcLzds+XIYq+N4aVER76M/o2r1z8l3STxBPGctFzEHw0+nOI
        sGK6G5/kZXOorIr1otF8lA4xWbtRJxPzeeteawig15BGOnpHAdGqULJ7uKi8+R9+lmIlgLmuhx4lC
        wdGWKxX02hszENVvCUmXXauBfsJWKwTcvzgs04jQvSB5Ijb/pwwb6SzYCzZsqpDSUFIscXL7tDXxD
        jTWYdU+IJ2PpnLXXWzuywSb1KH3hNf4Edsz5lwNI8advOUiRXYm142mbvaEXcA1n1EujjIwQuVYbo
        rUypcBLg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pnP7f-00Fg0l-0A;
        Fri, 14 Apr 2023 19:30:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4D4CE3002A6;
        Fri, 14 Apr 2023 21:30:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A48A241FB92F; Fri, 14 Apr 2023 21:30:14 +0200 (CEST)
Date:   Fri, 14 Apr 2023 21:30:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <20230414193013.GB778423@hirez.programming.kicks-ass.net>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
 <20230414171255.oylmsdizl4waao4t@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414171255.oylmsdizl4waao4t@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 10:12:55AM -0700, Josh Poimboeuf wrote:

> > * How to avoid/minimize the need to reverse-engineer control flow for things
> >   like ORC generation.
> > 
> >   On the arm64 side we're pretty averse to doing this to generate metadata for
> >   unwinding (and we might not need to), but there are things objtool does today
> >   that requires awareness of control-flow (e.g. forward-edge checks for noinstr
> >   safety).
> > 
> >   Hopefully without a flamewar about DWARF...
> 
> If objtool is going to be doing control-flow anyway then it could just
> validate DWARF/SFrame.  Then everybody's happy?

Right; so per another recent thread somewhere; you can't rely on
DWARF/Sframe or any other compiler generated thing simply because it
doesn't cover .S files and inline asm -- and this being a kernel, we've
got quite a bit of that.

At best it could use DWARF to help reconstruct code flow and then
validate Sframe for the bits that got sframe.

FWIW, manually annotated asm without validation is an utter fail -- x86
tried that and it never works.

FWIW2, building with DWARF info on is significantly slower / bigger.

> > * Better compiler support for noinstr and similar properties.
> > 
> >   For example, noinstr functions are currently all noinline, and we can't
> >   inline a noinstr function into a noinstr function, leading to a painful mix
> >   of noinstr and __always_inline. Having a mechanism to allow noinstr code to
> >   be inlined into other noinstr code would be nice.
> 
> Can you elaborate?  Why can't noinstr inline noinstr?  (that's a
> mouthful)
> 
> Is it because of potential cloning caused by IPA optimizations?

It is because noinstr includes an explicit noinline. This is to avoid
the cmpiler from inlining noinstr functions in regular functions --
which for obvious raisins must never happen.

The compiler does not take the whole __sectio() attribute as a strong
enough clue for inlining boundaries.
