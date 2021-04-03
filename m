Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BE3534CC
	for <lists+live-patching@lfdr.de>; Sat,  3 Apr 2021 19:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhDCRCN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 3 Apr 2021 13:02:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236724AbhDCRCN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 3 Apr 2021 13:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617469330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ad/+qQqMg6bmNohEsVoTIHFOFHVcRfOP46VT5NtpO9A=;
        b=F1ACNFw0WMInaDtKVLVty78hLbCylvTKuWK/CMFV4Mtf7iJfxvD18LkJTCYJ3Q6ouFxQqb
        MiHmFZPHf7CfhrD1ojDcPWAb6Kd2xJDov849ZBwbcAjUsdU5ARpMgXVwaahiMzy2hC9DOQ
        QE7jSKdM01E/ljMn/XY3kX9YGLhE84Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-NGZBI5oVMuKuM4eyP3mF-A-1; Sat, 03 Apr 2021 13:02:08 -0400
X-MC-Unique: NGZBI5oVMuKuM4eyP3mF-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FC61084C83;
        Sat,  3 Apr 2021 17:02:06 +0000 (UTC)
Received: from treble (ovpn-116-68.rdu2.redhat.com [10.10.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B02A100F49F;
        Sat,  3 Apr 2021 17:02:01 +0000 (UTC)
Date:   Sat, 3 Apr 2021 12:01:59 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, broonie@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210403170159.gegqjrsrg7jshlne@treble>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330190955.13707-1-madvenka@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 30, 2021 at 02:09:51PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> There are a number of places in kernel code where the stack trace is not
> reliable. Enhance the unwinder to check for those cases and mark the
> stack trace as unreliable. Once all of the checks are in place, the unwinder
> can be used for livepatching.

This assumes all such places are known.  That's a big assumption, as

a) hand-written asm code may inadvertantly skip frame pointer setup;

b) for inline asm which calls a function, the compiler may blindly
   insert it into a function before the frame pointer setup.

That's where objtool stack validation would come in.
   
> Detect EL1 exception frame
> ==========================
> 
> EL1 exceptions can happen on any instruction including instructions in
> the frame pointer prolog or epilog. Depending on where exactly they happen,
> they could render the stack trace unreliable.
> 
> Add all of the EL1 exception handlers to special_functions[].
> 
> 	- el1_sync()
> 	- el1_irq()
> 	- el1_error()
> 	- el1_sync_invalid()
> 	- el1_irq_invalid()
> 	- el1_fiq_invalid()
> 	- el1_error_invalid()

A possibly more robust alternative would be to somehow mark el1
exception frames so the unwinder can detect them more generally.

For example, as described in my previous email, encode the frame pointer
so the unwinder can detect el1 frames automatically.

> Detect ftrace frame
> ===================
> 
> When FTRACE executes at the beginning of a traced function, it creates two
> frames and calls the tracer function:
> 
> 	- One frame for the traced function
> 
> 	- One frame for the caller of the traced function
> 
> That gives a sensible stack trace while executing in the tracer function.
> When FTRACE returns to the traced function, the frames are popped and
> everything is back to normal.
> 
> However, in cases like live patch, the tracer function redirects execution
> to a different function. When FTRACE returns, control will go to that target
> function. A stack trace taken in the tracer function will not show the target
> function. The target function is the real function that we want to track.
> So, the stack trace is unreliable.

I don't think this is a real problem.  Livepatch only checks the stacks
of blocked tasks (and the task calling into livepatch).  So the
reliability of unwinding from the livepatch tracer function itself
(klp_ftrace_handler) isn't a concern since it doesn't sleep.

> To detect FTRACE in a stack trace, add the following to special_functions[]:
> 
> 	- ftrace_graph_call()
> 	- ftrace_graph_caller()
> 
> Please see the diff for a comment that explains why ftrace_graph_call()
> must be checked.
> 
> Also, the Function Graph Tracer modifies the return address of a traced
> function to a return trampoline (return_to_handler()) to gather tracing
> data on function return. Stack traces taken from the traced function and
> functions it calls will not show the original caller of the traced function.
> The unwinder handles this case by getting the original caller from FTRACE.
> 
> However, stack traces taken from the trampoline itself and functions it calls
> are unreliable as the original return address may not be available in
> that context. This is because the trampoline calls FTRACE to gather trace
> data as well as to obtain the actual return address and FTRACE discards the
> record of the original return address along the way.

Again, this shouldn't be a concern because livepatch won't be unwinding
from a function_graph trampoline unless it got preempted somehow (and
then the el1 frame would get detected anyway).

> Add return_to_handler() to special_functions[].
> 
> Check for kretprobe
> ===================
> 
> For functions with a kretprobe set up, probe code executes on entry
> to the function and replaces the return address in the stack frame with a
> kretprobe trampoline. Whenever the function returns, control is
> transferred to the trampoline. The trampoline eventually returns to the
> original return address.
> 
> A stack trace taken while executing in the function (or in functions that
> get called from the function) will not show the original return address.
> Similarly, a stack trace taken while executing in the trampoline itself
> (and functions that get called from the trampoline) will not show the
> original return address. This means that the caller of the probed function
> will not show. This makes the stack trace unreliable.
> 
> Add the kretprobe trampoline to special_functions[].
> 
> FYI, each task contains a task->kretprobe_instances list that can
> theoretically be consulted to find the orginal return address. But I am
> not entirely sure how to safely traverse that list for stack traces
> not on the current process. So, I have taken the easy way out.

For kretprobes, unwinding from the trampoline or kretprobe handler
shouldn't be a reliability concern for live patching, for similar
reasons as above.

Otherwise, when unwinding from a blocked task which has
'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
original return address.  Masami has been working on an interface to
make that possible for x86.  I assume something similar could be done
for arm64.

> Optprobes
> =========
> 
> Optprobes may be implemented in the future for arm64. For optprobes,
> the relevant trampoline(s) can be added to special_functions[].

Similar comment here, livepatch doesn't unwind from such trampolines.

-- 
Josh

