Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C664F816
	for <lists+live-patching@lfdr.de>; Sat, 17 Dec 2022 08:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiLQHb6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 17 Dec 2022 02:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLQHb4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 17 Dec 2022 02:31:56 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828281DF35;
        Fri, 16 Dec 2022 23:31:54 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NYyGr1YPYzqT6p;
        Sat, 17 Dec 2022 15:27:32 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 17 Dec 2022 15:31:50 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     David Laight <David.Laight@ACULAB.COM>,
        'Steven Rostedt' <rostedt@goodmis.org>
CC:     'Andreas Schwab' <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
        Luis Chamberlain <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
 <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
 <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com>
 <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
 <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
 <06345dca-0afb-00a5-c9e9-5ba830d8ad05@huawei.com>
 <52450ec1da164d6d87587063c3b3d3d2@AcuMS.aculab.com>
 <592dce7a0de24c62bd31c29f86ce6c1b@AcuMS.aculab.com>
 <87pmcjidfe.fsf@igel.home>
 <1ba1fadb39994a4d91edabdfd9d69fa6@AcuMS.aculab.com>
 <87len7ibtt.fsf@igel.home>
 <c7cebe9da0474eb880ab14124ba290d0@AcuMS.aculab.com>
 <87fsdfib07.fsf@igel.home>
 <819801284eb745d9a4189759bad297f5@AcuMS.aculab.com>
 <20221216115314.6120beb7@gandalf.local.home>
 <ecf4939dbff84709a1782a8e8851b29f@AcuMS.aculab.com>
 <20221216121947.7d03b651@gandalf.local.home>
 <20221216123805.6eba002c@gandalf.local.home>
 <83701d57c0064c709669c03cecc38356@AcuMS.aculab.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <066d4a61-3df9-b9c8-81a2-40dfcd3c73ef@huawei.com>
Date:   Sat, 17 Dec 2022 15:31:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <83701d57c0064c709669c03cecc38356@AcuMS.aculab.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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



On 2022/12/17 3:27, David Laight wrote:
> From: Steven Rostedt
>> Sent: 16 December 2022 17:38
>>
>> On Fri, 16 Dec 2022 12:19:47 -0500
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> I assumed that "memory" was for memory unrelated to the input constraints.
>>
>> Well, it looks like you do need a "memory" barrier.
>>
>>   https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
>>
>> "memory"
>>
>>       The "memory" clobber tells the compiler that the assembly code
>>       performs memory reads or writes to items other than those listed in
>>       the input and output operands (for example, accessing the memory
>>       pointed to by one of the input parameters). To ensure memory contains
>>       correct values, GCC may need to flush specific register values to
>>       memory before executing the asm. Further, the compiler does not
>>       assume that any values read from memory before an asm remain
>>       unchanged after that asm; it reloads them as needed. Using the
>>       "memory" clobber effectively forms a read/write memory barrier for
>>       the compiler.
>>
>> As the "(for example, accessing the memory pointed to by one of the input
>> parameters)" is exactly this case.
> 
> Without the memory clobber code like:
> int f(const char *s)
> {
> 	char c[4] = "abc";
> 	return strcmp(s, c);
> }
> is very like to get optimised so that c[] is never written.
> 
> However, in this case, the strings have all existed for ages.
> So that won't be the problem.
> 
> It might be obvious what is wrong from the asm output.
> Although the binary-chop lookup is suspect I'd also check
> that the sorted index is plausible - just tracing the first
> 20 entries might be enough.
> No point peering at the search code if the setup is wrong.

6.47.2.1 Volatile
GCC’s optimizers sometimes discard asm statements if they determine there is no need for
the output variables. Also, the optimizers may move code out of loops if they believe that
the code will always return the same result (i.e. none of its input values change between
calls). Using the volatile qualifier disables these optimizations.

So it's quite possible (I didn't disassemble vmlinux, because I didn't learn m68k):

//binary search
while (low <= high) {
    ...
    ret = compare_symbol_name(name, namebuf);   ----> (1)
    if (!ret)
        break;
}

low = mid;
while (low) {
    ...
    if (compare_symbol_name(name, namebuf))     ----> (2)
        break;
    low--;
}

The pointer 'name' and 'namebuf' of (1) and (2) are the same,
so the 'if' statement of (2) maybe omitted by compiler.

By the way, I tried no volatile but with
+               : : "memory");
It also works well.

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
