Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703E97905B8
	for <lists+live-patching@lfdr.de>; Sat,  2 Sep 2023 09:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346608AbjIBH1c (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 2 Sep 2023 03:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjIBH1c (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 2 Sep 2023 03:27:32 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56510F6;
        Sat,  2 Sep 2023 00:27:26 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-5734f54dc44so1644111eaf.2;
        Sat, 02 Sep 2023 00:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693639646; x=1694244446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsI6g+dA+nKzshSZrrFFndvkurHFzul5wgr8T7ir4xI=;
        b=bD/SkFcdeKvw9qRtbkodezms/vhVTNbhwAALA0o0vrZyUeIg2erPJMYTjeTUG+A3/3
         f7blGTivxiqb84snKMUNbgqDgjKqzhMBLzrTXOXQ3whuEIswVXalAMvKShUyB9vbeSs8
         M/jU1SWqRBgi9OvV4DQriS8JUMkGJYPDsF/tMrCj0ZkohDkltuQgMaXMjCmqrnm2rU/P
         RUSGOPND1CE0ft+/+iwaztz5uwuOSQrpPx6JPrg8vTnU8enSnxRGDIwVibmDbIe0KCf2
         ENXcN/d12MQnL4ikGnkruXJR+Dasdf0YFnSFtHHxcTqwHWW+2vaR8tTphUh67YXXEwiw
         FKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693639646; x=1694244446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsI6g+dA+nKzshSZrrFFndvkurHFzul5wgr8T7ir4xI=;
        b=NIeK38mGWSUGJOnsdvhbosY9+3qLY270T7YQ5phXMdKG0O+ADAOtpnPcf88OdEsQem
         AO8WWQe0fy4AIjZfUg+KFCmue3B7AbjDwghCn6QSC/xkGx2jAV7PKPEoNsYAhOPd5mrC
         D1y4ILDYeft572rSTNzQ5YQKG3t1CzNzxWxcRZ/PTqwMb4m/GVzqYvm+HdO9fwy6/qRx
         m3gvoHSmbbA5mLK7OAYKOvz8hWvgMfXDPVbjarzUhZoudzI/hxWpg7h1SNXKiT1T9pxF
         xR1LC4tT7dInvP++nLs99S2vx5JC+2rguDWG98oEutRnYWeQG1ucEkFkHenkw47FQ2kH
         muVg==
X-Gm-Message-State: AOJu0Yx6VAYby2Q+XNvIt2mM7nkPI5MIyV4F/PO3M6tttXAhauSQLsv1
        LUjquzNr+WNpjpulhis+hNjICEU2BO3WlwECB4c=
X-Google-Smtp-Source: AGHT+IEtvNX9uti3Yvxp7VjVQP43UF6tEmvCNg7Tz+vMTjjO3TmAPbYgPDh8KG32v4KJ9EqTssrWNQzPDqULaUGy9OM=
X-Received: by 2002:a4a:2a0f:0:b0:573:55f4:5175 with SMTP id
 k15-20020a4a2a0f000000b0057355f45175mr4507050oof.0.1693639645464; Sat, 02 Sep
 2023 00:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com> <5966520.lOV4Wx5bFT@pwmachine>
In-Reply-To: <5966520.lOV4Wx5bFT@pwmachine>
From:   Alessandro Carminati <alessandro.carminati@gmail.com>
Date:   Sat, 2 Sep 2023 09:26:49 +0200
Message-ID: <CAPp5cGR=HSHcJCdTgPasYWjQ_T1xDxHmifhBKBc4=wgxdm-5Rg@mail.gmail.com>
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
To:     Francis Laniel <flaniel@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
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

Hi Francis,

I want to express my gratitude for your review and the time you took
to provide it.

Il giorno mar 29 ago 2023 alle ore 16:51 Francis Laniel
<flaniel@linux.microsoft.com> ha scritto:
>
> Hi.
>
> Le lundi 28 ao=C3=BBt 2023, 10:04:23 CEST Alessandro Carminati (Red Hat) =
a =C3=A9crit :
> > From: Alessandro Carminati <alessandro.carminati@gmail.com>
> >
> > It is not uncommon for drivers or modules related to similar peripheral=
s
> > to have symbols with the exact same name.
> > While this is not a problem for the kernel's binary itself, it becomes =
an
> > issue when attempting to trace or probe specific functions using
> > infrastructure like ftrace or kprobe.
>
> Thank you for the patch!
> I tested it and it works fine:
> root@vm-amd64:~# grep -m 6 ' name_show' /proc/kallsyms
> ffffffff81108330 t name_show
> ffffffff81108330 t name_show@_kernel_irq_irqdesc_c_264
> ffffffff816d2dd0 t name_show
> ffffffff816d2dd0 t name_show@_drivers_pnp_card_c_186
> ffffffff81814990 t name_show
> ffffffff81814990 t name_show@_drivers_gpu_drm_i915_gt_sysfs_engines_c_26
>
> On the paper, it combines well with my other patch forbidding tracing non
> unique symbols.
> I will nonetheless need to try yours on top of mine and I will let you kn=
ow
> the result, even though everything should go well.
>
> Regarding the code itself, from my review your implementation is good.
> I was just wondering if we cannot avoid the first sort BY_NAME by modifyi=
ng
> find_duplicates() and the returned structured, but the index you are usin=
g
> later should reduce the loopthrough time and compensate the first sort.
> I have some specific comments but they are mainly nits:
>
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
>
> This output is outdated.
> This is not a big problem but it would be better with the updated one as =
the
> "@_file_line" is better.
>
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
> >
> >  > >/sys/kernel/tracing/kprobe_events
> >
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
ti@gm
> > ail.com/
> >
> > Changes from v2:
> > - Alias tags are created by querying DWARF information from the vmlinux=
.
> > - The filename + line number is normalized and appended to the original
> > name. - The tag begins with '@' to indicate the symbol source.
> > - Not a change, but worth mentioning, since the alias is added to the
> > existing list, the old duplicated name is preserved, and the livepatch =
way
> > of dealing with duplicates is maintained.
> > - Acknowledging the existence of scenarios where inlined functions decl=
ared
> > in header files may result in multiple copies due to compiler behavior,
> > though it is not actionable as it does not pose an operational issue.
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
ti@gm
> > ail.com/
> >
> > Signed-off-by: Alessandro Carminati (Red Hat)
> > <alessandro.carminati@gmail.com> ---
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
> >  create mode 100644 scripts/kas_alias/Makefile
> >  create mode 100644 scripts/kas_alias/a2l.c
> >  create mode 100644 scripts/kas_alias/a2l.h
> >  create mode 100644 scripts/kas_alias/duplicates_list.c
> >  create mode 100644 scripts/kas_alias/duplicates_list.h
> >  create mode 100644 scripts/kas_alias/item_list.c
> >  create mode 100644 scripts/kas_alias/item_list.h
> >  create mode 100644 scripts/kas_alias/kas_alias.c
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index f7f65af4ee12..bc69fcd9cbc8 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1737,6 +1737,42 @@ config KALLSYMS_BASE_RELATIVE
> >         time constants, and no relocation pass is required at runtime t=
o fix
> >         up the entries based on the runtime load address of the kernel.
> >
> > +config KALLSYMS_ALIAS
> > +     bool "Produces alias for duplicated symbols" if EXPERT
> > +     depends on KALLSYMS && (DEBUG_INFO_DWARF4 || DEBUG_INFO_DWARF5)
> > +     help
> > +       It is not uncommon for drivers or modules related to similar
> > +       peripherals to have symbols with the exact same name.
> > +       While this is not a problem for the kernel's binary itself, it
> > +       becomes an issue when attempting to trace or probe specific
> > +       functions using infrastructure like ftrace or kprobe.
> > +
> > +       This option addresses this challenge by extending the symbol na=
mes
> > +       with unique suffixes during the kernel build process.
> > +       The newly created aliases for these duplicated symbols are uniq=
ue
> > +       names that can be fed to the ftrace sysfs interface. By doing s=
o, it
> > +       enables previously unreachable symbols to be probed.
> > +
> > +config CONFIG_KALLSYMS_ALIAS_DATA
> > +     bool "Produces alias also for data"
> > +     depends on KALLSYMS_ALIAS
> > +     help
> > +       Sometimes it can be useful to refer to data. In live patch
> scenarios,
> > +       you may find yourself needing to use symbols that are shared wi=
th
> > +       other functions. Since symbols face the same issue as functions=
,
> this
> > +       option allows you to create aliases for data as well.
> > +
> > +config CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > +     bool "Removes all filter when producing data alias"
> > +     depends on CONFIG_KALLSYMS_ALIAS_DATA
> > +     help
> > +       When selecting data aliases, not all symbols are included in th=
e set
> > +       This is because many symbols are unlikely to be used. If you ch=
oose
> > +       to have an alias for all data symbols, be aware that it will
> > +       significantly increase the size.
> > +
> > +       If unsure, say N.
> > +
> >  # end of the "standard kernel features (expert users)" menu
> >
> >  # syscall, maps, verifier
> > diff --git a/scripts/Makefile b/scripts/Makefile
> > index 32b6ba722728..65fafe17cfe5 100644
> > --- a/scripts/Makefile
> > +++ b/scripts/Makefile
> > @@ -49,3 +49,7 @@ subdir-$(CONFIG_SECURITY_SELINUX) +=3D selinux
> >
> >  # Let clean descend into subdirs
> >  subdir-      +=3D basic dtc gdb kconfig mod
> > +
> > +# KALLSyms alias
> > +subdir-$(CONFIG_KALLSYMS_ALIAS) +=3D kas_alias
> > +
> > diff --git a/scripts/kas_alias/Makefile b/scripts/kas_alias/Makefile
> > new file mode 100644
> > index 000000000000..e1fde69232b4
> > --- /dev/null
> > +++ b/scripts/kas_alias/Makefile
> > @@ -0,0 +1,4 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +hostprogs-always-$(CONFIG_KALLSYMS_ALIAS)    +=3D kas_alias
> > +
> > +kas_alias-objs        :=3D duplicates_list.o item_list.o kas_alias.o a=
2l.o
> > diff --git a/scripts/kas_alias/a2l.c b/scripts/kas_alias/a2l.c
> > new file mode 100644
> > index 000000000000..a9692ac30180
> > --- /dev/null
> > +++ b/scripts/kas_alias/a2l.c
> > @@ -0,0 +1,268 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <sys/types.h>
> > +#include <sys/wait.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <stdbool.h>
> > +
> > +#include "a2l.h"
> > +
> > +int addr2line_pid =3D -1;
> > +int a2l_in[2];
> > +int a2l_out[2];
> > +char line[MAX_BUF];
> > +char vmlinux_path[MAX_BUF];
> > +char addr2line_cmd[MAX_CMD_LEN];
> > +FILE *a2l_stdin, *a2l_stdout;
> > +
> > +static char *normalize_path(const char *input_path, char *output_path)
> > +{
> > +     char *prev_token =3D NULL;
> > +     char *delimiter =3D "/";
> > +     char inbuf[MAX_BUF];
>
> Rather than using memset below you can initialize it like this above:
> char inbuf[MAX_BUF] =3D {0};
>
> > +     char *token;
> > +     char *pos;
> > +
> > +     memset(inbuf, 0, MAX_BUF);
> > +     *output_path =3D '\0';
> > +     strncpy(inbuf, input_path, MAX_BUF);
> > +     if (!input_path || !output_path || strlen(input_path) =3D=3D 0)
> > +             return NULL;
> > +
> > +     token =3D strtok(inbuf, delimiter);
> > +     while (token) {
> > +             if (strcmp(token, "..") =3D=3D 0 && prev_token) {
> > +                     pos =3D strrchr(output_path, '/');
>
> > +                     if (pos)
> > +                             *pos =3D '\0';
> > +
> > +             } else if (strcmp(token, ".") !=3D 0) {
> > +                     strcat(output_path, "/");
> > +                     strcat(output_path, token);
> > +             }
> > +
> > +             prev_token =3D token;
> > +             token =3D strtok(NULL, delimiter);
> > +     }
> > +
> > +     return output_path;
> > +}
> > +
> > +static void path_of(const char *full_path, char *path)
> > +{
> > +     const char *last_slash =3D strrchr(full_path, '/');
> > +     size_t path_length;
> > +     char cwd[MAX_BUF];
> > +
> > +     if (!last_slash) {
> > +             if (getcwd(cwd, sizeof(cwd)))
> > +                     strcpy(path, cwd);
> > +             else
> > +                     strcpy(path, ".");
> > +     } else {
> > +             path_length =3D last_slash - full_path;
> > +             strncpy(path, full_path, path_length);
> > +             path[path_length] =3D '\0';
> > +     }
> > +}
> > +
> > +static bool file_exists(const char *file_path)
> > +{
> > +     FILE *file;
> > +
> > +     file =3D fopen(file_path, "r");
> > +     if (file) {
> > +             fclose(file);
> > +             return true;
> > +     }
> > +     return false;
> > +}
> > +
> > +int addr2line_init(const char *cmd, const char *vmlinux)
> > +{
> > +     if ((!file_exists(cmd)) || (!file_exists(vmlinux))) {
> > +             printf("file not found\n");
> > +             return 0;
> > +             }
> > +
> > +     path_of(vmlinux, vmlinux_path);
> > +     if (pipe(a2l_in) =3D=3D -1) {
> > +             printf("Failed to create pipe\n");
> > +             return 0;
> > +     }
> > +
> > +     if (pipe(a2l_out) =3D=3D -1) {
> > +             printf("Failed to create pipe\n");
> > +             return 0;
> > +     }
> > +
> > +     addr2line_pid =3D fork();
> > +     if (addr2line_pid =3D=3D -1) {
> > +             printf("Failed to fork process\n");
> > +             close(a2l_in[P_READ]);
> > +             close(a2l_in[P_WRITE]);
> > +             close(a2l_out[P_READ]);
> > +             close(a2l_out[P_WRITE]);
> > +             return 0;
> > +     }
> > +
> > +     if (addr2line_pid =3D=3D 0) {
> > +             dup2(a2l_in[P_READ], 0);
> > +             dup2(a2l_out[P_WRITE], 1);
> > +             close(a2l_in[P_WRITE]);
> > +             close(a2l_out[P_READ]);
> > +
> > +             execlp(cmd, cmd, ADDR2LINE_ARGS, vmlinux, NULL);
> > +
> > +             printf("Failed to execute addr2line command\n");
> > +             exit(1);
> > +     } else {
> > +             close(a2l_in[P_READ]);
> > +             close(a2l_out[P_WRITE]);
> > +     }
> > +
> > +     a2l_stdin =3D fdopen(a2l_in[P_WRITE], "w");
> > +     if (!a2l_stdin) {
> > +             printf("Failed to open pipe a2l_in\n");
> > +             return 0;
> > +     }
> > +
> > +     a2l_stdout =3D fdopen(a2l_out[P_READ], "r");
> > +     if (!a2l_stdout) {
> > +             printf("Failed to open pipe a2l_out\n");
> > +             fclose(a2l_stdin);
> > +             return 0;
> > +     }
> > +
> > +     return 1;
> > +}
> > +
> > +const char *remove_subdir(const char *home, const char *f_path)
> > +{
> > +     int i =3D 0;
> > +
> > +     while (*(home + i) =3D=3D *(f_path + i))
>
> Using home[i] and f_path[i] should do the trick too.
>
> > +             i++;
> > +
> > +     return (strlen(home) !=3D i) ? NULL : f_path + i;
> > +}
> > +
> > +char *addr2line_get_lines(uint64_t address)
> > +{
> > +     char buf[MAX_BUF];
> > +
> > +     fprintf(a2l_stdin, "%08lx\n", address);
> > +     fflush(a2l_stdin);
> > +
> > +     if (!fgets(line, sizeof(line), a2l_stdout)) {
> > +             printf("Failed to read lines from addr2line\n");
> > +             return NULL;
> > +     }
> > +
> > +     if (!fgets(line, sizeof(line), a2l_stdout)) {
> > +             printf("Failed to read lines from addr2line\n");
> > +             return NULL;
> > +     }
> > +     line[strcspn(line, "\n")] =3D '\0';
> > +     strncpy(buf, line, MAX_BUF);
> > +     return normalize_path(buf, line);
> > +}
> > +
> > +int addr2line_cleanup(void)
> > +{
> > +     int status;
> > +
> > +     if (addr2line_pid !=3D -1) {
> > +             kill(addr2line_pid, SIGKILL);
> > +             waitpid(addr2line_pid, &status, 0);
> > +             fclose(a2l_stdin);
> > +             fclose(a2l_stdout);
> > +             addr2line_pid =3D -1;
> > +     }
> > +
> > +     return 1;
> > +}
> > +
> > +static char *find_executable(const char *command)
>
> Nice function, I would rather have tried to execve() the command.
>
> > +{
> > +     char *path_env =3D getenv("PATH");
> > +     char *executable_path;
> > +     char *path_copy;
> > +     char *path;
> > +     int n;
> > +
> > +     if (!path_env)
> > +             return NULL;
> > +
> > +     path_copy =3D strdup(path_env);
> > +     if (!path_copy)
> > +             return NULL;
> > +
> > +     path =3D strtok(path_copy, ":");
> > +     while (path) {
> > +             n =3D snprintf(0, 0, "%s/%s", path, command);
> > +             executable_path =3D (char *)malloc(n + 1);
> > +             snprintf(executable_path, n + 1, "%s/%s", path, command);
> > +             if (access(executable_path, X_OK) =3D=3D 0) {
> > +                     free(path_copy);
> > +                     return executable_path;
> > +             }
> > +
> > +     path =3D strtok(NULL, ":");
> > +     free(executable_path);
> > +     executable_path =3D NULL;
>
> > +     }
> > +
> > +     free(path_copy);
> > +     if (executable_path)
> > +             free(executable_path);
>
> If you arrive here, executable_path should be NULL, right?
>
> > +     return NULL;
> > +}
> > +
> > +const char *get_addr2line(int mode)
> > +{
> > +     char *buf =3D "";
> > +
> > +     switch (mode) {
> > +     case A2L_CROSS:
> > +             buf =3D getenv("CROSS_COMPILE");
> > +             memcpy(addr2line_cmd, buf, strlen(buf));
> > +     case A2L_DEFAULT:
> > +             memcpy(addr2line_cmd + strlen(buf), ADDR2LINE,
> strlen(ADDR2LINE));
> > +             buf =3D find_executable(addr2line_cmd);
> > +             if (buf) {
> > +                     memcpy(addr2line_cmd, buf, strlen(buf));
> > +                     free(buf);
> > +             }
> > +             return addr2line_cmd;
> > +     case A2L_LLVM:
> > +     default:
> > +             return NULL;
> > +     }
> > +}
> > +
> > +char *get_vmlinux(char *input)
> > +{
> > +     const char *match_string1 =3D ".syms";
> > +     const char *match_string2 =3D ".tmp_vmlinux.kallsyms";
> > +     char *result =3D NULL;
> > +     char *match_pos;
> > +
> > +     match_pos =3D strstr(input, match_string1);
> > +     if (!match_pos)
> > +             return NULL;
> > +
> > +     match_pos =3D strstr(input, match_string2);
> > +     if (!match_pos)
> > +             return NULL;
> > +
> > +     result =3D strdup(input);
> > +     match_pos =3D strstr(result, match_string1);
> > +     *match_pos =3D '\0';
> > +     return result;
> > +}
> > diff --git a/scripts/kas_alias/a2l.h b/scripts/kas_alias/a2l.h
> > new file mode 100644
> > index 000000000000..ca6419229dde
> > --- /dev/null
> > +++ b/scripts/kas_alias/a2l.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef A2L_H
> > +#define A2L_H
> > +#include <stdint.h>
> > +
> > +#define ADDR2LINE "addr2line"
> > +#define ADDR2LINE_ARGS "-fe"
> > +//#define VMLINUX "vmlinux"
> > +#define MAX_BUF 4096
> > +#define MAX_CMD_LEN 256
> > +#define P_READ 0
> > +#define P_WRITE 1
> > +#define A2L_DEFAULT 1
> > +#define A2L_CROSS 2
> > +#define A2L_LLVM 3
> > +#define A2L_MAKE_VALUE 2
> > +
> > +extern int addr2line_pid;
> > +extern int a2l_in[2];
> > +extern int a2l_out[2];
> > +extern char line[MAX_BUF];
> > +extern char vmlinux_path[MAX_BUF];
> > +extern char addr2line_cmd[MAX_CMD_LEN];
> > +
> > +int addr2line_init(const char *cmd, const char *vmlinux);
> > +char *addr2line_get_lines(uint64_t address);
> > +int addr2line_cleanup(void);
> > +const char *remove_subdir(const char *home, const char *f_path);
> > +const char *get_addr2line(int mode);
> > +char *get_vmlinux(char *input);
> > +
> > +#endif
> > diff --git a/scripts/kas_alias/duplicates_list.c
> > b/scripts/kas_alias/duplicates_list.c new file mode 100644
> > index 000000000000..e7a3d2917937
> > --- /dev/null
> > +++ b/scripts/kas_alias/duplicates_list.c
> > @@ -0,0 +1,70 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdint.h>
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <stdlib.h>
> > +#include <stdbool.h>
> > +
> > +#include "item_list.h"
> > +#include "duplicates_list.h"
> > +
> > +struct duplicate_item *find_duplicates(struct item *list)
> > +{
> > +     struct duplicate_item *current_duplicate =3D NULL;
> > +     struct duplicate_item *duplicates =3D NULL;
> > +     struct duplicate_item *new_duplicate;
> > +     struct item *current_item =3D list;
> > +     bool prev_was_duplicate =3D false;
> > +     struct item *prev_item =3D NULL;
> > +
> > +     while (current_item) {
> > +             if ((prev_item && (strcmp(current_item->symb_name, prev_i=
tem-
> >symb_name)
> > =3D=3D 0)) || +               prev_was_duplicate) {
> > +                     if (!duplicates) {
> > +                             duplicates =3D malloc(sizeof(struct
> duplicate_item));
> > +                             if (!duplicates)
> > +                                     return NULL;
> > +
> > +                             duplicates->original_item =3D prev_item;
> > +                             duplicates->next =3D NULL;
> > +                             current_duplicate =3D duplicates;
> > +                     } else {
> > +                             new_duplicate =3D malloc(sizeof(struct
> duplicate_item));
> > +                             if (!new_duplicate) {
> > +                                     free_duplicates(&duplicates);
> > +                                     return NULL;
> > +                             }
> > +
> > +                             new_duplicate->original_item =3D prev_ite=
m;
> > +                             new_duplicate->next =3D NULL;
> > +                             current_duplicate->next =3D new_duplicate=
;
> > +                             current_duplicate =3D new_duplicate;
> > +
> > +                             if ((strcmp(current_item->symb_name, prev=
_item-
> >symb_name) !=3D 0) &&
> > +                                 (prev_was_duplicate))
> > +                                     prev_was_duplicate =3D false;
> > +                             else
> > +                                     prev_was_duplicate =3D true;
>
> You can remove the branch and set prev_was_duplicate to:
> prev_was_duplicate =3D strcmp(current_item->symb_name, prev_item->symb_na=
me) !=3D
> 0 && prev_was_duplicate;
 I agree with all your points, except for one.
While your statement is undoubtedly more concise than mine, in the v4,
I actually use its negation.
>
> > +                     }
> > +             }
> > +
> > +             prev_item =3D current_item;
> > +             current_item =3D current_item->next;
> > +     }
> > +
> > +     return duplicates;
> > +}
> > +
> > +void free_duplicates(struct duplicate_item **duplicates)
> > +{
> > +     struct duplicate_item *duplicates_iterator =3D *duplicates;
> > +     struct duplicate_item *app;
> > +
> > +     while (duplicates_iterator) {
> > +             app =3D duplicates_iterator;
> > +             duplicates_iterator =3D duplicates_iterator->next;
> > +             free(app);
> > +     }
> > +
> > +     *duplicates =3D NULL;
> > +}
> > diff --git a/scripts/kas_alias/duplicates_list.h
> > b/scripts/kas_alias/duplicates_list.h new file mode 100644
> > index 000000000000..76aa73e584bc
> > --- /dev/null
> > +++ b/scripts/kas_alias/duplicates_list.h
> > @@ -0,0 +1,15 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef DUPLICATES_LIST_H
> > +#define DUPLICATES_LIST_H
> > +
> > +#include "item_list.h"
> > +
> > +struct duplicate_item {
> > +     struct item *original_item;
> > +     struct duplicate_item *next;
> > +};
> > +
> > +struct duplicate_item *find_duplicates(struct item *list);
> > +void free_duplicates(struct duplicate_item **duplicates);
> > +
> > +#endif
> > diff --git a/scripts/kas_alias/item_list.c b/scripts/kas_alias/item_lis=
t.c
> > new file mode 100644
> > index 000000000000..48f2e525592a
> > --- /dev/null
> > +++ b/scripts/kas_alias/item_list.c
> > @@ -0,0 +1,230 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdint.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <assert.h>
> > +#include "item_list.h"
> > +
> > +#define CHECK_ORDER_BY_ADDRESS(sort_by, current, temp, op) \
> > +     ((sort_by) =3D=3D BY_ADDRESS && (current)->addr op (temp)->addr)
> > +#define CHECK_ORDER_BY_NAME(sort_by, current, temp, op) \
> > +     ((sort_by) =3D=3D BY_NAME && strcmp((current)->symb_name, (temp)-
> >symb_name)
> > op 0) +
> > +struct item *list_index[96] =3D {0};
> > +
> > +void build_index(struct item *list)
> > +{
> > +     char current_first_letter =3D ' ';
> > +     struct item *current =3D list;
> > +
> > +     while (current) {
> > +             if (current->symb_name[0] !=3D current_first_letter) {
> > +                     current_first_letter =3D current->symb_name[0];
> > +                     list_index[current_first_letter - 32] =3D current=
;
>
> > +             }
> > +             current =3D current->next;
> > +     }
> > +}
> > +
> > +struct item *add_item(struct item **list, const char *name, char stype=
,
> > uint64_t addr) +{
> > +     struct item *new_item;
> > +     struct item *current;
> > +
> > +     new_item =3D malloc(sizeof(struct item));
> > +     if (!new_item)
> > +             return NULL;
> > +
> > +     strncpy(new_item->symb_name, name, MAX_NAME_SIZE);
> > +     new_item->symb_name[MAX_NAME_SIZE - 1] =3D '\0';
> > +     new_item->addr =3D addr;
> > +     new_item->stype =3D stype;
> > +     new_item->next =3D NULL;
> > +
> > +     if (!(*list)) {
> > +             *list =3D new_item;
> > +     } else {
> > +             current =3D *list;
> > +             while (current->next)
> > +                     current =3D current->next;
> > +
> > +             current->next =3D new_item;
> > +     }
> > +     return new_item;
> > +}
> > +
> > +void sort_list(struct item **list, int sort_by)
> > +{
> > +     struct item *current =3D *list;
> > +     struct item *sorted =3D NULL;
> > +     struct item *next_item;
> > +     struct item *temp;
> > +
> > +     if (!(*list) || !((*list)->next))
> > +             return;
> > +
> > +     while (current) {
> > +             next_item =3D current->next;
> > +             if (!sorted ||
> > +                 (CHECK_ORDER_BY_ADDRESS(sort_by, current, sorted, <) =
||
> > +                 CHECK_ORDER_BY_NAME(sort_by, current, sorted, >=3D)))=
 {
> > +                     current->next =3D sorted;
> > +                     sorted =3D current;
> > +             } else {
> > +                     temp =3D sorted;
> > +                     while (temp->next &&
> > +                            (CHECK_ORDER_BY_ADDRESS(sort_by, current, =
temp-
> >next, >=3D) ||
> > +                            CHECK_ORDER_BY_NAME(sort_by, current, temp=
->next,
> >=3D)))
> > +                             temp =3D temp->next;
> > +
> > +                     current->next =3D temp->next;
> > +                     temp->next =3D current;
> > +             }
> > +             current =3D next_item;
> > +     }
> > +
> > +     *list =3D sorted;
> > +}
> > +
> > +struct item *merge(struct item *left, struct item *right, int sort_by)
>
> > +{
> > +     struct item *current =3D NULL;
> > +     struct item *result =3D NULL;
> > +
> > +     if (!left)
> > +             return right;
> > +     if (!right)
> > +             return left;
> > +
> > +     if (sort_by =3D=3D BY_NAME) {
> > +             if (strcmp(left->symb_name, right->symb_name) <=3D 0) {
> > +                     result =3D left;
> > +                     left =3D left->next;
> > +             } else {
> > +                     result =3D right;
> > +                     right =3D right->next;
> > +             }
> > +     } else {
> > +             if (sort_by =3D=3D BY_ADDRESS) {
> > +                     if (left->addr <=3D right->addr) {
> > +                             result =3D left;
> > +                             left =3D left->next;
> > +                     } else {
> > +                             result =3D right;
> > +                             right =3D right->next;
> > +                     }
> > +             }
> > +     }
> > +
> > +     current =3D result;
> > +
> > +     while (left && right) {
> > +             if (sort_by =3D=3D BY_NAME) {
> > +                     if (strcmp(left->symb_name, right->symb_name) <=
=3D 0) {
> > +                             current->next =3D left;
> > +                             left =3D left->next;
> > +                     } else {
> > +                             current->next =3D right;
> > +                             right =3D right->next;
> > +                     }
> > +             } else {
> > +                     if (sort_by =3D=3D BY_ADDRESS) {
> > +                             if (left->addr <=3D right->addr) {
> > +                                     current->next =3D left;
> > +                                     left =3D left->next;
> > +                             } else {
> > +                                     current->next =3D right;
> > +                                     right =3D right->next;
> > +                             }
> > +                     }
> > +             }
> > +
> > +             current =3D current->next;
> > +     }
> > +
> > +     if (left) {
> > +             current->next =3D left;
> > +     } else {
> > +             if (right)
>
> > +                     current->next =3D right;
> > +     }
> > +
> > +     return result;
> > +}
> > +
> > +struct item *merge_sort(struct item *head, int sort_by)
> > +{
> > +     struct item *right;
> > +     struct item *slow;
> > +     struct item *fast;
> > +     struct item *left;
> > +
> > +     if (!head || !head->next)
> > +             return head;
> > +
> > +     slow =3D head;
> > +     fast =3D head->next;
> > +
> > +     while (fast && fast->next) {
> > +             slow =3D slow->next;
> > +             fast =3D fast->next->next;
> > +     }
> > +
> > +     left =3D head;
> > +     right =3D slow->next;
> > +     slow->next =3D NULL;
> > +
> > +     left =3D merge_sort(left, sort_by);
> > +     right =3D merge_sort(right, sort_by);
> > +
> > +     return merge(left, right, sort_by);
> > +}
> > +
> > +void sort_list_m(struct item **head, int sort_by)
> > +{
> > +     if (!(*head) || !((*head)->next))
> > +             return;
> > +
> > +     *head =3D merge_sort(*head, sort_by);
> > +}
> > +
> > +int insert_after(struct item *list, const uint64_t search_addr,
> > +              const char *name, uint64_t addr, char stype)
> > +{
> > +     struct item *new_item;
> > +     struct item *current;
> > +     int ret =3D 0;
> > +
> > +     current =3D (list_index[name[0] - 32]) ? list_index[name[0] - 32]=
 :
> list;
> > +     while (current) {
> > +             if (current->addr =3D=3D search_addr) {
> > +                     new_item =3D malloc(sizeof(struct item));
> > +                     if (!new_item)
> > +                             return ret;
> > +                     strncpy(new_item->symb_name, name, MAX_NAME_SIZE)=
;
> > +                     new_item->symb_name[MAX_NAME_SIZE - 1] =3D '\0';
> > +                     new_item->addr =3D addr;
> > +                     new_item->stype =3D stype;
> > +                     new_item->next =3D current->next;
> > +                     current->next =3D new_item;
> > +                     ret =3D 1;
> > +                     break;
>
> > +             }
> > +             current =3D current->next;
> > +     }
> > +     return ret;
> > +}
> > +
> > +void free_items(struct item **head)
> > +{
> > +     struct item *app, *item_iterator =3D *head;
> > +
> > +     while (item_iterator) {
> > +             app =3D item_iterator;
> > +             item_iterator =3D item_iterator->next;
> > +             free(app);
> > +     }
> > +     *head =3D NULL;
> > +}
> > diff --git a/scripts/kas_alias/item_list.h b/scripts/kas_alias/item_lis=
t.h
> > new file mode 100644
> > index 000000000000..b4891cb088ee
> > --- /dev/null
> > +++ b/scripts/kas_alias/item_list.h
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef ITEM_LIST_H
> > +#define ITEM_LIST_H
> > +#include <stdint.h>
> > +
> > +#define MAX_NAME_SIZE 256
> > +#define BY_ADDRESS 1
> > +#define BY_NAME 2
> > +
> > +struct item {
> > +     char            symb_name[MAX_NAME_SIZE];
> > +     uint64_t        addr;
> > +     char            stype;
> > +     struct item     *next;
> > +};
> > +
> > +void build_index(struct item *list);
> > +struct item *add_item(struct item **list, const char *name, char stype=
,
> > uint64_t addr); +void sort_list(struct item **list, int sort_by);
> > +struct item *merge(struct item *left, struct item *right, int sort_by)=
;
> > +struct item *merge_sort(struct item *head, int sort_by);
> > +void sort_list_m(struct item **head, int sort_by);
> > +int insert_after(struct item *list, const uint64_t search_addr,
> > +              const char *name, uint64_t addr, char stype);
> > +void free_items(struct item **head);
> > +#endif
> > diff --git a/scripts/kas_alias/kas_alias.c b/scripts/kas_alias/kas_alia=
s.c
> > new file mode 100644
> > index 000000000000..532aeb39f851
> > --- /dev/null
> > +++ b/scripts/kas_alias/kas_alias.c
> > @@ -0,0 +1,217 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdint.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <stdarg.h>
> > +#include <regex.h>
> > +
> > +#include "item_list.h"
> > +#include "duplicates_list.h"
> > +#include "a2l.h"
> > +
> > +#define SYMB_IS_TEXT(s) ((((s)->stype) =3D=3D 't') ||  (((s)->stype) =
=3D=3D 'T'))
> > +#define SYMB_IS_DATA(s) ((((s)->stype) =3D=3D 'b') ||  (((s)->stype) =
=3D=3D 'B') ||
> > \ +                    (((s)->stype) =3D=3D 'd') ||  (((s)->stype) =3D=
=3D 'D') || \
> > +                      (((s)->stype) =3D=3D 'r') ||  (((s)->stype) =3D=
=3D 'R'))
> > +#ifdef CONFIG_KALLSYMS_ALIAS_DATA
> > +#define SYMB_NEEDS_ALIAS(s) (SYMB_IS_TEXT(s) || SYMB_IS_DATA(s))
> > +#else
> > +#define SYMB_NEEDS_ALIAS(s) SYMB_IS_TEXT(s)
> > +#endif
> > +#define FNOMATCH 0
> > +#define FMATCH 1
> > +#define EREGEX 2
> > +
> > +const char *ignore_regex[] =3D {
> > +     "^__cfi_.*$",                           // __cfi_ preamble
> > +#ifndef CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > +     "^_*TRACE_SYSTEM.*$",
> > +     "^__already_done\\.[0-9]+$",            // Call a function once d=
ata
> > +     "^___tp_str\\.[0-9]+$",
> > +     "^___done\\.[0-9]+$",
> > +     "^__print_once\\.[0-9]+$",
> > +     "^_rs\\.[0-9]+$",
> > +     "^__compound_literal\\.[0-9]+$",
> > +     "^___once_key\\.[0-9]+$",
> > +     "^__func__\\.[0-9]+$",
> > +     "^__msg\\.[0-9]+$",
> > +     "^CSWTCH\\.[0-9]+$",
> > +     "^__flags\\.[0-9]+$",
> > +     "^__wkey.*$",
> > +     "^__mkey.*$",
> > +     "^__key.*$",
> > +#endif
> > +     "^__pfx_.*$"                            // NOP-padding
> > +};
> > +
> > +int suffix_serial;
> > +
> > +static inline void verbose_msg(bool verbose, const char *fmt, ...)
> > +{
> > +     va_list args;
> > +
> > +     va_start(args, fmt);
> > +     if (verbose)
> > +             printf(fmt, args);
> > +
> > +     va_end(args);
> > +}
> > +
> > +static void create_suffix(const char *name, char *output_suffix)
> > +{
> > +     sprintf(output_suffix, "%s__alias__%d", name, suffix_serial++);
> > +}
> > +
> > +static void create_file_suffix(const char *name, uint64_t address, cha=
r
> > *output_suffix, char *cwd) +{
> > +     const char *f_path;
> > +     char *buf;
> > +     int i =3D 0;
> > +
> > +     buf =3D addr2line_get_lines(address);
> > +     f_path =3D remove_subdir(cwd, buf);
> > +     if (f_path) {
> > +             sprintf(output_suffix, "%s@%s", name, f_path);
> > +             while (*(output_suffix + i) !=3D '\0') {
> > +                     switch (*(output_suffix + i)) {
> > +                     case '/':
> > +                     case ':':
> > +                     case '.':
> > +                             *(output_suffix + i) =3D '_';
> > +                             break;
> > +                     default:
> > +                     }
> > +             i++;
> > +             }
> > +     } else {
> > +             create_suffix(name, output_suffix);
> > +     }
> > +}
> > +
> > +static int filter_symbols(char *symbol, const char **ignore_list, int
> > regex_no) +{
> > +     regex_t regex;
> > +     int res, i;
> > +
> > +     for (i =3D 0; i < regex_no; i++) {
> > +             res =3D regcomp(&regex, ignore_list[i], REG_EXTENDED);
> > +             if (res)
> > +                     return -EREGEX;
> > +
> > +             res =3D regexec(&regex, symbol, 0, NULL, 0);
> > +             regfree(&regex);
> > +             switch (res) {
> > +             case 0:
> > +                     return FMATCH;
> > +             case REG_NOMATCH:
> > +                     break;
> > +             default:
> > +                     return -EREGEX;
> > +             }
> > +     }
> > +
> > +     return FNOMATCH;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     char t, sym_name[MAX_NAME_SIZE], new_name[MAX_NAME_SIZE + 15];
> > +     struct duplicate_item  *duplicate_iterator;
> > +     struct duplicate_item *duplicate;
> > +     struct item *head =3D {NULL};
> > +     bool need_2_process =3D true;
> > +     struct item *last =3D {NULL};
> > +     struct item  *current;
> > +     int verbose_mode =3D 0;
> > +     uint64_t address;
> > +     FILE *fp;
> > +     int res;
> > +
> > +     if (argc < 2 || argc > 3) {
> > +             printf("Usage: %s <nmfile> [-verbose]\n", argv[0]);
> > +             return 1;
> > +     }
> > +
> > +     if (argc =3D=3D 3 && strcmp(argv[2], "-verbose") =3D=3D 0)
> > +             verbose_mode =3D 1;
> > +
> > +     verbose_msg(verbose_mode, "Scanning nm data(%s)\n", argv[1]);
> > +
> > +     fp =3D fopen(argv[1], "r");
> > +     if (!fp) {
> > +             printf("Can't open input file.\n");
> > +             return 1;
> > +     }
> > +
> > +     if (!addr2line_init(get_addr2line(A2L_DEFAULT), get_vmlinux(argv[=
1])))
> > +             return 1;
> > +
> > +     while (fscanf(fp, "%lx %c %99s\n", &address, &t, sym_name) =3D=3D=
 3) {
> > +             if (strstr(sym_name, "@_")) {
> > +                     if (verbose_mode && need_2_process)
> > +                             printf("Already processed\n");
> > +                     need_2_process =3D false;
> > +                     }
> > +             last =3D add_item(&last, sym_name, t, address);
> > +             if (!last) {
> > +                     printf("Error in allocate memory\n");
> > +                     free_items(&head);
> > +                     return 1;
> > +             }
> > +
> > +             if (!head)
> > +                     head =3D last;
> > +     }
> > +
> > +     fclose(fp);
> > +
> > +     if (need_2_process) {
> > +             verbose_msg(verbose_mode, "Sorting nm data\n");
> > +             sort_list_m(&head, BY_NAME);
> > +             verbose_msg(verbose_mode, "Scanning nm data for duplicate=
s\n");
> > +             duplicate =3D find_duplicates(head);
> > +             if (!duplicate) {
> > +                     printf("Error in duplicates list\n");
> > +                     return 1;
> > +             }
> > +
> > +             verbose_msg(verbose_mode, "Applying suffixes\n");
> > +             build_index(head);
> > +             duplicate_iterator =3D duplicate;
> > +             while (duplicate_iterator) {
> > +                     res =3D filter_symbols(duplicate_iterator->origin=
al_item-
> >symb_name,
> > +                                          ignore_regex, sizeof(ignore_=
regex) /
> > +                                          sizeof(ignore_regex[0]));
> > +                     if (res !=3D FMATCH &&
> > +                         SYMB_NEEDS_ALIAS(duplicate_iterator->original=
_item))
> {
> > +                             if (res < 0)
> > +                                     return 1;
> > +
> > +                             create_file_suffix(duplicate_iterator-
> >original_item->symb_name,
> > +                                                duplicate_iterator-
> >original_item->addr,
> > +                                                new_name, vmlinux_path=
);
> > +                             if (!insert_after(head, duplicate_iterato=
r-
> >original_item->addr,
> > +                                               new_name, duplicate_ite=
rator-
> >original_item->addr,
> > +                                               duplicate_iterator-
> >original_item->stype))
> > +                                     return 1;
> > +                     }
> > +
> > +                     duplicate_iterator =3D duplicate_iterator->next;
> > +             }
> > +
> > +             sort_list_m(&head, BY_ADDRESS);
> > +     }
> > +     current =3D head;
> > +     while (current) {
> > +             printf("%08lx %c %s\n", current->addr, current->stype,
> > current->symb_name); +                current =3D current->next;
> > +     }
> > +
> > +     free_items(&head);
> > +     free_duplicates(&duplicate);
> > +     addr2line_cleanup();
> > +     return 0;
> > +}
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index a432b171be82..cacf60b597ce 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -89,8 +89,9 @@ vmlinux_link()
> >
> >       ldflags=3D"${ldflags} ${wl}--script=3D${objtree}/${KBUILD_LDS}"
> >
> > -     # The kallsyms linking does not need debug symbols included.
> > -     if [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
> > +     # The kallsyms linking does not need debug symbols included, unle=
ss
> the
> > KALLSYMS_ALIAS. +     if [ ! is_enabled CONFIG_KALLSYMS_ALIAS ] && \
> > +         [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
> >               ldflags=3D"${ldflags} ${wl}--strip-debug"
> >       fi
> >
> > @@ -161,7 +162,11 @@ kallsyms()
> >       fi
> >
> >       info KSYMS ${2}
> > -     scripts/kallsyms ${kallsymopt} ${1} > ${2}
> > +     if is_enabled CONFIG_KALLSYMS_ALIAS; then
> > +             ALIAS=3D".alias"
> > +             scripts/kas_alias/kas_alias ${1} >${1}${ALIAS}
> > +             fi
> > +     scripts/kallsyms ${kallsymopt} ${1}${ALIAS} > ${2}
> >  }
> >
> >  # Perform one step in kallsyms generation, including temporary linking=
 of
>
> Best regards.
>
>
Cheers
