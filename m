Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ACB459434
	for <lists+live-patching@lfdr.de>; Mon, 22 Nov 2021 18:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhKVRt5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Nov 2021 12:49:57 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:41414 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhKVRt4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Nov 2021 12:49:56 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 63D89218D9;
        Mon, 22 Nov 2021 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637603208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IVyCpk3Enlbt6FlcDd28jnmXorqsQH3XWfqrWEWV2RQ=;
        b=pv3Kg2WGahcnYOPDpoAePsmS/PpntbddIc9ju0hKOg9AtndhWdb+TGNSicv8VAaF0R4YnM
        4RLlVCvUgsN1NQhFTqmK8oJp7NqtJvRU5c3ExiLc/IumE99XCpZlOf+gucq4ZqpS3nBg/X
        aDiCBmwFS4gbasy/nX0rlD1ZbAvp3Q4=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2432DA3B85;
        Mon, 22 Nov 2021 17:46:48 +0000 (UTC)
Date:   Mon, 22 Nov 2021 18:46:44 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 20/22] x86,word-at-a-time: Remove .fixup usage
Message-ID: <YZvXhAYjHrnc3/rv@alley>
References: <20211108164711.mr2cqdcvedin2lvx@treble>
 <YYlshkTmf5zdvf1Q@hirez.programming.kicks-ass.net>
 <CAKwvOdkFZ4PSN0GGmKMmoCrcp7_VVNjau_b0sNRm3MuqVi8yow@mail.gmail.com>
 <YYov8SVHk/ZpFsUn@hirez.programming.kicks-ass.net>
 <CAKwvOdn8yrRopXyfd299=SwZS9TAPfPj4apYgdCnzPb20knhbg@mail.gmail.com>
 <20211109210736.GV174703@worktop.programming.kicks-ass.net>
 <f6dbe42651e84278b44e44ed7d0ed74f@AcuMS.aculab.com>
 <YYuogZ+2Dnjyj1ge@hirez.programming.kicks-ass.net>
 <2734a37ebed2432291345aaa8d9fd47e@AcuMS.aculab.com>
 <20211112015003.pefl656m3zmir6ov@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112015003.pefl656m3zmir6ov@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-11-11 17:50:03, Josh Poimboeuf wrote:
> On Wed, Nov 10, 2021 at 12:20:47PM +0000, David Laight wrote:
> > > > Wouldn't moving part of a function to .text.cold (or .text.unlikely)
> > > > generate the same problems with the stack backtrace code as the
> > > > .text.fixup section you are removing had??
> > > 
> > > GCC can already split a function into func and func.cold today (or
> > > worse: func, func.isra.N, func.cold, func.isra.N.cold etc..).
> > > 
> > > I'm assuming reliable unwind and livepatch know how to deal with this.
> > 
> > They'll have 'proper' function labels at the top - so backtrace
> > stands a chance.
> > Indeed you (probably) want it to output "func.irsa.n.cold" rather
> > than just "func" to help show which copy it is in.  > 
> > I guess that livepatch will need separate patches for each
> > version of the function - which might be 'interesting' if
> > all the copies actually need patching at the same time.
> > You'd certainly want a warning if there seemed to be multiple
> > copies of the function.
> 
> Hm, I think there is actually a livepatch problem here.
> 
> If the .cold (aka "child") function actually had a fentry hook then we'd
> be fine.  Then we could just patch both "parent" and "child" functions
> at the same time.  We already have the ability to patch multiple
> functions having dependent interface changes.
> 
> But there's no fentry hook in the child, so we can only patch the
> parent.
> 
> If the child schedules out, and then the parent gets patched, things can
> go off-script if the child later jumps back to the unpatched version of
> the parent, and then for example the old parent tries to call another
> patched function with a since-changed ABI.

This thread seems to be motivation for the patchset
https://lore.kernel.org/all/20211119090327.12811-1-mbenes@suse.cz/
I am trying to understand the problem here, first. And I am
a bit lost.

How exactly is child called in the above scenario, please?
How could parent get livepatched when child is sleeping?

I imagine it the following way:

    parent_func()
       fentry

       /* some parent code */
       jmp child
	   /* child code */
	   jmp back_to_parent
       /* more parent code */
       ret

In the above example, parent_func() would be on stack and could not
get livepatched even when the process is sleeping in the child code.

The livepatching is done via ftrace. Only code with fentry could be
livepatched. And code called via fentry must be visible on stack.


Anyway, this looks to me like yet another compiler optimization where
we need to livepatch the callers. The compiler might produce completely
different optimizations for the new code. I do not see a reasonable
way how to create compatible func, func.isra.N, func.cold,
func.isra.N.cold variants.

Best Regards,
Petr
