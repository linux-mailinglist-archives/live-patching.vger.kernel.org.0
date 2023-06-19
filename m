Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D97734AA5
	for <lists+live-patching@lfdr.de>; Mon, 19 Jun 2023 05:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjFSDcP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 18 Jun 2023 23:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjFSDcO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 18 Jun 2023 23:32:14 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D4583
        for <live-patching@vger.kernel.org>; Sun, 18 Jun 2023 20:32:13 -0700 (PDT)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QkwLG5GFvz1FDdF;
        Mon, 19 Jun 2023 11:32:06 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 19 Jun 2023 11:32:10 +0800
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
To:     Song Liu <songliubraving@meta.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
Date:   Mon, 19 Jun 2023 11:32:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2023/6/17 1:37, Song Liu wrote:
> 
> 
>> On Jun 16, 2023, at 2:31 AM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
>>
>>
>>
>> On 2023/6/16 1:00, Song Liu wrote:
>>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>>> suffixes during comparison. This is problematic for livepatch, as
>>> kallsyms_on_each_match_symbol may find multiple matches for the same
>>> symbol, and fail with:
>>>
>>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
>>>
>>> Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
>>> livepatch is the only user of kallsyms_on_each_match_symbol(), this
>>> change is safe.
>>>
>>> Signed-off-by: Song Liu <song@kernel.org>
>>> ---
>>> kernel/kallsyms.c | 17 +++++++++--------
>>> 1 file changed, 9 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
>>> index 77747391f49b..2ab459b43084 100644
>>> --- a/kernel/kallsyms.c
>>> +++ b/kernel/kallsyms.c
>>> @@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
>>> return false;
>>> }
>>>
>>> -static int compare_symbol_name(const char *name, char *namebuf)
>>> +static int compare_symbol_name(const char *name, char *namebuf, bool match_exactly)
>>> {
>>> int ret;
>>>
>>> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
>>> if (!ret)
>>> return ret;
>>>
>>> - if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
>>> + if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
>>
>> This may affect the lookup of static functions.
> 
> I am not following why would this be a problem. Could you give an 
> example of it?

Here are the comments in cleanup_symbol_name(). If the compiler adds a suffix to the
static function, but we do not remove the suffix, will the symbol match fail?

	/*
	 * LLVM appends various suffixes for local functions and variables that
	 * must be promoted to global scope as part of LTO.  This can break
	 * hooking of static functions with kprobes. '.' is not a valid
	 * character in an identifier in C. Suffixes observed:
	 * - foo.llvm.[0-9a-f]+
	 * - foo.[0-9a-f]+
	 */

> 
> Thanks,
> Song
> 
> .
> 

-- 
Regards,
  Zhen Lei
