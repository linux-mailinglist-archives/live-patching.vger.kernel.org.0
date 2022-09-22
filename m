Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD645E5873
	for <lists+live-patching@lfdr.de>; Thu, 22 Sep 2022 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIVCQs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 22:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIVCQr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 22:16:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73DB754A7;
        Wed, 21 Sep 2022 19:16:46 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXzLV6VLJzMpQh;
        Thu, 22 Sep 2022 10:12:02 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 10:16:45 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 10:16:44 +0800
Subject: Re: [PATCH v4 5/8] kallsyms: Add helper
 kallsyms_on_each_match_symbol()
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
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-6-thunder.leizhen@huawei.com> <YysuJrpLYkVa2vCg@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <9b27244e-fdc1-4a65-5c64-9a4cb7e57bf3@huawei.com>
Date:   Thu, 22 Sep 2022 10:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YysuJrpLYkVa2vCg@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/21 23:30, Petr Mladek wrote:
> On Tue 2022-09-20 15:13:14, Zhen Lei wrote:
>> Function kallsyms_on_each_symbol() traverses all symbols and submits each
>> symbol to the hook 'fn' for judgment and processing. For some cases, the
>> hook actually only handles the matched symbol, such as livepatch.
>>
>> So that, we can first compress the name being looked up and then use
>> it for comparison when traversing 'kallsyms_names', this greatly reduces
>> the time consumed by traversing.
>>
>> The pseudo code of the test case is as follows:
>> static int tst_find(void *data, const char *name,
>> 		    struct module *mod, unsigned long addr)
>> {
>> 	if (strcmp(name, "vmap") == 0)
>> 		*(unsigned long *)data = addr;
>>         return 0;
>> }
>>
>> static int tst_match(void *data, unsigned long addr)
>> {
>>         *(unsigned long *)data = addr;
>>         return 0;
>> }
>>
>> start = sched_clock();
>> kallsyms_on_each_match_symbol(tst_match, "vmap", &addr);
>> end = sched_clock();
>>
>> start = sched_clock();
>> kallsyms_on_each_symbol(tst_find, &addr);
>> end = sched_clock();
>>
>> The test results are as follows (twice):
>> kallsyms_on_each_match_symbol:   557400,   583900
>> kallsyms_on_each_symbol      : 16659500, 16113950
>>
>> kallsyms_on_each_match_symbol() consumes only 3.48% of
>> kallsyms_on_each_symbol()'s time.
>>
>> --- a/kernel/kallsyms.c
>> +++ b/kernel/kallsyms.c
>> @@ -305,6 +305,31 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>>  	return 0;
>>  }
>>  
>> +int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
>> +				  const char *name, void *data)
>> +{
>> +	unsigned int i, off;
>> +	int len, ret;
>> +	char namebuf[KSYM_NAME_LEN];
>> +
>> +	len = kallsyms_name_to_tokens(name, namebuf);
>> +	for (i = 0, off = 0; len && i < kallsyms_num_syms; i++) {
>> +		if ((i & 0xfff) == 0)
>> +			cond_resched();
>> +
>> +		if ((kallsyms_names[off] == len + 1) &&
>> +		    !memcmp(&kallsyms_names[off + 2], namebuf, len)) {
>> +			ret = fn(data, kallsyms_sym_address(i));
>> +			if (ret != 0)
>> +				return ret;
>> +			cond_resched();
>> +		}
>> +		off += kallsyms_names[off] + 1;
> 
> Similar tricky code is used also in kallsyms_lookup_name(). Please,
> avoid code duplication and put this into a helper funtion.

Okay, I'll try it.

> 
> Best Regards,
> Petr
> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static unsigned long get_symbol_pos(unsigned long addr,
>>  				    unsigned long *symbolsize,
>>  				    unsigned long *offset)
>> -- 
>> 2.25.1
> .
> 

-- 
Regards,
  Zhen Lei
