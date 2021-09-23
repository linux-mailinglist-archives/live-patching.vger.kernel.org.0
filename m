Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E22415DEF
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 14:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhIWMLe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 08:11:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55710 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbhIWMLe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 08:11:34 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6B22B2233D;
        Thu, 23 Sep 2021 12:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632399001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=60zH4HmS78UD32XiMlZJRxsSTbMfO5jzidDMFH51zO0=;
        b=EVhZdPg3tgzeEk5QeMdxzIAwT5d39uoswBpNhZPxw2DcRHXrQaYNM1TM+NfmPrNkiNPREU
        +mImKKSj56DQQxeAL2g8dMprHVjJiVrgcbsKYxd525lG6JMssJjx9uCTCDLq50PF5P+1rn
        oXL+iN+PpAMCXvHrk/1TEtTo6AdO8do=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 47CC225D3C;
        Thu, 23 Sep 2021 12:10:01 +0000 (UTC)
Date:   Thu, 23 Sep 2021 14:10:01 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <YUxumRtz7o/fKYri@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922110836.244770922@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-22 13:05:12, Peter Zijlstra wrote:
> Use rcu_user_{enter,exit}() calls to provide SMP ordering on context
> tracking state stores:
> 
> __context_tracking_exit()
>   __this_cpu_write(context_tracking.state, CONTEXT_KERNEL)
>   rcu_user_exit()
>     rcu_eqs_exit()
>       rcu_dynticks_eqs_eit()
>         rcu_dynticks_inc()
>           atomic_add_return() /* smp_mb */
> 
> __context_tracking_enter()
>   rcu_user_enter()
>     rcu_eqs_enter()
>       rcu_dynticks_eqs_enter()
>         rcu_dynticks_inc()
> 	  atomic_add_return() /* smp_mb */
>   __this_cpu_write(context_tracking.state, state)
> 
> This separates USER/KERNEL state with an smp_mb() on each side,
> therefore, a user of context_tracking_state_cpu() can say the CPU must
> pass through an smp_mb() before changing.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/context_tracking_state.h |   12 ++++++++++++
>  kernel/context_tracking.c              |    7 ++++---
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/context_tracking_state.h
> +++ b/include/linux/context_tracking_state.h
> @@ -45,11 +45,23 @@ static __always_inline bool context_trac
>  {
>  	return __this_cpu_read(context_tracking.state) == CONTEXT_USER;
>  }
> +
> +static __always_inline bool context_tracking_state_cpu(int cpu)
> +{
> +	struct context_tracking *ct = per_cpu_ptr(&context_tracking);

Missing cpu parameter:

	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);

> +
> +	if (!context_tracking_enabled() || !ct->active)
> +		return CONTEXT_DISABLED;
> +
> +	return ct->state;
> +}

Best Regards,
Petr
