Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4E3748FC
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhEEUBm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 16:01:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58604 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbhEEUBm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 16:01:42 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 43EDC20B7178;
        Wed,  5 May 2021 13:00:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 43EDC20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620244845;
        bh=HoV+Um7+hcWNbd/WJuTfI1F9jTke9AWWlUfuICCcErA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a9eiNUi6jG83XohDfCYfJ6dPGDZmPch684ePZGKdZsclGMOCCjXIjdqTwO0ViJhmH
         tg5mCb5PCM2qyzLG62yJp1ibVa45nReYWS+PLuYBo7NhQSJ1N5ug76QK1nycnPfpEU
         ZxdZw5inxM2KfSzTjhy5rWk/7KIWBS4goPEyEPyI=
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
To:     Ard Biesheuvel <ardb@kernel.org>
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
References: <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <CAMj1kXGcv3+=sXUswSFvhm1K2PZj+qVSSa7XBte9NqxeBNn5dA@mail.gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <587e0d68-48fd-6920-d803-2346ec00517b@linux.microsoft.com>
Date:   Wed, 5 May 2021 15:00:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGcv3+=sXUswSFvhm1K2PZj+qVSSa7XBte9NqxeBNn5dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

OK. I will make all the changes you suggested.

Thanks!

Madhavan

On 5/5/21 2:30 PM, Ard Biesheuvel wrote:
> On Mon, 3 May 2021 at 19:38, <madvenka@linux.microsoft.com> wrote:
>>
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Create a sym_code_ranges[] array to cover the following text sections that
>> contain functions defined as SYM_CODE_*(). These functions are low-level
>> functions (and do not have a proper frame pointer prolog and epilog). So,
>> they are inherently unreliable from a stack unwinding perspective.
>>
>>         .entry.text
>>         .idmap.text
>>         .hyp.idmap.text
>>         .hyp.text
>>         .hibernate_exit.text
>>         .entry.tramp.text
>>
>> If a return PC falls in any of these, mark the stack trace unreliable.
>>
>> The only exception to this is - if the unwinder has reached the last
>> frame already, it will not mark the stack trace unreliable since there
>> is no more unwinding to do. E.g.,
>>
>>         - ret_from_fork() occurs at the end of the stack trace of
>>           kernel tasks.
>>
>>         - el0_*() functions occur at the end of EL0 exception stack
>>           traces. This covers all user task entries into the kernel.
>>
>> NOTE:
>>         - EL1 exception handlers are in .entry.text. So, stack traces that
>>           contain those functions will be marked not reliable. This covers
>>           interrupts, exceptions and breakpoints encountered while executing
>>           in the kernel.
>>
>>         - At the end of an interrupt, the kernel can preempt the current
>>           task if required. So, the stack traces of all preempted tasks will
>>           show the interrupt frame and will be considered unreliable.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/stacktrace.c | 54 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 54 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index c21a1bca28f3..1ff14615a55a 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -15,9 +15,48 @@
>>
>>  #include <asm/irq.h>
>>  #include <asm/pointer_auth.h>
>> +#include <asm/sections.h>
>>  #include <asm/stack_pointer.h>
>>  #include <asm/stacktrace.h>
>>
>> +struct code_range {
>> +       unsigned long   start;
>> +       unsigned long   end;
>> +};
>> +
>> +struct code_range      sym_code_ranges[] =
> 
> This should be static and const
> 
>> +{
>> +       /* non-unwindable ranges */
>> +       { (unsigned long)__entry_text_start,
>> +         (unsigned long)__entry_text_end },
>> +       { (unsigned long)__idmap_text_start,
>> +         (unsigned long)__idmap_text_end },
>> +       { (unsigned long)__hyp_idmap_text_start,
>> +         (unsigned long)__hyp_idmap_text_end },
>> +       { (unsigned long)__hyp_text_start,
>> +         (unsigned long)__hyp_text_end },
>> +#ifdef CONFIG_HIBERNATION
>> +       { (unsigned long)__hibernate_exit_text_start,
>> +         (unsigned long)__hibernate_exit_text_end },
>> +#endif
>> +#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
>> +       { (unsigned long)__entry_tramp_text_start,
>> +         (unsigned long)__entry_tramp_text_end },
>> +#endif
>> +       { /* sentinel */ }
>> +};
>> +
>> +static struct code_range *lookup_range(unsigned long pc)
> 
> const struct code_range *
> 
>> +{
>> +       struct code_range *range;
> 
> const struct code_range *
> 
>> +
>> +       for (range = sym_code_ranges; range->start; range++) {
>> +               if (pc >= range->start && pc < range->end)
>> +                       return range;
>> +       }
>> +       return range;
>> +}
>> +
>>  /*
>>   * AArch64 PCS assigns the frame pointer to x29.
>>   *
>> @@ -43,6 +82,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  {
>>         unsigned long fp = frame->fp;
>>         struct stack_info info;
>> +       struct code_range *range;
> 
> const struct code_range *
> 
>>
>>         frame->reliable = true;
>>
>> @@ -103,6 +143,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>                 return 0;
>>         }
>>
>> +       range = lookup_range(frame->pc);
>> +
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>         if (tsk->ret_stack &&
>>                 frame->pc == (unsigned long)return_to_handler) {
>> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>                         return -EINVAL;
>>                 frame->pc = ret_stack->ret;
>>                 frame->pc = ptrauth_strip_insn_pac(frame->pc);
>> +               return 0;
>>         }
>>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>>
>> +       if (!range->start)
>> +               return 0;
>> +
>> +       /*
>> +        * The return PC falls in an unreliable function. If the final frame
>> +        * has been reached, no more unwinding is needed. Otherwise, mark the
>> +        * stack trace not reliable.
>> +        */
>> +       if (frame->fp)
>> +               frame->reliable = false;
>> +
>>         return 0;
>>  }
>>  NOKPROBE_SYMBOL(unwind_frame);
>> --
>> 2.25.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
