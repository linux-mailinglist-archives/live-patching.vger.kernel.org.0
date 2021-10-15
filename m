Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6559C42E751
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 05:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhJODlV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhJODlT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:41:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 038EC610D2;
        Fri, 15 Oct 2021 03:39:09 +0000 (UTC)
Date:   Thu, 14 Oct 2021 23:39:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20211014233907.15f13f62@oasis.local.home>
In-Reply-To: <YWhJP41cNwDphYsv@alley>
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
        <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
        <YWhJP41cNwDphYsv@alley>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 14 Oct 2021 17:14:07 +0200
Petr Mladek <pmladek@suse.com> wrote:

>   /**
>    * ftrace_test_recursion_trylock - tests for recursion in same context
>    *
>    * Use this for ftrace callbacks. This will detect if the function
>    * tracing recursed in the same context (normal vs interrupt),
>    *
>    * Returns: -1 if a recursion happened.
> -  *           >= 0 if no recursion
> +  *           >= 0 if no recursion (success)
> +  *
> +  * Disables the preemption on success. It is just for a convenience.
> +  * Current users needed to disable the preemtion for some reasons.
>    */

I started replying to this explaining the difference between bit not
zero and a bit zero, and I think I found a design flaw that can allow
unwanted recursion.

It's late and I'm about to go to bed, but I may have a new patch to fix
this before this gets added, as the fix will conflict with this patch,
and the fix will likely need to go to stable.

Stay tuned.

-- Steve
