Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E8B732A22
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 10:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343794AbjFPIoH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Jun 2023 04:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343703AbjFPIn6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Jun 2023 04:43:58 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0837D2D7E
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 01:43:55 -0700 (PDT)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QjCMF0ZcMzLmsg;
        Fri, 16 Jun 2023 16:42:01 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 16:43:53 +0800
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
To:     Song Liu <songliubraving@meta.com>
CC:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
References: <20230615170048.2382735-1-song@kernel.org>
 <4c05c5eb-7a15-484f-8227-55ad95abc295@huawei.com>
 <EE806082-EB5C-49BD-B7A7-FFAB3E6340F4@fb.com>
 <85475c44-d9c4-d5ad-350e-bb5fd713ff26@huawei.com>
Message-ID: <77d57723-73d3-8837-b2b5-9fc81e482a8d@huawei.com>
Date:   Fri, 16 Jun 2023 16:43:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <85475c44-d9c4-d5ad-350e-bb5fd713ff26@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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



On 2023/6/16 16:11, Leizhen (ThunderTown) wrote:
> 
> 
> On 2023/6/16 13:01, Song Liu wrote:
>>
>>
>>> On Jun 15, 2023, at 7:19 PM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
>>>
>>> On 2023/6/16 1:00, Song Liu wrote:
>>>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>>>> suffixes during comparison. This is problematic for livepatch, as
>>>> kallsyms_on_each_match_symbol may find multiple matches for the same
>>>> symbol, and fail with:
>>>>
>>>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
>>>
>>> Did you forget to specify 'old_sympos'? When there are multiple symbols with
>>> the same name, we need to specify the sequence number of the symbols to be
>>> matched.
>>
>>
>> old_sympos is indeed 0 here. However, the issue with CONFIG_LTO_CLANG 
>> is different. Here is an example:
>>
>> $ grep bpf_verifier_vlog /proc/kallsyms
>> ffffffff81549f60 t bpf_verifier_vlog
>> ffffffff8268b430 d bpf_verifier_vlog._entry
>> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
>> ffffffff82e12a1f d bpf_verifier_vlog.__already_done
>>
>> kallsyms_on_each_match_symbol matches "bpf_verifier_vlog" to all of 
>> these because of cleanup_symbol_name(). IOW, we only have one 
>> function called bpf_verifier_vlog, but kallsyms_on_each_match_symbol() 
>> matches it to bpf_verifier_vlog.*. 
>>
>> Does this make sense?
> 
> Sorry. I mistakenly thought you were operating a static function.
> 
> These suffixes are not mentioned in the comments in the function
> cleanup_symbol_name(). So I didn't notice it.
We can keep these three suffixes on the kallsyms tool end.

> 
>>
>> Thanks,
>> Song
>>
>>
>> .
>>
> 

-- 
Regards,
  Zhen Lei
