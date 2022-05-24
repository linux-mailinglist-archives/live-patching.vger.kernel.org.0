Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CE1532C2C
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 16:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiEXO1u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 May 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiEXO1s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 May 2022 10:27:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1EB6A01D;
        Tue, 24 May 2022 07:27:47 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L6xN63gKdzjX1H;
        Tue, 24 May 2022 22:26:46 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 22:27:44 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 24 May
 2022 22:27:44 +0800
Message-ID: <ab3533a6-cb60-b553-e140-40b87fc09428@huawei.com>
Date:   Tue, 24 May 2022 22:27:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 05/20] objtool: Reorganize ORC types
Content-Language: en-US
To:     <madvenka@linux.microsoft.com>, <jpoimboe@redhat.com>,
        <peterz@infradead.org>, <mark.rutland@arm.com>,
        <broonie@kernel.org>, <nobuta.keiya@fujitsu.com>,
        <sjitindarsingh@gmail.com>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <jamorris@linux.microsoft.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-6-madvenka@linux.microsoft.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220524001637.1707472-6-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/5/24 8:16, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The ORC code needs to be reorganized into arch-specific and generic parts
> so that architectures other than X86 can use the generic parts.
> 
> orc_types.h contains the following ORC definitions shared between objtool
> and the kernel:
> 
> 	- ORC register definitions which are arch-specific.
> 	- orc_entry structure which is generic.
...
> diff --git a/include/linux/orc_entry.h b/include/linux/orc_entry.h
> new file mode 100644
> index 000000000000..3d49e3b9dabe
> --- /dev/null
> +++ b/include/linux/orc_entry.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2017 Josh Poimboeuf <jpoimboe@redhat.com>
> + */
> +
> +#ifndef _ORC_ENTRY_H
> +#define _ORC_ENTRY_H
> +
> +#ifndef __ASSEMBLY__
> +#include <asm/byteorder.h>
> +
> +/*
> + * This struct is more or less a vastly simplified version of the DWARF Call
> + * Frame Information standard.  It contains only the necessary parts of DWARF
> + * CFI, simplified for ease of access by the in-kernel unwinder.  It tells the
> + * unwinder how to find the previous SP and BP (and sometimes entry regs) on
> + * the stack for a given code address.  Each instance of the struct corresponds
> + * to one or more code locations.
> + */
> +struct orc_entry {
> +	s16		sp_offset;
> +	s16		fp_offset;
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	unsigned	sp_reg:4;
> +	unsigned	fp_reg:4;
Are sp_reg & fp_reg & end needed? I noticed that they are not used in
reliability checking.

> +	unsigned	type:3;
> +	unsigned	end:1;
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	unsigned	fp_reg:4;
> +	unsigned	sp_reg:4;
> +	unsigned	unused:4;
> +	unsigned	end:1;
> +	unsigned	type:3;
> +#endif
> +} __packed;
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* _ORC_ENTRY_H */

