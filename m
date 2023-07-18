Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84D75831E
	for <lists+live-patching@lfdr.de>; Tue, 18 Jul 2023 18:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjGRQ63 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 Jul 2023 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjGRQ6H (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 Jul 2023 12:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F3D170B;
        Tue, 18 Jul 2023 09:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FFA96169F;
        Tue, 18 Jul 2023 16:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E3EC433CA;
        Tue, 18 Jul 2023 16:55:25 +0000 (UTC)
Date:   Tue, 18 Jul 2023 12:55:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alessandro Carminati <alessandro.carminati@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Nick Alcock <nick.alcock@oracle.com>, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, mcgrof@kernel.org,
        live-patching@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-ID: <20230718125523.2fc05491@gandalf.local.home>
In-Reply-To: <CAPp5cGQVFU4FvVLAJhZTeAtcB1Lo=DXE+moEh-Ri1XDbjF2N6Q@mail.gmail.com>
References: <20230714150326.1152359-1-alessandro.carminati@gmail.com>
        <20230717105240.3d986331@gandalf.local.home>
        <CAPp5cGQVFU4FvVLAJhZTeAtcB1Lo=DXE+moEh-Ri1XDbjF2N6Q@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 18 Jul 2023 18:06:36 +0200
Alessandro Carminati <alessandro.carminati@gmail.com> wrote:

> Hi Steven,
> 
> >
> > Honestly, I think the "_alias_<some-random-number>" is useless. It doesn't
> > give you any clue to what function you are actually attaching to. There's
> > been other approaches that show module and/or file names. I know there's
> > still some issues with getting those accepted, but I much rather have them
> > than this!
> >
> > See: https://lore.kernel.org/all/20221205163157.269335-1-nick.alcock@oracle.com/
> >  
> 
> Thanks for sharing your thoughts on the current symbol naming convention and
> Nick Alcock's approach.
> I see your point about "alias<some-random-number>" not providing much context
> about the attached function.
> However, my intention was only to create a means to probe all functions.

We already have something that differentiates those functions. We have the address.

For example, we have:

 ~# grep calipso_sock_getattr /proc/kallsyms
ffffffff9b540a70 t calipso_sock_getattr
ffffffff9b55cef0 T calipso_sock_getattr

I can then add the second one to kprobe events:

 ~# echo 'p:sock_getattr 0xffffffff9b55cef0 sk=%di' > /sys/kernel/tracing/kprobe_events

As we have this work around, I don't want to add something that gives us
not much better. 

> 
> While other approaches, such as including module and file names, are more
> informative, it appears that these proposals are encountering certain
> challenges in gaining acceptance. Also, they do not fully address the
> specific problem I wanted to tackle.
> 
> In my upcoming proposal, I would like to maintain the conservative approach I
> have followed so far while still achieving my original objective of making all
> functions reachable from kprobe.

They should already be, as you can attach kprobes via the address and not
just the name.

> 
> To date, I have been working on addressing all the necessary aspects from
> outside the kernel source code. Essentially, I take the output of 'nm' and
> refine it to provide more meaningful information.
> 
> I am working in a V3, I am considering using `addr2line` to
> determine the origin of each symbol. Initially, I avoided it because the
> configuration dependency it introduces, specifically requiring DWARF
> information such as CONFIG_DEBUG_INFO_DWARF4 or
> CONFIG_DEBUG_INFO_DWARF5.
> 
> However, after reading Luis' comment suggesting the use of
> 'filename + line number', I realized that relying on DWARF information might
> be the only way to achieve a satisfying result.
> I will try that and see if it works... unless you know it will not already :-)

Do you only need DWARF for the build process, or need to include it into
kernel memory?

> 
> Actually, I did a fast try using DWARF and addr2line, the strategy I'd like to
> use in the v3, and the output looks like this: what do you guys think?
> 
>  $ ../kas_alias/main .tmp_vmlinux.kallsyms2.syms | grep name_show
>  ffffffff8100e5e0 t __pfx_pmu_name_show
>  ffffffff8100e5f0 t pmu_name_show
>  ffffffff810ed8e0 t __pfx_name_show
>  ffffffff810ed8f0 t name_show
>  ffffffff810ed8f0 t name_show@_kernel_irq_irqdesc_c_232
>  ffffffff810ed950 t __pfx_chip_name_show
>  ffffffff810ed960 t chip_name_show
>  ffffffff810ed960 t chip_name_show@_kernel_irq_irqdesc_c_168
>  ffffffff814cae80 t __pfx_name_show
>  ffffffff814cae90 t name_show
>  ffffffff814cae90 t name_show@_drivers_pnp_card_c_186
>  ffffffff816006d0 t __pfx_name_show
>  ffffffff816006e0 t name_show
>  ffffffff816006e0 t name_show@_drivers_gpu_drm_i915_gt_sysfs_engines_c_26
>  ffffffff81765460 t __pfx_name_show
>  ffffffff81765470 t name_show
>  ffffffff81765470 t name_show@_drivers_base_power_wakeup_stats_c_93
>  ffffffff8189b340 t __pfx_name_show
>  [...]

At build time you'll add the names and then include the above?

-- Steve

> 
> I want to emphasize that my goal is to find a solution that satisfies everyone
> involved and addresses the concerns raised.
> 
> Bests
> Alessandro
> 
> > -- Steve
> >
> >  
> > > Changes from v1:
> > > - Integrated changes requested by Masami to exclude symbols with prefixes
> > >   "_cfi" and "_pfx".
> > > - Introduced a small framework to handle patterns that need to be excluded
> > >   from the alias production.
> > > - Excluded other symbols using the framework.
> > > - Introduced the ability to discriminate between text and data symbols.
> > > - Added two new config symbols in this version: CONFIG_KALLSYMS_ALIAS_DATA,
> > >   which allows data for data, and CONFIG_KALLSYMS_ALIAS_DATA_ALL, which
> > >   excludes all filters and provides an alias for each duplicated symbol.
> > >
> > > https://lore.kernel.org/all/20230711151925.1092080-1-alessandro.carminati@gmail.com/
> > >
> > > Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
> > > ---
> > >  init/Kconfig                        |  36 +++++
> > >  scripts/Makefile                    |   4 +
> > >  scripts/kas_alias/Makefile          |   4 +
> > >  scripts/kas_alias/duplicates_list.c |  70 +++++++++
> > >  scripts/kas_alias/duplicates_list.h |  15 ++
> > >  scripts/kas_alias/item_list.c       | 230 ++++++++++++++++++++++++++++
> > >  scripts/kas_alias/item_list.h       |  26 ++++
> > >  scripts/kas_alias/kas_alias.c       | 186 ++++++++++++++++++++++
> > >  scripts/link-vmlinux.sh             |   6 +-
> > >  9 files changed, 576 insertions(+), 1 deletion(-)
> > >  create mode 100644 scripts/kas_alias/Makefile
> > >  create mode 100644 scripts/kas_alias/duplicates_list.c
> > >  create mode 100644 scripts/kas_alias/duplicates_list.h
> > >  create mode 100644 scripts/kas_alias/item_list.c
> > >  create mode 100644 scripts/kas_alias/item_list.h
> > >  create mode 100644 scripts/kas_alias/kas_alias.c
> > >
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index f7f65af4ee12..5ae7c613cdc4 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -1737,6 +1737,42 @@ config KALLSYMS_BASE_RELATIVE
> > >         time constants, and no relocation pass is required at runtime to fix
> > >         up the entries based on the runtime load address of the kernel.
> > >
> > > +config KALLSYMS_ALIAS
> > > +     bool "Produces alias for duplicated symbols" if EXPERT
> > > +     depends on KALLSYMS
> > > +     help
> > > +       It is not uncommon for drivers or modules related to similar
> > > +       peripherals to have symbols with the exact same name.
> > > +       While this is not a problem for the kernel's binary itself, it
> > > +       becomes an issue when attempting to trace or probe specific
> > > +       functions using infrastructure like ftrace or kprobe.
> > > +
> > > +       This option addresses this challenge by extending the symbol names
> > > +       with unique suffixes during the kernel build process.
> > > +       The newly created aliases for these duplicated symbols are unique
> > > +       names that can be fed to the ftrace sysfs interface. By doing so, it
> > > +       enables previously unreachable symbols to be probed.
> > > +
> > > +config CONFIG_KALLSYMS_ALIAS_DATA
> > > +     bool "Produces alias also for data"
> > > +     depends on KALLSYMS_ALIAS
> > > +     help
> > > +       Sometimes it can be useful to refer to data. In live patch scenarios,
> > > +       you may find yourself needing to use symbols that are shared with
> > > +       other functions. Since symbols face the same issue as functions, this
> > > +       option allows you to create aliases for data as well.
> > > +
> > > +config CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > > +     bool "Removes all filter when producing data alias"
> > > +     depends on CONFIG_KALLSYMS_ALIAS_DATA
> > > +     help
> > > +       When selecting data aliases, not all symbols are included in the set
> > > +       This is because many symbols are unlikely to be used. If you choose
> > > +       to have an alias for all data symbols, be aware that it will
> > > +       significantly increase the size.
> > > +
> > > +       If unsure, say N.
> > > +
> > >  # end of the "standard kernel features (expert users)" menu
> > >
> > >  # syscall, maps, verifier
> > > diff --git a/scripts/Makefile b/scripts/Makefile
> > > index 32b6ba722728..65fafe17cfe5 100644
> > > --- a/scripts/Makefile
> > > +++ b/scripts/Makefile
> > > @@ -49,3 +49,7 @@ subdir-$(CONFIG_SECURITY_SELINUX) += selinux
> > >
> > >  # Let clean descend into subdirs
> > >  subdir-      += basic dtc gdb kconfig mod
> > > +
> > > +# KALLSyms alias
> > > +subdir-$(CONFIG_KALLSYMS_ALIAS) += kas_alias
> > > +
> > > diff --git a/scripts/kas_alias/Makefile b/scripts/kas_alias/Makefile
> > > new file mode 100644
> > > index 000000000000..523fa3441013
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/Makefile
> > > @@ -0,0 +1,4 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +hostprogs-always-$(CONFIG_KALLSYMS_ALIAS)    += kas_alias
> > > +
> > > +kas_alias-objs        := duplicates_list.o item_list.o kas_alias.o
> > > diff --git a/scripts/kas_alias/duplicates_list.c b/scripts/kas_alias/duplicates_list.c
> > > new file mode 100644
> > > index 000000000000..e7a3d2917937
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/duplicates_list.c
> > > @@ -0,0 +1,70 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +#include <stdint.h>
> > > +#include <stdio.h>
> > > +#include <string.h>
> > > +#include <stdlib.h>
> > > +#include <stdbool.h>
> > > +
> > > +#include "item_list.h"
> > > +#include "duplicates_list.h"
> > > +
> > > +struct duplicate_item *find_duplicates(struct item *list)
> > > +{
> > > +     struct duplicate_item *current_duplicate = NULL;
> > > +     struct duplicate_item *duplicates = NULL;
> > > +     struct duplicate_item *new_duplicate;
> > > +     struct item *current_item = list;
> > > +     bool prev_was_duplicate = false;
> > > +     struct item *prev_item = NULL;
> > > +
> > > +     while (current_item) {
> > > +             if ((prev_item && (strcmp(current_item->symb_name, prev_item->symb_name) == 0)) ||
> > > +                 prev_was_duplicate) {
> > > +                     if (!duplicates) {
> > > +                             duplicates = malloc(sizeof(struct duplicate_item));
> > > +                             if (!duplicates)
> > > +                                     return NULL;
> > > +
> > > +                             duplicates->original_item = prev_item;
> > > +                             duplicates->next = NULL;
> > > +                             current_duplicate = duplicates;
> > > +                     } else {
> > > +                             new_duplicate = malloc(sizeof(struct duplicate_item));
> > > +                             if (!new_duplicate) {
> > > +                                     free_duplicates(&duplicates);
> > > +                                     return NULL;
> > > +                             }
> > > +
> > > +                             new_duplicate->original_item = prev_item;
> > > +                             new_duplicate->next = NULL;
> > > +                             current_duplicate->next = new_duplicate;
> > > +                             current_duplicate = new_duplicate;
> > > +
> > > +                             if ((strcmp(current_item->symb_name, prev_item->symb_name) != 0) &&
> > > +                                 (prev_was_duplicate))
> > > +                                     prev_was_duplicate = false;
> > > +                             else
> > > +                                     prev_was_duplicate = true;
> > > +                     }
> > > +             }
> > > +
> > > +             prev_item = current_item;
> > > +             current_item = current_item->next;
> > > +     }
> > > +
> > > +     return duplicates;
> > > +}
> > > +
> > > +void free_duplicates(struct duplicate_item **duplicates)
> > > +{
> > > +     struct duplicate_item *duplicates_iterator = *duplicates;
> > > +     struct duplicate_item *app;
> > > +
> > > +     while (duplicates_iterator) {
> > > +             app = duplicates_iterator;
> > > +             duplicates_iterator = duplicates_iterator->next;
> > > +             free(app);
> > > +     }
> > > +
> > > +     *duplicates = NULL;
> > > +}
> > > diff --git a/scripts/kas_alias/duplicates_list.h b/scripts/kas_alias/duplicates_list.h
> > > new file mode 100644
> > > index 000000000000..76aa73e584bc
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/duplicates_list.h
> > > @@ -0,0 +1,15 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +#ifndef DUPLICATES_LIST_H
> > > +#define DUPLICATES_LIST_H
> > > +
> > > +#include "item_list.h"
> > > +
> > > +struct duplicate_item {
> > > +     struct item *original_item;
> > > +     struct duplicate_item *next;
> > > +};
> > > +
> > > +struct duplicate_item *find_duplicates(struct item *list);
> > > +void free_duplicates(struct duplicate_item **duplicates);
> > > +
> > > +#endif
> > > diff --git a/scripts/kas_alias/item_list.c b/scripts/kas_alias/item_list.c
> > > new file mode 100644
> > > index 000000000000..7c9d5aecca9a
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/item_list.c
> > > @@ -0,0 +1,230 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +#include <stdio.h>
> > > +#include <stdlib.h>
> > > +#include <stdint.h>
> > > +#include <string.h>
> > > +#include <stdbool.h>
> > > +#include <assert.h>
> > > +#include "item_list.h"
> > > +
> > > +#define CHECK_ORDER_BY_ADDRESS(sort_by, current, temp, op) \
> > > +     ((sort_by) == BY_ADDRESS && (current)->addr op (temp)->addr)
> > > +#define CHECK_ORDER_BY_NAME(sort_by, current, temp, op) \
> > > +     ((sort_by) == BY_NAME && strcmp((current)->symb_name, (temp)->symb_name) op 0)
> > > +
> > > +struct item *list_index[96] = {0};
> > > +
> > > +void build_index(struct item *list)
> > > +{
> > > +     char current_first_letter = ' ';
> > > +     struct item *current = list;
> > > +
> > > +     while (current) {
> > > +             if (current->symb_name[0] != current_first_letter) {
> > > +                     current_first_letter = current->symb_name[0];
> > > +                     list_index[current_first_letter - 32] = current;
> > > +             }
> > > +             current = current->next;
> > > +     }
> > > +}
> > > +
> > > +struct item *add_item(struct item **list, const char *name, char stype, uint64_t addr)
> > > +{
> > > +     struct item *new_item;
> > > +     struct item *current;
> > > +
> > > +     new_item = malloc(sizeof(struct item));
> > > +     if (!new_item)
> > > +             return NULL;
> > > +
> > > +     strncpy(new_item->symb_name, name, MAX_NAME_SIZE);
> > > +     new_item->symb_name[MAX_NAME_SIZE - 1] = '\0';
> > > +     new_item->addr = addr;
> > > +     new_item->stype = stype;
> > > +     new_item->next = NULL;
> > > +
> > > +     if (!(*list)) {
> > > +             *list = new_item;
> > > +     } else {
> > > +             current = *list;
> > > +             while (current->next)
> > > +                     current = current->next;
> > > +
> > > +             current->next = new_item;
> > > +     }
> > > +     return new_item;
> > > +}
> > > +
> > > +void sort_list(struct item **list, int sort_by)
> > > +{
> > > +     struct item *current = *list;
> > > +     struct item *sorted = NULL;
> > > +     struct item *next_item;
> > > +     struct item *temp;
> > > +
> > > +     if (!(*list) || !((*list)->next))
> > > +             return;
> > > +
> > > +     while (current) {
> > > +             next_item = current->next;
> > > +             if (!sorted ||
> > > +                (CHECK_ORDER_BY_ADDRESS(sort_by, current, sorted, <) ||
> > > +                 CHECK_ORDER_BY_NAME(sort_by, current, sorted, >=))) {
> > > +                     current->next = sorted;
> > > +                     sorted = current;
> > > +             } else {
> > > +                     temp = sorted;
> > > +                     while (temp->next &&
> > > +                           (CHECK_ORDER_BY_ADDRESS(sort_by, current, temp->next, >=) ||
> > > +                            CHECK_ORDER_BY_NAME(sort_by, current, temp->next, >=)))
> > > +                             temp = temp->next;
> > > +
> > > +                     current->next = temp->next;
> > > +                     temp->next = current;
> > > +             }
> > > +             current = next_item;
> > > +     }
> > > +
> > > +     *list = sorted;
> > > +}
> > > +
> > > +struct item *merge(struct item *left, struct item *right, int sort_by)
> > > +{
> > > +     struct item *current = NULL;
> > > +     struct item *result = NULL;
> > > +
> > > +     if (!left)
> > > +             return right;
> > > +     if (!right)
> > > +             return left;
> > > +
> > > +     if (sort_by == BY_NAME) {
> > > +             if (strcmp(left->symb_name, right->symb_name) <= 0) {
> > > +                     result = left;
> > > +                     left = left->next;
> > > +             } else {
> > > +                     result = right;
> > > +                     right = right->next;
> > > +             }
> > > +     } else {
> > > +             if (sort_by == BY_ADDRESS) {
> > > +                     if (left->addr <= right->addr) {
> > > +                             result = left;
> > > +                             left = left->next;
> > > +                     } else {
> > > +                             result = right;
> > > +                             right = right->next;
> > > +                     }
> > > +             }
> > > +     }
> > > +
> > > +     current = result;
> > > +
> > > +     while (left && right) {
> > > +             if (sort_by == BY_NAME) {
> > > +                     if (strcmp(left->symb_name, right->symb_name) <= 0) {
> > > +                             current->next = left;
> > > +                             left = left->next;
> > > +                     } else {
> > > +                             current->next = right;
> > > +                             right = right->next;
> > > +                     }
> > > +             } else {
> > > +                     if (sort_by == BY_ADDRESS) {
> > > +                             if (left->addr <= right->addr) {
> > > +                                     current->next = left;
> > > +                                     left = left->next;
> > > +                             } else {
> > > +                                     current->next = right;
> > > +                                     right = right->next;
> > > +                             }
> > > +                     }
> > > +             }
> > > +
> > > +             current = current->next;
> > > +     }
> > > +
> > > +     if (left) {
> > > +             current->next = left;
> > > +     } else {
> > > +             if (right)
> > > +                     current->next = right;
> > > +     }
> > > +
> > > +     return result;
> > > +}
> > > +
> > > +struct item *merge_sort(struct item *head, int sort_by)
> > > +{
> > > +     struct item *right;
> > > +     struct item *slow;
> > > +     struct item *fast;
> > > +     struct item *left;
> > > +
> > > +     if (!head || !head->next)
> > > +             return head;
> > > +
> > > +     slow = head;
> > > +     fast = head->next;
> > > +
> > > +     while (fast && fast->next) {
> > > +             slow = slow->next;
> > > +             fast = fast->next->next;
> > > +     }
> > > +
> > > +     left = head;
> > > +     right = slow->next;
> > > +     slow->next = NULL;
> > > +
> > > +     left = merge_sort(left, sort_by);
> > > +     right = merge_sort(right, sort_by);
> > > +
> > > +     return merge(left, right, sort_by);
> > > +}
> > > +
> > > +void sort_list_m(struct item **head, int sort_by)
> > > +{
> > > +     if (!(*head) || !((*head)->next))
> > > +             return;
> > > +
> > > +     *head = merge_sort(*head, sort_by);
> > > +}
> > > +
> > > +int insert_after(struct item *list, const uint64_t search_addr,
> > > +              const char *name, uint64_t addr, char stype)
> > > +{
> > > +     struct item *new_item;
> > > +     struct item *current;
> > > +     int ret = 0;
> > > +
> > > +     current = (list_index[name[0] - 32]) ? list_index[name[0] - 32] : list;
> > > +     while (current) {
> > > +             if (current->addr == search_addr) {
> > > +                     new_item = malloc(sizeof(struct item));
> > > +                     if (!new_item)
> > > +                             return ret;
> > > +                     strncpy(new_item->symb_name, name, MAX_NAME_SIZE);
> > > +                     new_item->symb_name[MAX_NAME_SIZE - 1] = '\0';
> > > +                     new_item->addr = addr;
> > > +                     new_item->stype = stype;
> > > +                     new_item->next = current->next;
> > > +                     current->next = new_item;
> > > +                     ret = 1;
> > > +                     break;
> > > +             }
> > > +             current = current->next;
> > > +     }
> > > +     return ret;
> > > +}
> > > +
> > > +void free_items(struct item **head)
> > > +{
> > > +     struct item *app, *item_iterator = *head;
> > > +
> > > +     while (item_iterator) {
> > > +             app = item_iterator;
> > > +             item_iterator = item_iterator->next;
> > > +             free(app);
> > > +     }
> > > +     *head = NULL;
> > > +}
> > > diff --git a/scripts/kas_alias/item_list.h b/scripts/kas_alias/item_list.h
> > > new file mode 100644
> > > index 000000000000..b4891cb088ee
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/item_list.h
> > > @@ -0,0 +1,26 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +#ifndef ITEM_LIST_H
> > > +#define ITEM_LIST_H
> > > +#include <stdint.h>
> > > +
> > > +#define MAX_NAME_SIZE 256
> > > +#define BY_ADDRESS 1
> > > +#define BY_NAME 2
> > > +
> > > +struct item {
> > > +     char            symb_name[MAX_NAME_SIZE];
> > > +     uint64_t        addr;
> > > +     char            stype;
> > > +     struct item     *next;
> > > +};
> > > +
> > > +void build_index(struct item *list);
> > > +struct item *add_item(struct item **list, const char *name, char stype, uint64_t addr);
> > > +void sort_list(struct item **list, int sort_by);
> > > +struct item *merge(struct item *left, struct item *right, int sort_by);
> > > +struct item *merge_sort(struct item *head, int sort_by);
> > > +void sort_list_m(struct item **head, int sort_by);
> > > +int insert_after(struct item *list, const uint64_t search_addr,
> > > +              const char *name, uint64_t addr, char stype);
> > > +void free_items(struct item **head);
> > > +#endif
> > > diff --git a/scripts/kas_alias/kas_alias.c b/scripts/kas_alias/kas_alias.c
> > > new file mode 100644
> > > index 000000000000..eb873b368023
> > > --- /dev/null
> > > +++ b/scripts/kas_alias/kas_alias.c
> > > @@ -0,0 +1,186 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +#include <stdio.h>
> > > +#include <stdlib.h>
> > > +#include <stdint.h>
> > > +#include <string.h>
> > > +#include <stdbool.h>
> > > +#include <stdarg.h>
> > > +#include <regex.h>
> > > +
> > > +#include "item_list.h"
> > > +#include "duplicates_list.h"
> > > +
> > > +#define SYMB_IS_TEXT(s) ((((s)->stype) == 't') ||  (((s)->stype) == 'T'))
> > > +#define SYMB_IS_DATA(s) ((((s)->stype) == 'b') ||  (((s)->stype) == 'B') || \
> > > +                      (((s)->stype) == 'd') ||  (((s)->stype) == 'D') || \
> > > +                      (((s)->stype) == 'r') ||  (((s)->stype) == 'R'))
> > > +#ifdef CONFIG_KALLSYMS_ALIAS_DATA
> > > +#define SYMB_NEEDS_ALIAS(s) (SYMB_IS_TEXT(s) || SYMB_IS_DATA(s))
> > > +#else
> > > +#define SYMB_NEEDS_ALIAS(s) SYMB_IS_TEXT(s)
> > > +#endif
> > > +#define FNOMATCH 0
> > > +#define FMATCH 1
> > > +#define EREGEX 2
> > > +
> > > +const char *ignore_regex[] = {
> > > +     "^__cfi_.*$",                           // __cfi_ preamble
> > > +#ifndef CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > > +     "^_*TRACE_SYSTEM.*$",
> > > +     "^__already_done\\.[0-9]+$",            // Call a function once data
> > > +     "^___tp_str\\.[0-9]+$",
> > > +     "^___done\\.[0-9]+$",
> > > +     "^__print_once\\.[0-9]+$",
> > > +     "^_rs\\.[0-9]+$",
> > > +     "^__compound_literal\\.[0-9]+$",
> > > +     "^___once_key\\.[0-9]+$",
> > > +     "^__func__\\.[0-9]+$",
> > > +     "^__msg\\.[0-9]+$",
> > > +     "^CSWTCH\\.[0-9]+$",
> > > +     "^__flags\\.[0-9]+$",
> > > +     "^__wkey.*$",
> > > +     "^__mkey.*$",
> > > +     "^__key.*$",
> > > +#endif
> > > +     "^__pfx_.*$"                            // NOP-padding
> > > +};
> > > +
> > > +int suffix_serial;
> > > +
> > > +static inline void verbose_msg(bool verbose, const char *fmt, ...)
> > > +{
> > > +     va_list args;
> > > +
> > > +     va_start(args, fmt);
> > > +     if (verbose)
> > > +             printf(fmt, args);
> > > +
> > > +     va_end(args);
> > > +}
> > > +
> > > +static void create_suffix(const char *name, char *output_suffix)
> > > +{
> > > +     sprintf(output_suffix, "%s__alias__%d", name, suffix_serial++);
> > > +}
> > > +
> > > +static int filter_symbols(char *symbol, const char **ignore_list, int regex_no)
> > > +{
> > > +     regex_t regex;
> > > +     int res, i;
> > > +
> > > +     for (i = 0; i < regex_no; i++) {
> > > +             res = regcomp(&regex, ignore_list[i], REG_EXTENDED);
> > > +             if (res)
> > > +                     return -EREGEX;
> > > +
> > > +             res = regexec(&regex, symbol, 0, NULL, 0);
> > > +             regfree(&regex);
> > > +             switch (res) {
> > > +             case 0:
> > > +                     return FMATCH;
> > > +             case REG_NOMATCH:
> > > +                     break;
> > > +             default:
> > > +                     return -EREGEX;
> > > +             }
> > > +
> > > +     }
> > > +
> > > +     return FNOMATCH;
> > > +}
> > > +
> > > +int main(int argc, char *argv[])
> > > +{
> > > +     char t, sym_name[MAX_NAME_SIZE], new_name[MAX_NAME_SIZE + 15];
> > > +     struct duplicate_item  *duplicate_iterator;
> > > +     struct duplicate_item *duplicate;
> > > +     struct item *head = {NULL};
> > > +     bool need_2_process = true;
> > > +     struct item *last = {NULL};
> > > +     struct item  *current;
> > > +     int verbose_mode = 0;
> > > +     uint64_t address;
> > > +     FILE *fp;
> > > +     int res;
> > > +
> > > +     if (argc < 2 || argc > 3) {
> > > +             printf("Usage: %s <nmfile> [-verbose]\n", argv[0]);
> > > +             return 1;
> > > +     }
> > > +
> > > +     if (argc == 3 && strcmp(argv[2], "-verbose") == 0)
> > > +             verbose_mode = 1;
> > > +
> > > +     verbose_msg(verbose_mode, "Scanning nm data(%s)\n", argv[1]);
> > > +
> > > +     fp = fopen(argv[1], "r");
> > > +     if (!fp) {
> > > +             printf("Can't open input file.\n");
> > > +             return 1;
> > > +     }
> > > +
> > > +     while (fscanf(fp, "%lx %c %99s\n", &address, &t, sym_name) == 3) {
> > > +             if (strstr(sym_name, "__alias__1") != NULL) {
> > > +                     if (verbose_mode && need_2_process)
> > > +                             printf("Already processed\n");
> > > +                     need_2_process = false;
> > > +                     }
> > > +             last = add_item(&last, sym_name, t, address);
> > > +             if (!last) {
> > > +                     printf("Error in allocate memory\n");
> > > +                     free_items(&head);
> > > +                     return 1;
> > > +             }
> > > +
> > > +             if (!head)
> > > +                     head = last;
> > > +     }
> > > +
> > > +     fclose(fp);
> > > +
> > > +     if (need_2_process) {
> > > +             verbose_msg(verbose_mode, "Sorting nm data\n");
> > > +             sort_list_m(&head, BY_NAME);
> > > +             verbose_msg(verbose_mode, "Scanning nm data for duplicates\n");
> > > +             duplicate = find_duplicates(head);
> > > +             if (!duplicate) {
> > > +                     printf("Error in duplicates list\n");
> > > +                     return 1;
> > > +             }
> > > +
> > > +             verbose_msg(verbose_mode, "Applying suffixes\n");
> > > +             build_index(head);
> > > +             duplicate_iterator = duplicate;
> > > +             while (duplicate_iterator) {
> > > +                     res = filter_symbols(duplicate_iterator->original_item->symb_name,
> > > +                                          ignore_regex, sizeof(ignore_regex) /
> > > +                                          sizeof(ignore_regex[0]));
> > > +                     if ((res != FMATCH) &&
> > > +                        SYMB_NEEDS_ALIAS(duplicate_iterator->original_item)) {
> > > +                             if (res < 0)
> > > +                                     return 1;
> > > +
> > > +                             create_suffix(duplicate_iterator->original_item->symb_name,
> > > +                                           new_name);
> > > +                             if (!insert_after(head, duplicate_iterator->original_item->addr,
> > > +                                               new_name, duplicate_iterator->original_item->addr,
> > > +                                               duplicate_iterator->original_item->stype))
> > > +                                     return 1;
> > > +                     }
> > > +
> > > +                     duplicate_iterator = duplicate_iterator->next;
> > > +             }
> > > +
> > > +             sort_list_m(&head, BY_ADDRESS);
> > > +     }
> > > +     current = head;
> > > +     while (current) {
> > > +             printf("%08lx %c %s\n", current->addr, current->stype, current->symb_name);
> > > +             current = current->next;
> > > +     }
> > > +
> > > +     free_items(&head);
> > > +     free_duplicates(&duplicate);
> > > +
> > > +     return 0;
> > > +}
> > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > index a432b171be82..4e3dea3ac2df 100755
> > > --- a/scripts/link-vmlinux.sh
> > > +++ b/scripts/link-vmlinux.sh
> > > @@ -161,7 +161,11 @@ kallsyms()
> > >       fi
> > >
> > >       info KSYMS ${2}
> > > -     scripts/kallsyms ${kallsymopt} ${1} > ${2}
> > > +     if is_enabled CONFIG_KALLSYMS_ALIAS; then
> > > +             ALIAS=".alias"
> > > +             scripts/kas_alias/kas_alias ${1} >${1}${ALIAS}
> > > +             fi
> > > +     scripts/kallsyms ${kallsymopt} ${1}${ALIAS} > ${2}
> > >  }
> > >
> > >  # Perform one step in kallsyms generation, including temporary linking of  
> >  

