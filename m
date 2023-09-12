Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD31E79D36D
	for <lists+live-patching@lfdr.de>; Tue, 12 Sep 2023 16:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjILOSo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Sep 2023 10:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbjILOSm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Sep 2023 10:18:42 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89C10D;
        Tue, 12 Sep 2023 07:18:37 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a8614fe8c4so4245928b6e.1;
        Tue, 12 Sep 2023 07:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694528316; x=1695133116; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CN89uS22Fp8hqoBkQ7h2ESKNsmqtKbE4YnZMd1TJDLU=;
        b=TPYhSXPHVSMEbhY3bGAt1K3FmKQWxmapOKswoQseqHSPw/68+nY4ZIu2utju85s5K7
         4Dh58we7ib4sngjeSCERl78VGMHsjLOjjzyG3JFCiLnQJEX8+OHvgJVkJPnk1mD3EFvn
         grJC6El8QXQNWD3z+CnGPgLrTlAbdwvJJaTefzKNkHYQOhJrJqaGAmvAYrtAvhy6Tp6x
         Fgh7xPOyvAkcNdNJFjAgZ4ZcBu1sXY8viuh6zleK7T0nVdAqhwynwTrpMpfXfKO5L2Z1
         /kJ+LZiKtP5+COnVZkQtG+qestVUuNIkkgdjxV/stILoIkb9OyEcDdcO3O8jj8GM+UYj
         oi6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694528316; x=1695133116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CN89uS22Fp8hqoBkQ7h2ESKNsmqtKbE4YnZMd1TJDLU=;
        b=hJ636szhOk+tjV22c8FQDKv8sdjPYm7RTW9gzU1d7sFquq+dTG0aP2yZ8xpUpKNJAO
         t1F5hF2HQ3k/6jEWV5H/CcETBSfeB+IxR6KACkLujWTE6a0UA+kYFju0twslcerg09If
         4D3xj++OfWcMffjmefp1NTQ2A7fSEtlB/xrP7sQqJqHHK7iwwepEYOA9cWd0WhwMgDyt
         VHFCVvJYkxOZRIH4JHdJ1nPTOkJ+Yi9yB4nnNFd6iNlFtuR6EJ2Bvnl6Hq93sVIyT8up
         oj5AM7epiwIYjpgHfpGqWxD57hI5cfAzVdD5tfChVfx3ELvPeuU866NQRHN82vA7n1Ho
         vOFQ==
X-Gm-Message-State: AOJu0YzCEm/wpHMsrmCQK8HG0bfaI2t8rVc61tTjeA3IHHFXvkuCYbUs
        f5ocOBXcnnpOztWk0QuKiqyyPVkxCJLQO2NFY84=
X-Google-Smtp-Source: AGHT+IFD16cQyNN838F8zhND/vp0BxVYdY2PqoJfAW8hm75M/qZvWohSbWE7ZsUW32ImefUM/fWKp9fy9Rs5LFaRvug=
X-Received: by 2002:a05:6870:1f0d:b0:1d5:e498:35de with SMTP id
 pd13-20020a0568701f0d00b001d5e49835demr3247004oab.26.1694528316223; Tue, 12
 Sep 2023 07:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com> <d385548e-9788-2814-05c9-bb0f275b233f@intel.com>
In-Reply-To: <d385548e-9788-2814-05c9-bb0f275b233f@intel.com>
From:   Alessandro Carminati <alessandro.carminati@gmail.com>
Date:   Tue, 12 Sep 2023 16:18:00 +0200
Message-ID: <CAPp5cGSHdU6z2J=bUYkXMOakFzSWzjeCznTsV=DrTSvWmaqStA@mail.gmail.com>
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Nick Alcock <nick.alcock@oracle.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Eugene Loh <eugene.loh@oracle.com>,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Viktor Malik <vmalik@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello Alexander,

Thank you for your mail.

Il giorno lun 11 set 2023 alle ore 16:26 Alexander Lobakin
<aleksander.lobakin@intel.com> ha scritto:
>
> From: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
> Date: Mon, 28 Aug 2023 08:04:23 +0000
>
> > From: Alessandro Carminati <alessandro.carminati@gmail.com>
> >
> > It is not uncommon for drivers or modules related to similar peripherals
> > to have symbols with the exact same name.
>
> [...]
>
> > Changes from v2:
> > - Alias tags are created by querying DWARF information from the vmlinux.
> > - The filename + line number is normalized and appended to the original name.
> > - The tag begins with '@' to indicate the symbol source.
> > - Not a change, but worth mentioning, since the alias is added to the existing
> >   list, the old duplicated name is preserved, and the livepatch way of dealing
> >   with duplicates is maintained.
> > - Acknowledging the existence of scenarios where inlined functions declared in
> >   header files may result in multiple copies due to compiler behavior, though
> >    it is not actionable as it does not pose an operational issue.
> > - Highlighting a single exception where the same name refers to different
> >   functions: the case of "compat_binfmt_elf.c," which directly includes
> >   "binfmt_elf.c" producing identical function copies in two separate
> >   modules.
>
> Oh, I thought you managed to handle this in v3 since you didn't reply in
> the previous thread...
I want to thank you for this observation because it gives me the chance to
discuss this topic.

It is evident that the corner case in question is inherently challenging
to address using the addr2line approach. Attempting to conceal this
limitation would be counterproductive.

compat_binfmt_elf.c includes directly binfmt_elf.c, addr2line can't help
but report all functions and data declared in that file, coming from that
file. compat_binfmt_elf.c is just a bunch of macro definitions that
rename a few symbols and define some items used in macro-defined
compilation in binfmt_elf.c.

Looking at the functions, only two of the functions defined by
compat_binfmt_elf.c are binary different from their counterpart in
binfmt_elf.c.
These differences, while present, are indeed minimal, but this fact not
relevant to this discussion.

My position is that, rather than producing a more complicated pipeline
to handle this corner case, it is better to fix it. Before reading your
message, I was about to send the v4, but now I'd prefer to hear the
others' opinions on this matter before taking any future action.


>
> >
> > sample from new v3
> >
> >  ~ # cat /proc/kallsyms | grep gic_mask_irq
> >  ffffd0b03c04dae4 t gic_mask_irq
> >  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> >  ffffd0b03c050960 t gic_mask_irq
> >  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
>
> BTW, why normalize them? Why not just
>
> gic_mask_irq@drivers/irqchip/...
>
> Aaaaand why line number? Line numbers break reproducible builds and also
> would make it harder to refer to a particular symbol by its path and
> name since we also have to pass its line number which may change once
> you add a debug print there, for example.
> OTOH there can't be 2 symbols with the same name within one file, so
> just path + name would be enough. Or not?

Regarding the use of full file paths and line numbers for symbol decoration,
it indeed provides the highest level of uniqueness for each symbol.
However, I understand your point that this level of detail might be more than
necessary.

This approach was implemented in response to a specific request expressed in
the live-patching list, and I wanted to ensure we met those requirements.
I am open to revisiting this aspect, and I am willing to accommodate changes
based on feedback.

If you believe that simplifying the format to just path + name would be more
practical, or if you think that eliminating line numbers is a better choice
to avoid potential issues while debugging builds, I'm open to considering
these adjustments.
Additionally, I've interpreted and implemented Francis's suggestion as making
the separator a configurable option, but maybe a proper format string here,
would be more appropriate.


>
> (sorry if some of this was already discussed previously)
>
> [...]
>
> Thanks,
> Olek

Thank you,
Alessandro
