Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99DF42F39A
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 15:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbhJONhz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 09:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhJONhx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 09:37:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667A761151;
        Fri, 15 Oct 2021 13:35:44 +0000 (UTC)
Date:   Fri, 15 Oct 2021 09:35:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Petr Mladek <pmladek@suse.com>, Guo Ren <guoren@kernel.org>,
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
Message-ID: <20211015093542.7d9a9671@gandalf.local.home>
In-Reply-To: <3c87e825-e907-cba0-e95f-28878356fc71@linux.alibaba.com>
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
        <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
        <YWhJP41cNwDphYsv@alley>
        <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
        <YWktujP6DcMnRIXT@alley>
        <3c87e825-e907-cba0-e95f-28878356fc71@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 15 Oct 2021 17:12:26 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> Maybe take some example would be easier to understand...
> 
> Currently there are two way of using ftrace_test_recursion_trylock(),
> one with TRACE_FTRACE_XXX we mark as A, one with TRACE_LIST_XXX we mark
> as B, then:
> 
> A followed by B on same context got bit > 0
> B followed by A on any context got bit 0
> A followed by A on same context got bit > 0
> A followed by A followed by A on same context got bit -1
> B followed by B on same context got bit > 0
> B followed by B followed by B on same context got bit -1
> 
> If we get rid of the TRACE_TRANSITION_BIT which allowed recursion for
> onetime, then it would be:

We can't get rid of the transition bit. It's there to fix a bug. Or at
least until we finish the "noinst" issue which may be true now? I have to
go revisit it.

The reason for the transition bit, is because we were dropping function
traces, that people relied on being there. The problem is that the
recursion protection allows for nested context. That is, it will not detect
recursion if we an interrupt triggers during a trace (while the recursion
lock is held) and then that interrupt does a trace. It is allowed to call
the ftrace_test_recursion_trylock() again.

But, what happens if the trace occurs after the interrupt triggers, but
before the preempt_count states that we are now in interrupt context? As
preempt_count is used by this code to determine what context we are in, if
a trace happens in this "transition" state, without the transition bit, a
recursion is detected (false positive) and the event is dropped. People are
then confused on how an interrupt happened, but the entry of the interrupt
never triggered (according to the trace).

The transition bit allows one level of recursion to handle this case.

The "noinst" work may also remove all locations that can be traced before
the context is updated. I need to see if that is now the case, and if it
is, we can remove the transition bit.

This is not the design issue I mentioned earlier. I'm still working on that
one.

-- Steve


> 
> A followed by B on same context got bit > 0
> B followed by A on any context got bit 0
> A followed by A on same context got bit -1
> B followed by B on same context got bit -1
> 
> So as long as no continuously AAA it's safe?

