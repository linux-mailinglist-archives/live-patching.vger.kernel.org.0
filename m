Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35304383B5
	for <lists+live-patching@lfdr.de>; Sat, 23 Oct 2021 14:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhJWMyL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 23 Oct 2021 08:54:11 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55582 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhJWMyL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 23 Oct 2021 08:54:11 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 66C032063658;
        Sat, 23 Oct 2021 05:51:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 66C032063658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634993512;
        bh=RdTHdq2wYecLPNsH3yc13xGJJ4ejMJTIX+ByLhv3VSk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fY62T29GRFOFNOt69w9wl8U9BzW+9fyDV+vhzs44GQvTi70UrYD6MfnSabWGKR+eF
         fl8jnJLiXFyvQWlr7rRomiaeyBvPpbj9FxVN2hxxT/if4csTIGPvHo6YEqhyIBPD+z
         8zF5sTnRY8ZsP/ucSA6Mv/f0NE5qlt+Od8U843co=
Subject: Re: [PATCH v10 04/11] arm64: Make return_address() use
 arch_stack_walk()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-5-madvenka@linux.microsoft.com>
 <20211022185148.GA91654@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <9986ddf4-d992-ffd8-7032-a18fdbdb7bb1@linux.microsoft.com>
Date:   Sat, 23 Oct 2021 07:51:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022185148.GA91654@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/22/21 1:51 PM, Mark Rutland wrote:
> On Thu, Oct 14, 2021 at 09:58:40PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, return_address() in ARM64 code walks the stack using
>> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
>> instead. This makes maintenance easier.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/return_address.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
>> index a6d18755652f..92a0f4d434e4 100644
>> --- a/arch/arm64/kernel/return_address.c
>> +++ b/arch/arm64/kernel/return_address.c
>> @@ -35,15 +35,11 @@ NOKPROBE_SYMBOL(save_return_addr);
>>  void *return_address(unsigned int level)
>>  {
>>  	struct return_address_data data;
>> -	struct stackframe frame;
>>  
>>  	data.level = level + 2;
>>  	data.addr = NULL;
>>  
>> -	start_backtrace(&frame,
>> -			(unsigned long)__builtin_frame_address(0),
>> -			(unsigned long)return_address);
>> -	walk_stackframe(current, &frame, save_return_addr, &data);
>> +	arch_stack_walk(save_return_addr, &data, current, NULL);
> 
> This looks equivalent to me. Previously the arguments to
> start_backtrace() meant that walk_stackframe would report
> return_address(), then the caller of return_address(), and so on. As
> arch_stack_walk() starts from its immediate caller (i.e.
> return_address()), that should result in the same trace.
> 
> It would be nice if we could note something to that effect in the commit
> message.
> 

Will do.

> I had a play with ftrace, which uses return_address(), and that all
> looks sound.
> 

Thanks a lot!

>>  
>>  	if (!data.level)
>>  		return data.addr;
> 
> The end of this function currently does:
> 
> 	if (!data.level)
> 		return data.addr;
> 	else
> 		return NULL;
> 
> ... but since we initialize data.addr to NULL, and save_return_addr()
> only writes to data.addr when called at the correct level, we can
> simplify that to:
> 
> 	return data.addr;
> 

OK. I will make this change.

> Regardles of that cleanup:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> 

Thanks a lot!

> I'll continue reviewing the series next week.
> 

Great!

Madhavan
