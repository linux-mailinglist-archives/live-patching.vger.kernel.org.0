Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21745162CC
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 13:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfEGL3w (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 07:29:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:44240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbfEGL3w (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 07:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D460ABF1;
        Tue,  7 May 2019 11:29:51 +0000 (UTC)
Date:   Tue, 7 May 2019 13:29:50 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
 <20190507014332.l5pmvjyfropaiui2@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507014332.l5pmvjyfropaiui2@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2019-05-06 20:43:32, Josh Poimboeuf wrote:
> On Mon, May 06, 2019 at 07:40:32PM -0500, Josh Poimboeuf wrote:
> > On Tue, Apr 30, 2019 at 11:10:48AM +0200, Petr Mladek wrote:
> > > WARN_ON_ONCE() could not be called safely under rq lock because
> > > of console deadlock issues. Fortunately, there is another check
> > > for the reliable stacktrace support in klp_enable_patch().
> > > 
> > > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > > ---
> > >  kernel/livepatch/transition.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > > index 9c89ae8b337a..8e0274075e75 100644
> > > --- a/kernel/livepatch/transition.c
> > > +++ b/kernel/livepatch/transition.c
> > > @@ -263,8 +263,15 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> > >  	trace.nr_entries = 0;
> > >  	trace.max_entries = MAX_STACK_ENTRIES;
> > >  	trace.entries = entries;
> > > +
> > >  	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > -	WARN_ON_ONCE(ret == -ENOSYS);
> > > +	/*
> > > +	 * pr_warn() under task rq lock might cause a deadlock.
> > > +	 * Fortunately, missing reliable stacktrace support has
> > > +	 * already been handled when the livepatch was enabled.
> > > +	 */
> > > +	if (ret == -ENOSYS)
> > > +		return ret;
> > 
> > I find the comment to be a bit wordy and confusing (and vague).

Then please provide a better one. I have no idea what might make
you happy and am not interested into an endless disputing.

> > Also this check is effectively the same as the klp_have_reliable_stack()
> > check which is done in kernel/livepatch/core.c.  So I think it would be
> > clearer and more consistent if the same check is done here:
> > 
> > 	if (!klp_have_reliable_stack())
> > 		return -ENOSYS;

Huh, it smells with over engineering to me.

> > 	ret = save_stack_trace_tsk_reliable(task, &trace);
> > 
> > 	[ no need to check ret for ENOSYS here ]
> > 
> > Then, IMO, no comment is needed.
> 
> BTW, if you agree with this approach then we can leave the
> WARN_ON_ONCE() in save_stack_trace_tsk_reliable() after all.

I really like the removal of the WARN_ON_ONCE(). I consider
it an old fashioned way used when people are lazy to handle
errors. It might make sense when the backtrace helps to locate
the context but the context is well known here. Finally,
WARN() should be used with care. It might cause reboot
with panic_on_warn.

Best Regards,
Petr
