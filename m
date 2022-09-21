Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAE75BFEBB
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIUNNa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 09:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiIUNNa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 09:13:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88388DF0;
        Wed, 21 Sep 2022 06:13:27 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXf0r3crKzpTqx;
        Wed, 21 Sep 2022 21:10:36 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:13:25 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:13:24 +0800
Subject: Re: [PATCH v4 3/8] scripts/kallsyms: don't compress symbol types
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
 <20220920071317.1787-4-thunder.leizhen@huawei.com> <YyrSwnvMn5N5lV6Q@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <5fe18639-0a0c-70b5-8fa5-83ed83ffcaf3@huawei.com>
Date:   Wed, 21 Sep 2022 21:13:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YyrSwnvMn5N5lV6Q@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/9/21 17:00, Petr Mladek wrote:
> On Tue 2022-09-20 15:13:12, Zhen Lei wrote:
>> Currently, to search for a symbol, we need to expand the symbols in
>> 'kallsyms_names' one by one, and then use the expanded string for
>> comparison. Because we do not know the symbol type, and the symbol type
>> may be combined with the following characters to form a token.
>>
>> So if we don't compress the symbol type, we can first compress the
>> searched symbol and then make a quick comparison based on the compressed
>> length and content. In this way, for entries with mismatched lengths,
>> there is no need to expand and compare strings. And for those matching
>> lengths, there's no need to expand the symbol. This saves a lot of time.
>> According to my test results, the average performance of
>> kallsyms_lookup_name() can be improved by 20 to 30 times.
>>
>> Of course, because the symbol type is forcibly not compressed, the
>> compression rate also decreases. Here are the test results with
>> defconfig:
>>
>> arm64: <<<<<<
>>         ---------------------------------------------------------------
>>        | ALL | nr_symbols | compressed size | original size | ratio(%) |
>>         -----|---------------------------------------------------------|
>> Before |  Y  |     174094 |       1884938   |      3750653  |  50.25   |
>> After  |  Y  |     174099 |       1960154   |      3750756  |  52.26   |
>> Before |  N  |      61744 |        725507   |      1222737  |  59.33   |
>> After  |  N  |      61747 |        745733   |      1222801  |  60.98   |
>>         ---------------------------------------------------------------
>> The memory overhead is increased by:
>>   73.5KiB and 4.0% if CONFIG_KALLSYMS_ALL=y.
>>   19.8KiB and 2.8% if CONFIG_KALLSYMS_ALL=n.
>>
>> x86: <<<<<<<<
>>        ---------------------------------------------------------------
>>        | ALL | nr_symbols | compressed size | original size | ratio(%) |
>>         -----|---------------------------------------------------------|
>> Before |  Y  |     131415 |       1697542   |      3161216  |  53.69   |
>> After  |  Y  |     131540 |       1747769   |      3163933  |  55.24   |
>> Before |  N  |      60695 |        737627   |      1283046  |  57.49   |
>> After  |  N  |      60699 |        754797   |      1283149  |  58.82   |
>>         ---------------------------------------------------------------
>> The memory overhead is increased by:
>>   49.0KiB and 3.0% if CONFIG_KALLSYMS_ALL=y.
>>   16.8KiB and 2.3% if CONFIG_KALLSYMS_ALL=n.
>>
>> This additional memory overhead is worth it compared to the performance
>> improvement, I think.
> 
> I agree. The speedup mentioned in the followup patches looks big.
> I just suggest to do this change a cleaner way, see below.
> 
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  scripts/kallsyms.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
>> index 3319d9f38d7a5f2..1ae9ce773d2a31d 100644
>> --- a/scripts/kallsyms.c
>> +++ b/scripts/kallsyms.c
>> @@ -61,6 +61,15 @@ static int all_symbols;
>>  static int absolute_percpu;
>>  static int base_relative;
>>  
>> +/*
>> + * Each entry in the symbol table consists of the symbol type and the symbol
>> + * itself. To optimize the performance of finding or traversing symbols in
>> + * kernel, do not compress the symbol type. In this way, when looking for a
>> + * symbol of unknown type, we can first compress the searched symbol and then
>> + * make a quick comparison based on the compressed length and content.
>> + */
>> +static int sym_start_idx = 1;
>> +
>>  static int token_profit[0x10000];
>>  
>>  /* the table that holds the result of the compression */
>> @@ -511,7 +520,7 @@ static void learn_symbol(const unsigned char *symbol, int len)
>>  {
>>  	int i;
>>  
>> -	for (i = 0; i < len - 1; i++)
>> +	for (i = sym_start_idx; i < len - 1; i++)
> 
> It creates yet another twists in scripts/kallsyms.c. read_symbol()
> explicitely adds the type as the first character so that it can be
> compressed. And this patch adds a hack to skip it.
> 
> Let's do it a clean way and store the type serarately:
> 
> struct sym_entry {
> 	unsigned long long addr;
> 	unsigned int len;
> 	unsigned int start_pos;
> 	unsigned int percpu_absolute;
> 	unsigned char type;

Yes, it's very necessary. Thanks.

> 	unsigned char name[];

Yes, using "name[]" will be clearer than using "sym[]"

> };
> 
> static struct sym_entry *read_symbol(FILE *in)
> {
> [...]
> 	name_len = strlen(name);
> 
> 	sym = malloc(sizeof(*sym) + name_len);
> 	if (!sym) {
> 		fprintf(stderr, "kallsyms failure: "
> 			"unable to allocate required amount of memory\n");
> 		exit(EXIT_FAILURE);
> 	}
> 	sym->addr = addr;
> 	sym->len = name_len;
> 	sym->type = type;
> 	strcpy(sys->name, name);
> 	sym->percpu_absolute = 0;
> }
> 
> It would allow to remove the tricky:
> 
> 	static char *sym_name(const struct sym_entry *s)
> 	{
> 		return (char *)s->sym + 1;
> 	}
> 
> and access s->name directly.

OK

> 
> OK, the problem is how to store the type. The clean way would be
> to put it into a separate section, for example:
> 
> static void write_src(void)
> {
> [...]
> 	output_label("kallsyms_types");
> 	off = 0;
> 	for (i = 0; i < table_cnt; i++) {
> 		printf("\t.byte 0x%02x\n", table[i]->type);
> 	}
> 	printf("\n");
> [...]
> }
> 
> It would probably increase the size even more. Another problem
> is that it would need changes in the crash dump tools, see:
> 
> static int __init crash_save_vmcoreinfo_init(void)
> {
> [...]
> 	VMCOREINFO_SYMBOL(kallsyms_names);
> [...]
> }
> 
> A solution would be to store it the old way:

I'll use this compatibility mode first. Because I'm going to compress
the type later.

> 
> static void write_src(void)
> {
> [...]
> 	output_label("kallsyms_names");
> 	off = 0;
> 	for (i = 0; i < table_cnt; i++) {
> 		if ((i & 0xFF) == 0)
> 			markers[i >> 8] = off;
> 
> 		/*
> 		 * Store the symbol type togerher with symbol name.
> 		 * It helps to reduce the size.
> 		 */
> 		printf("\t.byte 0x%02x", table[i]->len + 1);
> 		printf(", 0x%02x", table[i]->type);
> 		for (k = 0; k < table[i]->len; k++)
> 			printf(", 0x%02x", table[i]->sym[k]);
> 		printf("\n");
> 
> 		/* symbol name lenght + type + "\n" */
> 		off += table[i]->len + 2;
> 	}
> 	printf("\n");
> [...]
> }
> 
> The result would be the same as with your patch. But the code would be
> even cleaner than before.

Yes，Thank you for your valuable comments.

> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
