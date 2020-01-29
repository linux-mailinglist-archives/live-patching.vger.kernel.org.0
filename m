Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12C714C424
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2020 01:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgA2ArC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 19:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgA2ArB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 19:47:01 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE5D92073A;
        Wed, 29 Jan 2020 00:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580258821;
        bh=HlE3Pgkk7dDEKRsCD3nPkyOTqjP2QeWR8StyZLq5bEU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ejFuWz0R0R5TUCGRjF1ncZbRCpNQnOzeg4EbChz9OwyAw/MXIMQ0RSbDFvmatWHiN
         p2yt1ooPKKzdqA08a1zpdEFEkZnsraGQGqnIpixjfh2zWKgVH0MT5+3zncz83HVsYd
         BHKAm0jnw6VbpsPEdkGqJTfVrhTdl+8+n222325Q=
Date:   Wed, 29 Jan 2020 01:46:55 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20200128170254.igb72ib5n7lvn3ds@treble>
Message-ID: <nycvar.YFH.7.76.2001290141140.31058@cbobk.fhfr.pm>
References: <20191016074217.GL2328@hirez.programming.kicks-ass.net> <20191021150549.bitgqifqk2tbd3aj@treble> <20200120165039.6hohicj5o52gdghu@treble> <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz> <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz> <20200122214239.ivnebi7hiabi5tbs@treble> <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz> <20200128150014.juaxfgivneiv6lje@treble> <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
 <20200128170254.igb72ib5n7lvn3ds@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 28 Jan 2020, Josh Poimboeuf wrote:

> > Anyway, I think that we might make your life easier with using the 
> > proposed -Wsuggest-attribute=noreturn.
> 
> Maybe.  Though if I understand correctly, this doesn't help for any of 
> the new warnings because they're for static functions, and this only 
> warns about global functions.

Could you please provide a pointer where those have been 
reported/analyzed?

For the cases I've seen so far, it has always been gcc deciding under 
certain circumstances not to propagate __attribute__((__noreturn__)) from 
callee to caller even in the cases when caller unconditionally called 
callee.

AFAIU, the behavior is (and always will) be dependent on the state of gcc 
optimizations, and therefore I don't see any other way than adding 
__noreturn anotation transitively everywhere in order to silence objtool.

So those cases have to be fixed anyway.

What are the other cases please? Either I have completely missed those, or 
they haven't been mentioned in this thread.

Thanks,

-- 
Jiri Kosina
SUSE Labs

