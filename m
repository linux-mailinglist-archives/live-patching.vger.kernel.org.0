Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABD742A458
	for <lists+live-patching@lfdr.de>; Tue, 12 Oct 2021 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhJLM0u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 08:26:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36472 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbhJLM0t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 08:26:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 52F7E2008D;
        Tue, 12 Oct 2021 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634041486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ak50EaVK3T2xTOor5Gd356wiLx9ZgAxHtCEMYkhSwNY=;
        b=NpEckCnyzfzZUxRiTtHccM6MSmoh8iAqzDmMQH3nvC9cklNV1aH2j0mqOYNL6LBcF1FeMn
        ZS7r6xkvovnOOVDfrUeNHLg+1IzJSOHmBmp9BmIxbCSlOHerYxzwJLnjrK76VmPaF4eviM
        Mtj7AQh9vh6k4vNWt1qYyojA7mlg/Nc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634041486;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ak50EaVK3T2xTOor5Gd356wiLx9ZgAxHtCEMYkhSwNY=;
        b=Txq3fZPPSrbXYn9fRcHcLC8++QyRUHTnoTmwTaV7ZXHhoiXC5v/Y+ZRgg4PZ9Lgr86Iqhj
        AAWT2wwIZo5qkwCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F220BA3B84;
        Tue, 12 Oct 2021 12:24:43 +0000 (UTC)
Date:   Tue, 12 Oct 2021 14:24:43 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     =?ISO-2022-JP?Q?=1B$B2&lV=1B=28J?= <yun.wang@linux.alibaba.com>
cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
Message-ID: <alpine.LSU.2.21.2110121421260.3394@pobox.suse.cz>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com> <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index a9f9c57..805f9c4 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -214,7 +214,14 @@ static __always_inline void trace_clear_recursion(int bit)
>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>  							 unsigned long parent_ip)
>  {
> -	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	int bit;
> +
> +	preempt_disable_notrace();
> +	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	if (bit < 0)
> +		preempt_enable_notrace();
> +
> +	return bit;
>  }
> 
>  /**
> @@ -226,6 +233,7 @@ static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>  static __always_inline void ftrace_test_recursion_unlock(int bit)
>  {
>  	trace_clear_recursion(bit);
> +	preempt_enable_notrace();
>  }
> 
>  #endif /* CONFIG_TRACING */
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index e8029ae..6e66ccd 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -52,11 +52,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>  	if (WARN_ON_ONCE(bit < 0))
>  		return;
> -	/*
> -	 * A variant of synchronize_rcu() is used to allow patching functions
> -	 * where RCU is not watching, see klp_synchronize_transition().
> -	 */
> -	preempt_disable_notrace();
> 
>  	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
>  				      stack_node);
> @@ -120,7 +115,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
> 
>  unlock:
> -	preempt_enable_notrace();
>  	ftrace_test_recursion_unlock(bit);
>  }

I don't like this change much. We have preempt_disable there not because 
of ftrace_test_recursion, but because of RCU. ftrace_test_recursion was 
added later. Yes, it would work with the change, but it would also hide 
things which should not be hidden in my opinion.

Miroslav
