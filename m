Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF1629312
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 09:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiKOIPV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 03:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOIPV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 03:15:21 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0242418E1F;
        Tue, 15 Nov 2022 00:15:19 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NBJrK0khrz15MZK;
        Tue, 15 Nov 2022 16:14:57 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 16:14:29 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 16:14:28 +0800
Subject: Re: [PATCH v8 7/9] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Jiri Olsa <olsajiri@gmail.com>, <nick.alcock@oracle.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "David Laight" <David.Laight@aculab.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com> <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com> <Y3IY6gzDtk1ze3u7@krava>
 <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com> <Y3JB++KOXxMWWX35@krava>
 <Y3JivLcvbHNcIcSB@bombadil.infradead.org>
 <df46ad45-2de4-0300-4afa-5788463d712a@huawei.com> <Y3NADwGUIvfwnGTp@krava>
 <Y3NFoLn/GOJybXoc@bombadil.infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <3df2bdd7-f10b-b8d1-3b7a-7e8111affd0c@huawei.com>
Date:   Tue, 15 Nov 2022 16:14:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y3NFoLn/GOJybXoc@bombadil.infradead.org>
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



On 2022/11/15 15:54, Luis Chamberlain wrote:
> On Tue, Nov 15, 2022 at 08:30:23AM +0100, Jiri Olsa wrote:
>> On Tue, Nov 15, 2022 at 10:10:16AM +0800, Leizhen (ThunderTown) wrote:
>>>
>>>
>>> On 2022/11/14 23:46, Luis Chamberlain wrote:
>>>> On Mon, Nov 14, 2022 at 02:26:19PM +0100, Jiri Olsa wrote:
>>>>> I'll check on that, meanwhile if we could keep the module argument,
>>>>> that'd be great
>>>>
>>>> As Leizhen suggested I could just drop patches:
>>>>
>>>> 7/9 livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
>>>> 8/9 kallsyms: Delete an unused parameter related to kallsyms_on_each_symbol()
>>>>
>>>> Then after the next kernel is released this can be relooked at.
>>>> If this is agreeable let me know.
>>>
>>> I'm OK.
>>
>> sounds good, thanks
> 
> OK thanks, I dropped the last selftest patch as well, and pushed to
> modules-next.  Leizhen, can you enhance the selftest for the new module
> requirement and repost?

Okay, right away.

> 
> Stephen, you can drop your fix from linux-next, hopefully there should
> no longer be any merge conflicts. The module requirement will stick for
> now.
> 
> Thanks,
> 
>   Luis
> .
> 

-- 
Regards,
  Zhen Lei
