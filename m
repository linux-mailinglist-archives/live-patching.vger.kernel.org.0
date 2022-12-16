Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DC64EB07
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 12:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiLPL6R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 06:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiLPL6I (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 06:58:08 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E887F389FF;
        Fri, 16 Dec 2022 03:58:06 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYSDS52rdzqTDf;
        Fri, 16 Dec 2022 19:53:44 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 19:58:03 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
 <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
 <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
 <87len7k1yn.fsf@igel.home>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <9f2d4035-c647-4bd9-ffff-b970a88bcc88@huawei.com>
Date:   Fri, 16 Dec 2022 19:57:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87len7k1yn.fsf@igel.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/12/16 19:44, Andreas Schwab wrote:
> On Dez 15 2022, Geert Uytterhoeven wrote:
> 
>> Changing:
>>
>>     --- a/arch/m68k/include/asm/string.h
>>     +++ b/arch/m68k/include/asm/string.h
>>     @@ -42,7 +42,7 @@ static inline char *strncpy(char *dest, const
>> char *src, size_t n)
>>      #define __HAVE_ARCH_STRCMP
>>      static inline int strcmp(const char *cs, const char *ct)
>>      {
>>     -       char res;
>>     +       signed char res;
>>
>>             asm ("\n"
>>                     "1:     move.b  (%0)+,%2\n"     /* get *cs */
> 
> Note that strcmp needs to compute the return value from the difference
> of the _unsigned_ characters.  That does not explain the error, though,
> since symbol names don't have characters with the high bit set.

Why consider the high bit? It is not memcmp(). If the high bit is set,
it is the user's fault.


> 

-- 
Regards,
  Zhen Lei
