Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3845F14BD1C
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2020 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgA1Pku (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 10:40:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:60600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgA1Pku (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 10:40:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1E50AC9D;
        Tue, 28 Jan 2020 15:40:47 +0000 (UTC)
Date:   Tue, 28 Jan 2020 16:40:46 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
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
Message-ID: <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
References: <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128150014.juaxfgivneiv6lje@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2020-01-28 09:00:14, Josh Poimboeuf wrote:
> On Tue, Jan 28, 2020 at 10:28:07AM +0100, Miroslav Benes wrote:
> > I don't think we have something special at SUSE not generally available...
> > 
> > ...and I don't think it is really important to discuss that and replying 
> > to the above, because there is a legitimate use case which relies on the 
> > flag. We decided to support different use cases right at the beginning.
> > 
> > I understand it currently complicates things for objtool, but objtool is 
> > sensitive to GCC code generation by definition. "Issues" appear with every 
> > new GCC version. I see no difference here and luckily it is not so 
> > difficult to fix it.
> > 
> > I am happy to help with acting on those objtool warning reports you 
> > mentioned in the other email. Just Cc me where appropriate. We will take a 
> > look.
> 
> As I said, the objtool warnings aren't even the main issue.

Great.

Anyway, I think that we might make your life easier with using
the proposed -Wsuggest-attribute=noreturn.

Also it might be possible to create the list of global
noreturn functions using some gcc tool. Similar way that we get
the list of functions that need to be livepatched explicitly
because of the problematic optimizations.

It sounds like a win-win approach.


> There are N users[*] of CONFIG_LIVEPATCH, where N is perhaps dozens.
> For N-1 users, they have to suffer ALL the drawbacks, with NONE of the
> benefits.

You wrote in the other mail:

  > The problems associated with it: performance, LTO incompatibility,
  > clang incompatibility (I think?), the GCC dead code issue.

SUSE performance team did extensive testing and did not found
any real performance issues. It was discussed when the option
was enabled upstream.

Are the other problems affecting real life usage, please?
Could you be more specific about them, please?


> And, even if they wanted those benefits, they have no idea how to get
> them because the patch creation process isn't documented.

I do not understand this. All the sample modules and selftests are
using source based livepatches. It is actually the only somehow
documented way. Sure, the documentation might get improved.
Patches are welcome.

The option is not currently needed by the selftests only because
there is no selftest for this type of problems. But the problems
are real. They would actually deserve selftests. Again, patches
are welcome.

My understanding is that the source based livepatches is the future.
N-1 users are just waiting until the 1 user develops more helper
tools for this. I would really like to hear about some serious problems
before we do this step back in upstream.

Best Regards,
Petr
