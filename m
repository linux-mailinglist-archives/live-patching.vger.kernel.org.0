Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0604D5BF3AA
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 04:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiIUCnP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 22:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiIUCnO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 22:43:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD727D799;
        Tue, 20 Sep 2022 19:43:10 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXN1c0HnJzpTjM;
        Wed, 21 Sep 2022 10:40:20 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 10:43:08 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 10:43:07 +0800
Subject: Re: [PATCH v2 1/8] scripts/kallsyms: don't compress symbol type when
 CONFIG_KALLSYMS_ALL=y
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
 <20220909130016.727-2-thunder.leizhen@huawei.com> <Yyn305PlgTZixR0V@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <42cdce86-8ccd-3cc1-9e30-13485a183d98@huawei.com>
Date:   Wed, 21 Sep 2022 10:42:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Yyn305PlgTZixR0V@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/9/21 1:26, Petr Mladek wrote:
> On Fri 2022-09-09 21:00:09, Zhen Lei wrote:
>> Currently, to search for a symbol, we need to expand the symbols in
>> 'kallsyms_names' one by one, and then use the expanded string for
>> comparison. This is very slow.
>>
>> In fact, we can first compress the name being looked up and then use
>> it for comparison when traversing 'kallsyms_names'.
> 
> This does not explain how this patch modifies the compressed data
> and why it is needed.

Yes, I have updated the description from the v3 version.

So if we don't compress the symbol type, we can first compress the
searched symbol and then make a quick comparison based on the compressed
length and content. In this way, for entries with mismatched lengths,
there is no need to expand and compare strings. And for those matching
lengths, there's no need to expand the symbol. This saves a lot of time.

> 
> 
>> This increases the size of 'kallsyms_names'. About 48KiB, 2.67%, on x86
>> with defconfig.
>> Before: kallsyms_num_syms=131392, sizeof(kallsyms_names)=1823659
>> After : kallsyms_num_syms=131392, sizeof(kallsyms_names)=1872418
>>
>> However, if CONFIG_KALLSYMS_ALL is not set, the size of 'kallsyms_names'
>> does not change.
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  scripts/kallsyms.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>> index f18e6dfc68c5839..ab6fe7cd014efd1 100644
>> --- a/scripts/kallsyms.c
>> +++ b/scripts/kallsyms.c
>> @@ -60,6 +60,7 @@ static unsigned int table_size, table_cnt;
>>  static int all_symbols;
>>  static int absolute_percpu;
>>  static int base_relative;
>> +static int sym_start_idx;
>>  
>>  static int token_profit[0x10000];
>>  
>> @@ -511,7 +512,7 @@ static void learn_symbol(const unsigned char *symbol, int len)
>>  {
>>  	int i;
>>  
>> -	for (i = 0; i < len - 1; i++)
>> +	for (i = sym_start_idx; i < len - 1; i++)
>>  		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]++;
> 
> This skips the first character in the @symbol string. I do not see how
> this is used in the new code, for example, in
> kallsyms_on_each_match_symbol(), in the 5th patch. It seems to iterate
> the compressed data from the 0th index:
> 
> 	for (i = 0, off = 0; i < kallsyms_num_syms; i++)
> 
>>  }
>>  
>> @@ -520,7 +521,7 @@ static void forget_symbol(const unsigned char *symbol, int len)
>>  {
>>  	int i;
>>  
>> -	for (i = 0; i < len - 1; i++)
>> +	for (i = sym_start_idx; i < len - 1; i++)
>>  		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]--;
>>  }
>>  
>> @@ -538,7 +539,7 @@ static unsigned char *find_token(unsigned char *str, int len,
>>  {
>>  	int i;
>>  
>> -	for (i = 0; i < len - 1; i++) {
>> +	for (i = sym_start_idx; i < len - 1; i++) {
>>  		if (str[i] == token[0] && str[i+1] == token[1])
>>  			return &str[i];
>>  	}
>> @@ -780,6 +781,14 @@ int main(int argc, char **argv)
>>  	} else if (argc != 1)
>>  		usage();
>>  
>> +	/*
>> +	 * Skip the symbol type, do not compress it to optimize the performance
>> +	 * of finding or traversing symbols in kernel, this is good for modules
>> +	 * such as livepatch.
> 
> I see. The type is added as the first character here.
> 
> in static struct sym_entry *read_symbol(FILE *in)
> {
> [...]
> 	/* include the type field in the symbol name, so that it gets
> 	 * compressed together */

Good catch. I should remove "so that it gets compressed together"

> [...]
> 	sym->sym[0] = type;
> 	strcpy(sym_name(sym), name);
> 
> It sounds a bit crazy. read_symbol() makes a trick so that the type
> can be compressed. This patch does another trick to avoid it.
> 
> 
>> +	 */
>> +	if (all_symbols)
>> +		sym_start_idx = 1;
> 
> This looks a bit fragile. My understanding is that the new code in
> kernel/kallsyms.c and kernel/module/kallsyms.c depends on this change.

They do not depend on this change, because the index in
insert_real_symbols_in_table() is still starting from 0. kallsyms_expand_symbol()
shows that it uses every byte of the compressed data to look up the token table.
The index in insert_real_symbols_in_table() starting from 0 make sure that the
raw character of 'type' occupies a separate position in kallsyms_token_table[].
So that kallsyms_expand_symbol() can still work well.

> 
> The faster search is used when CONFIG_KALLSYMS_ALL is defined.
> But the data are compressed this way when this script is called
> with --all-symbols.
> 
> Is it guaranteed that this script will generate the needed data
> when CONFIG_KALLSYMS_ALL is defined?

Yes, see kallsyms() in scripts/link-vmlinux.sh
	if is_enabled CONFIG_KALLSYMS_ALL; then
                kallsymopt="${kallsymopt} --all-symbols"
        fi

> 
> What about 3rd party modules?

Should they call the API directly?

> 
> I would personally suggest to store the symbol type into a separate
> sym->type entry in struct sym_entry and never compress it.

Yes，I've also considered this, for the purpose of increasing the
compression ratio. See below, if the sorting is performed based on
the address and then based on the type. We can record all the symbol
type information in less than 100 bytes. Of course, this makes the
functions that look up symbols based on the address loop serveral
times more. However, I would like to wait until the current patch
series is accepted. Otherwise, I'll have to rework a lot of patches
and it's too much work. To be honest, I've been coding for it these days.

cat /proc/kallsyms | awk '{print $2}' | sort | uniq -c | sort -r
  44678 r
  38299 t
  28315 T
  11644 d
   3768 D
   2778 b
    778 R
    641 B
    282 A
    178 W
     37 V

> 
> IMHO, the size win is not worth the code complexity.
> 
> Well, people compiling the kernel for small devices might think
> different. But they probably disable kallsyms completely.

Yes, to make the code look better, I've stopped binding CONFIG_KALLSYMS_ALL since v3.

3. The symbol type is not compressed regardless of whether
   CONFIG_KALLSYMS_ALL is set or not. The memory overhead is increased
   by less than 20KiB if CONFIG_KALLSYMS_ALL=n.

> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
