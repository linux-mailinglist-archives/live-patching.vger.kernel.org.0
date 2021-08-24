Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08C73F683C
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhHXRlk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 13:41:40 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38164 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242156AbhHXRjM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:12 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id EC1F720B85E8;
        Tue, 24 Aug 2021 10:38:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC1F720B85E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629826707;
        bh=R6YgY1J4gD2s66MsoljAfldZ8VnigpmKriT610HRPkU=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=D8lpOYe/w8+XekYIkMuGN2ml0DXIA/rRNfpe25N549BSWSVkYpTaqKMxVniIa/IdI
         PeQdYBq1e27VHs5DsxVy62nrlNWX0FRFLQ9EbbwhlraKxJ1EB+1z/xPpSaQMdJ0Xfg
         9pNJMx7tdilmCXyFIoXwoCE17pO1aBz93QBxtNEc=
Subject: Re: [RFC PATCH v8 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-2-madvenka@linux.microsoft.com>
 <20210824131344.GE96738@C02TD0UTHF1T.local>
 <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
Message-ID: <66d0ff83-bf67-5576-4c74-10f825855091@linux.microsoft.com>
Date:   Tue, 24 Aug 2021 12:38:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



>>> diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
>>> index a6d18755652f..92a0f4d434e4 100644
>>> --- a/arch/arm64/kernel/return_address.c
>>> +++ b/arch/arm64/kernel/return_address.c
>>> @@ -35,15 +35,11 @@ NOKPROBE_SYMBOL(save_return_addr);
>>>  void *return_address(unsigned int level)
>>>  {
>>>  	struct return_address_data data;
>>> -	struct stackframe frame;
>>>  
>>>  	data.level = level + 2;
>>>  	data.addr = NULL;
>>>  
>>> -	start_backtrace(&frame,
>>> -			(unsigned long)__builtin_frame_address(0),
>>> -			(unsigned long)return_address);
>>> -	walk_stackframe(current, &frame, save_return_addr, &data);
>>> +	arch_stack_walk(save_return_addr, &data, current, NULL);
>>>  
>>>  	if (!data.level)
>>>  		return data.addr;
>>
>> Nor that arch_stack_walk() will start with it's caller, so
>> return_address() will be included in the trace where it wasn't
>> previously, which implies we need to skip an additional level.
>>
> 
> You are correct. I will fix this. Thanks for catching this.
> 
>> That said, I'm not entirely sure why we need to skip 2 levels today; it
>> might be worth checking that's correct.
>>
> 
> AFAICT, return_address() acts like builtin_return_address(). That is, it
> returns the address of the caller. If func() calls return_address(),
> func() wants its caller's address. So, return_address() and func() need to
> be skipped.
> 
> I will change it to skip 3 levels instead of 2.
> 

Actually, I take that back. I remember now. return_address() used to start
with PC=return_address(). That is, it used to start with itself. arch_stack_walk()
starts with its caller which, in this case, is return_address(). So, I don't need
to change anything.

Do you agree?

Madhavan
