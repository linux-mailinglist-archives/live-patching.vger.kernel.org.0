Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9003C532B93
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiEXNp0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 May 2022 09:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiEXNp0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 May 2022 09:45:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D05954A0;
        Tue, 24 May 2022 06:45:24 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L6wRD2HmyzjX5j;
        Tue, 24 May 2022 21:44:24 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 21:45:22 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 24 May
 2022 21:45:22 +0800
Message-ID: <767e814c-b3cc-73a1-d283-82dbc0287cde@huawei.com>
Date:   Tue, 24 May 2022 21:45:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 11/20] objtool: arm64: Walk instructions and
 compute CFI for each instruction
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
 <20220524001637.1707472-12-madvenka@linux.microsoft.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220524001637.1707472-12-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Hi,

On 2022/5/24 8:16, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Implement arch_initial_func_cfi_state() to initialize the CFI for a
> function.
> 
> Add code to fpv_decode() to walk the instructions in every function and
> compute the CFI information for each instruction.
> 
> Implement special handling for cases like jump tables.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  tools/objtool/arch/arm64/decode.c |  15 +++
>  tools/objtool/fpv.c               | 204 ++++++++++++++++++++++++++++++
>  2 files changed, 219 insertions(+)
...
> +static void update_cfi_state(struct cfi_state *cfi, struct stack_op *op)
> +{
> +	struct cfi_reg *cfa = &cfi->cfa;
> +	struct cfi_reg *regs = cfi->regs;
> +
> +	if (op->src.reg == CFI_SP) {
> +		if (op->dest.reg == CFI_SP)
> +			cfa->offset -= op->src.offset;
> +		else
> +			regs[CFI_FP].offset = -cfa->offset + op->src.offset;
Seems wrong here, we don't have any op->src.offset for [mov x29, sp] so here we
get: fp->offset = -cfa->offset. The dumped info also proves this.

> +	case UNWIND_HINT_TYPE_CALL:
> +		/* Normal call */
> +		frame->cfa += orc->sp_offset;
> +		fp = frame->cfa + orc->fp_offset;
> +		break;
Obviously this is not conform to the reliability check because we get
frame->cfa == fp here.

IIUC your sp_offset equals to stack length, and fp_offset is offset from next
x29 to next CFA. So maybe here we should have
regs[CFI_FP].offset = regs[CFI_SP].offset for [mov x29, sp].

Anyway, in original objtool sp_offset and fp_offset both represents the offset
from CFA to REGs. I think it's better not spoiling their original meaning and
just extending.



