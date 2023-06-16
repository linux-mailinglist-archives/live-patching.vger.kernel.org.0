Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37387324A0
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 03:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjFPBYG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Jun 2023 21:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjFPBYF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Jun 2023 21:24:05 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B6296E
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 18:24:04 -0700 (PDT)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Qj1bh5rwPzLmqw;
        Fri, 16 Jun 2023 09:22:08 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:24:00 +0800
Subject: Re: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
CC:     Song Liu <songliubraving@meta.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>
References: <20230602232401.3938285-1-song@kernel.org>
 <ZILQERU8CJQvn9ix@alley> <A4BB490E-42EE-4435-AAE7-2309E384C934@fb.com>
 <ZIiITvTMOimZ-t1z@alley>
 <CAPhsuW5TZPzzFefZ=d1OjVY7yBqge0XBnS9UE2xCWnoLmwj_Og@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <3307943c-c842-ea52-d7b8-2f704139e645@huawei.com>
Date:   Fri, 16 Jun 2023 09:23:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5TZPzzFefZ=d1OjVY7yBqge0XBnS9UE2xCWnoLmwj_Og@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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



On 2023/6/16 0:58, Song Liu wrote:
> On Tue, Jun 13, 2023 at 8:16 AM Petr Mladek <pmladek@suse.com> wrote:
>>
> 
> [...]
> 
>>
>> I agree that it is a slow path.
>>
>> Well, Zhen put a lot of effort into the optimization. I am not sure
>> what was the primary motivation. But it would be harsh to remove it
>> without asking.
>>
>> Zhen, what was the motivation for the speedup of kallsyms, please?
>>

If a large number of functions are modified, livepatch may fail. In some
actual scenarios(business), the patch needs to be activated within a limited time.

> 
> I took a closer look at the code. kallsyms_on_each_match_symbol()
> is only used by livepatch. So indeed it doesn't make sense to drop
> all the optimizations by Zhen.

Yes, if CLANG has special requirements, it can be specially addressed.
I was thinking about CLANG, and I'll take a closer look at the current problem.

> 
> I got another solution for this. Will send it shortly.
> 
> Thanks,
> Song
> 
>>
>>> OTOH, this version is simpler and should work just as
>>> well.
>>
>> Sure. But we should double check Zhen's motivation.
>>
>> Anyway, iterating over all symbols costs a lot. See also
>> the commit f5bdb34bf0c9314548f2d ("livepatch: Avoid CPU hogging
>> with cond_resched").
> .
> 

-- 
Regards,
  Zhen Lei
