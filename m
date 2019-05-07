Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7C916364
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 14:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfEGMEB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 08:04:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfEGMEB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 08:04:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C57FA81F19;
        Tue,  7 May 2019 12:03:56 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F631A7D9;
        Tue,  7 May 2019 12:03:52 +0000 (UTC)
Date:   Tue, 7 May 2019 07:03:50 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190507120350.gpazr6xivzwvd3az@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
 <20190507014332.l5pmvjyfropaiui2@treble>
 <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 07 May 2019 12:04:01 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 07, 2019 at 01:29:50PM +0200, Petr Mladek wrote:
> On Mon 2019-05-06 20:43:32, Josh Poimboeuf wrote:
> > On Mon, May 06, 2019 at 07:40:32PM -0500, Josh Poimboeuf wrote:
> > > On Tue, Apr 30, 2019 at 11:10:48AM +0200, Petr Mladek wrote:
> > > > WARN_ON_ONCE() could not be called safely under rq lock because
> > > > of console deadlock issues. Fortunately, there is another check
> > > > for the reliable stacktrace support in klp_enable_patch().
> > > > 
> > > > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > > > ---
> > > >  kernel/livepatch/transition.c | 9 ++++++++-
> > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > > > index 9c89ae8b337a..8e0274075e75 100644
> > > > --- a/kernel/livepatch/transition.c
> > > > +++ b/kernel/livepatch/transition.c
> > > > @@ -263,8 +263,15 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> > > >  	trace.nr_entries = 0;
> > > >  	trace.max_entries = MAX_STACK_ENTRIES;
> > > >  	trace.entries = entries;
> > > > +
> > > >  	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > > -	WARN_ON_ONCE(ret == -ENOSYS);
> > > > +	/*
> > > > +	 * pr_warn() under task rq lock might cause a deadlock.
> > > > +	 * Fortunately, missing reliable stacktrace support has
> > > > +	 * already been handled when the livepatch was enabled.
> > > > +	 */
> > > > +	if (ret == -ENOSYS)
> > > > +		return ret;
> > > 
> > > I find the comment to be a bit wordy and confusing (and vague).
> 
> Then please provide a better one. I have no idea what might make
> you happy and am not interested into an endless disputing.

Something like this would be clearer:

	if (ret == -ENOSYS) {
		/*
		 * This arch doesn't support reliable stack tracing.  No
		 * need to print a warning; that has already been done
		 * by klp_enable_patch().
		 */
		return ret;
	}

But my next point was that changing the code would be even better than
fixing the comment.

> > > Also this check is effectively the same as the klp_have_reliable_stack()
> > > check which is done in kernel/livepatch/core.c.  So I think it would be
> > > clearer and more consistent if the same check is done here:
> > > 
> > > 	if (!klp_have_reliable_stack())
> > > 		return -ENOSYS;
> 
> Huh, it smells with over engineering to me.

How so?  It makes the code more readable and the generated code should
be much better because it becomes a build-time check.

But I think Miroslav's suggestion to revert 1d98a69e5cef would be even
better.

> > > 	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > 
> > > 	[ no need to check ret for ENOSYS here ]
> > > 
> > > Then, IMO, no comment is needed.
> > 
> > BTW, if you agree with this approach then we can leave the
> > WARN_ON_ONCE() in save_stack_trace_tsk_reliable() after all.
> 
> I really like the removal of the WARN_ON_ONCE(). I consider
> it an old fashioned way used when people are lazy to handle
> errors. It might make sense when the backtrace helps to locate
> the context but the context is well known here. Finally,
> WARN() should be used with care. It might cause reboot
> with panic_on_warn.

The warning makes the function consistent with the other weak functions
in stacktrace.c and clarifies that it should never be called unless an
arch has misconfigured something.  And if we aren't even checking the
specific ENOSYS error as I proposed then this warning would make the
error more obvious.

-- 
Josh
