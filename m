Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AAB44F8F7
	for <lists+live-patching@lfdr.de>; Sun, 14 Nov 2021 17:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhKNQSD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 14 Nov 2021 11:18:03 -0500
Received: from linux.microsoft.com ([13.77.154.182]:45870 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbhKNQSB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 14 Nov 2021 11:18:01 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 969A920C35F2;
        Sun, 14 Nov 2021 08:15:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 969A920C35F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636906507;
        bh=X6psgr8IIimAoDb415er2gByzlMAjh9kHi8G85RXHX0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mDPTsVgink3+0ruTibJnay+XhUQP+W7VAU43dPcmocnbs21yxIzvtufa6g2erU6OD
         IqNaC24ReiDHpHK0whGSVptBU+55QPcQyY5Hxquhm/RLxcrjOUlpmk6tWadfNYJCA+
         DD1MJvGByeVWR2WUGsKk/fjFcuQr45En17B4BW1o=
Subject: Re: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-2-madvenka@linux.microsoft.com>
 <20211022180243.GL86184@C02TD0UTHF1T.local>
 <20211112174405.GA5977@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <208a4149-306d-2115-cf1e-1035d61dc07f@linux.microsoft.com>
Date:   Sun, 14 Nov 2021 10:15:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211112174405.GA5977@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I reviewed the changes briefly. They look good. I will take a more detailed look this week.

Thanks for doing this!

Once this is part of v5.16-rc2, I will send out version 11 on top of that with the rest of
the patches in my series.

Madhavan

On 11/12/21 11:44 AM, Mark Rutland wrote:
> On Fri, Oct 22, 2021 at 07:02:43PM +0100, Mark Rutland wrote:
>> On Thu, Oct 14, 2021 at 09:58:37PM -0500, madvenka@linux.microsoft.com wrote:
>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>
>>> Currently, there are multiple functions in ARM64 code that walk the
>>> stack using start_backtrace() and unwind_frame() or start_backtrace()
>>> and walk_stackframe(). They should all be converted to use
>>> arch_stack_walk(). This makes maintenance easier.
>>>
>>> To do that, arch_stack_walk() must always be defined. arch_stack_walk()
>>> is within #ifdef CONFIG_STACKTRACE. So, select STACKTRACE in
>>> arch/arm64/Kconfig.
>>
>> I'd prefer if we could decouple ARCH_STACKWALK from STACKTRACE, so that
>> we don't have to expose /proc/*/stack unconditionally, which Peter
>> Zijlstra has a patch for:
>>
>>   https://lore.kernel.org/lkml/20211022152104.356586621@infradead.org/
>>
>> ... but regardless the rest of the series looks pretty good, so I'll go
>> review that, and we can figure out how to queue the bits and pieces in
>> the right order.
> 
> FWIW, it looks like the direction of travel there is not go and unify
> the various arch unwinders, but I would like to not depend on
> STACKTRACE. Regardless, the initial arch_stack_walk() cleanup patches
> all look good, so I reckon we should try to get those out of the way and
> queue those for arm64 soon even if we need some more back-and-forth over
> the later part of the series.
> 
> With that in mind, I've picked up Peter's patch decoupling
> ARCH_STACKWALK from STACKTRACE, and rebased the initial patches from
> this series atop. Since there's some subtltety in a few cases (and this
> was easy to miss while reviewing), I've expanded the commit messages
> with additional rationale as to why each transformation is safe.
> I've pushed that to:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/stacktrace/arch-stack-walk
> 
> There's a dependency on:
> 
>   https://lore.kernel.org/r/20211029162245.39761-1-mark.rutland@arm.com
> 
> ... which was queued for v5.16-rc1, but got dropped due to a conflict,
> and I'm expecting it to be re-queued as a fix for v5.16-rc2 shortly
> after v5.16-rc1 is tagged. Hopefully that means we have a table base by
> v5.16-rc2.
> 
> I'll send the preparatory series as I've prepared it shortly after
> v5.16-rc1 so that people can shout if I've messed something up.
> 
> Hopefully it's easy enough to use that as a base for the more involved
> rework later in this series.
> 
> Thanks,
> Mark.
> 
>> Thanks,
>> Mark.
>>
>>>
>>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>>> ---
>>>  arch/arm64/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index fdcd54d39c1e..bfb0ce60d820 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -35,6 +35,7 @@ config ARM64
>>>  	select ARCH_HAS_SET_DIRECT_MAP
>>>  	select ARCH_HAS_SET_MEMORY
>>>  	select ARCH_STACKWALK
>>> +	select STACKTRACE
>>>  	select ARCH_HAS_STRICT_KERNEL_RWX
>>>  	select ARCH_HAS_STRICT_MODULE_RWX
>>>  	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
>>> -- 
>>> 2.25.1
>>>
