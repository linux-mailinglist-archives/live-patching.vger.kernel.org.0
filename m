Return-Path: <live-patching+bounces-1090-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 246E3A22BB8
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 11:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2992F3A86B3
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 10:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716A41BD9C5;
	Thu, 30 Jan 2025 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="EF7mc93R"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99E91BCA19;
	Thu, 30 Jan 2025 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738233423; cv=none; b=L4o4m9c8LCXZjP9jcPNstwItaLFAlSDIMcvQ7bvBVfAJhALYLKVeTsLkdpfSndgDhk1rBITxz/b0NsSW/6ZCGdylMLpCaozwL3DkFxv1/cCVFFnd3MaFS8M2O2l6krcobsT2hY1yv6dSbFIT+XBsMjs8rb/RVjuCWcVyLOaVL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738233423; c=relaxed/simple;
	bh=IakoazHnI69jhWVkfuysRy7NUYvtYEtGyHjmLWa1zYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gRzefUSbZW+vSGvwFyCPKLnXjQ3I3lhbj1ofSrnocNu1vMOzk1BgV3BYgE8Cvt/j5UWcY5Jm/K100wdGqT5eNjWnsMdUjHVH/mIuI6fvpGeQRpRqggSd34YPb86UlYloSttn2SEnY8AMIJmP2APH6128CuWbsJQ0EnbfkPpiPp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=EF7mc93R; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6431B2109CD7;
	Thu, 30 Jan 2025 02:36:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6431B2109CD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738233421;
	bh=mHU7Mfj+jdlBvEEUG3Mk560s4FlcL4gxyi/SpShMVNE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EF7mc93R7ozr4HWtaTUzkbz0uslmOMqrlEanm/rjn3O836YTZTP1Hlo9HoABT4Ka0
	 WrruTcK51vLoChcNhmJfPPFN5+n4+uuGn2iqDhEIejPmFjl7dKjqLJWunpI9prVWCw
	 8h7zd/F7OYeBQyF5LWUqi2B9q0W5fPxX2Datin+w=
Message-ID: <f2cbccc0-1bab-48a3-b837-ce875df21efe@linux.microsoft.com>
Date: Thu, 30 Jan 2025 16:06:57 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] unwind: arm64: add reliable stacktrace support for
 arm64
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
 Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-7-wnliu@google.com>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <20250127213310.2496133-7-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 28-01-2025 03:03, Weinan Liu wrote:
> To support livepatch, we need to add arch_stack_walk_reliable to
> support reliable stacktrace according to
> https://docs.kernel.org/livepatch/reliable-stacktrace.html#requirements
>
> report stacktrace is not reliable if we are not able to unwind the stack
> by sframe unwinder and fallback to FP based unwinder
>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   arch/arm64/include/asm/stacktrace/common.h |  2 +
>   arch/arm64/kernel/stacktrace.c             | 47 +++++++++++++++++++++-
>   2 files changed, 47 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 19edae8a5b1a..26449cd402db 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -26,6 +26,7 @@ struct stack_info {
>    * @stacks:      An array of stacks which can be unwound.
>    * @nr_stacks:   The number of stacks in @stacks.
>    * @cfa:         The sp value at the call site of the current function.
> + * @unreliable:  Stacktrace is unreliable.
>    */
>   struct unwind_state {
>   	unsigned long fp;
> @@ -36,6 +37,7 @@ struct unwind_state {
>   	int nr_stacks;
>   #ifdef CONFIG_SFRAME_UNWINDER
>   	unsigned long cfa;
> +	bool unreliable;
>   #endif
>   };
>   
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index c035adb8fe8a..eab16dc05bb5 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -310,11 +310,16 @@ kunwind_next(struct kunwind_state *state)
>   	case KUNWIND_SOURCE_TASK:
>   	case KUNWIND_SOURCE_REGS_PC:
>   #ifdef CONFIG_SFRAME_UNWINDER
> -	err = unwind_next_frame_sframe(&state->common);
> +	if (!state->common.unreliable)
> +		err = unwind_next_frame_sframe(&state->common);
>   
>   	/* Fallback to FP based unwinder */
> -	if (err)
> +	if (err || state->common.unreliable) {
>   		err = kunwind_next_frame_record(state);
> +		/* Mark its stacktrace result as unreliable if it is unwindable via FP */
> +		if (!err)
> +			state->common.unreliable = true;
> +	}
>   #else
>   	err = kunwind_next_frame_record(state);
>   #endif
> @@ -446,6 +451,44 @@ noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
>   	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
>   }
>   
> +#ifdef CONFIG_SFRAME_UNWINDER
> +struct kunwind_reliable_consume_entry_data {
> +	stack_trace_consume_fn consume_entry;
> +	void *cookie;
> +	bool unreliable;
> +};
> +
> +static __always_inline bool
> +arch_kunwind_reliable_consume_entry(const struct kunwind_state *state, void *cookie)
> +{
> +	struct kunwind_reliable_consume_entry_data *data = cookie;
> +
> +	if (state->common.unreliable) {
> +		data->unreliable = true;
> +		return false;
> +	}
> +	return data->consume_entry(data->cookie, state->common.pc);
> +}
> +
> +noinline notrace int arch_stack_walk_reliable(
> +				stack_trace_consume_fn consume_entry,
> +				void *cookie, struct task_struct *task)
> +{
> +	struct kunwind_reliable_consume_entry_data data = {
> +		.consume_entry = consume_entry,
> +		.cookie = cookie,
> +		.unreliable = false,
> +	};
> +
> +	kunwind_stack_walk(arch_kunwind_reliable_consume_entry, &data, task, NULL);
> +
> +	if (data.unreliable)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +#endif
> +
>   struct bpf_unwind_consume_entry_data {
>   	bool (*consume_entry)(void *cookie, u64 ip, u64 sp, u64 fp);
>   	void *cookie;

Why not fold the previous patch and this into one?

But the code looks good to me.

Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>.

