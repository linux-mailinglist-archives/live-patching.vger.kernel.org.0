Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E116234D199
	for <lists+live-patching@lfdr.de>; Mon, 29 Mar 2021 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhC2NqG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Mar 2021 09:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhC2Npo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Mar 2021 09:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617025543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0y2XlpOQ1zPIm8nre1SSlzdpsIZsBs0a+WqNhPR+L+k=;
        b=OV9GAZtOsyP7jyjSWLtjnDKG1tny9xHNedh5N3RH0FgE7sYIxk/fsDmrtBkJ4oKcXlBvIk
        mVKElFGT1ZYcHF17EJtMLLM9L1VeVfhOQk9ayLw03t22kyDiZw1+OiF+ecio9x4F6VUb1u
        3H3+tjieTU3lxGOLI2c68sB8k2zr92k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-FMEv17uKOpSmyn2AsymNJA-1; Mon, 29 Mar 2021 09:45:41 -0400
X-MC-Unique: FMEv17uKOpSmyn2AsymNJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED4BA84B9A0;
        Mon, 29 Mar 2021 13:45:39 +0000 (UTC)
Received: from [10.10.112.16] (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5309560CFB;
        Mon, 29 Mar 2021 13:45:38 +0000 (UTC)
Subject: Re: [PATCH v2] livepatch: Replace the fake signal sending with
 TIF_NOTIFY_SIGNAL infrastructure
To:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
References: <20210329132815.10035-1-mbenes@suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <c6dd4315-2e90-8786-e5ec-a377ac8c12f9@redhat.com>
Date:   Mon, 29 Mar 2021 09:45:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210329132815.10035-1-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/29/21 9:28 AM, Miroslav Benes wrote:
> Livepatch sends a fake signal to all remaining blocking tasks of a
> running transition after a set period of time. It uses TIF_SIGPENDING
> flag for the purpose. Commit 12db8b690010 ("entry: Add support for
> TIF_NOTIFY_SIGNAL") added a generic infrastructure to achieve the same.
> Replace our bespoke solution with the generic one.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
> v2:
> - #include from kernel/signal.c removed [Petr]
> 
>   kernel/livepatch/transition.c | 5 ++---
>   kernel/signal.c               | 4 +---
>   2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f6310f848f34..3a4beb9395c4 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -9,6 +9,7 @@
>   
>   #include <linux/cpu.h>
>   #include <linux/stacktrace.h>
> +#include <linux/tracehook.h>
>   #include "core.h"
>   #include "patch.h"
>   #include "transition.h"
> @@ -369,9 +370,7 @@ static void klp_send_signals(void)
>   			 * Send fake signal to all non-kthread tasks which are
>   			 * still not migrated.
>   			 */
> -			spin_lock_irq(&task->sighand->siglock);
> -			signal_wake_up(task, 0);
> -			spin_unlock_irq(&task->sighand->siglock);
> +			set_notify_signal(task);
>   		}
>   	}
>   	read_unlock(&tasklist_lock);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index f2a1b898da29..604290a8ca89 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -43,7 +43,6 @@
>   #include <linux/cn_proc.h>
>   #include <linux/compiler.h>
>   #include <linux/posix-timers.h>
> -#include <linux/livepatch.h>
>   #include <linux/cgroup.h>
>   #include <linux/audit.h>
>   
> @@ -181,8 +180,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
>   
>   void recalc_sigpending(void)
>   {
> -	if (!recalc_sigpending_tsk(current) && !freezing(current) &&
> -	    !klp_patch_pending(current))
> +	if (!recalc_sigpending_tsk(current) && !freezing(current))
>   		clear_thread_flag(TIF_SIGPENDING);
>   
>   }
> 

Looks good to me.  Thanks for checking on this and updating.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe

