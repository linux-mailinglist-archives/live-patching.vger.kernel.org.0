Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792653ABBE5
	for <lists+live-patching@lfdr.de>; Thu, 17 Jun 2021 20:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFQSeV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Jun 2021 14:34:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45086 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhFQSeS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Jun 2021 14:34:18 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 596D320B83DE;
        Thu, 17 Jun 2021 11:32:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 596D320B83DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623954730;
        bh=LUzAs8YwcV9OEjtCvxPMYvniuVgxNyeebthHhcHDNUQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kD5E+KGp4yOxOp+fj4nhFGdWt11PntzW4A2NBd2U7SL9Wq6IYTKJGhJ2Llf3RGlH6
         BUxM+DWFZ1d/2vXkeI7mU0HYUo1l0qw6abtjuebcP7c7ZP9BRSkYZk76H7PkkJQvil
         0x+dEVwDwzioelIYxXPSSVJu8UuooGch59mPIrMI=
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "duwe@lst.de" <duwe@lst.de>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20210604235930.603-1-surajjs@amazon.com>
 <TYAPR01MB526348C06BB8E410DF8CE3D3850E9@TYAPR01MB5263.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <7080d2a9-6ec2-94e9-3577-e5f7233ad3ab@linux.microsoft.com>
Date:   Thu, 17 Jun 2021 13:32:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <TYAPR01MB526348C06BB8E410DF8CE3D3850E9@TYAPR01MB5263.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/17/21 4:29 AM, nobuta.keiya@fujitsu.com wrote:
> 
>> It's my understanding that the two pieces of work required to enable live
>> patching on arm are in flight upstream;
>> - Reliable stack traces as implemented by Madhavan T. Venkataraman [1]
>> - Objtool as implemented by Julien Thierry [2]
>>
>> This is the remaining part required to enable live patching on arm.
>> Based on work by Torsten Duwe [3]
>>
>> Allocate a task flag used to represent the patch pending state for the
>> task. Also implement generic functions klp_arch_set_pc() &
>> klp_get_ftrace_location().
>>
>> In klp_arch_set_pc() it is sufficient to set regs->pc as in
>> ftrace_common_return() the return address is loaded from the stack.
>>
>> ldr     x9, [sp, #S_PC]
>> <snip>
>> ret     x9
>>
>> In klp_get_ftrace_location() it is necessary to advance the address by
>> AARCH64_INSN_SIZE (4) to point to the BL in the callsite as 2 nops were
>> placed at the start of the function, one to be patched to save the LR and
>> another to be patched to branch to the ftrace call, and
>> klp_get_ftrace_location() is expected to return the address of the BL. It
>> may also be necessary to advance the address by another AARCH64_INSN_SIZE
>> if CONFIG_ARM64_BTI_KERNEL is enabled due to the instruction placed at the
>> branch target to satisfy BTI,
>>
>> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
>>
>> [1] https://lkml.org/lkml/2021/5/26/1212
>> [2] https://lkml.org/lkml/2021/3/3/1135
>> [3] https://lkml.org/lkml/2018/10/26/536
>> ---
> 
> AFAIU Madhavan's patch series linked in the above [1] is currently awaiting
> review by Mark Rutland. It seems that not only this patch series but also the
> implementation of arch_stack_walk_reliable() at the below link is required
> to enable livepatch.
> 

Yes. I have a patch ready for that. But I can submit that only after the previous
series has been accepted.

Thanks

Madhavan
