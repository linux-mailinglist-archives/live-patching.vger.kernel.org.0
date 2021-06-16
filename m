Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294063A98E4
	for <lists+live-patching@lfdr.de>; Wed, 16 Jun 2021 13:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFPLMp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Jun 2021 07:12:45 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35926 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFPLMo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Jun 2021 07:12:44 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id D8DCE20B6C50;
        Wed, 16 Jun 2021 04:10:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D8DCE20B6C50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623841838;
        bh=WUztDHkRTHMvJT4FbhrMu1omm7Qd16h31ex9As3+QBk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=RuhaHoW4wskuJllTYrUI5HXLIHDc2rQajM4zq7x/Ly2YWl8D0BGfSZH5xwaNy/9GC
         4NwKPLa2flFfs40lGzufd1Zg51BjhDIy7BGbDrjBxXb44DUtdett3ldRCrVQ9ZUZ2N
         xiZPhS0gLufvNqSTAxqShGWcuiXofBQk3atkSKik=
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-3-madvenka@linux.microsoft.com>
 <712b44d2af8f8cd3199aad87eb3bc94ea22d6f4a.camel@gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <b169a4d6-152a-4853-e465-909f3bba2878@linux.microsoft.com>
Date:   Wed, 16 Jun 2021 06:10:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <712b44d2af8f8cd3199aad87eb3bc94ea22d6f4a.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/15/21 8:52 PM, Suraj Jitindar Singh wrote:
> On Wed, 2021-05-26 at 16:49 -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The unwinder should check if the return PC falls in any function that
>> is considered unreliable from an unwinding perspective. If it does,
>> mark the stack trace unreliable.
>>
> 
> [snip]
> 
> Correct me if I'm wrong, but do you not need to move the final frame
> check to before the unwinder_is_unreliable() call?
> 

That is done in a patch series that has been merged into for-next/stacktrace branch.
When I merge this patch series with that, the final frame check will be done prior.

I have mentioned this in the cover letter:

Last stack frame
================

If a SYM_CODE function occurs in the very last frame in the stack trace,
then the stack trace is not considered unreliable. This is because there
is no more unwinding to do. Examples:

        - EL0 exception stack traces end in the top level EL0 exception
          handlers.

        - All kernel thread stack traces end in ret_from_fork().

Madhavan

> Userland threads which have ret_from_fork as the last entry on the
> stack will always be marked unreliable as they will always have a
> SYM_CODE entry on their stack (the ret_from_fork).
> 


> Also given that this means the last frame has been reached and as such
> there's no more unwinding to do, I don't think we care if the last pc
> is a code address.
> 
> - Suraj
> 
>>   *
>> @@ -133,7 +236,20 @@ int notrace unwind_frame(struct task_struct
>> *tsk, struct stackframe *frame)
>>  	 *	- Foreign code (e.g. EFI runtime services)
>>  	 *	- Procedure Linkage Table (PLT) entries and veneer
>> functions
>>  	 */
>> -	if (!__kernel_text_address(frame->pc))
>> +	if (!__kernel_text_address(frame->pc)) {
>> +		frame->reliable = false;
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * If the final frame has been reached, there is no more
>> unwinding
>> +	 * to do. There is no need to check if the return PC is
>> considered
>> +	 * unreliable by the unwinder.
>> +	 */
>> +	if (!frame->fp)
>> +		return 0;
> 
> if (frame->fp == (unsigned long)task_pt_regs(tsk)->stackframe)
> 	return -ENOENT;
> 
>> +
>> +	if (unwinder_is_unreliable(frame->pc))
>>  		frame->reliable = false;
>>  
>>  	return 0;
>> diff --git a/arch/arm64/kernel/vmlinux.lds.S
>> b/arch/arm64/kernel/vmlinux.lds.S
>> index 7eea7888bb02..32e8d57397a1 100644
>> --- a/arch/arm64/kernel/vmlinux.lds.S
>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>> @@ -103,6 +103,12 @@ jiffies = jiffies_64;
>>  #define TRAMP_TEXT
>>  #endif
>>  
>> +#define SYM_CODE_FUNCTIONS                                     \
>> +       . = ALIGN(16);                                           \
>> +       __sym_code_functions_start = .;                         \
>> +       KEEP(*(sym_code_functions))                             \
>> +       __sym_code_functions_end = .;
>> +
>>  /*
>>   * The size of the PE/COFF section that covers the kernel image,
>> which
>>   * runs from _stext to _edata, must be a round multiple of the
>> PE/COFF
>> @@ -218,6 +224,7 @@ SECTIONS
>>  		CON_INITCALL
>>  		INIT_RAM_FS
>>  		*(.init.altinstructions .init.bss)	/* from the
>> EFI stub */
>> +               SYM_CODE_FUNCTIONS
>>  	}
>>  	.exit.data : {
>>  		EXIT_DATA
