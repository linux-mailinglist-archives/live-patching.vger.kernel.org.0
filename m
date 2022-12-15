Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F4C64DB37
	for <lists+live-patching@lfdr.de>; Thu, 15 Dec 2022 13:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLOMeU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Dec 2022 07:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLOMeL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Dec 2022 07:34:11 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A711C925;
        Thu, 15 Dec 2022 04:34:08 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXs4X0sYrzgZ3Z;
        Thu, 15 Dec 2022 20:29:48 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 15 Dec 2022 20:34:05 +0800
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
        linux-m68k <linux-m68k@lists.linux-m68k.org>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
 <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
Date:   Thu, 15 Dec 2022 20:33:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
Content-Type: multipart/mixed;
        boundary="------------6C44F0A13F580239C62817B7"
Content-Language: en-US
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

--------------6C44F0A13F580239C62817B7
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit



On 2022/12/15 17:39, Geert Uytterhoeven wrote:
> Hi Zhen,
> 
> On Thu, Dec 15, 2022 at 10:16 AM Leizhen (ThunderTown)
> <thunder.leizhen@huawei.com> wrote:
>> On 2022/12/15 16:50, Geert Uytterhoeven wrote:
>>> On Tue, Nov 15, 2022 at 9:41 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>>>> Added test cases for basic functions and performance of functions
>>>> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
>>>> kallsyms_on_each_match_symbol(). It also calculates the compression rate
>>>> of the kallsyms compression algorithm for the current symbol set.
>>>>
>>>> The basic functions test begins by testing a set of symbols whose address
>>>> values are known. Then, traverse all symbol addresses and find the
>>>> corresponding symbol name based on the address. It's impossible to
>>>> determine whether these addresses are correct, but we can use the above
>>>> three functions along with the addresses to test each other. Due to the
>>>> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
>>>> symbols can be tested in one second, so let it test on average once
>>>> every 128 symbols. The other two functions validate all symbols.
>>>>
>>>> If the basic functions test is passed, print only performance test
>>>> results. If the test fails, print error information, but do not perform
>>>> subsequent performance tests.
>>>>
>>>> Start self-test automatically after system startup if
>>>> CONFIG_KALLSYMS_SELFTEST=y.
>>>>
>>>> Example of output content: (prefix 'kallsyms_selftest:' is omitted
>>>>  start
>>>>   ---------------------------------------------------------
>>>>  | nr_symbols | compressed size | original size | ratio(%) |
>>>>  |---------------------------------------------------------|
>>>>  |     107543 |       1357912   |      2407433  |  56.40   |
>>>>   ---------------------------------------------------------
>>>>  kallsyms_lookup_name() looked up 107543 symbols
>>>>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
>>>>  kallsyms_on_each_symbol() traverse all: 11782628 ns
>>>>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
>>>>  finish
>>>>
>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>
>>> Thanks for your patch, which is now commit 30f3bb09778de64e ("kallsyms:
>>> Add self-test facility") in linus/master.
>>>
>>> I gave this a try on m68k (atari_defconfig + CONFIG_KALLSYMS_SELFTEST=y),
>>> but it failed:
>>>
>>>     start
>>>     kallsyms_lookup_name() for kallsyms_test_func_static failed:
>>> addr=0, expect 60ab0
>>>     kallsyms_lookup_name() for kallsyms_test_func failed: addr=0, expect 60ac0
>>>     kallsyms_lookup_name() for kallsyms_test_func_weak failed: addr=0,
>>> expect 60ac2
>>>     kallsyms_lookup_name() for vmalloc failed: addr=0, expect c272a
>>>     kallsyms_lookup_name() for vfree failed: addr=0, expect c2142
>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_static
>>> failed: count=0, addr=0, expect 60ab0
>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
>>> count=0, addr=0, expect 60ac0
>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
>>> failed: count=0, addr=0, expect 60ac2
>>>     kallsyms_on_each_match_symbol() for vmalloc failed: count=0,
>>> addr=0, expect c272a
>>>     kallsyms_on_each_match_symbol() for vfree failed: count=0, addr=0,
>>> expect c2142
>>>     abort
>>>
>>> Given all addresses are zero, it looks like some required functionality
>>> or config option is missing.
>>>
>>> $ grep SYM .config
>>> CONFIG_KALLSYMS=y
>>> CONFIG_KALLSYMS_SELFTEST=y
>>> CONFIG_KALLSYMS_BASE_RELATIVE=y
>>> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
>>> CONFIG_SYMBOLIC_ERRNAME=y
>>> # CONFIG_STRIP_ASM_SYMS is not set
>>> CONFIG_KALLSYMS_SELFTEST
>>>
>>> Do you have a clue?
>>
>> cat /proc/kallsyms | grep kallsyms_test_func
>> Let's see if the compiler-generated symbols have some special suffixes.
> 
> Thanks, looks normal to me:
> 
>     atari:~# cat /proc/kallsyms | grep kallsyms_test_func
>     00060ab0 t kallsyms_test_func_static
>     00060ac0 T kallsyms_test_func
>     00060ac2 W kallsyms_test_func_weak
>     atari:~#

It's incredible. I don't have a m68k environment and I'm trying to build a qemu
environment. If you're in a hurry and willing, you can apply the debugging patch
in the attachment. I'd like to see what's wrong. Use "dmesg | grep tst" to collect
the output information.

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

--------------6C44F0A13F580239C62817B7
Content-Type: text/plain; charset="UTF-8";
	name="0001-kallsyms-debug-m68k.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0001-kallsyms-debug-m68k.patch"

RnJvbSA4ZGZhYTNmN2E4Mzc3MzdlZDQyMDVkNGEwZjBmODU5ZDQ4NWJiOTdiIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaGVuIExlaSA8dGh1bmRlci5sZWl6aGVuQGh1YXdl
aS5jb20+CkRhdGU6IFRodSwgMTUgRGVjIDIwMjIgMjA6MTI6MzggKzA4MDAKU3ViamVjdDog
W1BBVENIXSBrYWxsc3ltczogZGVidWcgbTY4awoKU2lnbmVkLW9mZi1ieTogWmhlbiBMZWkg
PHRodW5kZXIubGVpemhlbkBodWF3ZWkuY29tPgotLS0KIGtlcm5lbC9rYWxsc3ltcy5jICAg
ICAgICAgIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGtl
cm5lbC9rYWxsc3ltc19zZWxmdGVzdC5jIHwgIDMgKysrCiAyIGZpbGVzIGNoYW5nZWQsIDU2
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9rZXJuZWwva2FsbHN5bXMuYyBiL2tlcm5l
bC9rYWxsc3ltcy5jCmluZGV4IDgzZjQ5OTE4MmM5YWEzMS4uMzM5NjcyNWQzOTg0MmEzIDEw
MDY0NAotLS0gYS9rZXJuZWwva2FsbHN5bXMuYworKysgYi9rZXJuZWwva2FsbHN5bXMuYwpA
QCAtMjY3LDYgKzI2Nyw1OSBAQCBzdGF0aWMgaW50IGthbGxzeW1zX2xvb2t1cF9uYW1lcyhj
b25zdCBjaGFyICpuYW1lLAogCXJldHVybiAwOwogfQogCit2b2lkIHRzdF9rYWxsc3ltc19s
b29rdXBfbmFtZShjb25zdCBjaGFyICpuYW1lKQoreworCWludCBpOworCWludCByZXQ7CisJ
aW50IGxvdywgbWlkLCBoaWdoOworCXVuc2lnbmVkIGludCBzZXEsIG9mZjsKKwljaGFyIG5h
bWVidWZbS1NZTV9OQU1FX0xFTl07CisKKwlyZXQgPSBrYWxsc3ltc19sb29rdXBfbmFtZXMo
bmFtZSwgJmksIE5VTEwpOworCWlmICghcmV0KSB7CisJCXByX3dhcm4oInRzdDoga2FsbHN5
bXNfbG9va3VwX25hbWVzKCkgaXMgT0ssIG5hbWU9JXMsIGk9JWRcbiIsIG5hbWUsIGkpOwor
CQlyZXR1cm47CisJfQorCisKKwlmb3IgKGkgPSAwOyBpIDwga2FsbHN5bXNfbnVtX3N5bXM7
IGkrKykgeworCQlzZXEgPSBnZXRfc3ltYm9sX3NlcShpKTsKKwkJb2ZmID0gZ2V0X3N5bWJv
bF9vZmZzZXQoc2VxKTsKKwkJa2FsbHN5bXNfZXhwYW5kX3N5bWJvbChvZmYsIG5hbWVidWYs
IEFSUkFZX1NJWkUobmFtZWJ1ZikpOworCQlyZXQgPSBjb21wYXJlX3N5bWJvbF9uYW1lKG5h
bWUsIG5hbWVidWYpOworCQlpZiAoIXJldCkgeworCQkJcHJfd2FybigidHN0OiBmb3VuZCAl
cyBhdCBpbmRleD0lZFxuIiwgbmFtZSwgaSk7CisJCQlicmVhazsKKwkJfQorCX0KKworCWlm
IChpID09IGthbGxzeW1zX251bV9zeW1zKSB7CisJCXByX3dhcm4oInRzdDogZm91bmQgJXMg
ZmFpbGVkXG4iLCBuYW1lKTsKKwkJcmV0dXJuOworCX0KKworCWxvdyA9IDA7CisJaGlnaCA9
IGthbGxzeW1zX251bV9zeW1zIC0gMTsKKworCXdoaWxlIChsb3cgPD0gaGlnaCkgeworCQlt
aWQgPSBsb3cgKyAoaGlnaCAtIGxvdykgLyAyOworCQlzZXEgPSBnZXRfc3ltYm9sX3NlcSht
aWQpOworCQlvZmYgPSBnZXRfc3ltYm9sX29mZnNldChzZXEpOworCQlrYWxsc3ltc19leHBh
bmRfc3ltYm9sKG9mZiwgbmFtZWJ1ZiwgQVJSQVlfU0laRShuYW1lYnVmKSk7CisJCXByX3dh
cm4oInRzdDogWyVkXSA9ICVzLCBzZXE9JWQsIG9mZnNldD0lZFxuIiwgbWlkLCBuYW1lLCBz
ZXEsIG9mZik7CisJCXJldCA9IGNvbXBhcmVfc3ltYm9sX25hbWUobmFtZSwgbmFtZWJ1Zik7
CisJCWlmIChyZXQgPiAwKQorCQkJbG93ID0gbWlkICsgMTsKKwkJZWxzZSBpZiAocmV0IDwg
MCkKKwkJCWhpZ2ggPSBtaWQgLSAxOworCQllbHNlCisJCQlicmVhazsKKwl9CisKKwlpZiAo
bWlkID09IGkpCisJCXByX3dhcm4oInRzdDogYmluYXJ5IHNlYXJjaCBpcyBPS1xuIik7Cit9
CisKIC8qIExvb2t1cCB0aGUgYWRkcmVzcyBmb3IgdGhpcyBzeW1ib2wuIFJldHVybnMgMCBp
ZiBub3QgZm91bmQuICovCiB1bnNpZ25lZCBsb25nIGthbGxzeW1zX2xvb2t1cF9uYW1lKGNv
bnN0IGNoYXIgKm5hbWUpCiB7CmRpZmYgLS1naXQgYS9rZXJuZWwva2FsbHN5bXNfc2VsZnRl
c3QuYyBiL2tlcm5lbC9rYWxsc3ltc19zZWxmdGVzdC5jCmluZGV4IGYzNWQ5Y2MxYWFiMTU0
NC4uNzNhMjVhNWZiZTNlOWVmIDEwMDY0NAotLS0gYS9rZXJuZWwva2FsbHN5bXNfc2VsZnRl
c3QuYworKysgYi9rZXJuZWwva2FsbHN5bXNfc2VsZnRlc3QuYwpAQCAtMjkzLDYgKzI5Myw5
IEBAIHN0YXRpYyBpbnQgdGVzdF9rYWxsc3ltc19iYXNpY19mdW5jdGlvbih2b2lkKQogCXVu
c2lnbmVkIGxvbmcgYWRkciwgbG9va3VwX2FkZHI7CiAJY2hhciBuYW1lYnVmW0tTWU1fTkFN
RV9MRU5dOwogCXN0cnVjdCB0ZXN0X3N0YXQgKnN0YXQsICpzdGF0MjsKKwlleHRlcm4gdm9p
ZCB0c3Rfa2FsbHN5bXNfbG9va3VwX25hbWUoY29uc3QgY2hhciAqbmFtZSk7CisKKwl0c3Rf
a2FsbHN5bXNfbG9va3VwX25hbWUoImthbGxzeW1zX3Rlc3RfZnVuYyIpOwogCiAJc3RhdCA9
IGttYWxsb2Moc2l6ZW9mKCpzdGF0KSAqIDIsIEdGUF9LRVJORUwpOwogCWlmICghc3RhdCkK
LS0gCjIuMjUuMQoK
--------------6C44F0A13F580239C62817B7--
