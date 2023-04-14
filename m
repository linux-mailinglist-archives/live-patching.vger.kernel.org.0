Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D106E2907
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjDNRNE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDNRNE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 13:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0223C07
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 10:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952C764636
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 17:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC03C433EF;
        Fri, 14 Apr 2023 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681492378;
        bh=1+l+Z9xdoJRFlFWSdwQYXzaC6pQ9thrviOV9OZkfZHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYVTPYf3eo0tnB94MU9tupw4DZk3kWTEl7fJQIVRP4i2rodOgOuTUr+c1eZiz0YCv
         uwKkERUKXSvYFld6zZaeQXSWCRREQDm+0NXYc1zwyXRz8wmE2fIj0nLy0wzQ5Rwt+d
         MyPUe5PYYjIJSmT8Nst7tf+r8E7xiCcAH4s9JGHkujRyMS6iRRSedXg9Vnj056MmJS
         h+BElEab8tKP9XnPLARAxCX4IIO26rLzXDz4Utz0C20e9Fz5aa459toe5gK+b7t3Ks
         29gPDAJmL47ofAjUENyRA9TKxEspf5M4ekFszkV2sbBHaCxGcmRAc4h3iM4DEYdEns
         +ixbESTLAGLPg==
Date:   Fri, 14 Apr 2023 10:12:55 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <20230414171255.oylmsdizl4waao4t@treble>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 10:53:03AM +0100, Mark Rutland wrote:
> > Currently proposed topics follow. The list is open though and more will
> > be added during the regular Call for Topics.
> > 
> >   - klp-convert (as means to fix CET IBT limitations) and its 
> >     upstreamability
> >   - shadow variables, global state transition
> >   - kselftests and the future direction of development
> >   - arm64 live patching
> 
> I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
> get in contact with anyone looking at the arm64 userspace side (e.g.
> klp-convert).

klp-convert is still considered experimental.  FYI here's a pull request
which adds arm64 support to kpatch-build:

  https://github.com/dynup/kpatch/pull/1302

> I have some topics which overlap between live-patching and general toolchain
> bits and pieces, and I'm not sure if they'd be best suited here or in a
> toolchain track, e.g.
> 
> * How to avoid/minimize the need to reverse-engineer control flow for things
>   like ORC generation.
> 
>   On the arm64 side we're pretty averse to doing this to generate metadata for
>   unwinding (and we might not need to), but there are things objtool does today
>   that requires awareness of control-flow (e.g. forward-edge checks for noinstr
>   safety).
> 
>   Hopefully without a flamewar about DWARF...

If objtool is going to be doing control-flow anyway then it could just
validate DWARF/SFrame.  Then everybody's happy?

> * Better compiler support for noinstr and similar properties.
> 
>   For example, noinstr functions are currently all noinline, and we can't
>   inline a noinstr function into a noinstr function, leading to a painful mix
>   of noinstr and __always_inline. Having a mechanism to allow noinstr code to
>   be inlined into other noinstr code would be nice.

Can you elaborate?  Why can't noinstr inline noinstr?  (that's a
mouthful)

Is it because of potential cloning caused by IPA optimizations?

>   Likewise, whether we could somehow get compile-time warnings about unintended
>   calls from instrumentable code from noinstr code.
> 
> * How is this going to work with rust?
> 
>   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
>   live-patching are going to work with rust.

Not to mention how objtool will react to compiled rust code (has it
already been tried?)

-- 
Josh
