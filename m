Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522682B0124
	for <lists+live-patching@lfdr.de>; Thu, 12 Nov 2020 09:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgKLIV6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Nov 2020 03:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLIV6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Nov 2020 03:21:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E77C0613D1;
        Thu, 12 Nov 2020 00:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bDhGCoNCH4JKfnFAw99KraNMb+ggnOriYZE/KLPpuXY=; b=HnA2HdLR7qhmdpHPgKtaTFyRYV
        JykJrDLWCWqw3jJrHgGUy8ViT3YnZJG4HrE32volI9oE2msYuD0gre5drZxgRTYvf0gseVVMMMD0m
        vHojUijaNpJjnmnDXkuj6GFMBTjlrTrFkgdzDb8J3qptzAdItWV8NNRQ7x35sV++fqpG6MZmgHFs3
        lrW4bs1TIixvY83iECdVT8czTUE/f2CnLOixR+zPHQgfQTjCcG0sFNXujmDtvhiI1llo60hlnZQLH
        U5wR8vqKWX2Bp+Xjwx59BSWaI2OwzeuwcSb9wbun0fT4Wyseffmy76MCd4blJx1IM5Rkx6XWGt3LD
        qotqfJnQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kd7rV-00028z-Sk; Thu, 12 Nov 2020 08:21:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9D4B8301324;
        Thu, 12 Nov 2020 09:21:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5EAE22BDE7EF8; Thu, 12 Nov 2020 09:21:44 +0100 (CET)
Date:   Thu, 12 Nov 2020 09:21:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v5] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <20201112082144.GS2628@hirez.programming.kicks-ass.net>
References: <20201112011516.589846126@goodmis.org>
 <20201112011815.755256598@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112011815.755256598@goodmis.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 11, 2020 at 08:15:19PM -0500, Steven Rostedt wrote:

> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index e00fe88146e0..235385a38bd9 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -54,6 +54,9 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
>  		return NULL;
>  	return &fregs->regs;
>  }
> +
> +#define ftrace_regs_set_ip(fregs, _ip)		\
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
>  }
>  

The normal variant is called instruction_pointer_set(), should this be
called ftrace_instruction_pointer_set() ?

(and yes, I hate the long name too).

Also, do you want something like:

unsigned long ftrace_regs_get_register(struct ftrace_regs *regs, unsigned int offset)
{
	switch (offset / sizeof(long)) {
	case  4: /* RBP */

	case  8: /* R9  */
	case  9: /* R8  */
	case 10: /* RAX */
	case 11: /* RCX */
	case 12: /* RDX */
	case 13: /* RSI */
	case 14: /* RDI */
	case 15: /* ORIG_RAX */
	case 16: /* RIP */
		return *(unsigned long *)regs->regs + offset;

	default:
		WARN_ON_ONCE(1);
	}
	return 0;
}
