Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2712F6BC1
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 21:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbhANUFE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 15:05:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730442AbhANUFE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 15:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610654617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HpNvJaw5SGQOpvSB4p7vktWYcMVdtuSl93krDsAW8gY=;
        b=PTVhewum2ni0013uWkRiq56USkifdQ6zJgJjeLYJqmeYoXiVtUxeHMaqeSV5WX2gD3Odvn
        ti9ojtBs1kRt2W56qgH/ck07Y4r0S4tj3aaddJaRji0tRzrsF3XD4QT3bfEr0x1jx97PuI
        bTfSSlxF4fgf/bINkG1BLWZOsb+XWH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-Y5Do79eyPGWaOCQ76KT3qg-1; Thu, 14 Jan 2021 15:03:33 -0500
X-MC-Unique: Y5Do79eyPGWaOCQ76KT3qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7D1A803F41;
        Thu, 14 Jan 2021 20:03:31 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEF0E100AE41;
        Thu, 14 Jan 2021 20:03:25 +0000 (UTC)
Date:   Thu, 14 Jan 2021 14:03:16 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210114200316.2hc3wmsoyzafxzm2@treble>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210114115418.GB2739@C02TD0UTHF1T.local>
 <20210114143650.nsqhejalpk4k5qfl@treble>
 <20210114174932.GD2739@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114174932.GD2739@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 14, 2021 at 05:49:32PM +0000, Mark Rutland wrote:
> On Thu, Jan 14, 2021 at 08:36:50AM -0600, Josh Poimboeuf wrote:
> > On Thu, Jan 14, 2021 at 11:54:18AM +0000, Mark Rutland wrote:
> > > On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> > > > On Wed, Jan 13, 2021 at 04:57:43PM +0000, Mark Brown wrote:
> > > > > From: Mark Rutland <mark.rutland@arm.com>
> > > > > +There are several ways an architecture may identify kernel code which is deemed
> > > > > +unreliable to unwind from, e.g.
> > > > > +
> > > > > +* Using metadata created by objtool, with such code annotated with
> > > > > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
> > > > 
> > > > I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> > > > necessarily mean the code is unreliable, and objtool doesn't treat it as
> > > > such.  Its mention can probably be removed unless there was some other
> > > > point I'm missing.
> > >
> > > > Also, s/STACKFRAME/STACK_FRAME/
> 
> Given that (per the discussion below) STACK_FRAME_NON_STANDARD() also
> doesn't result in objtool producing anything special metadata (and such
> code is still expected to be unwindable), I believe we can delete this
> bullet point outright?

With ORC, UNWIND_HINT_EMPTY can be used to mark missing ORC metadata,
which the unwinder translates as unreliable.  So that may be worth
mentioning.

> > I realize your understanding is pretty much consistent with
> > tools/objtool/Documentation/stack-validation.txt:
> > 
> > 2. Conversely, each section of code which is *not* callable should *not*
> >    be annotated as an ELF function.  The ENDPROC macro shouldn't be used
> >    in this case.
> > 
> >    This rule is needed so that objtool can ignore non-callable code.
> >    Such code doesn't have to follow any of the other rules.
> > 
> > But this statement is no longer true:
> > 
> >   **This rule is needed so that objtool can ignore non-callable code.**
> > 
> > [ and it looks like the ENDPROC reference is also out of date ]
> 
> Ok -- looks like that needs an update!

Added to the TODO list!

> > Since that document was written, around the time ORC was written we
> > realized objtool shouldn't ignore SYM_CODE after all.  That way we can
> > get full coverage for ORC (including interrupts/exceptions), as well as
> > some of the other validations like retpoline, uaccess, noinstr, etc.
> > 
> > Though it's still true that SYM_CODE doesn't have to follow the
> > function-specific rules, e.g. frame pointers.
> 
> Ok; I suspect on the arm64 side we'll need to think a bit harder about
> what that means for us. I guess that'll influence or interact with
> whatever support we need specifically in objtool.
> 
> > So now objtool requires that it be able to traverse and understand *all*
> > code, otherwise it will spit out "unreachable instruction" warnings.
> > But since SYM_CODE isn't a normal callable function, objtool doesn't
> > know to interpret it directly.  Therefore all SYM_CODE must be reachable
> > by objtool in some other way:
> > 
> > - either indirectly, via a jump from a SYM_FUNC; or

This should say "via a jump from some code objtool already knows about:
either a SYM_FUNC or a SYM_CODE with UNWIND_HINTs".

> > 
> > - via an UNWIND_HINT
> > 
> > (And that's true for both ORC and frame pointers.)
> > 
> > If you look closely at arch/x86/entry/entry_64.S you should be able to
> > see that's the case.
> 
> Assuming you mean the UNWIND_HINT_EMPTY at the start of each exception
> entry point, I think I follow.

Also see for example common_interrupt_return(), which doesn't have an
UNWIND_HINT right away, but is still reachable from other code which
objtool already knows about via
the 'swapgs_restore_regs_and_return_to_usermode' label.

> > > If that's right, it might be worth splitting this into two points, e.g.
> > > 
> > > | * Using metadata created by objtool, with such code annotated with
> > > |   STACKFRAME_NON_STANDARD().
> > > |
> > > |
> > > | * Using ELF symbol attributes, with such code annotated with
> > > |   SYM_CODE_{START,END}, and not having a function type.
> > > 
> > > If that's wrong, I suspect there are latent issues here?
> > 
> > For ORC, UNWIND_HINT_EMPTY is used to annotate that some code is
> > non-unwindable.  (Note I have plans to split that into UNWIND_HINT_ENTRY
> > and UNWIND_HINT_UNDEFINED.)
> 
> Interesting; where would the UNDEFINED case be used?

UNDEFINED would be some code which is either unreachable (like the
middle of a retpoline) or otherwise not annotated (like
STACK_FRAME_NON_STANDARD).

> > For frame pointers, the hints aren't used, other than by objtool to
> > follow the code flow as described above.  But objtool doesn't produce
> > any metadata for the FP unwinder.  Instead the FP unwinder makes such
> > determinations about unwindability at runtime.
> 
> I suspect for arm64 with frame pointers we'll need a fair amount of
> special casing for the entry code; I'll have a think offline.

I'd be happy to help with this.  It may end up easier for me to learn
your entry code than for you to learn the expectations of my tool ;-)

-- 
Josh

