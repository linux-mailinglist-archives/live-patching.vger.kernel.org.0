Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848C2661EF0
	for <lists+live-patching@lfdr.de>; Mon,  9 Jan 2023 08:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjAIHDi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 Jan 2023 02:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbjAIHDg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 Jan 2023 02:03:36 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2AD6361;
        Sun,  8 Jan 2023 23:03:34 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nr4cd5Ly4zRr3d;
        Mon,  9 Jan 2023 15:01:53 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 15:03:31 +0800
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
 <Y7dBoII5kZnHGFdL@krava>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <15c72493-90d9-9e8a-e354-0a1b043b75dd@huawei.com>
Date:   Mon, 9 Jan 2023 15:03:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y7dBoII5kZnHGFdL@krava>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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



On 2023/1/6 5:31, Jiri Olsa wrote:
> On Wed, Jan 04, 2023 at 05:25:08PM +0100, Petr Mladek wrote:
>> On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
>>> Function __module_address() can quickly return the pointer of the module
>>> to which an address belongs. We do not need to traverse the symbols of all
>>> modules to check whether each address in addrs[] is the start address of
>>> the corresponding symbol, because register_fprobe_ips() will do this check
>>> later.
> 
> hum, for some reason I can see only replies to this patch and
> not the actual patch.. I'll dig it out of the lore I guess

https://lkml.org/lkml/2022/12/30/195

> 
>>>
>>> Assuming that there are m modules, each module has n symbols on average,
>>> and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
>>> complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
>>> and the time complexity of current method is O(K * (log(m) + M)), M <= m.
>>> (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
>>> the ratio is still greater than 1. Therefore, the new method will
>>> generally have better performance.
> 
> could you try to benchmark that? I tried something similar but was not
> able to get better performance

I'm just theoretically analyzing, at least the performance won't get worse.

> 
> I'll review and run my benchmark test tomorrow
> 
> thanks,
> jirka
> 
>>>
>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>> ---
>>>  kernel/trace/bpf_trace.c | 101 ++++++++++++++++-----------------------
>>>  1 file changed, 40 insertions(+), 61 deletions(-)
>>>
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index 5f3be4bc16403a5..0ff9037098bd241 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -2684,69 +2684,55 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
>>>  	}
>>>  }
>>>  
>>> -struct module_addr_args {
>>> -	unsigned long *addrs;
>>> -	u32 addrs_cnt;
>>> -	struct module **mods;
>>> -	int mods_cnt;
>>> -	int mods_cap;
>>> -};
>>> -
>>> -static int module_callback(void *data, const char *name,
>>> -			   struct module *mod, unsigned long addr)
>>> +static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
>>>  {
>>> -	struct module_addr_args *args = data;
>>> -	struct module **mods;
>>> -
>>> -	/* We iterate all modules symbols and for each we:
>>> -	 * - search for it in provided addresses array
>>> -	 * - if found we check if we already have the module pointer stored
>>> -	 *   (we iterate modules sequentially, so we can check just the last
>>> -	 *   module pointer)
>>> -	 * - take module reference and store it
>>> -	 */
>>> -	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
>>> -		       bpf_kprobe_multi_addrs_cmp))
>>> -		return 0;
>>> +	int i, j, err;
>>> +	int mods_cnt = 0;
>>> +	int mods_cap = 0;
>>> +	struct module *mod;
>>> +	struct module **mods = NULL;
>>>  
>>> -	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
>>> -		return 0;
>>> +	for (i = 0; i < addrs_cnt; i++) {
>>> +		mod = __module_address(addrs[i]);
>>
>> This must be called under module_mutex to make sure that the module
>> would not disappear.
>>
>>> +		if (!mod)
>>> +			continue;
>>>  
>>> -	if (args->mods_cnt == args->mods_cap) {
>>> -		args->mods_cap = max(16, args->mods_cap * 3 / 2);
>>> -		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
>>> -		if (!mods)
>>> -			return -ENOMEM;
>>> -		args->mods = mods;
>>> -	}
>>> +		/* check if we already have the module pointer stored */
>>> +		for (j = 0; j < mods_cnt; j++) {
>>> +			if (mods[j] == mod)
>>> +				break;
>>> +		}
>>
>> This might get optimized like the original code.
>>
>> My understanding is that the addresses are sorted in "addrs" array.
>> So, the address is either part of the last found module or it belongs
>> to a completely new module.
>>
>> 	for (i = 0; i < addrs_cnt; i++) {
>> 		/*
>> 		 * The adresses are sorted. The adress either belongs
>> 		 * to the last found module or a new one.
>> 		 *
>> 		 * This is safe because we already have reference
>> 		 * on the found modules.
>> 		 */
>> 		 if (mods_cnt && within_module(addrs[i], mods[mods_cnt - 1]))
>> 			continue;
>>
>> 		mutex_lock(&module_mutex);
>> 		mod = __module_address(addrs[i]);
>> 		if (mod && !try_module_get(mod)) {
>> 			mutex_unlock(&module_mutex);
>> 			goto failed;
>> 		}
>> 		mutex_unlock(&module_mutex);
>>
>> 		/*
>> 		 * Nope when the address was not from a module.
>> 		 *
>> 		 * Is this correct? What if the module has gone in
>> 		 * the meantime? Anyway, the original code
>> 		 * worked this way.
>> 		 *
>> 		 * FIXME: I would personally make sure that it is part
>> 		 * of vmlinux or so.
>> 		 */
>> 		if (!mod)
>> 			continue;
>>
>> 		/* store the module into mods array */
>> 		...
>>
>>
>>
>>
>>> +		if (j < mods_cnt)
>>> +			continue;
>>>  
>>> -	if (!try_module_get(mod))
>>> -		return -EINVAL;
>>> +		if (mods_cnt == mods_cap) {
>>> +			struct module **new_mods;
>>>  
>>> -	args->mods[args->mods_cnt] = mod;
>>> -	args->mods_cnt++;
>>> -	return 0;
>>> -}
>>> +			mods_cap = max(16, mods_cap * 3 / 2);
>>> +			new_mods = krealloc_array(mods, mods_cap, sizeof(*mods), GFP_KERNEL);
>>> +			if (!new_mods) {
>>> +				err = -ENOMEM;
>>> +				goto failed;
>>> +			}
>>> +			mods = new_mods;
>>> +		}
>>>  
>>> -static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
>>> -{
>>> -	struct module_addr_args args = {
>>> -		.addrs     = addrs,
>>> -		.addrs_cnt = addrs_cnt,
>>> -	};
>>> -	int err;
>>> +		if (!try_module_get(mod)) {
>>> +			err = -EINVAL;
>>> +			goto failed;
>>> +		}
>>>  
>>> -	/* We return either err < 0 in case of error, ... */
>>> -	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
>>> -	if (err) {
>>> -		kprobe_multi_put_modules(args.mods, args.mods_cnt);
>>> -		kfree(args.mods);
>>> -		return err;
>>> +		mods[mods_cnt] = mod;
>>> +		mods_cnt++;
>>>  	}
>>>  
>>> -	/* or number of modules found if everything is ok. */
>>> -	*mods = args.mods;
>>> -	return args.mods_cnt;
>>> +	*out_mods = mods;
>>> +	return mods_cnt;
>>> +
>>> +failed:
>>> +	kprobe_multi_put_modules(mods, mods_cnt);
>>> +	kfree(mods);
>>> +	return err;
>>>  }
>>>  
>>>  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>
>> Otherwise, it looks good. IMHO, the new code looks more straightforward
>> than the original one.
>>
>> Best Regards,
>> Petr
> .
> 

-- 
Regards,
  Zhen Lei
