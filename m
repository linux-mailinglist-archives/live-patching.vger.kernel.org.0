Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FD56E42FE
	for <lists+live-patching@lfdr.de>; Mon, 17 Apr 2023 10:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjDQI6R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Apr 2023 04:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDQI6I (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Apr 2023 04:58:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8F98198D
        for <live-patching@vger.kernel.org>; Mon, 17 Apr 2023 01:58:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 970A01063;
        Mon, 17 Apr 2023 01:58:50 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.19.253])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3C983F6C4;
        Mon, 17 Apr 2023 01:58:03 -0700 (PDT)
Date:   Mon, 17 Apr 2023 09:58:01 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <ZD0KGUZbIU2JOrMo@FVFF77S0Q05N>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
 <20230414171255.oylmsdizl4waao4t@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414171255.oylmsdizl4waao4t@treble>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 10:12:55AM -0700, Josh Poimboeuf wrote:
> On Fri, Apr 14, 2023 at 10:53:03AM +0100, Mark Rutland wrote:
> > > Currently proposed topics follow. The list is open though and more will
> > > be added during the regular Call for Topics.
> > > 
> > >   - klp-convert (as means to fix CET IBT limitations) and its 
> > >     upstreamability
> > >   - shadow variables, global state transition
> > >   - kselftests and the future direction of development
> > >   - arm64 live patching
> > 
> > I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
> > get in contact with anyone looking at the arm64 userspace side (e.g.
> > klp-convert).
> 
> klp-convert is still considered experimental.  FYI here's a pull request
> which adds arm64 support to kpatch-build:
> 
>   https://github.com/dynup/kpatch/pull/1302

Ah; I'm clearly not familiar with the userspace side at all!

> > I have some topics which overlap between live-patching and general toolchain
> > bits and pieces, and I'm not sure if they'd be best suited here or in a
> > toolchain track, e.g.
> > 
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
> 
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

Today, noinstr is marks as noinline:

| /* Section for code which can't be instrumented at all */
| #define __noinstr_section(section)                                      \
|         noinline notrace __attribute((__section__(section)))            \
|         __no_kcsan __no_sanitize_address __no_profile __no_sanitize_coverage \
|         __no_sanitize_memory
| 
| #define noinstr __noinstr_section(".noinstr.text")

My understnading is that without that, a noinstr function *could* get inlined
into an instrumentable function and get instrumented (e.g. in the case of a
static noinstr function with a single caller).

> >   Likewise, whether we could somehow get compile-time warnings about unintended
> >   calls from instrumentable code from noinstr code.
> > 
> > * How is this going to work with rust?
> > 
> >   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
> >   live-patching are going to work with rust.
> 
> Not to mention how objtool will react to compiled rust code (has it
> already been tried?)

I have no idea :)

Thanks,
Mark
