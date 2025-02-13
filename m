Return-Path: <live-patching+bounces-1166-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A864A3359B
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 03:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFB7C1887131
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E56978F37;
	Thu, 13 Feb 2025 02:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NI471y76"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2790B35947
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414871; cv=none; b=kgdXNMNoS1kLUl/zCj/hIiPqI8swUWc8X/y1P3hG6xSO1JXmc1qyV6QDDuajGlIuOyA9YXjrEYT59oNVRPLNOTi9FWqxtRwgeohHoI6PHt2nPGHuAZSMU/UuLAwKCfD6hc9Nn687qHmlWtC7QuoggH8l363xJw03i3g4+yjDN8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414871; c=relaxed/simple;
	bh=agX7U1SPz0ruuJQdt696BsO/oGxHevg0jCSyDs326pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6MX1npZej2oDcHsR/nwohDHT8SMgnJqBBIb6y/cXd6wYsJgxV3e4/r2cwqXas2yuk294BLW7eaEPjVfGsMwL124798UqFg35Q0cItDQ4aSQ60Odt1gDLVbrlVIs87gMRtJFjruItPS25G2B8Z5y2tyGDjSdWHX+QIlofYdCxSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NI471y76; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C073C4CEDF;
	Thu, 13 Feb 2025 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739414870;
	bh=agX7U1SPz0ruuJQdt696BsO/oGxHevg0jCSyDs326pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NI471y76WdBPxdvR//yxzVqBxGxsLH8jlb069feNbzNPiXUB6pXfxavB4OmoqfujC
	 NZr1vVxj8odh2BQPEWtCP2ZtTvmaPUYOtgYBAdco8MnVFjPNVMyflKiKYHebZnXODB
	 x9r4X/eWvWyFctjM5GXfuTdvL41kPmcqf/SdJz7kibk3HQvD2YO4KuAeNa7QegWPVm
	 D6GlRCnneF+4qPL8BHkaOME699daIIquxRdDs7ZR37AZqzjpl6Gh6oxLsYJCc7akpO
	 NF4XWCLjCiobaxAIWE7VpovlqvX0RH81E/ufeThZB4glbVsvNop09eikhGjNc7IA3+
	 hndQUFfQ7n1Tg==
Date: Wed, 12 Feb 2025 18:47:48 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <20250213024748.2sgwoltfvinb5rop@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>

On Wed, Feb 12, 2025 at 07:54:21PM +0800, Yafang Shao wrote:
> Before the newly forked task is added to the task list, it doesn’t
> execute any code and can always be considered safe during the KLP
> transition. Therefore, we could replace klp_copy_process() with
> klp_init_process(), where we simply set patch_state to
> KLP_TRANSITION_IDLE, as shown below:
> 
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2544,7 +2544,9 @@ __latent_entropy struct task_struct *copy_process(
>                 p->exit_signal = args->exit_signal;
>         }
> 
> -       klp_copy_process(p);
> +       // klp_init_process(p);
> +       clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> +       child->patch_state = KLP_TRANSITION_IDLE;
> 
>         sched_core_fork(p);
> 
> Some additional changes may be needed, such as removing
> WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE) in
> klp_ftrace_handler().

Oops, I managed to miss this email before my reply.  Looks like we had a
similar idea :-)

-- 
Josh

