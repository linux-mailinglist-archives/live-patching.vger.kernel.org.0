Return-Path: <live-patching+bounces-2689-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCpZJ+vY9GmfFQIAu9opvQ
	(envelope-from <live-patching+bounces-2689-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 18:46:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A10C94AE298
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 18:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2CC993002905
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 16:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8193F9F20;
	Fri,  1 May 2026 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gYXN8qKN"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2118D34E765;
	Fri,  1 May 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777653986; cv=none; b=VDE7dXBJvPoEPR3gdiWLPaO8yDTSopgN+1Y6SLYpPA1HL9lw1ME+qpbXf2sB1FfW3eSwAgV8YWB/pvXZcnYyw+v8haN/cdf8tWSH5e5rl8+xpDnvM23Z4W5BXd4vPAyyYoqMDKzOQP1mJ/LuGaC1vzCkPDoESbQYeqaees1SuYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777653986; c=relaxed/simple;
	bh=44xl6jnIZuwKgvVWnq+3f6yKLirpvy1PsM7ushYUE5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwEndNnZHfBC0C3P9FhawYCQoSxIHL4R9A29pE/jcilj4XCPF0vgJLyxXDW1qzCVOW5MM6+tEJrOaFI0AtZtxeYv4pVLL8qtR9VgnZwVW7hSdiZqRGJ+l6IUFZeb2Xy76+hFWDL/oxA7LVyhyMtNc+WhMrCvRS0YzmDZuwDZar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gYXN8qKN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DD711692;
	Fri,  1 May 2026 09:46:08 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 177EF3F7B4;
	Fri,  1 May 2026 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777653973; bh=44xl6jnIZuwKgvVWnq+3f6yKLirpvy1PsM7ushYUE5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gYXN8qKNFfZg5PODtFardrI/KK5Lqv1U7pyfDlnSin5EnX8jmb9mfbbsLCU5IdwmV
	 BjojzqgC5O13WSn1amRJCPNJ6geoKZHtAlyIk51mcqQC7EMFz4hBpVY2j0TC0VKWIi
	 xkiutDcOP2K8NDfc8Gdo82I/t9LsMstaZp95/VDM=
Date: Fri, 1 May 2026 17:46:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
Message-ID: <afTYzAF_x41pyilu@J2N7QTR9R3>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428183643.3796063-9-dylanbhatch@google.com>
X-Rspamd-Queue-Id: A10C94AE298
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2689-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Hi Dylan,

Thanks for putting this together. I think this is looking pretty good.
However, there are some things that aren't quite right and need some
work, which I've commented on below.

More generally, there are a few things that aren't addressed by this
series that we will also need to address. Importantly:

(1) For correctness, we'll need to address a latent issue with unwinding
    across an fgraph return trampoline, where the return address is
    transiently unrecoverable.

    Before this series, that doesn't matter for livepatching because the
    livepatching code isn't called synchronously within the fgraph
    handler, and unwinds which cross an exception boundary are marked as
    unreliable.

    After this series, that does matter as we can unwind across an
    exception boundary, and might happen to interrupt that transient
    window.

    I think we can solve that with some restructuring of that code,
    restoring the original address *before* removing that from the
    fgraph return stack, and ensuring that the unwinder can find it.

    I'm not immediately sure whether kretprobes has a similar issue.

(2) To make unwinding generally possible, we'll need to annotate some
    assembly functions as unwindable. We'll need to do that for string
    routines under lib/, and probably some crypto code, but we don't
    need to do that for most code in head.S, entry.S, etc.

    The vast majority of relevant assembly functions are leaf functions
    (where the return address is never moved out of the LR), so we can
    probably get away with a simple annotation for those that avoids the
    need for open-coded CFI directives everywhere.

I've pushed some reliable stacktrace tests to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git stacktrace/tests

That finds the fgraph issue (regardless of this series). When merged
with this series triggers a warning in kunwind_next_frame_record_meta(),
where unwind_next_frame_sframe() calls that erroneously as a fallback.

As noted below, I think that fallback path should be removed, and
unwind_next_frame_sframe() should return an error in that case.

On Tue, Apr 28, 2026 at 06:36:43PM +0000, Dylan Hatch wrote:
> Add unwind_next_frame_sframe() function to unwind by sframe info if
> present. Use this method at exception boundaries, falling back to
> frame-pointer unwind only on failure. In such failure cases, the
> stacktrace is considered unreliable.
>
> During normal unwind, prefer frame pointer unwind (for better
> performance) with sframe as a backup.

We should certainly use SFrame at an exception boundary. However, when
frame point unwind fails I do not think we should use it as a backup.
That only fails when something is already wrong, and an SFrame unwind
isn't necessarily going to be better. I think we should immediately fail
in those cases.

> This change restores the LR behavior originally introduced in commit
> c2c6b27b5aa14fa2 ("arm64: stacktrace: unwind exception boundaries"),
> But later removed in commit 32ed1205682e ("arm64: stacktrace: Skip
> reporting LR at exception boundaries")
> 
> This can be done because the sframe data can be used to determine
> whether the LR is current for the PC value recovered from pt_regs at the
> exception boundary.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> Reviewed-by: Jens Remus <jremus@linux.ibm.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> ---
>  arch/arm64/include/asm/stacktrace/common.h |   6 +
>  arch/arm64/kernel/stacktrace.c             | 246 +++++++++++++++++++--
>  2 files changed, 232 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 821a8fdd31af..4df68181e1b5 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -21,6 +21,8 @@ struct stack_info {
>   *
>   * @fp:          The fp value in the frame record (or the real fp)
>   * @pc:          The lr value in the frame record (or the real lr)
> + * @sp:          The sp value at the call site of the current function.
> + * @unreliable:  Stacktrace is unreliable.
>   *
>   * @stack:       The stack currently being unwound.
>   * @stacks:      An array of stacks which can be unwound.
> @@ -29,7 +31,11 @@ struct stack_info {
>  struct unwind_state {
>  	unsigned long fp;
>  	unsigned long pc;
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +	unsigned long sp;
> +#endif

As this is only used by the kernel unwinder (and not the hyp unwinder),
this should live in struct kunwind_state in stacktrace.c.

That said, for unwinding across exception boundaries we should not need
this, as the SP value will be in the pt_regs. If we only use SFrame for
the exception boundary case, we can remove this entirely. I would
strongly prefer that we do that.

> +	bool unreliable;

Likewise, this should live in struct kunwind_state.

>  	struct stack_info stack;
>  	struct stack_info *stacks;
>  	int nr_stacks;
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 3ebcf8c53fb0..c935323f393b 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -14,6 +14,7 @@
>  #include <linux/sched/debug.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/stacktrace.h>
> +#include <linux/sframe.h>

Nit: these are supposed to be ordered alphabetically, so the include of
<linux/sframe.h> should be just before <linux/stacktrace.h>.

>  
>  #include <asm/efi.h>
>  #include <asm/irq.h>
> @@ -26,6 +27,7 @@ enum kunwind_source {
>  	KUNWIND_SOURCE_CALLER,
>  	KUNWIND_SOURCE_TASK,
>  	KUNWIND_SOURCE_REGS_PC,
> +	KUNWIND_SOURCE_REGS_LR,
>  };
>  
>  union unwind_flags {
> @@ -85,6 +87,9 @@ kunwind_init_from_regs(struct kunwind_state *state,
>  	state->regs = regs;
>  	state->common.fp = regs->regs[29];
>  	state->common.pc = regs->pc;
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +	state->common.sp = regs->sp;
> +#endif

As above, I don't think we need to stash the SP, as it only matters when
performing the next unwind from the KUNWIND_SOURCE_REGS_PC state, and in
that state we have the regs.

>  	state->source = KUNWIND_SOURCE_REGS_PC;
>  }
>  
> @@ -103,6 +108,9 @@ kunwind_init_from_caller(struct kunwind_state *state)
>  
>  	state->common.fp = (unsigned long)__builtin_frame_address(1);
>  	state->common.pc = (unsigned long)__builtin_return_address(0);
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +	state->common.sp = (unsigned long)__builtin_frame_address(0);
> +#endif
>  	state->source = KUNWIND_SOURCE_CALLER;
>  }

This is not correct. On arm64, __builtin_frame_address(0) returns the
address of the current function's frame record. That's not the same as
the SP of the caller (which would necessarily differ by at least the
size of that frame record).

For example, the following:

	void *return_own_frame(void)
	{
		return __builtin_frame_address(0);
	}

... is compiled by GCC 15.2.0 as:

	0000000000000000 <return_own_frame>:
	   0:   d503233f        paciasp
	   4:   a9bf7bfd        stp     x29, x30, [sp, #-16]!
	   8:   910003fd        mov     x29, sp
	   c:   aa1d03e0        mov     x0, x29
	  10:   a8c17bfd        ldp     x29, x30, [sp], #16
	  14:   d50323bf        autiasp
	  18:   d65f03c0        ret
	  1c:   d503201f        nop

As above, I think we can remove unwind_state:sp entirely, and omit this.

> @@ -124,6 +132,9 @@ kunwind_init_from_task(struct kunwind_state *state,
>  
>  	state->common.fp = thread_saved_fp(task);
>  	state->common.pc = thread_saved_pc(task);
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +	state->common.sp = thread_saved_sp(task);
> +#endif
>  	state->source = KUNWIND_SOURCE_TASK;
>  }

As above, I think we can remove unwind_state:sp entirely, and omit this.

In contrast to kunwind_init_from_caller() above, given the way the
cpu_switch_to() assembly function saves the FP/PC/SP, those should all
be consistent with the values in the caller immediately after the caller
is returned to.

> @@ -181,7 +192,6 @@ int kunwind_next_regs_pc(struct kunwind_state *state)
>  	state->regs = regs;
>  	state->common.pc = regs->pc;
>  	state->common.fp = regs->regs[29];
> -	state->regs = NULL;
>  	state->source = KUNWIND_SOURCE_REGS_PC;
>  	return 0;
>  }
> @@ -237,6 +247,9 @@ kunwind_next_frame_record(struct kunwind_state *state)
>  
>  	unwind_consume_stack(&state->common, info, fp, sizeof(*record));
>  
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +	state->common.sp = state->common.fp;
> +#endif

This is not correct. The caller's frame record can be anywhere in the
caller's stack frame, and we definitely have cases today where FP != SP
at a function call boundary.

For example, the add_random_kstack_offset() logic in invoke_syscall()
typically results in the SP being decremented after the frame record has
been placed on the stack.

That looks roughly like the following:

	void callee(void *ptr);

	void caller(size_t size)
	{
		void *ptr = __builtin_alloca(size);
		callee(ptr);
	}

... which GCC 15.2.0 can compile as:

	0000000000000000 <caller>:
	   0:   d503233f        paciasp
	   4:   91003c00        add     x0, x0, #0xf
	   8:   a9bf7bfd        stp     x29, x30, [sp, #-16]!
	   c:   927cec00        and     x0, x0, #0xfffffffffffffff0
	  10:   910003fd        mov     x29, sp
	  14:   cb2063ff        sub     sp, sp, x0
	  18:   910003e0        mov     x0, sp
	  1c:   94000000        bl      0 <callee>
	  20:   910003bf        mov     sp, x29
	  24:   a8c17bfd        ldp     x29, x30, [sp], #16
	  28:   d50323bf        autiasp
	  2c:   d65f03c0        ret

As above, I think we can remove unwind_state:sp entirely, and omit this.

>  	state->common.fp = new_fp;
>  	state->common.pc = new_pc;
>  	state->source = KUNWIND_SOURCE_FRAME;
> @@ -244,6 +257,176 @@ kunwind_next_frame_record(struct kunwind_state *state)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +
> +static __always_inline struct stack_info *
> +get_word(struct unwind_state *state, unsigned long *word)
> +{
> +	unsigned long addr = *word;
> +	struct stack_info *info;
> +
> +	info = unwind_find_stack(state, addr, sizeof(addr));
> +	if (!info)
> +		return info;
> +
> +	*word = READ_ONCE(*(unsigned long *)addr);
> +
> +	return info;
> +}
> +
> +static __always_inline int
> +get_consume_word(struct unwind_state *state, unsigned long *word)
> +{
> +	struct stack_info *info;
> +	unsigned long addr = *word;
> +
> +	info = get_word(state, word);
> +	if (!info)
> +		return -EINVAL;
> +
> +	unwind_consume_stack(state, info, addr, sizeof(addr));
> +	return 0;
> +}

I was hoping that we wouldn't need these if we only used SFrame to
determine whether to use the LR or frame record, but I see that there
could be cases where the frame record might be partially constructed.

> +
> +/*
> + * Unwind to the next frame according to sframe.
> + */
> +static __always_inline int
> +unwind_next_frame_sframe(struct kunwind_state *state)
> +{
> +	struct unwind_frame frame;
> +	unsigned long cfa, fp, ra;
> +	enum kunwind_source source = KUNWIND_SOURCE_FRAME;
> +	struct pt_regs *regs = state->regs;
> +
> +	int err;

As above, we should only use this for unwinding from the regs, after a
KUNWIND_SOURCE_REGS_PC step.

With that in mind, it would be good to:

(1) Rename this to something like kunwind_next_regs_sframe(). Note
    'kunwind' rather than 'unwind' for consistency with the rest of this
    file.

(2) Add the following sanity checks:

	if (WARN_ON_ONCE(state->source != KUNWIND_SOURCE_REGS_PC))
		return -EINVAL;
	if (WARN_ON_ONCE(!state->regs))
		return -EINVAL;

    ... which will also allow the code below to be simplified.

> +
> +	/* FP/SP alignment 8 bytes */
> +	if (state->common.fp & 0x7 || state->common.sp & 0x7)
> +		return -EINVAL;
> +
> +	/*
> +	 * Most/all outermost functions are not visible to sframe. So, check for
> +	 * a meta frame record if the sframe lookup fails.
> +	 */
> +	err = sframe_find_kernel(state->common.pc, &frame);
> +	if (err)
> +		return kunwind_next_frame_record_meta(state);
> +
> +	if (frame.outermost)
> +		return -ENOENT;

I don't think we ever expect an outermost frame within the kernel. We
haven't added any annotations for that, and we expect to unwind all the
way to a FRAME_META_TYPE_FINAL frame.

We cannot fall back to kunwind_next_frame_record_meta() here. We don't
know that the next frame is a meta frame (and this results in a warning
noted above), and we don't know the result is going to be reliable if we
don't have SFrame data, so the right thing to do is return an error.

I think this should be:

	/*
	 * A kernel unwind should always end at a FRAME_META_TYPE_FINAL
	 * frame. There should be no outermost frames within the kernel.
	 */
	if (frame.outermost)
		return -EINVAL;

	err = sframe_find_kernel(state->common.pc, &frame);
	if (err)
		return -EINVAL;

> +	/* Get the Canonical Frame Address (CFA) */
> +	switch (frame.cfa.rule) {
> +	case UNWIND_CFA_RULE_SP_OFFSET:
> +		cfa = state->common.sp;
> +		break;
> +	case UNWIND_CFA_RULE_FP_OFFSET:
> +		if (state->common.fp < state->common.sp)
> +			return -EINVAL;
> +		cfa = state->common.fp;
> +		break;
> +	case UNWIND_CFA_RULE_REG_OFFSET:
> +	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
> +		/* regs only available in topmost/interrupt frame */
> +		if (!regs || frame.cfa.regnum > 30)
> +			return -EINVAL;
> +		cfa = regs->regs[frame.cfa.regnum];
> +		break;

Do we ever expect to see UNWIND_CFA_RULE_REG_OFFSET or
UNWIND_CFA_RULE_REG_OFFSET_DEREF in practice for kernel code?

> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +	cfa += frame.cfa.offset;
> +
> +	/*
> +	 * CFA typically points to a higher address than RA or FP, so don't
> +	 * consume from the stack when we read it.
> +	 */
> +	if (frame.cfa.rule & UNWIND_RULE_DEREF &&
> +	    !get_word(&state->common, &cfa))
> +		return -EINVAL;

Per the switch above, this could only be
UNWIND_CFA_RULE_REG_OFFSET_DEREF. As above, do we ever expect to
encounter that in practice for kernel code?

> +
> +	/* CFA alignment 8 bytes */
> +	if (cfa & 0x7)
> +		return -EINVAL;

If the CFA is the SP upon entry to the function, then per AAPCS64 rules
it should be aligned to 16 bytes. Otherwise, where has this 8 byte
alignment requirement come from? Does SFrame mandate that?

> +
> +	/* Get the Return Address (RA) */
> +	switch (frame.ra.rule) {
> +	case UNWIND_RULE_RETAIN:
> +		/* regs only available in topmost/interrupt frame */
> +		if (!regs)
> +			return -EINVAL;
> +		ra = regs->regs[30];
> +		source = KUNWIND_SOURCE_REGS_LR;
> +		break;
> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */

It would be better for the comment to say *why* that's not implemented.

I assume that's because UNWIND_USER_RULE_CFA_OFFSET would mean that the return
address is a stack address, and that's obviously not legitimate.

> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
> +		ra = cfa + frame.ra.offset;
> +		break;
> +	case UNWIND_RULE_REG_OFFSET:
> +	case UNWIND_RULE_REG_OFFSET_DEREF:
> +		/* regs only available in topmost/interrupt frame */
> +		if (!regs)
> +			return -EINVAL;
> +		ra = regs->regs[frame.cfa.regnum];
> +		ra += frame.ra.offset;
> +		break;

Do we ever expect UNWIND_RULE_REG_OFFSET or UNWIND_RULE_REG_OFFSET_DEREF
in practice for kernel code?

I don't think we expect UNWIND_RULE_REG_OFFSET unless that's sometimes used
instead of UNWIND_RULE_RETAIN to express that the return address is in x30
(with zero offset).

Similarly, if the address is on the stack it should be in a frame
record. Would we ever expect UNWIND_RULE_REG_OFFSET_DEREF rather than
UNWIND_RULE_CFA_OFFSET_DEREF?

> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	/* Get the Frame Pointer (FP) */
> +	switch (frame.fp.rule) {
> +	case UNWIND_RULE_RETAIN:
> +		fp = state->common.fp;
> +		break;
> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */

As for RA, the comment should explain why that's not implemented.

> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
> +		fp = cfa + frame.fp.offset;
> +		break;
> +	case UNWIND_RULE_REG_OFFSET:
> +	case UNWIND_RULE_REG_OFFSET_DEREF:
> +		/* regs only available in topmost/interrupt frame */
> +		if (!regs)
> +			return -EINVAL;
> +		fp = regs->regs[frame.fp.regnum];
> +		fp += frame.fp.offset;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Consume RA and FP from the stack. The frame record puts FP at a lower
> +	 * address than RA, so we always read FP first.
> +	 */
> +	if (frame.fp.rule & UNWIND_RULE_DEREF &&
> +	    !get_word(&state->common, &fp))
> +		return -EINVAL;

Why is this get_word() rather than get_consume_word()?

> +
> +	if (frame.ra.rule & UNWIND_RULE_DEREF &&
> +	    get_consume_word(&state->common, &ra))
> +		return -EINVAL;
> +
> +	state->common.pc = ra;
> +	state->common.sp = cfa;

As above, the SP can be removed.

> +	state->common.fp = fp;
> +
> +	state->source = source;
> +
> +	return 0;
> +}
> +
> +#else /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
> +
> +static __always_inline int
> +unwind_next_frame_sframe(struct kunwind_state *state) { return -EINVAL; }
> +
> +#endif /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME*/
> +
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
>   *
> @@ -259,12 +442,25 @@ kunwind_next(struct kunwind_state *state)
>  	state->flags.all = 0;
>  
>  	switch (state->source) {
> +	case KUNWIND_SOURCE_REGS_PC:
> +		err = unwind_next_frame_sframe(state);
> +
> +		if (err && err != -ENOENT) {
> +			/* Fallback to FP based unwinder */
> +			err = kunwind_next_frame_record(state);
> +			state->common.unreliable = true;
> +		}
> +		state->regs = NULL;
> +		break;

This makes sense to me.

>  	case KUNWIND_SOURCE_FRAME:
>  	case KUNWIND_SOURCE_CALLER:
>  	case KUNWIND_SOURCE_TASK:
> -	case KUNWIND_SOURCE_REGS_PC:
> +	case KUNWIND_SOURCE_REGS_LR:
>  		err = kunwind_next_frame_record(state);
> +		if (err && err != -ENOENT)
> +			err = unwind_next_frame_sframe(state);

This isn't sound as we cannot track the SP reliably across all
transitions.

If a regular frame pointer unwind has failed, something is already
wrong, and we should give up immediately.

Please remove the fallback to sframe here.

>  		break;
> +
>  	default:

No need for this whitespace change.

>  		err = -EINVAL;
>  	}
> @@ -350,6 +546,9 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
>  		.common = {
>  			.stacks = stacks,
>  			.nr_stacks = ARRAY_SIZE(stacks),
> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> +			.sp = 0,
> +#endif

As above, this can go.

Thanks,
Mark.

>  		},
>  	};
>  
> @@ -390,34 +589,40 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
>  }
>  
> +struct kunwind_reliable_consume_entry_data {
> +	stack_trace_consume_fn consume_entry;
> +	void *cookie;
> +	bool unreliable;
> +};
> +
>  static __always_inline bool
> -arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
> +arch_kunwind_reliable_consume_entry(const struct kunwind_state *state, void *cookie)
>  {
> -	/*
> -	 * At an exception boundary we can reliably consume the saved PC. We do
> -	 * not know whether the LR was live when the exception was taken, and
> -	 * so we cannot perform the next unwind step reliably.
> -	 *
> -	 * All that matters is whether the *entire* unwind is reliable, so give
> -	 * up as soon as we hit an exception boundary.
> -	 */
> -	if (state->source == KUNWIND_SOURCE_REGS_PC)
> -		return false;
> +	struct kunwind_reliable_consume_entry_data *data = cookie;
>  
> -	return arch_kunwind_consume_entry(state, cookie);
> +	if (state->common.unreliable) {
> +		data->unreliable = true;
> +		return false;
> +	}
> +	return data->consume_entry(data->cookie, state->common.pc);
>  }
>  
> -noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
> -					      void *cookie,
> -					      struct task_struct *task)
> +noinline notrace int arch_stack_walk_reliable(
> +				stack_trace_consume_fn consume_entry,
> +				void *cookie, struct task_struct *task)
>  {
> -	struct kunwind_consume_entry_data data = {
> +	struct kunwind_reliable_consume_entry_data data = {
>  		.consume_entry = consume_entry,
>  		.cookie = cookie,
> +		.unreliable = false,
>  	};
>  
> -	return kunwind_stack_walk(arch_reliable_kunwind_consume_entry, &data,
> -				  task, NULL);
> +	kunwind_stack_walk(arch_kunwind_reliable_consume_entry, &data, task, NULL);
> +
> +	if (data.unreliable)
> +		return -EINVAL;
> +
> +	return 0;
>  }
>  
>  struct bpf_unwind_consume_entry_data {
> @@ -452,6 +657,7 @@ static const char *state_source_string(const struct kunwind_state *state)
>  	case KUNWIND_SOURCE_CALLER:	return "C";
>  	case KUNWIND_SOURCE_TASK:	return "T";
>  	case KUNWIND_SOURCE_REGS_PC:	return "P";
> +	case KUNWIND_SOURCE_REGS_LR:	return "L";
>  	default:			return "U";
>  	}
>  }
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

