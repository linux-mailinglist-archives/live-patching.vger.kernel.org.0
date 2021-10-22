Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8CD437C7E
	for <lists+live-patching@lfdr.de>; Fri, 22 Oct 2021 20:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhJVSOU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Oct 2021 14:14:20 -0400
Received: from foss.arm.com ([217.140.110.172]:57458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhJVSOS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Oct 2021 14:14:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A23B1063;
        Fri, 22 Oct 2021 11:12:00 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.73.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D3023F73D;
        Fri, 22 Oct 2021 11:11:57 -0700 (PDT)
Date:   Fri, 22 Oct 2021 19:11:54 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/11] arm64: Make perf_callchain_kernel() use
 arch_stack_walk()
Message-ID: <20211022181154.GM86184@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-3-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 14, 2021 at 09:58:38PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, perf_callchain_kernel() in ARM64 code walks the stack using
> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

This looks good to me; bailing out when perf_callchain_store() can't
accept any more entries absolutely makes sense.

I gave this a spin with:

| #  perf record -g -c1 ls
| #  perf report

... and the recorded callchains look sane.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

As mentioned on patch 1, I'd like to get this rebased atop Peter's
untangling of ARCH_STACKWALK from STACKTRACE.

Thanks,
Mark.

> ---
>  arch/arm64/kernel/perf_callchain.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
> index 4a72c2727309..f173c448e852 100644
> --- a/arch/arm64/kernel/perf_callchain.c
> +++ b/arch/arm64/kernel/perf_callchain.c
> @@ -140,22 +140,18 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>  static bool callchain_trace(void *data, unsigned long pc)
>  {
>  	struct perf_callchain_entry_ctx *entry = data;
> -	perf_callchain_store(entry, pc);
> -	return true;
> +	return perf_callchain_store(entry, pc) == 0;
>  }
>  
>  void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>  			   struct pt_regs *regs)
>  {
> -	struct stackframe frame;
> -
>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
>  		/* We don't support guest os callchain now */
>  		return;
>  	}
>  
> -	start_backtrace(&frame, regs->regs[29], regs->pc);
> -	walk_stackframe(current, &frame, callchain_trace, entry);
> +	arch_stack_walk(callchain_trace, entry, current, regs);
>  }
>  
>  unsigned long perf_instruction_pointer(struct pt_regs *regs)
> -- 
> 2.25.1
> 
