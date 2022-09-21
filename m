Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FA45BF947
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 10:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiIUIbZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 04:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIUIbY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 04:31:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F976951;
        Wed, 21 Sep 2022 01:31:18 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXWk13FChzmVTn;
        Wed, 21 Sep 2022 16:27:21 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 16:31:16 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 16:31:16 +0800
Subject: Re: [PATCH v4 2/8] scripts/kallsyms: ensure that all possible
 combinations are compressed
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
 <20220920071317.1787-3-thunder.leizhen@huawei.com> <YyrEh+fbhYh6ltLp@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <f1eaedb1-fc3e-cd0e-e63a-6e3caa9e015e@huawei.com>
Date:   Wed, 21 Sep 2022 16:31:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YyrEh+fbhYh6ltLp@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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



On 2022/9/21 16:00, Petr Mladek wrote:
> On Tue 2022-09-20 15:13:11, Zhen Lei wrote:
>> For a symbol, there may be more than one place that can be merged. For
>> example: nfs_fs_proc_net_init, there are two "f"+"s_" combinations.
>> And we're only compressing the first combination at the moment.
> 
> Really?

Yes, there are about 200 such functions.

> 
>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>> index 8caccc8f4a23703..3319d9f38d7a5f2 100644
>> --- a/scripts/kallsyms.c
>> +++ b/scripts/kallsyms.c
>> @@ -553,7 +553,7 @@ static void compress_symbols(const unsigned char *str, int idx)
>>  	unsigned char *p1, *p2;
>>  
>>  	for (i = 0; i < table_cnt; i++) {
>> -
>> +retry:
>>  		len = table[i]->len;
>>  		p1 = table[i]->sym;
>>  
>> @@ -585,6 +585,9 @@ static void compress_symbols(const unsigned char *str, int idx)
>>  
>>  		/* increase the counts for this symbol's new tokens */
>>  		learn_symbol(table[i]->sym, len);
>> +
>> +		/* May be more than one place that can be merged, try again */
>> +		goto retry;
>>  	}
>>  }
> 
> My understanding is that the code already tries to find the same
> token several times. Here are the important parts of the existing
> code:
> 
> static void compress_symbols(const unsigned char *str, int idx)
> {
> 
> 		p2 = find_token(p1, len, str);
> 
> 		do {
> 			/* replace the found token with idx */
> 			*p2 = idx;
> 			[...]
> 
> 			/* find the token on the symbol */
> 			p2 = find_token(p1, size, str);

Oh, yes, it retries. Let me reanalyze it. However, the problem is
real, and there may be a problem somewhere in the loop.

> 
> 		} while (p2);
> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
