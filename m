Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA4E532C28
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 16:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbiEXOY7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 May 2022 10:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiEXOY7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 May 2022 10:24:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0B75FF36;
        Tue, 24 May 2022 07:24:58 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L6xK967grzjX04;
        Tue, 24 May 2022 22:24:13 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 22:24:56 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 24 May
 2022 22:24:55 +0800
Message-ID: <061a4299-114f-96e0-86a4-6ab255778498@huawei.com>
Date:   Tue, 24 May 2022 22:24:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 00/20] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
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
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Hi Madvenka,

I have a brief look at your patch and the idea that using CFA metadata to
validate FP is reasonable to me. And I found a problem when I used 'pv dump' to
check the orc value and I replied your commit 11/20 for that.

I think it's not necessary that you rewrite the arm64 decoder(there is already a
decoder in my patch) and insn check(objtool check can just make it) by yourself.
Especially it is too duplicated to have two check in objtool.

For me it's also a trouble that objtool runs too much unnecessary work. I advise
that we should move some check for x86 as arch specific and refactor the cmdline
options, they doesn't turn off everything perfectly now.

Other than that I have an advise: We only use orc for reliable stacktrace and
normal FP unwind doesn't depends on it. Should we only load these data for
livepatch (or other scenario needs reliable stacktrace)? It can save the memory
and time consuming for kernel.

That's all. And if you don't mind, can I incorporate some commit into my set?
Appreciate for it.

Best,
Chen

