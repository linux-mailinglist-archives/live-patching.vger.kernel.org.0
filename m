Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884612F634B
	for <lists+live-patching@lfdr.de>; Thu, 14 Jan 2021 15:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbhANOi2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 09:38:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727283AbhANOi1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 09:38:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610635020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4up8iL2UjGLCCTseIriUTgakG+YpC7Jv5oAbQ6UAgWE=;
        b=Ia4TkkDdVxKuxIygivRhBCh0BBuoofm4RzebVr9eL7JKdzks95JtSgv7TAm/pXs0Bhlpnd
        M1TPViE1y3aqxLX2S9No5XVyIAMPptu+DLM94PDqeut6R/yqj/GdahiwlWqN73qAzwglu6
        bm/KFdv82Xl1vQnncRC+XeI5zbScPHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-BNY-NKKPMtmOnee4wvRguA-1; Thu, 14 Jan 2021 09:36:59 -0500
X-MC-Unique: BNY-NKKPMtmOnee4wvRguA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 413841DDE4;
        Thu, 14 Jan 2021 14:36:57 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE3EA5D9E2;
        Thu, 14 Jan 2021 14:36:52 +0000 (UTC)
Date:   Thu, 14 Jan 2021 08:36:50 -0600
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
Message-ID: <20210114143650.nsqhejalpk4k5qfl@treble>
References: <20210113165743.3385-1-broonie@kernel.org>
 <20210113192735.rg2fxwlfrzueinci@treble>
 <20210114115418.GB2739@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114115418.GB2739@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 14, 2021 at 11:54:18AM +0000, Mark Rutland wrote:
> On Wed, Jan 13, 2021 at 01:33:13PM -0600, Josh Poimboeuf wrote:
> > On Wed, Jan 13, 2021 at 04:57:43PM +0000, Mark Brown wrote:
> > > From: Mark Rutland <mark.rutland@arm.com>
> > > +There are several ways an architecture may identify kernel code which is deemed
> > > +unreliable to unwind from, e.g.
> > > +
> > > +* Using metadata created by objtool, with such code annotated with
> > > +  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
> > 
> > I'm not sure why SYM_CODE_{START,END} is mentioned here, but it doesn't
> > necessarily mean the code is unreliable, and objtool doesn't treat it as
> > such.  Its mention can probably be removed unless there was some other
> > point I'm missing.
> > 
> > Also, s/STACKFRAME/STACK_FRAME/
> 
> When I wrote this, I was under the impression that (for x86) code marked
> as SYM_CODE_{START,END} wouldn't be considered as a function by objtool.
> Specifically SYM_FUNC_END() marks the function with SYM_T_FUNC whereas
> SYM_CODE_END() marks it with SYM_T_NONE, and IIRC I thought that objtool
> only generated ORC for SYM_T_FUNC functions, and hence anything else
> would be considered not unwindable due to the absence of ORC.
> 
> Just to check, is that understanding for x86 correct, or did I get that
> wrong?

Doh, I suppose you read the documentation ;-)

I realize your understanding is pretty much consistent with
tools/objtool/Documentation/stack-validation.txt:

2. Conversely, each section of code which is *not* callable should *not*
   be annotated as an ELF function.  The ENDPROC macro shouldn't be used
   in this case.

   This rule is needed so that objtool can ignore non-callable code.
   Such code doesn't have to follow any of the other rules.

But this statement is no longer true:

  **This rule is needed so that objtool can ignore non-callable code.**

[ and it looks like the ENDPROC reference is also out of date ]

Since that document was written, around the time ORC was written we
realized objtool shouldn't ignore SYM_CODE after all.  That way we can
get full coverage for ORC (including interrupts/exceptions), as well as
some of the other validations like retpoline, uaccess, noinstr, etc.

Though it's still true that SYM_CODE doesn't have to follow the
function-specific rules, e.g. frame pointers.

So now objtool requires that it be able to traverse and understand *all*
code, otherwise it will spit out "unreachable instruction" warnings.
But since SYM_CODE isn't a normal callable function, objtool doesn't
know to interpret it directly.  Therefore all SYM_CODE must be reachable
by objtool in some other way:

- either indirectly, via a jump from a SYM_FUNC; or

- via an UNWIND_HINT

(And that's true for both ORC and frame pointers.)

If you look closely at arch/x86/entry/entry_64.S you should be able to
see that's the case.

> If that's right, it might be worth splitting this into two points, e.g.
> 
> | * Using metadata created by objtool, with such code annotated with
> |   STACKFRAME_NON_STANDARD().
> |
> |
> | * Using ELF symbol attributes, with such code annotated with
> |   SYM_CODE_{START,END}, and not having a function type.
> 
> If that's wrong, I suspect there are latent issues here?

For ORC, UNWIND_HINT_EMPTY is used to annotate that some code is
non-unwindable.  (Note I have plans to split that into UNWIND_HINT_ENTRY
and UNWIND_HINT_UNDEFINED.)

For frame pointers, the hints aren't used, other than by objtool to
follow the code flow as described above.  But objtool doesn't produce
any metadata for the FP unwinder.  Instead the FP unwinder makes such
determinations about unwindability at runtime.

-- 
Josh

