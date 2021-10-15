Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA86042FB03
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 20:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhJOSb4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 14:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbhJOSb4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 14:31:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6ADC061570;
        Fri, 15 Oct 2021 11:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=us4YosfodZgYMwFe8rJkfXK5dBQB718M3Lke3zJ1ToY=; b=cY0CRJ4SyOUVhj9UQyVxaRjiQw
        /1wr6TKwpWSzfpNTEbXEKVniDAC2ka6eybM+zn4dvXDqwYkZkvTR7v491RJDKTw//hD58xTRj4oSR
        0QlPPMnjn7Kj5Q69itBEQRhxFEDeXwGDeihgs8rBliRLbgQ1rALI78w76v8T7IV7afCS0Fz+4Wm/4
        JqW5/oOc7BvO/34prpputAko6YLKktrYcXK5QZw27hBqOhlswQg+31OoFJIp0mMSv5a8AOMHrtuWW
        Noym6xZO/FLCs8cS2lPtQPTbXYrAqWX9Q1Zx+cYlupXrs+iYell2Jzqq1JcZWRqrfVcDkMJ/NiCjB
        zMNudW1A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbRt6-009CM0-0J; Fri, 15 Oct 2021 18:25:17 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 90BD19857C7; Fri, 15 Oct 2021 20:24:59 +0200 (CEST)
Date:   Fri, 15 Oct 2021 20:24:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <20211015182459.GL174703@worktop.programming.kicks-ass.net>
References: <20211015110035.14813389@gandalf.local.home>
 <20211015161702.GF174703@worktop.programming.kicks-ass.net>
 <20211015133504.6c0a9fcc@gandalf.local.home>
 <20211015135806.72d1af23@gandalf.local.home>
 <20211015180429.GK174703@worktop.programming.kicks-ass.net>
 <20211015142033.72605b47@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015142033.72605b47@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 15, 2021 at 02:20:33PM -0400, Steven Rostedt wrote:
> On Fri, 15 Oct 2021 20:04:29 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Oct 15, 2021 at 01:58:06PM -0400, Steven Rostedt wrote:
> > > Something like this:  
> > 
> > I think having one copy of that in a header is better than having 3
> > copies. But yes, something along them lines.
> 
> I was just about to ask you about this patch ;-)

Much better :-)

> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index 228801e20788..c91711f20cf8 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -206,11 +206,7 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
>  static inline int get_recursion_context(int *recursion)
>  {
>  	unsigned int pc = preempt_count();

Although I think we can do without that ^ line as well :-)

> -	unsigned char rctx = 0;
> -
> -	rctx += !!(pc & (NMI_MASK));
> -	rctx += !!(pc & (NMI_MASK | HARDIRQ_MASK));
> -	rctx += !!(pc & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET));
> +	unsigned char rctx = interrupt_context_level();
>  
>  	if (recursion[rctx])
>  		return -1;
