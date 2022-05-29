Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC5E537188
	for <lists+live-patching@lfdr.de>; Sun, 29 May 2022 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiE2Pge (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 29 May 2022 11:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiE2Pgd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 29 May 2022 11:36:33 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE256BF78;
        Sun, 29 May 2022 08:36:32 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id ADE7620BA5BE;
        Sun, 29 May 2022 08:36:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ADE7620BA5BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653838592;
        bh=ROb/W/+2IsIw99UuNX/wvckTYE+xEoi+uH7gZDy4cXY=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=an5IEXSZmn1efYGvhIMQvq9/f9ZuUi9v5rC3SmrLUsSoW+56mQGsMUFPwSV4T6PcM
         uqzKZFVpUESsFTgkg5K8PI1LbBxufNocS0EGYCIq/CZ6TUjk2UpEBTfKiumi0Zqp8Z
         7FYeCTJxgsiCBulx+ZYsy4CKzcDMgjICBukMxrzY=
Message-ID: <c42112ac-5606-347f-dfe7-ef941b77c6a5@linux.microsoft.com>
Date:   Sun, 29 May 2022 10:36:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 05/20] objtool: Reorganize ORC types
Content-Language: en-US
To:     Chen Zhongjin <chenzhongjin@huawei.com>, jpoimboe@redhat.com,
        peterz@infradead.org, mark.rutland@arm.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-6-madvenka@linux.microsoft.com>
 <ab3533a6-cb60-b553-e140-40b87fc09428@huawei.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ab3533a6-cb60-b553-e140-40b87fc09428@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

See my responses inline...

On 5/24/22 09:27, Chen Zhongjin wrote:
> 
> 
> On 2022/5/24 8:16, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The ORC code needs to be reorganized into arch-specific and generic parts
>> so that architectures other than X86 can use the generic parts.
>>
>> orc_types.h contains the following ORC definitions shared between objtool
>> and the kernel:
>>
>> 	- ORC register definitions which are arch-specific.
>> 	- orc_entry structure which is generic.
> ...
>> diff --git a/include/linux/orc_entry.h b/include/linux/orc_entry.h
>> new file mode 100644
>> index 000000000000..3d49e3b9dabe
>> --- /dev/null
>> +++ b/include/linux/orc_entry.h
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
>> + * This struct is more or less a vastly simplified version of the DWARF Call
>> + * Frame Information standard.  It contains only the necessary parts of DWARF
>> + * CFI, simplified for ease of access by the in-kernel unwinder.  It tells the
>> + * unwinder how to find the previous SP and BP (and sometimes entry regs) on
>> + * the stack for a given code address.  Each instance of the struct corresponds
>> + * to one or more code locations.
>> + */
>> +struct orc_entry {
>> +	s16		sp_offset;
>> +	s16		fp_offset;
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +	unsigned	sp_reg:4;
>> +	unsigned	fp_reg:4;
> Are sp_reg & fp_reg & end needed? I noticed that they are not used in
> reliability checking.

Yeah. The ORC entry structure is a superset of what I need for ARM64. But X86 requires all of it.
(Although I think "end" is not needed anymore).

And, other architectures might require all of it. So, I am keeping it as is.

> 
>> +	unsigned	type:3;
>> +	unsigned	end:1;
>> +#elif defined(__BIG_ENDIAN_BITFIELD)
>> +	unsigned	fp_reg:4;
>> +	unsigned	sp_reg:4;
>> +	unsigned	unused:4;
>> +	unsigned	end:1;
>> +	unsigned	type:3;
>> +#endif
>> +} __packed;
>> +
>> +#endif /* __ASSEMBLY__ */
>> +
>> +#endif /* _ORC_ENTRY_H */

Thanks!

Madhavan
