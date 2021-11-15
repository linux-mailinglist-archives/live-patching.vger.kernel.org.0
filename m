Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7149F450482
	for <lists+live-patching@lfdr.de>; Mon, 15 Nov 2021 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhKOMjq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Nov 2021 07:39:46 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52184 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKOMjX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Nov 2021 07:39:23 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A66811FD43;
        Mon, 15 Nov 2021 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636979781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0a3HM55iSUahbtbOkMShQHEby0rQ6WJrVZvXete502Q=;
        b=aOMVnsbjjUbZgyyMHdgG6GOgNd0KzBJbo186hUAYYhv62+tqkacTm4+eq1YExTodNdsvX/
        gSpg6U0mRu+YYFDh3S0tuDXOz9ZDpkYX7TWI3E2lcRWNdoAiWA1D/J5d9DfEaoHDjdE71s
        JSk+AXpcABNJH8xF2otjZx54cNXJKzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636979781;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0a3HM55iSUahbtbOkMShQHEby0rQ6WJrVZvXete502Q=;
        b=OUPr8NCsXCrdkSKNjNwkeyni6rHSuvzinD+d4aXgJx1Bx8zLagBq2RshRkYklonJNOK58D
        9ydl85kMmMVyGNDA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 673D5A3B81;
        Mon, 15 Nov 2021 12:36:21 +0000 (UTC)
Date:   Mon, 15 Nov 2021 13:36:21 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20211113053500.jcnx5airbn7g763a@treble>
Message-ID: <alpine.LSU.2.21.2111151325390.29981@pobox.suse.cz>
References: <YYlshkTmf5zdvf1Q@hirez.programming.kicks-ass.net> <CAKwvOdkFZ4PSN0GGmKMmoCrcp7_VVNjau_b0sNRm3MuqVi8yow@mail.gmail.com> <YYov8SVHk/ZpFsUn@hirez.programming.kicks-ass.net> <CAKwvOdn8yrRopXyfd299=SwZS9TAPfPj4apYgdCnzPb20knhbg@mail.gmail.com>
 <20211109210736.GV174703@worktop.programming.kicks-ass.net> <f6dbe42651e84278b44e44ed7d0ed74f@AcuMS.aculab.com> <YYuogZ+2Dnjyj1ge@hirez.programming.kicks-ass.net> <2734a37ebed2432291345aaa8d9fd47e@AcuMS.aculab.com> <20211112015003.pefl656m3zmir6ov@treble>
 <YY408BW0phe9I1/o@hirez.programming.kicks-ass.net> <20211113053500.jcnx5airbn7g763a@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 12 Nov 2021, Josh Poimboeuf wrote:

> On Fri, Nov 12, 2021 at 10:33:36AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 11, 2021 at 05:50:03PM -0800, Josh Poimboeuf wrote:
> > 
> > > Hm, I think there is actually a livepatch problem here.
> > 
> > I suspected as much, because I couldn't find any code dealing with it
> > when I looked in a hurry.. :/
> > 
> > > Some ideas to fix:
> > 
> > > c) Update the reliable stacktrace code to mark the stack unreliable if
> > >    it has a function with ".cold" in the name?
> > 
> > Why not simply match func.cold as func in the transition thing? Then
> > func won't get patched as long as it (or it's .cold part) is in use.
> > This seems like the natural thing to do.
> 
> Well yes, you're basically hinting at my first two options a and b:
> 
> a) Add a field to 'klp_func' which allows the patch module to specify a
>    function's .cold counterpart?
> 
> b) Detect such cold counterparts in klp_enable_patch()?  Presumably it
>    would require searching kallsyms for "<func>.cold", which is somewhat
>    problematic as there might be duplicates.
> 
> It's basically a two-step process:  1) match func to .cold if it exists;
> 2) check for both in klp_check_stack_func().  The above two options are
> proposals for the 1st step.  The 2nd step was implied.

This reminded me... one of the things I have on my todo list for a long 
time is to add an option for a live patch creator to specify functions 
which are not contained in the live patch but their presence on stacks 
should be checked for. It could save some space in the final live patch 
when one would add functions (callers) just because the consistency 
requires it.

I took as a convenience feature with a low priority and forgot about it. 
The problem above changes it. So should we take the opportunity and 
implement both in one step? I wanted to include a list of functions in 
on a patch level (klp_patch structure) and klp_check_stack() would just 
have more to check.

Miroslav
