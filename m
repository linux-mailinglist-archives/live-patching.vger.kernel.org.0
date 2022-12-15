Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2064DCFF
	for <lists+live-patching@lfdr.de>; Thu, 15 Dec 2022 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLOOku (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Dec 2022 09:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLOOks (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Dec 2022 09:40:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBF05F71;
        Thu, 15 Dec 2022 06:40:44 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXvtZ5D7mzqSnt;
        Thu, 15 Dec 2022 22:36:22 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 15 Dec 2022 22:40:39 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
Message-ID: <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
Date:   Thu, 15 Dec 2022 22:40:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
Content-Type: multipart/mixed;
        boundary="------------02EB81ACC5D49A141807CD0A"
Content-Language: en-US
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

--------------02EB81ACC5D49A141807CD0A
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit



On 2022/12/15 21:58, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/12/15 21:24, Geert Uytterhoeven wrote:
>> Hi Zhen,
>>
>> CC Jason
>>
>> On Thu, Dec 15, 2022 at 1:34 PM Leizhen (ThunderTown)
>> <thunder.leizhen@huawei.com> wrote:
>>> On 2022/12/15 17:39, Geert Uytterhoeven wrote:
>>>> On Thu, Dec 15, 2022 at 10:16 AM Leizhen (ThunderTown)
>>>> <thunder.leizhen@huawei.com> wrote:
>>>>> On 2022/12/15 16:50, Geert Uytterhoeven wrote:
>>>>>> On Tue, Nov 15, 2022 at 9:41 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>>>>>>> Added test cases for basic functions and performance of functions
>>>>>>> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
>>>>>>> kallsyms_on_each_match_symbol(). It also calculates the compression rate
>>>>>>> of the kallsyms compression algorithm for the current symbol set.
>>>>>>>
>>>>>>> The basic functions test begins by testing a set of symbols whose address
>>>>>>> values are known. Then, traverse all symbol addresses and find the
>>>>>>> corresponding symbol name based on the address. It's impossible to
>>>>>>> determine whether these addresses are correct, but we can use the above
>>>>>>> three functions along with the addresses to test each other. Due to the
>>>>>>> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
>>>>>>> symbols can be tested in one second, so let it test on average once
>>>>>>> every 128 symbols. The other two functions validate all symbols.
>>>>>>>
>>>>>>> If the basic functions test is passed, print only performance test
>>>>>>> results. If the test fails, print error information, but do not perform
>>>>>>> subsequent performance tests.
>>>>>>>
>>>>>>> Start self-test automatically after system startup if
>>>>>>> CONFIG_KALLSYMS_SELFTEST=y.
>>>>>>>
>>>>>>> Example of output content: (prefix 'kallsyms_selftest:' is omitted
>>>>>>>  start
>>>>>>>   ---------------------------------------------------------
>>>>>>>  | nr_symbols | compressed size | original size | ratio(%) |
>>>>>>>  |---------------------------------------------------------|
>>>>>>>  |     107543 |       1357912   |      2407433  |  56.40   |
>>>>>>>   ---------------------------------------------------------
>>>>>>>  kallsyms_lookup_name() looked up 107543 symbols
>>>>>>>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
>>>>>>>  kallsyms_on_each_symbol() traverse all: 11782628 ns
>>>>>>>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
>>>>>>>  finish
>>>>>>>
>>>>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>>>>
>>>>>> Thanks for your patch, which is now commit 30f3bb09778de64e ("kallsyms:
>>>>>> Add self-test facility") in linus/master.
>>>>>>
>>>>>> I gave this a try on m68k (atari_defconfig + CONFIG_KALLSYMS_SELFTEST=y),
>>>>>> but it failed:
>>>>>>
>>>>>>     start
>>>>>>     kallsyms_lookup_name() for kallsyms_test_func_static failed:
>>>>>> addr=0, expect 60ab0
>>>>>>     kallsyms_lookup_name() for kallsyms_test_func failed: addr=0, expect 60ac0
>>>>>>     kallsyms_lookup_name() for kallsyms_test_func_weak failed: addr=0,
>>>>>> expect 60ac2
>>>>>>     kallsyms_lookup_name() for vmalloc failed: addr=0, expect c272a
>>>>>>     kallsyms_lookup_name() for vfree failed: addr=0, expect c2142
>>>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_static
>>>>>> failed: count=0, addr=0, expect 60ab0
>>>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
>>>>>> count=0, addr=0, expect 60ac0
>>>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
>>>>>> failed: count=0, addr=0, expect 60ac2
>>>>>>     kallsyms_on_each_match_symbol() for vmalloc failed: count=0,
>>>>>> addr=0, expect c272a
>>>>>>     kallsyms_on_each_match_symbol() for vfree failed: count=0, addr=0,
>>>>>> expect c2142
>>>>>>     abort
>>>>>>
>>>>>> Given all addresses are zero, it looks like some required functionality
>>>>>> or config option is missing.
>>>>>>
>>>>>> $ grep SYM .config
>>>>>> CONFIG_KALLSYMS=y
>>>>>> CONFIG_KALLSYMS_SELFTEST=y
>>>>>> CONFIG_KALLSYMS_BASE_RELATIVE=y
>>>>>> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
>>>>>> CONFIG_SYMBOLIC_ERRNAME=y
>>>>>> # CONFIG_STRIP_ASM_SYMS is not set
>>>>>> CONFIG_KALLSYMS_SELFTEST
>>>>>>
>>>>>> Do you have a clue?
>>>>>
>>>>> cat /proc/kallsyms | grep kallsyms_test_func
>>>>> Let's see if the compiler-generated symbols have some special suffixes.
>>>>
>>>> Thanks, looks normal to me:
>>>>
>>>>     atari:~# cat /proc/kallsyms | grep kallsyms_test_func
>>>>     00060ab0 t kallsyms_test_func_static
>>>>     00060ac0 T kallsyms_test_func
>>>>     00060ac2 W kallsyms_test_func_weak
>>>>     atari:~#
>>>
>>> It's incredible. I don't have a m68k environment and I'm trying to build a qemu
>>> environment. If you're in a hurry and willing, you can apply the debugging patch
>>> in the attachment. I'd like to see what's wrong. Use "dmesg | grep tst" to collect
>>> the output information.
>>
>> Still fails:
>>
>>     tst: found kallsyms_test_func at index=12845
>>     tst: [12533] = kallsyms_test_func, seq=17370, offset=191223
>>     tst: [18800] = kallsyms_test_func, seq=23193, offset=259263
>>     tst: [21934] = kallsyms_test_func, seq=2527, offset=22331
>>     tst: [23501] = kallsyms_test_func, seq=11792, offset=126366
>>     tst: [24284] = kallsyms_test_func, seq=8427, offset=87395
>>     tst: [24676] = kallsyms_test_func, seq=21896, offset=243536
>>     tst: [24872] = kallsyms_test_func, seq=22571, offset=251856
>>     tst: [24970] = kallsyms_test_func, seq=23264, offset=260074
>>     tst: [25019] = kallsyms_test_func, seq=9003, offset=93752
>>     tst: [25043] = kallsyms_test_func, seq=14324, offset=155117
>>     tst: [25055] = kallsyms_test_func, seq=5942, offset=62266
>>     tst: [25061] = kallsyms_test_func, seq=14347, offset=155467
>>     tst: [25064] = kallsyms_test_func, seq=14350, offset=155512
>>     tst: [25066] = kallsyms_test_func, seq=14346, offset=155457
>>     tst: [25067] = kallsyms_test_func, seq=14354, offset=155565
> 
> -               pr_warn("tst: [%d] = %s, seq=%d, offset=%d\n", mid, name, seq, off);
> +               pr_warn("tst: [%d] = %s, seq=%d, offset=%d\n", mid, namebuf, seq, off);
> 
> Sorry, a variable in the debugging code is incorrectly written. 'name' should
> be replaced with 'namebuf', then we can see which function the comparison is wrong.

I attached debug patch v2.

> 
>>
>> However, the binary search sequence looks very suspicious.
>> After investigation, it turns out compare_symbol_name() and strcmp()
>> always return positive numbers.
>>
>> Looks like commit 3bc753c06dd02a35 ("kbuild: treat char as always
>> unsigned") is to blame.
> 
> Oh, maybe you can "git reset --hard 30f3bb09778de64" and try again.
> 30f3bb09778de64 kallsyms: Add self-test facility
> 
> But the latest kernel is OK on x86. So other patches are unlikely to
> affect this function.
> 
> Is m68k big-endian?
> 
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
>>
>>     tst: kallsyms_lookup_names() is OK, name=kallsyms_test_func, i=0
> 
> i=0, i is impossible zero. Maybe kallsyms_lookup_names() always return success now.
> 
>>     kallsyms_selftest: kallsyms_lookup_name() for
>> kallsyms_test_func_static failed: addr=8e1c, expect 60cd4
>>     kallsyms_selftest: kallsyms_lookup_name() for kallsyms_test_func
>> failed: addr=8e1c, expect 60ce4
>>     kallsyms_selftest: kallsyms_lookup_name() for
>> kallsyms_test_func_weak failed: addr=8e1c, expect 60ce6
>>     kallsyms_selftest: kallsyms_lookup_name() for vmalloc failed:
>> addr=8e1c, expect c2946
>>     kallsyms_selftest: kallsyms_lookup_name() for vfree failed:
>> addr=8e1c, expect c235e
>>     kallsyms_selftest: kallsyms_on_each_match_symbol() for
>> kallsyms_test_func_static failed: count=25068, addr=1f3d3c, expect
>> 60cd4
>>     kallsyms_selftest: kallsyms_on_each_match_symbol() for
>> kallsyms_test_func failed: count=25068, addr=1f3d3c, expect 60ce4
>>     kallsyms_selftest: kallsyms_on_each_match_symbol() for
>> kallsyms_test_func_weak failed: count=25068, addr=1f3d3c, expect 60ce6
>>     kallsyms_selftest: kallsyms_on_each_match_symbol() for vmalloc
>> failed: count=25068, addr=1f3d3c, expect c2946
>>     kallsyms_selftest: kallsyms_on_each_match_symbol() for vfree
>> failed: count=25068, addr=1f3d3c, expect c235e
>>     kallsyms_selftest: abort
>>
>> Dropping -funsigned-char doesn't improve upon that...
>>
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>>
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a hacker. But
>> when I'm talking to journalists I just say "programmer" or something like that.
>>                                 -- Linus Torvalds
>>
>> .
>>
> 

-- 
Regards,
  Zhen Lei

--------------02EB81ACC5D49A141807CD0A
Content-Type: text/plain; charset="UTF-8";
	name="0001-kallsyms-debug-m68k.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0001-kallsyms-debug-m68k.patch"

RnJvbSBjMDY1YWM4NmNmZDkxNTNlNGZiNzFiYmMwNmQ0NDBhNDE4MzRiODc4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaGVuIExlaSA8dGh1bmRlci5sZWl6aGVuQGh1YXdl
aS5jb20+CkRhdGU6IFRodSwgMTUgRGVjIDIwMjIgMjA6MTI6MzggKzA4MDAKU3ViamVjdDog
W1BBVENIIHYyXSBrYWxsc3ltczogZGVidWcgbTY4awoKU2lnbmVkLW9mZi1ieTogWmhlbiBM
ZWkgPHRodW5kZXIubGVpemhlbkBodWF3ZWkuY29tPgotLS0KIGtlcm5lbC9rYWxsc3ltcy5j
ICAgICAgICAgIHwgNTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
IGtlcm5lbC9rYWxsc3ltc19zZWxmdGVzdC5jIHwgIDMgKysKIDIgZmlsZXMgY2hhbmdlZCwg
NjAgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9rYWxsc3ltcy5jIGIva2Vy
bmVsL2thbGxzeW1zLmMKaW5kZXggODNmNDk5MTgyYzlhYTMxLi44MDI1MWRhOTk1MmI5NTcg
MTAwNjQ0Ci0tLSBhL2tlcm5lbC9rYWxsc3ltcy5jCisrKyBiL2tlcm5lbC9rYWxsc3ltcy5j
CkBAIC0yNjcsNiArMjY3LDYzIEBAIHN0YXRpYyBpbnQga2FsbHN5bXNfbG9va3VwX25hbWVz
KGNvbnN0IGNoYXIgKm5hbWUsCiAJcmV0dXJuIDA7CiB9CiAKK3ZvaWQgdHN0X2thbGxzeW1z
X2xvb2t1cF9uYW1lKGNvbnN0IGNoYXIgKm5hbWUsIHZvaWQgKmFkZHIpCit7CisJaW50IGk7
CisJaW50IHJldDsKKwlpbnQgbG93LCBtaWQsIGhpZ2g7CisJdW5zaWduZWQgaW50IHNlcSwg
b2ZmOworCWNoYXIgbmFtZWJ1ZltLU1lNX05BTUVfTEVOXTsKKworCXJldCA9IGthbGxzeW1z
X2xvb2t1cF9uYW1lcyhuYW1lLCAmaSwgTlVMTCk7CisJaWYgKCFyZXQpIHsKKwkJcHJfd2Fy
bigidHN0OiBrYWxsc3ltc19sb29rdXBfbmFtZXMoKSBpcyBPSywgbmFtZT0lcywgaT0lZFxu
IiwgbmFtZSwgaSk7CisJCWlmIChhZGRyID09ICh2b2lkICopa2FsbHN5bXNfc3ltX2FkZHJl
c3MoZ2V0X3N5bWJvbF9zZXEoaSkpKQorCQkJcHJfd2FybigidHN0OiBsb29rdXAgYWRkcmVz
cyBpcyBPS1xuIik7CisJCXJldHVybjsKKwl9CisKKworCWZvciAoaSA9IDA7IGkgPCBrYWxs
c3ltc19udW1fc3ltczsgaSsrKSB7CisJCXNlcSA9IGdldF9zeW1ib2xfc2VxKGkpOworCQlv
ZmYgPSBnZXRfc3ltYm9sX29mZnNldChzZXEpOworCQlrYWxsc3ltc19leHBhbmRfc3ltYm9s
KG9mZiwgbmFtZWJ1ZiwgQVJSQVlfU0laRShuYW1lYnVmKSk7CisJCXJldCA9IGNvbXBhcmVf
c3ltYm9sX25hbWUobmFtZSwgbmFtZWJ1Zik7CisJCWlmICghcmV0KSB7CisJCQlwcl93YXJu
KCJ0c3Q6IGZvdW5kICVzIGF0IGluZGV4PSVkXG4iLCBuYW1lLCBpKTsKKwkJCWlmIChhZGRy
ID09ICh2b2lkICopa2FsbHN5bXNfc3ltX2FkZHJlc3MoZ2V0X3N5bWJvbF9zZXEoaSkpKQor
CQkJCXByX3dhcm4oInRzdDogbG9va3VwIGFkZHJlc3MgaXMgT0tcbiIpOworCQkJYnJlYWs7
CisJCX0KKwl9CisKKwlpZiAoaSA9PSBrYWxsc3ltc19udW1fc3ltcykgeworCQlwcl93YXJu
KCJ0c3Q6IGZvdW5kICVzIGZhaWxlZFxuIiwgbmFtZSk7CisJCXJldHVybjsKKwl9CisKKwls
b3cgPSAwOworCWhpZ2ggPSBrYWxsc3ltc19udW1fc3ltcyAtIDE7CisKKwl3aGlsZSAobG93
IDw9IGhpZ2gpIHsKKwkJbWlkID0gbG93ICsgKGhpZ2ggLSBsb3cpIC8gMjsKKwkJc2VxID0g
Z2V0X3N5bWJvbF9zZXEobWlkKTsKKwkJb2ZmID0gZ2V0X3N5bWJvbF9vZmZzZXQoc2VxKTsK
KwkJa2FsbHN5bXNfZXhwYW5kX3N5bWJvbChvZmYsIG5hbWVidWYsIEFSUkFZX1NJWkUobmFt
ZWJ1ZikpOworCQlwcl93YXJuKCJ0c3Q6IFslZF0gPSAlcywgc2VxPSVkLCBvZmZzZXQ9JWRc
biIsIG1pZCwgbmFtZWJ1Ziwgc2VxLCBvZmYpOworCQlyZXQgPSBjb21wYXJlX3N5bWJvbF9u
YW1lKG5hbWUsIG5hbWVidWYpOworCQlpZiAocmV0ID4gMCkKKwkJCWxvdyA9IG1pZCArIDE7
CisJCWVsc2UgaWYgKHJldCA8IDApCisJCQloaWdoID0gbWlkIC0gMTsKKwkJZWxzZQorCQkJ
YnJlYWs7CisJfQorCisJaWYgKG1pZCA9PSBpKQorCQlwcl93YXJuKCJ0c3Q6IGJpbmFyeSBz
ZWFyY2ggaXMgT0tcbiIpOworfQorCiAvKiBMb29rdXAgdGhlIGFkZHJlc3MgZm9yIHRoaXMg
c3ltYm9sLiBSZXR1cm5zIDAgaWYgbm90IGZvdW5kLiAqLwogdW5zaWduZWQgbG9uZyBrYWxs
c3ltc19sb29rdXBfbmFtZShjb25zdCBjaGFyICpuYW1lKQogewpkaWZmIC0tZ2l0IGEva2Vy
bmVsL2thbGxzeW1zX3NlbGZ0ZXN0LmMgYi9rZXJuZWwva2FsbHN5bXNfc2VsZnRlc3QuYwpp
bmRleCBmMzVkOWNjMWFhYjE1NDQuLmYwZjdjOWZjNzJjNWQ1MyAxMDA2NDQKLS0tIGEva2Vy
bmVsL2thbGxzeW1zX3NlbGZ0ZXN0LmMKKysrIGIva2VybmVsL2thbGxzeW1zX3NlbGZ0ZXN0
LmMKQEAgLTI5Myw2ICsyOTMsOSBAQCBzdGF0aWMgaW50IHRlc3Rfa2FsbHN5bXNfYmFzaWNf
ZnVuY3Rpb24odm9pZCkKIAl1bnNpZ25lZCBsb25nIGFkZHIsIGxvb2t1cF9hZGRyOwogCWNo
YXIgbmFtZWJ1ZltLU1lNX05BTUVfTEVOXTsKIAlzdHJ1Y3QgdGVzdF9zdGF0ICpzdGF0LCAq
c3RhdDI7CisJZXh0ZXJuIHZvaWQgdHN0X2thbGxzeW1zX2xvb2t1cF9uYW1lKGNvbnN0IGNo
YXIgKm5hbWUsIHZvaWQgKmFkZHIpOworCisJdHN0X2thbGxzeW1zX2xvb2t1cF9uYW1lKCJr
YWxsc3ltc190ZXN0X2Z1bmMiLCBrYWxsc3ltc190ZXN0X2Z1bmMpOwogCiAJc3RhdCA9IGtt
YWxsb2Moc2l6ZW9mKCpzdGF0KSAqIDIsIEdGUF9LRVJORUwpOwogCWlmICghc3RhdCkKLS0g
CjIuMjUuMQoK
--------------02EB81ACC5D49A141807CD0A--
