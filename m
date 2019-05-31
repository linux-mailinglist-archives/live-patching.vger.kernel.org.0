Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D017631574
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 21:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfEaTht (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 15:37:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbfEaThq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 15:37:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8EDB081F22;
        Fri, 31 May 2019 19:37:45 +0000 (UTC)
Received: from treble (ovpn-124-142.rdu2.redhat.com [10.10.124.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AD8760BFC;
        Fri, 31 May 2019 19:37:42 +0000 (UTC)
Date:   Fri, 31 May 2019 14:37:40 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190531193740.fdyhlgvfz32yzxgj@treble>
References: <20190531074147.27616-1-pmladek@suse.com>
 <20190531074147.27616-3-pmladek@suse.com>
 <alpine.LSU.2.21.1905311425450.742@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1905311425450.742@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 31 May 2019 19:37:45 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 31, 2019 at 02:32:34PM +0200, Miroslav Benes wrote:
> On Fri, 31 May 2019, Petr Mladek wrote:
> 
> > WARN_ON_ONCE() could not be called safely under rq lock because
> > of console deadlock issues.
> > 
> > It can be simply removed. A better descriptive message is written
> > in klp_enable_patch() when klp_have_reliable_stack() fails.
> > The remaining debug message is good enough.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > ---
> >  kernel/livepatch/transition.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > index abb2a4a2cbb2..1bf362df76e1 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -247,7 +247,6 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> >  	int ret, nr_entries;
> >  
> >  	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
> > -	WARN_ON_ONCE(ret == -ENOSYS);
> >  	if (ret < 0) {
> >  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
> >  			 "%s: %s:%d has an unreliable stack\n",
> 
> The current situation is not the best, but I think the patch improves it 
> only slightly. I see two possible solutions.
> 
> 1. we either revert commit 1d98a69e5cef ("livepatch: Remove reliable 
> stacktrace check in klp_try_switch_task()"), so that klp_check_stack() 
> returns right away.
> 
> 2. or we test ret from stack_trace_save_tsk_reliable() for ENOSYS and 
> return.
> 
> In my opinion either of them is better than what we have now (and what we 
> would have with the patch), because klp_check_stack() returns, but it 
> prints out that a task has an unreliable stack. Yes, it is pr_debug() only 
> in the end, but still.
> 
> I don't have a preference and my understanding is that Petr does not want 
> to do v4. I can prepare a patch, but it would be nice to choose now. Josh? 
> Anyone else?

My vote would be #1 -- just revert 1d98a69e5cef.

-- 
Josh
