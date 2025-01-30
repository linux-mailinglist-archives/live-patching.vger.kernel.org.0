Return-Path: <live-patching+bounces-1089-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A61A22BA8
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 11:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB1D03A8413
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 10:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEE71B87ED;
	Thu, 30 Jan 2025 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="K1dCig9e"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5806185955;
	Thu, 30 Jan 2025 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738233305; cv=none; b=e0hSMamlBNPMsk4BLsIcrqCce9fTBxAi8v9k1tME0tA7BCb3TmQGIsbrRLuUC0nQM04+iXQH0jj/IG1gw2vUDBd3RiVkQemwaWQHWUGryT9NejhPicXoVLImv6uH7ukd7xS6cs6X5XzUNDHOm9cAhqTGFUCBYesou/oois/Udso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738233305; c=relaxed/simple;
	bh=hdKhXgaK3f//0AkZjxuDWr02rhY/QoJKzXHPooHD51A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irXgJTYhEeQLEqV461Aihw+6NDEgwQDvR4Az0Nn1W/9BAtrI4mYG9AAmG/8BOm5un7EoIUfVrcjs66fYwUyCLctTkGquR02hnhv53Y44DRlT0y9ht7Pp1DC/JqHI+ECHwmNdIGitq929T8AzFN6pSGSaX3ka2AnvmVvmjELwKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=K1dCig9e; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id 08CCF2109CD7;
	Thu, 30 Jan 2025 02:34:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 08CCF2109CD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738233303;
	bh=zVxf1UYtEnYrkLL5hJZ5QlBHDjxANnAboqvzYXh5U+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K1dCig9el0oa/CufgrNC59jLSZ4uDmmETUxrotOCcTRTtmSR76F0u8ePBztpNA0Dx
	 ApYzof/Kaow0caEadeNkSHDC9/1jaqtV1XE0KzQ8OXzbNRz738nPbZZiAOBkfkKMeF
	 ogJ+/z2GDWMeFSr/hiw+UHD5ZjxCV0VU9Gh3Lp28=
Message-ID: <e109763f-d4c1-4016-83eb-c8973b291cee@linux.microsoft.com>
Date: Thu, 30 Jan 2025 16:04:58 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] unwind: arm64: Add sframe unwinder on arm64
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
 Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-6-wnliu@google.com>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <20250127213310.2496133-6-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 28-01-2025 03:03, Weinan Liu wrote:
> Add unwind_next_frame_sframe() function to unwind by sframe info.
> Built with GNU Binutils 2.42 to verify that this sframe unwinder can
> backtrace correctly on arm64.
>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   arch/arm64/include/asm/stacktrace/common.h |  4 ++
>   arch/arm64/kernel/setup.c                  |  2 +
>   arch/arm64/kernel/stacktrace.c             | 59 ++++++++++++++++++++++
>   3 files changed, 65 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 821a8fdd31af..19edae8a5b1a 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -25,6 +25,7 @@ struct stack_info {
>    * @stack:       The stack currently being unwound.
>    * @stacks:      An array of stacks which can be unwound.
>    * @nr_stacks:   The number of stacks in @stacks.
> + * @cfa:         The sp value at the call site of the current function.
>    */
>   struct unwind_state {
>   	unsigned long fp;
> @@ -33,6 +34,9 @@ struct unwind_state {
>   	struct stack_info stack;
>   	struct stack_info *stacks;
>   	int nr_stacks;
> +#ifdef CONFIG_SFRAME_UNWINDER
> +	unsigned long cfa;
> +#endif
>   };
>   
>   static inline struct stack_info stackinfo_get_unknown(void)
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 4f613e8e0745..d3ac92b624f3 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -32,6 +32,7 @@
>   #include <linux/sched/task.h>
>   #include <linux/scs.h>
>   #include <linux/mm.h>
> +#include <linux/sframe_lookup.h>
>   
>   #include <asm/acpi.h>
>   #include <asm/fixmap.h>
> @@ -377,6 +378,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>   			"This indicates a broken bootloader or old kernel\n",
>   			boot_args[1], boot_args[2], boot_args[3]);
>   	}
> +	init_sframe_table();
>   }
>   
>   static inline bool cpu_can_disable(unsigned int cpu)
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 1d9d51d7627f..c035adb8fe8a 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -14,6 +14,7 @@
>   #include <linux/sched/debug.h>
>   #include <linux/sched/task_stack.h>
>   #include <linux/stacktrace.h>
> +#include <linux/sframe_lookup.h>
>   
>   #include <asm/efi.h>
>   #include <asm/irq.h>
> @@ -242,6 +243,53 @@ kunwind_next_frame_record(struct kunwind_state *state)
>   	return 0;
>   }
>   
> +#ifdef CONFIG_SFRAME_UNWINDER
> +/*
> + * Unwind to the next frame according to sframe.
> + */
> +static __always_inline int
> +unwind_next_frame_sframe(struct unwind_state *state)
> +{
> +	unsigned long fp = state->fp, ip = state->pc;
> +	unsigned long base_reg, cfa;
> +	unsigned long pc_addr, fp_addr;
> +	struct sframe_ip_entry entry;
> +	struct stack_info *info;
> +	struct frame_record *record = (struct frame_record *)fp;
> +
> +	int err;
> +
> +	/* frame record alignment 8 bytes */
> +	if (fp & 0x7)
> +		return -EINVAL;
> +
> +	info = unwind_find_stack(state, fp, sizeof(*record));
> +	if (!info)
> +		return -EINVAL;
> +
> +	err = sframe_find_pc(ip, &entry);
> +	if (err)
> +		return -EINVAL;
> +
> +	unwind_consume_stack(state, info, fp, sizeof(*record));
> +
> +	base_reg = entry.use_fp ? fp : state->cfa;
> +
> +	/* Set up the initial CFA using fp based info if CFA is not set */
> +	if (!state->cfa)
> +		cfa = fp - entry.fp_offset;
> +	else
> +		cfa = base_reg + entry.cfa_offset;
> +	fp_addr = cfa + entry.fp_offset;
> +	pc_addr = cfa + entry.ra_offset;
> +	state->cfa = cfa;
> +	state->fp = READ_ONCE(*(unsigned long *)(fp_addr));
> +	state->pc = READ_ONCE(*(unsigned long *)(pc_addr));
> +
> +	return 0;
> +}
> +#endif
> +
>   /*
>    * Unwind from one frame record (A) to the next frame record (B).
>    *
> @@ -261,7 +309,15 @@ kunwind_next(struct kunwind_state *state)
>   	case KUNWIND_SOURCE_CALLER:
>   	case KUNWIND_SOURCE_TASK:
>   	case KUNWIND_SOURCE_REGS_PC:
> +#ifdef CONFIG_SFRAME_UNWINDER
> +	err = unwind_next_frame_sframe(&state->common);
> +
> +	/* Fallback to FP based unwinder */
> +	if (err)
>   		err = kunwind_next_frame_record(state);
> +#else
> +	err = kunwind_next_frame_record(state);
> +#endif
>   		break;
>   	default:
>   		err = -EINVAL;
> @@ -347,6 +403,9 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
>   		.common = {
>   			.stacks = stacks,
>   			.nr_stacks = ARRAY_SIZE(stacks),
> +#ifdef CONFIG_SFRAME_UNWINDER
> +			.cfa = 0,
> +#endif
>   		},
>   	};
>   

Looks good to me.
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>.


