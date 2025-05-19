Return-Path: <live-patching+bounces-1438-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 000F9ABBF5C
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 15:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92E453B2574
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 13:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532C327A128;
	Mon, 19 May 2025 13:41:15 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2612727A121;
	Mon, 19 May 2025 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662075; cv=none; b=IslAyi5qgtaar/RzAJ2XK9GNQK1tiy0/eYCTD3GIy714QLH4uaePSOL0nwx3oUtk70RBfzIKNgtVa2igykee9yKk9Yp28GNT5VZ5cZfa7LnyAuqt/kBcBNpsMbHzm5SiFM+2JM3T1RaX6qOLr48RZB2W576yiUMHlBq7b3jguGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662075; c=relaxed/simple;
	bh=OueGFMEXX6gZvda3QTRBoFs+f9ZjnU1L0TOOtSBxr0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPS85UIXyWXTsuMZkpY5I3+TgWS0Lz7Ja29glLQP+1WgbmY8CBFeX3IEzeNiN8XUUMPzTuLGal6OJR6nXhKpMqmK5hKCCf06mp40lh2Fw7sBYa/g09SFq3oBGk09oZ7RP/GH64Ahk6mAMCChhW7n5CPDaE5fj+5Ox33lmqFqG/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 486291655;
	Mon, 19 May 2025 06:40:59 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 939DF3F6A8;
	Mon, 19 May 2025 06:41:09 -0700 (PDT)
Date: Mon, 19 May 2025 14:41:06 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org,
	will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <aCs08i3u9C9MWy4M@J2N7QTR9R3>
References: <20250320171559.3423224-1-song@kernel.org>
 <20250320171559.3423224-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320171559.3423224-2-song@kernel.org>

On Thu, Mar 20, 2025 at 10:15:58AM -0700, Song Liu wrote:
> With proper exception boundary detection, it is possible to implment
> arch_stack_walk_reliable without sframe.
> 
> Note that, arch_stack_walk_reliable does not guarantee getting reliable
> stack in all scenarios. Instead, it can reliably detect when the stack
> trace is not reliable, which is enough to provide reliable livepatching.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  arch/arm64/Kconfig             |  2 +-
>  arch/arm64/kernel/stacktrace.c | 66 +++++++++++++++++++++++++---------
>  2 files changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 701d980ea921..31d5e1ee6089 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -276,6 +276,7 @@ config ARM64
>  	select HAVE_SOFTIRQ_ON_OWN_STACK
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
> +	select HAVE_RELIABLE_STACKTRACE
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> @@ -2500,4 +2501,3 @@ endmenu # "CPU Power Management"
>  source "drivers/acpi/Kconfig"
>  
>  source "arch/arm64/kvm/Kconfig"
> -
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 1d9d51d7627f..7e07911d8694 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -56,6 +56,7 @@ struct kunwind_state {
>  	enum kunwind_source source;
>  	union unwind_flags flags;
>  	struct pt_regs *regs;
> +	bool end_on_unreliable;
>  };
>  
>  static __always_inline void
> @@ -230,8 +231,26 @@ kunwind_next_frame_record(struct kunwind_state *state)
>  	new_fp = READ_ONCE(record->fp);
>  	new_pc = READ_ONCE(record->lr);
>  
> -	if (!new_fp && !new_pc)
> -		return kunwind_next_frame_record_meta(state);
> +	if (!new_fp && !new_pc) {
> +		int ret;
> +
> +		ret = kunwind_next_frame_record_meta(state);
> +		if (ret < 0) {
> +			/*
> +			 * This covers two different conditions:
> +			 *  1. ret == -ENOENT, unwinding is done.
> +			 *  2. ret == -EINVAL, unwinding hit error.
> +			 */
> +			return ret;
> +		}
> +		/*
> +		 * Searching across exception boundaries. The stack is now
> +		 * unreliable.
> +		 */
> +		if (state->end_on_unreliable)
> +			return -EINVAL;
> +		return 0;
> +	}

My original expectation for this this was that we'd propogate the
errors, and then all the reliability logic would live un a consume_entry
wrapper like we have for BPF, e.g.

| static __always_inline bool
| arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
| {
|         struct kunwind_consume_entry_data *data = cookie;
| 
|         /*  
|          * When unwinding across an exception boundary, the PC will be
|          * reliable, but we do not know whether the FP is live, and so we
|          * cannot perform the *next* unwind reliably.
|          *
|          * Give up as soon as we hit an exception boundary.
|          */
|         if (state->source == KUNWIND_SOURCE_REGS_PC)
|                 return false;
| 
|         return data->consume_entry(data->cookie, state->common.pc);
| }
| 
| noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
|                                               void *cookie,
|                                               struct task_struct *task)
| {
|         int ret;
|         struct kunwind_consume_entry_data data = { 
|                 .consume_entry = consume_entry,
|                 .cookie = cookie,
|         };  
| 
|         ret = kunwind_stack_walk(arch_reliable_kunwind_consume_entry, &data,
|                                  task, NULL);
|         return ret == -ENOENT ? 0 : ret;
| }

... and then in future we can add anything spdecific to reliable
stacktrace there.

That aside, this generally looks good to me. The only thing that I note
is that we're lacking a check on the return value of
kretprobe_find_ret_addr(), and we should return -EINVAL when that is
NULL, but that should never happen in normal operation.

I've pushed a arm64/stacktrace-updates branch [1] with fixups for those
as two separate commits atop this one. If that looks good to you I
suggest we post that as a series and ask Will and Catalin to take that
as-is.

I'll look at the actual patching bits now.

Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/ arm64/stacktrace-updates

