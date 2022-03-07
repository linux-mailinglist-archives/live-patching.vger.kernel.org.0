Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0FA4D048E
	for <lists+live-patching@lfdr.de>; Mon,  7 Mar 2022 17:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiCGQwf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Mar 2022 11:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCGQwe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Mar 2022 11:52:34 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2ED3F66FB4;
        Mon,  7 Mar 2022 08:51:40 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0B8AA20B7178;
        Mon,  7 Mar 2022 08:51:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B8AA20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646671899;
        bh=JQmaJ6+1WVAcZ6MJzqpqjZ1DNV3GaZkH13UClOQhBpg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ue1hmS3Gsyah9sI5cZDAOXzVc5lVCKCI8ifJyo6A/0g7bAQHQzeRQieWTOBWf6i4u
         Xd9FVWGerNtpa5E5BfK3JVqgrU3Pdw34AV8f+mXk6C9/wsDgp6EqQyG8cuajqr7bMI
         eO6K7351xZTqISQNNQpDI2p/XgP6mm2BsyrTJuuQ=
Message-ID: <845e4589-97d9-5371-3a0e-f6e05919f32d@linux.microsoft.com>
Date:   Mon, 7 Mar 2022 10:51:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hey Mark Rutland, Mark Brown,

Could you please review the rest of the patches in the series when you can?

Also, many of the patches have received a Reviewed-By from you both. So, after I send the next version out, can we upstream those ones?

Thanks.

Madhavan

On 2/15/22 07:39, Mark Rutland wrote:
> On Mon, Jan 17, 2022 at 08:56:03AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Rename the arguments to unwind() for better consistency. Also, use the
>> typedef stack_trace_consume_fn for the consume_entry function as it is
>> already defined in linux/stacktrace.h.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> How about: 
> 
> | arm64: align with common stracktrace naming
> |
> | For historical reasons, the naming of parameters and their types in the arm64
> | stacktrace code differs from that used in generic code and other
> | architectures, even though the types are equivalent.
> |
> | For consistency and clarity, use the generic names.
> 
> Either way:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 
> Mark.
> 
>> ---
>>  arch/arm64/kernel/stacktrace.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index 1b32e55735aa..f772dac78b11 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -181,12 +181,12 @@ static int notrace unwind_next(struct unwind_state *state)
>>  NOKPROBE_SYMBOL(unwind_next);
>>  
>>  static void notrace unwind(struct unwind_state *state,
>> -			   bool (*fn)(void *, unsigned long), void *data)
>> +			   stack_trace_consume_fn consume_entry, void *cookie)
>>  {
>>  	while (1) {
>>  		int ret;
>>  
>> -		if (!fn(data, state->pc))
>> +		if (!consume_entry(cookie, state->pc))
>>  			break;
>>  		ret = unwind_next(state);
>>  		if (ret < 0)
>> -- 
>> 2.25.1
>>
