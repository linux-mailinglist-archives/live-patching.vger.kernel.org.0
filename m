Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8092864F91E
	for <lists+live-patching@lfdr.de>; Sat, 17 Dec 2022 14:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLQNh2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Sat, 17 Dec 2022 08:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLQNh1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 17 Dec 2022 08:37:27 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C40120BE;
        Sat, 17 Dec 2022 05:37:24 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id ay32so4822595qtb.11;
        Sat, 17 Dec 2022 05:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEQhxkMBO6XWJFe+D6nzXPLObph3tXaHaWCQZey9h9Y=;
        b=KF8wQm5mje6ABdqvpnOQe0OyWYnoaDIXhpc2Zqd2a6JCIAlNHuO9Tc/utnMD6QYqFO
         52InTIIBieZtbCWDoCxpzMvGGtLwA2ujetcPuNcxWoaBjIh4joJZkemiAy0OKUBDaWsX
         jFWxvAPAjoWguGy1HPFmgJlrBDkYnVkMFdLRLZAmYoNVmBh4pjtkBaAA9IkFNMezXdxV
         FT0GHwiyFva2DTTJjUsvuj1uyGlhSftKXBOAvBvbulTGIEIf5koK6GRmkHcX5UBr9kpG
         DvLu6zZCSn8vZWBYHO6UsOeIbGCxJB+Mmp8uLK+U4ajldIsONr/rf8M2eiJWT0NJ38LU
         dwdw==
X-Gm-Message-State: AFqh2krulqa+dJygYldrNBFM1QPvFOjtNtXMlGqZRrN2Q9NQ++EdZb1a
        3APfQvQcvB6Jxi7sQMYxgyZ6eVmJdJPw+w==
X-Google-Smtp-Source: AMrXdXstLjUzBJhqz6Yf8n5agF/AOCmGAO90eDMzCNhL5PRRAiH+qCnF16IeEDacZSPnR4VTXJWRVw==
X-Received: by 2002:a05:622a:a05:b0:3a7:e8ab:2ae3 with SMTP id bv5-20020a05622a0a0500b003a7e8ab2ae3mr4857608qtb.25.1671284243072;
        Sat, 17 Dec 2022 05:37:23 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id v18-20020a05620a441200b006fed2788751sm3592727qkp.76.2022.12.17.05.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Dec 2022 05:37:22 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id 203so617399yby.10;
        Sat, 17 Dec 2022 05:37:22 -0800 (PST)
X-Received: by 2002:a25:7104:0:b0:702:90b4:2e24 with SMTP id
 m4-20020a257104000000b0070290b42e24mr14490470ybc.365.1671284241922; Sat, 17
 Dec 2022 05:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <e81710a9-2c45-0724-ec5f-727977202858@huawei.com> <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
 <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com> <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
 <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
 <06345dca-0afb-00a5-c9e9-5ba830d8ad05@huawei.com> <52450ec1da164d6d87587063c3b3d3d2@AcuMS.aculab.com>
 <592dce7a0de24c62bd31c29f86ce6c1b@AcuMS.aculab.com> <87pmcjidfe.fsf@igel.home>
 <1ba1fadb39994a4d91edabdfd9d69fa6@AcuMS.aculab.com> <87len7ibtt.fsf@igel.home>
 <c7cebe9da0474eb880ab14124ba290d0@AcuMS.aculab.com> <87fsdfib07.fsf@igel.home>
 <819801284eb745d9a4189759bad297f5@AcuMS.aculab.com> <20221216115314.6120beb7@gandalf.local.home>
 <ecf4939dbff84709a1782a8e8851b29f@AcuMS.aculab.com> <20221216121947.7d03b651@gandalf.local.home>
 <20221216123805.6eba002c@gandalf.local.home> <83701d57c0064c709669c03cecc38356@AcuMS.aculab.com>
 <066d4a61-3df9-b9c8-81a2-40dfcd3c73ef@huawei.com>
In-Reply-To: <066d4a61-3df9-b9c8-81a2-40dfcd3c73ef@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 17 Dec 2022 14:37:09 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXeusQbcfymQpKD4EWjBgKF4Wr8o2LyJhyaj3tS2MKTiQ@mail.gmail.com>
Message-ID: <CAMuHMdXeusQbcfymQpKD4EWjBgKF4Wr8o2LyJhyaj3tS2MKTiQ@mail.gmail.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

On Sat, Dec 17, 2022 at 8:32 AM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
> On 2022/12/17 3:27, David Laight wrote:
> > From: Steven Rostedt
> >> Sent: 16 December 2022 17:38
> >>
> >> On Fri, 16 Dec 2022 12:19:47 -0500
> >> Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >>> I assumed that "memory" was for memory unrelated to the input constraints.
> >>
> >> Well, it looks like you do need a "memory" barrier.
> >>
> >>   https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
> >>
> >> "memory"
> >>
> >>       The "memory" clobber tells the compiler that the assembly code
> >>       performs memory reads or writes to items other than those listed in
> >>       the input and output operands (for example, accessing the memory
> >>       pointed to by one of the input parameters). To ensure memory contains
> >>       correct values, GCC may need to flush specific register values to
> >>       memory before executing the asm. Further, the compiler does not
> >>       assume that any values read from memory before an asm remain
> >>       unchanged after that asm; it reloads them as needed. Using the
> >>       "memory" clobber effectively forms a read/write memory barrier for
> >>       the compiler.
> >>
> >> As the "(for example, accessing the memory pointed to by one of the input
> >> parameters)" is exactly this case.
> >
> > Without the memory clobber code like:
> > int f(const char *s)
> > {
> >       char c[4] = "abc";
> >       return strcmp(s, c);
> > }
> > is very like to get optimised so that c[] is never written.
> >
> > However, in this case, the strings have all existed for ages.
> > So that won't be the problem.
> >
> > It might be obvious what is wrong from the asm output.
> > Although the binary-chop lookup is suspect I'd also check
> > that the sorted index is plausible - just tracing the first
> > 20 entries might be enough.
> > No point peering at the search code if the setup is wrong.
>
> 6.47.2.1 Volatile
> GCC’s optimizers sometimes discard asm statements if they determine there is no need for
> the output variables. Also, the optimizers may move code out of loops if they believe that
> the code will always return the same result (i.e. none of its input values change between
> calls). Using the volatile qualifier disables these optimizations.
>
> So it's quite possible (I didn't disassemble vmlinux, because I didn't learn m68k):

You don't have to disassemble, "make kernel/kallsyms.s" creates
annotated assembler.

> //binary search
> while (low <= high) {
>     ...
>     ret = compare_symbol_name(name, namebuf);   ----> (1)
>     if (!ret)
>         break;
> }
>
> low = mid;
> while (low) {
>     ...
>     if (compare_symbol_name(name, namebuf))     ----> (2)
>         break;
>     low--;
> }
>
> The pointer 'name' and 'namebuf' of (1) and (2) are the same,
> so the 'if' statement of (2) maybe omitted by compiler.

And that is exactly what is happening: there are 3 calls to strcmp()
with the exact same parameters, and gcc omits two of them, because it
assumes it can predict the outcome, as the parameters haven't changed.

Now, why have we never noticed this before? I guess because it is very
uncommon for a function calling strcmp() multiple times with the exact
same pointer parameters.  Common users change the pointers before
every call, instead of keeping the pointer, but changing the buffers'
contents the pointers point to.

> By the way, I tried no volatile but with
> +               : : "memory");
> It also works well.

Indeed, gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04) generates the
same code for either adding the volatile or the memory clobber.

Note that strcmp() is the only function in arch/m68k/include/asm/string.h
using inline asm without the volatile keyword.  I guess we would
see similar issues with strnlen() (which also doesn't modify memory)
when dropping the volatile.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
