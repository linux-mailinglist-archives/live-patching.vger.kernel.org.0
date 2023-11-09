Return-Path: <live-patching+bounces-28-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EF57E7545
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 00:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AD6F281769
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 23:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6AA38FB0;
	Thu,  9 Nov 2023 23:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+A9XrnO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC09238FAD
	for <live-patching@vger.kernel.org>; Thu,  9 Nov 2023 23:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB5C433C7;
	Thu,  9 Nov 2023 23:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699573659;
	bh=Zkq/7iZ3H80Jnb4PLSdJyK3YLpUxFO5+W/MaihT41SQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+A9XrnOk6oY72C2nTFJMUmZJRnnID0D70pM5Z5vYztBmNoq0v6Ll/AqmLukM0jrl
	 VuVhTeIC7r2OCuTeCvMA6Br1s3A1E0B32L92RdnTOQoOv74OZbA00oFHpaZjXtNdIY
	 QoRvBAdICqqupiVYwsCpU70B6pgg1qrY++l0aXl+yYhSvw9jMWnZILIZb+OFx1thxA
	 UMOTUwAH93hCZvZUS5jtAtJg7DYUaGjgi9oPFJewcgyDPD1ry+e+QWu/1z4xi+4jlC
	 POYaBbAPgrTV/h6P9YgGbPghCI+t+RIheW1G1NXGDv1PWdBITeq2BOB/R8NryYYKf5
	 k1xv/uSlnX++Q==
Date: Thu, 9 Nov 2023 15:47:36 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, peterz@infradead.org,
	torvalds@linux-foundation.org, paulmck@kernel.org,
	linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
	luto@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, mingo@redhat.com, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, willy@infradead.org, mgorman@suse.de,
	jon.grimm@amd.com, bharata@amd.com, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, jgross@suse.com,
	andrew.cooper3@citrix.com, mingo@kernel.org, bristot@kernel.org,
	mathieu.desnoyers@efficios.com, geert@linux-m68k.org,
	glaubitz@physik.fu-berlin.de, anton.ivanov@cambridgegreys.com,
	mattst88@gmail.com, krypton@ulrich-teichert.org,
	David.Laight@ACULAB.COM, richard@nod.at, mjguzik@gmail.com,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 07/86] Revert "livepatch,sched: Add livepatch task
 switching to cond_resched()"
Message-ID: <20231109234736.4kik62ys47ey23ju@treble>
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
 <20231107215742.363031-8-ankur.a.arora@oracle.com>
 <20231107181609.7e9e9dcc@gandalf.local.home>
 <20231109172637.ayue3jexgdxd53tu@treble>
 <20231109123147.2bb11809@gandalf.local.home>
 <20231109175118.olggitpaltz47n3b@treble>
 <87o7g2bkxj.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87o7g2bkxj.fsf@oracle.com>

On Thu, Nov 09, 2023 at 02:50:48PM -0800, Ankur Arora wrote:
> >> I guess I'm not fully understanding what the cond rescheds are for. But
> >> would an IPI to all CPUs setting NEED_RESCHED, fix it?
> 
> Yeah. We could just temporarily toggle to full preemption, when
> NEED_RESCHED_LAZY is always upgraded to NEED_RESCHED which will
> then send IPIs.
> 
> > If all livepatch arches had the ORC unwinder, yes.
> >
> > The problem is that frame pointer (and similar) unwinders can't reliably
> > unwind past an interrupt frame.
> 
> Ah, I wonder if we could just disable the preempt_schedule_irq() path
> temporarily? Hooking into schedule() alongside something like this:
> 
> @@ -379,7 +379,7 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
> 
>  void irqentry_exit_cond_resched(void)
>  {
> -       if (!preempt_count()) {
> +       if (klp_cond_resched_disable() && !preempt_count()) {
> 
> The problem would be tasks that don't go through any preemptible
> sections.

Let me back up a bit and explain what klp is trying to do.

When a livepatch is applied, klp needs to unwind all the tasks,
preferably within a reasonable amount of time.

We can't unwind task A from task B while task A is running, since task A
could be changing the stack during the unwind.  So task A needs to be
blocked or asleep.  The only exception to that is if the unwind happens
in the context of task A itself.

The problem we were seeing was CPU-bound kthreads (e.g., vhost_worker)
not getting patched within a reasonable amount of time.  We fixed it by
hooking the klp unwind into cond_resched() so it can unwind from the
task itself.

It only worked because we had a non-preempted hook (because non-ORC
unwinders can't unwind reliably through preemption) which called klp to
unwind from the context of the task.

Without something to hook into, we have a problem.  We could of course
hook into schedule(), but if the kthread never calls schedule() from a
non-preempted context then it still doesn't help.

-- 
Josh

