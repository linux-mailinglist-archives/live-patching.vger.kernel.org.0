Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD49452B8B
	for <lists+live-patching@lfdr.de>; Tue, 16 Nov 2021 08:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhKPH2u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 16 Nov 2021 02:28:50 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42328 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhKPH2b (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 16 Nov 2021 02:28:31 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1047E1FC9E;
        Tue, 16 Nov 2021 07:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637047532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmZk/HXJcieKLADN5O3iVOd17jesS1JuFRBvZjGN0po=;
        b=eFnCKq2FUzEnwqfnwnj9nXV6mPrw/RO2dUTePqD1QM2aPAAUx2BMLAfP/x4wVfim2rAVo2
        OaI6eVy7rAF4gKyypx9Faeu24qLz4/YoWw/zQL1GjYrXW+yrKyCAA6wZMomM3wUL0vCsAK
        0IXMvE+KARU/CzPrPblStCKA4X/WVTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637047532;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmZk/HXJcieKLADN5O3iVOd17jesS1JuFRBvZjGN0po=;
        b=hM/7n8Nfl+ah9PMKi1+q7LVzUAmKNsP7qamfs5KSu0nZGEbmdrP01cl6WTBNUouDqvCENK
        Iunr4hegpRKGm3Dg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BD75BA3B87;
        Tue, 16 Nov 2021 07:25:31 +0000 (UTC)
Date:   Tue, 16 Nov 2021 08:25:31 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 20/22] x86,word-at-a-time: Remove .fixup usage
In-Reply-To: <20211115230327.m3zswzgrshotocju@treble>
Message-ID: <alpine.LSU.2.21.2111160823350.2250@pobox.suse.cz>
References: <CAKwvOdn8yrRopXyfd299=SwZS9TAPfPj4apYgdCnzPb20knhbg@mail.gmail.com> <20211109210736.GV174703@worktop.programming.kicks-ass.net> <f6dbe42651e84278b44e44ed7d0ed74f@AcuMS.aculab.com> <YYuogZ+2Dnjyj1ge@hirez.programming.kicks-ass.net>
 <2734a37ebed2432291345aaa8d9fd47e@AcuMS.aculab.com> <20211112015003.pefl656m3zmir6ov@treble> <YY408BW0phe9I1/o@hirez.programming.kicks-ass.net> <20211113053500.jcnx5airbn7g763a@treble> <alpine.LSU.2.21.2111151325390.29981@pobox.suse.cz>
 <68b37450-d4bd-fa46-7bad-08d237e922b1@redhat.com> <20211115230327.m3zswzgrshotocju@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 15 Nov 2021, Josh Poimboeuf wrote:

> On Mon, Nov 15, 2021 at 08:01:13AM -0500, Joe Lawrence wrote:
> > > This reminded me... one of the things I have on my todo list for a long 
> > > time is to add an option for a live patch creator to specify functions 
> > > which are not contained in the live patch but their presence on stacks 
> > > should be checked for. It could save some space in the final live patch 
> > > when one would add functions (callers) just because the consistency 
> > > requires it.
> > > 
> > 
> > Yea, I've used this technique once (adding a nop to a function so
> > kpatch-build would detect and include in klp_funcs[]) to make a set of
> > changes safer with respect to the consistency model.  Making it simpler
> > to for the livepatch author to say, "I'm not changing foo(), but I don't
> > want it doing anything while patching a task" sounds reasonable.
> > 
> > > I took as a convenience feature with a low priority and forgot about it. 
> > > The problem above changes it. So should we take the opportunity and 
> > > implement both in one step? I wanted to include a list of functions in 
> > > on a patch level (klp_patch structure) and klp_check_stack() would just 
> > > have more to check.
> > > 
> > 
> > As far as I read the original problem, I think it would solve for that,
> > too, so I would say go for it.
> 
> Sounds good to me.
> 
> Miroslav, do I understand correctly that you're volunteering to make
> this change? ;-)

Yes, you do. I am not superfast peterz, so it will take some time, but 
I'll be happy to do it :).

Miroslav
