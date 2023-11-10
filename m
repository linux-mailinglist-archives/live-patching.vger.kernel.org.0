Return-Path: <live-patching+bounces-30-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCBC7E761E
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 01:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47A682813F1
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 00:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2BF382;
	Fri, 10 Nov 2023 00:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3EB628
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 00:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4F5C433C8;
	Fri, 10 Nov 2023 00:56:45 +0000 (UTC)
Date: Thu, 9 Nov 2023 19:56:49 -0500
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
Message-ID: <20231109195649.2b2869fc@gandalf.local.home>
In-Reply-To: <20231109175118.olggitpaltz47n3b@treble>
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
	<20231107215742.363031-8-ankur.a.arora@oracle.com>
	<20231107181609.7e9e9dcc@gandalf.local.home>
	<20231109172637.ayue3jexgdxd53tu@treble>
	<20231109123147.2bb11809@gandalf.local.home>
	<20231109175118.olggitpaltz47n3b@treble>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 Nov 2023 09:51:18 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> > I guess I'm not fully understanding what the cond rescheds are for. But
> > would an IPI to all CPUs setting NEED_RESCHED, fix it?  
> 
> If all livepatch arches had the ORC unwinder, yes.
> 
> The problem is that frame pointer (and similar) unwinders can't reliably
> unwind past an interrupt frame.

Perhaps we can use this to push those archs with bad unwinders to port over
ORC unwinding ;-)

-- Steve

