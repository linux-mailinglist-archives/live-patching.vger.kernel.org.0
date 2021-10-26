Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1443AA6B
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 04:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhJZCpC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Oct 2021 22:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234432AbhJZCpA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Oct 2021 22:45:00 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E000861074;
        Tue, 26 Oct 2021 02:42:34 +0000 (UTC)
Date:   Mon, 25 Oct 2021 22:42:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 0/2] fix & prevent the missing preemption disabling
Message-ID: <20211025224233.61b8e088@rorschach.local.home>
In-Reply-To: <71c21f78-9c44-fdb2-f8e2-d8544b3421bd@linux.alibaba.com>
References: <32a36348-69ee-6464-390c-3a8d6e9d2b53@linux.alibaba.com>
        <71c21f78-9c44-fdb2-f8e2-d8544b3421bd@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 26 Oct 2021 10:09:12 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> Just a ping, to see if there are any more comments :-P

I guess you missed what went into mainline (and your name found a bug
in my perl script for importing patches ;-)

  https://lore.kernel.org/all/20211019091344.65629198@gandalf.local.home/

Which means patch 1 needs to change:

> +	/*
> +	 * Disable preemption to fulfill the promise.
> +	 *
> +	 * Don't worry about the bit 0 cases, they indicate
> +	 * the disabling behaviour has already been done by
> +	 * internal call previously.
> +	 */
> +	preempt_disable_notrace();
> +
>  	return bit + 1;
>  }
> 
> +/*
> + * Preemption will be enabled (if it was previously enabled).
> + */
>  static __always_inline void trace_clear_recursion(int bit)
>  {
>  	if (!bit)
>  		return;
> 
> +	if (bit > 0)
> +		preempt_enable_notrace();
> +

Where this wont work anymore.

Need to preempt disable and enable always.

-- Steve


>  	barrier();
>  	bit--;
>  	trace_recursion_clear(bit);
> @@ -209,7 +227,7 @@ static __always_inline void trace_clear_recursion(int bit)
>   * tracing recursed in the same context (normal vs interrupt),
>   *
