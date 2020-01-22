Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB37145228
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 11:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAVKKC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 05:10:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:55116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVKKC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 05:10:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BB8DCB2C0;
        Wed, 22 Jan 2020 10:09:59 +0000 (UTC)
Date:   Wed, 22 Jan 2020 11:09:56 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20200121161045.dhihqibnpyrk2lsu@treble>
Message-ID: <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
References: <20191015135634.GK2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home> <20191016074217.GL2328@hirez.programming.kicks-ass.net> <20191021150549.bitgqifqk2tbd3aj@treble> <20200120165039.6hohicj5o52gdghu@treble> <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> > > At this point, I only see downsides of -flive-patching, at least until
> > > we actually have real upstream code which needs it.
> > 
> > Can you explain this? The option makes GCC to avoid optimizations which 
> > are difficult to detect and would make live patching unsafe. I consider it 
> > useful as it is, so if you shared the other downsides and what you meant 
> > by real upstream code, we could discuss it.
> 
> Only SLES needs it right?  Why inflict it on other livepatch users?  By
> "real upstream code" I mean there's no (documented) way to create live
> patches using the method which relies on this flag.  So I don't see any
> upstream benefits for having it enabled.

I'd put it differently. SLES and upstream need it, RHEL does not need it. 
Or anyone using kpatch-build. It is perfectly fine to prepare live patches 
just from the source code using upstream live patching infrastructure. 
After all, SLES is nothing else than upstream here. We were creating live 
patches manually for quite a long time and only recently we have been 
using Nicolai's klp-ccp automation (https://github.com/SUSE/klp-ccp).

So, everyone using upstream directly relies on the flag, which seems to be 
a clear benefit to me. Reverting the patch would be a step back.

Also I think we're moving in the right direction to make the life of 
upstream user easier with a proposal of klp-ccp and Petr's patch set to 
split live patch modules. It is a path from inconvenient to comfortable 
and not from impossible to possible.

Miroslav
