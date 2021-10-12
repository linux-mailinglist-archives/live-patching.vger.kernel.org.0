Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145AF42A468
	for <lists+live-patching@lfdr.de>; Tue, 12 Oct 2021 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhJLMb0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 08:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236281AbhJLMbZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 08:31:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8122460E74;
        Tue, 12 Oct 2021 12:29:21 +0000 (UTC)
Date:   Tue, 12 Oct 2021 08:29:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
Message-ID: <20211012082920.1f8d6557@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2110121421260.3394@pobox.suse.cz>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
        <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
        <alpine.LSU.2.21.2110121421260.3394@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 12 Oct 2021 14:24:43 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> > +++ b/kernel/livepatch/patch.c
> > @@ -52,11 +52,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> >  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
> >  	if (WARN_ON_ONCE(bit < 0))
> >  		return;
> > -	/*
> > -	 * A variant of synchronize_rcu() is used to allow patching functions
> > -	 * where RCU is not watching, see klp_synchronize_transition().
> > -	 */
> > -	preempt_disable_notrace();
> > 
> >  	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
> >  				      stack_node);
> > @@ -120,7 +115,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> >  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
> > 
> >  unlock:
> > -	preempt_enable_notrace();
> >  	ftrace_test_recursion_unlock(bit);
> >  }  
> 
> I don't like this change much. We have preempt_disable there not because 
> of ftrace_test_recursion, but because of RCU. ftrace_test_recursion was 
> added later. Yes, it would work with the change, but it would also hide 
> things which should not be hidden in my opinion.

Agreed, but I believe the change is fine, but requires a nice comment to
explain what you said above.

Thus, before the "ftrace_test_recursion_trylock()" we need:

	/*
	 * The ftrace_test_recursion_trylock() will disable preemption,
	 * which is required for the variant of synchronize_rcu() that is
	 * used to allow patching functions where RCU is not watching.
	 * See klp_synchronize_transition() for more details.
	 */

-- Steve
