Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ECD3748B9
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 21:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhEETbr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 15:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhEETbr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 15:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17255613C9;
        Wed,  5 May 2021 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620243050;
        bh=tx58r5SqqAt8Xc8bUwSSUdj18jhapJAcIO0PT4jWmvs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W8Gd0UfkwmwQ67rQdqAcnKRkoHTlHKFWKLSCW30mWd1xWwSzIvviqYpNXh21xgNwH
         688vnT51ZRO/NVzpktdSz9oEr11uYPp6N3rkD3QIGeIuBAQc54M9tCrgBN/B1/FdJE
         iyngtfHkSz/l5vmXjvQmhPXmK4S9yGCMA2n5bxkSwkgEV5ldx8ndhGMESCUJfNr65O
         7b9yg+2f9H4rDxU8tdWoGxzRg92y+dIxDgzv1F/tTdVXr7AJHSiuW5z3MTmmoSHuUA
         lCIs+fZ2T8XHXjgKVPqEImOMyENGQDYounZlAi42sJhKltJf3qCUvJK+TyZ9f5Ghda
         1lmCLtXgvMttw==
Received: by mail-ot1-f52.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so2718051otf.12;
        Wed, 05 May 2021 12:30:50 -0700 (PDT)
X-Gm-Message-State: AOAM531/qi511Tn4rV5um09dTHhvEo61VhRjUH/SaILcZI286xAK1DG+
        gojlrthsRRlKoUNFbuRjEC2KmbiFUboPpCeXuHQ=
X-Google-Smtp-Source: ABdhPJxAhFxIfAUg3rX0hOz8QhAhIdIRdzlZytMH60JG8fawviGxyRB6uCwiDm7eYYIKW062LaoEitLuCny7PMlvTHo=
X-Received: by 2002:a9d:69c5:: with SMTP id v5mr250768oto.108.1620243049274;
 Wed, 05 May 2021 12:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210503173615.21576-1-madvenka@linux.microsoft.com> <20210503173615.21576-3-madvenka@linux.microsoft.com>
In-Reply-To: <20210503173615.21576-3-madvenka@linux.microsoft.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 5 May 2021 21:30:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGcv3+=sXUswSFvhm1K2PZj+qVSSa7XBte9NqxeBNn5dA@mail.gmail.com>
Message-ID: <CAMj1kXGcv3+=sXUswSFvhm1K2PZj+qVSSa7XBte9NqxeBNn5dA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <jthierry@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morris <jmorris@namei.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        live-patching@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 3 May 2021 at 19:38, <madvenka@linux.microsoft.com> wrote:
>
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>
> Create a sym_code_ranges[] array to cover the following text sections that
> contain functions defined as SYM_CODE_*(). These functions are low-level
> functions (and do not have a proper frame pointer prolog and epilog). So,
> they are inherently unreliable from a stack unwinding perspective.
>
>         .entry.text
>         .idmap.text
>         .hyp.idmap.text
>         .hyp.text
>         .hibernate_exit.text
>         .entry.tramp.text
>
> If a return PC falls in any of these, mark the stack trace unreliable.
>
> The only exception to this is - if the unwinder has reached the last
> frame already, it will not mark the stack trace unreliable since there
> is no more unwinding to do. E.g.,
>
>         - ret_from_fork() occurs at the end of the stack trace of
>           kernel tasks.
>
>         - el0_*() functions occur at the end of EL0 exception stack
>           traces. This covers all user task entries into the kernel.
>
> NOTE:
>         - EL1 exception handlers are in .entry.text. So, stack traces that
>           contain those functions will be marked not reliable. This covers
>           interrupts, exceptions and breakpoints encountered while executing
>           in the kernel.
>
>         - At the end of an interrupt, the kernel can preempt the current
>           task if required. So, the stack traces of all preempted tasks will
>           show the interrupt frame and will be considered unreliable.
>
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 54 ++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index c21a1bca28f3..1ff14615a55a 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -15,9 +15,48 @@
>
>  #include <asm/irq.h>
>  #include <asm/pointer_auth.h>
> +#include <asm/sections.h>
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>
> +struct code_range {
> +       unsigned long   start;
> +       unsigned long   end;
> +};
> +
> +struct code_range      sym_code_ranges[] =

This should be static and const

> +{
> +       /* non-unwindable ranges */
> +       { (unsigned long)__entry_text_start,
> +         (unsigned long)__entry_text_end },
> +       { (unsigned long)__idmap_text_start,
> +         (unsigned long)__idmap_text_end },
> +       { (unsigned long)__hyp_idmap_text_start,
> +         (unsigned long)__hyp_idmap_text_end },
> +       { (unsigned long)__hyp_text_start,
> +         (unsigned long)__hyp_text_end },
> +#ifdef CONFIG_HIBERNATION
> +       { (unsigned long)__hibernate_exit_text_start,
> +         (unsigned long)__hibernate_exit_text_end },
> +#endif
> +#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> +       { (unsigned long)__entry_tramp_text_start,
> +         (unsigned long)__entry_tramp_text_end },
> +#endif
> +       { /* sentinel */ }
> +};
> +
> +static struct code_range *lookup_range(unsigned long pc)

const struct code_range *

> +{
> +       struct code_range *range;

const struct code_range *

> +
> +       for (range = sym_code_ranges; range->start; range++) {
> +               if (pc >= range->start && pc < range->end)
> +                       return range;
> +       }
> +       return range;
> +}
> +
>  /*
>   * AArch64 PCS assigns the frame pointer to x29.
>   *
> @@ -43,6 +82,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  {
>         unsigned long fp = frame->fp;
>         struct stack_info info;
> +       struct code_range *range;

const struct code_range *

>
>         frame->reliable = true;
>
> @@ -103,6 +143,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>                 return 0;
>         }
>
> +       range = lookup_range(frame->pc);
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>         if (tsk->ret_stack &&
>                 frame->pc == (unsigned long)return_to_handler) {
> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>                         return -EINVAL;
>                 frame->pc = ret_stack->ret;
>                 frame->pc = ptrauth_strip_insn_pac(frame->pc);
> +               return 0;
>         }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>
> +       if (!range->start)
> +               return 0;
> +
> +       /*
> +        * The return PC falls in an unreliable function. If the final frame
> +        * has been reached, no more unwinding is needed. Otherwise, mark the
> +        * stack trace not reliable.
> +        */
> +       if (frame->fp)
> +               frame->reliable = false;
> +
>         return 0;
>  }
>  NOKPROBE_SYMBOL(unwind_frame);
> --
> 2.25.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
