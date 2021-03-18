Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6560340F06
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 21:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhCRU0W (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 16:26:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:46208 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhCRU0P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 16:26:15 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 07B2C209C385;
        Thu, 18 Mar 2021 13:26:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 07B2C209C385
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616099174;
        bh=SErigyigsB0CpeFt4XrJIuybAQdBkzUzy9hIoufBLVI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZrFg9y5qLvRUHYY1YNzQUvIM046vnG2grx/rbBeb1HEIh+Km+1V1A8PJjCyRTtwwm
         +kcZcaQeEx4bR4vMvgv4uf4VePkcFT44JZvSs7O+HvmhY5aPe+HaKvw6BaNYC0j/oP
         Dg3myggTvd9jAj8y4mi+wAdCj/vOjmb0qmH1QIIQ=
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
 <20210318150905.GL5469@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
Date:   Thu, 18 Mar 2021 15:26:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318150905.GL5469@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/18/21 10:09 AM, Mark Brown wrote:
> On Mon, Mar 15, 2021 at 11:57:53AM -0500, madvenka@linux.microsoft.com wrote:
> 
>> In summary, task pt_regs->stackframe is where a successful stack trace ends.
> 
>>         .if \el == 0
>> -       mov     x29, xzr
>> +       stp     xzr, xzr, [sp, #S_STACKFRAME]
>>         .else
>>         stp     x29, x22, [sp, #S_STACKFRAME]
>> -       add     x29, sp, #S_STACKFRAME
>>         .endif
>> +       add     x29, sp, #S_STACKFRAME
> 
> For both user and kernel threads this patch (at least by itself) results
> in an additional record being reported in stack traces with a NULL
> function pointer since it keeps the existing record where it is and adds
> this new fixed record below it.  This is addressed for the kernel later
> in the series, by "arm64: Terminate the stack trace at TASK_FRAME and
> EL0_FRAME", but will still be visible to other unwinders such as
> debuggers.  I'm not sure that this *matters* but it might and should at
> least be called out more explicitly.
> 
> If we are going to add the extra record there would probably be less
> potential for confusion if we pointed it at some sensibly named dummy
> function so anything or anyone that does see it on the stack doesn't get
> confused by a NULL.
> 

I agree. I will think about this some more. If no other solution presents
itself, I will add the dummy function.

Madhavan

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
