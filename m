Return-Path: <live-patching+bounces-1085-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFB1A22AF0
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 10:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A4983A578E
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 09:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F93E1B85CA;
	Thu, 30 Jan 2025 09:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RzCPKNde"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78791B6D0B;
	Thu, 30 Jan 2025 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230897; cv=none; b=SJLd7Y1tzwSkofTuRC2Kq46eeFc1gvcp93jYUfqyqBc1xCGHt5SqmeB9fXG3JfXuBrwS2fSdnE/1t0yVSlog0uLZH3QLw0gdBqy4/owjS3mLMpcd7uk+4MLsPfX5UAufnrashZDwpCWviSPps3MythzBbKyxW/dK7v18xq6UV7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230897; c=relaxed/simple;
	bh=eGA/gDFrH8C4Sif6FNWh1bdZsChS7abWb4kZvzh++XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2q751u+lNpL+jm+JmVwNha1DR2R8nQmqLyER+1OXoow2Snubc3GhkgRK7BfEkvRd8dfccgzLzfsx1RxJ2a9JFqouxYA/Hj645qF3bwAAGkoSoGAVhkfd9Qo3Cp5hW9ZUFNVqSJtor1/WdOv6Y9emGJaoSHgdAcTBt0OyT1xJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RzCPKNde; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9961C2109CD7;
	Thu, 30 Jan 2025 01:54:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9961C2109CD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738230895;
	bh=3ygSSs5wsJyXqcv3ReS1ED3Taq0KIu32kgznuzVAlVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RzCPKNde4/ytrIS/aZsrF8rshVuFVVjpYjpXou7r+ccV4v2ZGV5qu02RWRcl6LHUX
	 Vys807dJ2N9QvfcJHLHickulVOy4XaZGH66PClvto52qqlkr+J8SpVqyC8DBm9APqK
	 L3BY6vECgtxk+KCt0lBn0TpAudrIRVtQYAP7Xr7A=
Message-ID: <755ae1e9-5f58-4260-8460-94a757894cf8@linux.microsoft.com>
Date: Thu, 30 Jan 2025 15:24:50 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] arm64: Define TIF_PATCH_PENDING for livepatch
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
 Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Suraj Jitindar Singh <sjitindarsingh@gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-8-wnliu@google.com>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <20250127213310.2496133-8-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 28-01-2025 03:03, Weinan Liu wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>
> 	- Define TIF_PATCH_PENDING in arch/arm64/include/asm/thread_info.h
> 	  for livepatch.
>
> 	- Check TIF_PATCH_PENDING in do_notify_resume() to patch the
> 	  current task for livepatch.
>
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   arch/arm64/include/asm/thread_info.h | 4 +++-
>   arch/arm64/kernel/entry-common.c     | 4 ++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 1114c1c3300a..3810c2f3914e 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -64,6 +64,7 @@ void arch_setup_new_exec(void);
>   #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
>   #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
>   #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
> +#define TIF_PATCH_PENDING	7	/* pending live patching update */
>   #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
>   #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
>   #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
> @@ -99,11 +100,12 @@ void arch_setup_new_exec(void);
>   #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
>   #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
>   #define _TIF_TSC_SIGSEGV	(1 << TIF_TSC_SIGSEGV)
> +#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
>   
>   #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>   				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
>   				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
> -				 _TIF_NOTIFY_SIGNAL)
> +				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
>   
>   #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
>   				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
> index b260ddc4d3e9..b537af333b42 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
> @@ -8,6 +8,7 @@
>   #include <linux/context_tracking.h>
>   #include <linux/kasan.h>
>   #include <linux/linkage.h>
> +#include <linux/livepatch.h>
>   #include <linux/lockdep.h>
>   #include <linux/ptrace.h>
>   #include <linux/resume_user_mode.h>
> @@ -144,6 +145,9 @@ static void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
>   				       (void __user *)NULL, current);
>   		}
>   
> +		if (thread_flags & _TIF_PATCH_PENDING)
> +			klp_update_patch_state(current);
> +
>   		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>   			do_signal(regs);
>   

Looks good to me.
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>.


