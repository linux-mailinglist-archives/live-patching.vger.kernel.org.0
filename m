Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C530E26
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEaMch (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 08:32:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:34578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbfEaMcg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 08:32:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08C13AD96;
        Fri, 31 May 2019 12:32:35 +0000 (UTC)
Date:   Fri, 31 May 2019 14:32:34 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
In-Reply-To: <20190531074147.27616-3-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1905311425450.742@pobox.suse.cz>
References: <20190531074147.27616-1-pmladek@suse.com> <20190531074147.27616-3-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 31 May 2019, Petr Mladek wrote:

> WARN_ON_ONCE() could not be called safely under rq lock because
> of console deadlock issues.
> 
> It can be simply removed. A better descriptive message is written
> in klp_enable_patch() when klp_have_reliable_stack() fails.
> The remaining debug message is good enough.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/transition.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index abb2a4a2cbb2..1bf362df76e1 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -247,7 +247,6 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
>  	int ret, nr_entries;
>  
>  	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
> -	WARN_ON_ONCE(ret == -ENOSYS);
>  	if (ret < 0) {
>  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
>  			 "%s: %s:%d has an unreliable stack\n",

The current situation is not the best, but I think the patch improves it 
only slightly. I see two possible solutions.

1. we either revert commit 1d98a69e5cef ("livepatch: Remove reliable 
stacktrace check in klp_try_switch_task()"), so that klp_check_stack() 
returns right away.

2. or we test ret from stack_trace_save_tsk_reliable() for ENOSYS and 
return.

In my opinion either of them is better than what we have now (and what we 
would have with the patch), because klp_check_stack() returns, but it 
prints out that a task has an unreliable stack. Yes, it is pr_debug() only 
in the end, but still.

I don't have a preference and my understanding is that Petr does not want 
to do v4. I can prepare a patch, but it would be nice to choose now. Josh? 
Anyone else?

Miroslav
