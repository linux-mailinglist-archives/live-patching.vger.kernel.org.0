Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1D68B0ED
	for <lists+live-patching@lfdr.de>; Sun,  5 Feb 2023 17:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBEQWF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 5 Feb 2023 11:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBEQWE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 5 Feb 2023 11:22:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848A65A4;
        Sun,  5 Feb 2023 08:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B29B80C93;
        Sun,  5 Feb 2023 16:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6072DC433EF;
        Sun,  5 Feb 2023 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675614118;
        bh=Ah7JsMso/gKSKfSDC+u0iMmehdce+I9oIrEIjZfxS0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R8sbsyniUgXIUWBXc5BCiFKfBly8y1P9daSadDPzyWh0yLZxiCqNn4fvTcbigmqli
         74h9cjYiPyc+sfvEguC8rT1B1y483Xo5ff7ktYgksIA7hP4VFbjte+aksSnPyr1TG4
         gNunv0n5yKFUl3DkK/u48gu9c2rB5+Jb9mmEeLBQdbnqrNINyBQKlYzUXbE9ljurrW
         VOXtnav+63pHox1hkL4UmBIk7tPlRRern9yUP/0kn74hspxZUuKcaeRbapzCuj8kT8
         0fzX1ypuWSVUXqOa9wKmgNeSKQcaR8gCbE0W86Nf6tgRuKUw4ZLSI1wXQbU9PSf6mU
         vjkkjDb2SCCNA==
Date:   Sun, 5 Feb 2023 08:21:56 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
Message-ID: <20230205162156.zganuowqio4kva6o@treble>
References: <cover.1674617130.git.jpoimboe@kernel.org>
 <20230204172357.mbudvbtv7tc7vhf3@treble>
 <87357ley7f.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87357ley7f.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Feb 05, 2023 at 11:46:12AM +1100, Michael Ellerman wrote:
> Josh Poimboeuf <jpoimboe@kernel.org> writes:
> > On Tue, Jan 24, 2023 at 07:38:03PM -0800, Josh Poimboeuf wrote:
> >> Fix a livepatch bug seen when reloading a patched module.
> >> 
> >> This is the powerpc counterpart to Song Liu's fix for a similar issue on
> >> x86:
> >> 
> >>   https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org
> >> 
> >> Josh Poimboeuf (2):
> >>   powerpc/module_64: Improve restore_r2() return semantics
> >>   powerpc/module_64: Fix "expected nop" error on module re-patching
> >> 
> >>  arch/powerpc/kernel/module_64.c | 29 ++++++++++++++++++-----------
> >>  1 file changed, 18 insertions(+), 11 deletions(-)
> >
> > Hi Michael,
> >
> > Ping?  Any objections to this?
> >
> > The x86 counterpart to this is queued for 6.3, it would be nice if this
> > also landed.  We could take it through the livepatch tree if needed.
> 
> It's in my next since about a week. Sorry I forgot to send the
> "accepted" emails (which I still don't have automated :/ ).
> 
> 337251c7114e1 ("powerpc/module_64: Fix "expected nop" error on module re-patching")

Ah, I didn't think to look in -next.  Thanks!

-- 
Josh
