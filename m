Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406ED35E947
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 00:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348694AbhDMWxo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Apr 2021 18:53:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346222AbhDMWxn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Apr 2021 18:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618354403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1oL1MJeIJ7O55P7VKTMm7clEqM06bfVb251ZTxzvCU=;
        b=Xb7ssgJ7hGnaQupltgHuFvQNoRByfVm2vQbQ+fyzUvStQpB0GZ1reFX3//aT/Vigz0kGS8
        hcEBcAJKbXRYMvrWe6CtcJo0IsgRIsiTjfNZcfejOnSWY87mr4/X+zJXak/we5PE+ARskS
        tevU9uPFIDmunOfXdf6rzmRwvXy3x4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-asdE7gCMMLaWHCi3p1Vj5w-1; Tue, 13 Apr 2021 18:53:19 -0400
X-MC-Unique: asdE7gCMMLaWHCi3p1Vj5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1428107ACE3;
        Tue, 13 Apr 2021 22:53:17 +0000 (UTC)
Received: from treble (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 682FC62665;
        Tue, 13 Apr 2021 22:53:12 +0000 (UTC)
Date:   Tue, 13 Apr 2021 17:53:10 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210413225310.k64wqjnst7cia4ft@treble>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
 <20210409223227.rvf6tfhvgnpzmabn@treble>
 <20210412165933.GD5379@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210412165933.GD5379@sirena.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 12, 2021 at 05:59:33PM +0100, Mark Brown wrote:
> On Fri, Apr 09, 2021 at 05:32:27PM -0500, Josh Poimboeuf wrote:
> 
> > Hm, for that matter, even without renaming things, a comment above
> > stack_trace_save_tsk_reliable() describing the meaning of "reliable"
> > would be a good idea.
> 
> Might be better to place something at the prototype for
> arch_stack_walk_reliable() or cross link the two since that's where any
> new architectures should be starting, or perhaps even better to extend
> the document that Mark wrote further and point to that from both places.  
> 
> Some more explict pointer to live patching as the only user would
> definitely be good but I think the more important thing would be writing
> down any assumptions in the API that aren't already written down and
> we're supposed to be relying on.  Mark's document captured a lot of it
> but it sounds like there's more here, and even with knowing that this
> interface is only used by live patch and digging into what it does it's
> not always clear what happens to work with the code right now and what's
> something that's suitable to be relied on.

Something like so?

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] livepatch: Clarify the meaning of 'reliable'

Update the comments and documentation to reflect what 'reliable'
unwinding actually means, in the context of live patching.

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 .../livepatch/reliable-stacktrace.rst         | 26 +++++++++++++----
 arch/x86/kernel/stacktrace.c                  |  6 ----
 include/linux/stacktrace.h                    | 29 +++++++++++++++++--
 kernel/stacktrace.c                           |  7 ++++-
 4 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
index 67459d2ca2af..e325efc7e952 100644
--- a/Documentation/livepatch/reliable-stacktrace.rst
+++ b/Documentation/livepatch/reliable-stacktrace.rst
@@ -72,7 +72,21 @@ The unwinding process varies across architectures, their respective procedure
 call standards, and kernel configurations. This section describes common
 details that architectures should consider.
 
-4.1 Identifying successful termination
+4.1 Only preemptible code needs reliability detection
+-----------------------------------------------------
+
+The only current user of reliable stacktracing is livepatch, which only
+calls it for a) inactive tasks; or b) the current task in task context.
+
+Therefore, the unwinder only needs to detect the reliability of stacks
+involving *preemptible* code.
+
+Practically speaking, reliability of stacks involving *non-preemptible*
+code is a "don't-care".  It may help to return a wrong reliability
+result for such cases, if it results in reduced complexity, since such
+cases will not happen in practice.
+
+4.2 Identifying successful termination
 --------------------------------------
 
 Unwinding may terminate early for a number of reasons, including:
@@ -95,7 +109,7 @@ architectures verify that a stacktrace ends at an expected location, e.g.
 * On a specific stack expected for a kernel entry point (e.g. if the
   architecture has separate task and IRQ stacks).
 
-4.2 Identifying unwindable code
+4.3 Identifying unwindable code
 -------------------------------
 
 Unwinding typically relies on code following specific conventions (e.g.
@@ -129,7 +143,7 @@ unreliable to unwind from, e.g.
 
 * Identifying specific portions of code using bounds information.
 
-4.3 Unwinding across interrupts and exceptions
+4.4 Unwinding across interrupts and exceptions
 ----------------------------------------------
 
 At function call boundaries the stack and other unwind state is expected to be
@@ -156,7 +170,7 @@ have no such cases) should attempt to unwind across exception boundaries, as
 doing so can prevent unnecessarily stalling livepatch consistency checks and
 permits livepatch transitions to complete more quickly.
 
-4.4 Rewriting of return addresses
+4.5 Rewriting of return addresses
 ---------------------------------
 
 Some trampolines temporarily modify the return address of a function in order
@@ -222,7 +236,7 @@ middle of return_to_handler and can report this as unreliable. Architectures
 are not required to unwind from other trampolines which modify the return
 address.
 
-4.5 Obscuring of return addresses
+4.6 Obscuring of return addresses
 ---------------------------------
 
 Some trampolines do not rewrite the return address in order to intercept
@@ -249,7 +263,7 @@ than the link register as would usually be the case.
 Architectures must either ensure that unwinders either reliably unwind
 such cases, or report the unwinding as unreliable.
 
-4.6 Link register unreliability
+4.7 Link register unreliability
 -------------------------------
 
 On some other architectures, 'call' instructions place the return address into a
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 8627fda8d993..15b058eefc4e 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -29,12 +29,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 }
 
-/*
- * This function returns an error if it detects any unreliable features of the
- * stack.  Otherwise it guarantees that the stack trace is reliable.
- *
- * If the task is not 'current', the caller *must* ensure the task is inactive.
- */
 int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			     void *cookie, struct task_struct *task)
 {
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 50e2df30b0aa..1b6a65a0ad22 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -26,7 +26,7 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
 #ifdef CONFIG_ARCH_STACKWALK
 
 /**
- * stack_trace_consume_fn - Callback for arch_stack_walk()
+ * stack_trace_consume_fn() - Callback for arch_stack_walk()
  * @cookie:	Caller supplied pointer handed back by arch_stack_walk()
  * @addr:	The stack entry address to consume
  *
@@ -35,7 +35,7 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
  */
 typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr);
 /**
- * arch_stack_walk - Architecture specific function to walk the stack
+ * arch_stack_walk() - Architecture specific function to walk the stack
  * @consume_entry:	Callback which is invoked by the architecture code for
  *			each entry.
  * @cookie:		Caller supplied pointer which is handed back to
@@ -52,8 +52,33 @@ typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr);
  */
 void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * arch_stack_walk_reliable() - Architecture specific function to walk the
+ *				stack, with stack reliability check
+ * @consume_entry:	Callback which is invoked by the architecture code for
+ *			each entry.
+ * @cookie:		Caller supplied pointer which is handed back to
+ *			@consume_entry
+ * @task:		Pointer to a task struct, can be NULL for current
+ *
+ * Return: 0 if the stack trace is considered reliable for livepatch; else < 0.
+ *
+ * NOTE: This interface is only used by livepatch.  The caller must ensure that
+ *	 it's only called in one of the following two scenarios:
+ *
+ *	 a) the task is inactive (and guaranteed to remain so); or
+ *
+ *	 b) the task is 'current', running in task context.
+ *
+ * Effectively, this means the arch unwinder doesn't need to detect the
+ * reliability of stacks involving non-preemptible code.
+ *
+ * For more details, see Documentation/livepatch/reliable-stacktrace.rst.
+ */
 int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
 			     struct task_struct *task);
+
 void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 			  const struct pt_regs *regs);
 
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 9f8117c7cfdd..a198fd194fed 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -185,7 +185,12 @@ unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
  *		stack. Otherwise it guarantees that the stack trace is
  *		reliable and returns the number of entries stored.
  *
- * If the task is not 'current', the caller *must* ensure the task is inactive.
+ * NOTE: This interface is only used by livepatch.  The caller must ensure that
+ *	 it's only called in one of the following two scenarios:
+ *
+ *	 a) the task is inactive (and guaranteed to remain so); or
+ *
+ *	 b) the task is 'current', running in task context.
  */
 int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
 				  unsigned int size)
-- 
2.30.2

