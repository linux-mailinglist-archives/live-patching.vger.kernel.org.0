Return-Path: <live-patching+bounces-22-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D00367E4C9B
	for <lists+live-patching@lfdr.de>; Wed,  8 Nov 2023 00:16:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6B021C20A7B
	for <lists+live-patching@lfdr.de>; Tue,  7 Nov 2023 23:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379D43066C;
	Tue,  7 Nov 2023 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4BC210B
	for <live-patching@vger.kernel.org>; Tue,  7 Nov 2023 23:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C5FC433C8;
	Tue,  7 Nov 2023 23:16:07 +0000 (UTC)
Date: Tue, 7 Nov 2023 18:16:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
 torvalds@linux-foundation.org, paulmck@kernel.org, linux-mm@kvack.org,
 x86@kernel.org, akpm@linux-foundation.org, luto@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, willy@infradead.org,
 mgorman@suse.de, jon.grimm@amd.com, bharata@amd.com,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 jgross@suse.com, andrew.cooper3@citrix.com, mingo@kernel.org,
 bristot@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org,
 glaubitz@physik.fu-berlin.de, anton.ivanov@cambridgegreys.com,
 mattst88@gmail.com, krypton@ulrich-teichert.org, David.Laight@ACULAB.COM,
 richard@nod.at, mjguzik@gmail.com, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 07/86] Revert "livepatch,sched: Add livepatch task
 switching to cond_resched()"
Message-ID: <20231107181609.7e9e9dcc@gandalf.local.home>
In-Reply-To: <20231107215742.363031-8-ankur.a.arora@oracle.com>
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
	<20231107215742.363031-8-ankur.a.arora@oracle.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 Nov 2023 13:56:53 -0800
Ankur Arora <ankur.a.arora@oracle.com> wrote:

> This reverts commit e3ff7c609f39671d1aaff4fb4a8594e14f3e03f8.
> 
> Note that removing this commit reintroduces "live patches failing to
> complete within a reasonable amount of time due to CPU-bound kthreads."
> 
> Unfortunately this fix depends quite critically on PREEMPT_DYNAMIC and
> existence of cond_resched() so this will need an alternate fix.
> 

Then it would probably be a good idea to Cc the live patching maintainers!

-- Steve

> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  include/linux/livepatch.h       |   1 -
>  include/linux/livepatch_sched.h |  29 ---------
>  include/linux/sched.h           |  20 ++----
>  kernel/livepatch/core.c         |   1 -
>  kernel/livepatch/transition.c   | 107 +++++---------------------------
>  kernel/sched/core.c             |  64 +++----------------
>  6 files changed, 28 insertions(+), 194 deletions(-)
>  delete mode 100644 include/linux/livepatch_sched.h
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9b9b38e89563..293e29960c6e 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -13,7 +13,6 @@
>  #include <linux/ftrace.h>
>  #include <linux/completion.h>
>  #include <linux/list.h>
> -#include <linux/livepatch_sched.h>
>  
>  #if IS_ENABLED(CONFIG_LIVEPATCH)
>  
> diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
> deleted file mode 100644
> index 013794fb5da0..000000000000
> --- a/include/linux/livepatch_sched.h
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -#ifndef _LINUX_LIVEPATCH_SCHED_H_
> -#define _LINUX_LIVEPATCH_SCHED_H_
> -
> -#include <linux/jump_label.h>
> -#include <linux/static_call_types.h>
> -
> -#ifdef CONFIG_LIVEPATCH
> -
> -void __klp_sched_try_switch(void);
> -
> -#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
> -
> -DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
> -
> -static __always_inline void klp_sched_try_switch(void)
> -{
> -	if (static_branch_unlikely(&klp_sched_try_switch_key))
> -		__klp_sched_try_switch();
> -}
> -
> -#endif /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> -
> -#else /* !CONFIG_LIVEPATCH */
> -static inline void klp_sched_try_switch(void) {}
> -static inline void __klp_sched_try_switch(void) {}
> -#endif /* CONFIG_LIVEPATCH */
> -
> -#endif /* _LINUX_LIVEPATCH_SCHED_H_ */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5bdf80136e42..c5b0ef1ecfe4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -36,7 +36,6 @@
>  #include <linux/seqlock.h>
>  #include <linux/kcsan.h>
>  #include <linux/rv.h>
> -#include <linux/livepatch_sched.h>
>  #include <asm/kmap_size.h>
>  
>  /* task_struct member predeclarations (sorted alphabetically): */
> @@ -2087,9 +2086,6 @@ extern int __cond_resched(void);
>  
>  #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
>  
> -void sched_dynamic_klp_enable(void);
> -void sched_dynamic_klp_disable(void);
> -
>  DECLARE_STATIC_CALL(cond_resched, __cond_resched);
>  
>  static __always_inline int _cond_resched(void)
> @@ -2098,7 +2094,6 @@ static __always_inline int _cond_resched(void)
>  }
>  
>  #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_KEY)
> -
>  extern int dynamic_cond_resched(void);
>  
>  static __always_inline int _cond_resched(void)
> @@ -2106,25 +2101,20 @@ static __always_inline int _cond_resched(void)
>  	return dynamic_cond_resched();
>  }
>  
> -#else /* !CONFIG_PREEMPTION */
> +#else
>  
>  static inline int _cond_resched(void)
>  {
> -	klp_sched_try_switch();
>  	return __cond_resched();
>  }
>  
> -#endif /* PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> +#endif /* CONFIG_PREEMPT_DYNAMIC */
>  
> -#else /* CONFIG_PREEMPTION && !CONFIG_PREEMPT_DYNAMIC */
> +#else
>  
> -static inline int _cond_resched(void)
> -{
> -	klp_sched_try_switch();
> -	return 0;
> -}
> +static inline int _cond_resched(void) { return 0; }
>  
> -#endif /* !CONFIG_PREEMPTION || CONFIG_PREEMPT_DYNAMIC */
> +#endif /* !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC) */
>  
>  #define cond_resched() ({			\
>  	__might_resched(__FILE__, __LINE__, 0);	\
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 61328328c474..fc851455740c 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -33,7 +33,6 @@
>   *
>   * - klp_ftrace_handler()
>   * - klp_update_patch_state()
> - * - __klp_sched_try_switch()
>   */
>  DEFINE_MUTEX(klp_mutex);
>  
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index e54c3d60a904..70bc38f27af7 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -9,7 +9,6 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/stacktrace.h>
> -#include <linux/static_call.h>
>  #include "core.h"
>  #include "patch.h"
>  #include "transition.h"
> @@ -27,25 +26,6 @@ static int klp_target_state = KLP_UNDEFINED;
>  
>  static unsigned int klp_signals_cnt;
>  
> -/*
> - * When a livepatch is in progress, enable klp stack checking in
> - * cond_resched().  This helps CPU-bound kthreads get patched.
> - */
> -#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
> -
> -#define klp_cond_resched_enable() sched_dynamic_klp_enable()
> -#define klp_cond_resched_disable() sched_dynamic_klp_disable()
> -
> -#else /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> -
> -DEFINE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
> -EXPORT_SYMBOL(klp_sched_try_switch_key);
> -
> -#define klp_cond_resched_enable() static_branch_enable(&klp_sched_try_switch_key)
> -#define klp_cond_resched_disable() static_branch_disable(&klp_sched_try_switch_key)
> -
> -#endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> -
>  /*
>   * This work can be performed periodically to finish patching or unpatching any
>   * "straggler" tasks which failed to transition in the first attempt.
> @@ -194,8 +174,8 @@ void klp_update_patch_state(struct task_struct *task)
>  	 * barrier (smp_rmb) for two cases:
>  	 *
>  	 * 1) Enforce the order of the TIF_PATCH_PENDING read and the
> -	 *    klp_target_state read.  The corresponding write barriers are in
> -	 *    klp_init_transition() and klp_reverse_transition().
> +	 *    klp_target_state read.  The corresponding write barrier is in
> +	 *    klp_init_transition().
>  	 *
>  	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
>  	 *    of func->transition, if klp_ftrace_handler() is called later on
> @@ -363,44 +343,6 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	return !ret;
>  }
>  
> -void __klp_sched_try_switch(void)
> -{
> -	if (likely(!klp_patch_pending(current)))
> -		return;
> -
> -	/*
> -	 * This function is called from cond_resched() which is called in many
> -	 * places throughout the kernel.  Using the klp_mutex here might
> -	 * deadlock.
> -	 *
> -	 * Instead, disable preemption to prevent racing with other callers of
> -	 * klp_try_switch_task().  Thanks to task_call_func() they won't be
> -	 * able to switch this task while it's running.
> -	 */
> -	preempt_disable();
> -
> -	/*
> -	 * Make sure current didn't get patched between the above check and
> -	 * preempt_disable().
> -	 */
> -	if (unlikely(!klp_patch_pending(current)))
> -		goto out;
> -
> -	/*
> -	 * Enforce the order of the TIF_PATCH_PENDING read above and the
> -	 * klp_target_state read in klp_try_switch_task().  The corresponding
> -	 * write barriers are in klp_init_transition() and
> -	 * klp_reverse_transition().
> -	 */
> -	smp_rmb();
> -
> -	klp_try_switch_task(current);
> -
> -out:
> -	preempt_enable();
> -}
> -EXPORT_SYMBOL(__klp_sched_try_switch);
> -
>  /*
>   * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
>   * Kthreads with TIF_PATCH_PENDING set are woken up.
> @@ -507,8 +449,7 @@ void klp_try_complete_transition(void)
>  		return;
>  	}
>  
> -	/* Done!  Now cleanup the data structures. */
> -	klp_cond_resched_disable();
> +	/* we're done, now cleanup the data structures */
>  	patch = klp_transition_patch;
>  	klp_complete_transition();
>  
> @@ -560,8 +501,6 @@ void klp_start_transition(void)
>  			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
>  	}
>  
> -	klp_cond_resched_enable();
> -
>  	klp_signals_cnt = 0;
>  }
>  
> @@ -617,9 +556,8 @@ void klp_init_transition(struct klp_patch *patch, int state)
>  	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
>  	 *
>  	 * Also enforce the order of the klp_target_state write and future
> -	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
> -	 * __klp_sched_try_switch() don't set a task->patch_state to
> -	 * KLP_UNDEFINED.
> +	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() doesn't
> +	 * set a task->patch_state to KLP_UNDEFINED.
>  	 */
>  	smp_wmb();
>  
> @@ -655,10 +593,14 @@ void klp_reverse_transition(void)
>  		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
>  						   "unpatching to patching");
>  
> +	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> +
> +	klp_target_state = !klp_target_state;
> +
>  	/*
>  	 * Clear all TIF_PATCH_PENDING flags to prevent races caused by
> -	 * klp_update_patch_state() or __klp_sched_try_switch() running in
> -	 * parallel with the reverse transition.
> +	 * klp_update_patch_state() running in parallel with
> +	 * klp_start_transition().
>  	 */
>  	read_lock(&tasklist_lock);
>  	for_each_process_thread(g, task)
> @@ -668,28 +610,9 @@ void klp_reverse_transition(void)
>  	for_each_possible_cpu(cpu)
>  		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
>  
> -	/*
> -	 * Make sure all existing invocations of klp_update_patch_state() and
> -	 * __klp_sched_try_switch() see the cleared TIF_PATCH_PENDING before
> -	 * starting the reverse transition.
> -	 */
> +	/* Let any remaining calls to klp_update_patch_state() complete */
>  	klp_synchronize_transition();
>  
> -	/*
> -	 * All patching has stopped, now re-initialize the global variables to
> -	 * prepare for the reverse transition.
> -	 */
> -	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> -	klp_target_state = !klp_target_state;
> -
> -	/*
> -	 * Enforce the order of the klp_target_state write and the
> -	 * TIF_PATCH_PENDING writes in klp_start_transition() to ensure
> -	 * klp_update_patch_state() and __klp_sched_try_switch() don't set
> -	 * task->patch_state to the wrong value.
> -	 */
> -	smp_wmb();
> -
>  	klp_start_transition();
>  }
>  
> @@ -703,9 +626,9 @@ void klp_copy_process(struct task_struct *child)
>  	 * the task flag up to date with the parent here.
>  	 *
>  	 * The operation is serialized against all klp_*_transition()
> -	 * operations by the tasklist_lock. The only exceptions are
> -	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
> -	 * cannot race with them because we are current.
> +	 * operations by the tasklist_lock. The only exception is
> +	 * klp_update_patch_state(current), but we cannot race with
> +	 * that because we are current.
>  	 */
>  	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
>  		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0e8764d63041..b43fda3c5733 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8597,7 +8597,6 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
>  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
>  int __sched dynamic_cond_resched(void)
>  {
> -	klp_sched_try_switch();
>  	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
>  		return 0;
>  	return __cond_resched();
> @@ -8746,17 +8745,13 @@ int sched_dynamic_mode(const char *str)
>  #error "Unsupported PREEMPT_DYNAMIC mechanism"
>  #endif
>  
> -DEFINE_MUTEX(sched_dynamic_mutex);
> -static bool klp_override;
> -
> -static void __sched_dynamic_update(int mode)
> +void sched_dynamic_update(int mode)
>  {
>  	/*
>  	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
>  	 * the ZERO state, which is invalid.
>  	 */
> -	if (!klp_override)
> -		preempt_dynamic_enable(cond_resched);
> +	preempt_dynamic_enable(cond_resched);
>  	preempt_dynamic_enable(might_resched);
>  	preempt_dynamic_enable(preempt_schedule);
>  	preempt_dynamic_enable(preempt_schedule_notrace);
> @@ -8764,79 +8759,36 @@ static void __sched_dynamic_update(int mode)
>  
>  	switch (mode) {
>  	case preempt_dynamic_none:
> -		if (!klp_override)
> -			preempt_dynamic_enable(cond_resched);
> +		preempt_dynamic_enable(cond_resched);
>  		preempt_dynamic_disable(might_resched);
>  		preempt_dynamic_disable(preempt_schedule);
>  		preempt_dynamic_disable(preempt_schedule_notrace);
>  		preempt_dynamic_disable(irqentry_exit_cond_resched);
> -		if (mode != preempt_dynamic_mode)
> -			pr_info("Dynamic Preempt: none\n");
> +		pr_info("Dynamic Preempt: none\n");
>  		break;
>  
>  	case preempt_dynamic_voluntary:
> -		if (!klp_override)
> -			preempt_dynamic_enable(cond_resched);
> +		preempt_dynamic_enable(cond_resched);
>  		preempt_dynamic_enable(might_resched);
>  		preempt_dynamic_disable(preempt_schedule);
>  		preempt_dynamic_disable(preempt_schedule_notrace);
>  		preempt_dynamic_disable(irqentry_exit_cond_resched);
> -		if (mode != preempt_dynamic_mode)
> -			pr_info("Dynamic Preempt: voluntary\n");
> +		pr_info("Dynamic Preempt: voluntary\n");
>  		break;
>  
>  	case preempt_dynamic_full:
> -		if (!klp_override)
> -			preempt_dynamic_disable(cond_resched);
> +		preempt_dynamic_disable(cond_resched);
>  		preempt_dynamic_disable(might_resched);
>  		preempt_dynamic_enable(preempt_schedule);
>  		preempt_dynamic_enable(preempt_schedule_notrace);
>  		preempt_dynamic_enable(irqentry_exit_cond_resched);
> -		if (mode != preempt_dynamic_mode)
> -			pr_info("Dynamic Preempt: full\n");
> +		pr_info("Dynamic Preempt: full\n");
>  		break;
>  	}
>  
>  	preempt_dynamic_mode = mode;
>  }
>  
> -void sched_dynamic_update(int mode)
> -{
> -	mutex_lock(&sched_dynamic_mutex);
> -	__sched_dynamic_update(mode);
> -	mutex_unlock(&sched_dynamic_mutex);
> -}
> -
> -#ifdef CONFIG_HAVE_PREEMPT_DYNAMIC_CALL
> -
> -static int klp_cond_resched(void)
> -{
> -	__klp_sched_try_switch();
> -	return __cond_resched();
> -}
> -
> -void sched_dynamic_klp_enable(void)
> -{
> -	mutex_lock(&sched_dynamic_mutex);
> -
> -	klp_override = true;
> -	static_call_update(cond_resched, klp_cond_resched);
> -
> -	mutex_unlock(&sched_dynamic_mutex);
> -}
> -
> -void sched_dynamic_klp_disable(void)
> -{
> -	mutex_lock(&sched_dynamic_mutex);
> -
> -	klp_override = false;
> -	__sched_dynamic_update(preempt_dynamic_mode);
> -
> -	mutex_unlock(&sched_dynamic_mutex);
> -}
> -
> -#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> -
>  static int __init setup_preempt_mode(char *str)
>  {
>  	int mode = sched_dynamic_mode(str);


