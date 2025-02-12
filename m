Return-Path: <live-patching+bounces-1151-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAB9A31AA1
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 01:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B553A75B3
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 00:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189812BD04;
	Wed, 12 Feb 2025 00:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuUOXsLu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78C02AE96
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 00:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739320812; cv=none; b=FjXnxU1QPjCz/KoaAATliJ1HqZht7u/8lsIfHAlBLTJLAdF7jW4ARqgOqykcn1bRyj84LfOxjA8Nw1kGU9bG7PxFtN5HS+5QNGULuATgBlaIBzv/SygQPyXL7okstnjVZnWd0iV8Eh3nyNbKYftmghn6+JFuLB832h3A+VgqU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739320812; c=relaxed/simple;
	bh=W9np9OkGV8m6Ln2vKTQ77h0ki2+BkuYpxfPJ9XdCdiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6cs3dfmeLKmZE5BkOHw2WjCs4rTuXnKnq9qcAWPZYOW2MigsEeHRVSQBBiWC9u9A7Z2Bp3L6Fz+45HXXeer+W4J+V7IZ4yuCLfb7cC/vicj3yu3MPuLZhV5Knx1yl/P/5Oxl1Hv2IlTQpRVyZkZlKV1mS2UlQvFVaJSDth1U7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuUOXsLu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3EAC4CEDD;
	Wed, 12 Feb 2025 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739320811;
	bh=W9np9OkGV8m6Ln2vKTQ77h0ki2+BkuYpxfPJ9XdCdiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kuUOXsLuEkXCAn+7JwIgyLFzGTWJj+0YFre6vEDX+aGY6hsKmUANQpOdGY733biz4
	 P+xJhIb2LsYCpnSzUi90C+mBB4VSV1yqgzZ7UvvNEJRZ64Et8yebvBwPrNs8JlNrMR
	 yr6GUY8q01C6Yel4GpFyrVPGuJXnpB/rhMrwqv5EI5IiIUk2PrL3HpJ/3N/MrQ8sLw
	 WNRQ6rJIlLRlL4iIwtZqvYwrN303Fa+SniBFNqx9aYwex+UTKw/kDZizmIkYtLOw7v
	 j193DCK8w6FWdLjfApABEqpMsPTH+8TqieLZp7yWil/tu7E0uTcE7PVKoEs3Wo3dpr
	 VoH9wcK8t9rcw==
Date: Tue, 11 Feb 2025 16:40:09 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250211062437.46811-3-laoar.shao@gmail.com>

On Tue, Feb 11, 2025 at 02:24:36PM +0800, Yafang Shao wrote:
>  void klp_try_complete_transition(void)
>  {
> +	unsigned long timeout, proceed_pending_processes;
>  	unsigned int cpu;
>  	struct task_struct *g, *task;
>  	struct klp_patch *patch;
> @@ -467,9 +468,30 @@ void klp_try_complete_transition(void)
>  	 * unless the patch includes changes to a very common function.
>  	 */
>  	read_lock(&tasklist_lock);
> -	for_each_process_thread(g, task)
> +	timeout = jiffies + HZ;
> +	proceed_pending_processes = 0;
> +	for_each_process_thread(g, task) {
> +		/* check if this task has already switched over */
> +		if (task->patch_state == klp_target_state)
> +			continue;
> +
> +		proceed_pending_processes++;
> +
>  		if (!klp_try_switch_task(task))
>  			complete = false;
> +
> +		/*
> +		 * Prevent hardlockup by not blocking tasklist_lock for too long.
> +		 * But guarantee the forward progress by making sure at least
> +		 * some pending processes were checked.
> +		 */
> +		if (rwlock_is_contended(&tasklist_lock) &&
> +		    time_after(jiffies, timeout) &&
> +		    proceed_pending_processes > 100) {
> +			complete = false;
> +			break;
> +		}
> +	}
>  	read_unlock(&tasklist_lock);

Instead of all this can we not just use rcu_read_lock() instead of
tasklist_lock?

Petr, I know you mentioned that would widen the race window for the
do_exit() path, but don't we need to fix that race anyway?

-- 
Josh

