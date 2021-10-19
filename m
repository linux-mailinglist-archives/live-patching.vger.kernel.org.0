Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B897D432BA6
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 04:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJSCEV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Oct 2021 22:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJSCEV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Oct 2021 22:04:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B6A60ED4;
        Tue, 19 Oct 2021 02:02:06 +0000 (UTC)
Date:   Mon, 18 Oct 2021 22:02:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <20211018220203.064a42ed@gandalf.local.home>
In-Reply-To: <YW1KKCFallDG+E01@alley>
References: <20211015110035.14813389@gandalf.local.home>
        <YW1KKCFallDG+E01@alley>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 18 Oct 2021 12:19:20 +0200
Petr Mladek <pmladek@suse.com> wrote:

> > -
> >  	bit = trace_get_context_bit() + start;
> >  	if (unlikely(val & (1 << bit))) {
> >  		/*
> >  		 * It could be that preempt_count has not been updated during
> >  		 * a switch between contexts. Allow for a single recursion.
> >  		 */
> > -		bit = TRACE_TRANSITION_BIT;
> > +		bit = TRACE_CTX_TRANSITION + start;  
>

[..]

> Could we please update the comment? I mean to say if it is a race
> or if we trace a function that should not get traced.

What do you think of this change?

diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index 1d8cce02c3fb..24f284eb55a7 100644
--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -168,8 +168,12 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
 	bit = trace_get_context_bit() + start;
 	if (unlikely(val & (1 << bit))) {
 		/*
-		 * It could be that preempt_count has not been updated during
-		 * a switch between contexts. Allow for a single recursion.
+		 * If an interrupt occurs during a trace, and another trace
+		 * happens in that interrupt but before the preempt_count is
+		 * updated to reflect the new interrupt context, then this
+		 * will think a recursion occurred, and the event will be dropped.
+		 * Let a single instance happen via the TRANSITION_BIT to
+		 * not drop those events.
 		 */
 		bit = TRACE_TRANSITION_BIT;
 		if (val & (1 << bit)) {


-- Steve
