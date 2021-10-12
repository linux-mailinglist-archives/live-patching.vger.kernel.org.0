Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4972942A31C
	for <lists+live-patching@lfdr.de>; Tue, 12 Oct 2021 13:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbhJLLXx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 07:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbhJLLXw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 07:23:52 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701A0C061570;
        Tue, 12 Oct 2021 04:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=UdEw1pT+fzl3XWuMYAjaroJq/eSkWpToEoEiK0H4tc8=; b=FQxDrQd8VQL8FLxSXHhYsFD549
        Bw3bzrYjTSkvz6brYato3qgL9mUti/CSCA7aSlS/rdOtg3iWvvcBBvUgAeYrIFknl4VrCnIAyARwb
        W2ZXY143bMOgnoZk5lM0F0hWDwSbN7tcO2rrRt3vOI6Gu/hOdQfvMSUKEbu89ZHT8kEVJjserHvJd
        T7a8jHQf222nRNoBi1vcek3vurQIbT0ONUwczkQh/COwwW0ZYFL0GAmCPPO+A5W3537y79C/w1pmK
        EI8baZ2LtgSX5reCbuBE8jcoOFTckA/Kx6YdhS5bzDlaMwjvlkTi6AJztbRxgYS/jG5G8VzhIIzeL
        6WxmRXvw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1maFpg-009P0D-Kh; Tue, 12 Oct 2021 11:20:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5AAF630032E;
        Tue, 12 Oct 2021 13:20:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0E30E20218D80; Tue, 12 Oct 2021 13:20:29 +0200 (CEST)
Date:   Tue, 12 Oct 2021 13:20:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
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
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: prevent preemption in
 perf_ftrace_function_call()
Message-ID: <YWVvfBybqjKuifum@hirez.programming.kicks-ass.net>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
 <7ec34e08-a357-58d6-2ce4-c7472d8b0381@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ec34e08-a357-58d6-2ce4-c7472d8b0381@linux.alibaba.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 12, 2021 at 01:40:31PM +0800, 王贇 wrote:

> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 6aed10e..33c2f76 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -441,12 +441,19 @@ void perf_trace_buf_update(void *record, u16 type)
>  	if (!rcu_is_watching())
>  		return;
> 
> +	/*
> +	 * Prevent CPU changing from now on. rcu must
> +	 * be in watching if the task was migrated and
> +	 * scheduled.
> +	 */
> +	preempt_disable_notrace();
> +
>  	if ((unsigned long)ops->private != smp_processor_id())
> -		return;
> +		goto out;
> 
>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>  	if (bit < 0)
> -		return;
> +		goto out;
> 
>  	event = container_of(ops, struct perf_event, ftrace_ops);
> 

This seems rather daft, wouldn't it be easier to just put that check
under the recursion thing?
