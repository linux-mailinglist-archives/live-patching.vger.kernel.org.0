Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17EC793FED
	for <lists+live-patching@lfdr.de>; Wed,  6 Sep 2023 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242336AbjIFPHD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Sep 2023 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242358AbjIFPHC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Sep 2023 11:07:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B941990;
        Wed,  6 Sep 2023 08:06:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7DDC433CD;
        Wed,  6 Sep 2023 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694012811;
        bh=8R4kzh3nTSqACHjy9Igl6y50DXqOQIL6KrU6Xizd5vw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AhWcnUbZ+xiAHtObPOonQ+/3NaC1cqET1bOPJgIMdhVZyxeUDtximhNM1VeLq7jJO
         WnDoh+ChzesxUgRi5ykHRvVdLBWFOGdUWnPjrryEYomWsbfusvvHlA1i83vtKsTuVf
         O9w2nvS6DEojbkdATDQsk/fE7QZ8yg6rLJjsOdcn+4cUcL+aYiqxqzckDGluhSe99a
         d3rXta069sDO3orkisIZR+unsGClW+oAJbgSUvK6bVcgm2R1EMAsl+d6bMKRwTnDbZ
         cC6SL+MhYSdCQdGMILC4dnTWs52jBbJdujfzVSsSW+qQSiBENhmxlL+D8S6lijxtlS
         y3yvYICVYFdVw==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5733bcf6eb6so2049257eaf.0;
        Wed, 06 Sep 2023 08:06:51 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx+PRNKN3vmGnmbPuw3OUU3liDjPr3gWw1SCkP0vepCz8YMS/Cm
        w/YhrAI0IhWNWADed5g6K407AVgkS3ltjVqL968=
X-Google-Smtp-Source: AGHT+IHs9MYVYX/hL5BllUuyFYnsWzXobUhMf+WTR4jpf255UF4qgkKxgbZrXP3NqiWFcMlEU6SXSZNicl0p1mJq7Xo=
X-Received: by 2002:a4a:6c11:0:b0:573:4e21:5d25 with SMTP id
 q17-20020a4a6c11000000b005734e215d25mr12858374ooc.9.1694012810670; Wed, 06
 Sep 2023 08:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
 <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com> <CAPp5cGQgn0kfxPc+pmLMEJmHzOJ2HQQbsWSE0LFsxi4bigHOdQ@mail.gmail.com>
In-Reply-To: <CAPp5cGQgn0kfxPc+pmLMEJmHzOJ2HQQbsWSE0LFsxi4bigHOdQ@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 7 Sep 2023 00:06:14 +0900
X-Gmail-Original-Message-ID: <CAK7LNATRCcQ7yBjoBiq8remJtVA0hfSr=yW-oY1_m9WneQuvQQ@mail.gmail.com>
Message-ID: <CAK7LNATRCcQ7yBjoBiq8remJtVA0hfSr=yW-oY1_m9WneQuvQQ@mail.gmail.com>
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
To:     Alessandro Carminati <alessandro.carminati@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Nick Alcock <nick.alcock@oracle.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Eugene Loh <eugene.loh@oracle.com>,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Viktor Malik <vmalik@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 6, 2023 at 7:09=E2=80=AFPM Alessandro Carminati
<alessandro.carminati@gmail.com> wrote:
>
> Hello Masahiro,
>
> Thank you for your suggestions,
> Il giorno sab 2 set 2023 alle ore 08:36 Masahiro Yamada
> <masahiroy@kernel.org> ha scritto:
> >
> > On Mon, Aug 28, 2023 at 8:45=E2=80=AFPM Alessandro Carminati (Red Hat)
> > <alessandro.carminati@gmail.com> wrote:
> > >
> > > From: Alessandro Carminati <alessandro.carminati@gmail.com>
> > >
> > > It is not uncommon for drivers or modules related to similar peripher=
als
> > > to have symbols with the exact same name.
> > > While this is not a problem for the kernel's binary itself, it become=
s an
> > > issue when attempting to trace or probe specific functions using
> > > infrastructure like ftrace or kprobe.
> > >
> > > The tracing subsystem relies on the `nm -n vmlinux` output, which pro=
vides
> > > symbol information from the kernel's ELF binary. However, when multip=
le
> > > symbols share the same name, the standard nm output does not differen=
tiate
> > > between them. This can lead to confusion and difficulty when trying t=
o
> > > probe the intended symbol.
> > >
> > >  ~ # cat /proc/kallsyms | grep " name_show"
> > >  ffffffff8c4f76d0 t name_show
> > >  ffffffff8c9cccb0 t name_show
> > >  ffffffff8cb0ac20 t name_show
> > >  ffffffff8cc728c0 t name_show
> > >  ffffffff8ce0efd0 t name_show
> > >  ffffffff8ce126c0 t name_show
> > >  ffffffff8ce1dd20 t name_show
> > >  ffffffff8ce24e70 t name_show
> > >  ffffffff8d1104c0 t name_show
> > >  ffffffff8d1fe480 t name_show
> > >
> > > **kas_alias** addresses this challenge by extending the symbol names =
with
> > > unique suffixes during the kernel build process.
> > > The newly created aliases for these duplicated symbols are unique nam=
es
> > > that can be fed to the ftracefs interface. By doing so, it enables
> > > previously unreachable symbols to be probed.
> > >
> > >  ~ # cat /proc/kallsyms | grep " name_show"
> > >  ffffffff974f76d0 t name_show
> > >  ffffffff974f76d0 t name_show__alias__6340
> > >  ffffffff979cccb0 t name_show
> > >  ffffffff979cccb0 t name_show__alias__6341
> > >  ffffffff97b0ac20 t name_show
> > >  ffffffff97b0ac20 t name_show__alias__6342
> > >  ffffffff97c728c0 t name_show
> > >  ffffffff97c728c0 t name_show__alias__6343
> > >  ffffffff97e0efd0 t name_show
> > >  ffffffff97e0efd0 t name_show__alias__6344
> > >  ffffffff97e126c0 t name_show
> > >  ffffffff97e126c0 t name_show__alias__6345
> > >  ffffffff97e1dd20 t name_show
> > >  ffffffff97e1dd20 t name_show__alias__6346
> > >  ffffffff97e24e70 t name_show
> > >  ffffffff97e24e70 t name_show__alias__6347
> > >  ffffffff981104c0 t name_show
> > >  ffffffff981104c0 t name_show__alias__6348
> > >  ffffffff981fe480 t name_show
> > >  ffffffff981fe480 t name_show__alias__6349
> > >  ~ # echo "p:kprobes/evnt1 name_show__alias__6349" \
> > >  > >/sys/kernel/tracing/kprobe_events
> > >  ~ # cat /sys/kernel/tracing/kprobe_events
> > >  p:kprobes/evnt1 name_show__alias__6349
> > >
> > > Changes from v1:
> > > - Integrated changes requested by Masami to exclude symbols with pref=
ixes
> > >   "_cfi" and "_pfx".
> > > - Introduced a small framework to handle patterns that need to be exc=
luded
> > >   from the alias production.
> > > - Excluded other symbols using the framework.
> > > - Introduced the ability to discriminate between text and data symbol=
s.
> > > - Added two new config symbols in this version: CONFIG_KALLSYMS_ALIAS=
_DATA,
> > >   which allows data for data, and CONFIG_KALLSYMS_ALIAS_DATA_ALL, whi=
ch
> > >   excludes all filters and provides an alias for each duplicated symb=
ol.
> > >
> > > https://lore.kernel.org/all/20230711151925.1092080-1-alessandro.carmi=
nati@gmail.com/
> > >
> > > Changes from v2:
> > > - Alias tags are created by querying DWARF information from the vmlin=
ux.
> > > - The filename + line number is normalized and appended to the origin=
al name.
> > > - The tag begins with '@' to indicate the symbol source.
> > > - Not a change, but worth mentioning, since the alias is added to the=
 existing
> > >   list, the old duplicated name is preserved, and the livepatch way o=
f dealing
> > >   with duplicates is maintained.
> > > - Acknowledging the existence of scenarios where inlined functions de=
clared in
> > >   header files may result in multiple copies due to compiler behavior=
, though
> > >    it is not actionable as it does not pose an operational issue.
> > > - Highlighting a single exception where the same name refers to diffe=
rent
> > >   functions: the case of "compat_binfmt_elf.c," which directly includ=
es
> > >   "binfmt_elf.c" producing identical function copies in two separate
> > >   modules.
> > >
> > > sample from new v3
> > >
> > >  ~ # cat /proc/kallsyms | grep gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> > >  ffffd0b03c050960 t gic_mask_irq
> > >  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
> > >  ~ #
> > >
> > > https://lore.kernel.org/all/20230714150326.1152359-1-alessandro.carmi=
nati@gmail.com/
> > >
> > > Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@g=
mail.com>
> > > ---
> > >  init/Kconfig                        |  36 ++++
> > >  scripts/Makefile                    |   4 +
> > >  scripts/kas_alias/Makefile          |   4 +
> > >  scripts/kas_alias/a2l.c             | 268 ++++++++++++++++++++++++++=
++
> > >  scripts/kas_alias/a2l.h             |  32 ++++
> > >  scripts/kas_alias/duplicates_list.c |  70 ++++++++
> > >  scripts/kas_alias/duplicates_list.h |  15 ++
> > >  scripts/kas_alias/item_list.c       | 230 ++++++++++++++++++++++++
> > >  scripts/kas_alias/item_list.h       |  26 +++
> > >  scripts/kas_alias/kas_alias.c       | 217 ++++++++++++++++++++++
> > >  scripts/link-vmlinux.sh             |  11 +-
> > >  11 files changed, 910 insertions(+), 3 deletions(-)
> >
> >
> > I added some review comments in another thread, but
> > one of the biggest concerns might be "910 insertions".
> >
> >
> > What this program does is quite simple,
> > "find duplicated names, and call addr2line".
> >
> >
> >
> > You wrote a lot of code to self-implement these:
> >
> >  - sort function
> >  - parse PATH env variable to find addr2line
> >  - fork addr2line to establish pipe communications
> >
> >
> >
> > Have you considered writing the code in Python (or Perl)?
> > Is it too slow?
>
> I have attempted to incorporate all your suggestions.
> I refactored the C code to utilize hashing instead of sorting, and I
> completely re-implemented the entire thing in Python for the purpose of
> comparison.
>
> You are correct;
> the C version is indeed faster, but the difference is negligible when
> considering the use case and code maintainability.


Nice. Then, I prefer shorter code.

The Python implementation is 0.2 sec slower
(given the script is executed three times, 0.6 sec cost in total)
but it is not a big issue, I think.

Thanks.









>
> Here's a direct comparison of the two.
> ```
> ~ $ time ./kas_alias.py -a /usr/bin/aarch64-linux-gnu-addr2line \
>                       -n linux-6.5/.tmp_vmlinux.kallsyms1.syms \
>                       -v linux-6.5/.tmp_vmlinux.kallsyms1 \
>                       -o output_py
>
> real    0m1.626s
> user    0m1.436s
> sys     0m0.185s
> $ cat kas_alias.py | wc -l
> 133
> ~ $ time ./kas_alias -a /usr/bin/aarch64-linux-gnu-addr2line \
>                    -v linux-6.5/.tmp_vmlinux.kallsyms1 \
>                    -n linux-6.5/.tmp_vmlinux.kallsyms1.syms \
>                    -o output_c
>
> real    0m1.418s
> user    0m1.262s
> sys     0m0.162s
> ~ $ cat a2l.c a2l.h conf.c conf.h item_list.c item_list.h kas_alias.c | w=
c -l
> 742
> ~ $ diff output_py output_c
> ~ $
> ```
> C version is 7/10% faster but is more than 5 times in terms of code size.
>
> >
> > Most of the functions you implemented are already
> > available in script languages.
> >
> >
> >
> > I am not sure if "@<file-path>" is a good solution,
> > but the amount of the added code looks too much to me.
>
> I followed Francis's suggestion and made the separator between
> <symbol name> and <normalized filename> an argument that you can select
> using the command line. Since I'm not aware of a better choice, I set the
> default value to '@'.
>
> >
> >
> >
> >
> > --
> > Best Regards
> > Masahiro Yamada
>
> Best regards
> Alessandro Carminati



--=20
Best Regards
Masahiro Yamada
