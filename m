Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C4C43CE7C
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhJ0QRu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 12:17:50 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53142 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhJ0QRt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 12:17:49 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5B2512034CB7;
        Wed, 27 Oct 2021 09:15:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B2512034CB7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635351324;
        bh=DvIwhXdeH0bKthXRzPqStEFs19Q8Pn9BY0Ld8zgL3BA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tExYXoo54lVvG2m6Ei1Z/rvIH8DX7KSn7e7FJnYb/wud1mywvbC++w632dhi1ppW7
         VmHSyylStge+1aY7qGAPA8IYjhkNq+9IdEWQaGDXAeYieMmPcflbu4ksDXHhGImpNk
         oFhj3OlytJaJSJV9WNeVlRKtLJkkMGGC8/2+ksXE=
Subject: Re: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-7-madvenka@linux.microsoft.com>
 <20211027133212.GG54628@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bc165886-3939-a5e5-b905-23f9a2f3e0f8@linux.microsoft.com>
Date:   Wed, 27 Oct 2021 11:15:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211027133212.GG54628@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/27/21 8:32 AM, Mark Rutland wrote:
> On Thu, Oct 14, 2021 at 09:58:42PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, profile_pc() in ARM64 code walks the stack using
>> start_backtrace() and unwind_frame(). Make it use arch_stack_walk()
>> instead. This makes maintenance easier.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/time.c | 22 +++++++++++++---------
>>  1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>> index eebbc8d7123e..671b3038a772 100644
>> --- a/arch/arm64/kernel/time.c
>> +++ b/arch/arm64/kernel/time.c
>> @@ -32,22 +32,26 @@
>>  #include <asm/stacktrace.h>
>>  #include <asm/paravirt.h>
>>  
>> +static bool profile_pc_cb(void *arg, unsigned long pc)
>> +{
>> +	unsigned long *prof_pc = arg;
>> +
>> +	if (in_lock_functions(pc))
>> +		return true;
>> +	*prof_pc = pc;
>> +	return false;
>> +}
>> +
>>  unsigned long profile_pc(struct pt_regs *regs)
>>  {
>> -	struct stackframe frame;
>> +	unsigned long prof_pc = 0;
>>  
>>  	if (!in_lock_functions(regs->pc))
>>  		return regs->pc;
> 
> This can go -- the first call to profile_pc_cb() will use regs->pc.
> 

Agreed.

> With that gone, and the include updates to use <linux/stacktrace.h>:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 

I will make the two changes.

Madhavan
