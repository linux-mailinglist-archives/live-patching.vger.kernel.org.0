Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE904B1864
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 23:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345067AbiBJWlk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 17:41:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345059AbiBJWlj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 17:41:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D043626D4
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 14:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644532898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D9z1haah+UIcdDYLlT29sLlYpdDn7jZamy9pjb18HtA=;
        b=EqRw9uAUsmm/VrfV8meQc4fRVWGpBE2ifCepRB97FikRA0sy78X7NTkh/7sCiZXltiu9ga
        n6Lo0E5bqeOXZ/Y2yPmrfO6uRLNaRKb1fc2lFIeaZhDq+Oyr3HomTvyiCU0PrIK7Qoe3on
        1btHxcUynUR2l3GUmPlqVlpIBljCEIs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-zuQxA7srM1iC9xMakVMmDQ-1; Thu, 10 Feb 2022 17:41:37 -0500
X-MC-Unique: zuQxA7srM1iC9xMakVMmDQ-1
Received: by mail-lj1-f200.google.com with SMTP id m13-20020a2e97cd000000b0023e09d49ce4so3247051ljj.6
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 14:41:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D9z1haah+UIcdDYLlT29sLlYpdDn7jZamy9pjb18HtA=;
        b=rXM3IzPNuyGy6ixa/zGB/6VvH5PVoRsvd9TdubU0t4u6C407gdvUzT96wA+PjWmp4T
         DvYgld52KqILfeujBoitO+K4b/CidiYCIKMayejqkTPtfKyuxW6gUwfC54EwpnDfUxtm
         iV38RD6tww8eDLOrQtk3jYd5IZJmkOfzC2548EhiK2jpm1oL+8GlRCeoJODA0gOO8Dgs
         2R8z5zR4AVzuHWwtnJ/Mnn3mSBhrNH4ToMh23OC51CoJnsCMcY8pk/gcfufdlrZpk0VZ
         sniYE2dussRaFIpyqjYUhT8NAQ/Nrtmfsh/8MYpOabpMU1MC3QUxbTmaLBogXp53ggDL
         4CGw==
X-Gm-Message-State: AOAM532M5shMkTEgruNZMM6A3+l2VbMNWoYOEgxYHaqM4HkOovJ+iqe6
        0aETo6zshYkE8ipPZRFOoBt3NKEORGo7hG85KuRcnrQnOqzM4ta3y3FFLHcftk93lTMstBLNIz8
        PGZW8FynQ9Q6FEDtJ+aStqRsjZHBeH8SMBeKz0bzI
X-Received: by 2002:a05:6512:33c8:: with SMTP id d8mr6470343lfg.41.1644532896202;
        Thu, 10 Feb 2022 14:41:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjGYPFGigD9D5dsbstwF6UYHTzLHLhy3FVbR0KZZXe7/vG4kYJtCyu+fmRfnrOqKewzMh+QFBD+44qNwh8PAk=
X-Received: by 2002:a05:6512:33c8:: with SMTP id d8mr6470330lfg.41.1644532895928;
 Thu, 10 Feb 2022 14:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20220209170358.3266629-1-atomlin@redhat.com> <20220209170358.3266629-6-atomlin@redhat.com>
 <32b37a9b-8765-ca96-7528-0ef4faa9ae34@csgroup.eu>
In-Reply-To: <32b37a9b-8765-ca96-7528-0ef4faa9ae34@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Thu, 10 Feb 2022 22:41:24 +0000
Message-ID: <CANfR36iKsTd8Ave+gt2PUho0Zpcnc7kYJrXUHEG5_TrbH_+3jw@mail.gmail.com>
Subject: Re: [PATCH v5 05/13] module: Move latched RB-tree support to a
 separate file
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 12:03 +0000, Christophe Leroy wrote:
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 680b31ff57fa..fd6161d78127 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -342,9 +342,9 @@ struct module_layout {
> >   #ifdef CONFIG_MODULES_TREE_LOOKUP
> >   /* Only touch one cacheline for common rbtree-for-core-layout case. */
> >   #define __module_layout_align ____cacheline_aligned
> > -#else
> > +#else /* !CONFIG_MODULES_TREE_LOOKUP */
> >   #define __module_layout_align
> > -#endif
> > +#endif /* CONFIG_MODULES_TREE_LOOKUP */
> Commenting an #else / #endif is only usefull when the block is more than
> one screen or when there are nested #ifdef inside the block.

For me, this is a personal style preference. That being said, fair enough.

> > +#else /* !CONFIG_MODULES_TREE_LOOKUP */
> > +static unsigned long module_addr_min = -1UL, module_addr_max;
>
> This is wrong to put that in a .h.
>

I understand. This was an oversight. I'll move this to kernel/module/main.c
in preparation for your work.

> > +static void mod_tree_insert(struct module *mod) { }
> > +static void mod_tree_remove_init(struct module *mod) { }
> > +static void mod_tree_remove(struct module *mod) { }
> > +static struct module *mod_find(unsigned long addr)
>
> Also keep mod_find() in main.c, or make it a 'static inline'. Otherwise
> it will be duplicated in every file including internal.h

Agreed. This too was an oversight. I'll use the 'inline' keyword here.

> > diff --git a/kernel/module/tree_lookup.c b/kernel/module/tree_lookup.c
> > new file mode 100644
> > index 000000000000..037d6eb2f56f
> > --- /dev/null
> > +++ b/kernel/module/tree_lookup.c
> > @@ -0,0 +1,109 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Modules tree lookup
> > + *
> > + * Copyright (C) 2015 Peter Zijlstra
> > + * Copyright (C) 2015 Rusty Russell
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/rbtree_latch.h>
> > +#include "internal.h"
> > +
> > +/*
> > + * Use a latched RB-tree for __module_address(); this allows us to use
> > + * RCU-sched lookups of the address from any context.
> > + *
> > + * This is conditional on PERF_EVENTS || TRACING because those can really hit
> > + * __module_address() hard by doing a lot of stack unwinding; potentially from
> > + * NMI context.
> > + */
> > +
> > +__always_inline unsigned long __mod_tree_val(struct latch_tree_node *n)
>
> Should be static.
> > +__always_inline unsigned long __mod_tree_size(struct latch_tree_node *n)
>
> Should be static.
> > +__always_inline bool
> > +mod_tree_less(struct latch_tree_node *a, struct latch_tree_node *b)
>
> Should be static.
>
>
> > +__always_inline int
> > +mod_tree_comp(void *key, struct latch_tree_node *n)
>
> Should be static.
>
> > +const struct latch_tree_ops mod_tree_ops = {
> > +    .less = mod_tree_less,
> > +    .comp = mod_tree_comp,
> > +};
>
> Should be static.

Agreed. Only used in kernel/module/tree_lookup.c.


-- 
Aaron Tomlin

