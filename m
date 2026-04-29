Return-Path: <live-patching+bounces-2607-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BXVJksj8mmOoQEAu9opvQ
	(envelope-from <live-patching+bounces-2607-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 17:27:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F45496D92
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 17:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5C6B3033D08
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 15:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B36437F743;
	Wed, 29 Apr 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DVR5A69Y"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7740037E31D;
	Wed, 29 Apr 2026 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476386; cv=none; b=cyBgnsaUegs84/3XpbYz9oqPP4AP9mLtd3hM4BKYjsMw9m5HBszt+Z+9xpQCLJL/qQ9vZ+oPltsT4Hr8fZRabLzps4BD2wm5OKkssJl7f0xn5XUpXJWzB40NkYd6grTTsW1cisi+qvHwxdh/YORQ8XSjAfqgrGpFd2oZH4bm1V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476386; c=relaxed/simple;
	bh=ToHBbsGGf1LD2+ZDgJuZjsnXK7XLE8KJHIPpOy6olpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTKfeCRM9TegadMf6zpEwFmXQza4pj6bbfflJCnUcCQnXA0+xMfwCfXRW3qSwDPHj/CBZDptuT1lgkK1+kaJEozdHmKt8LPxW1Yhxv0rISBx4FGRX2jZK0S3rvNQm3NNIrdpop2nF1XSY5EiG95diwS5nSAKuHwF/JbT6feaE88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DVR5A69Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B75ED1655;
	Wed, 29 Apr 2026 08:26:15 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B3003F763;
	Wed, 29 Apr 2026 08:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777476381; bh=ToHBbsGGf1LD2+ZDgJuZjsnXK7XLE8KJHIPpOy6olpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVR5A69YL3Q+LStcdhQecow5PpoUUUb3PLHRQdvqty0reh/1ncGgWmmiKXTgSK9At
	 XIdCnhZ+gv3B2UuYEsOdIL7aGkJe8GNfPRLmDsFxcY58+0G23kboLqTRD4D64V94BA
	 62YpRlDnNvetzvGDJ3vs9upWOmCgsx1CCaeQVYAw=
Date: Wed, 29 Apr 2026 16:26:12 +0100
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
Subject: Re: [PATCH v5 3/8] arm64: entry: add unwind info for various kernel
 entries
Message-ID: <afIjFLbUrdxWA6eR@J2N7QTR9R3.cambridge.arm.com>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-4-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428183643.3796063-4-dylanbhatch@google.com>
X-Rspamd-Queue-Id: 24F45496D92
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	TAGGED_FROM(0.00)[bounces-2607-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Hi Dylan,

On Tue, Apr 28, 2026 at 06:36:38PM +0000, Dylan Hatch wrote:
> From: Weinan Liu <wnliu@google.com>
> 
> DWARF CFI (Call Frame Information) specifies how to recover the return
> address and callee-saved registers at each PC in a given function.
> Compilers are able to generate the CFI annotations when they compile
> the code to assembly language. For handcrafted assembly, we need to
> annotate them by hand.
> 
> Annotate minimal CFI to enable stacktracing using SFrame for kernel
> exception entries through el1*_64_*() paths 

I thought we were only consuming SFrame when unwinding an exeption
boundary?

We shouldn't be taking exceptions _from_ the entry assembly functions
unless something has gone horribly wrong, and so I don't see why we'd
need CFI entries for the entry assembly functions.

Am I missing some reason we need CFI entries for the entry assembly
functions? I strongly suspect it is not necessary to add these, and I'd
prefer to omit them.

> and irq entries through call_on_irq_stack()

Needing some sort of unwind annotations for call_on_irq_stack() makes
sense to me, but don't we need something for other assembly functions
too?

We can interrupt things like memset(); I assume we'll treat those as
unreliable until annotated?

Mark.

> Signed-off-by: Weinan Liu <wnliu@google.com>
> Suggested-by: Jens Remus <jremus@linux.ibm.com>
> Reviewed-by: Jens Remus <jremus@linux.ibm.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> ---
>  arch/arm64/kernel/entry.S | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index f8018b5c1f9a..dc55b0b19cfa 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -30,6 +30,12 @@
>  #include <asm/asm-uaccess.h>
>  #include <asm/unistd.h>
>  
> +/*
> + * Do not generate .eh_frame.  Only generate .debug_frame and optionally
> + * .sframe (via assembler option --gsframe[-N]).
> + */
> +	.cfi_sections .debug_frame
> +
>  	.macro	clear_gp_regs
>  	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
>  	mov	x\n, xzr
> @@ -575,7 +581,16 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
>  	.if \el == 0
>  	b	ret_to_user
>  	.else
> +	/*
> +	 * Minimal DWARF CFI for unwinding across the call above.
> +	 * Enable unwinding for el1*_64_*() path only.
> +	 */
> +	.cfi_startproc
> +	.cfi_def_cfa_offset PT_REGS_SIZE
> +	.cfi_offset 29, S_FP - PT_REGS_SIZE
> +	.cfi_offset 30, S_LR - PT_REGS_SIZE
>  	b	ret_to_kernel
> +	.cfi_endproc
>  	.endif
>  SYM_CODE_END(el\el\ht\()_\regsize\()_\label)
>  	.endm
> @@ -872,6 +887,7 @@ NOKPROBE(ret_from_fork)
>   * Calls func(regs) using this CPU's irq stack and shadow irq stack.
>   */
>  SYM_FUNC_START(call_on_irq_stack)
> +	.cfi_startproc
>  	save_and_disable_daif x9
>  #ifdef CONFIG_SHADOW_CALL_STACK
>  	get_current_task x16
> @@ -882,6 +898,9 @@ SYM_FUNC_START(call_on_irq_stack)
>  	/* Create a frame record to save our LR and SP (implicit in FP) */
>  	stp	x29, x30, [sp, #-16]!
>  	mov	x29, sp
> +	.cfi_def_cfa 29, 16
> +	.cfi_offset 29, -16
> +	.cfi_offset 30, -8
>  
>  	ldr_this_cpu x16, irq_stack_ptr, x17
>  
> @@ -897,9 +916,13 @@ SYM_FUNC_START(call_on_irq_stack)
>  	 */
>  	mov	sp, x29
>  	ldp	x29, x30, [sp], #16
> +	.cfi_restore 29
> +	.cfi_restore 30
> +	.cfi_def_cfa 31, 0
>  	scs_load_current
>  	restore_irq x9
>  	ret
> +	.cfi_endproc
>  SYM_FUNC_END(call_on_irq_stack)
>  NOKPROBE(call_on_irq_stack)
>  
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

