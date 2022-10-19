Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EBD60493B
	for <lists+live-patching@lfdr.de>; Wed, 19 Oct 2022 16:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJSO3N (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Oct 2022 10:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiJSO2s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Oct 2022 10:28:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88165149DEA;
        Wed, 19 Oct 2022 07:13:15 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mssz81K3YzpVgY;
        Wed, 19 Oct 2022 22:08:52 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 22:12:10 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 22:12:09 +0800
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
Date:   Wed, 19 Oct 2022 22:11:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y0/nEngJF6bbINEx@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/10/19 20:01, Luis Chamberlain wrote:
> On Mon, Oct 17, 2022 at 02:49:39PM +0800, Zhen Lei wrote:
>> Currently, to search for a symbol, we need to expand the symbols in
>> 'kallsyms_names' one by one, and then use the expanded string for
>> comparison. This is very slow.
>>
>> In fact, we can first compress the name being looked up and then use
>> it for comparison when traversing 'kallsyms_names'.
>>
>> This patch series optimizes the performance of function kallsyms_lookup_name(),
>> and function klp_find_object_symbol() in the livepatch module. Based on the
>> test results, the performance overhead is reduced to 5%. That is, the
>> performance of these functions is improved by 20 times.
> 
> Stupid question, is a hash table in order?

No hash table.

All symbols are arranged in ascending order of address. For example: cat /proc/kallsyms

The addresses of all symbols are stored in kallsyms_addresses[], and names of all symbols
are stored in kallsyms_names[]. The elements in these two arrays are in a one-to-one
relationship. For any symbol, it has the same index in both arrays.

Therefore, when we look up a symbolic name based on an address, we use a binary lookup.
However, when we look up an address based on a symbol name, we can only traverse array
kallsyms_names[] in sequence. I think the reason why hash is not used is to save memory.

> 
>   Luis
> .
> 

-- 
Regards,
  Zhen Lei
