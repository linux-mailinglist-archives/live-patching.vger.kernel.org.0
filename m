Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFD543CE66
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 18:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhJ0QNS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 12:13:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52610 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242946AbhJ0QMy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 12:12:54 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5CF082034CB2;
        Wed, 27 Oct 2021 09:10:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5CF082034CB2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635351029;
        bh=KPTUkYPm4k91ndaje5wemec3HSxDBjpY1g+uVBjvLeI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=nA0OuFiMFY5cSanBoeqPKPrT1BxaPwRNv3n+3EZV9TuVewEtkeCjK0IWNiim6UcvI
         y5O+1hekcSe6kYxc5A0Yq0c2tDUUujMh+Jg1TtjRB34Erzxap/hYGFRftpXiTH+U6+
         1mFeMQ+VOPTQfbNWaUpccTrjEr48BjzgUCi3cwh8=
Subject: Re: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-7-madvenka@linux.microsoft.com>
 <TY2PR01MB5257A65FD9D19AE3516D447285839@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <4af5d1e4-75cc-f5a6-8552-5a2f0f631724@linux.microsoft.com>
Date:   Wed, 27 Oct 2021 11:10:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB5257A65FD9D19AE3516D447285839@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/24/21 9:18 PM, nobuta.keiya@fujitsu.com wrote:
> Hi,
> 
>> -----Original Message-----
>> From: madvenka@linux.microsoft.com <madvenka@linux.microsoft.com>
>> Sent: Friday, October 15, 2021 11:59 AM
>> To: mark.rutland@arm.com; broonie@kernel.org; jpoimboe@redhat.com; ardb@kernel.org; Nobuta, Keiya/信田 圭哉
>> <nobuta.keiya@fujitsu.com>; sjitindarsingh@gmail.com; catalin.marinas@arm.com; will@kernel.org; jmorris@namei.org;
>> linux-arm-kernel@lists.infradead.org; live-patching@vger.kernel.org; linux-kernel@vger.kernel.org;
>> madvenka@linux.microsoft.com
>> Subject: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
>>
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, profile_pc() in ARM64 code walks the stack using
>> start_backtrace() and unwind_frame(). Make it use arch_stack_walk() instead. This makes maintenance easier.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/time.c | 22 +++++++++++++---------
>>  1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c index eebbc8d7123e..671b3038a772 100644
>> --- a/arch/arm64/kernel/time.c
>> +++ b/arch/arm64/kernel/time.c
>> @@ -32,22 +32,26 @@
>>  #include <asm/stacktrace.h>
>>  #include <asm/paravirt.h>
>>
>> +static bool profile_pc_cb(void *arg, unsigned long pc) {
>> +	unsigned long *prof_pc = arg;
>> +
>> +	if (in_lock_functions(pc))
>> +		return true;
>> +	*prof_pc = pc;
>> +	return false;
>> +}
>> +
>>  unsigned long profile_pc(struct pt_regs *regs)  {
>> -	struct stackframe frame;
>> +	unsigned long prof_pc = 0;
>>
>>  	if (!in_lock_functions(regs->pc))
>>  		return regs->pc;
>>
>> -	start_backtrace(&frame, regs->regs[29], regs->pc);
>> -
>> -	do {
>> -		int ret = unwind_frame(NULL, &frame);
>> -		if (ret < 0)
>> -			return 0;
>> -	} while (in_lock_functions(frame.pc));
>> +	arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
>>
>> -	return frame.pc;
>> +	return prof_pc;
>>  }
>>  EXPORT_SYMBOL(profile_pc);
>>
>> --
>> 2.25.1
> 
> 
> I've got build error with CONFIG_ACPI=n:
> ====
> arch/arm64/kernel/time.c: In function 'profile_pc':
> arch/arm64/kernel/time.c:52:2: error: implicit declaration of function 'arch_stack_walk' [-Werror=implicit-function-declaration]
>    52 |  arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
>       |  ^~~~~~~~~~~~~~~
> ====
> 
> I think it should include <linux/stacktrace.h> instead of <asm/stacktrace.h>.
> 

OK. I will fix this.
Thanks for catching this.

Madhavan
