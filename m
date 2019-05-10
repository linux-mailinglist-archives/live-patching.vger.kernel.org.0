Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198F8196BB
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 04:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfEJChf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 22:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfEJChb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 22:37:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEE26217F4;
        Fri, 10 May 2019 02:37:29 +0000 (UTC)
Date:   Thu, 9 May 2019 22:37:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
Message-ID: <20190509223728.203a58cd@gandalf.local.home>
In-Reply-To: <20190509154902.34ea14f8@gandalf.local.home>
References: <20190509154902.34ea14f8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 9 May 2019 15:49:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index cf350639e76d..287f1f7b2e52 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -3,12 +3,10 @@
>  #define _ASM_X86_FTRACE_H
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> -#ifdef CC_USING_FENTRY
> -# define MCOUNT_ADDR		((unsigned long)(__fentry__))
> -#else
> -# define MCOUNT_ADDR		((unsigned long)(mcount))
> -# define HAVE_FUNCTION_GRAPH_FP_TEST
> +#ifndef CC_USING_FENTRY
> +# error Compiler does not support fentry?
>  #endif
> +# define MCOUNT_ADDR		((unsigned long)(__fentry__))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE

Failed my tests. :-(

In arch/x86/Kconfig ...

	select HAVE_FENTRY                      if X86_64 || DYNAMIC_FTRACE


Bah! I need to work a little on this patch.

I need to implement fentry in the !DYNAMIC_FTRACE code of x86_32 first.
Shouldn't be too hard, but still.

I could also just force DYNAMIC_FTRACE to be 'y' for x86_32 if
CONFIG_FUNCTION_TRACER is set. The only reason I still support static
FTRACE on x86 is because I use it to test !DYNAMIC_FTRACE generic code,
because there's still some archs that only support the !DYNAMIC_FTRACE
function tracer.

-- Steve
