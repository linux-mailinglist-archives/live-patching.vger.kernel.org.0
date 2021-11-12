Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB5444E3DE
	for <lists+live-patching@lfdr.de>; Fri, 12 Nov 2021 10:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhKLJgw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 12 Nov 2021 04:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhKLJgv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 12 Nov 2021 04:36:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6C2C061766;
        Fri, 12 Nov 2021 01:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=REVGkF6eRn7+YtrHq8BUhmi5Kq0utPzdhrc+6SzJFmk=; b=DpB9UYET5QhlpaVmJgZCs2Yiv0
        s9Mm5Z4cog+M2JmVa0m51tMwz9b+1XutM7gMfcBxnlHSmusR02rK4phHZpqfM2ZqxcbT4qqOSfVdv
        o2FpU/rnEh8eFJu8d5maB0RBQ4Kf314oNaZvn1cfQw88sl6Xgqn07oaebzi4XSJLg7MHlUVkBLLmn
        fwQUFLW6au+ESNDo3hNsAE4OYC1KBWAPLgzuhCN52fsTDvtbd5QmIh76c+7sB7THxFi2QHca1wSBP
        ib3ozkopKRH9NveRJXscWxOdkgQo4fIKWoaPvE6kNDbuJ38ovq3t83y52ssRBR2TiSUXz7eAf6PEO
        UuJAbJrg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlSwE-00FbY0-1k; Fri, 12 Nov 2021 09:33:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C232330001C;
        Fri, 12 Nov 2021 10:33:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9E08E20DC06DC; Fri, 12 Nov 2021 10:33:36 +0100 (CET)
Date:   Fri, 12 Nov 2021 10:33:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
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
Message-ID: <YY408BW0phe9I1/o@hirez.programming.kicks-ass.net>
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

On Thu, Nov 11, 2021 at 05:50:03PM -0800, Josh Poimboeuf wrote:

> Hm, I think there is actually a livepatch problem here.

I suspected as much, because I couldn't find any code dealing with it
when I looked in a hurry.. :/

> Some ideas to fix:

> c) Update the reliable stacktrace code to mark the stack unreliable if
>    it has a function with ".cold" in the name?

Why not simply match func.cold as func in the transition thing? Then
func won't get patched as long as it (or it's .cold part) is in use.
This seems like the natural thing to do.

If there are enough .cold functions, always reporting stacktrace as
unreliable will make progress hard, even though it might be perfectly
safe.

> e) Disable .cold optimization?

Yeah, lets not do that. That'll have me lobbying to kill KLP again
because it generates crap code.
