Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7396343B1D7
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 14:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhJZMIB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 08:08:01 -0400
Received: from foss.arm.com ([217.140.110.172]:57232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235685AbhJZMH4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 08:07:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54E8C1FB;
        Tue, 26 Oct 2021 05:05:31 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.74.144])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3E453F73D;
        Tue, 26 Oct 2021 05:05:28 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:05:16 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 05/11] arm64: Make dump_stacktrace() use
 arch_stack_walk()
Message-ID: <20211026120516.GA34073@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-6-madvenka@linux.microsoft.com>
 <20211025164925.GB2001@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025164925.GB2001@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 25, 2021 at 05:49:25PM +0100, Mark Rutland wrote:
> From f3e66ca75aff3474355839f72d123276028204e1 Mon Sep 17 00:00:00 2001
> From: Mark Rutland <mark.rutland@arm.com>
> Date: Mon, 25 Oct 2021 13:23:11 +0100
> Subject: [PATCH] arm64: ftrace: use HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
> 
> When CONFIG_FUNCTION_GRAPH_TRACER is selected, and the function graph:
> tracer is in use, unwind_frame() may erroneously asscociate a traced
> function with an incorrect return address. This can happen when starting
> an unwind from a pt_regs, or when unwinding across an exception
> boundary.
> 
> The underlying problem is that ftrace_graph_get_ret_stack() takes an
> index offset from the most recent entry added to the fgraph return
> stack. We start an unwind at offset 0, and increment the offset each
> time we encounter `return_to_handler`, which indicates a rewritten
> return address. This is broken in two cases:
> 
> * Between creating a pt_regs and starting the unwind, function calls may
>   place entries on the stack, leaving an abitrary offset which we can
>   only determine by performing a full unwind from the caller of the
>   unwind code. While this initial unwind is open-coded in
>   dump_backtrace(), this is not performed for other unwinders such as
>   perf_callchain_kernel().
> 
> * When unwinding across an exception boundary (whether continuing an
>   unwind or starting a new unwind from regs), we always consume the LR
>   of the interrupted context, though this may not have been live at the
>   time of the exception. Where the LR was not live but happened to
>   contain `return_to_handler`, we'll recover an address from the graph
>   return stack and increment the current offset, leaving subsequent
>   entries off-by-one.
> 
>   Where the LR was not live and did not contain `return_to_handler`, we
>   will still report an erroneous address, but subsequent entries will be
>   unaffected.

It turns out I had this backwards, and we currently always *skip* the LR
when unwinding across regs, because:

* The entry assembly creates a synthetic frame record with the original
  FP and the ELR_EL1 value (i.e. the PC at the point of the exception),
  skipping the LR.

* In arch_stack_walk() we start the walk from regs->pc, and continue
  with the frame record, skipping the LR.

* In the existing dump_backtrace, we skip until we hit a frame record
  whose FP value matches the FP in the regs (i.e. the synthetic frame
  record created by the entry assembly). That'll dump the ELR_EL1 value,
  then continue to the next frame record, skipping the LR.

So case two is bogus, and only case one can happen today. This cleanup
shouldn't trigger the WARN_ON_ONCE() in unwind_frame(), and we can fix
the missing LR entry in a subsequent cleanup.

Thanks,
Mark.
