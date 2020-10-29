Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6AB29F40C
	for <lists+live-patching@lfdr.de>; Thu, 29 Oct 2020 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgJ2SYM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Oct 2020 14:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgJ2SYL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Oct 2020 14:24:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F7820825;
        Thu, 29 Oct 2020 18:24:09 +0000 (UTC)
Date:   Thu, 29 Oct 2020 14:24:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
Message-ID: <20201029142406.3c46855a@gandalf.local.home>
In-Reply-To: <20201029145709.GD16774@alley>
References: <20201028115244.995788961@goodmis.org>
        <20201028115613.291169246@goodmis.org>
        <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
        <20201029145709.GD16774@alley>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 29 Oct 2020 15:57:09 +0100
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2020-10-29 14:51:06, Miroslav Benes wrote:
> > On Wed, 28 Oct 2020, Steven Rostedt wrote:
> >   
> > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > > 
> > > If a ftrace callback does not supply its own recursion protection and
> > > does not set the RECURSION_SAFE flag in its ftrace_ops, then ftrace will
> > > make a helper trampoline to do so before calling the callback instead of
> > > just calling the callback directly.
> > > 
> > > The default for ftrace_ops is going to assume recursion protection unless
> > > otherwise specified.  
> 
> It might be my lack skills to read English. But the above sentence
> sounds ambiguous to me. It is not clear to me who provides the
> recursion protection by default. Could you please make it more
> explicit, for example by:
> 
> "The default for ftrace_ops is going to change. It will expect that
> handlers provide their own recursion protection."

It was originally written as something else, as my first series (that I
didn't post) added the recursion flag, and then I needed one big nasty
patch to remove them. Then I realized it would be fine to just keep the
double recursion testing and remove the flag when it was no longer used. I
then went back and wrote up that sentence, and yeah, it wasn't the best
explanation.

Your sentence is better, I'll update it.

> 
> 
> > Hm, I've always thought that we did not need any kind of recursion 
> > protection for our callback. It is marked as notrace and it does not call 
> > anything traceable. In fact, it does not call anything. I even have a note 
> > in my todo list to mark the callback as RECURSION_SAFE :)  
> 
> Well, it calls WARN_ON_ONCE() ;-)
> 
> > At the same time, it probably does not hurt and the patch is still better 
> > than what we have now without RECURSION_SAFE if I understand the patch set 
> > correctly.  
> 
> And better be on the safe side.

And the WARN_ON_ONCE() use to cause a problem, until I fixed it:

  dfbf2897d0049 ("bug: set warn variable before calling WARN()")

> 
> 
> > > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Cc: Jiri Kosina <jikos@kernel.org>
> > > Cc: Miroslav Benes <mbenes@suse.cz>
> > > Cc: Petr Mladek <pmladek@suse.com>
> > > Cc: Joe Lawrence <joe.lawrence@redhat.com>
> > > Cc: live-patching@vger.kernel.org
> > > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > ---
> > >  kernel/livepatch/patch.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> > > index b552cf2d85f8..6c0164d24bbd 100644
> > > --- a/kernel/livepatch/patch.c
> > > +++ b/kernel/livepatch/patch.c
> > > @@ -45,9 +45,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> > >  	struct klp_ops *ops;
> > >  	struct klp_func *func;
> > >  	int patch_state;
> > > +	int bit;
> > >  
> > >  	ops = container_of(fops, struct klp_ops, fops);
> > >  
> > > +	bit = ftrace_test_recursion_trylock();
> > > +	if (bit < 0)
> > > +		return;  
> > 
> > This means that the original function will be called in case of recursion. 
> > That's probably fair, but I'm wondering if we should at least WARN about 
> > it.  
> 
> Yeah, the early return might break the consistency model and
> unexpected things might happen. We should be aware of it.
> Please use:
> 
> 	if (WARN_ON_ONCE(bit < 0))
> 		return;
> 
> WARN_ON_ONCE() might be part of the recursion. But it should happen
> only once. IMHO, it is worth the risk.
> 
> Otherwise it looks good.

Perhaps we can add that as a separate patch, because this patch doesn't add
any real functionality change. It only moves the recursion testing from the
helper function (which ftrace wraps all callbacks that do not have the
RECURSION flags set, including this one) down to your callback.

In keeping with one patch to do one thing principle, the added of
WARN_ON_ONCE() should be a separate patch, as that will change the
functionality.

If that WARN_ON_ONCE() breaks things, I'd like it to be bisected to another
patch other than this one.

-- Steve
