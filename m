Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20EA415E32
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbhIWMUv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 08:20:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56452 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbhIWMUt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 08:20:49 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 894EC2235E;
        Thu, 23 Sep 2021 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632399557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gxpf7d8Oowqt1Lj8qf+yCS9JtOiokgvQEJNA55aMtZI=;
        b=ATobTh2vYzGRTEHa/xKE3U1CQ0Fum9fY8Tr6buJPVfVTJx8V0HgE+WbG06fiiZ2fMrY7KE
        QqA9rJ+HKhxRNAKe0uWBr4kr7hdw2QTjvIKXOTC1YoYkE6+pEKIjJ4+x2vkNwJteIojejJ
        a80p9elh7lABlzOA8xcFXplPMVcKxlI=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 6CBFE25D3C;
        Thu, 23 Sep 2021 12:19:17 +0000 (UTC)
Date:   Thu, 23 Sep 2021 14:19:17 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>, gor@linux.ibm.com,
        jpoimboe@redhat.com, jikos@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 5/7] sched,livepatch: Use wake_up_if_idle()
Message-ID: <YUxwxUPLs0ig6d5S@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.185239814@infradead.org>
 <alpine.LSU.2.21.2109221458230.442@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2109221458230.442@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-22 15:05:03, Miroslav Benes wrote:
> > @@ -405,8 +405,10 @@ void klp_try_complete_transition(void)
> >  	for_each_possible_cpu(cpu) {
> >  		task = idle_task(cpu);
> >  		if (cpu_online(cpu)) {
> > -			if (!klp_try_switch_task(task))
> > -				complete = false;
> > +			int ret = klp_try_switch_task(task);
> > +			if (ret == -EBUSY)
> > +				wake_up_if_idle(cpu);
> > +			complete = !ret;
> 
> This is broken. You can basically change "complete" only to false (when it 
> applies). This could leave some tasks in the old patching state.

I was a bit confused by Mirek's comment ;-) Anyway, the following works for me:

@@ -406,9 +406,12 @@ void klp_try_complete_transition(void)
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
 			int ret = klp_try_switch_task(task);
-			if (ret == -EBUSY)
-				wake_up_if_idle(cpu);
-			complete = !ret;
+			if (ret) {
+				complete = false;
+				/* Make idle task go through the main loop. */
+				if (ret == -EBUSY)
+					wake_up_if_idle(cpu);
+			}
 		} else if (task->patch_state != klp_target_state) {
 			/* offline idle tasks can be switched immediately */
 			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);

Best Regards,
Petr
