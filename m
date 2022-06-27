Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185255B779
	for <lists+live-patching@lfdr.de>; Mon, 27 Jun 2022 07:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiF0FGx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 01:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiF0FGw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 01:06:52 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F30726EA;
        Sun, 26 Jun 2022 22:06:51 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2ED8420CD15E;
        Sun, 26 Jun 2022 22:06:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2ED8420CD15E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656306410;
        bh=ptE65eWw/KVf5Qv9m3tSe+Guw7shYAImcZXGyiZYlag=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PcaGdrYf2ecurMB+zVTYzcBYlK1W8lxfYe46xnDkz9Rdk1XDznscP4qL7Dm468bnV
         achw3aNfsJrb3r/0tj99oH90bMbZvQFgUbTA2bM26K9ui4Te5vY/Fi7PLD33y5Rkm9
         kYUZRsIvif3JNe5wFpsFFjCUuN9FQhU1O0UUQ1VA=
Message-ID: <8c64f0f4-be71-c462-5b74-34a4236265ae@linux.microsoft.com>
Date:   Mon, 27 Jun 2022 00:06:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 5/6] arm64: Create a list of SYM_CODE functions, check
 return PC against list
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-6-madvenka@linux.microsoft.com>
 <Yrgc/Z7uG29XihFg@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <Yrgc/Z7uG29XihFg@FVFF77S0Q05N>
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



On 6/26/22 03:46, Mark Rutland wrote:
> On Fri, Jun 17, 2022 at 04:07:16PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> SYM_CODE functions don't follow the usual calling conventions. Check if the
>> return PC in a stack frame falls in any of these. If it does, consider the
>> stack trace unreliable.
>>
>> Define a special section for unreliable functions
>> =================================================
>>
>> Define a SYM_CODE_END() macro for arm64 that adds the function address
>> range to a new section called "sym_code_functions".
>>
>> Linker file
>> ===========
>>
>> Include the "sym_code_functions" section under read-only data in
>> vmlinux.lds.S.
>>
>> Initialization
>> ==============
>>
>> Define an early_initcall() to create a sym_code_functions[] array from
>> the linker data.
>>
>> Unwinder check
>> ==============
>>
>> Add a reliability check in unwind_check_reliability() that compares a
>> return PC with sym_code_functions[]. If there is a match, then return
>> failure.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> Reviewed-by: Mark Brown <broonie@kernel.org>
>> ---
>>  arch/arm64/include/asm/linkage.h  | 11 +++++++
>>  arch/arm64/include/asm/sections.h |  1 +
>>  arch/arm64/kernel/stacktrace.c    | 55 +++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
>>  4 files changed, 77 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
>> index 43f8c25b3fda..d4058de4af78 100644
>> --- a/arch/arm64/include/asm/linkage.h
>> +++ b/arch/arm64/include/asm/linkage.h
>> @@ -39,4 +39,15 @@
>>  	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
>>  	bti c ;
>>  
>> +/*
>> + * Record the address range of each SYM_CODE function in a struct code_range
>> + * in a special section.
>> + */
>> +#define SYM_CODE_END(name)				\
>> +	SYM_END(name, SYM_T_NONE)			;\
>> +99:	.pushsection "sym_code_functions", "aw"		;\
>> +	.quad	name					;\
>> +	.quad	99b					;\
>> +	.popsection
>> +
>>  #endif
>> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
>> index 40971ac1303f..50cfd1083563 100644
>> --- a/arch/arm64/include/asm/sections.h
>> +++ b/arch/arm64/include/asm/sections.h
>> @@ -22,6 +22,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
>>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
>>  extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
>> +extern char __sym_code_functions_start[], __sym_code_functions_end[];
>>  
>>  static inline size_t entry_tramp_text_size(void)
>>  {
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index 5ef2ce217324..eda8581f7dbe 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -62,6 +62,31 @@ struct unwind_state {
>>  	bool reliable;
>>  };
>>  
>> +struct code_range {
>> +	unsigned long	start;
>> +	unsigned long	end;
>> +};
>> +
>> +static struct code_range	*sym_code_functions;
>> +static int			num_sym_code_functions;
>> +
>> +int __init init_sym_code_functions(void)
>> +{
>> +	size_t size = (unsigned long)__sym_code_functions_end -
>> +		      (unsigned long)__sym_code_functions_start;
>> +
>> +	sym_code_functions = (struct code_range *)__sym_code_functions_start;
>> +	/*
>> +	 * Order it so that sym_code_functions is not visible before
>> +	 * num_sym_code_functions.
>> +	 */
>> +	smp_mb();
>> +	num_sym_code_functions = size / sizeof(struct code_range);
>> +
>> +	return 0;
>> +}
>> +early_initcall(init_sym_code_functions);
> 
> There's no reason to need an initcall for this; we can iterate over this
> directly using __sym_code_functions_start and __sym_code_functions_end, like we
> do for exception tables today.
> 
> For example:
> 
> static inline bool pc_is_sym_code(unsigned long pc)
> {
> 	extern struct code_range *__sym_code_functions_start;
> 	extern struct code_range *__sym_code_functions_end;
> 
> 	struct code_range *r;
> 
> 	for (r = __sym_code_functions_start; r < __sym_code_functions_end; r++) {
> 		if (pc >= r->start && pc < r->end)
> 			return true;
> 	}
> 
> 	return false;
> }
> 

OK.

However, I have decided to hold off on the reliability checks until we have the right
structure in the unwind code. I am also trying to address the question of reliability
with a single FP check in my FP validation series.

So, for now, I will remove the reliability checks part of the patch series.

Thanks for the review though. It will be useful when I revisit this in the future and
resend.

Thanks.

Madhavan
