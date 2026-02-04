Return-Path: <live-patching+bounces-1975-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id m4MKFeysgmliYAMAu9opvQ
	(envelope-from <live-patching+bounces-1975-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:20:28 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A5175E0C39
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58E1B30234CD
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B1227467F;
	Wed,  4 Feb 2026 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm/Xh62q"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE53256C8B;
	Wed,  4 Feb 2026 02:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770171625; cv=none; b=D8x+oT+8NBPwRGT62PVnnE+TPXMLo+iKypUhrLyDRAdiBQPAobarNzRXZUsZlOUKfgtGWetomcsYklRFszEzSHKUHE8Cwco7FJijnGVl1PF+uzM8BbYk4S7XwE6bo38QnkB8msV+rprKPdDbtAiY2MuGvVqgStzqB9ZxIuxf91w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770171625; c=relaxed/simple;
	bh=cxAuoW30AWlNck7xb3uD1X6PKEvTUVee9oHeXxchGPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbOs1MhUKasrQpCc3R15MnfDQB7lbgHkykXABlu3+i+X1zyYYQd5Cpb0K8DoTLRj2zo+pp4R3wIl9iVIo3xrUXbU75sygTumlIdbKbvpgG1HP1oJ4AHdA/YsWIpvAHuaf8PhauwRYpcccBUQRZtIYYbWqSdW38VgLkmyXqYNlNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm/Xh62q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E531C16AAE;
	Wed,  4 Feb 2026 02:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770171624;
	bh=cxAuoW30AWlNck7xb3uD1X6PKEvTUVee9oHeXxchGPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qm/Xh62qTlxdx9W+zKe+P2Clp+9VpcDACykzHebA1SAlz0fpUjbovKine2V7qNeQq
	 +Sr7mqzSGArFHk2+FCUcW4qSsA/7Pd6a8VJPjwyzi1RCwGnIPLTJI2Dt7SkdJwDLua
	 FslB+VFoWnqiffXdiiOY5FUS7MsTQnz7fmJo2xNOF9OEflfk+nfzvuDFKkTL4t6vXe
	 hGIiBxYl3WsFCm/QxEzXYCb+hQagNEDZu6mmQJKiELsz8hNNe26VIYUJ2eulsR6+gZ
	 bTYY56Ip3rhL6oXjhY/H2iM2zdO+kAlnkhvKrNxB9clIVaX3zMLIb00pRFER8Dt2DT
	 rOBPyDE6riu8A==
Date: Tue, 3 Feb 2026 18:20:22 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	qirui.001@bytedance.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] klp: use stop machine to check and expedite transition
 for running tasks
Message-ID: <5vctv762jvnxiselc3vwattfsgegw6uv7kltsp27qtoajel2rl@kjrg4ko74gcn>
References: <20260202091334.60881-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260202091334.60881-1-lizhe.67@bytedance.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1975-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bytedance.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5175E0C39
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 05:13:34PM +0800, Li Zhe wrote:
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

PeterZ, what's your take on this?

I wonder if we could instead do resched_cpu() or something similar to
trigger the call to klp_sched_try_switch() in __schedule()?

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

-- 
Josh

