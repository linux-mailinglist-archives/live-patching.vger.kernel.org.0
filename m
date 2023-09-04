Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7353E7917CC
	for <lists+live-patching@lfdr.de>; Mon,  4 Sep 2023 15:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbjIDNJX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 4 Sep 2023 09:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjIDNJW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 4 Sep 2023 09:09:22 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9D501AD;
        Mon,  4 Sep 2023 06:09:18 -0700 (PDT)
Received: from pwmachine.localnet (85-170-34-233.rev.numericable.fr [85.170.34.233])
        by linux.microsoft.com (Postfix) with ESMTPSA id EF88E212B16B;
        Mon,  4 Sep 2023 06:09:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EF88E212B16B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1693832958;
        bh=LtAw+jVuIucYv5hspY/X06k4jJZyLR+Pai5EJWTJy8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dy1rkeKHWA6nJgdJ6sf04+PJ9ExqJ5t3hL1YuoKT960ZsBq4jlkw4nhX380lmimqW
         C9Ruzvcc/UXrYKL6lCh51w7mQsxHiEMTEpeQDiNWFZfhbftnC2EPoJpX5bJeVQtA36
         73B7EfcJoD2YGG4/jdJo2eDhUOcc5HBpfPt0oByU=
From:   Francis Laniel <flaniel@linux.microsoft.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Alessandro Carminati <alessandro.carminati@gmail.com>
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
        Viktor Malik <vmalik@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate symbols for kallsyms
Date:   Mon, 04 Sep 2023 15:09:12 +0200
Message-ID: <12278120.O9o76ZdvQC@pwmachine>
In-Reply-To: <CAPp5cGTngA6_zhPpgMGsvp8T49LZEohzyRtedGSo8hkEJFRkiA@mail.gmail.com>
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com> <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com> <CAPp5cGTngA6_zhPpgMGsvp8T49LZEohzyRtedGSo8hkEJFRkiA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi.

Le samedi 2 septembre 2023, 09:40:46 CEST Alessandro Carminati a =C3=A9crit=
 :
> Il giorno sab 2 set 2023 alle ore 08:36 Masahiro Yamada
>=20
> <masahiroy@kernel.org> ha scritto:
> > On Mon, Aug 28, 2023 at 8:45=E2=80=AFPM Alessandro Carminati (Red Hat)
> >=20
> > <alessandro.carminati@gmail.com> wrote:
> > > From: Alessandro Carminati <alessandro.carminati@gmail.com>
> > >=20
> > > It is not uncommon for drivers or modules related to similar peripher=
als
> > > to have symbols with the exact same name.
> > > While this is not a problem for the kernel's binary itself, it becomes
> > > an
> > > issue when attempting to trace or probe specific functions using
> > > infrastructure like ftrace or kprobe.
> > >=20
> > > The tracing subsystem relies on the `nm -n vmlinux` output, which
> > > provides
> > > symbol information from the kernel's ELF binary. However, when multip=
le
> > > symbols share the same name, the standard nm output does not
> > > differentiate
> > > between them. This can lead to confusion and difficulty when trying to
> > > probe the intended symbol.
> > >=20
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
> > >=20
> > > **kas_alias** addresses this challenge by extending the symbol names
> > > with
> > > unique suffixes during the kernel build process.
> > > The newly created aliases for these duplicated symbols are unique nam=
es
> > > that can be fed to the ftracefs interface. By doing so, it enables
> > > previously unreachable symbols to be probed.
> > >=20
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
> > > =20
> > >  > >/sys/kernel/tracing/kprobe_events
> > > =20
> > >  ~ # cat /sys/kernel/tracing/kprobe_events
> > >  p:kprobes/evnt1 name_show__alias__6349
> > >=20
> > > Changes from v1:
> > > - Integrated changes requested by Masami to exclude symbols with
> > > prefixes
> > >=20
> > >   "_cfi" and "_pfx".
> > >=20
> > > - Introduced a small framework to handle patterns that need to be
> > > excluded
> > >=20
> > >   from the alias production.
> > >=20
> > > - Excluded other symbols using the framework.
> > > - Introduced the ability to discriminate between text and data symbol=
s.
> > > - Added two new config symbols in this version:
> > > CONFIG_KALLSYMS_ALIAS_DATA,
> > >=20
> > >   which allows data for data, and CONFIG_KALLSYMS_ALIAS_DATA_ALL, whi=
ch
> > >   excludes all filters and provides an alias for each duplicated symb=
ol.
> > >=20
> > > https://lore.kernel.org/all/20230711151925.1092080-1-alessandro.carmi=
nat
> > > i@gmail.com/
> > >=20
> > > Changes from v2:
> > > - Alias tags are created by querying DWARF information from the vmlin=
ux.
> > > - The filename + line number is normalized and appended to the origin=
al
> > > name. - The tag begins with '@' to indicate the symbol source.
> > > - Not a change, but worth mentioning, since the alias is added to the
> > > existing> >=20
> > >   list, the old duplicated name is preserved, and the livepatch way of
> > >   dealing with duplicates is maintained.
> > >=20
> > > - Acknowledging the existence of scenarios where inlined functions
> > > declared in> >=20
> > >   header files may result in multiple copies due to compiler behavior,
> > >   though
> > >  =20
> > >    it is not actionable as it does not pose an operational issue.
> > >=20
> > > - Highlighting a single exception where the same name refers to
> > > different
> > >=20
> > >   functions: the case of "compat_binfmt_elf.c," which directly includ=
es
> > >   "binfmt_elf.c" producing identical function copies in two separate
> > >   modules.
> > >=20
> > > sample from new v3
> > >=20
> > >  ~ # cat /proc/kallsyms | grep gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq
> > >  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> > >  ffffd0b03c050960 t gic_mask_irq
> > >  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
> > >  ~ #
> > >=20
> > > https://lore.kernel.org/all/20230714150326.1152359-1-alessandro.carmi=
nat
> > > i@gmail.com/
> > >=20
> > > Signed-off-by: Alessandro Carminati (Red Hat)
> > > <alessandro.carminati@gmail.com> ---
> > >=20
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
> >=20
> > I added some review comments in another thread, but
> > one of the biggest concerns might be "910 insertions".
>=20
> Based on the feedback I received in the reviews, I need to overhaul the
> code, potentially reducing its size. What would be a reasonable number
> of lines for this feature?
>=20
> > What this program does is quite simple,
> > "find duplicated names, and call addr2line".
> >=20
> > You wrote a lot of code to self-implement these:
> >  - sort function
> >  - parse PATH env variable to find addr2line
> >  - fork addr2line to establish pipe communications
>=20
> Some of these functions might become obsolete in the upcoming v4, which
> will certainly reduce the line count.
>=20
> > Have you considered writing the code in Python (or Perl)?
> > Is it too slow?
> >
> >From my perspective, there is a concern that using Python or Perl might
>=20
> result in slower performance. My proficiency in Python and Perl is
> limited, so I did not initially consider them as viable options for
> implementing this solution.
>=20
> > Most of the functions you implemented are already
> > available in script languages.
> >=20
> >=20
> >=20
> > I am not sure if "@<file-path>" is a good solution,
> > but the amount of the added code looks too much to me.
>=20
> I had reservations about using the '@' symbol to decorate the alias becau=
se
> it's not a character commonly found in the kallsyms output. However, after
> careful consideration, I arrived at the conclusion that it was suitable f=
or
> the task because it would make the alias stand-out and be easily
> identifiable.
> I'm open to any suggestions or alternative approaches you may have on this
> matter.

I am maybe over-engineering the thing, but maybe we can have a=20
CONFIG_KALLSYMS_ALIAS_FORMAT which users would set to indicate how to=20
differentiate between two symbols?
=46or example, CONFIG_KALLSYMS_ALIAS_FORMAT=3D@file-lineno would lead to wh=
at we=20
have currently.
If you switch to using a higher level language, you can maybe focus more on=
=20
this.
Anyway, I personally like what this contribution offers currently as it per=
mits=20
to distinguish between same symbols.
I will take a look at v4! Thank you again for working on this.

> > --
> > Best Regards
> > Masahiro Yamada
>=20
> Thank you

Best regards.


