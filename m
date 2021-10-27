Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15ACC43CAB4
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 15:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhJ0Neo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 09:34:44 -0400
Received: from foss.arm.com ([217.140.110.172]:43394 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJ0Nen (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 09:34:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94F7D1FB;
        Wed, 27 Oct 2021 06:32:17 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.72.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F18073F73D;
        Wed, 27 Oct 2021 06:32:14 -0700 (PDT)
Date:   Wed, 27 Oct 2021 14:32:12 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
Message-ID: <20211027133212.GG54628@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-7-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-7-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 14, 2021 at 09:58:42PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, profile_pc() in ARM64 code walks the stack using
> start_backtrace() and unwind_frame(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/time.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index eebbc8d7123e..671b3038a772 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -32,22 +32,26 @@
>  #include <asm/stacktrace.h>
>  #include <asm/paravirt.h>
>  
> +static bool profile_pc_cb(void *arg, unsigned long pc)
> +{
> +	unsigned long *prof_pc = arg;
> +
> +	if (in_lock_functions(pc))
> +		return true;
> +	*prof_pc = pc;
> +	return false;
> +}
> +
>  unsigned long profile_pc(struct pt_regs *regs)
>  {
> -	struct stackframe frame;
> +	unsigned long prof_pc = 0;
>  
>  	if (!in_lock_functions(regs->pc))
>  		return regs->pc;

This can go -- the first call to profile_pc_cb() will use regs->pc.

With that gone, and the include updates to use <linux/stacktrace.h>:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> -	start_backtrace(&frame, regs->regs[29], regs->pc);
> -
> -	do {
> -		int ret = unwind_frame(NULL, &frame);
> -		if (ret < 0)
> -			return 0;
> -	} while (in_lock_functions(frame.pc));
> +	arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
>  
> -	return frame.pc;
> +	return prof_pc;
>  }
>  EXPORT_SYMBOL(profile_pc);
>  
> -- 
> 2.25.1
> 
