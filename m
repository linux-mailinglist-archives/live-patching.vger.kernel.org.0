Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E2D79059D
	for <lists+live-patching@lfdr.de>; Sat,  2 Sep 2023 08:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351676AbjIBGhA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 2 Sep 2023 02:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjIBGg7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 2 Sep 2023 02:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171EE1706;
        Fri,  1 Sep 2023 23:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E99C60BEC;
        Sat,  2 Sep 2023 06:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0117C43140;
        Sat,  2 Sep 2023 06:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693636615;
        bh=9xn+Gqkfmh1YDEaa6/jkJbanYbq4pFQjGneSrL6XxBg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VkVmY120x11OcQUskcr56GodJSMgkiSDj3lAP29AWTUgo6TQOPesdixYvKpv7X38X
         nDXBvtduGH1VFzdwo5Xy4DwxPHlfubES39IMaJeRak0FREfPh3bM6TSRMc4KlNE2LG
         AQclB7mBMWbLjipJKZ0/c4v2c0plyjRBaKBZXPg5Y3tMqHJYSsudMO/jYOvtt+u/wM
         mZ2xJRFMUzx3zBfOo5Yx5hyPAaLzEar71wU0YJqxFoyeu+XPr6q3MolTOcFZSlbfT0
         NxrPrmh23yzsfUtJiPGFo3c+riJCZj/8x8/7fmXA5cYRlZ4x3Z5olCsKZhlUnO1y7N
         u83G9Zx9sr/eg==
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-573ac2fa37aso1675633eaf.3;
        Fri, 01 Sep 2023 23:36:54 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx0b8Sd0gM2YzKM7ndArlZgjne1vSoWh0SpZTVSeE5fkA6doSnb
        8PgMqRM3BNP4ekTQLn1DvtKGdEuW2rwAHJIIrII=
X-Google-Smtp-Source: AGHT+IFcMlt428+yNg8X4sm70nVkmouA/Q1FSvJWkc+S9GWTgUD9b8hxaKXZ+Lk2fNpc0KdOsVmQ/Yi7K0gA1rTgHJk=
X-Received: by 2002:a05:6820:81f:b0:571:1a1d:f230 with SMTP id
 bg31-20020a056820081f00b005711a1df230mr4203830oob.9.1693636614116; Fri, 01
 Sep 2023 23:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
In-Reply-To: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 2 Sep 2023 15:36:17 +0900
X-Gmail-Original-Message-ID: <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
Message-ID: <CAK7LNATf5zQH=qOX3HCcAoaccK1KTjoGNuXc-d2-FM-japABoQ@mail.gmail.com>
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
To:     "Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 28, 2023 at 8:45=E2=80=AFPM Alessandro Carminati (Red Hat)
<alessandro.carminati@gmail.com> wrote:
>
> From: Alessandro Carminati <alessandro.carminati@gmail.com>
>
> It is not uncommon for drivers or modules related to similar peripherals
> to have symbols with the exact same name.
> While this is not a problem for the kernel's binary itself, it becomes an
> issue when attempting to trace or probe specific functions using
> infrastructure like ftrace or kprobe.
>
> The tracing subsystem relies on the `nm -n vmlinux` output, which provide=
s
> symbol information from the kernel's ELF binary. However, when multiple
> symbols share the same name, the standard nm output does not differentiat=
e
> between them. This can lead to confusion and difficulty when trying to
> probe the intended symbol.
>
>  ~ # cat /proc/kallsyms | grep " name_show"
>  ffffffff8c4f76d0 t name_show
>  ffffffff8c9cccb0 t name_show
>  ffffffff8cb0ac20 t name_show
>  ffffffff8cc728c0 t name_show
>  ffffffff8ce0efd0 t name_show
>  ffffffff8ce126c0 t name_show
>  ffffffff8ce1dd20 t name_show
>  ffffffff8ce24e70 t name_show
>  ffffffff8d1104c0 t name_show
>  ffffffff8d1fe480 t name_show
>
> **kas_alias** addresses this challenge by extending the symbol names with
> unique suffixes during the kernel build process.
> The newly created aliases for these duplicated symbols are unique names
> that can be fed to the ftracefs interface. By doing so, it enables
> previously unreachable symbols to be probed.
>
>  ~ # cat /proc/kallsyms | grep " name_show"
>  ffffffff974f76d0 t name_show
>  ffffffff974f76d0 t name_show__alias__6340
>  ffffffff979cccb0 t name_show
>  ffffffff979cccb0 t name_show__alias__6341
>  ffffffff97b0ac20 t name_show
>  ffffffff97b0ac20 t name_show__alias__6342
>  ffffffff97c728c0 t name_show
>  ffffffff97c728c0 t name_show__alias__6343
>  ffffffff97e0efd0 t name_show
>  ffffffff97e0efd0 t name_show__alias__6344
>  ffffffff97e126c0 t name_show
>  ffffffff97e126c0 t name_show__alias__6345
>  ffffffff97e1dd20 t name_show
>  ffffffff97e1dd20 t name_show__alias__6346
>  ffffffff97e24e70 t name_show
>  ffffffff97e24e70 t name_show__alias__6347
>  ffffffff981104c0 t name_show
>  ffffffff981104c0 t name_show__alias__6348
>  ffffffff981fe480 t name_show
>  ffffffff981fe480 t name_show__alias__6349
>  ~ # echo "p:kprobes/evnt1 name_show__alias__6349" \
>  > >/sys/kernel/tracing/kprobe_events
>  ~ # cat /sys/kernel/tracing/kprobe_events
>  p:kprobes/evnt1 name_show__alias__6349
>
> Changes from v1:
> - Integrated changes requested by Masami to exclude symbols with prefixes
>   "_cfi" and "_pfx".
> - Introduced a small framework to handle patterns that need to be exclude=
d
>   from the alias production.
> - Excluded other symbols using the framework.
> - Introduced the ability to discriminate between text and data symbols.
> - Added two new config symbols in this version: CONFIG_KALLSYMS_ALIAS_DAT=
A,
>   which allows data for data, and CONFIG_KALLSYMS_ALIAS_DATA_ALL, which
>   excludes all filters and provides an alias for each duplicated symbol.
>
> https://lore.kernel.org/all/20230711151925.1092080-1-alessandro.carminati=
@gmail.com/
>
> Changes from v2:
> - Alias tags are created by querying DWARF information from the vmlinux.
> - The filename + line number is normalized and appended to the original n=
ame.
> - The tag begins with '@' to indicate the symbol source.
> - Not a change, but worth mentioning, since the alias is added to the exi=
sting
>   list, the old duplicated name is preserved, and the livepatch way of de=
aling
>   with duplicates is maintained.
> - Acknowledging the existence of scenarios where inlined functions declar=
ed in
>   header files may result in multiple copies due to compiler behavior, th=
ough
>    it is not actionable as it does not pose an operational issue.
> - Highlighting a single exception where the same name refers to different
>   functions: the case of "compat_binfmt_elf.c," which directly includes
>   "binfmt_elf.c" producing identical function copies in two separate
>   modules.
>
> sample from new v3
>
>  ~ # cat /proc/kallsyms | grep gic_mask_irq
>  ffffd0b03c04dae4 t gic_mask_irq
>  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
>  ffffd0b03c050960 t gic_mask_irq
>  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
>  ~ #
>
> https://lore.kernel.org/all/20230714150326.1152359-1-alessandro.carminati=
@gmail.com/
>
> Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail=
.com>
> ---
>  init/Kconfig                        |  36 ++++
>  scripts/Makefile                    |   4 +
>  scripts/kas_alias/Makefile          |   4 +
>  scripts/kas_alias/a2l.c             | 268 ++++++++++++++++++++++++++++
>  scripts/kas_alias/a2l.h             |  32 ++++
>  scripts/kas_alias/duplicates_list.c |  70 ++++++++
>  scripts/kas_alias/duplicates_list.h |  15 ++
>  scripts/kas_alias/item_list.c       | 230 ++++++++++++++++++++++++
>  scripts/kas_alias/item_list.h       |  26 +++
>  scripts/kas_alias/kas_alias.c       | 217 ++++++++++++++++++++++
>  scripts/link-vmlinux.sh             |  11 +-
>  11 files changed, 910 insertions(+), 3 deletions(-)


I added some review comments in another thread, but
one of the biggest concerns might be "910 insertions".


What this program does is quite simple,
"find duplicated names, and call addr2line".



You wrote a lot of code to self-implement these:

 - sort function
 - parse PATH env variable to find addr2line
 - fork addr2line to establish pipe communications



Have you considered writing the code in Python (or Perl)?
Is it too slow?

Most of the functions you implemented are already
available in script languages.



I am not sure if "@<file-path>" is a good solution,
but the amount of the added code looks too much to me.




--
Best Regards
Masahiro Yamada
