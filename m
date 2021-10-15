Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80142EA28
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 09:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhJOHbM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 03:31:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35324 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhJOHbK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 03:31:10 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8F2FE21A5F;
        Fri, 15 Oct 2021 07:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634282942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajbOHu+rClKJMCVN9IOrg9A779y/UiP4OhkzJFOjSQ0=;
        b=Kgq5rJkdVrVP4IDhfsKBOlKRbJj/ElwH9MtJu3TB/6DSQyKaBrnGTAZEUIHTm9Wg9/R9yP
        gS+2GjVcOOgJ8gcQFMUqXpN0t0LxD5W1VSXuJRJZSg5ELwNykVEIFOvyYognnuQg7wAlZK
        xUQAgCSdgE9t8+fHmbr613MI5spEt8o=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7FDD2A3B84;
        Fri, 15 Oct 2021 07:29:01 +0000 (UTC)
Date:   Fri, 15 Oct 2021 09:28:58 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
Message-ID: <YWktujP6DcMnRIXT@alley>
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
 <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
 <YWhJP41cNwDphYsv@alley>
 <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-10-15 11:13:08, 王贇 wrote:
> 
> 
> On 2021/10/14 下午11:14, Petr Mladek wrote:
> [snip]
> >> -	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> >> +	int bit;
> >> +
> >> +	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> >> +	/*
> >> +	 * The zero bit indicate we are nested
> >> +	 * in another trylock(), which means the
> >> +	 * preemption already disabled.
> >> +	 */
> >> +	if (bit > 0)
> >> +		preempt_disable_notrace();
> > 
> > Is this safe? The preemption is disabled only when
> > trace_test_and_set_recursion() was called by ftrace_test_recursion_trylock().
> > 
> > We must either always disable the preemtion when bit >= 0.
> > Or we have to disable the preemtion already in
> > trace_test_and_set_recursion().
> 
> Internal calling of trace_test_and_set_recursion() will disable preemption
> on succeed, it should be safe.

trace_test_and_set_recursion() does _not_ disable preemtion!
It works only because all callers disable the preemption.

It means that the comment is wrong. It is not guarantted that the
preemption will be disabled. It works only by chance.


> We can also consider move the logical into trace_test_and_set_recursion()
> and trace_clear_recursion(), but I'm not very sure about that... ftrace
> internally already make sure preemption disabled

How? Because it calls trace_test_and_set_recursion() via the trylock() API?


> , what uncovered is those users who call API trylock/unlock, isn't
> it?

And this is exactly the problem. trace_test_and_set_recursion() is in
a public header. Anyone could use it. And if anyone uses it in the
future without the trylock() and does not disable the preemtion
explicitely then we are lost again.

And it is even more dangerous. The original code disabled the
preemtion on various layers. As a result, the preemtion was disabled
several times for sure. It means that the deeper layers were
always on the safe side.

With this patch, if the first trace_test_and_set_recursion() caller
does not disable preemtion then trylock() will not disable it either
and the entire code is procceed with preemtion enabled.


> > Finally, the comment confused me a lot. The difference between nesting and
> > recursion is far from clear. And the code is tricky liky like hell :-)
> > I propose to add some comments, see below for a proposal.
> The comments do confusing, I'll make it something like:
> 
> The zero bit indicate trace recursion happened, whatever
> the recursively call was made by ftrace handler or ftrace
> itself, the preemption already disabled.

I am sorry but it is still confusing. We need to find a better way
how to clearly explain the difference between the safe and
unsafe recursion.

My understanding is that the recursion is:

  + "unsafe" when the trace code recursively enters the same trace point.

  + "safe" when ftrace_test_recursion_trylock() is called recursivelly
    while still processing the same trace entry.

> >> +
> >> +	return bit;
> >>  }
> >>  /**
> >> @@ -222,9 +233,13 @@ static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
> >>   * @bit: The return of a successful ftrace_test_recursion_trylock()
> >>   *
> >>   * This is used at the end of a ftrace callback.
> >> + *
> >> + * Preemption will be enabled (if it was previously enabled).
> >>   */
> >>  static __always_inline void ftrace_test_recursion_unlock(int bit)
> >>  {
> >> +	if (bit)
> > 
> > This is not symetric with trylock(). It should be:
> > 
> > 	if (bit > 0)
> > 
> > Anyway, trace_clear_recursion() quiently ignores bit != 0
> 
> Yes, bit == 0 should not happen in here.

Yes, it "should" not happen. My point is that we could make the API
more safe. We could do the right thing when
ftrace_test_recursion_unlock() is called with negative @bit.
Ideally, we should also warn about the mis-use.


Anyway, let's wait for Steven. It seems that he found another problem
with the API that should be solved first. The fix will probably
also help to better understand the "safe" vs "unsafe" recursion.

Best Regards,
Petr
