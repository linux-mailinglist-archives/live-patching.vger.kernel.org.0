Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5B6AC89E
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjCFQrc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 11:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjCFQrQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 11:47:16 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C991E3346F;
        Mon,  6 Mar 2023 08:46:26 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.203.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 517FE205749B;
        Mon,  6 Mar 2023 08:45:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 517FE205749B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678121136;
        bh=YcoUX/2qCqQPDCK8IDInDMDtWaFz8e9Rpcguu9pOTXA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=AbSR297bn4+I8KzkRz4bWpbyUjbUXiqyASy4lnrB1mbWoAOk/yIwxcwXM+DJ0gZiC
         +3Da6g/iUzzT8StKd/poDk8elU50gtLAlx8i7X9csedOsCz6zFAoBrF1LrzXdlghPm
         vTGo0wyIDb2MY+Syh0lpS6mkMv2PCBTEASr1xnoI=
Message-ID: <aa63d868-d97a-cfec-27c1-13ac9e74e584@linux.microsoft.com>
Date:   Mon, 6 Mar 2023 10:45:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 05/22] objtool: Reorganize ORC types
Content-Language: en-US
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <20230202074036.507249-6-madvenka@linux.microsoft.com>
 <a1b83a8d621e37310194c0c32b9d847a0952d282.camel@gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <a1b83a8d621e37310194c0c32b9d847a0952d282.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Sorry for the delay in responding to your comments. I was out sick.
Please find my responses inline.

On 2/18/23 03:30, Suraj Jitindar Singh wrote:
> On Thu, 2023-02-02 at 01:40 -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The ORC code needs to be reorganized into arch-specific and generic
>> parts
>> so that architectures other than X86 can use the generic parts.
>>
>> orc_types.h contains the following ORC definitions shared between
>> objtool
>> and the kernel:
>>
>> 	- ORC register definitions which are arch-specific.
>> 	- orc_entry structure which is generic.
>>
>> Move orc_entry into a new file include/linux/orc_entry.h. Also, the
>> field
>> names bp_reg and bp_offset in struct orc_entry are x86-specific.
>> Change
>> them to fp_reg and fp_offset. FP stands for frame pointer.
>>
>> Currently, the type field in orc_entry is only 2 bits. For other
>> architectures, we will need more. So, expand this to 3 bits.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com
>>>
>> ---
>>  arch/x86/include/asm/orc_types.h       | 37 +++++-------------------
>>  include/linux/orc_entry.h              | 39
>> ++++++++++++++++++++++++++
>>  tools/arch/x86/include/asm/orc_types.h | 37 +++++-------------------
>>  tools/include/linux/orc_entry.h        | 39
>> ++++++++++++++++++++++++++
>>  tools/objtool/orc_gen.c                |  4 +--
>>  tools/objtool/sync-check.sh            |  1 +
>>  6 files changed, 95 insertions(+), 62 deletions(-)
>>  create mode 100644 include/linux/orc_entry.h
>>  create mode 100644 tools/include/linux/orc_entry.h
>>
> 
> [snip]
> 
>> diff --git a/tools/include/linux/orc_entry.h
>> b/tools/include/linux/orc_entry.h
>> new file mode 100644
>> index 000000000000..3d49e3b9dabe
>> --- /dev/null
>> +++ b/tools/include/linux/orc_entry.h
>> @@ -0,0 +1,39 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Copyright (C) 2017 Josh Poimboeuf <jpoimboe@redhat.com>
>> + */
>> +
>> +#ifndef _ORC_ENTRY_H
>> +#define _ORC_ENTRY_H
>> +
>> +#ifndef __ASSEMBLY__
>> +#include <asm/byteorder.h>
>> +
>> +/*
>> + * This struct is more or less a vastly simplified version of the
>> DWARF Call
>> + * Frame Information standard.  It contains only the necessary parts
>> of DWARF
>> + * CFI, simplified for ease of access by the in-kernel unwinder.  It
>> tells the
>> + * unwinder how to find the previous SP and BP (and sometimes entry
>> regs) on
>> + * the stack for a given code address.  Each instance of the struct
>> corresponds
>> + * to one or more code locations.
>> + */
>> +struct orc_entry {
>> +	s16		sp_offset;
>> +	s16		fp_offset;
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +	unsigned	sp_reg:4;
>> +	unsigned	fp_reg:4;
>> +	unsigned	type:3;
>> +	unsigned	end:1;
>> +#elif defined(__BIG_ENDIAN_BITFIELD)
>> +	unsigned	fp_reg:4;
>> +	unsigned	sp_reg:4;
>> +	unsigned	unused:4;
>> +	unsigned	end:1;
>> +	unsigned	type:3;
>> +#
> 
> nit:
> I believe you also need to update fp_reg/bp_offset -> fp_reg/fp_offset
> in orc_dump() in orc_dump.c
> 

OK. Will do.

Madhavan
> - Suraj
> 
>> +
>> +#endif /* __ASSEMBLY__ */
>> +
>> +#endif /* _ORC_ENTRY_H */
>> diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
>> index dd3c64af9db2..68c317daadbf 100644
>> --- a/tools/objtool/orc_gen.c
>> +++ b/tools/objtool/orc_gen.c
>> @@ -98,7 +98,7 @@ static int write_orc_entry(struct elf *elf, struct
>> section *orc_sec,
>>  	orc = (struct orc_entry *)orc_sec->data->d_buf + idx;
>>  	memcpy(orc, o, sizeof(*orc));
>>  	orc->sp_offset = bswap_if_needed(orc->sp_offset);
>> -	orc->bp_offset = bswap_if_needed(orc->bp_offset);
>> +	orc->fp_offset = bswap_if_needed(orc->fp_offset);
>>  
>>  	/* populate reloc for ip */
>>  	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int),
>> R_X86_64_PC32,
>> @@ -149,7 +149,7 @@ int orc_create(struct objtool_file *file)
>>  
>>  	struct orc_entry null = {
>>  		.sp_reg  = ORC_REG_UNDEFINED,
>> -		.bp_reg  = ORC_REG_UNDEFINED,
>> +		.fp_reg  = ORC_REG_UNDEFINED,
>>  		.type    = UNWIND_HINT_TYPE_CALL,
>>  	};
>>  
>> diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-
>> check.sh
>> index ee49b4e9e72c..ef1acb064605 100755
>> --- a/tools/objtool/sync-check.sh
>> +++ b/tools/objtool/sync-check.sh
>> @@ -18,6 +18,7 @@ arch/x86/include/asm/unwind_hints.h
>>  arch/x86/lib/x86-opcode-map.txt
>>  arch/x86/tools/gen-insn-attr-x86.awk
>>  include/linux/static_call_types.h
>> +include/linux/orc_entry.h
>>  "
>>  
>>  SYNC_CHECK_FILES='
