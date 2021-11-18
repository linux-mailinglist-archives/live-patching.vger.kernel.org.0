Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE1545555A
	for <lists+live-patching@lfdr.de>; Thu, 18 Nov 2021 08:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbhKRHSy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Nov 2021 02:18:54 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51796 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243773AbhKRHSZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Nov 2021 02:18:25 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F39BD1FD35;
        Thu, 18 Nov 2021 07:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637219724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Mr/E/XvORtR80K5LI+JFm08oBLxIXXIo2at3Nc1HYo=;
        b=2MW+eYwtDY5kIdnlvcnTekTMB91Gdnw8D5VSkIn7ihg5kXK32i0EBGGZJNWw5sC8QEToSE
        jNzXeIYiL1Zza+5aC55SA+h3jDzqKxc4xEEJW81GTtHySJNpK6/upO5flzMwkq4mlTrQX/
        C8Pjrnlm/2l+nBZiTaCJRQmqSTWUSUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637219724;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Mr/E/XvORtR80K5LI+JFm08oBLxIXXIo2at3Nc1HYo=;
        b=XbPKGLpGtBVlEt+Izfix5XlERcVatM7+yGY2iBZ5rtyHOXemiClt9spvCj8mMTbucOKPEl
        jrfS70KBxu0T3CCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C22FEA3B83;
        Thu, 18 Nov 2021 07:15:23 +0000 (UTC)
Date:   Thu, 18 Nov 2021 08:15:23 +0100 (CET)
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
        live-patching@vger.kernel.org, nstange@suse.de
Subject: Re: [PATCH 20/22] x86,word-at-a-time: Remove .fixup usage
In-Reply-To: <20211115230737.27gqnzwvkaxoi7es@treble>
Message-ID: <alpine.LSU.2.21.2111180811370.16632@pobox.suse.cz>
References: <YYov8SVHk/ZpFsUn@hirez.programming.kicks-ass.net> <CAKwvOdn8yrRopXyfd299=SwZS9TAPfPj4apYgdCnzPb20knhbg@mail.gmail.com> <20211109210736.GV174703@worktop.programming.kicks-ass.net> <f6dbe42651e84278b44e44ed7d0ed74f@AcuMS.aculab.com>
 <YYuogZ+2Dnjyj1ge@hirez.programming.kicks-ass.net> <2734a37ebed2432291345aaa8d9fd47e@AcuMS.aculab.com> <20211112015003.pefl656m3zmir6ov@treble> <YY408BW0phe9I1/o@hirez.programming.kicks-ass.net> <20211113053500.jcnx5airbn7g763a@treble>
 <alpine.LSU.2.21.2111151353550.29981@pobox.suse.cz> <20211115230737.27gqnzwvkaxoi7es@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 16 Nov 2021, Josh Poimboeuf wrote:

> On Mon, Nov 15, 2021 at 01:59:36PM +0100, Miroslav Benes wrote:
> > On Fri, 12 Nov 2021, Josh Poimboeuf wrote:
> > 
> > > If the child schedules out, and then the parent gets patched, things can
> > > go off-script if the child later jumps back to the unpatched version of
> > > the parent, and then for example the old parent tries to call another
> > > patched function with a since-changed ABI.
> > 
> > ...
> >  
> > > I don't know about other patch creation tooling, but I'd imagine they
> > > also need to know about .cold functions, unless they have that
> > > optimization disabled.  Because the func and its .cold counterpart
> > > always need to be patched together.
> > 
> > We, at SUSE, solve the issue differently... the new patched parent would 
> > call that another patched function with a changed ABI statically in a live 
> > patch. So in that example, .cold child would jump back to the unpatched 
> > parent which would then call, also, the unpatched function.
> 
> So if I understand correctly, if a function's ABI changes then you don't
> patch it directly, but only patch its callers to call the replacement?

Yes.
 
> Is there a reason for that?

Not really. There were a couple of cases in the past where this was safer 
to implement and then it became a habbit, I guess.

[ Nicolai CCed, if he wants to add more details ]

Miroslav
