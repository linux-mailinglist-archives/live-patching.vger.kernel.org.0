Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D57165A5
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 16:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEGO2t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 10:28:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:49696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726730AbfEGO2t (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 10:28:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75258ACAE;
        Tue,  7 May 2019 14:28:47 +0000 (UTC)
Date:   Tue, 7 May 2019 16:28:47 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190507142847.pre7tvm4oysimfww@pathway.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
 <20190507014332.l5pmvjyfropaiui2@treble>
 <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
 <20190507120350.gpazr6xivzwvd3az@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507120350.gpazr6xivzwvd3az@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2019-05-07 07:03:50, Josh Poimboeuf wrote:
> On Tue, May 07, 2019 at 01:29:50PM +0200, Petr Mladek wrote:
> > On Mon 2019-05-06 20:43:32, Josh Poimboeuf wrote:
> > > On Mon, May 06, 2019 at 07:40:32PM -0500, Josh Poimboeuf wrote:
> > > > On Tue, Apr 30, 2019 at 11:10:48AM +0200, Petr Mladek wrote:
> > > > > --- a/kernel/livepatch/transition.c
> > > > > +++ b/kernel/livepatch/transition.c
> > > > > @@ -263,8 +263,15 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> > > > >  	trace.nr_entries = 0;
> > > > >  	trace.max_entries = MAX_STACK_ENTRIES;
> > > > >  	trace.entries = entries;
> > > > > +
> > > > >  	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > > > -	WARN_ON_ONCE(ret == -ENOSYS);
> > > > > +	/*
> > > > > +	 * pr_warn() under task rq lock might cause a deadlock.
> > > > > +	 * Fortunately, missing reliable stacktrace support has
> > > > > +	 * already been handled when the livepatch was enabled.
> > > > > +	 */
> > > > > +	if (ret == -ENOSYS)
> > > > > +		return ret;
> > > > 
> > > > I find the comment to be a bit wordy and confusing (and vague).
> > 
> > Then please provide a better one. I have no idea what might make
> > you happy and am not interested into an endless disputing.
>
> Something like this would be clearer:
> 
> 	if (ret == -ENOSYS) {
> 		/*
> 		 * This arch doesn't support reliable stack tracing.  No
> 		 * need to print a warning; that has already been done
> 		 * by klp_enable_patch().
> 		 */
> 		return ret;
> 	}

I do not mind.

> > > > Also this check is effectively the same as the klp_have_reliable_stack()
> > > > check which is done in kernel/livepatch/core.c.  So I think it would be
> > > > clearer and more consistent if the same check is done here:
> > > > 
> > > > 	if (!klp_have_reliable_stack())
> > > > 		return -ENOSYS;
> > 
> > Huh, it smells with over engineering to me.
> 
> How so?  It makes the code more readable and the generated code should
> be much better because it becomes a build-time check.

save_stack_trace_tsk_reliable() returns various error codes.
We catch a specific one because otherwise the message below
might be misleading.

I do not see why we should prevent this error by calling
a custom hack: klp_have_reliable_stack()?

Regarding reliability. If anyone changes semantic of
save_stack_trace_tsk_reliable() error codes, they would likely
check if all users (one at the moment) handle it correctly.

On the other hand, the dependency between the -ENOSYS
return value and klp_have_reliable_stack() is far from
obvious.

If we want to discuss and fix this to the death. We should change
the return value from -ENOSYS to -EOPNOTSUPP. The reason
is the same as in the commit 375bfca3459db1c5596
("livepatch: core: Return EOPNOTSUPP instead of ENOSYS").

Note that EOPNOTSUPP is the same errno as ENOTSUP, see
man 3 errno.


> But I think Miroslav's suggestion to revert 1d98a69e5cef would be even
> better.

AFAIK, Miroslav wanted to point out that your opinion was inconsistent.


> > > > 	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > > 
> > > > 	[ no need to check ret for ENOSYS here ]
> > > > 
> > > > Then, IMO, no comment is needed.
> > > 
> > > BTW, if you agree with this approach then we can leave the
> > > WARN_ON_ONCE() in save_stack_trace_tsk_reliable() after all.
> > 
> > I really like the removal of the WARN_ON_ONCE(). I consider
> > it an old fashioned way used when people are lazy to handle
> > errors. It might make sense when the backtrace helps to locate
> > the context but the context is well known here. Finally,
> > WARN() should be used with care. It might cause reboot
> > with panic_on_warn.
> 
> The warning makes the function consistent with the other weak functions
> in stacktrace.c and clarifies that it should never be called unless an
> arch has misconfigured something.  And if we aren't even checking the
> specific ENOSYS error as I proposed then this warning would make the
> error more obvious.

I consider both WARN() and error value as superfluous. I like the
error value because it allows users to handle the situation as
they need it.

Best Regards,
Petr

PS: This is my last mail in the thread this week. I will eventually
return to it with a clear head next week. It is all nitpicking from
my POV and I have better things to do.
