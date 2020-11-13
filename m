Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA012B1B9C
	for <lists+live-patching@lfdr.de>; Fri, 13 Nov 2020 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgKMNKK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Nov 2020 08:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgKMNKK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Nov 2020 08:10:10 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7423208D5;
        Fri, 13 Nov 2020 13:10:08 +0000 (UTC)
Date:   Fri, 13 Nov 2020 08:10:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v6] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <20201113081006.00c350c7@oasis.local.home>
In-Reply-To: <alpine.LSU.2.21.2011131229460.16581@pobox.suse.cz>
References: <20201113020142.252688534@goodmis.org>
        <20201113020254.023201106@goodmis.org>
        <alpine.LSU.2.21.2011131229460.16581@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 13 Nov 2020 12:31:11 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

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
> 
> You forgot to update the call site :)

Bah. This would have been caught via my full test suite, but I only ran
the cross compiling tests :-P

Thanks, will fix in v7.

-- Steve
