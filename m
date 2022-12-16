Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0300464EA65
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 12:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLPL2j (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 06:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLPL2i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 06:28:38 -0500
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623662A409;
        Fri, 16 Dec 2022 03:28:37 -0800 (PST)
Received: by mail-qv1-f45.google.com with SMTP id c14so1480286qvq.0;
        Fri, 16 Dec 2022 03:28:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cpsh6MRE6XYtx9/rCflIcIbNFehaXSviVtyQLfJ5VOk=;
        b=0b+XLxVJFLps7fTjsm9dhvP3y/BLGrpyYeMYItXOdnth/AYbYB0U8+lC4cqX2UBGU5
         kCRaxMUrFufiQPyri6eqZBN9iJkGcxeX5WpVa7cZRSmF826F5vk6Mh/B+7qQ7RevJ3ko
         4N/XzVtfsnXYsy60IrPCwY81tgO/Kp+BdfcUOf9QgCuuzgKHiN7iednccDe138z5kpXJ
         09nb21r4wQDaBlWbgXLYgtlXgDOUl+yceq5PaLbF3jiBpdkCQHAT1dJzs1dQFFpDTqTa
         bwg05DzWu4m2Vbn6QT3FyQHFgORKBSneNoLzzhnSvoUwDZ7HRTvsScS9NyC+QFEf77Oi
         mmFg==
X-Gm-Message-State: ANoB5pnSdlVmPuunUXcQ1eGNZ9OuMi9Sv3NYfcDz7w6BElBIJTkX+QpZ
        Bo7poD6mhn/+MojfTPo76gAlU8TRT6I+IA==
X-Google-Smtp-Source: AA0mqf7AhfEI+eh6XTo/yL+6MisWUAAsxs59S8YZpcOlaQyDm1A730UJA8jO6K3+ArDHwr6Cpp6HBw==
X-Received: by 2002:a0c:fdea:0:b0:4c6:b888:5da with SMTP id m10-20020a0cfdea000000b004c6b88805damr35018984qvu.18.1671190116332;
        Fri, 16 Dec 2022 03:28:36 -0800 (PST)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id n11-20020a05620a294b00b006b5cc25535fsm1301168qkp.99.2022.12.16.03.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:28:35 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-3f15a6f72d0so29183067b3.1;
        Fri, 16 Dec 2022 03:28:34 -0800 (PST)
X-Received: by 2002:a0d:dd4b:0:b0:370:61f5:b19e with SMTP id
 g72-20020a0ddd4b000000b0037061f5b19emr28567896ywe.316.1671190114634; Fri, 16
 Dec 2022 03:28:34 -0800 (PST)
MIME-Version: 1.0
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com> <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com> <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
 <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com> <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
 <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
 <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com> <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
In-Reply-To: <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Dec 2022 12:28:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
Message-ID: <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
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

On Fri, Dec 16, 2022 at 10:43 AM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
> On 2022/12/16 15:42, Leizhen (ThunderTown) wrote:
> > On 2022/12/15 22:51, Geert Uytterhoeven wrote:
> >> On 30f3bb09778de64 with your debug patch v2:
> > I've set up the qemu environment, and I'll try to solve it by tomorrow at the latest.
>
> It seems that the problem is still strcmp(). After I commented strcmp() in
> arch/m68k/include/asm/string.h, and force it to use the one in lib/string.c,
> it works well.

I can confirm that.

One difference is that the one in lib/string.c always return -1/0/1,
while the m68k version can return other negative or positive numbers.

However, adding:

       if (res < 0) return -1;
       if (res > 0) return 1;

to the m68k version doesn't make a difference.

Renaming the m68k version (changed to -1/0/1) to m68k_strcmp(), and
the generic version to lib_strcmp(), and adding a wrapper that calls
and compares both, shows that both functions do return the same value,
and the test succeeds.

Moving the m68k version inside lib/string.c makes the test pass, too.
So it must be related to the function being inline, and gcc making
(incorrect) assumptions...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
