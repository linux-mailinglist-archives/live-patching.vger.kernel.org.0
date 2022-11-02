Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01030615F6D
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 10:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKBJUx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 05:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiKBJUi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 05:20:38 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE3225;
        Wed,  2 Nov 2022 02:18:28 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2LnT481WzpW9X;
        Wed,  2 Nov 2022 17:14:53 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 17:18:26 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 17:18:25 +0800
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
 <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
 <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
 <Y1mEiIvbld4SX1lx@bombadil.infradead.org>
 <4f06547b-456f-e1ec-c535-16577f502ff1@huawei.com>
 <d7393d45-84bb-9e7b-99f4-412eb9223208@huawei.com>
 <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
 <b7215b83-11ab-6db6-bd7f-9729725eaaeb@huawei.com>
 <b30a540b-019d-4466-19d9-33900b1a89b1@huawei.com>
Message-ID: <d059c054-1ef9-f89b-fcb2-7387770d2ec7@huawei.com>
Date:   Wed, 2 Nov 2022 17:18:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b30a540b-019d-4466-19d9-33900b1a89b1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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



On 2022/10/31 23:04, Leizhen (ThunderTown) wrote:
> Now, we need to make a decision. Choose one of the two:
> 1. Continue with my current approach. Improve the average performance of
>    kallsyms_lookup_name() by 20 to 30 times. The memory overhead is increased by:
>    arm64 (defconfig):
>      73.5KiB and 4.0% if CONFIG_KALLSYMS_ALL=y.
>      19.8KiB and 2.8% if CONFIG_KALLSYMS_ALL=n.
>    x86 (defconfig):
>      49.0KiB and 3.0% if CONFIG_KALLSYMS_ALL=y.
>      16.8KiB and 2.3% if CONFIG_KALLSYMS_ALL=n.
> 2. Sort names, binary search (The static function causes duplicate names. Additional work is required）
>    2^18=262144, only up to 18 symbol expansions and comparisons are required.
>    The performance is definitely excellent, although I haven't tested it yet.
>    The memory overhead is increased by: 6 * kallsyms_num_syms
>    arm64 (defconfig):
>        1MiB if CONFIG_KALLSYMS_ALL=y.
>      362KiB if CONFIG_KALLSYMS_ALL=n.
>    x86 (defconfig):
>      770KiB if CONFIG_KALLSYMS_ALL=y.
>      356KiB if CONFIG_KALLSYMS_ALL=n.

Hi, Luis:
  I've implemented v8 based on method 2(Sort names, binary search).
The memory overhead is increased by: 3 * kallsyms_num_syms.
kallsyms_offsets_of_names[] is not added in v8 because it does not help
much in performance improvement, so save (3 * kallsyms_num_syms) bytes.
For details about the performance data, please see the commit message.


-- 
Regards,
  Zhen Lei
