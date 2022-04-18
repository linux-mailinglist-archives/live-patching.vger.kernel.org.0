Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED5050521F
	for <lists+live-patching@lfdr.de>; Mon, 18 Apr 2022 14:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiDRMkS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Apr 2022 08:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiDRMiJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Apr 2022 08:38:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295A72409F;
        Mon, 18 Apr 2022 05:28:42 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KhmSM06LKzhXYf;
        Mon, 18 Apr 2022 20:28:35 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Apr 2022 20:28:36 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 18 Apr
 2022 20:28:36 +0800
Message-ID: <0abfa1af-81ec-9048-6f95-cf5dda295139@huawei.com>
Date:   Mon, 18 Apr 2022 20:28:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        <mark.rutland@arm.com>, <broonie@kernel.org>, <ardb@kernel.org>,
        <nobuta.keiya@fujitsu.com>, <sjitindarsingh@gmail.com>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <jmorris@namei.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
 <35c99466-9024-a7fd-9632-5d21b3e558f7@huawei.com>
 <20220416005609.3znhltjlhpg475ff@treble>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220416005609.3znhltjlhpg475ff@treble>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Josh,

IIUC, ORC on x86 can make reliable stack unwind for this scenario
because objtool validates BP state.

I'm thinking that on arm64 there's no guarantee that LR will be pushed
onto stack. When we meet similar scenario on arm64, we should recover
(LR, FP) on pt_regs and continue to unwind the stack. And this is
reliable only after we validate (LR, FP).

So should we track LR on arm64 additionally as track BP on x86? Or can
we just treat (LR, FP) as a pair? because as I know they are always set
up together.

On 2022/4/16 8:56, Josh Poimboeuf wrote:
> On Tue, Apr 12, 2022 at 04:32:22PM +0800, Chen Zhongjin wrote:
>> By the way, I was thinking about a corner case, because arm64 CALL
>> instruction won't push LR onto stack atomically as x86. Before push LR, FP
>> to save frame there still can be some instructions such as bti, paciasp. If
>> an irq happens here, the stack frame is not constructed so the FP unwinder
>> will omit this function and provides a wrong stack trace to livepatch.
>>
>> It's just a guess and I have not built the test case. But I think it's a
>> defect on arm64 that FP unwinder can't work properly on prologue and
>> epilogue. Do you have any idea about this?
> 
> x86 has similar issues with frame pointers, if for example preemption or
> page fault exception occurs in a leaf function, or in a function
> prologue or epilogue, before or after the frame pointer setup.
> 
> This issue is solved by the "reliable" unwinder which detects
> irqs/exceptions on the stack and reports the stack as unreliable.
> 

