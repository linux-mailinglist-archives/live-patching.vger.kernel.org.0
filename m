Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17A461EC87
	for <lists+live-patching@lfdr.de>; Mon,  7 Nov 2022 09:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiKGIBd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Nov 2022 03:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKGIBc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Nov 2022 03:01:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1270613E87;
        Mon,  7 Nov 2022 00:01:30 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5Nw1689NzHvjr;
        Mon,  7 Nov 2022 16:01:05 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 16:01:28 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 16:01:28 +0800
Subject: Re: [PATCH v8 4/9] kallsyms: Reduce the memory occupied by
 kallsyms_seqs_of_names[]
To:     David Laight <David.Laight@ACULAB.COM>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-5-thunder.leizhen@huawei.com>
 <bd30cbc9b7594261a7b9da26e9c98da4@AcuMS.aculab.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <59edf022-45a7-3cee-a7e7-4b6480e9b679@huawei.com>
Date:   Mon, 7 Nov 2022 16:01:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <bd30cbc9b7594261a7b9da26e9c98da4@AcuMS.aculab.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



On 2022/11/2 20:00, David Laight wrote:
> From: Zhen Lei
>> Sent: 02 November 2022 08:49
>>
>> kallsyms_seqs_of_names[] records the symbol index sorted by address, the
>> maximum value in kallsyms_seqs_of_names[] is the number of symbols. And
>> 2^24 = 16777216, which means that three bytes are enough to store the
>> index. This can help us save (1 * kallsyms_num_syms) bytes of memory.
> 
> You can get the compiler to do the 'heavy lifting' for you.
> 
> struct uint24 {
>     unsigned int val24:24;
> } __attribute__((packed));

This method depends on byte order. If the byte order of the tool is
different from that of the kernel, it's a problem. For example,
cross-compile PowerPC kernel on x86.

> 
> struct uint24 table[1024];
> 
> works fine.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 
> .
> 

-- 
Regards,
  Zhen Lei
