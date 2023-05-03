Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAD6F6019
	for <lists+live-patching@lfdr.de>; Wed,  3 May 2023 22:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjECUdT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 May 2023 16:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjECUdT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 May 2023 16:33:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0FE7D8B
        for <live-patching@vger.kernel.org>; Wed,  3 May 2023 13:33:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B2D162FB6
        for <live-patching@vger.kernel.org>; Wed,  3 May 2023 20:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A85C433EF;
        Wed,  3 May 2023 20:33:13 +0000 (UTC)
Date:   Wed, 3 May 2023 16:33:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
Message-ID: <20230503163312.275f956e@gandalf.local.home>
In-Reply-To: <0edd2374-5cfa-2731-f874-aeaa54b3dd18@redhat.com>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
        <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
        <0edd2374-5cfa-2731-f874-aeaa54b3dd18@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 3 May 2023 16:05:15 -0400
Joe Lawrence <joe.lawrence@redhat.com> wrote:

> On 4/14/23 05:53, Mark Rutland wrote:
> > 
> > * How is this going to work with rust?
> > 
> >   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
> >   live-patching are going to work with rust. We probably need to start looking
> >   soon.
> >   
> 
> [ cc += Steve ]
> 
> For me, any explanation of kernel livepatching to another kernel dev
> usually starts with ftrace, handlers, function granularity, etc.
> Thinking about livepatching + rust, I can only imagine there will be a
> lot of known and unknown gotchas with respect to data scoping, stacks,
> relocations, etc... but I would still work my way up from learning more
> about how / if Rust code will be trace-able and what that roadmap may be.
> 
> Any thoughts on that Steve?  I see that the "Kernel Testing &
> Dependability" microconf has Rust on their proposal, are there any other
> planned talks re: ftrace / rust?
>

Thanks for bringing this up. ftrace on rust has been on the back of my
mind, and yeah, we should start looking into it. I should push for a
tracing MC, we haven't had one in a few years.

-- Steve

