Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8A414CD7
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 17:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhIVPSw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 11:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhIVPSv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 11:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F4960EDF;
        Wed, 22 Sep 2021 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632323841;
        bh=EeNtYnKR/zbvqktKcr7IxoT4NGlAurhldlhJw+CCHJk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YMDrmg8Zpk0QZ+L003K7khdXGv/qB4Hb9j2uEexYLUv9SF6H0lk2MVVi9dPc+BIhg
         RY+iq7LImWW/7gviNBZzidavLRtQhSKlNB63WaFoM9Kms+xy13srpMzyDtdUNw0jpR
         eUn+BgcF0ODuYksDeVeUqbEtrDRup97BzIYOl6HONKvHJgdnaVIyI+VmwNC9xQvF2g
         FbS9wZLCkhkQqOAJpfG5DphRNQ8syV824Kfp4ymmHkve9lRfhYWuy78sMjzC9WIypT
         NUe9j1Jd0wu9WVKxXfhIcv4c8YaxUWd3FYYe9/HiWs+4uC1Iv0Su8QgS1NIPI+BtVE
         NhMJQZeu4wSQw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 3E37E5C0F12; Wed, 22 Sep 2021 08:17:21 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:17:21 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922110836.244770922@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 01:05:12PM +0200, Peter Zijlstra wrote:
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

For the transformation to negative errno return value and name change
from an RCU perspective:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

For the sampling of nohz_full userspace state:

Another approach is for the rcu_data structure's ->dynticks variable to
use the lower two bits to differentiate between idle, nohz_full userspace
and kernel.  In theory, inlining should make this zero cost for idle
transition, and should allow you to safely sample nohz_full userspace
state with a load and a couple of memory barriers instead of an IPI.

To make this work nicely, the low-order bits have to be 00 for kernel,
and (say) 01 for idle and 10 for nohz_full userspace.  11 would be an
error.

The trick would be for rcu_user_enter() and rcu_user_exit() to atomically
increment ->dynticks by 2, for rcu_nmi_exit() to increment by 1 and
rcu_nmi_enter() to increment by 3.  The state sampling would need to
change accordingly.

Does this make sense, or am I missing something?

							Thanx, Paul

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
> +
> +	if (!context_tracking_enabled() || !ct->active)
> +		return CONTEXT_DISABLED;
> +
> +	return ct->state;
> +}
> +
>  #else
>  static inline bool context_tracking_in_user(void) { return false; }
>  static inline bool context_tracking_enabled(void) { return false; }
>  static inline bool context_tracking_enabled_cpu(int cpu) { return false; }
>  static inline bool context_tracking_enabled_this_cpu(void) { return false; }
> +static inline bool context_tracking_state_cpu(int cpu) { return CONTEXT_DISABLED; }
>  #endif /* CONFIG_CONTEXT_TRACKING */
>  
>  #endif
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -82,7 +82,7 @@ void noinstr __context_tracking_enter(en
>  				vtime_user_enter(current);
>  				instrumentation_end();
>  			}
> -			rcu_user_enter();
> +			rcu_user_enter(); /* smp_mb */
>  		}
>  		/*
>  		 * Even if context tracking is disabled on this CPU, because it's outside
> @@ -149,12 +149,14 @@ void noinstr __context_tracking_exit(enu
>  		return;
>  
>  	if (__this_cpu_read(context_tracking.state) == state) {
> +		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
> +
>  		if (__this_cpu_read(context_tracking.active)) {
>  			/*
>  			 * We are going to run code that may use RCU. Inform
>  			 * RCU core about that (ie: we may need the tick again).
>  			 */
> -			rcu_user_exit();
> +			rcu_user_exit(); /* smp_mb */
>  			if (state == CONTEXT_USER) {
>  				instrumentation_begin();
>  				vtime_user_exit(current);
> @@ -162,7 +164,6 @@ void noinstr __context_tracking_exit(enu
>  				instrumentation_end();
>  			}
>  		}
> -		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
>  	}
>  	context_tracking_recursion_exit();
>  }
> 
> 
