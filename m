Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC1E6E2F06
	for <lists+live-patching@lfdr.de>; Sat, 15 Apr 2023 06:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjDOEjz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Apr 2023 00:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOEjx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Apr 2023 00:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF94EFB
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 21:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6043560C75
        for <live-patching@vger.kernel.org>; Sat, 15 Apr 2023 04:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4359AC433D2;
        Sat, 15 Apr 2023 04:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681533591;
        bh=uzSf/VwwqYrRz6GGbVFYM99hyw1kUP+txpv5k5RlJnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M6lDEbGeWsbt57S4Hqes2bk+NNCyvwJ3+rdzWLfmOKsdfwtHLBg5WfLnmibqZ5Rc3
         iJ0lgDTnOzZ+joaE9D/1j9pimgT0e1On/XyaOxC1JiROd+miPhFBV29jkK2xwZjZ0r
         yr/o3yMfOTGpU6QfobAgLtZWMHG83gff8VWWctrSgfnoAnVrzY7snJCh0oGj2zdf69
         4d3Ek+D/8cbO7JAxO394jN97mqMjAFfUyHUVVolSJ3JbTlKvrfroRuXCBnB88JLEKY
         3BRGM6pesUV8SLxyMYTXX9hw5/234rxLBQpiuYbnP9SkL9xNzfdqrV5C3OAL5EDzIm
         h9Y3C3/t7VogA==
Date:   Fri, 14 Apr 2023 21:39:49 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <20230415043949.7y4tvshe26zday3e@treble>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
 <20230414171255.oylmsdizl4waao4t@treble>
 <20230414193013.GB778423@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230414193013.GB778423@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 09:30:13PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 14, 2023 at 10:12:55AM -0700, Josh Poimboeuf wrote:
> 
> > > * How to avoid/minimize the need to reverse-engineer control flow for things
> > >   like ORC generation.
> > > 
> > >   On the arm64 side we're pretty averse to doing this to generate metadata for
> > >   unwinding (and we might not need to), but there are things objtool does today
> > >   that requires awareness of control-flow (e.g. forward-edge checks for noinstr
> > >   safety).
> > > 
> > >   Hopefully without a flamewar about DWARF...
> > 
> > If objtool is going to be doing control-flow anyway then it could just
> > validate DWARF/SFrame.  Then everybody's happy?
> 
> Right; so per another recent thread somewhere; you can't rely on
> DWARF/Sframe or any other compiler generated thing simply because it
> doesn't cover .S files and inline asm -- and this being a kernel, we've
> got quite a bit of that.
> 
> At best it could use DWARF to help reconstruct code flow and then
> validate Sframe for the bits that got sframe.

I wasn't (necessarily) suggesting that objtool use DWARF as an input to
help it construct the control-flow graph (CFG).

Instead, the idea is for objtool to continue to reverse-engineer the CFG
as it does today (albeit with a little help from the compiler in
specific problematic areas, e.g. noreturns and jump tables).

Then, it could use that independently-developed CFG to read the
compiler-generated metadata (DWARF/SFrame/whatever), and report any
warnings if the DWARF doesn't match objtool's CFG.

In other words, DWARF validation becomes just another optional objtool
feature, similar to its other unwinding-related features like frame
pointer validation and ORC generation.

That way, regardless of which philosophy [1] you subscribe to, if
something is amiss with reliable unwinding, the end result is the same:
a warning.

Then a human can look at the warning and investigate whether it's
objtool or DWARF/whatever that needs to be fixed.

[1] "reverse engineering is risky" vs "reverse engineering is reliable"

-- 
Josh
