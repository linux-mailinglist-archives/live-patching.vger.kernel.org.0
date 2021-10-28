Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2655143E260
	for <lists+live-patching@lfdr.de>; Thu, 28 Oct 2021 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhJ1NiS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Oct 2021 09:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhJ1NiR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Oct 2021 09:38:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF5261038;
        Thu, 28 Oct 2021 13:35:49 +0000 (UTC)
Date:   Thu, 28 Oct 2021 09:35:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Message-ID: <20211028093547.48c69dfe@gandalf.local.home>
In-Reply-To: <cover.1635423081.git.christophe.leroy@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 28 Oct 2021 14:24:00 +0200
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> This series implements livepatch on PPC32.
> 
> This is largely copied from what's done on PPC64.
> 
> Christophe Leroy (5):
>   livepatch: Fix build failure on 32 bits processors
>   powerpc/ftrace: No need to read LR from stack in _mcount()
>   powerpc/ftrace: Add module_trampoline_target() for PPC32
>   powerpc/ftrace: Activate HAVE_DYNAMIC_FTRACE_WITH_REGS on PPC32
>   powerpc/ftrace: Add support for livepatch to PPC32
> 
>  arch/powerpc/Kconfig                  |   2 +-
>  arch/powerpc/include/asm/livepatch.h  |   4 +-
>  arch/powerpc/kernel/module_32.c       |  33 +++++
>  arch/powerpc/kernel/trace/ftrace.c    |  53 +++-----
>  arch/powerpc/kernel/trace/ftrace_32.S | 187 ++++++++++++++++++++++++--
>  kernel/livepatch/core.c               |   4 +-
>  6 files changed, 230 insertions(+), 53 deletions(-)
> 

This is great that you are doing this, but I wonder if it would even be
easier, and more efficient, if you could implement
HAVE_DYNAMIC_FTRACE_WITH_ARGS?

Then you don't need to save all regs for live kernel patching. And I am
also working on function tracing with arguments with this too.

That is, to call a generic ftrace callback, you need to save all the args
that are stored in registers to prevent the callback from clobbering them.
As live kernel patching only needs to have the arguments of the functions,
you save time from having to save the other regs as well.

The callbacks now have "struct ftrace_regs" instead of pt_regs, because it
will allow non ftrace_regs_caller functions to access the arguments if it
is supported.

Look at how x86_64 implements this. It should be possible to do this for
all other archs as well.

Also note, by doing this, we can then get rid of the ftrace_graph_caller,
and have function graph tracer be a function tracing callback, as it will
allow ftrace_graph_caller to have access to the stack and the return as
well.

If you need any more help or information to do this, I'd be happy to assist
you.

Note, you can implement this first, (I looked over the patches and they
seem fine) and then update both ppc64 and ppc32 to implement
DYNAMIC_FTRACE_WITH_ARGS.

Cheers,

-- Steve
