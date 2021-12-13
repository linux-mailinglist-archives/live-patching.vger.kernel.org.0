Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824F24732C1
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 18:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbhLMRPk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 12:15:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56626 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhLMRPk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 12:15:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D489561191;
        Mon, 13 Dec 2021 17:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F6FC34602;
        Mon, 13 Dec 2021 17:15:38 +0000 (UTC)
Date:   Mon, 13 Dec 2021 12:15:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Message-ID: <20211213121536.25e5488d@gandalf.local.home>
In-Reply-To: <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
        <20211028093547.48c69dfe@gandalf.local.home>
        <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 13 Dec 2021 14:39:15 +0000
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> > Note, you can implement this first, (I looked over the patches and they
> > seem fine) and then update both ppc64 and ppc32 to implement
> > DYNAMIC_FTRACE_WITH_ARGS.
> >   
> 
> I tried to activate DYNAMIC_FTRACE_WITH_ARGS on PPC32.
> 
> I copied into powerpc the changes from 5740a7c71ab6 ("s390/ftrace: add 
> HAVE_DYNAMIC_FTRACE_WITH_ARGS support")
> 
> Ftrace selftests tell "Testing tracer function_graph: FAILED!".
> 
> Is there anything else to do ?

Yes. Because BPF is now hooking into the function callbacks, it causes
issues with function graph tracer. So what we did was to have function
graph tracing to now use the function tracer callback as well (this allows
both the BPF direct trampolines to work with function graph tracer).

As it requires DYNAMIC_FTRACE_WITH_ARGS, and x86 was the only one to
support that for now, I decided to make all the archs change function graph
tracing when they implement DYNAMIC_FTRACE_WITH_ARGS too. (It is becoming a
pain to have too many variants of function tracing between the archs).

The change that did this for x86 was:

0c0593b45c9b4 ("x86/ftrace: Make function graph use ftrace directly")

This actually simplifies the function graph tracer, as you no longer need
it's own entry trampoline (still need the trampoline for the return of the
function).

What you need to do is:

In your arch/*/include/asm/ftrace.h add:

struct ftrace_ops;

#define ftrace_graph_func ftrace_graph_func
void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
                      struct ftrace_ops *op, struct ftrace_regs *fregs);


Where ftrace_graph_func() is now what is called for the function graph
tracer, directly from the ftrace callbacks (no longer a secondary
trampoline).

Define the ftrace_graph_func() to be something like:

void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
                      struct ftrace_ops *op, struct ftrace_regs *fregs)
{
       struct pt_regs *regs = &fregs->regs;
       unsigned long *stack = (unsigned long *)kernel_stack_pointer(regs);

       prepare_ftrace_return(ip, (unsigned long *)stack, 0);
}

This is called by the function tracer code. But because with
DYNAMIC_FTRACE_WITH_ARGS, we have access to the argument register, we should
also have access to the link register and the stack. Then you can use that
to modify the stack and or link register to jump to the the return
trampoline.

This should all work with powerpc (both 64 and 32) but if it does not, let
me know. I'm happy to help out.

-- Steve
