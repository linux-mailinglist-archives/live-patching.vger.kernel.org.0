Return-Path: <live-patching+bounces-1637-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 121ABB50A19
	for <lists+live-patching@lfdr.de>; Wed, 10 Sep 2025 03:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1528564A24
	for <lists+live-patching@lfdr.de>; Wed, 10 Sep 2025 01:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA1C1E1DE9;
	Wed, 10 Sep 2025 01:12:02 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EE61E2853;
	Wed, 10 Sep 2025 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757466722; cv=none; b=Pt08Ke5Rvha1SktFppvuut2E+Y7RX093d+N6JHjhVJoRlKoJ2y/nfSRTjM9uG5L4//wycmbIqVu2fPU+sME32AwM2IG+IbLpa/AN8Red38tLe3yd6foIxQJKyPbt/MID7n2OL+/Kz2Z4db/ukIAv3WbAA8iv+WyYn/PDR8yK8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757466722; c=relaxed/simple;
	bh=VLZV08D0RrY8qkrpwcLypvyV7VjZDjrL8NWEVgCZtdM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YZao3QPEQwF3AlKuKNp4ZynmuC/ibNZ3sTneMx+8NCsiDC1etsEgtuweRnSfpgfMtaH6EgsnlOaUAIprCjJ69vojq5TGP3P5wZpne8w62IBraUm8JIMgNEa4GaniWLIu4TISc9B/sYGlcWBtYrxmfr2yD0QONu4/+jY5QqUCCHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [111.9.175.10])
	by gateway (Coremail) with SMTP id _____8Bx3tJb0MBow54IAA--.18478S3;
	Wed, 10 Sep 2025 09:11:55 +0800 (CST)
Received: from [10.136.12.26] (unknown [111.9.175.10])
	by front1 (Coremail) with SMTP id qMiowJAxQMJY0MBozDqLAA--.43503S3;
	Wed, 10 Sep 2025 09:11:54 +0800 (CST)
Subject: Re: [PATCH v1 2/2] LoongArch: Return 0 for user tasks in
 arch_stack_walk_reliable()
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Xi Zhang <zhangxi@kylinos.cn>,
 live-patching@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
 <20250909113106.22992-3-yangtiezhu@loongson.cn>
From: Jinyang He <hejinyang@loongson.cn>
Message-ID: <5e45a1a9-4ac3-56ee-1415-0b2128b4ed9a@loongson.cn>
Date: Wed, 10 Sep 2025 09:11:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250909113106.22992-3-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:qMiowJAxQMJY0MBozDqLAA--.43503S3
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBj93XoWxZF48KryDAw4fCr1DuF4fCrX_yoWrWF4Dpr
	15u3Zxt3yUt3sIq3ZFkr45ZryrXw4kA3sxWF93K3sa93WDZa48tr92kw1jyw4Yvr90kw17
	Xr10gFyvga1xZ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_MaUUUU
	U

On 2025-09-09 19:31, Tiezhu Yang wrote:

> When testing the kernel live patching with "modprobe livepatch-sample",
> there is a timeout over 15 seconds from "starting patching transition"
> to "patching complete", dmesg shows "unreliable stack" for user tasks
> in debug mode. When executing "rmmod livepatch-sample", there exists
> the similar issue.
>
> Like x86, arch_stack_walk_reliable() should return 0 for user tasks.
> It is necessary to set regs->csr_prmd as task->thread.csr_prmd first,
> then use user_mode() to check whether the task is in userspace.
>
> Here are the call chains:
>
>    klp_enable_patch()
>      klp_try_complete_transition()
>        klp_try_switch_task()
>          klp_check_and_switch_task()
>            klp_check_stack()
>              stack_trace_save_tsk_reliable()
>                arch_stack_walk_reliable()
>
> With this patch, it takes a short time for patching and unpatching.
>
> Before:
>
>    # modprobe livepatch-sample
>    # dmesg -T | tail -3
>    [Sat Sep  6 11:00:20 2025] livepatch: 'livepatch_sample': starting patching transition
>    [Sat Sep  6 11:00:35 2025] livepatch: signaling remaining tasks
>    [Sat Sep  6 11:00:36 2025] livepatch: 'livepatch_sample': patching complete
>
>    # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
>    # rmmod livepatch_sample
>    rmmod: ERROR: Module livepatch_sample is in use
>    # rmmod livepatch_sample
>    # dmesg -T | tail -3
>    [Sat Sep  6 11:06:05 2025] livepatch: 'livepatch_sample': starting unpatching transition
>    [Sat Sep  6 11:06:20 2025] livepatch: signaling remaining tasks
>    [Sat Sep  6 11:06:21 2025] livepatch: 'livepatch_sample': unpatching complete
>
> After:
>
>    # modprobe livepatch-sample
>    # dmesg -T | tail -2
>    [Sat Sep  6 11:19:00 2025] livepatch: 'livepatch_sample': starting patching transition
>    [Sat Sep  6 11:19:01 2025] livepatch: 'livepatch_sample': patching complete
>
>    # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
>    # rmmod livepatch_sample
>    # dmesg -T | tail -2
>    [Sat Sep  6 11:21:10 2025] livepatch: 'livepatch_sample': starting unpatching transition
>    [Sat Sep  6 11:21:11 2025] livepatch: 'livepatch_sample': unpatching complete
>
> While at it, do the similar thing for arch_stack_walk() to avoid
> potential issues.
>
> Cc: stable@vger.kernel.org # v6.9+
> Fixes: 199cc14cb4f1 ("LoongArch: Add kernel livepatching support")
> Reported-by: Xi Zhang <zhangxi@kylinos.cn>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   arch/loongarch/kernel/stacktrace.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
> index 9a038d1070d7..0454cce3b667 100644
> --- a/arch/loongarch/kernel/stacktrace.c
> +++ b/arch/loongarch/kernel/stacktrace.c
> @@ -30,10 +30,15 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>   		}
>   		regs->regs[1] = 0;
>   		regs->regs[22] = 0;
> +		regs->csr_prmd = task->thread.csr_prmd;
>   	}
>   
>   	for (unwind_start(&state, task, regs);
>   	     !unwind_done(&state); unwind_next_frame(&state)) {
> +		/* Success path for user tasks */
> +		if (user_mode(regs))
> +			return;
> +
>   		addr = unwind_get_return_address(&state);
>   		if (!addr || !consume_entry(cookie, addr))
>   			break;
> @@ -57,9 +62,14 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>   	}
>   	regs->regs[1] = 0;
>   	regs->regs[22] = 0;
> +	regs->csr_prmd = task->thread.csr_prmd;
>   
>   	for (unwind_start(&state, task, regs);
>   	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
> +		/* Success path for user tasks */
> +		if (user_mode(regs))
> +			return 0;
> +
>   		addr = unwind_get_return_address(&state);
>   
>   		/*
Hi, Tiezhu,

We update stack info by get_stack_info when meet ORC_TYPE_REGS in
unwind_next_frame. And in arch_stack_walk(_reliable), we always
do unwind_done before unwind_next_frame. So is there anything
error in get_stack_info which causing regs is user_mode while
stack is not STACK_TYPE_UNKNOWN?


