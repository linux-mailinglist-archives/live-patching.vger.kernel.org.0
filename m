Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A927B64DC35
	for <lists+live-patching@lfdr.de>; Thu, 15 Dec 2022 14:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLONZL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Dec 2022 08:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLONZH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Dec 2022 08:25:07 -0500
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5A52EF5F;
        Thu, 15 Dec 2022 05:25:05 -0800 (PST)
Received: by mail-vk1-f173.google.com with SMTP id b81so4702295vkf.1;
        Thu, 15 Dec 2022 05:25:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwOvoQprZDVQRzs2vhwkIOuB19lw7EaaQpyGlGPGWf8=;
        b=PYCgManLj1tBRH6Rdx1tkgM7ad02cXj+ZaZNNVmsvDKP0l7TlG5/S/ekdMIaJr9f+y
         P7oFh1Yi4cA69WdGTQiTNrzm+aB76Sg5gf1ENHfUmiw+k2lvFwK+jYa8nYw5xPAVaEay
         SZZf2f+GJzPsHKrK/Gmxbozs2Bv2ppe3xNbZf9sTQWEsDJylUSbdK/DHbFJQR9qLiqC5
         bxyP+twQ2MdC8nPIiJtQL3XIbeceODtDnC1r98uNirZUexM15N1N0I1JKVk4UDbgl582
         1qLFUFwbK2IWB9wHWMrjODWgRqwx6wwF1VFgAtwDWrYdpaicnTz/GgXi3E/u8EWizPBD
         BmNg==
X-Gm-Message-State: AFqh2koYdue0r6BEiEdNaX8SZ6FzqHRlquRb3W5X1529uv2TzC2fW9iw
        z8J1NN08ahmlaop0cWr73kROPc+bZYa2gA==
X-Google-Smtp-Source: AMrXdXsh7CEQvl3nM+y1yZusXcff+IXZdyXsP1ZNJ6t3Nrhwp1V8ko8tuBAJG7zJKprFAZPShxCQZQ==
X-Received: by 2002:a05:6122:e1e:b0:3c4:9181:a6ab with SMTP id bk30-20020a0561220e1e00b003c49181a6abmr3636665vkb.0.1671110703808;
        Thu, 15 Dec 2022 05:25:03 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id q7-20020a05620a0d8700b006cf38fd659asm12125552qkl.103.2022.12.15.05.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 05:25:03 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id j206so3472303ybj.1;
        Thu, 15 Dec 2022 05:25:02 -0800 (PST)
X-Received: by 2002:a25:9e84:0:b0:6de:6183:c5c3 with SMTP id
 p4-20020a259e84000000b006de6183c5c3mr77689635ybq.89.1671110702515; Thu, 15
 Dec 2022 05:25:02 -0800 (PST)
MIME-Version: 1.0
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com> <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
In-Reply-To: <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Dec 2022 14:24:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
Message-ID: <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Zhen,

CC Jason

On Thu, Dec 15, 2022 at 1:34 PM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
> On 2022/12/15 17:39, Geert Uytterhoeven wrote:
> > On Thu, Dec 15, 2022 at 10:16 AM Leizhen (ThunderTown)
> > <thunder.leizhen@huawei.com> wrote:
> >> On 2022/12/15 16:50, Geert Uytterhoeven wrote:
> >>> On Tue, Nov 15, 2022 at 9:41 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> >>>> Added test cases for basic functions and performance of functions
> >>>> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
> >>>> kallsyms_on_each_match_symbol(). It also calculates the compression rate
> >>>> of the kallsyms compression algorithm for the current symbol set.
> >>>>
> >>>> The basic functions test begins by testing a set of symbols whose address
> >>>> values are known. Then, traverse all symbol addresses and find the
> >>>> corresponding symbol name based on the address. It's impossible to
> >>>> determine whether these addresses are correct, but we can use the above
> >>>> three functions along with the addresses to test each other. Due to the
> >>>> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
> >>>> symbols can be tested in one second, so let it test on average once
> >>>> every 128 symbols. The other two functions validate all symbols.
> >>>>
> >>>> If the basic functions test is passed, print only performance test
> >>>> results. If the test fails, print error information, but do not perform
> >>>> subsequent performance tests.
> >>>>
> >>>> Start self-test automatically after system startup if
> >>>> CONFIG_KALLSYMS_SELFTEST=y.
> >>>>
> >>>> Example of output content: (prefix 'kallsyms_selftest:' is omitted
> >>>>  start
> >>>>   ---------------------------------------------------------
> >>>>  | nr_symbols | compressed size | original size | ratio(%) |
> >>>>  |---------------------------------------------------------|
> >>>>  |     107543 |       1357912   |      2407433  |  56.40   |
> >>>>   ---------------------------------------------------------
> >>>>  kallsyms_lookup_name() looked up 107543 symbols
> >>>>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
> >>>>  kallsyms_on_each_symbol() traverse all: 11782628 ns
> >>>>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
> >>>>  finish
> >>>>
> >>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>
> >>> Thanks for your patch, which is now commit 30f3bb09778de64e ("kallsyms:
> >>> Add self-test facility") in linus/master.
> >>>
> >>> I gave this a try on m68k (atari_defconfig + CONFIG_KALLSYMS_SELFTEST=y),
> >>> but it failed:
> >>>
> >>>     start
> >>>     kallsyms_lookup_name() for kallsyms_test_func_static failed:
> >>> addr=0, expect 60ab0
> >>>     kallsyms_lookup_name() for kallsyms_test_func failed: addr=0, expect 60ac0
> >>>     kallsyms_lookup_name() for kallsyms_test_func_weak failed: addr=0,
> >>> expect 60ac2
> >>>     kallsyms_lookup_name() for vmalloc failed: addr=0, expect c272a
> >>>     kallsyms_lookup_name() for vfree failed: addr=0, expect c2142
> >>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_static
> >>> failed: count=0, addr=0, expect 60ab0
> >>>     kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
> >>> count=0, addr=0, expect 60ac0
> >>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
> >>> failed: count=0, addr=0, expect 60ac2
> >>>     kallsyms_on_each_match_symbol() for vmalloc failed: count=0,
> >>> addr=0, expect c272a
> >>>     kallsyms_on_each_match_symbol() for vfree failed: count=0, addr=0,
> >>> expect c2142
> >>>     abort
> >>>
> >>> Given all addresses are zero, it looks like some required functionality
> >>> or config option is missing.
> >>>
> >>> $ grep SYM .config
> >>> CONFIG_KALLSYMS=y
> >>> CONFIG_KALLSYMS_SELFTEST=y
> >>> CONFIG_KALLSYMS_BASE_RELATIVE=y
> >>> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> >>> CONFIG_SYMBOLIC_ERRNAME=y
> >>> # CONFIG_STRIP_ASM_SYMS is not set
> >>> CONFIG_KALLSYMS_SELFTEST
> >>>
> >>> Do you have a clue?
> >>
> >> cat /proc/kallsyms | grep kallsyms_test_func
> >> Let's see if the compiler-generated symbols have some special suffixes.
> >
> > Thanks, looks normal to me:
> >
> >     atari:~# cat /proc/kallsyms | grep kallsyms_test_func
> >     00060ab0 t kallsyms_test_func_static
> >     00060ac0 T kallsyms_test_func
> >     00060ac2 W kallsyms_test_func_weak
> >     atari:~#
>
> It's incredible. I don't have a m68k environment and I'm trying to build a qemu
> environment. If you're in a hurry and willing, you can apply the debugging patch
> in the attachment. I'd like to see what's wrong. Use "dmesg | grep tst" to collect
> the output information.

Still fails:

    tst: found kallsyms_test_func at index=12845
    tst: [12533] = kallsyms_test_func, seq=17370, offset=191223
    tst: [18800] = kallsyms_test_func, seq=23193, offset=259263
    tst: [21934] = kallsyms_test_func, seq=2527, offset=22331
    tst: [23501] = kallsyms_test_func, seq=11792, offset=126366
    tst: [24284] = kallsyms_test_func, seq=8427, offset=87395
    tst: [24676] = kallsyms_test_func, seq=21896, offset=243536
    tst: [24872] = kallsyms_test_func, seq=22571, offset=251856
    tst: [24970] = kallsyms_test_func, seq=23264, offset=260074
    tst: [25019] = kallsyms_test_func, seq=9003, offset=93752
    tst: [25043] = kallsyms_test_func, seq=14324, offset=155117
    tst: [25055] = kallsyms_test_func, seq=5942, offset=62266
    tst: [25061] = kallsyms_test_func, seq=14347, offset=155467
    tst: [25064] = kallsyms_test_func, seq=14350, offset=155512
    tst: [25066] = kallsyms_test_func, seq=14346, offset=155457
    tst: [25067] = kallsyms_test_func, seq=14354, offset=155565

However, the binary search sequence looks very suspicious.
After investigation, it turns out compare_symbol_name() and strcmp()
always return positive numbers.

Looks like commit 3bc753c06dd02a35 ("kbuild: treat char as always
unsigned") is to blame.

Changing:

    --- a/arch/m68k/include/asm/string.h
    +++ b/arch/m68k/include/asm/string.h
    @@ -42,7 +42,7 @@ static inline char *strncpy(char *dest, const
char *src, size_t n)
     #define __HAVE_ARCH_STRCMP
     static inline int strcmp(const char *cs, const char *ct)
     {
    -       char res;
    +       signed char res;

            asm ("\n"
                    "1:     move.b  (%0)+,%2\n"     /* get *cs */

fixes strcmp, but the test still fails:

    tst: kallsyms_lookup_names() is OK, name=kallsyms_test_func, i=0
    kallsyms_selftest: kallsyms_lookup_name() for
kallsyms_test_func_static failed: addr=8e1c, expect 60cd4
    kallsyms_selftest: kallsyms_lookup_name() for kallsyms_test_func
failed: addr=8e1c, expect 60ce4
    kallsyms_selftest: kallsyms_lookup_name() for
kallsyms_test_func_weak failed: addr=8e1c, expect 60ce6
    kallsyms_selftest: kallsyms_lookup_name() for vmalloc failed:
addr=8e1c, expect c2946
    kallsyms_selftest: kallsyms_lookup_name() for vfree failed:
addr=8e1c, expect c235e
    kallsyms_selftest: kallsyms_on_each_match_symbol() for
kallsyms_test_func_static failed: count=25068, addr=1f3d3c, expect
60cd4
    kallsyms_selftest: kallsyms_on_each_match_symbol() for
kallsyms_test_func failed: count=25068, addr=1f3d3c, expect 60ce4
    kallsyms_selftest: kallsyms_on_each_match_symbol() for
kallsyms_test_func_weak failed: count=25068, addr=1f3d3c, expect 60ce6
    kallsyms_selftest: kallsyms_on_each_match_symbol() for vmalloc
failed: count=25068, addr=1f3d3c, expect c2946
    kallsyms_selftest: kallsyms_on_each_match_symbol() for vfree
failed: count=25068, addr=1f3d3c, expect c235e
    kallsyms_selftest: abort

Dropping -funsigned-char doesn't improve upon that...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
