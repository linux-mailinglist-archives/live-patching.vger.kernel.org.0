Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBEC25ADF7
	for <lists+live-patching@lfdr.de>; Wed,  2 Sep 2020 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIBOuF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Sep 2020 10:50:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:53498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIBOA6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Sep 2020 10:00:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BFBEEAEF3;
        Wed,  2 Sep 2020 14:00:56 +0000 (UTC)
Date:   Wed, 2 Sep 2020 16:00:55 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        nstange@suse.de
Subject: Re: refactoring livepatch documentation was Re: [PATCH 1/2]
 docs/livepatch: Add new compiler considerations doc
In-Reply-To: <3842fe65-332e-9f90-fe75-7cd80b34b75e@redhat.com>
Message-ID: <alpine.LSU.2.21.2009021549320.23200@pobox.suse.cz>
References: <20200721161407.26806-1-joe.lawrence@redhat.com> <20200721161407.26806-2-joe.lawrence@redhat.com> <20200721230442.5v6ah7bpjx4puqva@treble> <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com> <20200722205139.hwbej2atk2ejq27n@treble>
 <20200806120336.GP24529@alley> <3842fe65-332e-9f90-fe75-7cd80b34b75e@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[side note: So not only that my INBOX is a mess after the summer. I also 
lost some emails apparently. I'm really sorry about that. ]

CCing Nicolai too.

> Hi Petr, Josh,
> 
> The compiler optimization pitfall document can wait for refactored livepatch
> documentation if that puts it into better context, particularly for newbies.
> I don't mind either way.  FWIW, I don't profess to be an authoritative source
> its content -- we've dealt some of these issues in kpatch, so it was
> interesting to see how they affect livepatches that don't rely on binary
> comparison.
> 
> 
> Toward the larger goal, I've changed the thread subject to talk about how we
> may rearrange and supplement our current documentation.  This is a first pass
> at a possible refactoring...
> 
> 
> 1. Provide a better index page to connect the other files/docs, like
> https://www.kernel.org/doc/html/latest/core-api/index.html but obviously not
> that extensive.  Right now we have only a Table of Contents tree without any
> commentary.
> 
> 2. Rearrange and refactor sections:
> 
> livepatch.rst
>   Keep just about everything
>   Add a history section to explain ksplice, kgraft, kpatch for the
>     uninitiated?
>   Add a section on source based vs. binary diff livepatch creation,
>     this may be worth its own top-level section
> 
> Livepatch API
>   Basic API
>   Callbacks
>   Shadow variables
>   Cumulative patches
>   System state
> 
> KLP Relocations
>   Right now this is a bit academic AFAIK kpatch is the only tool
>   currently making use of them.  So maybe this document becomes a
>   more general purpose doc explaining how to reference unexported
>   symbols?  (ie, how does kgraft currently do it, particularly
>   w/kallsyms going unexported?)

Yes, we rely on kallsyms_lookup_name() pretty much right now and once we 
hit the problem with the next kernel version upgrade, we'll have to fix 
it.
 
>   Eventually this could contain klp-convert howto if it ever gets
>   merged.
> 
> Compiler considerations
>   TBD
> 
> I suppose this doesn't create a "Livepatching creation for dummies" guide, but
> my feeling is that there are so many potential (hidden) pitfalls that such
> guide would be dangerous.

It does not create the guide, but it looks like a good basis. I agree with 
Josh here. It might be difficult at the beginning, but the outcome could 
be great even for a newbie and I think we should aim for that.
 
> If someone were to ask me today how to start building a livepatch, I would
> probably point them at the samples to demonstrate the basic concept and API,
> but then implore them to read through the documentation to understand how
> quickly complicated it can become.

True.

We discuss the need to properly document our internal process every once 
in a while and there is always something more important to deal with, but 
it is high time to finally start with that.

Miroslav
