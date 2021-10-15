Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73342FB96
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbhJOTDC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 15:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242270AbhJOTDB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 15:03:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCAA061041;
        Fri, 15 Oct 2021 19:00:51 +0000 (UTC)
Date:   Fri, 15 Oct 2021 15:00:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <20211015150050.3310b3bf@gandalf.local.home>
In-Reply-To: <20211015182459.GL174703@worktop.programming.kicks-ass.net>
References: <20211015110035.14813389@gandalf.local.home>
        <20211015161702.GF174703@worktop.programming.kicks-ass.net>
        <20211015133504.6c0a9fcc@gandalf.local.home>
        <20211015135806.72d1af23@gandalf.local.home>
        <20211015180429.GK174703@worktop.programming.kicks-ass.net>
        <20211015142033.72605b47@gandalf.local.home>
        <20211015182459.GL174703@worktop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 15 Oct 2021 20:24:59 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > @@ -206,11 +206,7 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
> >  static inline int get_recursion_context(int *recursion)
> >  {
> >  	unsigned int pc = preempt_count();  
> 
> Although I think we can do without that ^ line as well :-)

Ah, I could have sworn I deleted it. Oh well, will make a proper patch set.

Thanks!

-- Steve


> 
> > -	unsigned char rctx = 0;
