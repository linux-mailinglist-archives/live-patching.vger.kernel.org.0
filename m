Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931FD43AF2A
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhJZJhp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 05:37:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52672 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhJZJhm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 05:37:42 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CD07021957;
        Tue, 26 Oct 2021 09:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635240917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0B4KOzLh0SzQ324Nbkzza+/yS3xupOET/Cg+lBufZUI=;
        b=rw+fG9VAu+8kRC9wTlBf3rcyz3Kf3ZCAjBJINdd8QZW/j3p+2ahcfvCnSj8OuOuJqkx02V
        GTi8IJ3HcUBXayzm3HUW+kf8zSfRse0QcnIbB2v1NyPMTBdz9wPJ0PnGR36r6X7vSW0okN
        kRpnoYVmTXHa91qm+5pJr77RUdNgugk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635240917;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0B4KOzLh0SzQ324Nbkzza+/yS3xupOET/Cg+lBufZUI=;
        b=qgOIyawzyHE9pTOjD50nMXsKDtve0Cel3ya97cAgrn/VbL62UicJFGeCHbZLrb2CyTyimO
        0vfvl2IWd2suabBg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 06EF6A3B83;
        Tue, 26 Oct 2021 09:35:16 +0000 (UTC)
Date:   Tue, 26 Oct 2021 11:35:16 +0200 (CEST)
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v5 1/2] ftrace: disable preemption when recursion
 locked
In-Reply-To: <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
Message-ID: <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
References: <3ca92dc9-ea04-ddc2-71cd-524bfa5a5721@linux.alibaba.com> <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index abe1a50..2bc1522 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -135,6 +135,9 @@ static __always_inline int trace_get_context_bit(void)
>  # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
>  #endif
> 
> +/*
> + * Preemption is promised to be disabled when return bit > 0.
> + */
>  static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsigned long pip,
>  							int start)
>  {
> @@ -162,11 +165,17 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
>  	current->trace_recursion = val;
>  	barrier();
> 
> +	preempt_disable_notrace();
> +
>  	return bit;
>  }
> 
> +/*
> + * Preemption will be enabled (if it was previously enabled).
> + */
>  static __always_inline void trace_clear_recursion(int bit)
>  {
> +	preempt_enable_notrace();
>  	barrier();
>  	trace_recursion_clear(bit);
>  }

The two comments should be updated too since Steven removed the "bit == 0" 
trick.

> @@ -178,7 +187,7 @@ static __always_inline void trace_clear_recursion(int bit)
>   * tracing recursed in the same context (normal vs interrupt),
>   *
>   * Returns: -1 if a recursion happened.
> - *           >= 0 if no recursion
> + *           > 0 if no recursion.
>   */
>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>  							 unsigned long parent_ip)

And this change would not be correct now.

Regards
Miroslav
