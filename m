Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D196793986
	for <lists+live-patching@lfdr.de>; Wed,  6 Sep 2023 12:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbjIFKJz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Sep 2023 06:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjIFKJz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Sep 2023 06:09:55 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87A79E;
        Wed,  6 Sep 2023 03:09:50 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-5738cb00eebso2198025eaf.2;
        Wed, 06 Sep 2023 03:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693994990; x=1694599790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hB+PvGMU7bVonbgCU3v3Efy35gCAE3hYixxnZD/At8=;
        b=dhF5NVxd+uiDT2QxuQsvKzqriKnOY/RST9IuW1hSKt6jbyfr0SeJSwRr9oa8Det382
         YcJyO5ieoCu33zEkibhMuSBwZSif6Y4ctnd591ajw17ZXSHwNrcXxmpvZSbJP3ijQimW
         1JEvXoCGcFpxa0B11+m57Inz8KqfntFVoVx7m8zeZz8pdP/kd6uUpSeT/ywhM4VkoXNA
         F1y8NJeNGmP1QttwuJ5tYAXn1Hj5GfvHw1q81wgY/HLfhHJPO5TkWKe1jMHhJ++VR8MB
         GVNEkpACNKxvXzhhdRFMYj1oAo23c2RzXps7rAYPa8ulkNxCUT4EsDj1In9bjnMcIy7Q
         VW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693994990; x=1694599790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hB+PvGMU7bVonbgCU3v3Efy35gCAE3hYixxnZD/At8=;
        b=kMtyZSNQawjRq78RsR+lCO3b5S6EBkBAEipSLbENN8BIY0z1XCJ5BXUj2UzaHQe7ht
         6Ay1fOka6fTa7QzLbBQs5SuGmZsf9PdUaibI5hJq7jydnJu0BcGheyVcsLKkjszvE1nC
         D13QYmSpRzDrX2VM1MEVpeusaza3SPJWDTJzEKUeq5OIh1eFXHApJVlbkWwHJBzaEJtJ
         9SACKNDuaZro1xyEab0caluGREwGC0eygcNo0QTYpmDQIaJ+a2NWq5Oxgd7S/Y8koPJ5
         P3mUYgSb4NaQtZT+JvBta8A5hlRpogmEZ6QDT8mtZqZND4IVK3wGx34ktCOqlz/4dh9s
         ah3w==
X-Gm-Message-State: AOJu0YxZQuS4mYYNXA8I5ENW4jD3cHvzUTRm4Rr5VW4qxnX1HuOCKYX4
        b8x59kw8QSoWGYnpggPXyj/G9M9eNbLR57ATMPo=
X-Google-Smtp-Source: AGHT+IGsVIO3Wdlzdu5IoNPsgfuXEEegjy8jw54qEODMt1x9AhK2XQp2UlXOyvRNEqjuDd11FqPfJpy8H/Hf20nIUGU=
X-Received: by 2002:a05:6820:284:b0:571:aceb:26ce with SMTP id
 q4-20020a056820028400b00571aceb26cemr14312637ood.1.1693994989962; Wed, 06 Sep
 2023 03:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com> <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
In-Reply-To: <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
From:   Alessandro Carminati <alessandro.carminati@gmail.com>
Date:   Wed, 6 Sep 2023 12:09:13 +0200
Message-ID: <CAPp5cGQgn0kfxPc+pmLMEJmHzOJ2HQQbsWSE0LFsxi4bigHOdQ@mail.gmail.com>
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
To:     Masahiro Yamada <masahiroy@kernel.org>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello Masahiro,

Thank you for your suggestions,
Il giorno sab 2 set 2023 alle ore 08:36 Masahiro Yamada
<masahiroy@kernel.org> ha scritto:
>
> On Mon, Aug 28, 2023 at 8:45=E2=80=AFPM Alessandro Carminati (Red Hat)
> <alessandro.carminati@gmail.com> wrote:
> >
> > From: Alessandro Carminati <alessandro.carminati@gmail.com>
> >
> > It is not uncommon for drivers or modules related to similar peripheral=
s
> > to have symbols with the exact same name.
> > While this is not a problem for the kernel's binary itself, it becomes =
an
> > issue when attempting to trace or probe specific functions using
> > infrastructure like ftrace or kprobe.
> >
> > The tracing subsystem relies on the `nm -n vmlinux` output, which provi=
des
> > symbol information from the kernel's ELF binary. However, when multiple
> > symbols share the same name, the standard nm output does not differenti=
ate
> > between them. This can lead to confusion and difficulty when trying to
> > probe the intended symbol.
> >
> >  ~ # cat /proc/kallsyms | grep " name_show"
> >  ffffffff8c4f76d0 t name_show
> >  ffffffff8c9cccb0 t name_show
> >  ffffffff8cb0ac20 t name_show
> >  ffffffff8cc728c0 t name_show
> >  ffffffff8ce0efd0 t name_show
> >  ffffffff8ce126c0 t name_show
> >  ffffffff8ce1dd20 t name_show
> >  ffffffff8ce24e70 t name_show
> >  ffffffff8d1104c0 t name_show
> >  ffffffff8d1fe480 t name_show
> >
> > **kas_alias** addresses this challenge by extending the symbol names wi=
th
> > unique suffixes during the kernel build process.
> > The newly created aliases for these duplicated symbols are unique names
> > that can be fed to the ftracefs interface. By doing so, it enables
> > previously unreachable symbols to be probed.
> >
> >  ~ # cat /proc/kallsyms | grep " name_show"
> >  ffffffff974f76d0 t name_show
> >  ffffffff974f76d0 t name_show__alias__6340
> >  ffffffff979cccb0 t name_show
> >  ffffffff979cccb0 t name_show__alias__6341
> >  ffffffff97b0ac20 t name_show
> >  ffffffff97b0ac20 t name_show__alias__6342
> >  ffffffff97c728c0 t name_show
> >  ffffffff97c728c0 t name_show__alias__6343
> >  ffffffff97e0efd0 t name_show
> >  ffffffff97e0efd0 t name_show__alias__6344
> >  ffffffff97e126c0 t name_show
> >  ffffffff97e126c0 t name_show__alias__6345
> >  ffffffff97e1dd20 t name_show
> >  ffffffff97e1dd20 t name_show__alias__6346
> >  ffffffff97e24e70 t name_show
> >  ffffffff97e24e70 t name_show__alias__6347
> >  ffffffff981104c0 t name_show
> >  ffffffff981104c0 t name_show__alias__6348
> >  ffffffff981fe480 t name_show
> >  ffffffff981fe480 t name_show__alias__6349
> >  ~ # echo "p:kprobes/evnt1 name_show__alias__6349" \
> >  > >/sys/kernel/tracing/kprobe_events
> >  ~ # cat /sys/kernel/tracing/kprobe_events
> >  p:kprobes/evnt1 name_show__alias__6349
> >
> > Changes from v1:
> > - Integrated changes requested by Masami to exclude symbols with prefix=
es
> >   "_cfi" and "_pfx".
> > - Introduced a small framework to handle patterns that need to be exclu=
ded
> >   from the alias production.
> > - Excluded other symbols using the framework.
> > - Introduced the ability to discriminate between text and data symbols.
> > - Added two new config symbols in this version: CONFIG_KALLSYMS_ALIAS_D=
ATA,
> >   which allows data for data, and CONFIG_KALLSYMS_ALIAS_DATA_ALL, which
> >   excludes all filters and provides an alias for each duplicated symbol=
.
> >
> > https://lore.kernel.org/all/20230711151925.1092080-1-alessandro.carmina=
ti@gmail.com/
> >
> > Changes from v2:
> > - Alias tags are created by querying DWARF information from the vmlinux=
.
> > - The filename + line number is normalized and appended to the original=
 name.
> > - The tag begins with '@' to indicate the symbol source.
> > - Not a change, but worth mentioning, since the alias is added to the e=
xisting
> >   list, the old duplicated name is preserved, and the livepatch way of =
dealing
> >   with duplicates is maintained.
> > - Acknowledging the existence of scenarios where inlined functions decl=
ared in
> >   header files may result in multiple copies due to compiler behavior, =
though
> >    it is not actionable as it does not pose an operational issue.
> > - Highlighting a single exception where the same name refers to differe=
nt
> >   functions: the case of "compat_binfmt_elf.c," which directly includes
> >   "binfmt_elf.c" producing identical function copies in two separate
> >   modules.
> >
> > sample from new v3
> >
> >  ~ # cat /proc/kallsyms | grep gic_mask_irq
> >  ffffd0b03c04dae4 t gic_mask_irq
> >  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> >  ffffd0b03c050960 t gic_mask_irq
> >  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
> >  ~ #
> >
> > https://lore.kernel.org/all/20230714150326.1152359-1-alessandro.carmina=
ti@gmail.com/
> >
> > Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gma=
il.com>
> > ---
> >  init/Kconfig                        |  36 ++++
> >  scripts/Makefile                    |   4 +
> >  scripts/kas_alias/Makefile          |   4 +
> >  scripts/kas_alias/a2l.c             | 268 ++++++++++++++++++++++++++++
> >  scripts/kas_alias/a2l.h             |  32 ++++
> >  scripts/kas_alias/duplicates_list.c |  70 ++++++++
> >  scripts/kas_alias/duplicates_list.h |  15 ++
> >  scripts/kas_alias/item_list.c       | 230 ++++++++++++++++++++++++
> >  scripts/kas_alias/item_list.h       |  26 +++
> >  scripts/kas_alias/kas_alias.c       | 217 ++++++++++++++++++++++
> >  scripts/link-vmlinux.sh             |  11 +-
> >  11 files changed, 910 insertions(+), 3 deletions(-)
>
>
> I added some review comments in another thread, but
> one of the biggest concerns might be "910 insertions".
>
>
> What this program does is quite simple,
> "find duplicated names, and call addr2line".
>
>
>
> You wrote a lot of code to self-implement these:
>
>  - sort function
>  - parse PATH env variable to find addr2line
>  - fork addr2line to establish pipe communications
>
>
>
> Have you considered writing the code in Python (or Perl)?
> Is it too slow?

I have attempted to incorporate all your suggestions.
I refactored the C code to utilize hashing instead of sorting, and I
completely re-implemented the entire thing in Python for the purpose of
comparison.

You are correct;
the C version is indeed faster, but the difference is negligible when
considering the use case and code maintainability.

Here's a direct comparison of the two.
```
~ $ time ./kas_alias.py -a /usr/bin/aarch64-linux-gnu-addr2line \
                      -n linux-6.5/.tmp_vmlinux.kallsyms1.syms \
                      -v linux-6.5/.tmp_vmlinux.kallsyms1 \
                      -o output_py

real    0m1.626s
user    0m1.436s
sys     0m0.185s
$ cat kas_alias.py | wc -l
133
~ $ time ./kas_alias -a /usr/bin/aarch64-linux-gnu-addr2line \
                   -v linux-6.5/.tmp_vmlinux.kallsyms1 \
                   -n linux-6.5/.tmp_vmlinux.kallsyms1.syms \
                   -o output_c

real    0m1.418s
user    0m1.262s
sys     0m0.162s
~ $ cat a2l.c a2l.h conf.c conf.h item_list.c item_list.h kas_alias.c | wc =
-l
742
~ $ diff output_py output_c
~ $
```
C version is 7/10% faster but is more than 5 times in terms of code size.

>
> Most of the functions you implemented are already
> available in script languages.
>
>
>
> I am not sure if "@<file-path>" is a good solution,
> but the amount of the added code looks too much to me.

I followed Francis's suggestion and made the separator between
<symbol name> and <normalized filename> an argument that you can select
using the command line. Since I'm not aware of a better choice, I set the
default value to '@'.

>
>
>
>
> --
> Best Regards
> Masahiro Yamada

Best regards
Alessandro Carminati
