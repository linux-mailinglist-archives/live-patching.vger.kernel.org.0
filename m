Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17C0259C32
	for <lists+live-patching@lfdr.de>; Tue,  1 Sep 2020 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgIARMe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Sep 2020 13:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729511AbgIARMa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Sep 2020 13:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598980348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6tq9XbBkkctfISvu/8JAip4aOF6DG++oXbCP77hju3Y=;
        b=gJkKQHN55Bpw5EkTKici/3xksgTyQKzzzuFnlpmYlk61Is8Os6zESmLcWoAclCskphna71
        02mecyF9UmvgHtKXwsccpkBhXqXYiPl43Rr+VCXHbVU26E5kI9exvw/okXnmk5FeK4MhB1
        4R3NksX6o4EeTTYMGVZqCLCMEClfV3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-gfbAtqhlPbKr-7JAzqN6xw-1; Tue, 01 Sep 2020 13:12:27 -0400
X-MC-Unique: gfbAtqhlPbKr-7JAzqN6xw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 344B11006708;
        Tue,  1 Sep 2020 17:12:26 +0000 (UTC)
Received: from treble (ovpn-113-168.rdu2.redhat.com [10.10.113.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B1BD1002D60;
        Tue,  1 Sep 2020 17:12:22 +0000 (UTC)
Date:   Tue, 1 Sep 2020 12:12:20 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: refactoring livepatch documentation was Re: [PATCH 1/2]
 docs/livepatch: Add new compiler considerations doc
Message-ID: <20200901171220.pgepj3hxrfwy37rj@treble>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <20200721161407.26806-2-joe.lawrence@redhat.com>
 <20200721230442.5v6ah7bpjx4puqva@treble>
 <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
 <20200722205139.hwbej2atk2ejq27n@treble>
 <20200806120336.GP24529@alley>
 <3842fe65-332e-9f90-fe75-7cd80b34b75e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3842fe65-332e-9f90-fe75-7cd80b34b75e@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 10, 2020 at 03:46:46PM -0400, Joe Lawrence wrote:
> > > > > I'm thinking a newcomer reading this might be lost.  It's not
> > > > > necessarily clear that there are currently two completely different
> > > > > approaches to creating a livepatch module, each with their own quirks
> > > > > and benefits/drawbacks.  There is one mention of a "source-based
> > > > > livepatch author" but no explanation of what that means.
> > > > > 
> > > > 
> > > > Yes, the initial draft was light on source-based patching since I only
> > > > really tinker with it for samples/kselftests.  The doc was the result of an
> > > > experienced livepatch developer and Sunday afternoon w/the compiler. I'm
> > > > sure it reads as such. :)
> > > 
> > > Are experienced livepatch developers the intended audience?  If so I
> > > question what value this document has in its current form.  Presumably
> > > experienced livepatch developers would already know this stuff.
> > 
> > IMHO, this document is useful even for newbies. They might at
> > least get a clue about these catches. It is better than nothing.
> > 
> > I do not want to discourage Joe from creating even better
> > documentation. But if he does not have interest or time
> > to work on it, I am happy even for this piece.

Agreed.  Joe, sorry for instigating and then disappearing :-)

I know we're all busy and I didn't intend to block the patch until we
reach Documentation Nirvana.  Though it would be _really_ nice to get
more input from those who have more experience with the subject matter
(source-based patch generation).

It's part of my job as a maintainer to push back, question, and
sometimes even complain.  I was just wondering where this is heading,
because as our documentation grows (a good thing), the overall state is
getting less cohesive (a bad thing).

Anyway, ACK to the original patch.

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
> 
>   Eventually this could contain klp-convert howto if it ever gets
>   merged.
> 
> Compiler considerations
>   TBD

This is certainly a logical way to organize things.  But again I would
wonder, who's the audience?

> I suppose this doesn't create a "Livepatching creation for dummies" guide,
> but my feeling is that there are so many potential (hidden) pitfalls that
> such guide would be dangerous.

I disagree that a live patching creation guide would be dangerous.  I
think it would be less dangerous than *not* having one.  There are
several companies now delivering (hopefully reliable) livepatches to
customers, and they're all presumably following processes.  We just need
to agree on best practices and document the resulting process.  Over
time I believe that will create much more good than harm.

Sure, there are pitfalls, but the known ones can be highlighted in the
guide.  No document is perfect but it hopefully improves and becomes
more useful over time.

-- 
Josh

