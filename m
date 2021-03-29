Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F0834D005
	for <lists+live-patching@lfdr.de>; Mon, 29 Mar 2021 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhC2MZw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Mar 2021 08:25:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:54774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhC2MZd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Mar 2021 08:25:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617020728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N7hVAqpYAusMkHlATCXWeNNlZhd9syTrD6uQQBirn8c=;
        b=sNvwsFtpjxUjAszNASXyGeAyCB0QX1h+VK+1fE29wFDuDA5nqfu5gBVZKefdIG+QNueDW7
        1of1QLAvyu2evHAH+gxZgFEKUyZJk0tHHVKsR883sItvdIuFxqCrVFwZVvJe5IIqZD+axH
        L8p7tPc2iYjrBAG6+wMm6Vn9FgII7Nk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B6B69B471;
        Mon, 29 Mar 2021 12:25:28 +0000 (UTC)
Date:   Mon, 29 Mar 2021 14:25:28 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH] livepatch: Replace the fake signal sending with
 TIF_NOTIFY_SIGNAL infrastructure
Message-ID: <YGHHODMwuxvRiGRI@alley>
References: <20210326143021.17773-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326143021.17773-1-mbenes@suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-03-26 15:30:21, Miroslav Benes wrote:
> Livepatch sends a fake signal to all remaining blocking tasks of a
> running transition after a set period of time. It uses TIF_SIGPENDING
> flag for the purpose. Commit 12db8b690010 ("entry: Add support for
> TIF_NOTIFY_SIGNAL") added a generic infrastructure to achieve the same.
> Replace our bespoke solution with the generic one.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
> Tested on x86_64, s390x and ppc64le archs.
> 
>  kernel/livepatch/transition.c | 5 ++---
>  kernel/signal.c               | 3 +--
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f6310f848f34..3a4beb9395c4 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/stacktrace.h>
> +#include <linux/tracehook.h>
>  #include "core.h"
>  #include "patch.h"
>  #include "transition.h"
> @@ -369,9 +370,7 @@ static void klp_send_signals(void)
>  			 * Send fake signal to all non-kthread tasks which are
>  			 * still not migrated.
>  			 */
> -			spin_lock_irq(&task->sighand->siglock);
> -			signal_wake_up(task, 0);
> -			spin_unlock_irq(&task->sighand->siglock);
> +			set_notify_signal(task);
>  		}
>  	}
>  	read_unlock(&tasklist_lock);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index f2a1b898da29..e52cb82aaecd 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -181,8 +181,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
>  
>  void recalc_sigpending(void)
>  {
> -	if (!recalc_sigpending_tsk(current) && !freezing(current) &&
> -	    !klp_patch_pending(current))
> +	if (!recalc_sigpending_tsk(current) && !freezing(current))
>  		clear_thread_flag(TIF_SIGPENDING);
>  
>  }

The original commit 43347d56c8d9dd732cee2 ("livepatch: send a fake
signal to all blocking tasks") did also:

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -40,6 +40,7 @@
 #include <linux/cn_proc.h>
 #include <linux/compiler.h>
 #include <linux/posix-timers.h>
+#include <linux/livepatch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>

We could/should remove the include now.

Otherwise, it looks good to me. Well, I do not feel to be expert
in this are. Anyway, feel free to add:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
