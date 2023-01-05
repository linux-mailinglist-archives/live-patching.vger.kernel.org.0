Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA965E621
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 08:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjAEHcN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 02:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjAEHcH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 02:32:07 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E033544DD;
        Wed,  4 Jan 2023 23:32:00 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NndMn2yjxzqTbx;
        Thu,  5 Jan 2023 15:27:17 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 5 Jan 2023 15:31:56 +0800
Subject: Re: [PATCH 2/3] bpf: Optimize get_modules_for_addrs()
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com> <Y7WoZARt37xGpjXD@alley>
 <CAPhsuW6sZ9yQvZvKLd0g9m4FoabmUzwn-txX6T_A-_VYgJoXFg@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <9be7a6a9-9290-5410-0ed7-f48ef3dea285@huawei.com>
Date:   Thu, 5 Jan 2023 15:31:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6sZ9yQvZvKLd0g9m4FoabmUzwn-txX6T_A-_VYgJoXFg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2023/1/5 1:07, Song Liu wrote:
> On Wed, Jan 4, 2023 at 8:25 AM Petr Mladek <pmladek@suse.com> wrote:
>>
>> On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
>>> Function __module_address() can quickly return the pointer of the module
>>> to which an address belongs. We do not need to traverse the symbols of all
>>> modules to check whether each address in addrs[] is the start address of
>>> the corresponding symbol, because register_fprobe_ips() will do this check
>>> later.
>>>
>>> Assuming that there are m modules, each module has n symbols on average,
>>> and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
>>> complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
>>> and the time complexity of current method is O(K * (log(m) + M)), M <= m.
>>> (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
>>> the ratio is still greater than 1. Therefore, the new method will
>>> generally have better performance.
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
>>>       }
>>>  }
>>>
>>> -struct module_addr_args {
>>> -     unsigned long *addrs;
>>> -     u32 addrs_cnt;
>>> -     struct module **mods;
>>> -     int mods_cnt;
>>> -     int mods_cap;
>>> -};
>>> -
>>> -static int module_callback(void *data, const char *name,
>>> -                        struct module *mod, unsigned long addr)
>>> +static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
>>>  {
>>> -     struct module_addr_args *args = data;
>>> -     struct module **mods;
>>> -
>>> -     /* We iterate all modules symbols and for each we:
>>> -      * - search for it in provided addresses array
>>> -      * - if found we check if we already have the module pointer stored
>>> -      *   (we iterate modules sequentially, so we can check just the last
>>> -      *   module pointer)
>>> -      * - take module reference and store it
>>> -      */
>>> -     if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
>>> -                    bpf_kprobe_multi_addrs_cmp))
>>> -             return 0;
>>> +     int i, j, err;
>>> +     int mods_cnt = 0;
>>> +     int mods_cap = 0;
>>> +     struct module *mod;
>>> +     struct module **mods = NULL;
>>>
>>> -     if (args->mods && args->mods[args->mods_cnt - 1] == mod)
>>> -             return 0;
>>> +     for (i = 0; i < addrs_cnt; i++) {
>>> +             mod = __module_address(addrs[i]);
>>
>> This must be called under module_mutex to make sure that the module
>> would not disappear.

Yes, mod needs to be protected, thanks.

> 
> module_mutex is not available outside kernel/module/. The common
> practice is to disable preempt before calling __module_address().

Yes, I've looked elsewhere, and all calling preempt_disable() for
RCU read protection. I will fix it.

> CONFIG_LOCKDEP should catch this.
> 
> Thanks,
> Song
> 
> [...]
> .
> 

-- 
Regards,
  Zhen Lei
