Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF892B1A1B
	for <lists+live-patching@lfdr.de>; Fri, 13 Nov 2020 12:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgKMLcG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Nov 2020 06:32:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgKMLbc (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Nov 2020 06:31:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC218ABF4;
        Fri, 13 Nov 2020 11:31:11 +0000 (UTC)
Date:   Fri, 13 Nov 2020 12:31:11 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v6] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
In-Reply-To: <20201113020254.023201106@goodmis.org>
Message-ID: <alpine.LSU.2.21.2011131229460.16581@pobox.suse.cz>
References: <20201113020142.252688534@goodmis.org> <20201113020254.023201106@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index e00fe88146e0..7c9474d52060 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -54,6 +54,9 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
>  		return NULL;
>  	return &fregs->regs;
>  }
> +
> +#define ftrace_instruction_pointer_set(fregs, ip)	\
> +	do { (fregs)->regs.ip = (_ip); } while (0)
>  #endif
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
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

You forgot to update the call site :)

Miroslav
