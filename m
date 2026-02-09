Return-Path: <live-patching+bounces-1997-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aELOMYtMiWl46AQAu9opvQ
	(envelope-from <live-patching+bounces-1997-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 09 Feb 2026 03:55:07 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F95910B415
	for <lists+live-patching@lfdr.de>; Mon, 09 Feb 2026 03:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE05230067BE
	for <lists+live-patching@lfdr.de>; Mon,  9 Feb 2026 02:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57A82E1722;
	Mon,  9 Feb 2026 02:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Feeh5RG7"
X-Original-To: live-patching@vger.kernel.org
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A562E0B48
	for <live-patching@vger.kernel.org>; Mon,  9 Feb 2026 02:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770605704; cv=none; b=lsW8SdfNh1SmuhexqCoYTbrbnQtLIY22mBDE8ZxB7noXJis6uCDRYEx3dcGdjx+1m4I8sCrWjgCa9tqbElWs/c7J4e059xDRUyDKvHS7pQ1ycJ0E8XqET9HsN4DKCdXCJU+2ExCXEsR2nXRqgSLZ4I0M1Nw+ZOOl/atFZrSE2hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770605704; c=relaxed/simple;
	bh=3Rv7xna7GU6ls+yEvfJMs8jGF2FgLXVQdOG8T8uZE5k=;
	h=From:Mime-Version:To:In-Reply-To:Subject:Date:Content-Type:Cc:
	 Message-Id:References; b=J7bKi9EKld2WCXqC1ENttNAVc/ncc8g7ej+c9UNhevlzMyw8tfJhEAtBv5EFCUepFwNh8gNFOBrrWNj6sZOib1UW49F1z9ufscrH4037Xsm3P0ep9+TnKhKXIbU417PzSWic5bYsWx1ZRvMw6cjjDhZPxrdX3uiivlWY+9U3Gb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Feeh5RG7; arc=none smtp.client-ip=118.26.132.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1770605691; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7+AMLgwSr/2tmZ/mf/kLOTA8fBw+YIQfAshH6RLOlc0=;
 b=Feeh5RG72c4p7RLz7wcRrK+f7KYnp48Kiv8bX0YOHSFw0/FJoYQ0vLpu6bu3XTJxUQwSEP
 LWPwmBxm7mj3iEeYvjmh2/8dHWwYu1ZOrnC0Lhl1U4fsPcF/00tbgx5GbdXTSWe0ytN4bb
 vh+kt3i5K7vqN41bJXJMhRl2vsY6TEtbZc4tUMY2O1JE3SkZA5NeZGDcZe3TdjXjrxYoG9
 HBDatoqra7vUh/oSSZxPGeoB1WWBE/oPPdr9a9W0fLO5facFil9MMz4cViBcOmSJX8DB7D
 dchHxK7sF97JEuaghv1XDOMkVwo0YBoAWHWSAajotmQzB/i7FC8s6ZiIFARjbA==
From: "Li Zhe" <lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269894c79+821897+vger.kernel.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <lizhe.67@bytedance.com>
In-Reply-To: <20260204024756.6776-1-lizhe.67@bytedance.com>
Subject: Re: [PATCH] klp: use stop machine to check and expedite transition for running tasks
Date: Mon,  9 Feb 2026 10:54:34 +0800
Content-Type: text/plain; charset=UTF-8
Cc: <jikos@kernel.org>, <joe.lawrence@redhat.com>, <jpoimboe@kernel.org>, 
	<linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>, 
	<mbenes@suse.cz>, <peterz@infradead.org>, <pmladek@suse.com>, 
	<qirui.001@bytedance.com>
Message-Id: <20260209025434.9809-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <20260204024756.6776-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1997-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[bytedance.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lizhe.67@bytedance.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bytedance.com:email,bytedance.com:dkim,bytedance.com:mid]
X-Rspamd-Queue-Id: 2F95910B415
X-Rspamd-Action: no action

On Mon, 2 Feb 2026 17:13:34 +0800, lizhe.67@bytedance.com wrote:
 
> In the current KLP transition implementation, the strategy for running
> tasks relies on waiting for a context switch to attempt to clear the
> TIF_PATCH_PENDING flag. Alternatively, determine whether the
> TIF_PATCH_PENDING flag can be cleared by inspecting the stack once the
> process has yielded the CPU. However, this approach proves problematic
> in certain environments.
> 
> Consider a scenario where the majority of system CPUs are configured
> with nohzfull and isolcpus, each dedicated to a VM with a vCPU pinned
> to that physical core and configured with idle=poll within the guest.
> Under such conditions, these vCPUs rarely leave the CPU. Combined with
> the high core counts typical of modern server platforms, this results
> in transition completion times that are not only excessively prolonged
> but also highly unpredictable.
> 
> This patch resolves this issue by registering a callback with
> stop_machine. The callback attempts to transition the associated running
> task. In a VM environment configured with 32 CPUs, the live patching
> operation completes promptly after the SIGNALS_TIMEOUT period with this
> patch applied; without it, the process nearly fails to complete under
> the same scenario.
> 
> Co-developed-by: Rui Qi <qirui.001@bytedance.com>
> Signed-off-by: Rui Qi <qirui.001@bytedance.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  kernel/livepatch/transition.c | 62 ++++++++++++++++++++++++++++++++---
>  1 file changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 2351a19ac2a9..9c078b9bd755 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -10,6 +10,7 @@
>  #include <linux/cpu.h>
>  #include <linux/stacktrace.h>
>  #include <linux/static_call.h>
> +#include <linux/stop_machine.h>
>  #include "core.h"
>  #include "patch.h"
>  #include "transition.h"
> @@ -297,6 +298,61 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
>  	return 0;
>  }
>  
> +enum klp_stop_work_bit {
> +	KLP_STOP_WORK_PENDING_BIT,
> +};
> +
> +struct klp_stop_work_info {
> +	struct task_struct *task;
> +	unsigned long flag;
> +};
> +
> +static DEFINE_PER_CPU(struct cpu_stop_work, klp_transition_stop_work);
> +static DEFINE_PER_CPU(struct klp_stop_work_info, klp_stop_work_info);
> +
> +static int klp_check_task(struct task_struct *task, void *old_name)
> +{
> +	if (task == current)
> +		return klp_check_and_switch_task(current, old_name);
> +	else
> +		return task_call_func(task, klp_check_and_switch_task, old_name);
> +}
> +
> +static int klp_transition_stop_work_fn(void *arg)
> +{
> +	struct klp_stop_work_info *info = (struct klp_stop_work_info *)arg;
> +	struct task_struct *task = info->task;
> +	const char *old_name;
> +
> +	clear_bit(KLP_STOP_WORK_PENDING_BIT, &info->flag);
> +
> +	if (likely(klp_patch_pending(task)))
> +		klp_check_task(task, &old_name);
> +
> +	put_task_struct(task);
> +
> +	return 0;
> +}
> +
> +static void klp_try_transition_running_task(struct task_struct *task)
> +{
> +	int cpu = task_cpu(task);
> +
> +	if (klp_signals_cnt && !(klp_signals_cnt % SIGNALS_TIMEOUT)) {
> +		struct klp_stop_work_info *info =
> +			per_cpu_ptr(&klp_stop_work_info, cpu);
> +
> +		if (test_and_set_bit(KLP_STOP_WORK_PENDING_BIT, &info->flag))
> +			return;
> +
> +		info->task = get_task_struct(task);
> +		if (!stop_one_cpu_nowait(cpu, klp_transition_stop_work_fn, info,
> +					 per_cpu_ptr(&klp_transition_stop_work,
> +					 cpu)))
> +			put_task_struct(task);
> +	}
> +}
> +
>  /*
>   * Try to safely switch a task to the target patch state.  If it's currently
>   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
> @@ -323,10 +379,7 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	 * functions.  If all goes well, switch the task to the target patch
>  	 * state.
>  	 */
> -	if (task == current)
> -		ret = klp_check_and_switch_task(current, &old_name);
> -	else
> -		ret = task_call_func(task, klp_check_and_switch_task, &old_name);
> +	ret = klp_check_task(task, &old_name);
>  
>  	switch (ret) {
>  	case 0:		/* success */
> @@ -335,6 +388,7 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	case -EBUSY:	/* klp_check_and_switch_task() */
>  		pr_debug("%s: %s:%d is running\n",
>  			 __func__, task->comm, task->pid);
> +		klp_try_transition_running_task(task);
>  		break;
>  	case -EINVAL:	/* klp_check_and_switch_task() */
>  		pr_debug("%s: %s:%d has an unreliable stack\n",
> -- 
> 2.20.1

Hi all,

Just a gentle ping on this patch.
Please let me know if there's anything I can improve or if you need
more information.

Thanks,
Zhe

