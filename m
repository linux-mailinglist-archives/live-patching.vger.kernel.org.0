Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2179127FE29
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 13:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgJALNJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Oct 2020 07:13:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgJALNJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 07:13:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6FB4AEEE;
        Thu,  1 Oct 2020 11:13:07 +0000 (UTC)
Date:   Thu, 1 Oct 2020 13:13:07 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
cc:     live-patching@vger.kernel.org, pmladek@suse.com, nstange@suse.de
Subject: Re: Patching kthread functions
In-Reply-To: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
Message-ID: <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:

> Hi,
> 
> I wonder, can livepatch from the current mainline kernel patch the main
> functions of kthreads, which are running or sleeping constantly? Are there any
> best practices here?

No. It is a "known" limitation, "" because we discussed it a couple of 
times (at least with Petr), but it is not documented :(

I wonder if it is really an issue practically. I haven't met a case 
yet when we wanted to patch such thing. But yes, you're correct, it is not 
possible.
 
> I mean, suppose we have a function which runs in a kthread (passed to
> kthread_create()) and is organized like this:
> 
> while (!kthread_should_stop()) {
>   ...
>   DEFINE_WAIT(_wait);
>   for (;;) {
>     prepare_to_wait(waitq, &_wait, TASK_INTERRUPTIBLE);
>     if (we_have_requests_to_process || kthread_should_stop())
>       break;
>     schedule();
>   }
>   finish_wait(waitq, &_wait);
>   ...
>   if (we_have_requests_to_process)
>     process_one_request();
>   ...
> }
> 
> (The question appeared when I was looking at the following code:
> https://src.openvz.org/projects/OVZ/repos/vzkernel/browse/drivers/block/ploop/io_kaio.c?at=refs%2Ftags%2Frh7-3.10.0-1127.8.2.vz7.151.14#478)
> 
> The kthread is always running and never exits the kernel.
> 
> I could rewrite the function to add klp_update_patch_state() somewhere, but
> would it help?

In fact, we used exactly this approach in, now obsolete, kGraft. All 
kthreads had to be manually annotated somewhere safe, where safe meant 
that the thread could be switched to a new universe without the problem 
wrt to calling old/new functions in the loop...

> No locks are held right before and after "schedule()", and the thread is not
> processing any requests at that point.

... like this.

> But even if I place
> klp_update_patch_state(), say, just before schedule(), it would just switch
> task->patch_state for that kthread.

Correct.

> The old function will continue running, right?

Correct. It will, however, call new functions.

> Looks like we can only switch to the patched code of the function at the
> beginning, via Ftrace hook. So, if the function is constantly running or
> sleeping, it seems, it cannot be live-patched.

Yes and no. Normally, a task cannot run indefinitely and if it sleeps, we 
can deal with that (thanks to stack checking or signaling/kicking the 
task), but kthreads' main loops are special.

> Is that so? Are there any workarounds?

Petr, do you remember the crazy workarounds we talked about? My head is 
empty now. And I am sure, Nicolai could come up with something.

Thanks
Miroslav
