Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175A749B54C
	for <lists+live-patching@lfdr.de>; Tue, 25 Jan 2022 14:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577724AbiAYNqE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Jan 2022 08:46:04 -0500
Received: from linux.microsoft.com ([13.77.154.182]:36176 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383903AbiAYNny (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Jan 2022 08:43:54 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5E17F20B6C61;
        Tue, 25 Jan 2022 05:43:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E17F20B6C61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1643118233;
        bh=pNSTEP0TRPy0j5oEkFezTz31lZK+4Yx3qQJpktHhUjs=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=QH0fuY0YhBO7vXSfmXGWSFbzJOgdLCyFhrYhzV8LZtGzmrvNybYSgEzDhld46vZ+q
         3KFYbxmbPXOQpmp5poOJK6Zb3Z2CU8rDW0ls7Xbl21fxkAsCTS7zXbISNDna+eunUc
         fzB0vE6t+hQelwlPCl4tEIT/f0a90+dP2KsEDVMY=
Message-ID: <825b8b72-c746-ba24-7142-3fff481e82d6@linux.microsoft.com>
Date:   Tue, 25 Jan 2022 07:43:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Content-Language: en-US
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
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
 <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I have not seen any activity on that in a long time. IIRC, Julien quit RedHat.
I don't know if anyone else has taken over this work in RedHat.

Sorry, I don't have any more information.

Madhavan

On 1/24/22 23:21, nobuta.keiya@fujitsu.com wrote:
> Hi Madhavan,
> 
>> Select HAVE_RELIABLE_STACKTRACE in arm64/Kconfig to allow
>> arch_stack_walk_reliable() to be used.
>>
>> Note that this is conditional upon STACK_VALIDATION which will be added when frame pointer validation is implemented (say
>> via objtool).
> 
> I know that Julien Thierry published objtool support for arm64 [1], but I'm not
> sure if it has been updated. Could you tell me other threads if you know?
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20210303170932.1838634-1-jthierry@redhat.com/
> 
> 
> Thanks,
> Keiya
> 
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index f6e333b59314..bc7b3514b563 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -223,6 +223,7 @@ config ARM64
>>  	select THREAD_INFO_IN_TASK
>>  	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
>>  	select TRACE_IRQFLAGS_SUPPORT
>> +	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && STACK_VALIDATION
>>  	help
>>  	  ARM 64-bit (AArch64) Linux support.
>>
>> --
>> 2.25.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
