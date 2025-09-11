Return-Path: <live-patching+bounces-1640-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB85B53163
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 13:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48AB07B171F
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 11:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E5B2F0670;
	Thu, 11 Sep 2025 11:49:58 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8042C159A;
	Thu, 11 Sep 2025 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591398; cv=none; b=X1VXZfbzVWjYDQOyQk//qqycNgNeACZs1s60Jn4Jf54z+oAn8fm6lbC9XbW5i4vxcKUtYdZYHCcXJSRhV09/85djYhLPcDg3xyrnseRHypvvQjQAIlzXDcIWM3S+6ghVCNvwyrN+nHzUUYm5HI9F2siTlkNA2d1w2UlorbChp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591398; c=relaxed/simple;
	bh=jU7cQJWKbEmzN+FcnVCf5vLe/NA8j+GUwLOmZOFuYZ4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q48bbBZB/iln51+JGvWJPP5CEQ0L/nu07VVAjIY8U7JRwtAMUsbdj3orheyBYMSbBKN/mDFqHQK/rUhv+goyWDEypSit+OAFCJzeIWpYt8ceBFGE92KPHeCtHjCcihAPMcceerbzoCKSIE+Eq/pLIgsb6Aom6aS93iI/ZZmuEO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8CxbNJft8JoLDgJAA--.19746S3;
	Thu, 11 Sep 2025 19:49:51 +0800 (CST)
Received: from [10.130.10.66] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJAxT+Zet8JoVPWNAA--.57205S3;
	Thu, 11 Sep 2025 19:49:51 +0800 (CST)
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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <c3431ce4-0026-3a05-fa50-281cd34aba4e@loongson.cn>
Date: Thu, 11 Sep 2025 19:49:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5e45a1a9-4ac3-56ee-1415-0b2128b4ed9a@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+Zet8JoVPWNAA--.57205S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7trW7XF1fAFykCFW5ur43CFX_yoW8tr4rpr
	95C3ZxKFyUtr9YgF9rGr1DXFy8Jw4kZw1DGF1rJ3W7ZF1Yqr1Fgw429ayj9rsxArWkJw4a
	kr15trykua17JacCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_MaUUUU
	U

On 2025/9/10 上午9:11, Jinyang He wrote:
> On 2025-09-09 19:31, Tiezhu Yang wrote:
> 
>> When testing the kernel live patching with "modprobe livepatch-sample",
>> there is a timeout over 15 seconds from "starting patching transition"
>> to "patching complete", dmesg shows "unreliable stack" for user tasks
>> in debug mode. When executing "rmmod livepatch-sample", there exists
>> the similar issue.

...

>> @@ -57,9 +62,14 @@ int arch_stack_walk_reliable(stack_trace_consume_fn 
>> consume_entry,
>>       }
>>       regs->regs[1] = 0;
>>       regs->regs[22] = 0;
>> +    regs->csr_prmd = task->thread.csr_prmd;
>>       for (unwind_start(&state, task, regs);
>>            !unwind_done(&state) && !unwind_error(&state); 
>> unwind_next_frame(&state)) {
>> +        /* Success path for user tasks */
>> +        if (user_mode(regs))
>> +            return 0;
>> +
>>           addr = unwind_get_return_address(&state);
>>           /*
> Hi, Tiezhu,
> 
> We update stack info by get_stack_info when meet ORC_TYPE_REGS in
> unwind_next_frame. And in arch_stack_walk(_reliable), we always
> do unwind_done before unwind_next_frame. So is there anything
> error in get_stack_info which causing regs is user_mode while
> stack is not STACK_TYPE_UNKNOWN?

When testing the kernel live patching, the error code path in
unwind_next_frame() is:

   switch (orc->fp_reg) {
           case ORC_REG_PREV_SP:
                   p = (unsigned long *)(state->sp + orc->fp_offset);
                   if (!stack_access_ok(state, (unsigned long)p, 
sizeof(unsigned long)))
                           goto err;

for this case, get_stack_info() does not return 0 due to in_task_stack()
is not true, then goto error, state->stack_info.type = STACK_TYPE_UNKNOWN
and state->error = true. In arch_stack_walk_reliable(), the loop will be
break and it returns -EINVAL, thus causing unreliable stack.

Maybe it can check whether the task is in userspace and set
state->stack_info.type = STACK_TYPE_UNKNOWN in get_stack_info(),
but I think no need to do that because it has similar effect with
this patch.

Thanks,
Tiezhu


