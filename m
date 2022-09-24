Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058805E8C17
	for <lists+live-patching@lfdr.de>; Sat, 24 Sep 2022 14:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiIXMLQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 24 Sep 2022 08:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiIXMLN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 24 Sep 2022 08:11:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234889CFF;
        Sat, 24 Sep 2022 05:11:12 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZSS318SVzlXL7;
        Sat, 24 Sep 2022 20:06:59 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:11:10 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:11:09 +0800
Subject: Re: [PATCH v5 08/10] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
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
        "Luis Chamberlain" <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20220923112033.1958-1-thunder.leizhen@huawei.com>
 <20220923112033.1958-9-thunder.leizhen@huawei.com>
 <4ef46874-4dbc-2663-ebad-7adbbbfa3b18@huawei.com>
Message-ID: <6cddc5ab-6af5-c221-9383-a45d955af52b@huawei.com>
Date:   Sat, 24 Sep 2022 20:10:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4ef46874-4dbc-2663-ebad-7adbbbfa3b18@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/24 9:11, Leizhen (ThunderTown) wrote:
> 
> On 2022/9/23 19:20, Zhen Lei wrote:
>> Currently we traverse all symbols of all modules to find the specified
>> function for the specified module. But in reality, we just need to find
>> the given module and then traverse all the symbols in it.
>>
>> In order to achieve this purpose, split the call to hook 'fn' into two
>> phases:
>> 1. Finds the given module. Pass pointer 'mod'. Hook 'fn' directly returns
>>    the comparison result of the module name without comparing the function
>>    name.
>> 2. Finds the given function in that module. Pass pointer 'mod = NULL'.
>>    Hook 'fn' skip the comparison of module name and directly compare
>>    function names.
> Sorry, I forgot to change the description. I will fix it in v6, after I've
> collected review comments.

Oh, It's Saturday, and I don't think anyone's seen v5 yet. So I'll post the v6.
Please skip v5.

> 

-- 
Regards,
  Zhen Lei
