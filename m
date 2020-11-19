Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373F12B91E3
	for <lists+live-patching@lfdr.de>; Thu, 19 Nov 2020 12:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgKSLwE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Nov 2020 06:52:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:38972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbgKSLwD (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Nov 2020 06:52:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605786720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0orS1kguKvUDUAcNIvHV8RnxWd3fbv2oJIa1VA4KWp4=;
        b=kGTPNdtAOvAhUZQxiF+jjUmHO6YpE055dV46rXIiqzmWgMDpHBVXIs0ejY1IcSdv6VQI7L
        UPKPypxheXaSAQTNDAG9W/PQ0jDorD9t++gaUjWQfPJDNG7ZDsxakl7WhLRelf/qm3PYLD
        T/K7SIb5v89++Zb3Zr0vHi7rPCAGLBg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A2E0AABF4;
        Thu, 19 Nov 2020 11:52:00 +0000 (UTC)
Date:   Thu, 19 Nov 2020 12:52:00 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v7] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <X7ZcYIWJEPXW6Z9s@alley>
References: <20201113171811.288150055@goodmis.org>
 <20201113171939.455339580@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113171939.455339580@goodmis.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-11-13 12:18:14, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> When CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS is available, the ftrace call
> will be able to set the ip of the calling function. This will improve the
> performance of live kernel patching where it does not need all the regs to
> be stored just to change the instruction pointer.
> 
> If all archs that support live kernel patching also support
> HAVE_DYNAMIC_FTRACE_WITH_ARGS, then the architecture specific function
> klp_arch_set_pc() could be made generic.
> 
> It is possible that an arch can support HAVE_DYNAMIC_FTRACE_WITH_ARGS but
> not HAVE_DYNAMIC_FTRACE_WITH_REGS and then have access to live patching.
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: live-patching@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v6:
>  - Updated to use ftrace_instruction_pointer_set() macro
> 
>  arch/powerpc/include/asm/livepatch.h | 4 +++-
>  arch/s390/include/asm/livepatch.h    | 5 ++++-
>  arch/x86/include/asm/ftrace.h        | 3 +++
>  arch/x86/include/asm/livepatch.h     | 4 ++--
>  arch/x86/kernel/ftrace_64.S          | 4 ++++
>  include/linux/ftrace.h               | 7 +++++++
>  kernel/livepatch/Kconfig             | 2 +-
>  kernel/livepatch/patch.c             | 9 +++++----
>  8 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
> index 4a3d5d25fed5..ae25e6e72997 100644
> --- a/arch/powerpc/include/asm/livepatch.h
> +++ b/arch/powerpc/include/asm/livepatch.h
> @@ -12,8 +12,10 @@
>  #include <linux/sched/task_stack.h>
>  
>  #ifdef CONFIG_LIVEPATCH
> -static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  {
> +	struct pt_regs *regs = ftrace_get_regs(fregs);

Should we check for NULL pointer here?

> +
>  	regs->nip = ip;
>  }
>  
> diff --git a/arch/s390/include/asm/livepatch.h b/arch/s390/include/asm/livepatch.h
> index 818612b784cd..d578a8c76676 100644
> --- a/arch/s390/include/asm/livepatch.h
> +++ b/arch/s390/include/asm/livepatch.h
> @@ -11,10 +11,13 @@
>  #ifndef ASM_LIVEPATCH_H
>  #define ASM_LIVEPATCH_H
>  
> +#include <linux/ftrace.h>
>  #include <asm/ptrace.h>
>  
> -static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  {
> +	struct pt_regs *regs = ftrace_get_regs(fregs);

And here?

> +
>  	regs->psw.addr = ip;
>  }
>  

Otherwise, it looks for me.

Best Regards,
Petr
