Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF8145867
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgAVPFd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 10:05:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:36980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVPFd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 10:05:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10C3FACD9;
        Wed, 22 Jan 2020 15:05:29 +0000 (UTC)
Date:   Wed, 22 Jan 2020 16:05:27 +0100 (CET)
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
        Randy Dunlap <rdunlap@infradead.org>, mjambor@suse.cz
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <alpine.LSU.2.21.2001221312030.15957@pobox.suse.cz>
Message-ID: <alpine.LSU.2.21.2001221556160.15957@pobox.suse.cz>
References: <20191015135634.GK2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home> <20191016074217.GL2328@hirez.programming.kicks-ass.net> <20191021150549.bitgqifqk2tbd3aj@treble> <20200120165039.6hohicj5o52gdghu@treble> <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz> <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221312030.15957@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 22 Jan 2020, Miroslav Benes wrote:

> On Tue, 21 Jan 2020, Josh Poimboeuf wrote:
> 
> > On Tue, Jan 21, 2020 at 09:35:28AM +0100, Miroslav Benes wrote:
> > > On Mon, 20 Jan 2020, Josh Poimboeuf wrote:
> > > 
> > > > On Mon, Oct 21, 2019 at 10:05:49AM -0500, Josh Poimboeuf wrote:
> > > > > On Wed, Oct 16, 2019 at 09:42:17AM +0200, Peter Zijlstra wrote:
> > > > > > > which are not compatible with livepatching. GCC upstream now has
> > > > > > > -flive-patching option, which disables all those interfering optimizations.
> > > > > > 
> > > > > > Which, IIRC, has a significant performance impact and should thus really
> > > > > > not be used...
> > > > > > 
> > > > > > If distros ship that crap, I'm going to laugh at them the next time they
> > > > > > want a single digit performance improvement because *important*.
> > > > > 
> > > > > I have a crazy plan to try to use objtool to detect function changes at
> > > > > a binary level, which would hopefully allow us to drop this flag.
> > > > > 
> > > > > But regardless, I wonder if we enabled this flag prematurely.  We still
> > > > > don't have a reasonable way to use it for creating source-based live
> > > > > patches upstream, and it should really be optional for CONFIG_LIVEPATCH,
> > > > > since kpatch-build doesn't need it.
> > > > 
> > > > I also just discovered that -flive-patching is responsible for all those
> > > > "unreachable instruction" objtool warnings which Randy has been
> > > > dutifully bugging me about over the last several months.  For some
> > > > reason it subtly breaks GCC implicit noreturn detection for local
> > > > functions.
> > > 
> > > Ugh, that is unfortunate. Have you reported it?
> > 
> > Not yet (but I plan to).
> 
> My findings so far...
> 
> I bisected through GCC options which -flive-patching disables and 
> -fno-ipa-pure-const is the culprit. I got no warnings without the option 
> with my config.
> 
> Then I found out allmodconfig was ok even with -flive-patching. 
> CONFIG_GCOV is the difference. CONFIG_GCOV=y seems to make the warnings go 
> away here.

Sorry, that was a red herring. See 867ac9d73709 ("objtool: Fix gcov check 
for older versions of GCC").

I started looking at some btrfs reports and then found out those were 
already fixed. 
https://lore.kernel.org/linux-btrfs/cd4091e4-1c04-a880-f239-00bc053f46a2@infradead.org/

arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_panic()+0x11b: unreachable instruction
was next...

Broken code (-fno-ipa-pure-const):
...
    1186:       e8 a5 fe ff ff          callq  1030 <wait_for_panic>
    118b:       e9 23 ff ff ff          jmpq   10b3 <mce_panic+0x43>
</end of function>

Working code (-fipa-pure-const):
     753:       e8 88 fe ff ff          callq  5e0 <wait_for_panic>
     758:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
     75f:       00 

mce_panic() has:
                if (atomic_inc_return(&mce_panicked) > 1)                                                              
                        wait_for_panic();
                barrier();
                
                bust_spinlocks(1);                                                                                     

jmpq in the broken code goes to bust_spinlocks(1), because GCC does not 
know that wait_for_panic() is noreturn... because it is not. 
wait_for_panic() calls panic() unconditionally in the end, which is 
noreturn.

So the question is why ipa-pure-const optimization knows about panic()'s 
noreturn. The answer is that it is right one of the things the 
optimization does. It propagates inner noreturns to its callers. (Martin 
Jambor CCed).

Marking wait_for_panic() as noreturn (__noreturn), of course, fixes it 
then. Now I don't know what the right fix should be. Should we mark all 
these sites as noreturn, or is it ok for the kernel to rely on GCC 
behaviour in this case? Could we teach objtool to recognize this?

Miroslav
