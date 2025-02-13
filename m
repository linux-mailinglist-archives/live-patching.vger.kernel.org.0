Return-Path: <live-patching+bounces-1161-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED73A334C6
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B23EA3A22E3
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 01:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607DC80034;
	Thu, 13 Feb 2025 01:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdMIxHkN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F678F24
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 01:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410566; cv=none; b=BCDu+NRokzAGesTpkllx1id54rAKJn2FB+TbeJ9OKfHdurVqvUZB4WQ5sZz+LKI1TcbphI1ZvelmYEQxubtAP2D480uzKU5qoxu6NLiOEc7SrCubaPWm9ttC8qAbSYRNEAjdg19wAwidga0QXGuUCpcn+lZO5RDm7vJ9kgrHFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410566; c=relaxed/simple;
	bh=FyQf1tBOt8iHd6jzXiscHkAW0Ys/ROksA/0ar7PIrsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdJoZx/nq8D4/xFf4iW2ZFRzzGPtuXwGult1eY8VKc36kBq0Qggso52codZYV8rlINg+fM4hXfJFPab33xxxRJF8tohZsxuT63o+3TChbo0p8/ioVC9ZG0gM3LZ4CS8N1N6BoBExdy8leeUFJCxP6L7cHm7Wk9kV+C9yA4+MJ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdMIxHkN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4F5C4CEDF;
	Thu, 13 Feb 2025 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739410565;
	bh=FyQf1tBOt8iHd6jzXiscHkAW0Ys/ROksA/0ar7PIrsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdMIxHkNhGUsE0Fn3NGRHhDrQCR++Jt01hHTtibMXPOgwOWXCI0DOfFSJEBVMNsEH
	 ioDBTlmNyQ4FZ1bCa9fcYC4AjZPEptvOnm4KVLaVgul7Qqbdu92yIBudpba94aLI92
	 x0pfnm22s23XqLL84KDBC1IhrpKfuUrvPYIIbNBxm6p3R/3S6nj9kzdPGxBMtrgGjf
	 q7rqoPQtYHVVWjJhKB9Up3a747dMCXLkEB5y0wGuPiFGeurGclnEnnxxmlbHeeX+6k
	 aF13BpAn25vtxbTkIbnUnOURQSpf3aOuZ+bwp4Ez6lQxXVtVSpLLEa36hlUSO5Q3N9
	 2HI34viX9G11g==
Date: Wed, 12 Feb 2025 17:36:03 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6zBb9GRkFC-R0RE@pathway.suse.cz>

On Wed, Feb 12, 2025 at 04:42:39PM +0100, Petr Mladek wrote:
> CPU1				CPU1
> 
> 				klp_try_complete_transition()
> 
> 
> taskA:	
>  + fork()
>    + klp_copy_process()
>       child->patch_state = KLP_PATCH_UNPATCHED
> 
> 				  klp_try_switch_task(taskA)
> 				    // safe
> 
> 				child->patch_state = KLP_PATCH_PATCHED
> 
> 				all processes patched
> 
> 				klp_finish_transition()
> 
> 
> 	list_add_tail_rcu(&p->thread_node,
> 			  &p->signal->thread_head);
> 
> 
> BANG: The forked task has KLP_PATCH_UNPATCHED so that
>       klp_ftrace_handler() will redirect it to the old code.
> 
>       But CPU1 thinks that all tasks are migrated and is going
>       to finish the transition


Maybe klp_try_complete_transition() could iterate the tasks in two
passes?  The first pass would use rcu_read_lock().  Then if all tasks
appear to be patched, try again with tasklist_lock.

Or, we could do something completely different.  There's no need for
klp_copy_process() to copy the parent's state: a newly forked task can
be patched immediately because it has no stack.

So instead, just initialize it to KLP_TRANSITION_IDLE with
TIF_PATCH_PENDING cleared.  Then when klp_ftrace_handler() encounters a
KLP_TRANSITION_IDLE task, it considers its state to be 'klp_target_state'.

// called from copy_process()
void klp_init_task(struct task_struct *child)
{
	/* klp_ftrace_handler() will transition the task immediately */
	child->patch_state = KLP_TRANSITION_IDLE;
	clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
}


klp_ftrace_handler():

		patch_state = current->patch_state;

		if (patch_state == KLP_TRANSITION_IDLE)
			patch_state = klp_target_state;
		...

Hm?

> I would first like to understand how exactly the stall happens.
> It is possible that even rcu_read_lock() won't help here!
> 
> If the it takes too long time to check backtraces of all pending
> processes then even rcu_read_lock() might trigger the RCU stall
> warning as well.

Yeah, based on Yafang's reply it appears there are RCU stalls either
way.

-- 
Josh

