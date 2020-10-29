Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360FC29EF0B
	for <lists+live-patching@lfdr.de>; Thu, 29 Oct 2020 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgJ2PDN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Oct 2020 11:03:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:51376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgJ2PDN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Oct 2020 11:03:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C9D1CAF0C;
        Thu, 29 Oct 2020 15:03:11 +0000 (UTC)
Date:   Thu, 29 Oct 2020 16:03:09 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
In-Reply-To: <20201029145709.GD16774@alley>
Message-ID: <alpine.LSU.2.21.2010291601510.1688@pobox.suse.cz>
References: <20201028115244.995788961@goodmis.org> <20201028115613.291169246@goodmis.org> <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz> <20201029145709.GD16774@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 29 Oct 2020, Petr Mladek wrote:

> On Thu 2020-10-29 14:51:06, Miroslav Benes wrote:
> > On Wed, 28 Oct 2020, Steven Rostedt wrote:
> 
> > Hm, I've always thought that we did not need any kind of recursion 
> > protection for our callback. It is marked as notrace and it does not call 
> > anything traceable. In fact, it does not call anything. I even have a note 
> > in my todo list to mark the callback as RECURSION_SAFE :)
> 
> Well, it calls WARN_ON_ONCE() ;-)

Oh my, I learned to ignore these. Of course there is printk hidden 
everywhere.

> > At the same time, it probably does not hurt and the patch is still better 
> > than what we have now without RECURSION_SAFE if I understand the patch set 
> > correctly.
> 
> And better be on the safe side.

Agreed. 
 
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

Agreed.

Miroslav
