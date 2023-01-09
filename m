Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45242662987
	for <lists+live-patching@lfdr.de>; Mon,  9 Jan 2023 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbjAIPNJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 Jan 2023 10:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbjAIPMb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 Jan 2023 10:12:31 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23733590E;
        Mon,  9 Jan 2023 07:11:58 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NrHNY30LLzqV45;
        Mon,  9 Jan 2023 23:07:09 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 23:11:53 +0800
Subject: Re: [PATCH 2/3] bpf: Optimize get_modules_for_addrs()
To:     Jiri Olsa <olsajiri@gmail.com>
CC:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com> <Y7WoZARt37xGpjXD@alley>
 <Y7dBoII5kZnHGFdL@krava> <Y7ftxIiV35Wd75lZ@krava>
 <652e0eea-1ab2-a4fd-151a-e634bcb4e1da@huawei.com> <Y7wbNinAXM6O62ZF@krava>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <78754aee-7c06-cbc3-b68c-d723f09b7f77@huawei.com>
Date:   Mon, 9 Jan 2023 23:11:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y7wbNinAXM6O62ZF@krava>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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



On 2023/1/9 21:48, Jiri Olsa wrote:
> On Mon, Jan 09, 2023 at 04:51:37PM +0800, Leizhen (ThunderTown) wrote:
>>
>>
>> On 2023/1/6 17:45, Jiri Olsa wrote:
>>> On Thu, Jan 05, 2023 at 10:31:12PM +0100, Jiri Olsa wrote:
>>>> On Wed, Jan 04, 2023 at 05:25:08PM +0100, Petr Mladek wrote:
>>>>> On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
>>>>>> Function __module_address() can quickly return the pointer of the module
>>>>>> to which an address belongs. We do not need to traverse the symbols of all
>>>>>> modules to check whether each address in addrs[] is the start address of
>>>>>> the corresponding symbol, because register_fprobe_ips() will do this check
>>>>>> later.
>>>>
>>>> hum, for some reason I can see only replies to this patch and
>>>> not the actual patch.. I'll dig it out of the lore I guess
>>>>
>>>>>>
>>>>>> Assuming that there are m modules, each module has n symbols on average,
>>>>>> and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
>>>>>> complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
>>>>>> and the time complexity of current method is O(K * (log(m) + M)), M <= m.
>>>>>> (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
>>>>>> the ratio is still greater than 1. Therefore, the new method will
>>>>>> generally have better performance.
>>>>
>>>> could you try to benchmark that? I tried something similar but was not
>>>> able to get better performance
>>>
>>> hm looks like I tried the smilar thing (below) like you did,
>>
>> Yes. I just found out you're working on this improvement, too.
>>
>>> but wasn't able to get better performace
>>
>> Your implementation below is already the limit that can be optimized.
>> If the performance is not improved, it indicates that this place is
>> not the bottleneck.
>>
>>>
>>> I guess your goal is to get rid of the module arg in
>>> module_kallsyms_on_each_symbol callback that we use?
>>
>> It's not a bad thing to keep argument 'mod' for function
>> module_kallsyms_on_each_symbol(), but for kallsyms_on_each_symbol(),
>> it's completely redundant. Now these two functions often use the
>> same hook function. So I carefully analyzed get_modules_for_addrs(),
>> which is the only place that involves the use of parameter 'mod'.
>> Looks like there's a possibility of eliminating parameter 'mod'.
>>
>>> I'm ok with the change if the performace is not worse
>>
>> OK, thanks.
>>
>>>
>>> jirka
>>>
>>>
>>> ---
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index 5b9008bc597b..3280c22009f1 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -2692,23 +2692,16 @@ struct module_addr_args {
>>>  	int mods_cap;
>>>  };
>>>  
>>> -static int module_callback(void *data, const char *name,
>>> -			   struct module *mod, unsigned long addr)
>>> +static int add_module(struct module_addr_args *args, struct module *mod)
>>>  {
>>> -	struct module_addr_args *args = data;
>>>  	struct module **mods;
>>>  
>>> -	/* We iterate all modules symbols and for each we:
>>> -	 * - search for it in provided addresses array
>>> -	 * - if found we check if we already have the module pointer stored
>>> -	 *   (we iterate modules sequentially, so we can check just the last
>>> -	 *   module pointer)
>>> +	/* We iterate sorted addresses and for each within module we:
>>> +	 * - check if we already have the module pointer stored for it
>>> +	 *   (we iterate sorted addresses sequentially, so we can check
>>> +	 *   just the last module pointer)
>>>  	 * - take module reference and store it
>>>  	 */
>>> -	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
>>> -		       bpf_kprobe_multi_addrs_cmp))
>>> -		return 0;
>>> -
>>>  	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
>>>  		return 0;
>>
>> There'll be problems Petr mentioned.
>>
>> https://lkml.org/lkml/2023/1/5/191
> 
> ok, makes sense.. I guess we could just search args->mods in here?
> are you going to send new version, or should I update my patch with that?

It's better for you to update! I'm not familiar with the bpf module.

> 
> thanks,
> jirka
> .
> 

-- 
Regards,
  Zhen Lei
