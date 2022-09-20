Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6A5BE7DC
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiITOCF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiITOCD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 10:02:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06403386B5;
        Tue, 20 Sep 2022 07:01:59 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MX3586W8QzMnGc;
        Tue, 20 Sep 2022 21:57:16 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 22:01:56 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 22:01:56 +0800
Subject: Re: [PATCH v2 7/8] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
To:     Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-8-thunder.leizhen@huawei.com> <YymtJwYB7Q9mTPgS@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <263d1b98-463f-79b0-a4ff-41b9af900e9c@huawei.com>
Date:   Tue, 20 Sep 2022 22:01:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YymtJwYB7Q9mTPgS@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/20 20:08, Petr Mladek wrote:
> On Fri 2022-09-09 21:00:15, Zhen Lei wrote:
>> Currently we traverse all symbols of all modules to find the specified
>> function for the specified module. But in reality, we just need to find
>> the given module and then traverse all the symbols in it.
> 
> I agree that it might be noticeable speedup.
> 
>> In order to achieve this purpose, split the call to hook 'fn' into two
>> phases:
>> 1. Finds the given module. Pass pointer 'mod'. Hook 'fn' directly returns
>>    the comparison result of the module name without comparing the function
>>    name.
>> 2. Finds the given function in that module. Pass pointer 'mod = NULL'.
>>    Hook 'fn' skip the comparison of module name and directly compare
>>    function names.
>>
>> Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
>>                 |
>> Phase2:          -->f1-->f2-->f3
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  kernel/livepatch/core.c  |  7 ++-----
>>  kernel/module/kallsyms.c | 13 ++++++++++++-
>>  2 files changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 31b57ccf908017e..98e23137e4133bc 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -130,15 +130,12 @@ static int klp_find_callback(void *data, const char *name,
>>  {
>>  	struct klp_find_arg *args = data;
>>  
>> -	if ((mod && !args->objname) || (!mod && args->objname))
>> -		return 0;
>> +	if (mod)
>> +		return strcmp(args->objname, mod->name);
>>  
>>  	if (strcmp(args->name, name))
>>  		return 0;
>>  
>> -	if (args->objname && strcmp(args->objname, mod->name))
>> -		return 0;
>> -
>>  	args->addr = addr;
>>  	args->count++;
>>  
>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>> index f5c5c9175333df7..b033613e6c7e3bb 100644
>> --- a/kernel/module/kallsyms.c
>> +++ b/kernel/module/kallsyms.c
>> @@ -510,6 +510,11 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>>  		if (mod->state == MODULE_STATE_UNFORMED)
>>  			continue;
>>  
>> +		/* check mod->name first */
>> +		ret = fn(data, NULL, mod, 0);
>> +		if (ret)
>> +			continue;
> 
> Hmm, it somehow gets too complicated. The same fn() callback has to
> behave correctly in 3 different situations. I would suggest to
> simplify everything:
> 
> 
> 1. Pass the requested modname as a parameter to module_kallsyms_on_each_symbol()
> 
> /*
>  * Iterate over all symbols in the given @modname. For symbols from
>  * vmlinux use kallsyms_on_each_symbol() instead.
>  */
> int module_kallsyms_on_each_symbol(const char *modname,
> 				   int (*fn)(void *, const char *,
> 					     struct module *, unsigned long),
> 				   void *data)
> 
> and do here:
> 
> 		if (strcmp(modname, mod->name))
> 			continue;

Right, looks good. This makes the code logic much clearer. Thanks.

> 
> 
> 2. We do not even need to pass .objname in struct klp_find_arg
>    could simplify the callback:
> 

Yes

> static int klp_find_callback(void *data, const char *name,
> 			     struct module *mod, unsigned long addr)
> {
> 	struct klp_find_arg *args = data;
> 
> 	if (strcmp(args->name, name))
> 		return 0;
> 
> 	args->addr = addr;
> 	args->count++;
> 
> 	/*
> 	 * Finish the search when the symbol is found for the desired position
> 	 * or the position is not defined for a non-unique symbol.
> 	 */
> 	if ((args->pos && (args->count == args->pos)) ||
> 	    (!args->pos && (args->count > 1)))
> 		return 1;
> 
> 	return 0;
> }
> 
> 3. As a result the *mod parameter won't be used by any existing
>    fn() callback and could be removed. This should be done as
>    a separate patch. It touches also ftrace_lookup_symbols().

OK, I will do it tomorrow. The next version is v5.

> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
