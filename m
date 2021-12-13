Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD1473460
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 19:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhLMSyQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 13:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhLMSyP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 13:54:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4B5C061574;
        Mon, 13 Dec 2021 10:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E2F7B81249;
        Mon, 13 Dec 2021 18:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A4C34604;
        Mon, 13 Dec 2021 18:54:11 +0000 (UTC)
Date:   Mon, 13 Dec 2021 13:54:10 -0500
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
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Message-ID: <20211213135410.12642d8f@gandalf.local.home>
In-Reply-To: <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
        <20211028093547.48c69dfe@gandalf.local.home>
        <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
        <20211213121536.25e5488d@gandalf.local.home>
        <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
        <20211213123338.65eda5a0@gandalf.local.home>
        <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 13 Dec 2021 17:50:52 +0000
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> @@ -958,6 +942,12 @@ unsigned long prepare_ftrace_return(unsigned long 
> parent, unsigned long ip,
>   out:
>   	return parent;
>   }
> +
> +void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
> +		       struct ftrace_ops *op, struct ftrace_regs *fregs)
> +{
> +	prepare_ftrace_return(ip, kernel_stack_pointer(&fregs->regs), 0);
> +}

I have for powerpc prepare_ftrace_return as:


unsigned long prepare_ftrace_return(unsigned long parent, unsigned long ip,
                                                unsigned long sp)
{
        unsigned long return_hooker;

        if (unlikely(ftrace_graph_is_dead()))
                goto out;

        if (unlikely(atomic_read(&current->tracing_graph_pause)))
                goto out;

        return_hooker = ppc_function_entry(return_to_handler);

        if (!function_graph_enter(parent, ip, 0, (unsigned long *)sp))
                parent = return_hooker;
out:
        return parent;
}

Which means you'll need different parameters to it than what x86 has, which
has the prototype of:

void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
			   unsigned long frame_pointer)

and it does not use the frame_pointer for this case, which is why it is
zero.

For powerpc though, it uses the stack pointer, so you parameters are
incorrect. Looks like it should be:

	prepare_ftrace_return(parent_ip, ip, kernel_stack_pointer(&fregs->regs));

And that will likely not be enough. I'll need to update the ctr register,
as that is where the return address is saved. So you'll probably need it to be:

void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
		       struct ftrace_ops *op, struct ftrace_regs *fregs)
{
	unsigned long parent;

	parent = prepare_ftrace_return(parent_ip, ip, kernel_stack_pointer(&fregs->regs));
	fregs->regs.ctr = parent;
}



-- Steve
