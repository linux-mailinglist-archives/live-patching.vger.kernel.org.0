Return-Path: <live-patching+bounces-26-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD837E70D0
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 18:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0870B20B86
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 17:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E473035C;
	Thu,  9 Nov 2023 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1ePCVIE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CE5225D5
	for <live-patching@vger.kernel.org>; Thu,  9 Nov 2023 17:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCE5C433C9;
	Thu,  9 Nov 2023 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699552281;
	bh=XPmieidkvTqBzUR/vxOsuiXcCyKM/zgNK+ZNoUrqnMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r1ePCVIEMutoRd7UrDkWj2iYyVFGYbgLcHeSq9obJ4o4zzzwK3u4nxTihrF8eZ1yq
	 sfnuFjVWVf78FPKIU2e5mF59xnqWoRuYfTRYV2njrfu0kiUILM+7dub00TiAKJplOu
	 ngwhrE3y+SLoH095RDwg9P65PpQqcwuApLlWTgfX+Ck3rKSqe+7nEi3Pkzk2cG5zdI
	 TsAIS4ceXMHebQD+72i+fpNySaV7B33uhk1AdjtbOhggpGGxK/dm5f59yfOCp0X1Wj
	 uBSwsMwGXw0xoK3z0qEHuOggsU8fHqsZTSiDKPpse23MgOtaWsHt4yUiL9MT2Zj9eX
	 cJxDDq6v0NNZA==
Date: Thu, 9 Nov 2023 09:51:18 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20231109175118.olggitpaltz47n3b@treble>
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
 <20231107215742.363031-8-ankur.a.arora@oracle.com>
 <20231107181609.7e9e9dcc@gandalf.local.home>
 <20231109172637.ayue3jexgdxd53tu@treble>
 <20231109123147.2bb11809@gandalf.local.home>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231109123147.2bb11809@gandalf.local.home>

On Thu, Nov 09, 2023 at 12:31:47PM -0500, Steven Rostedt wrote:
> On Thu, 9 Nov 2023 09:26:37 -0800
> Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> > On Tue, Nov 07, 2023 at 06:16:09PM -0500, Steven Rostedt wrote:
> > > On Tue,  7 Nov 2023 13:56:53 -0800
> > > Ankur Arora <ankur.a.arora@oracle.com> wrote:
> > >   
> > > > This reverts commit e3ff7c609f39671d1aaff4fb4a8594e14f3e03f8.
> > > > 
> > > > Note that removing this commit reintroduces "live patches failing to
> > > > complete within a reasonable amount of time due to CPU-bound kthreads."
> > > > 
> > > > Unfortunately this fix depends quite critically on PREEMPT_DYNAMIC and
> > > > existence of cond_resched() so this will need an alternate fix.  
> > 
> > We definitely don't want to introduce a regression, something will need
> > to be figured out before removing cond_resched().
> > 
> > We could hook into preempt_schedule_irq(), but that wouldn't work for
> > non-ORC.
> > 
> > Another option would be to hook into schedule().  Then livepatch could
> > set TIF_NEED_RESCHED on remaining unpatched tasks.  But again if they go
> > through the preemption path then we have the same problem for non-ORC.
> > 
> > Worst case we'll need to sprinkle cond_livepatch() everywhere :-/
> > 
> 
> I guess I'm not fully understanding what the cond rescheds are for. But
> would an IPI to all CPUs setting NEED_RESCHED, fix it?

If all livepatch arches had the ORC unwinder, yes.

The problem is that frame pointer (and similar) unwinders can't reliably
unwind past an interrupt frame.

-- 
Josh

