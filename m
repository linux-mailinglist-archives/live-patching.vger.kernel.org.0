Return-Path: <live-patching+bounces-1227-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BF7A44AB4
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 19:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E93D83BB2A8
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 18:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2BF1C8626;
	Tue, 25 Feb 2025 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVOiPB79"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176B41C8602;
	Tue, 25 Feb 2025 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740508391; cv=none; b=mjsK5FLcKaidL/u36BL/Nw9ZpWaiUYUmJuXcNLGsGD60EtmksKwXa3w+1CaKCivOC8weY4GzeOK5UYgM+4ugnwLTC6ZiXCybLV42ZG46EVrAVXlx+VZqVadak1/9Pq8vbve1hW3V6jEfQms7E9HukK3SCEVqeCfyMkaUxMJfd/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740508391; c=relaxed/simple;
	bh=03NqTDrUs0oMO9xVqWE+ZbeCfpofpmt7PAlvxMuUudU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdBCsxzkQlr16SNByPhMQeEM6yf9paeOLZhRDt4jwFNmpfCJXeONxyZM1BsD93wzfdge2XKz1io/VeTLdUjcaCZ8COJeDuBOBryfEcswwAC7FFhcf5QRD295jzW8mTv0oxrxBX8keSxiuiDXAg/gyEBDOeSY324ymKSNcSEvm8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVOiPB79; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAD8C4CEDD;
	Tue, 25 Feb 2025 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740508390;
	bh=03NqTDrUs0oMO9xVqWE+ZbeCfpofpmt7PAlvxMuUudU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVOiPB79Rqw0x71AHmLqjt0kR1L9ieScgWEwU0ZJ2MZ3duW88KCLUaChtLjPMAklC
	 fD61BHnainx9uHmhCHl77RITR5IeMNOvLjXJudrpH5k7kMQ+kFbZHHYm7R7JA9GLEc
	 blYxFgwEjm7gYKte3ihH7iURUBuBrgQiMyiDbQm6Fkbw2ejjTZ5COFEPxzbrAKJ5Fm
	 0tqxD8bV2ZcdFZuihHebw0t0PqDQq3fBHman/m8Ux3ODYhqfW5lm9SrnOevNCJVptI
	 3dY8QghUDmtgKs+W9qqXkTe6l8LrVe8ApUGULNvv/6IJpBHsdFFAE3XF6K5OfJgO+l
	 woc06mva7u0uQ==
Date: Tue, 25 Feb 2025 10:33:08 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Replace tasklist_lock with RCU
Message-ID: <20250225183308.yjtgdl3esisvlhab@jpoimboe>
References: <20250223062046.2943-1-laoar.shao@gmail.com>
 <20250223062046.2943-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250223062046.2943-3-laoar.shao@gmail.com>

On Sun, Feb 23, 2025 at 02:20:46PM +0800, Yafang Shao wrote:
> +++ b/kernel/livepatch/patch.c
> @@ -95,7 +95,12 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  
>  		patch_state = current->patch_state;
>  
> -		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
> +		/* If the patch_state is KLP_TRANSITION_IDLE, it indicates the
> +		 * task was forked after klp_init_transition(). For this newly
> +		 * forked task, it is safe to switch it to klp_target_state.
> +		 */
> +		if (patch_state == KLP_TRANSITION_IDLE)
> +			current->patch_state = klp_target_state;

Hm, but then the following line is:

>  		if (patch_state == KLP_TRANSITION_UNPATCHED) {

Shouldn't the local 'patch_state' variable be updated?

It also seems unnecessary to update 'current->patch_state' here.

> @@ -294,6 +294,13 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
>  {
>  	int ret;
>  
> +	/* If the patch_state remains KLP_TRANSITION_IDLE at this point, it
> +	 * indicates that the task was forked after klp_init_transition(). For
> +	 * this newly forked task, it is now safe to perform the switch.
> +	 */
> +	if (task->patch_state == KLP_TRANSITION_IDLE)
> +		goto out;
> +

This also seems unnecessary.  No need to transition the patch if the
ftrace handler is already doing the right thing.  klp_try_switch_task()
can just return early on !TIF_PATCH_PENDING.

> @@ -466,11 +474,11 @@ void klp_try_complete_transition(void)
>  	 * Usually this will transition most (or all) of the tasks on a system
>  	 * unless the patch includes changes to a very common function.
>  	 */
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	for_each_process_thread(g, task)
>  		if (!klp_try_switch_task(task))
>  			complete = false;
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();

Can this also be done for the idle tasks?

-- 
Josh

