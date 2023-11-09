Return-Path: <live-patching+bounces-25-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BA97E7053
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 18:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D202812FE
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 17:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09416225D3;
	Thu,  9 Nov 2023 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBC1225D1
	for <live-patching@vger.kernel.org>; Thu,  9 Nov 2023 17:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8383FC433C9;
	Thu,  9 Nov 2023 17:31:43 +0000 (UTC)
Date: Thu, 9 Nov 2023 12:31:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, peterz@infradead.org, torvalds@linux-foundation.org,
 paulmck@kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, luto@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, willy@infradead.org,
 mgorman@suse.de, jon.grimm@amd.com, bharata@amd.com,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 jgross@suse.com, andrew.cooper3@citrix.com, mingo@kernel.org,
 bristot@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org,
 glaubitz@physik.fu-berlin.de, anton.ivanov@cambridgegreys.com,
 mattst88@gmail.com, krypton@ulrich-teichert.org, David.Laight@ACULAB.COM,
 richard@nod.at, mjguzik@gmail.com, Jiri Kosina <jikos@kernel.org>, Miroslav
 Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 07/86] Revert "livepatch,sched: Add livepatch task
 switching to cond_resched()"
Message-ID: <20231109123147.2bb11809@gandalf.local.home>
In-Reply-To: <20231109172637.ayue3jexgdxd53tu@treble>
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
	<20231107215742.363031-8-ankur.a.arora@oracle.com>
	<20231107181609.7e9e9dcc@gandalf.local.home>
	<20231109172637.ayue3jexgdxd53tu@treble>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 Nov 2023 09:26:37 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> On Tue, Nov 07, 2023 at 06:16:09PM -0500, Steven Rostedt wrote:
> > On Tue,  7 Nov 2023 13:56:53 -0800
> > Ankur Arora <ankur.a.arora@oracle.com> wrote:
> >   
> > > This reverts commit e3ff7c609f39671d1aaff4fb4a8594e14f3e03f8.
> > > 
> > > Note that removing this commit reintroduces "live patches failing to
> > > complete within a reasonable amount of time due to CPU-bound kthreads."
> > > 
> > > Unfortunately this fix depends quite critically on PREEMPT_DYNAMIC and
> > > existence of cond_resched() so this will need an alternate fix.  
> 
> We definitely don't want to introduce a regression, something will need
> to be figured out before removing cond_resched().
> 
> We could hook into preempt_schedule_irq(), but that wouldn't work for
> non-ORC.
> 
> Another option would be to hook into schedule().  Then livepatch could
> set TIF_NEED_RESCHED on remaining unpatched tasks.  But again if they go
> through the preemption path then we have the same problem for non-ORC.
> 
> Worst case we'll need to sprinkle cond_livepatch() everywhere :-/
> 

I guess I'm not fully understanding what the cond rescheds are for. But
would an IPI to all CPUs setting NEED_RESCHED, fix it?

-- Steve

