Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E362A0632
	for <lists+live-patching@lfdr.de>; Fri, 30 Oct 2020 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJ3NHO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Oct 2020 09:07:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:58932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgJ3NHO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Oct 2020 09:07:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 05626ABAE;
        Fri, 30 Oct 2020 13:07:12 +0000 (UTC)
Date:   Fri, 30 Oct 2020 14:07:11 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 3/3 v3] livepatching: Use the default ftrace_ops
 instead of REGS when ARGS is available
In-Reply-To: <20201029002253.192388563@goodmis.org>
Message-ID: <alpine.LSU.2.21.2010301359370.22360@pobox.suse.cz>
References: <20201029000816.272878754@goodmis.org> <20201029002253.192388563@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

(live-patching ML CCed, keeping the complete email for reference)

Hi,

a nit concerning the subject. We use just "livepatch:" as a prefix.

On Wed, 28 Oct 2020, Steven Rostedt wrote:

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

I think this is a nice idea, which could easily lead to removing 
FTRACE_WITH_REGS altogether. I'm really looking forward to that because 
every consolidation step is welcome.

My only remark is for the config. LIVEPATCH now depends on 
DYNAMIC_FTRACE_WITH_REGS which is not completely true after this change, 
so we should probably make it depend on DYNAMIC_FTRACE_WITH_REGS || 
DYNAMIC_FTRACE_WITH_ARGS, just to reflect the situation better.

Anyway, it passed my tests too and the patch looks good to me, so

Acked-by: Miroslav Benes <mbenes@suse.cz>

M

> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  arch/powerpc/include/asm/livepatch.h | 4 +++-
>  arch/s390/include/asm/livepatch.h    | 5 ++++-
>  arch/x86/include/asm/ftrace.h        | 3 +++
>  arch/x86/include/asm/livepatch.h     | 4 ++--
>  arch/x86/kernel/ftrace_64.S          | 4 ++++
>  include/linux/ftrace.h               | 7 +++++++
>  kernel/livepatch/patch.c             | 9 +++++----
>  7 files changed, 28 insertions(+), 8 deletions(-)
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
> +
>  	regs->psw.addr = ip;
>  }
>  
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index 6b175c2468e6..7042e80941e5 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -62,6 +62,9 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
>  		return NULL;
>  	return &fregs->regs;
>  }
> +
> +#define ftrace_regs_set_ip(fregs, _ip)		\
> +	do { (fregs)->regs.ip = (_ip); } while (0)
>  #endif
>  
>  #endif /*  CONFIG_DYNAMIC_FTRACE */
> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> index 1fde1ab6559e..59a08d5c6f1d 100644
> --- a/arch/x86/include/asm/livepatch.h
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -12,9 +12,9 @@
>  #include <asm/setup.h>
>  #include <linux/ftrace.h>
>  
> -static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  {
> -	regs->ip = ip;
> +	ftrace_regs_set_ip(fregs, ip);
>  }
>  
>  #endif /* _ASM_X86_LIVEPATCH_H */
> diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
> index c4177bd00cd2..d00806dd8eed 100644
> --- a/arch/x86/kernel/ftrace_64.S
> +++ b/arch/x86/kernel/ftrace_64.S
> @@ -157,6 +157,10 @@ SYM_INNER_LABEL(ftrace_caller_op_ptr, SYM_L_GLOBAL)
>  SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
>  	call ftrace_stub
>  
> +	/* Handlers can change the RIP */
> +	movq RIP(%rsp), %rax
> +	movq %rax, MCOUNT_REG_SIZE(%rsp)
> +
>  	restore_mcount_regs
>  
>  	/*
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 588ea7023a7a..b4eb962e2be9 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -97,6 +97,13 @@ struct ftrace_regs {
>  };
>  #define arch_ftrace_get_regs(fregs) (&(fregs)->regs)
>  
> +/*
> + * ftrace_regs_set_ip() is to be defined by the architecture if
> + * to allow setting of the instruction pointer from the ftrace_regs
> + * when HAVE_DYNAMIC_FTRACE_WITH_ARGS is set and it supports
> + * live kernel patching.
> + */
> +#define ftrace_regs_set_ip(fregs, ip) do { } while (0)
>  #endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
>  
>  static __always_inline struct pt_regs *ftrace_get_regs(struct ftrace_regs *fregs)
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index 9af0a7c8a255..722266472903 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -42,7 +42,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  				       struct ftrace_ops *fops,
>  				       struct ftrace_regs *fregs)
>  {
> -	struct pt_regs *regs = ftrace_get_regs(fregs);
>  	struct klp_ops *ops;
>  	struct klp_func *func;
>  	int patch_state;
> @@ -118,7 +117,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	if (func->nop)
>  		goto unlock;
>  
> -	klp_arch_set_pc(regs, (unsigned long)func->new_func);
> +	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
>  
>  unlock:
>  	preempt_enable_notrace();
> @@ -200,8 +199,10 @@ static int klp_patch_func(struct klp_func *func)
>  			return -ENOMEM;
>  
>  		ops->fops.func = klp_ftrace_handler;
> -		ops->fops.flags = FTRACE_OPS_FL_SAVE_REGS |
> -				  FTRACE_OPS_FL_DYNAMIC |
> +		ops->fops.flags = FTRACE_OPS_FL_DYNAMIC |
> +#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
> +				  FTRACE_OPS_FL_SAVE_REGS |
> +#endif
>  				  FTRACE_OPS_FL_IPMODIFY |
>  				  FTRACE_OPS_FL_PERMANENT;
>  
> -- 
> 2.28.0
> 
> 

