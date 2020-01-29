Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D13014CAD8
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2020 13:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2M2f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Jan 2020 07:28:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:54164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgA2M2f (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Jan 2020 07:28:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D717EAF92;
        Wed, 29 Jan 2020 12:28:31 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:28:30 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, nstange@suse.de
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20200128170254.igb72ib5n7lvn3ds@treble>
Message-ID: <alpine.LSU.2.21.2001291249430.28615@pobox.suse.cz>
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

> > > There are N users[*] of CONFIG_LIVEPATCH, where N is perhaps dozens.
> > > For N-1 users, they have to suffer ALL the drawbacks, with NONE of the
> > > benefits.
> > 
> > You wrote in the other mail:
> > 
> >   > The problems associated with it: performance, LTO incompatibility,
> >   > clang incompatibility (I think?), the GCC dead code issue.
> > 
> > SUSE performance team did extensive testing and did not found
> > any real performance issues. It was discussed when the option
> > was enabled upstream.
> > 
> > Are the other problems affecting real life usage, please?
> > Could you be more specific about them, please?
> 
> The original commit mentioned 1-3% scheduler degradation.  And I'd
> expect things to worsen over time as interprocedural optimizations
> improve.

Or maybe not.

Anyway, -flive-patching does not disable all interprocedural 
optimizations. By far. Only a subset of optimizations whose usage on the 
linux kernel is reportedly even not that prominent (compared to heavily 
C++ template based source codes). Reportedly, because we did some tests 
but nothing exhaustive. So I'd leave any expectations aside now.

The fact is that -fno-ipa-pure-const caused the objtool issue. One could 
argue that it should be fixed anyway, because it relies on GCC internal 
implementation which could easily change, and we luckily found it out 
thanks to -flive-patching. But you pointed out that was not even the main 
problem here, so I'd leave it for the separate subthread which Jiri 
started. 

Regarding the scheduler degradation. hackbench performance degradation to 
make it clear. It might be interesting to find out what really changed 
there. Which disabled optimization caused it and how. Maybe it could be 
gained back if proven again (because it may have changed, right?).

It all sound artificial to me though. I am not saying the degradation is 
not there, but many people also lived with frame pointers enabled for 
quite a long time and no one seemed to be bothered. And that was even more 
serious because the decline was bigger and it was measurable in many 
workflows. Not just a schedule microbenchmark. That is why Petr asked 
about real life reports, I guess.
 
> Also, LTO is coming whether we like it or not.  As is Clang.  Those are
> real-world things which will need to work with livepatching sooner or
> later.

Yes, but we are not there yet. Once a user has problem with that, we will 
try to solve it.

LTO might not be a big problem. The number of ipa clones would probably 
grow, but that is not directly dangerous. It remains to be seen.

I don't know much about Clang.

> > > And, even if they wanted those benefits, they have no idea how to get
> > > them because the patch creation process isn't documented.
> > 
> > I do not understand this. All the sample modules and selftests are
> > using source based livepatches.
> 
> We're talking in circles.  Have you read the thread?
>
> The samples are a (dangerous) joke.  With or without -flive-patching.

How come?

In my opinion, the samples and selftests try to show the way to prepare a 
(simple, yes) live patch. We try to ensure it always works (selftests 
should).

After all, there is not much more we do at SUSE to prepare a live patch.

1. take a patch and put all touched functions in a live patch
2. if the functions cannot be patched, patch their callers
3. do the function closure and/or add references (relocations or 
   kallsyms trick) so it can all be compiled.
4. done

See? Samples and selftests are not different. Our live patches are not 
different (https://kernel.suse.com/cgit/kernel-livepatch/). Can we 
implement the samples and selftests without -flive-patching? No, not 
really. Or we could, but no guarantees they would work.

For 2., we use -fdump-ipa-clones and Martin Liska's tool 
(https://github.com/marxin/kgraft-analysis-tool) to parse the output.

Yes, sometimes it is more complicated. Source based approach allows us to 
cope with that quite well. But that is case by case and cannot be easily 
documented.

Do we lack the documentation of our approach? Definitely. We are moving to 
klp-ccp automation now (https://github.com/SUSE/klp-ccp) and once done 
completely, we will hopefully have some documention. CCing Nicolai if he 
wants to add something.

Should it be upstream? I don't know. I don't think so. For the same reason 
kpatch-build documentation is not upstream either. Use cases of the 
infrastructure differ. Maybe there are users who use it in a completely 
different way. I don't know. In fact, it does not matter to me. I think we 
should support it all if they make sense.

And that is my message which (in my opinion) makes more sense. Definitely 
more sense than your "kpatch-build is the only safe way to prepare a live 
patch" mantra you are trying to sell here for whatever reason. I don't 
agree with it.

> > It is actually the only somehow documented way. Sure, the
> > documentation might get improved.  Patches are welcome.
> 
> Are you suggesting for *me* to send documentation for how *you* build
> patches?

I don't think that is what Petr meant (he will definitely correct me). If 
you think there is a space for improvement in our upstream documentation 
of the infrastructure, you are welcome to send patches. The space is 
definitely there.

> > The option is not currently needed by the selftests only because there
> > is no selftest for this type of problems. But the problems are real.
> > They would actually deserve selftests. Again, patches are welcome.
> > 
> > My understanding is that the source based livepatches is the future.
> 
> I think that still remains to be seen.
> 
> > N-1 users are just waiting until the 1 user develops more helper tools
> > for this.
> 
> No.  N-1 users have no idea how to make (safe) source-based patches in
> the first place.  And if *you* don't need the tools, why would anyone
> else?  Why not document the process and encourage the existence of other
> users so they can get involved and help with the tooling?

I replied to this one above. You are right we should document our approach 
better. I think it is off topic of the thread and problem here.

Regards
Miroslav
