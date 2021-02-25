Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC22C324F98
	for <lists+live-patching@lfdr.de>; Thu, 25 Feb 2021 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBYL7Z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Feb 2021 06:59:25 -0500
Received: from foss.arm.com ([217.140.110.172]:56162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232227AbhBYL7Q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Feb 2021 06:59:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0379D6E;
        Thu, 25 Feb 2021 03:58:30 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.50.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1EEF3F73D;
        Thu, 25 Feb 2021 03:58:28 -0800 (PST)
Date:   Thu, 25 Feb 2021 11:58:25 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
Message-ID: <20210225115825.GB37015@C02TD0UTHF1T.local>
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
 <20210224121716.GE50741@C02TD0UTHF1T.local>
 <4a96b31d-0d16-1f12-fa64-5fdae64cd2d1@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a96b31d-0d16-1f12-fa64-5fdae64cd2d1@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 24, 2021 at 01:34:09PM -0600, Madhavan T. Venkataraman wrote:
> On 2/24/21 6:17 AM, Mark Rutland wrote:
> > On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:
> >> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >> 	Termination
> >> 	===========
> >>
> >> 	Currently, the unwinder terminates when both the FP (frame pointer)
> >> 	and the PC (return address) of a frame are 0. But a frame could get
> >> 	corrupted and zeroed. There needs to be a better check.
> >>
> >> 	The following special terminating frame and function have been
> >> 	defined for this purpose:
> >>
> >> 	const u64    arm64_last_frame[2] __attribute__ ((aligned (16)));
> >>
> >> 	void arm64_last_func(void)
> >> 	{
> >> 	}
> >>
> >> 	So, set the FP to arm64_last_frame and the PC to arm64_last_func in
> >> 	the bottom most frame.
> > 
> > My expectation was that we'd do this per-task, creating an empty frame
> > record (i.e. with fp=NULL and lr=NULL) on the task's stack at the
> > instant it was created, and chaining this into x29. That way the address
> > is known (since it can be derived from the task), and the frame will
> > also implicitly check that the callchain terminates on the task stack
> > without loops. That also means that we can use it to detect the entry
> > code going wrong (e.g. if the SP gets corrupted), since in that case the
> > entry code would place the record at a different location.
> 
> That is exactly what this is doing. arm64_last_frame[] is a marker frame
> that contains fp=0 and pc=0.

Almost! What I meant was that rather that each task should have its own
final/marker frame record on its task task rather than sharing a common
global variable.

That way a check for that frame record implicitly checks that a task
started at the expected location *on that stack*, which catches
additional stack corruption cases (e.g. if we left data on the stack
prior to an EL0 entry).

[...]

> > ... I reckon once we've moved the last of the exception triage out to C
> > this will be relatively simple, since all of the exception handlers will
> > look like:
> > 
> > | SYM_CODE_START_LOCAL(elX_exception)
> > | 	kernel_entry X
> > | 	mov	x0, sp
> > | 	bl	elX_exception_handler
> > | 	kernel_exit X
> > | SYM_CODE_END(elX_exception)
> > 
> > ... and so we just need to identify the set of elX_exception functions
> > (which we'll never expect to take exceptions from directly). We could be
> > strict and reject unwinding into arbitrary bits of the entry code (e.g.
> > if we took an unexpected exception), and only permit unwinding to the
> > BL.
> > 
> >> 	It can do this if the FP and PC are also recorded elsewhere in the
> >> 	pt_regs for comparison. Currently, the FP is also stored in
> >> 	regs->regs[29]. The PC is stored in regs->pc. However, regs->pc can
> >> 	be changed by lower level functions.
> >>
> >> 	Create a new field, pt_regs->orig_pc, and record the return address
> >> 	PC there. With this, the unwinder can validate the exception frame
> >> 	and set a flag so that the caller of the unwinder can know when
> >> 	an exception frame is encountered.
> > 
> > I don't understand the case you're trying to solve here. When is
> > regs->pc changed in a way that's problematic?
> > 
> 
> For instance, I used a test driver in which the driver calls a function
> pointer which is NULL. The low level fault handler sends a signal to the
> task. Looks like it changes regs->pc for this.

I'm struggling to follow what you mean here.

If the kernel branches to NULL, the CPU should raise an instruction
abort from the current EL, and our handling of that should terminate the
thread via die_kernel_fault(), without returning to the faulting
context, and without altering the PC in the faulting context.

Signals are delivered to userspace and alter the userspace PC, not a
kernel PC, so this doesn't seem relevant. Do you mean an exception fixup
handler rather than a signal?

> When I dump the stack from the low level handler, the comparison with
> regs->pc does not work.  But comparison with regs->orig_pc works.

As above, I'm struggling with this; could you share a concrete example? 

Thanks,
Mark.
