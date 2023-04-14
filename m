Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4348E6E2566
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjDNOPi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 10:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDNOPf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 10:15:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015FBBBA2
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 07:15:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4A8DE219E1;
        Fri, 14 Apr 2023 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681481694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGrD8f6LSfSOeFzhuzJmp/v5Oq0RPYd9LQJeruV1Crk=;
        b=sR5X6j+zBzxTybM8jVYgaekmhAJT5tSD9hRXJledwsz4FeCKzigWD+e5zFgVAYFS4BVLpd
        uEPUH3RPfHV6xhpcgIgEGelD/k4uo2MMoLGwgSpz6/QttAMqUv7idd3v3lWbcVDWysjv3t
        9lQMk3/XyjMgM14ikH7ZQ3KL4X0VQj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681481694;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGrD8f6LSfSOeFzhuzJmp/v5Oq0RPYd9LQJeruV1Crk=;
        b=bpacPO0zyURazNtsSZ05RAioijVK5u5gm8DqBVcgabHtzTcAZevDfI/+o/r6JwPJ6Ol/kB
        7VDldSOPOzEvlrDw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DBBE72C143;
        Fri, 14 Apr 2023 14:14:53 +0000 (UTC)
Date:   Fri, 14 Apr 2023 16:14:53 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     "Jose E. Marchesi" <jose.marchesi@oracle.com>
cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        elena.zannoni@oracle.com, indu.bhagat@oracle.com
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <87r0sm39pt.fsf@oracle.com>
Message-ID: <alpine.LSU.2.21.2304141611090.4426@pobox.suse.cz>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz> <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <87r0sm39pt.fsf@oracle.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > I'm happy to talk about the kernel-side of arm64 live patching; it'd be good to
> > get in contact with anyone looking at the arm64 userspace side (e.g.
> > klp-convert).
> >
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
> >
> > * Better compiler support for noinstr and similar properties.
> >
> >   For example, noinstr functions are currently all noinline, and we can't
> >   inline a noinstr function into a noinstr function, leading to a painful mix
> >   of noinstr and __always_inline. Having a mechanism to allow noinstr code to
> >   be inlined into other noinstr code would be nice.
> >
> >   Likewise, whether we could somehow get compile-time warnings about unintended
> >   calls from instrumentable code from noinstr code.
> >
> > * How is this going to work with rust?
> >
> >   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
> >   live-patching are going to work with rust. We probably need to start looking
> >   soon.
> >
> > I've Cc'd Nick, Jose, and Miguel, in case they have thoughts.
> 
> We have indeed submitted a proposal for a Toolchains MC for Plumbers.

Great.
 
> I think the two first topics mentioned above (CFG in ELF and handling of
> noinstr functions) would definitely fit well in the Toolchains MC.

Yes.

> As for Rust... we have the Rust GCC support and that would fit in the MC
> as well.  We can surely invite some of the hackers working in the
> front-end.  But maybe it would be better to have that discussion in a
> Rust MC, if there is gonna be one (Miguel?).

I would definitely welcome a session which Mark proposed. Be it at Live 
Patching MC or Rust MC. I know next to nothing about how Rust is wired 
into the kernel and what impact it might have on us. The sooner we 
understand possible issues, the better.

> For starters, I would make sure that the involved MCs (Live Patching,
> Toolchains, and an eventual Rust MC) do not overlap in the schedule.
> Then we could have these discussions in either microconferences.

Agreed.

Miroslav
