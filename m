Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE59416CDE
	for <lists+live-patching@lfdr.de>; Fri, 24 Sep 2021 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbhIXHfj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Sep 2021 03:35:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54446 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbhIXHfe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Sep 2021 03:35:34 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 62E6622391;
        Fri, 24 Sep 2021 07:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632468840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fvFiisWdco37z/Q3AS4GjLyjOeGMuTmzt8oyl+4CCz0=;
        b=Wgf8kYS+7poxsMXO/r1kjgjdFqNiNIknOVDfobej88OcQxfwfySs7up/v69EDk/ZhmAsrJ
        jUVfsY85r3wn1KZYjWqwcZZu1PHOLW3VCE15PWH8KVurOWV3Rpt6iZ4d/7mXJSFW8Lv3LA
        AYYKyOwZpgA3K50w/xBxQGWnJIFG200=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 35D5025CCD;
        Fri, 24 Sep 2021 07:34:00 +0000 (UTC)
Date:   Fri, 24 Sep 2021 09:33:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 7/7] livepatch,context_tracking: Avoid disturbing
 NOHZ_FULL tasks
Message-ID: <YU1/Z/+IviZXog5w@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.304335737@infradead.org>
 <YUx9yNfgm4nnd23y@alley>
 <YUyBGJGCgrR56C7r@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUyBGJGCgrR56C7r@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-09-23 15:28:56, Peter Zijlstra wrote:
> On Thu, Sep 23, 2021 at 03:14:48PM +0200, Petr Mladek wrote:
> 
> > IMHO, this is not safe:
> > 
> > CPU0				CPU1
> > 
> > klp_check_task(A)
> >   if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER)
> >      goto complete;
> > 
> >   clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> > 
> > 				# task switching to kernel space
> > 				klp_update_patch_state(A)
> > 				       if (test_and_clear_tsk_thread_flag(task,	TIF_PATCH_PENDING))
> > 				       //false
> > 
> > 				# calling kernel code with old task->patch_state
> > 
> > 	task->patch_state = klp_target_state;
> > 
> > BANG: CPU0 sets task->patch_state when task A is already running
> > 	kernel code on CPU1.
> 
> Why is that a problem? That is, who actually cares about
> task->patch_state ? I was under the impression that state was purely for
> klp itself, to track which task has observed the new state.

It is the other way. The patch_state is used in klp_ftrace_handler()
to decide which code must be used (old or new).

The state must change only when the given task is _not_ using
any patched function. Hence we do it when:

     + no patched function is on the stack  (needed primary for kthreads)
     + entering/leaving kernel              (reliable way for user space)

See "Consistency model" in Documentation/livepatch/livepatch.rst
for more details.

Best Regards,
Petr
