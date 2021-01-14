Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B092F683F
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 18:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbhANRuX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 12:50:23 -0500
Received: from foss.arm.com ([217.140.110.172]:53776 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbhANRuW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 12:50:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCDB6D6E;
        Thu, 14 Jan 2021 09:49:36 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.42.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 606D73F70D;
        Thu, 14 Jan 2021 09:49:34 -0800 (PST)
Date:   Thu, 14 Jan 2021 17:49:32 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210114174932.GD2739@C02TD0UTHF1T.local>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210114115418.GB2739@C02TD0UTHF1T.local>
 <20210114143650.nsqhejalpk4k5qfl@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114143650.nsqhejalpk4k5qfl@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 14, 2021 at 08:36:50AM -0600, Josh Poimboeuf wrote:
> On Thu, Jan 14, 2021 at 11:54:18AM +0000, Mark Rutland wrote:
> > On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> > > On Wed, Jan 13, 2021 at 04:57:43PM +0000, Mark Brown wrote:
> > > > From: Mark Rutland <mark.rutland@arm.com>
> > > > +There are several ways an architecture may identify kernel code which is deemed
> > > > +unreliable to unwind from, e.g.
> > > > +
> > > > +* Using metadata created by objtool, with such code annotated with
> > > > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
> > > 
> > > I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> > > necessarily mean the code is unreliable, and objtool doesn't treat it as
> > > such.  Its mention can probably be removed unless there was some other
> > > point I'm missing.
> >
> > > Also, s/STACKFRAME/STACK_FRAME/

Given that (per the discussion below) STACK_FRAME_NON_STANDARD() also
doesn't result in objtool producing anything special metadata (and such
code is still expected to be unwindable), I believe we can delete this
bullet point outright?

> > When I wrote this, I was under the impression that (for x86) code marked
> > as SYM_CODE_{START,END} wouldn't be considered as a function by objtool.
> > Specifically SYM_FUNC_END() marks the function with SYM_T_FUNC whereas
> > SYM_CODE_END() marks it with SYM_T_NONE, and IIRC I thought that objtool
> > only generated ORC for SYM_T_FUNC functions, and hence anything else
> > would be considered not unwindable due to the absence of ORC.
> > 
> > Just to check, is that understanding for x86 correct, or did I get that
> > wrong?
> 
> Doh, I suppose you read the documentation ;-)

I think I skimmed the objtool source, too, but it was a while back. ;)

> I realize your understanding is pretty much consistent with
> tools/objtool/Documentation/stack-validation.txt:
> 
> 2. Conversely, each section of code which is *not* callable should *not*
>    be annotated as an ELF function.  The ENDPROC macro shouldn't be used
>    in this case.
> 
>    This rule is needed so that objtool can ignore non-callable code.
>    Such code doesn't have to follow any of the other rules.
> 
> But this statement is no longer true:
> 
>   **This rule is needed so that objtool can ignore non-callable code.**
> 
> [ and it looks like the ENDPROC reference is also out of date ]

Ok -- looks like that needs an update!

> Since that document was written, around the time ORC was written we
> realized objtool shouldn't ignore SYM_CODE after all.  That way we can
> get full coverage for ORC (including interrupts/exceptions), as well as
> some of the other validations like retpoline, uaccess, noinstr, etc.
> 
> Though it's still true that SYM_CODE doesn't have to follow the
> function-specific rules, e.g. frame pointers.

Ok; I suspect on the arm64 side we'll need to think a bit harder about
what that means for us. I guess that'll influence or interact with
whatever support we need specifically in objtool.

> So now objtool requires that it be able to traverse and understand *all*
> code, otherwise it will spit out "unreachable instruction" warnings.
> But since SYM_CODE isn't a normal callable function, objtool doesn't
> know to interpret it directly.  Therefore all SYM_CODE must be reachable
> by objtool in some other way:
> 
> - either indirectly, via a jump from a SYM_FUNC; or
> 
> - via an UNWIND_HINT
> 
> (And that's true for both ORC and frame pointers.)
> 
> If you look closely at arch/x86/entry/entry_64.S you should be able to
> see that's the case.

Assuming you mean the UNWIND_HINT_EMPTY at the start of each exception
entry point, I think I follow.

> > If that's right, it might be worth splitting this into two points, e.g.
> > 
> > | * Using metadata created by objtool, with such code annotated with
> > |   STACKFRAME_NON_STANDARD().
> > |
> > |
> > | * Using ELF symbol attributes, with such code annotated with
> > |   SYM_CODE_{START,END}, and not having a function type.
> > 
> > If that's wrong, I suspect there are latent issues here?
> 
> For ORC, UNWIND_HINT_EMPTY is used to annotate that some code is
> non-unwindable.  (Note I have plans to split that into UNWIND_HINT_ENTRY
> and UNWIND_HINT_UNDEFINED.)

Interesting; where would the UNDEFINED case be used?

> For frame pointers, the hints aren't used, other than by objtool to
> follow the code flow as described above.  But objtool doesn't produce
> any metadata for the FP unwinder.  Instead the FP unwinder makes such
> determinations about unwindability at runtime.

I suspect for arm64 with frame pointers we'll need a fair amount of
special casing for the entry code; I'll have a think offline.

Thanks,
Mark.
