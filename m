Return-Path: <live-patching+bounces-1651-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 80335B57360
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 10:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E6AF4E17E4
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 08:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B032EA720;
	Mon, 15 Sep 2025 08:48:26 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F0E20CCCA;
	Mon, 15 Sep 2025 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926106; cv=none; b=MfxKKn/n9i6iiTM4kYDZOUpW+dRJUS8/2LZpKlxHITRxQ1Xd7sR9PwwxTaU1go5jdn4ToDU5vjuqXu6xMxss3Y2vU/PVL3Sx92GguCBUXTv621yB5dZSki5QMlJ2laMY9MRBbVnUzJ/46SXdTEARlAPj/zYNBPKL2yJ2jFegQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926106; c=relaxed/simple;
	bh=LBmWcJyeHzo3TXNkMja5Tk62h8BTmwr6j9mQmrCb43c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JJpqF7I8+fVI6HEQ5b4AR9dorug8fm5aSqFpFrvN0OdBBF3PZrVXY2bmhBJwgjfVOWXhmIE44QWpqz8SWd/J52T+ECoBZXwr/kw8yS4HRo9v9oE2YIZkf9Io1khmbq/ljKiJ4daossl0o7d7luUpy1R1bhwvwROJaAW4BkC3RY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Cx6tHU0sdoS3UKAA--.22504S3;
	Mon, 15 Sep 2025 16:48:20 +0800 (CST)
Received: from [10.130.10.66] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJCxH8LS0sdod++WAA--.33937S3;
	Mon, 15 Sep 2025 16:48:19 +0800 (CST)
Subject: Re: [PATCH v1 2/2] LoongArch: Return 0 for user tasks in
 arch_stack_walk_reliable()
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Xi Zhang <zhangxi@kylinos.cn>,
 live-patching@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
 <20250909113106.22992-3-yangtiezhu@loongson.cn>
 <alpine.LSU.2.21.2509111541590.29971@pobox.suse.cz>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <2b3235b7-87a5-9146-9f31-4668dda207b2@loongson.cn>
Date: Mon, 15 Sep 2025 16:48:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2509111541590.29971@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxH8LS0sdod++WAA--.33937S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7JF1kuF15CFWrWr43Gw43twc_yoWDArb_Zw
	nrAFykuw1jqanxAw48tay5ArZ0kw4Fyry8XrZ5tr1ay3s3Z348Jrs7Kr97uasxJr4qyFnx
	Krn8JrWSyryS9osvyTuYvTs0mTUanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbfxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Cr1j6rxdM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=

On 2025/9/11 下午9:44, Miroslav Benes wrote:
> Hi,
> 
> On Tue, 9 Sep 2025, Tiezhu Yang wrote:
> 
>> When testing the kernel live patching with "modprobe livepatch-sample",
>> there is a timeout over 15 seconds from "starting patching transition"
>> to "patching complete", dmesg shows "unreliable stack" for user tasks
>> in debug mode. When executing "rmmod livepatch-sample", there exists
>> the similar issue.
>>
>> Like x86, arch_stack_walk_reliable() should return 0 for user tasks.
>> It is necessary to set regs->csr_prmd as task->thread.csr_prmd first,
>> then use user_mode() to check whether the task is in userspace.
> 
> it is a nice optimization for sure, but "unreliable stack" messages point
> to a fact that the unwinding of these tasks is probably suboptimal and
> could be improved, no?

Yes, makes sense, I will fix "unreliable stack" in the next version.

> It would also be nice to include these messages (not for all tasks) to the
> commit message.

OK, will do it.

Thanks,
Tiezhu


