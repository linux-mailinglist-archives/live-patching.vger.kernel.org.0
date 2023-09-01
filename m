Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6869078F801
	for <lists+live-patching@lfdr.de>; Fri,  1 Sep 2023 07:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbjIAFc1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Sep 2023 01:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348265AbjIAFc0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Sep 2023 01:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E989310C0;
        Thu, 31 Aug 2023 22:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED35615BC;
        Fri,  1 Sep 2023 05:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB2DC43391;
        Fri,  1 Sep 2023 05:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693546340;
        bh=5ZPd9fRdLQ8FeR3DbNpRVNgLxwDW3ILt/Hjgrxw+/4k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fkyS0ry3Mw5sTPKQ5YmEXp1wSwVkzuBPun43iqwNZMx8mxLlaaHKSR6e31Uxs9Yn+
         7zSvkTZea7YHtNKx/SYz8SzQNHgM1+tjwOAw5NF0aBvGmlcNM/fcQhuRV11+wVsrZt
         pleq8Fhr0fKWgtG+o4y7knKvocTcJ/Clj1n3WCTjm+AoT/nr1DpRGyp1i9gR6PAOM9
         MhxmMpKMB5AOHjstZ5ZnrueE78bqKhdkPjvAU2VVRKJhkgKpguDg4Aj4o27IV/6Md5
         Woe1w5y5QebyXmHKQcIoMzLU2snCWiy2Qxpf6SJ8XXTh1J9b6mmD76FD/xjDSgAlfN
         9MFXLJcEDTtLg==
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3a9f88b657eso973230b6e.3;
        Thu, 31 Aug 2023 22:32:20 -0700 (PDT)
X-Gm-Message-State: AOJu0YzyixO0TirfluXyNYhh6593PWsrJsraohfpopHeYDuQHmMZiNup
        /LQv1q3eqnQ5NKZBQQyMa1u3KCiRZy2/rp5BOyY=
X-Google-Smtp-Source: AGHT+IH7j6Ra4gowrTUnHaRVLswUS2wCDDtCcUzcsYoInnPaEXuzOBZ4s393x5b/cgTRVw7bWDDTR8TLqWCLHctbXUo=
X-Received: by 2002:a05:6808:250:b0:3a7:a299:1203 with SMTP id
 m16-20020a056808025000b003a7a2991203mr1560409oie.22.1693546339545; Thu, 31
 Aug 2023 22:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
In-Reply-To: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 1 Sep 2023 14:31:42 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT4wE9cHC5a5q1X2ogJr85ksjsWvn0F8m91GjCjPpK=Fw@mail.gmail.com>
Message-ID: <CAK7LNAT4wE9cHC5a5q1X2ogJr85ksjsWvn0F8m91GjCjPpK=Fw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
>
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
>  create mode 100644 scripts/kas_alias/Makefile
>  create mode 100644 scripts/kas_alias/a2l.c
>  create mode 100644 scripts/kas_alias/a2l.h
>  create mode 100644 scripts/kas_alias/duplicates_list.c
>  create mode 100644 scripts/kas_alias/duplicates_list.h
>  create mode 100644 scripts/kas_alias/item_list.c
>  create mode 100644 scripts/kas_alias/item_list.h
>  create mode 100644 scripts/kas_alias/kas_alias.c
>
> diff --git a/init/Kconfig b/init/Kconfig
> index f7f65af4ee12..bc69fcd9cbc8 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1737,6 +1737,42 @@ config KALLSYMS_BASE_RELATIVE
>           time constants, and no relocation pass is required at runtime t=
o fix
>           up the entries based on the runtime load address of the kernel.
>
> +config KALLSYMS_ALIAS
> +       bool "Produces alias for duplicated symbols" if EXPERT
> +       depends on KALLSYMS && (DEBUG_INFO_DWARF4 || DEBUG_INFO_DWARF5)


You can simplify this to


           depends on KALLSYMS && DEBUG_INFO

I re-checked the commit log of
a66049e2cf0ef166dba5bafdbb3062287fc965ad

It says "GCC since ~4.8 has defaulted to DWARF v4
implicitly, and GCC 11 has bumped this to v5"


When DEBUG_INFO is enabled, the dwarf version is 4 or 5.


Presumably, your code does not work with DEBUG_INFO_SPLIT


   depends on KALLSYMS && DEBUG_INFO && !DEBUG_INFO_SPLIT




> diff --git a/scripts/kas_alias/a2l.c b/scripts/kas_alias/a2l.c
> new file mode 100644
> index 000000000000..a9692ac30180
> --- /dev/null
> +++ b/scripts/kas_alias/a2l.c
> @@ -0,0 +1,268 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <string.h>


<string.h> is included twice.

I always sort include directives alphabetically
to avoid such a mistake.






> +#include <stdint.h>
> +#include <stdbool.h>
> +
> +#include "a2l.h"
> +
> +int addr2line_pid =3D -1;
> +int a2l_in[2];
> +int a2l_out[2];
> +char line[MAX_BUF];
> +char vmlinux_path[MAX_BUF];
> +char addr2line_cmd[MAX_CMD_LEN];
> +FILE *a2l_stdin, *a2l_stdout;
> +
> +static char *normalize_path(const char *input_path, char *output_path)
> +{
> +       char *prev_token =3D NULL;
> +       char *delimiter =3D "/";
> +       char inbuf[MAX_BUF];
> +       char *token;
> +       char *pos;
> +
> +       memset(inbuf, 0, MAX_BUF);
> +       *output_path =3D '\0';
> +       strncpy(inbuf, input_path, MAX_BUF);
> +       if (!input_path || !output_path || strlen(input_path) =3D=3D 0)
> +               return NULL;
> +
> +       token =3D strtok(inbuf, delimiter);
> +       while (token) {
> +               if (strcmp(token, "..") =3D=3D 0 && prev_token) {
> +                       pos =3D strrchr(output_path, '/');
> +                       if (pos)
> +                               *pos =3D '\0';
> +
> +               } else if (strcmp(token, ".") !=3D 0) {
> +                       strcat(output_path, "/");
> +                       strcat(output_path, token);
> +               }
> +
> +               prev_token =3D token;
> +               token =3D strtok(NULL, delimiter);
> +       }
> +
> +       return output_path;
> +}
> +
> +static void path_of(const char *full_path, char *path)
> +{
> +       const char *last_slash =3D strrchr(full_path, '/');
> +       size_t path_length;
> +       char cwd[MAX_BUF];
> +
> +       if (!last_slash) {
> +               if (getcwd(cwd, sizeof(cwd)))
> +                       strcpy(path, cwd);
> +               else
> +                       strcpy(path, ".");
> +       } else {
> +               path_length =3D last_slash - full_path;
> +               strncpy(path, full_path, path_length);
> +               path[path_length] =3D '\0';
> +       }
> +}
> +
> +static bool file_exists(const char *file_path)
> +{
> +       FILE *file;
> +
> +       file =3D fopen(file_path, "r");
> +       if (file) {
> +               fclose(file);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +int addr2line_init(const char *cmd, const char *vmlinux)
> +{
> +       if ((!file_exists(cmd)) || (!file_exists(vmlinux))) {
> +               printf("file not found\n");
> +               return 0;
> +               }
> +
> +       path_of(vmlinux, vmlinux_path);
> +       if (pipe(a2l_in) =3D=3D -1) {
> +               printf("Failed to create pipe\n");
> +               return 0;
> +       }
> +
> +       if (pipe(a2l_out) =3D=3D -1) {
> +               printf("Failed to create pipe\n");
> +               return 0;
> +       }
> +
> +       addr2line_pid =3D fork();
> +       if (addr2line_pid =3D=3D -1) {
> +               printf("Failed to fork process\n");
> +               close(a2l_in[P_READ]);
> +               close(a2l_in[P_WRITE]);
> +               close(a2l_out[P_READ]);
> +               close(a2l_out[P_WRITE]);
> +               return 0;
> +       }
> +
> +       if (addr2line_pid =3D=3D 0) {
> +               dup2(a2l_in[P_READ], 0);
> +               dup2(a2l_out[P_WRITE], 1);
> +               close(a2l_in[P_WRITE]);
> +               close(a2l_out[P_READ]);
> +
> +               execlp(cmd, cmd, ADDR2LINE_ARGS, vmlinux, NULL);
> +
> +               printf("Failed to execute addr2line command\n");
> +               exit(1);
> +       } else {
> +               close(a2l_in[P_READ]);
> +               close(a2l_out[P_WRITE]);
> +       }
> +
> +       a2l_stdin =3D fdopen(a2l_in[P_WRITE], "w");
> +       if (!a2l_stdin) {
> +               printf("Failed to open pipe a2l_in\n");
> +               return 0;
> +       }
> +
> +       a2l_stdout =3D fdopen(a2l_out[P_READ], "r");
> +       if (!a2l_stdout) {
> +               printf("Failed to open pipe a2l_out\n");
> +               fclose(a2l_stdin);
> +               return 0;
> +       }
> +
> +       return 1;
> +}
> +
> +const char *remove_subdir(const char *home, const char *f_path)
> +{
> +       int i =3D 0;
> +
> +       while (*(home + i) =3D=3D *(f_path + i))
> +               i++;
> +
> +       return (strlen(home) !=3D i) ? NULL : f_path + i;
> +}
> +
> +char *addr2line_get_lines(uint64_t address)
> +{
> +       char buf[MAX_BUF];
> +
> +       fprintf(a2l_stdin, "%08lx\n", address);
> +       fflush(a2l_stdin);
> +
> +       if (!fgets(line, sizeof(line), a2l_stdout)) {
> +               printf("Failed to read lines from addr2line\n");
> +               return NULL;
> +       }
> +
> +       if (!fgets(line, sizeof(line), a2l_stdout)) {
> +               printf("Failed to read lines from addr2line\n");
> +               return NULL;
> +       }
> +
> +       line[strcspn(line, "\n")] =3D '\0';
> +       strncpy(buf, line, MAX_BUF);
> +       return normalize_path(buf, line);
> +}
> +
> +int addr2line_cleanup(void)
> +{
> +       int status;
> +
> +       if (addr2line_pid !=3D -1) {
> +               kill(addr2line_pid, SIGKILL);
> +               waitpid(addr2line_pid, &status, 0);
> +               fclose(a2l_stdin);
> +               fclose(a2l_stdout);
> +               addr2line_pid =3D -1;
> +       }
> +
> +       return 1;
> +}
> +
> +static char *find_executable(const char *command)
> +{
> +       char *path_env =3D getenv("PATH");
> +       char *executable_path;
> +       char *path_copy;
> +       char *path;
> +       int n;
> +
> +       if (!path_env)
> +               return NULL;
> +
> +       path_copy =3D strdup(path_env);
> +       if (!path_copy)
> +               return NULL;
> +
> +       path =3D strtok(path_copy, ":");
> +       while (path) {
> +               n =3D snprintf(0, 0, "%s/%s", path, command);
> +               executable_path =3D (char *)malloc(n + 1);
> +               snprintf(executable_path, n + 1, "%s/%s", path, command);
> +               if (access(executable_path, X_OK) =3D=3D 0) {
> +                       free(path_copy);
> +                       return executable_path;
> +               }
> +
> +       path =3D strtok(NULL, ":");
> +       free(executable_path);
> +       executable_path =3D NULL;
> +       }
> +
> +       free(path_copy);
> +       if (executable_path)
> +               free(executable_path);
> +       return NULL;
> +}
> +
> +const char *get_addr2line(int mode)
> +{
> +       char *buf =3D "";
> +
> +       switch (mode) {
> +       case A2L_CROSS:
> +               buf =3D getenv("CROSS_COMPILE");
> +               memcpy(addr2line_cmd, buf, strlen(buf));

Dangerous code.
It is easy to cause a buffer overrun by setting a long string to CROSS_COMP=
ILE.


I am fine with adding ADDR2LINE in the top Makefile.





> +       case A2L_DEFAULT:
> +               memcpy(addr2line_cmd + strlen(buf), ADDR2LINE, strlen(ADD=
R2LINE));
> +               buf =3D find_executable(addr2line_cmd);
> +               if (buf) {
> +                       memcpy(addr2line_cmd, buf, strlen(buf));
> +                       free(buf);
> +               }
> +               return addr2line_cmd;
> +       case A2L_LLVM:
> +       default:
> +               return NULL;
> +       }
> +}
> +
> +char *get_vmlinux(char *input)
> +{
> +       const char *match_string1 =3D ".syms";
> +       const char *match_string2 =3D ".tmp_vmlinux.kallsyms";
> +       char *result =3D NULL;
> +       char *match_pos;
> +
> +       match_pos =3D strstr(input, match_string1);
> +       if (!match_pos)
> +               return NULL;
> +
> +       match_pos =3D strstr(input, match_string2);
> +       if (!match_pos)
> +               return NULL;
> +
> +       result =3D strdup(input);
> +       match_pos =3D strstr(result, match_string1);
> +       *match_pos =3D '\0';
> +       return result;
> +}

Tedious code to compute the vmlinux name.
You can pass vmlinux from command line.




> diff --git a/scripts/kas_alias/item_list.c b/scripts/kas_alias/item_list.=
c
> new file mode 100644
> index 000000000000..48f2e525592a
> --- /dev/null
> +++ b/scripts/kas_alias/item_list.c
> @@ -0,0 +1,230 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <assert.h>
> +#include "item_list.h"
> +
> +#define CHECK_ORDER_BY_ADDRESS(sort_by, current, temp, op) \
> +       ((sort_by) =3D=3D BY_ADDRESS && (current)->addr op (temp)->addr)
> +#define CHECK_ORDER_BY_NAME(sort_by, current, temp, op) \
> +       ((sort_by) =3D=3D BY_NAME && strcmp((current)->symb_name, (temp)-=
>symb_name) op 0)
> +
> +struct item *list_index[96] =3D {0};
> +
> +void build_index(struct item *list)
> +{
> +       char current_first_letter =3D ' ';
> +       struct item *current =3D list;
> +
> +       while (current) {
> +               if (current->symb_name[0] !=3D current_first_letter) {
> +                       current_first_letter =3D current->symb_name[0];
> +                       list_index[current_first_letter - 32] =3D current=
;
> +               }
> +               current =3D current->next;
> +       }
> +}
> +
> +struct item *add_item(struct item **list, const char *name, char stype, =
uint64_t addr)
> +{
> +       struct item *new_item;
> +       struct item *current;
> +
> +       new_item =3D malloc(sizeof(struct item));
> +       if (!new_item)
> +               return NULL;
> +
> +       strncpy(new_item->symb_name, name, MAX_NAME_SIZE);
> +       new_item->symb_name[MAX_NAME_SIZE - 1] =3D '\0';
> +       new_item->addr =3D addr;
> +       new_item->stype =3D stype;
> +       new_item->next =3D NULL;
> +
> +       if (!(*list)) {
> +               *list =3D new_item;
> +       } else {
> +               current =3D *list;
> +               while (current->next)
> +                       current =3D current->next;


What is the purpose of the ->next traverse in while() loop?

If you remember the last item,
you know where the new item should be connected, don't you?





> +struct item *merge(struct item *left, struct item *right, int sort_by)
> +{
> +       struct item *current =3D NULL;
> +       struct item *result =3D NULL;
> +
> +       if (!left)
> +               return right;
> +       if (!right)
> +               return left;
> +
> +       if (sort_by =3D=3D BY_NAME) {
> +               if (strcmp(left->symb_name, right->symb_name) <=3D 0) {
> +                       result =3D left;
> +                       left =3D left->next;
> +               } else {
> +                       result =3D right;
> +                       right =3D right->next;
> +               }
> +       } else {
> +               if (sort_by =3D=3D BY_ADDRESS) {
> +                       if (left->addr <=3D right->addr) {
> +                               result =3D left;
> +                               left =3D left->next;
> +                       } else {
> +                               result =3D right;
> +                               right =3D right->next;
> +                       }
> +               }
> +       }
> +
> +       current =3D result;
> +
> +       while (left && right) {
> +               if (sort_by =3D=3D BY_NAME) {
> +                       if (strcmp(left->symb_name, right->symb_name) <=
=3D 0) {
> +                               current->next =3D left;
> +                               left =3D left->next;
> +                       } else {
> +                               current->next =3D right;
> +                               right =3D right->next;
> +                       }
> +               } else {
> +                       if (sort_by =3D=3D BY_ADDRESS) {
> +                               if (left->addr <=3D right->addr) {
> +                                       current->next =3D left;
> +                                       left =3D left->next;
> +                               } else {
> +                                       current->next =3D right;
> +                                       right =3D right->next;
> +                               }
> +                       }
> +               }
> +
> +               current =3D current->next;
> +       }
> +
> +       if (left) {
> +               current->next =3D left;
> +       } else {
> +               if (right)
> +                       current->next =3D right;
> +       }
> +
> +       return result;
> +}
> +
> +struct item *merge_sort(struct item *head, int sort_by)



Any reason why you did not use qsort() in the C library?


One disadvantage of quick sort is that it is not "stable sort".

But, your algorithm (sort by name and sort by address)
does not keep the order anyway.




> diff --git a/scripts/kas_alias/item_list.h b/scripts/kas_alias/item_list.=
h
> new file mode 100644
> index 000000000000..b4891cb088ee
> --- /dev/null
> +++ b/scripts/kas_alias/item_list.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef ITEM_LIST_H
> +#define ITEM_LIST_H
> +#include <stdint.h>
> +
> +#define MAX_NAME_SIZE 256
> +#define BY_ADDRESS 1
> +#define BY_NAME 2
> +
> +struct item {
> +       char            symb_name[MAX_NAME_SIZE];
> +       uint64_t        addr;
> +       char            stype;
> +       struct item     *next;
> +};
> +
> +void build_index(struct item *list);
> +struct item *add_item(struct item **list, const char *name, char stype, =
uint64_t addr);
> +void sort_list(struct item **list, int sort_by);
> +struct item *merge(struct item *left, struct item *right, int sort_by);
> +struct item *merge_sort(struct item *head, int sort_by);
> +void sort_list_m(struct item **head, int sort_by);
> +int insert_after(struct item *list, const uint64_t search_addr,
> +                const char *name, uint64_t addr, char stype);
> +void free_items(struct item **head);
> +#endif
> diff --git a/scripts/kas_alias/kas_alias.c b/scripts/kas_alias/kas_alias.=
c
> new file mode 100644
> index 000000000000..532aeb39f851
> --- /dev/null
> +++ b/scripts/kas_alias/kas_alias.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <stdarg.h>
> +#include <regex.h>
> +
> +#include "item_list.h"
> +#include "duplicates_list.h"
> +#include "a2l.h"
> +
> +#define SYMB_IS_TEXT(s) ((((s)->stype) =3D=3D 't') ||  (((s)->stype) =3D=
=3D 'T'))
> +#define SYMB_IS_DATA(s) ((((s)->stype) =3D=3D 'b') ||  (((s)->stype) =3D=
=3D 'B') || \
> +                        (((s)->stype) =3D=3D 'd') ||  (((s)->stype) =3D=
=3D 'D') || \
> +                        (((s)->stype) =3D=3D 'r') ||  (((s)->stype) =3D=
=3D 'R'))
> +#ifdef CONFIG_KALLSYMS_ALIAS_DATA



Please do not use #ifdef CONFIG_ in host programs.

Also, please note include/linux/kconfig.h is not included
for host programs, so this #ifdef is always false.

You never tested this CONFIG_KALLSYMS_ALIAS_DATA







> +#define SYMB_NEEDS_ALIAS(s) (SYMB_IS_TEXT(s) || SYMB_IS_DATA(s))
> +#else
> +#define SYMB_NEEDS_ALIAS(s) SYMB_IS_TEXT(s)
> +#endif
> +#define FNOMATCH 0
> +#define FMATCH 1
> +#define EREGEX 2
> +
> +const char *ignore_regex[] =3D {
> +       "^__cfi_.*$",                           // __cfi_ preamble
> +#ifndef CONFIG_KALLSYMS_ALIAS_DATA_ALL
> +       "^_*TRACE_SYSTEM.*$",
> +       "^__already_done\\.[0-9]+$",            // Call a function once d=
ata
> +       "^___tp_str\\.[0-9]+$",
> +       "^___done\\.[0-9]+$",
> +       "^__print_once\\.[0-9]+$",
> +       "^_rs\\.[0-9]+$",
> +       "^__compound_literal\\.[0-9]+$",
> +       "^___once_key\\.[0-9]+$",
> +       "^__func__\\.[0-9]+$",
> +       "^__msg\\.[0-9]+$",
> +       "^CSWTCH\\.[0-9]+$",
> +       "^__flags\\.[0-9]+$",
> +       "^__wkey.*$",
> +       "^__mkey.*$",
> +       "^__key.*$",
> +#endif
> +       "^__pfx_.*$"                            // NOP-padding
> +};
> +
> +int suffix_serial;
> +
> +static inline void verbose_msg(bool verbose, const char *fmt, ...)

Meaningless 'inline'.  Only 'static' is enough.


> +{
> +       va_list args;
> +
> +       va_start(args, fmt);
> +       if (verbose)
> +               printf(fmt, args);



You cannot pass va_list to printf().

The correct code is:

          vprintf(fmt, args);








> +
> +       va_end(args);
> +}


verbose_msg() prints the message to stdout.

If verbose_msge is enabled, the output file breaks
because you redirect both real data and debug messages
in this way:
   scripts/kas_alias/kas_alias <input>   > <output>


If you implement debug logging, I recommend this:

   scripts/kas_alias/kas_alias <input> <output>





> +
> +static void create_suffix(const char *name, char *output_suffix)
> +{
> +       sprintf(output_suffix, "%s__alias__%d", name, suffix_serial++);
> +}
> +
> +static void create_file_suffix(const char *name, uint64_t address, char =
*output_suffix, char *cwd)
> +{
> +       const char *f_path;
> +       char *buf;
> +       int i =3D 0;
> +
> +       buf =3D addr2line_get_lines(address);
> +       f_path =3D remove_subdir(cwd, buf);
> +       if (f_path) {
> +               sprintf(output_suffix, "%s@%s", name, f_path);
> +               while (*(output_suffix + i) !=3D '\0') {
> +                       switch (*(output_suffix + i)) {
> +                       case '/':
> +                       case ':':
> +                       case '.':
> +                               *(output_suffix + i) =3D '_';
> +                               break;
> +                       default:
> +                       }
> +               i++;
> +               }
> +       } else {
> +               create_suffix(name, output_suffix);
> +       }
> +}
> +
> +static int filter_symbols(char *symbol, const char **ignore_list, int re=
gex_no)
> +{
> +       regex_t regex;
> +       int res, i;
> +
> +       for (i =3D 0; i < regex_no; i++) {
> +               res =3D regcomp(&regex, ignore_list[i], REG_EXTENDED);
> +               if (res)
> +                       return -EREGEX;
> +
> +               res =3D regexec(&regex, symbol, 0, NULL, 0);
> +               regfree(&regex);
> +               switch (res) {
> +               case 0:
> +                       return FMATCH;
> +               case REG_NOMATCH:
> +                       break;
> +               default:
> +                       return -EREGEX;
> +               }
> +       }
> +
> +       return FNOMATCH;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       char t, sym_name[MAX_NAME_SIZE], new_name[MAX_NAME_SIZE + 15];
> +       struct duplicate_item  *duplicate_iterator;
> +       struct duplicate_item *duplicate;
> +       struct item *head =3D {NULL};



This might be something new I should learn.

When I initialize a pointer, I always write like this:
        struct item *head =3D NULL;


I have never seen this style before:
        struct item *head =3D {NULL};

But, the compiler does not warn about it.
Could you educate me how it works?





> +       bool need_2_process =3D true;
> +       struct item *last =3D {NULL};
> +       struct item  *current;
> +       int verbose_mode =3D 0;
> +       uint64_t address;
> +       FILE *fp;
> +       int res;
> +
> +       if (argc < 2 || argc > 3) {
> +               printf("Usage: %s <nmfile> [-verbose]\n", argv[0]);
> +               return 1;
> +       }
> +
> +       if (argc =3D=3D 3 && strcmp(argv[2], "-verbose") =3D=3D 0)


"-v" or "--verbose" is better
(although there is no way to enable it.)


Anyway, I only see super-boring messages
even with -verbose given.

Scanning nm data()
Sorting nm data
Scanning nm data for duplicates
Applying suffixes



> +               verbose_mode =3D 1;
> +
> +       verbose_msg(verbose_mode, "Scanning nm data(%s)\n", argv[1]);
> +
> +       fp =3D fopen(argv[1], "r");
> +       if (!fp) {
> +               printf("Can't open input file.\n");
> +               return 1;
> +       }
> +
> +       if (!addr2line_init(get_addr2line(A2L_DEFAULT), get_vmlinux(argv[=
1])))
> +               return 1;
> +
> +       while (fscanf(fp, "%lx %c %99s\n", &address, &t, sym_name) =3D=3D=
 3) {
> +               if (strstr(sym_name, "@_")) {
> +                       if (verbose_mode && need_2_process)
> +                               printf("Already processed\n");
> +                       need_2_process =3D false;
> +                       }
> +               last =3D add_item(&last, sym_name, t, address);
> +               if (!last) {
> +                       printf("Error in allocate memory\n");
> +                       free_items(&head);
> +                       return 1;
> +               }
> +
> +               if (!head)
> +                       head =3D last;
> +       }
> +
> +       fclose(fp);
> +
> +       if (need_2_process) {
> +               verbose_msg(verbose_mode, "Sorting nm data\n");
> +               sort_list_m(&head, BY_NAME);
> +               verbose_msg(verbose_mode, "Scanning nm data for duplicate=
s\n");
> +               duplicate =3D find_duplicates(head);
> +               if (!duplicate) {
> +                       printf("Error in duplicates list\n");
> +                       return 1;
> +               }
> +
> +               verbose_msg(verbose_mode, "Applying suffixes\n");
> +               build_index(head);
> +               duplicate_iterator =3D duplicate;
> +               while (duplicate_iterator) {
> +                       res =3D filter_symbols(duplicate_iterator->origin=
al_item->symb_name,
> +                                            ignore_regex, sizeof(ignore_=
regex) /
> +                                            sizeof(ignore_regex[0]));
> +                       if (res !=3D FMATCH &&
> +                           SYMB_NEEDS_ALIAS(duplicate_iterator->original=
_item)) {
> +                               if (res < 0)
> +                                       return 1;
> +
> +                               create_file_suffix(duplicate_iterator->or=
iginal_item->symb_name,
> +                                                  duplicate_iterator->or=
iginal_item->addr,
> +                                                  new_name, vmlinux_path=
);
> +                               if (!insert_after(head, duplicate_iterato=
r->original_item->addr,
> +                                                 new_name, duplicate_ite=
rator->original_item->addr,
> +                                                 duplicate_iterator->ori=
ginal_item->stype))
> +                                       return 1;
> +                       }
> +
> +                       duplicate_iterator =3D duplicate_iterator->next;
> +               }
> +
> +               sort_list_m(&head, BY_ADDRESS);



Do you sort just for finding duplicates?


Since you sort the list by name, and then sort by address.

It can potentially change the order.


[input]
00000000 D foo
00000000 D bar
00000010 D baz

[merge sort by name]
00000000 D bar
00000010 D baz
00000000 D foo

[merge sort by address =3D final result]
00000000 D bar
00000000 D foo
00000010 D baz


It may not be a big deal, but such a destructive algorithm is frowned.



You do not need to sort the list to find duplicates.


Another choice is a hashtable of { name : count }.
Traversing the list, you can count the number of occurrences.
If count >=3D 2, it is duplicated.

The average look-up of a hashtable is O(1).
So, the hashtable (or set) algorithm is O(N).


Sorting is O(N log N).





> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index a432b171be82..cacf60b597ce 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -89,8 +89,9 @@ vmlinux_link()
>
>         ldflags=3D"${ldflags} ${wl}--script=3D${objtree}/${KBUILD_LDS}"
>
> -       # The kallsyms linking does not need debug symbols included.
> -       if [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
> +       # The kallsyms linking does not need debug symbols included, unle=
ss the KALLSYMS_ALIAS.
> +       if [ ! is_enabled CONFIG_KALLSYMS_ALIAS ] && \


I observed this error message:


scripts/link-vmlinux.sh: 93: [: is_enabled: unexpected operator


The correct code is this:


        if ! is_enabled CONFIG_KALLSYMS_ALIAS && \










> +           [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
>                 ldflags=3D"${ldflags} ${wl}--strip-debug"
>         fi
>
> @@ -161,7 +162,11 @@ kallsyms()
>         fi
>
>         info KSYMS ${2}
> -       scripts/kallsyms ${kallsymopt} ${1} > ${2}
> +       if is_enabled CONFIG_KALLSYMS_ALIAS; then
> +               ALIAS=3D".alias"
> +               scripts/kas_alias/kas_alias ${1} >${1}${ALIAS}
> +               fi
> +       scripts/kallsyms ${kallsymopt} ${1}${ALIAS} > ${2}
>  }
>
>  # Perform one step in kallsyms generation, including temporary linking o=
f
> --
> 2.34.1
>


--
Best Regards



Masahiro Yamada
