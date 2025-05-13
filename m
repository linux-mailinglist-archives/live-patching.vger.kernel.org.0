Return-Path: <live-patching+bounces-1425-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE744AB5627
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 15:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FECD4675A8
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 13:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C6B28D841;
	Tue, 13 May 2025 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rZQXxGbO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5OLeFq/q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jtOQQdTX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PqcjWPEQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79D927056C
	for <live-patching@vger.kernel.org>; Tue, 13 May 2025 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747143294; cv=none; b=FOgAzH2gug1Gk1d4SFpxRsEQ1slLo+GrUfMT6EBBhiNu1WmceCh2FjiHlaLg4LoxvwgYqbGSMgVCXHOyDN8K4jhSdfsdM16M0OiNimVF+0mxMAQFWBpxbT+SHny3/mp1agfOIVXWlfvvWGzRifShF9xCa+bWiOcNPPk1zXJdGkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747143294; c=relaxed/simple;
	bh=HiQAI9qA2+tr2vuBq7mJuDVHFurHRbktX1OJdzD37Xk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=R8pd261j2dZGRljzC8RIerClqNttj0N6EGK+qxkqMfgyoBYenASXONio9Owm2hv8R/8aB+flJ5ay5y3OIK7oErG7k/uuYaneakWw0pSs5YmQ2DCGdijW0pT3BQBleh9tWoGYndKv8HwzI4N84ZeeSuxjaVzczpCr00h7z3nhfP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rZQXxGbO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5OLeFq/q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jtOQQdTX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PqcjWPEQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E263621187;
	Tue, 13 May 2025 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1747143291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6J2+rvITsi5fqZ9/xhX64s08wLNi9ATpSHwWOtdqUQ4=;
	b=rZQXxGbOFvjtZfdW9nvJtW9GmYh8X7j/lQahq1p//LqOED5LZvRkREbwg8hbQB+82Q2lTM
	aFXeEBbkiHzSCHJ9S/4/hfOEXNBNyQMJ0TOifDhkDT46EAP5zLi1BjbtuWJF/D8W2qnNE5
	rPBLuY4BO7KlL/16W3Ox83D0DswVeDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1747143291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6J2+rvITsi5fqZ9/xhX64s08wLNi9ATpSHwWOtdqUQ4=;
	b=5OLeFq/qA22HJMWrxHkzMaD+dwxXl8aYRQoHxHpi/AWVLAqqFZc/GqKbQffhW3aoT+rWmV
	EbEg8wLbJV3PRCDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1747143290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6J2+rvITsi5fqZ9/xhX64s08wLNi9ATpSHwWOtdqUQ4=;
	b=jtOQQdTXYc5Rr3gZ0dOZN9kzqfD462iiRXPE3g86DRBz0WV4gGggXKZV51jJ5wImAq1qYf
	3Gdq39scbecU+kmirjMJB2gzvviVPYUv9N0dLJWJN3b+LgGCvJ/tr37vKbrhbyfO1HpciK
	DSqln5oULOJ3qXj47wLkunhCyvjyfKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1747143290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6J2+rvITsi5fqZ9/xhX64s08wLNi9ATpSHwWOtdqUQ4=;
	b=PqcjWPEQKLB4lsqAPlR8exdc5o38xr5q0jQyhxQJgGYaDH6AOakr2JWnQX2DJnSzC+n75p
	rFcxESK0Iae23aBA==
Date: Tue, 13 May 2025 15:34:50 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
    Peter Zijlstra <peterz@infradead.org>, 
    Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com, 
    juri.lelli@redhat.com, vincent.guittot@linaro.org, 
    dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
    mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org, 
    jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com, 
    Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
In-Reply-To: <20250509113659.wkP_HJ5z@linutronix.de>
Message-ID: <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>
References: <20250509113659.wkP_HJ5z@linutronix.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,infradead.org:email]

Hi,

thanks for the updated version.

On Fri, 9 May 2025, Sebastian Andrzej Siewior wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> needs to stop relying on cond_resched() to make forward progress.
> 
> Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> live-patching, the freezer needs to be able to stop tasks in a safe /
> known state.
> 
> Compile tested only.

livepatch selftests pass and I also ran some more.
 
> [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Miroslav Benes <mbenes@suse.cz>

A nit below if there is an another version, otherwise Petr might fix it 
when merging.

> @@ -365,27 +356,20 @@ static bool klp_try_switch_task(struct task_struct *task)
>  
>  void __klp_sched_try_switch(void)
>  {
> +	/*
> +	 * This function is called from __schedule() while a context switch is
> +	 * about to happen. Preemption is already disabled and klp_mutex
> +	 * can't be acquired.
> +	 * Disabled preemption is used to prevent racing with other callers of
> +	 * klp_try_switch_task(). Thanks to task_call_func() they won't be
> +	 * able to switch to this task while it's running.
> +	 */
> +	lockdep_assert_preemption_disabled();
> +
> +	/* Make sure current didn't get patched */
>       if (likely(!klp_patch_pending(current)))
>                return;

This last comment is not precise. If !klp_patch_pending(), there is 
nothing to do. Fast way out. So if it was up to me, I would remove the 
line all together.

Miroslav

