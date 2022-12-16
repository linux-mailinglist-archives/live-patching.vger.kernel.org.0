Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767D364EB1E
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 13:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiLPMCC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 07:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiLPMBo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 07:01:44 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9751D3F045;
        Fri, 16 Dec 2022 04:01:42 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYSJc28k9zqSxx;
        Fri, 16 Dec 2022 19:57:20 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 20:01:38 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
 <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
 <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
 <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
 <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com>
 <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
 <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <06345dca-0afb-00a5-c9e9-5ba830d8ad05@huawei.com>
Date:   Fri, 16 Dec 2022 20:01:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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



On 2022/12/16 19:28, Geert Uytterhoeven wrote:
> Hi Zhen,
> 
> On Fri, Dec 16, 2022 at 10:43 AM Leizhen (ThunderTown)
> <thunder.leizhen@huawei.com> wrote:
>> On 2022/12/16 15:42, Leizhen (ThunderTown) wrote:
>>> On 2022/12/15 22:51, Geert Uytterhoeven wrote:
>>>> On 30f3bb09778de64 with your debug patch v2:
>>> I've set up the qemu environment, and I'll try to solve it by tomorrow at the latest.
>>
>> It seems that the problem is still strcmp(). After I commented strcmp() in
>> arch/m68k/include/asm/string.h, and force it to use the one in lib/string.c,
>> it works well.
> 
> I can confirm that.
> 
> One difference is that the one in lib/string.c always return -1/0/1,
> while the m68k version can return other negative or positive numbers.
> 
> However, adding:
> 
>        if (res < 0) return -1;
>        if (res > 0) return 1;
> 
> to the m68k version doesn't make a difference.
> 
> Renaming the m68k version (changed to -1/0/1) to m68k_strcmp(), and
> the generic version to lib_strcmp(), and adding a wrapper that calls
> and compares both, shows that both functions do return the same value,
> and the test succeeds.
> 
> Moving the m68k version inside lib/string.c makes the test pass, too.
> So it must be related to the function being inline, and gcc making
> (incorrect) assumptions...

Yes, it's the compiler's fault. I just replied David Laight:

I added 'volatile' to prevent compiler optimizations, and it's OK now.

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index f759d944c449940..3db81e5a783c72a 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -42,9 +42,9 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
 #define __HAVE_ARCH_STRCMP
 static inline int strcmp(const char *cs, const char *ct)
 {
-       char res;
+       signed char res;

-       asm ("\n"
+       asm volatile ("\n"
                "1:     move.b  (%0)+,%2\n"     /* get *cs */
                "       cmp.b   (%1)+,%2\n"     /* compare a byte */
                "       jne     2f\n"           /* not equal, break out */

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
> .
> 

-- 
Regards,
  Zhen Lei
