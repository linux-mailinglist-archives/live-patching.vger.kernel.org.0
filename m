Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32CC432E77
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 08:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhJSGnm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 02:43:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36636 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJSGnl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 02:43:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA04B1FD8D;
        Tue, 19 Oct 2021 06:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634625687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yiCf/K6bKrAWm+H5GwYg06T7whuQxu5z+Eyutq5ePEE=;
        b=teDjFL9lr91NMRNc6Iv52QSxJj4QGuwwqDT3OOPMzK0CBm/3l5zawNGoKRXzDeN51cXEJP
        MSlwF/JcwJeOLxY3hgNh8mmlyB20AXu0yYaXblNFINe8pkmoTcCpXT4iQCyA+bOZUlhR5W
        yl7nzpiJ+YDINXRghZ+OA0t106VXXYU=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0F30AA3B81;
        Tue, 19 Oct 2021 06:41:26 +0000 (UTC)
Date:   Tue, 19 Oct 2021 08:41:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <YW5ok3CfNoRMfVQ5@alley>
References: <20211015110035.14813389@gandalf.local.home>
 <YW1KKCFallDG+E01@alley>
 <20211018220203.064a42ed@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018220203.064a42ed@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2021-10-18 22:02:03, Steven Rostedt wrote:
> On Mon, 18 Oct 2021 12:19:20 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > > -
> > >  	bit = trace_get_context_bit() + start;
> > >  	if (unlikely(val & (1 << bit))) {
> > >  		/*
> > >  		 * It could be that preempt_count has not been updated during
> > >  		 * a switch between contexts. Allow for a single recursion.
> > >  		 */
> > > -		bit = TRACE_TRANSITION_BIT;
> > > +		bit = TRACE_CTX_TRANSITION + start;  
> >
> 
> [..]
> 
> > Could we please update the comment? I mean to say if it is a race
> > or if we trace a function that should not get traced.
> 
> What do you think of this change?
> 
> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index 1d8cce02c3fb..24f284eb55a7 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -168,8 +168,12 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
>  	bit = trace_get_context_bit() + start;
>  	if (unlikely(val & (1 << bit))) {
>  		/*
> -		 * It could be that preempt_count has not been updated during
> -		 * a switch between contexts. Allow for a single recursion.
> +		 * If an interrupt occurs during a trace, and another trace
> +		 * happens in that interrupt but before the preempt_count is
> +		 * updated to reflect the new interrupt context, then this
> +		 * will think a recursion occurred, and the event will be dropped.
> +		 * Let a single instance happen via the TRANSITION_BIT to
> +		 * not drop those events.
>  		 */
>  		bit = TRACE_TRANSITION_BIT;
>  		if (val & (1 << bit)) {
> 
> 

Looks good to me. Thanks for the update.

Feel free to postpone this change. I do not want to complicate
upstreaming the fix for stable. I am sorry if I already
complicated it.

Best Regards,
Petr
