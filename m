Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F2628FAAA
	for <lists+live-patching@lfdr.de>; Thu, 15 Oct 2020 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgJOV3o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Oct 2020 17:29:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730552AbgJOV3o (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Oct 2020 17:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602797382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kx9DiDH08JaCe0i/mT8On9u7ra92vB1BVSutz2Qc+1Y=;
        b=JRA2Me5GfW3ujJ7QGO893nj5/Doa+NCYWb0c7XJNhl2LIjr3/y9htOxyIsJgSxT4Dtgf2v
        ez0EJQqPQ/Qig3mBecOaIMPfwXNsKoSMVSFbFUAnRsImazG2kplR6hp5AL7qbnzhay0o3f
        bdMmdrlo2O19gZBvUEDcNRYm1WgIEho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-MkcSJ-buO8aHZbvmQMrHsA-1; Thu, 15 Oct 2020 17:29:38 -0400
X-MC-Unique: MkcSJ-buO8aHZbvmQMrHsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D780B835B91;
        Thu, 15 Oct 2020 21:29:36 +0000 (UTC)
Received: from treble (ovpn-115-218.rdu2.redhat.com [10.10.115.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9B3961983;
        Thu, 15 Oct 2020 21:29:34 +0000 (UTC)
Date:   Thu, 15 Oct 2020 16:29:31 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201015212931.mh4a5jt7pxqlzxsg@treble>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201015154951.GD4390@sirena.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I can't see the original patch.  Can the original poster (Mark B?) add
me to Cc on the next version?

It's also good practice to add lkml as well.  That way, those of us not
copied can at least find the patch in the archives.

live-patching@vger.kernel.org would also be a good idea for this one.

On Thu, Oct 15, 2020 at 04:49:51PM +0100, Mark Brown wrote:
> On Thu, Oct 15, 2020 at 03:16:12PM +0100, Mark Rutland wrote:
> > On Thu, Oct 15, 2020 at 03:39:37PM +0200, Miroslav Benes wrote:
> 
> > > I'll just copy an excerpt from my notes about the required guarantees. 
> > > Written by Josh (CCed, he has better idea about the problem than me 
> > > anyway).
> 
> > > It also needs to:
> > > - detect preemption / page fault frames and return an error
> > > - only return success if it reaches the end of the task stack; for user
> > >   tasks, that means the syscall barrier; for kthreads/idle tasks, that
> > >   means finding a defined thread entry point
> > > - make sure it can't get into a recursive loop
> > > - make sure each return address is a valid text address
> > > - properly detect generated code hacks like function graph tracing and
> > >   kretprobes
> > > "
> 
> > It would be great if we could put something like the above into the
> > kernel tree, either under Documentation/ or in a comment somewhere for
> > the reliable stacktrace functions.
> 
> Yes, please - the expecations are quite hard to follow at the minute,
> implementing it involves quite a bit of guesswork and cargo culting to
> figure out what the APIs are supposed to do.

Documentation is indeed long overdue.  I suppose everyone's looking at
me.  I can do that, but my bandwidth's limited for at least a few weeks.

[ Currently in week 4 of traveling cross-country with a camper
  ("caravan" in British-speak?), National Lampoon vacation style. ]

If by cargo culting, you mean reverse engineering the requirements due
to lack of documentation, that's fair.

Otherwise, if you see anything that doesn't make sense or that can be
improved, let me know.

> > AFAICT, existing architectures don't always handle all of the above in
> > arch_stack_walk_reliable(). For example, it looks like x86 assumes
> > unwiding through exceptions is reliable for !CONFIG_FRAME_POINTER, but I
> > think this might not always be true.

Why not?

What else are the existing arches missing from the above list?

> I certainly wouldn't have inferred the list from what's there :/

Fair, presumably because of missing documentation.

> The searching for a defined thread entry point for example isn't
> entirely visible in the implementations.

For now I'll speak only of x86, because I don't quite remember how
powerpc does it.

For thread entry points, aka the "end" of the stack:

- For ORC, the end of the stack is either pt_regs, or -- when unwinding
  from kthreads, idle tasks, or irqs/exceptions in entry code --
  UNWIND_HINT_EMPTY (found by the unwinder's check for orc->end.

  [ Admittedly the implementation needs to be cleaned up a bit.  EMPTY
    is too broad and needs to be split into UNDEFINED and ENTRY. ]

- For frame pointers, by convention, the end of the stack for all tasks
  is a defined stack offset: end of stack page - sizeof(pt_regs).

And yes, all that needs to be documented.

-- 
Josh

