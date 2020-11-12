Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1952B07F8
	for <lists+live-patching@lfdr.de>; Thu, 12 Nov 2020 15:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgKLO7S (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Nov 2020 09:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgKLO7S (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Nov 2020 09:59:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518E622201;
        Thu, 12 Nov 2020 14:59:16 +0000 (UTC)
Date:   Thu, 12 Nov 2020 09:59:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v5] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <20201112095914.61bb8a3e@gandalf.local.home>
In-Reply-To: <20201112082144.GS2628@hirez.programming.kicks-ass.net>
References: <20201112011516.589846126@goodmis.org>
        <20201112011815.755256598@goodmis.org>
        <20201112082144.GS2628@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 12 Nov 2020 09:21:44 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 11, 2020 at 08:15:19PM -0500, Steven Rostedt wrote:
> 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index e00fe88146e0..235385a38bd9 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -54,6 +54,9 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
> >  		return NULL;
> >  	return &fregs->regs;
> >  }
> > +
> > +#define ftrace_regs_set_ip(fregs, _ip)		\
> > +	do { (fregs)->regs.ip = (_ip); } while (0)
> >  #endif
> >  
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> > diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> > index 1fde1ab6559e..59a08d5c6f1d 100644
> > --- a/arch/x86/include/asm/livepatch.h
> > +++ b/arch/x86/include/asm/livepatch.h
> > @@ -12,9 +12,9 @@
> >  #include <asm/setup.h>
> >  #include <linux/ftrace.h>
> >  
> > -static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> > +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
> >  {
> > -	regs->ip = ip;
> > +	ftrace_regs_set_ip(fregs, ip);
> >  }
> >    
> 
> The normal variant is called instruction_pointer_set(), should this be
> called ftrace_instruction_pointer_set() ?

Sure, I can change that.

> 
> (and yes, I hate the long name too).

 ftrace_regs_ip_set()? ;-)

> 
> Also, do you want something like:
> 
> unsigned long ftrace_regs_get_register(struct ftrace_regs *regs, unsigned int offset)
> {

I haven't gotten this far yet. I'm looking at generic use cases on how to
get args across archs. Each arch will have its own method.


> 	switch (offset / sizeof(long)) {
> 	case  4: /* RBP */
> 
> 	case  8: /* R9  */
> 	case  9: /* R8  */
> 	case 10: /* RAX */
> 	case 11: /* RCX */
> 	case 12: /* RDX */
> 	case 13: /* RSI */
> 	case 14: /* RDI */
> 	case 15: /* ORIG_RAX */
> 	case 16: /* RIP */
> 		return *(unsigned long *)regs->regs + offset;
> 
> 	default:
> 		WARN_ON_ONCE(1);

Not sure we even want to warn. Perhaps have this as:

bool ftrace_regs_get_register(struct ftrace_regs *regs,
                  unsigned int offset, unsigned long *val)
{
	if (regs->cs) {
		*val = regs_get_register(regs->regs, offset);
		return true;
	}
		
	switch (offset / sizeof(long)) {
	case ...:
		*val = *(unsigned long *)regs->regs + offset;
		return true;
	default;
		return false;
> 	}



-- Steve
