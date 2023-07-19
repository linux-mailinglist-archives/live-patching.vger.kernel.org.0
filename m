Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD21975996B
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 17:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjGSPVU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 11:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjGSPVS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 11:21:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50459E;
        Wed, 19 Jul 2023 08:21:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 93AA41FFA4;
        Wed, 19 Jul 2023 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689780075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dWtRlExKoqUIgcX6NxNlXAD281gSIaupKc5Oxdi/n08=;
        b=kNL1Fsh6OgjpwbG0rHcs0IAURm5dp4GYEb687ynGZMjs5Mn5o6EW4ltZtlEQJEu+sV+XM9
        gbPei/0Vi5ZWesUkBvZEd+qgNQRC3JlDJGCDkuJP5xxn/mijgZjTD6x4NDPCr5n/KhbreT
        2s+ZnwZe8kDdNikK0m4jfGIrsbwas+s=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D29FB2C142;
        Wed, 19 Jul 2023 15:21:14 +0000 (UTC)
Date:   Wed, 19 Jul 2023 17:21:11 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Brian Gerst <brgerst@gmail.com>, jpoimboe@kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        alyssa.milburn@linux.intel.com, keescook@chromium.org,
        joao@overdrivepizza.com, tim.c.chen@linux.intel.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86: Rewrite ret_from_fork() in C
Message-ID: <ZLf_Z5dCSm7zKDel@alley>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623225529.34590-3-brgerst@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-06-23 18:55:29, Brian Gerst wrote:
> When kCFI is enabled, special handling is needed for the indirect call
> to the kernel thread function.  Rewrite the ret_from_fork() function in
> C so that the compiler can properly handle the indirect call.

This patch broke livepatching. Kthreads never have a reliable stack.
It works when I revert it.

See also below.

> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -284,36 +284,19 @@ SYM_FUNC_END(__switch_to_asm)
>   * r12: kernel thread arg
>   */
>  .pushsection .text, "ax"
> -	__FUNC_ALIGN
> -SYM_CODE_START_NOALIGN(ret_from_fork)
> -	UNWIND_HINT_END_OF_STACK
> +SYM_CODE_START(ret_from_fork_asm)
> +	UNWIND_HINT_REGS
>  	ANNOTATE_NOENDBR // copy_thread
>  	CALL_DEPTH_ACCOUNT
> -	movq	%rax, %rdi
> -	call	schedule_tail			/* rdi: 'prev' task parameter */
>  
> -	testq	%rbx, %rbx			/* from kernel_thread? */
> -	jnz	1f				/* kernel threads are uncommon */
> +	movq	%rax, %rdi		/* prev */
> +	movq	%rsp, %rsi		/* regs */
> +	movq	%rbx, %rdx		/* fn */
> +	movq	%r12, %rcx		/* fn_arg */
> +	call	ret_from_fork
>  
> -2:
> -	UNWIND_HINT_REGS
> -	movq	%rsp, %rdi
> -	call	syscall_exit_to_user_mode	/* returns with IRQs disabled */
>  	jmp	swapgs_restore_regs_and_return_to_usermode
> -
> -1:
> -	/* kernel thread */
> -	UNWIND_HINT_END_OF_STACK

I think that it might be related to removal of this line.
The following intructions are going to call fn(fn_arg).
See below.

> -	movq	%r12, %rdi
> -	CALL_NOSPEC rbx
> -	/*
> -	 * A kernel thread is allowed to return here after successfully
> -	 * calling kernel_execve().  Exit to userspace to complete the execve()
> -	 * syscall.
> -	 */
> -	movq	$0, RAX(%rsp)
> -	jmp	2b
> -SYM_CODE_END(ret_from_fork)
> +SYM_CODE_END(ret_from_fork_asm)
>  .popsection
>  
>  .macro DEBUG_ENTRY_ASSERT_IRQS_OFF
> diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
> index 5c91305d09d2..f42dbf17f52b 100644
> --- a/arch/x86/include/asm/switch_to.h
> +++ b/arch/x86/include/asm/switch_to.h
> @@ -12,7 +12,9 @@ struct task_struct *__switch_to_asm(struct task_struct *prev,
>  __visible struct task_struct *__switch_to(struct task_struct *prev,
>  					  struct task_struct *next);
>  
> -asmlinkage void ret_from_fork(void);
> +asmlinkage void ret_from_fork_asm(void);
> +__visible void ret_from_fork(struct task_struct *prev, struct pt_regs *regs,
> +			     int (*fn)(void *), void *fn_arg);
>  
>  /*
>   * This is the structure pointed to by thread.sp for an inactive task.  The
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index cc7a642f8c9d..001e6dad9a48 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -136,6 +137,25 @@ static int set_new_tls(struct task_struct *p, unsigned long tls)
>  		return do_set_thread_area_64(p, ARCH_SET_FS, tls);
>  }
>  
> +__visible noinstr void ret_from_fork(struct task_struct *prev, struct pt_regs *regs,
> +				     int (*fn)(void *), void *fn_arg)
> +{
> +	schedule_tail(prev);
> +
> +	/* Is this a kernel thread? */
> +	if (unlikely(fn)) {
> +		fn(fn_arg);

This is the related code but it does not include the annotation
about the end of the stack.

Honestly, I am not familiar with the stack unwinder and how this is
supposed to work.

I hope that Josh or anyone else might know better.

> +		/*
> +		 * A kernel thread is allowed to return here after successfully
> +		 * calling kernel_execve().  Exit to userspace to complete the
> +		 * execve() syscall.
> +		 */
> +		regs->ax = 0;
> +	}
> +
> +	syscall_exit_to_user_mode(regs);
> +}
> +
>  int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
>  {
>  	unsigned long clone_flags = args->flags;

Best Regards,
Petr
