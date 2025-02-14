Return-Path: <live-patching+bounces-1202-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CEFA36585
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3DDD1732B9
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 18:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4009268C7E;
	Fri, 14 Feb 2025 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDhVC6Ri"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBE82686B4
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739556728; cv=none; b=CsYNeFQtah25N4MUYCUNAfOCtsMOu1CxokNMxstDK6Uh9CXl0sWur6PzF5WPliS2312txCsXB6YLWVgyD4TRrbzfN8LpdD1bqHtr/B8OwnLXqw1t905VLKp9Mbrr0D8nC3rFxwIfv2hY/w+99ZNhMmoGXMC8gwedmPnB0WOLVRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739556728; c=relaxed/simple;
	bh=IE6AlM52FuUyZ9EJGSQYDKiCFQ3JI2Ju5oSerDTtN2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLr8f8h6tbr36Tp+EM4gw2R8grNlDnpxVBZcVGJtEY2fKoYj2UNhzX8CYEMn1q+r+FVNqO2vZ2Ca/73duuBnqmZntrOxs8pFyuYVTuW+Pal2I0wbwu64rywM4d4+AIftmNddErW1DOcFKFiSvWNrZ3NcV7MN0S4E8ZDjtZN4Kxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDhVC6Ri; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6DBC4CED1;
	Fri, 14 Feb 2025 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739556728;
	bh=IE6AlM52FuUyZ9EJGSQYDKiCFQ3JI2Ju5oSerDTtN2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDhVC6RiO/WbZiHqcPn56S9E6YjvJG/E8mtoGeLaTqD4RMnyF+8NBjDvQLUhU0Xii
	 jIiiwq/1h2kdStXwoIdkhlbXojrxpnay/AXnOKOUBoH4p72oQ46yiNUcM0s6e35HCk
	 n630r4v69ZMFHgrm/R3TqNZXADZujbuU9m3QX3FLUiua/qM7ZQI5s7pSUP9wThR/1L
	 n7NzI/UcNnKdjLvH5JrQweTkay2BhLJwKmyUv+UXfN82M5W9r7mwHZRyp9ZrR3lEHY
	 vJmxOzBIzJ71nxBgGBEE6Kjgpx7cxVUYWENRHgtF5FUoCUIn+NQgv9sOe1h+E684nc
	 iLjCvHq1ps/Vw==
Date: Fri, 14 Feb 2025 10:12:06 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <20250214181206.xkvxohoc4ft26uhf@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
 <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
 <Z62_6wDP894cAttk@pathway.suse.cz>
 <20250213173253.ovivhuq2c5rmvkhj@jpoimboe>
 <Z69Wuhve2vnsrtp_@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z69Wuhve2vnsrtp_@pathway.suse.cz>

On Fri, Feb 14, 2025 at 03:44:10PM +0100, Petr Mladek wrote:
> I guess that we really could consider the new task as migrated
> and clear TIF_PATCH_PENDING.
> 
> But we can't set child->patch_state to KLP_TRANSITION_IDLE. It won't
> work when the transition gets reverted. [*]

Hm, why not?  I don't see any difference between patching or unpatching?

klp_init_transition() has a barrier to enforce the order of the
klp_target_state and func->transition writes, as read by the
klp_ftrace_handler().

So in the ftrace handler, if func->transition is set and the task is
KLP_TRANSITION_IDLE, it can use klp_target_state to decide which
function to use.  Its patch state would effectively be the same as any
other already-transitioned task, whether it's patching or unpatching.

Then in klp_complete_transition(), after func->transition gets set to
false, klp_synchronize_transition() flushes out any running ftrace
handlers.  From that point on, func->transition is false, so the ftrace
handler would no longer read klp_target_state.

> [*] I gave this few brain cycles but I did not find any elegant
>     way how to set this a safe way and allow using rcu_read_lock()
>     in klp_try_complete_transition().
> 
>     It might be because it is Friday evening and I am leaving for
>     a trip tomorrow. Also I not motivated enough to think about it
>     because Yafang saw the RCU stall even with that rcu_read_lock().
>     So I send this just for record.

Even if it doesn't fix the RCU stalls, I think we should still try to
avoid holding the tasklist_lock.  It's a global lock which can be
contended, and we want the livepatch transition to be as unobtrusive as
possible.

If the system is doing a lot of forking across many CPUs, holding the
lock could block all the forking tasks and trigger system-wide
scheduling latencies.  And that could be compounded by the unnecessary
transitioning of new tasks every time the delayed work runs.

-- 
Josh

