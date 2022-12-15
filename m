Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9F764DD07
	for <lists+live-patching@lfdr.de>; Thu, 15 Dec 2022 15:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLOOnQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Dec 2022 09:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiLOOnP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Dec 2022 09:43:15 -0500
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D21B2F007;
        Thu, 15 Dec 2022 06:43:14 -0800 (PST)
Received: by mail-qt1-f178.google.com with SMTP id ay32so5235401qtb.11;
        Thu, 15 Dec 2022 06:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e+PJ8OM02fEspKYgpZeR8IY6KQB1JYasGRGdsiTWkdU=;
        b=AId3zPz7HUrq12V14Ztevj2wX+5sTu26NaCt+pg6lVCvt/+iIwvPTo1uLUMBaJPc+S
         pJBIeD/R6Ags2+aZRQSnXgD/ezjUDusIe+O+lZBE06WD7QaHNcs3PVOGuIuVGVJgplqx
         C5foZKb/ayQnNX4AjhuG80K2w9M38dvrwmUau3YQhAvesFJ4ohdLM1CpdAw07+0icvHI
         4h8ilVw3NkYDlRbkK8G1vljsEMBy6UN3a/tIXBs11qkU/tMiKfJxHvlPRaTTND+97CtX
         3LwFfqZmuVhccE4HcSp9V1Xk8oUDOIFDU89MF/RTrbyuw9EuNAsZYQNRkB4CYZls2KIL
         kuGA==
X-Gm-Message-State: ANoB5pmkEQtjAM7x0b/NUbRygX1M1ffJrGq31NQmaZgHGGQcYcG6sjKP
        oHtI82UUTCFW/HaAooC25kmQOHFzZoSE6g==
X-Google-Smtp-Source: AA0mqf59leRD8AiV58l6ApSObx2mtRuO/vA9+GNx7ALnE8LAVPVeAyXojO4Kq2O/fMhvLQ1LlrZYuA==
X-Received: by 2002:ac8:7a85:0:b0:3a8:28fb:b076 with SMTP id x5-20020ac87a85000000b003a828fbb076mr12407213qtr.31.1671115393001;
        Thu, 15 Dec 2022 06:43:13 -0800 (PST)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id x8-20020ac84d48000000b00398a7c860c2sm3547853qtv.4.2022.12.15.06.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 06:43:12 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-3e78d07ab4fso43670827b3.9;
        Thu, 15 Dec 2022 06:43:12 -0800 (PST)
X-Received: by 2002:a0d:dd4b:0:b0:370:61f5:b19e with SMTP id
 g72-20020a0ddd4b000000b0037061f5b19emr28138210ywe.316.1671115391829; Thu, 15
 Dec 2022 06:43:11 -0800 (PST)
MIME-Version: 1.0
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com> <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com> <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
 <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
In-Reply-To: <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Dec 2022 15:43:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU2fge6UJwKAKOAFqtsnhVyfX80g703TRUoPRK_aeuu-w@mail.gmail.com>
Message-ID: <CAMuHMdU2fge6UJwKAKOAFqtsnhVyfX80g703TRUoPRK_aeuu-w@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Zhen,

On Thu, Dec 15, 2022 at 2:58 PM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
> On 2022/12/15 21:24, Geert Uytterhoeven wrote:
> > On Thu, Dec 15, 2022 at 1:34 PM Leizhen (ThunderTown)
> > <thunder.leizhen@huawei.com> wrote:
> >> On 2022/12/15 17:39, Geert Uytterhoeven wrote:
> >>> On Thu, Dec 15, 2022 at 10:16 AM Leizhen (ThunderTown)
> >>> <thunder.leizhen@huawei.com> wrote:
> >>>> On 2022/12/15 16:50, Geert Uytterhoeven wrote:
> >>>>> On Tue, Nov 15, 2022 at 9:41 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> >>>>>> Added test cases for basic functions and performance of functions
> >>>>>> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
> >>>>>> kallsyms_on_each_match_symbol(). It also calculates the compression rate
> >>>>>> of the kallsyms compression algorithm for the current symbol set.
> >>>>>>
> >>>>>> The basic functions test begins by testing a set of symbols whose address
> >>>>>> values are known. Then, traverse all symbol addresses and find the
> >>>>>> corresponding symbol name based on the address. It's impossible to
> >>>>>> determine whether these addresses are correct, but we can use the above
> >>>>>> three functions along with the addresses to test each other. Due to the
> >>>>>> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
> >>>>>> symbols can be tested in one second, so let it test on average once
> >>>>>> every 128 symbols. The other two functions validate all symbols.
> >>>>>>
> >>>>>> If the basic functions test is passed, print only performance test
> >>>>>> results. If the test fails, print error information, but do not perform
> >>>>>> subsequent performance tests.
> >>>>>>
> >>>>>> Start self-test automatically after system startup if
> >>>>>> CONFIG_KALLSYMS_SELFTEST=y.
> >>>>>>
> >>>>>> Example of output content: (prefix 'kallsyms_selftest:' is omitted
> >>>>>>  start
> >>>>>>   ---------------------------------------------------------
> >>>>>>  | nr_symbols | compressed size | original size | ratio(%) |
> >>>>>>  |---------------------------------------------------------|
> >>>>>>  |     107543 |       1357912   |      2407433  |  56.40   |
> >>>>>>   ---------------------------------------------------------
> >>>>>>  kallsyms_lookup_name() looked up 107543 symbols
> >>>>>>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
> >>>>>>  kallsyms_on_each_symbol() traverse all: 11782628 ns
> >>>>>>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
> >>>>>>  finish
> >>>>>>
> >>>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>>>
> >>>>> Thanks for your patch, which is now commit 30f3bb09778de64e ("kallsyms:
> >>>>> Add self-test facility") in linus/master.
> >>>>>
> >>>>> I gave this a try on m68k (atari_defconfig + CONFIG_KALLSYMS_SELFTEST=y),
> >>>>> but it failed:
> >>>>>
> >>>>>     start
> >>>>>     kallsyms_lookup_name() for kallsyms_test_func_static failed:
> >>>>> addr=0, expect 60ab0
> >>>>>     kallsyms_lookup_name() for kallsyms_test_func failed: addr=0, expect 60ac0
> >>>>>     kallsyms_lookup_name() for kallsyms_test_func_weak failed: addr=0,
> >>>>> expect 60ac2
> >>>>>     kallsyms_lookup_name() for vmalloc failed: addr=0, expect c272a
> >>>>>     kallsyms_lookup_name() for vfree failed: addr=0, expect c2142
> >>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_static
> >>>>> failed: count=0, addr=0, expect 60ab0
> >>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
> >>>>> count=0, addr=0, expect 60ac0
> >>>>>     kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
> >>>>> failed: count=0, addr=0, expect 60ac2
> >>>>>     kallsyms_on_each_match_symbol() for vmalloc failed: count=0,
> >>>>> addr=0, expect c272a
> >>>>>     kallsyms_on_each_match_symbol() for vfree failed: count=0, addr=0,
> >>>>> expect c2142
> >>>>>     abort

> Oh, maybe you can "git reset --hard 30f3bb09778de64" and try again.
> 30f3bb09778de64 kallsyms: Add self-test facility
>
> But the latest kernel is OK on x86. So other patches are unlikely to
> affect this function.

On 30f3bb09778de64 it fails the same way:

    start
    kallsyms_lookup_name() for kallsyms_test_func_static failed:
addr=8dbc, expect 60308
    kallsyms_lookup_name() for kallsyms_test_func failed: addr=8dbc,
expect 60318
    kallsyms_lookup_name() for kallsyms_test_func_weak failed:
addr=8dbc, expect 6031a
    kallsyms_lookup_name() for vmalloc failed: addr=8dbc, expect bdc88
    kallsyms_lookup_name() for vfree failed: addr=8dbc, expect bd6de
    kallsyms_on_each_match_symbol() for kallsyms_test_func_static
failed: count=24890, addr=1ee870, expect 60308
    kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
count=24890, addr=1ee870, expect 60318
    kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
failed: count=24890, addr=1ee870, expect 6031a
    kallsyms_on_each_match_symbol() for vmalloc failed: count=24890,
addr=1ee870, expect bdc88
    kallsyms_on_each_match_symbol() for vfree failed: count=24890,
addr=1ee870, expect bd6de
    abort

> Is m68k big-endian?

Yes it is. And 32-bit values are aligned to only 2 bytes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
