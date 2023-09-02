Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131B07905D1
	for <lists+live-patching@lfdr.de>; Sat,  2 Sep 2023 09:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbjIBHl2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 2 Sep 2023 03:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjIBHl1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 2 Sep 2023 03:41:27 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC493B4;
        Sat,  2 Sep 2023 00:41:23 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1ccb58b0099so1793827fac.0;
        Sat, 02 Sep 2023 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693640483; x=1694245283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EeXmzHg5IQ0UQxDkX+UTOJXNxt+qWees1SWh4fWjhQ=;
        b=TtCIKX7xmdv0vDLy10aHHbPFN2kcxiKmtAQCEE6/g/WWSfn2Zq/1rtsfLizCkuKV5u
         EgKBTgzoVNHH5fsKabssXE7nhvQi5i/OLuBwbFFzsFfXVUdChrq++ZXXAt3UpV0rp6C5
         nu00xhzGSolchznfIRx2f6OoRrS6se+dpxMjos4CGvf1Qt8XpuODHnSuv1Mx8TOuAYiX
         w7CxXGIMizx9LsP1LePsfVKMOq7WjSEDiOZV+zWo9Syid0yeM+oOeDkpacyKMIWpMgtD
         5Omkh9jD5cKNKP4u+AvMjVR0Wwx/01G8Xc1a37uKEa+K2HeAIra/rGkhT262cQAMIyVy
         m3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693640483; x=1694245283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8EeXmzHg5IQ0UQxDkX+UTOJXNxt+qWees1SWh4fWjhQ=;
        b=SJVAjPhfJJKoj9KLWshflSZEpLOp6O1fTNUMbXT5VnKI2n0iuie+BuWfsdsKXmcDaM
         uejEm/5aIeItTBRCYMFqiNLV1bJOFJYUOSER3qFO71YDOY7Rw+LNsl5XLdJ7KauT4OaV
         q65f0swNdI59to7Du2+fDO4bNr8u0+lzq3Y36nRSZZnw0IG435iFLVPoD4kZ8xZWE1r/
         KMQVDY34pzfC1kXnb0IQYJr4pKZBN9Qd5v6fW6Uvubgf3fb27fy3ziyIDW96p9ZqiMVM
         bouqyeUl1CZk71+cuA1k1lVkIbH/5OkpVc/7m01WvfDGCjx34nQqp6nzeEdk7k4HBxkD
         J6gg==
X-Gm-Message-State: AOJu0YyQdsiXW3kNMmil88kSyZllkMHaHssHpqMKkwhd5lo9MwFKKZk5
        nqyDJKrbBtNRfXUw6OqmB2gIeJVvYT7xMEl+PIc=
X-Google-Smtp-Source: AGHT+IE3QMut6U/Fojd2q7SDHIQhYeM6x6prZCZJgvC0j22ZXGlzE4GfaSPms2jQP8wtOTWAee388khd+7/lYwf2Vyw=
X-Received: by 2002:a05:6870:9a06:b0:1c8:bae6:527d with SMTP id
 fo6-20020a0568709a0600b001c8bae6527dmr6064665oab.55.1693640482900; Sat, 02
 Sep 2023 00:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com> <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
In-Reply-To: <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
From:   Alessandro Carminati <alessandro.carminati@gmail.com>
Date:   Sat, 2 Sep 2023 09:40:46 +0200
Message-ID: <CAPp5cGTngA6_zhPpgMGsvp8T49LZEohzyRtedGSo8hkEJFRkiA@mail.gmail.com>
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

Based on the feedback I received in the reviews, I need to overhaul the
code, potentially reducing its size. What would be a reasonable number
of lines for this feature?

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

Some of these functions might become obsolete in the upcoming v4, which
will certainly reduce the line count.

>
>
>
> Have you considered writing the code in Python (or Perl)?
> Is it too slow?

From my perspective, there is a concern that using Python or Perl might
result in slower performance. My proficiency in Python and Perl is
limited, so I did not initially consider them as viable options for
implementing this solution.

>
> Most of the functions you implemented are already
> available in script languages.
>
>
>
> I am not sure if "@<file-path>" is a good solution,
> but the amount of the added code looks too much to me.
>

I had reservations about using the '@' symbol to decorate the alias because
it's not a character commonly found in the kallsyms output. However, after
careful consideration, I arrived at the conclusion that it was suitable for
the task because it would make the alias stand-out and be easily
identifiable.
I'm open to any suggestions or alternative approaches you may have on this
matter.

>
>
>
> --
> Best Regards
> Masahiro Yamada

Thank you
