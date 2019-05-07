Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACBF15762
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 03:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfEGBni (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 21:43:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEGBni (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 21:43:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCC4F308427D;
        Tue,  7 May 2019 01:43:37 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CC131001925;
        Tue,  7 May 2019 01:43:34 +0000 (UTC)
Date:   Mon, 6 May 2019 20:43:32 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190507014332.l5pmvjyfropaiui2@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507004032.2fgddlsycyypqdsn@treble>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 07 May 2019 01:43:38 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 06, 2019 at 07:40:32PM -0500, Josh Poimboeuf wrote:
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
> 
> 	ret = save_stack_trace_tsk_reliable(task, &trace);
> 
> 	[ no need to check ret for ENOSYS here ]
> 
> Then, IMO, no comment is needed.

BTW, if you agree with this approach then we can leave the
WARN_ON_ONCE() in save_stack_trace_tsk_reliable() after all.

-- 
Josh
