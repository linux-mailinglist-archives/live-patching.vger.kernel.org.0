Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EDD42D5C7
	for <lists+live-patching@lfdr.de>; Thu, 14 Oct 2021 11:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhJNJPX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 05:15:23 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34094 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhJNJPW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 05:15:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1619621A78;
        Thu, 14 Oct 2021 09:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634202796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6qlO0B+dKVbDjD2ahAupf74QzcuBtOf+3HozXO78zVI=;
        b=TNcMw28JoUbqZZrjTwmFLWtEVPnNV5ytCnksIJIdcU85oBHx2uqflkwC21OnsmYSMeNEMC
        kYFkvf6iLxxdWYUsCUjTTstLSlPXR1+HgAuC5TKPtflyHbB0YnOvbj/4sp7TYCc11H5GiQ
        3hThb2kfKCZXvj271cl6oZ0iXmz+5fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634202796;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6qlO0B+dKVbDjD2ahAupf74QzcuBtOf+3HozXO78zVI=;
        b=F4BaV/k078gUywEn1Kt9pDnKXJaHdraB0NCigBl7LVC2HzjgwcBlCnC3EArFqzS4fQ7Sjb
        P9TBANAUA3ey+kBw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A7F0BA3B8B;
        Thu, 14 Oct 2021 09:13:13 +0000 (UTC)
Date:   Thu, 14 Oct 2021 11:13:13 +0200 (CEST)
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
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
In-Reply-To: <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
Message-ID: <alpine.LSU.2.21.2110141108150.23710@pobox.suse.cz>
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com> <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index e8029ae..b8d75fb 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -49,14 +49,16 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> 
>  	ops = container_of(fops, struct klp_ops, fops);
> 
> +	/*
> +	 *

This empty line is not useful.

> +	 * The ftrace_test_recursion_trylock() will disable preemption,
> +	 * which is required for the variant of synchronize_rcu() that is
> +	 * used to allow patching functions where RCU is not watching.
> +	 * See klp_synchronize_transition() for more details.
> +	 */
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
> @@ -120,7 +122,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
> 
>  unlock:
> -	preempt_enable_notrace();
>  	ftrace_test_recursion_unlock(bit);
>  }

Acked-by: Miroslav Benes <mbenes@suse.cz>

for the livepatch part of the patch.

I would also ask you not to submit new versions so often, so that the 
other reviewers have time to actually review the patch set.

Quoting from Documentation/process/submitting-patches.rst:

"Wait for a minimum of one week before resubmitting or pinging reviewers - 
possibly longer during busy times like merge windows."

Thanks

Miroslav
