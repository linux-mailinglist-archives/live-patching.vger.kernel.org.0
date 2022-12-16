Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3780F64EAC1
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 12:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLPLlC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 06:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLPLlA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 06:41:00 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951A41658C;
        Fri, 16 Dec 2022 03:40:57 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYRwT59tyzmWjQ;
        Fri, 16 Dec 2022 19:39:53 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 19:40:54 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     David Laight <David.Laight@ACULAB.COM>,
        'Geert Uytterhoeven' <geert@linux-m68k.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Luis Chamberlain <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
 <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
 <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
 <d2d6feddc28b4c12af06da84bd48d900@AcuMS.aculab.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <75b4f3be-1e79-5602-5774-aa1fab3f07ce@huawei.com>
Date:   Fri, 16 Dec 2022 19:40:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d2d6feddc28b4c12af06da84bd48d900@AcuMS.aculab.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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



On 2022/12/16 18:40, David Laight wrote:
> From: Geert Uytterhoeven 
>> Sent: 15 December 2022 13:25
> ...
>> Looks like commit 3bc753c06dd02a35 ("kbuild: treat char as always
>> unsigned") is to blame.
>>
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
>>
>> fixes strcmp, but the test still fails:
> 
> Try 'int res;' and an explicit sign extend (I think):
> 	"3: extb %2\n"

Compilation failed. I tried "return (int)(signed char)res;", it's still failed.

> 
> The strcmp() is still wrong if either input string
> has characters with the top bit set.
> The result needs to be based of the carry flag not
> the sign of the byte subtract.
> 
> It is too long since I've written m68k asm.
> I've checked, all byte operations leave the high 24bits
> unchanged.

Currently, only ASCCIs. So it won't be the reason.

> So it is possible that gcc is making assumptions and
> skipping the sign extend under some circumstances.

Wow, because compare_symbol_name() works properly during the previous binary
search, the compiler must have done something bad. So I add 'volatile' to prevent
compiler optimizations, and it's OK now.

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
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Regards,
  Zhen Lei
