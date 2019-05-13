Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14B61BB3E
	for <lists+live-patching@lfdr.de>; Mon, 13 May 2019 18:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfEMQqn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 May 2019 12:46:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfEMQqm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 May 2019 12:46:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B5C536887;
        Mon, 13 May 2019 16:46:42 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A66419926;
        Mon, 13 May 2019 16:46:38 +0000 (UTC)
Date:   Mon, 13 May 2019 11:46:36 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190513164636.bm32vygasta6lmsa@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
 <20190507014332.l5pmvjyfropaiui2@treble>
 <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
 <20190507120350.gpazr6xivzwvd3az@treble>
 <20190507142847.pre7tvm4oysimfww@pathway.suse.cz>
 <20190507212425.7gfqx5e3yc4fbdfy@treble>
 <20190513104318.5wt2hyg7jf5uikhl@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190513104318.5wt2hyg7jf5uikhl@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 13 May 2019 16:46:42 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 13, 2019 at 12:43:18PM +0200, Petr Mladek wrote:
> On Tue 2019-05-07 16:24:25, Josh Poimboeuf wrote:
> > On Tue, May 07, 2019 at 04:28:47PM +0200, Petr Mladek wrote:
> > > > > > > Also this check is effectively the same as the klp_have_reliable_stack()
> > > > > > > check which is done in kernel/livepatch/core.c.  So I think it would be
> > > > > > > clearer and more consistent if the same check is done here:
> > > > > > > 
> > > > > > > 	if (!klp_have_reliable_stack())
> > > > > > > 		return -ENOSYS;
> > > > > 
> > > > > Huh, it smells with over engineering to me.
> > > > 
> > > > How so?  It makes the code more readable and the generated code should
> > > > be much better because it becomes a build-time check.
> > > 
> > > save_stack_trace_tsk_reliable() returns various error codes.
> > > We catch a specific one because otherwise the message below
> > > might be misleading.
> > > 
> > > I do not see why we should prevent this error by calling
> > > a custom hack: klp_have_reliable_stack()?
> > 
> > I wouldn't call it a hack.  It's a simple build-time check.
> > 
> > > Regarding reliability. If anyone changes semantic of
> > > save_stack_trace_tsk_reliable() error codes, they would likely
> > > check if all users (one at the moment) handle it correctly.
> > > 
> > > On the other hand, the dependency between the -ENOSYS
> > > return value and klp_have_reliable_stack() is far from
> > > obvious.
> > 
> > I don't follow your point.
> 
> We implement klp_have_reliable_stack() in livepatch subsystem.
> It checks config options that defines behavior of the
> stacktrace subsystem.
> 
> We use the above livepatch-specific function to warn about
> that a function from stacktrace subsustem will not work.
> You even suggest to use it to ignore result from
> the stacktrace subsystem.
> 
> OK, using klp_have_reliable_stack() on both locations
> would keep it consistent.
> 
> My point is that the check itself is not reliable because
> it is "hard" to maintain.

I don't see how it would be "hard" to maintain.  If an arch implements
reliable stack tracing, but forgets to set HAVE_RELIABLE_STACKTRACE then
they will notice the warning immediately when they try to livepatch.

> Instead, I suggest to remove klp_have_reliable_stack() and use
> the following in klp_enable_patch().
> 
> 
> 	if (stack_trace_save_tsk_reliable(current, NULL, 0) == -ENOSYS) {
> 		pr_warn("This architecture doesn't have support for the livepatch consistency model.\n");
> 		pr_warn("The livepatch transition may never complete.\n");
> 	}

It seems confusing to call that function where it isn't needed, since
klp_enable_patch() isn't doing stack tracing yet at that location.

Calling klp_have_reliable_stack() is more readable, and is exactly the
check we want to make.

> Also I suggest to remove the check in klp_check_stack() completely.
> We will always print that the stack is not reliable but only when
> the debug message is enabled. It is slightly misleading
> message for -ENOSYS. But I doubt that it could cause much
> troubles in reality. This situation should be really rare
> and easy to debug.

If you want to remove the specific check in klp_check_stack(), that's
fine with me.  I slightly prefer just reverting Kamalesh's commit, but I
don't have a strong feeling either way.

> > > If we want to discuss and fix this to the death. We should change
> > > the return value from -ENOSYS to -EOPNOTSUPP. The reason
> > > is the same as in the commit 375bfca3459db1c5596
> > > ("livepatch: core: Return EOPNOTSUPP instead of ENOSYS").
> > > 
> > > Note that EOPNOTSUPP is the same errno as ENOTSUP, see
> > > man 3 errno.
> > 
> > Sure, but that's a separate issue.
> 
> I just wanted to show that we might spend even more time with
> making this code briliant.
> 
> 
> > > > But I think Miroslav's suggestion to revert 1d98a69e5cef would be even
> > > > better.
> > > 
> > > AFAIK, Miroslav wanted to point out that your opinion was inconsistent.
> > 
> > How is my opinion inconsistent?

I don't guarantee that I will always be consistent with my past self.
My thinking may evolve (or devolve?) over time.  And there's nothing
wrong with that.  But none of the below is actually inconsistent.

> 1. You have already acked the removal of WARN_ON() in
>    klp_have_reliable_stack(),
>    see https://lkml.kernel.org/r/20190424155154.h62wc3nt7ib2phdy@treble
> 
>    You even suggested it, see
>    https://lkml.kernel.org/r/20190418135858.n3lzq2oxkj52m6bi@treble
> 
>    But you suggest to put it back now.

Maybe I wasn't clear.  If we're not planning on calling the weak version
of the function, then the warning makes sense.

> 2. You suggested to remove the warning when klp_check_stack() because
>    it was superfluous. There was a discussion about keeping
>    the check for -ENOSYS there and you did not react, see
>    https://lkml.kernel.org/r/20190424155532.3uyxyxwm4c5dqsf5@treble

But then (I thought) Miroslav suggested reverting 1d98a69e5cef, which is
a better idea.

>    You even acked the commit 1d98a69e5cef3aeb68bcef ("livepatch:
>    Remove reliable stacktrace check in klp_try_switch_task()").
> 
>    And you suddenly want to revert it.

The circumstances have changed since that commit: now we are going back
to allowing non-reliable arches to load livepatches.

> > Is there something wrong with the original approach, which was reverted
> > with
> > 
> >   1d98a69e5cef ("livepatch: Remove reliable stacktrace check in klp_try_switch_task()")
> > 
> > ?
> > 
> > As I mentioned, that has some advantages:
> > 
> > - The generated code is simpler/faster because it uses a build-time
> >   check.
> > 
> > - The code is more readable IMO.  Especially if the check is done higher
> >   up the call stack by reverting 1d98a69e5cef.  That way the arch
> >   support short-circuiting is done in the logical place, before doing
> >   any more unnecessary work.  It's faster, but also, more importantly,
> >   it's less surprising.
> > 
> > - It's also more consistent with other code, since the intent of this
> >   check is the same as the klp_have_reliable_stack() use in
> >   klp_enabled_patch().
> > 
> > If you disagree with those, please explain why.
> 
> As I said. I think that it is less reliable because we check config
> options of an unrelated subsystem.

There's no harm in checking the config option of another subsystem.
Livepatch very much relies on stacktrace.

> Also I think that it is overengineered.
> save_stack_trace_tsk_reliable() is able to tell when it failed.
> This particular failure is superfast. IMHO, it is not worth such
> an optimization.

Sure, performance isn't a concern, but code simplicity, readability, and
consistency certainly are.

> In fact, it is a compile time check as well because the inline
> from include/linux/stacktrace.h
> 
> 
> > > PS: This is my last mail in the thread this week. I will eventually
> > > return to it with a clear head next week. It is all nitpicking from
> > > my POV and I have better things to do.
> > 
> > I don't think it's helpful to characterize it as nitpicking.  The
> > details of the code are important.
> 
> 1. You had issues with almost all my printk() messages, comments,
>    and commit messages. I know that my English is not perfect.
>    And that you might want to highlight another information.
>    But was is it really that bad?

It's just code review.

> 2. This entire patchset is about adding and removing messages
>    and checks. We have 3rd version and you are still not happy.
>    Not to say that you suggest something else each time.

That's how review works.  If the code improves with each iteration then
how is that a problem?

> Frankly, I do mind too much about this code path, which and how
> many warnings are printed. I am not aware about any complains.
> IMHO, only people adding support for new architecture
> might go this way.
> 
> I just wanted to switch the error to warning because Thomas
> Gleixner wondered about unused code on s390 when refactoring
> the stacktrace code.
> 
> I really did not expect that I would spend hours/days on this.
> I do not think that it is worth it.
> 
> I consider most of the requests as nitpicking because
> they requests extra work just because it looks like
> a good idea.
> 
> My take is that we should accept changes when they improve
> the situation and go in the right direction. Further clean up
> might be done later by anyone who does not have anything
> more important on the plate or gets annoyed enough.
> 
> Yes, you have many great ideas. But I am not a trained
> monkey. And I do not know how to stop this when it is
> looking endless.

I'm just trying to help improve the code.  That's how open source works.
And it's my responsibility as a maintainer.  If you're not open to
review, don't bother posting the code in the first place.

-- 
Josh
