Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3034815FEE
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEGI6z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 04:58:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:44488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfEGI6z (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 04:58:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77065ABAC;
        Tue,  7 May 2019 08:58:54 +0000 (UTC)
Date:   Tue, 7 May 2019 10:58:53 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
In-Reply-To: <20190507004032.2fgddlsycyypqdsn@treble>
Message-ID: <alpine.LSU.2.21.1905071052570.7486@pobox.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com> <20190430091049.30413-2-pmladek@suse.com> <20190507004032.2fgddlsycyypqdsn@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 6 May 2019, Josh Poimboeuf wrote:

> On Tue, Apr 30, 2019 at 11:10:48AM +0200, Petr Mladek wrote:
> > WARN_ON_ONCE() could not be called safely under rq lock because
> > of console deadlock issues. Fortunately, there is another check
> > for the reliable stacktrace support in klp_enable_patch().
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > ---
> >  kernel/livepatch/transition.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > index 9c89ae8b337a..8e0274075e75 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -263,8 +263,15 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> >  	trace.nr_entries = 0;
> >  	trace.max_entries = MAX_STACK_ENTRIES;
> >  	trace.entries = entries;
> > +
> >  	ret = save_stack_trace_tsk_reliable(task, &trace);
> > -	WARN_ON_ONCE(ret == -ENOSYS);
> > +	/*
> > +	 * pr_warn() under task rq lock might cause a deadlock.
> > +	 * Fortunately, missing reliable stacktrace support has
> > +	 * already been handled when the livepatch was enabled.
> > +	 */
> > +	if (ret == -ENOSYS)
> > +		return ret;
> 
> I find the comment to be a bit wordy and confusing (and vague).
> 
> Also this check is effectively the same as the klp_have_reliable_stack()
> check which is done in kernel/livepatch/core.c.  So I think it would be
> clearer and more consistent if the same check is done here:
> 
> 	if (!klp_have_reliable_stack())
> 		return -ENOSYS;

We removed it in 1d98a69e5cef ("livepatch: Remove reliable stacktrace 
check in klp_try_switch_task()") and I do think it does not belong here. 
We can check for the facility right at the beginning in klp_enable_patch() 
and it is not necessary to do it every time klp_check_stack() is called.

But it is nothing I could not live with, so if you decide it is better, I 
will not object.

Miroslav
