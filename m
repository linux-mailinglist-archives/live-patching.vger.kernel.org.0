Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B51423DC1
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbhJFMcd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 08:32:33 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58698 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbhJFMcc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 08:32:32 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1A15C1FEB3;
        Wed,  6 Oct 2021 12:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633523439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RX8HrjnICTxsGaZOGs20/A+T7SfihBzq47R0bPRXiMM=;
        b=o6/xjvZga9T0r38IEykYvxwSzgVAcoiq4caEjLs6IEAI4sGPyFdqgUZBETqWWwJ/NsXLEJ
        n76aFF5k50fhrxRWhb8LjSmTZu/c1vh6m66W2dmwqeVFlw5sEXoVORwIwq0YjjeMeqADv7
        sfKWZ2xgn7yFGwy4SW3Nf/YjndT5QG0=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BE17EA3B97;
        Wed,  6 Oct 2021 12:30:38 +0000 (UTC)
Date:   Wed, 6 Oct 2021 14:30:35 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 10/11] livepatch: Remove
 klp_synchronize_transition()
Message-ID: <YV2W60GY66Qh5Au+@alley>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.125997206@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152429.125997206@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-29 17:17:33, Peter Zijlstra wrote:
> The whole premise is broken, any trace usage outside of RCU is a BUG
> and should be fixed. Notable all code prior (and a fair bit after)
> ct_user_exit() is noinstr and explicitly doesn't allow any tracing.

I see. Is the situation the same with idle threads? I see that some
functions, called inside rcu_idle_enter()/exit() are still visible
for ftrace. For example, arch_cpu_idle() or tick_check_broadcast_expired().

That said, I am not sure if anyone would ever want to livepatch
this code. And there is still a workaround by livepatching
the callers.

Also it should be easy to catch eventual problems if we check
rcu_is_watching() in klp_ftrace_handler(). Most affected
scheduler and idle code paths will likely be called
even during the simple boot test.


> Use regular RCU, which has the benefit of actually respecting
> NOHZ_FULL.

Good to know.

After all, the patch looks good to me. I would just add something like:

--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -69,6 +69,12 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	if (WARN_ON_ONCE(!func))
 		goto unlock;
 
+	if (!rcu_is_watching()) {
+		printk_deferred_once(KERN_WARNING
+				     "warning: called \"%s\" without RCU watching. The function is not guarded by the consistency model. Also beware when removing the livepatch module.\n",
+				     func->old_name);
+	}
+
 	/*
 	 * In the enable path, enforce the order of the ops->func_stack and
 	 * func->transition reads.  The corresponding write barrier is in

But we could do this in a separate patch later.

Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
