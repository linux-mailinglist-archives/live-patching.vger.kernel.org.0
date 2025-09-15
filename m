Return-Path: <live-patching+bounces-1652-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5A9B573B6
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 10:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BC8F18829E6
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 08:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866942F5305;
	Mon, 15 Sep 2025 08:54:52 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4D12F0696;
	Mon, 15 Sep 2025 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926492; cv=none; b=GnYQi+Lf2U/UHsvwkRkWEHxYv4yBTXHzM9BBS0xoW0TDOAz+DXSQ+E1OQKnX+0zZZmUfovp+vhJGrp+YCMJJBSPo6UwwlapBYnzEI6agCTQH9XU5tt19sV+GqjvGDPeoTI54KZstRv4torSL2NkSEqFT0BRjcKnK7KMHD4vr+ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926492; c=relaxed/simple;
	bh=FqMfWhz6R7kWnn+nzywynCJfDgvX6OtKKVEedLJuU7k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sce4Cec6e1QKwGLIeae//Atni4UxA1vbhmgYB0R8FMWkoP6GspFNiwAA7cI0MexZsumKYIdKikojkc8k8hZp0qNYjxGFsmUQ26SetBxi7nITQoR1vQgTMJYYfwr6PAt3calRU0PTjI/T7uk3iMUSdClWUoETH/W0xu4RosBfDPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Bxnr9Y1MdoF3YKAA--.21196S3;
	Mon, 15 Sep 2025 16:54:48 +0800 (CST)
Received: from [10.130.10.66] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxTMFX1MdouPGWAA--.32715S3;
	Mon, 15 Sep 2025 16:54:48 +0800 (CST)
Subject: Re: [PATCH v1 2/2] LoongArch: Return 0 for user tasks in
 arch_stack_walk_reliable()
To: Jinyang He <hejinyang@loongson.cn>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Xi Zhang <zhangxi@kylinos.cn>,
 live-patching@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
 <20250909113106.22992-3-yangtiezhu@loongson.cn>
 <5e45a1a9-4ac3-56ee-1415-0b2128b4ed9a@loongson.cn>
 <c3431ce4-0026-3a05-fa50-281cd34aba4e@loongson.cn>
 <26036193-f570-3a17-e6d3-45ad70704198@loongson.cn>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <47be74ad-c01c-cf79-b7a4-3f05f85c2f71@loongson.cn>
Date: Mon, 15 Sep 2025 16:54:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <26036193-f570-3a17-e6d3-45ad70704198@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxTMFX1MdouPGWAA--.32715S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zr4UAFW3Kry7KFyxXryUtwc_yoW8Gr18pr
	92gF43KF4kJw1qvF97Kr4kWFyaqa97J3s8Kr1rt34DCr1qqr13GF1xKw45uFZxZrn5K3ya
	vr4jgr95uF4DAagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
	xVWxJr0_GcWln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz2NtUUUUU=

On 2025/9/12 上午9:55, Jinyang He wrote:
> On 2025-09-11 19:49, Tiezhu Yang wrote:
> 
>> On 2025/9/10 上午9:11, Jinyang He wrote:
>>> On 2025-09-09 19:31, Tiezhu Yang wrote:
>>>
>>>> When testing the kernel live patching with "modprobe livepatch-sample",
>>>> there is a timeout over 15 seconds from "starting patching transition"
>>>> to "patching complete", dmesg shows "unreliable stack" for user tasks
>>>> in debug mode. When executing "rmmod livepatch-sample", there exists
>>>> the similar issue.

...

>> for this case, get_stack_info() does not return 0 due to in_task_stack()
>> is not true, then goto error, state->stack_info.type = STACK_TYPE_UNKNOWN
>> and state->error = true. In arch_stack_walk_reliable(), the loop will be
>> break and it returns -EINVAL, thus causing unreliable stack.
> The stop position of a complete stack backtrace on LoongArch should be
> the top of the task stack or until the address is_entry_func.
> Otherwise, it is not a complete stack backtrace, and thus I think it
> is an "unreliable stack".
> I'm curious about what the ORC info at this PC.

The unwind process has problem, I have found the root cause and am
working to fix the "unreliable stack" issue, it should and can find
the last frame, and then the user_mode() check is not necessary.

Thanks,
Tiezhu


