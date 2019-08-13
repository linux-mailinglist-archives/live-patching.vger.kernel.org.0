Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7D8AC67
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2019 03:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHMBQh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Aug 2019 21:16:37 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:33910 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMBQh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Aug 2019 21:16:37 -0400
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x7D1GOuZ007521;
        Tue, 13 Aug 2019 10:16:25 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x7D1GOuZ007521
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1565658985;
        bh=x5smtKv6h2v/8yhnlgaNROKfkSxy4oSJJ2BG1gO1UMU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Vw73LRF6GvWcTkIk4YL9p7Mb6B2ipWQdGfpjJZARhYwmrBOfg7f4Zwb8QaZBAM+sS
         DocaYDtxt3u0Oqe7+VfbltV5qtgiq09xFQw1eR03H2dWzBaVouilThMbW+Qb3Loxnu
         LYvbmUw5nKY2i9tHHYmo7ZJIzyjZbmhC1lJXFJoN2X3/h977H1IFdPz5KKTPw0gAcE
         l+XVJTyCnan/GIxeyiUNQrIUqjrahZbG8c/N7S1StGE6NQuW2MKw8H3q4AwEx5JB2W
         R5+Yltnaw60YNIwD8qvlfesHtUzkUmAERkMUTfTMK1nA5jXb8w1LCdDm5V5s/DmIov
         WUp9kVtgm2wug==
X-Nifty-SrcIP: [209.85.217.47]
Received: by mail-vs1-f47.google.com with SMTP id i7so4739238vsp.0;
        Mon, 12 Aug 2019 18:16:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXGH32cVmxuQGHEKsYuZqLqqPCP7v7VpRos7avdHj2ZbIl1yiCa
        W0hd26kO86aMo20hMh84h+BFYpulUpU4t74VnsM=
X-Google-Smtp-Source: APXvYqz0M1H6vtA4f5I9ILfLTT+esNuxyIIfdFn001huHK5PQ6k9uZlOmUoXF2iErLZKRfLW0k/uYpfT0pVky1QDD3I=
X-Received: by 2002:a67:8e0a:: with SMTP id q10mr24146079vsd.215.1565658983739;
 Mon, 12 Aug 2019 18:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-4-joe.lawrence@redhat.com> <CAK7LNAT3qZ8EESs0eEtaezjgjzRa1XqoAAxpKh_sLi_JPJie2A@mail.gmail.com>
 <CAK7LNAToLyKSk9C0hwuMRxDK8yjJtghi_y6fH1p0+wK7N1wKow@mail.gmail.com> <20190809184253.GA31811@redhat.com>
In-Reply-To: <20190809184253.GA31811@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 13 Aug 2019 10:15:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNARHQY_7E2ar47EZJmh=SD_Mf3p51AcKAecVLQip27+3Ug@mail.gmail.com>
Message-ID: <CAK7LNARHQY_7E2ar47EZJmh=SD_Mf3p51AcKAecVLQip27+3Ug@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] livepatch: Add klp-convert tool
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Aug 10, 2019 at 3:42 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:

> > > > diff --git a/scripts/livepatch/Makefile b/scripts/livepatch/Makefile
> > > > new file mode 100644
> > > > index 000000000000..2842ecdba3fd
> > > > --- /dev/null
> > > > +++ b/scripts/livepatch/Makefile
> > > > @@ -0,0 +1,7 @@
> > > > +hostprogs-y                    := klp-convert
> > > > +always                         := $(hostprogs-y)
> > > > +
> > > > +klp-convert-objs               := klp-convert.o elf.o
> > > > +
> > > > +HOST_EXTRACFLAGS               := -g -I$(INSTALL_HDR_PATH)/include -Wall
> > >
> > > This looks strange.
> > >
> > > Theoretically, you cannot include headers in $(INSTALL_HDR_PATH)/include
> > > from host programs.
> > >
> > > headers_install works for the target architecture, not host architecture.
> > > This may cause a strange result when you are cross-compiling the kernel.
> > >
> > > BTW, which header in $(INSTALL_HDR_PATH)/include do you need to include ?
> > >
> > >
> > > Also, -Wall is redundant because it is set by the top-level Makefile.
> >
> >
> > I deleted HOST_EXTRACFLAGS entirely,
> > and I was still able to build klp-convert.
> >
> >
> > What is the purpose of '-g' ?
> > If it is only needed for local debugging,
> > it should be removed from the upstream code, in my opinion.
> >
>
> HOST_EXTRACFLAGS looks like it was present in the patchset from the
> early RFC days and inherited through each revision.
>
> These are the files that the klp-convert code includes, mostly typical C
> usercode headers like stdio.h and a few local headers like elf.h:
>
>   % grep -h '^#include' scripts/livepatch/*.{c,h} | sort -u
>   #include "elf.h"
>   #include <fcntl.h>
>   #include <gelf.h>
>   #include "klp-convert.h"
>   #include "list.h"
>   #include <stdbool.h>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
>   #include <sys/stat.h>
>   #include <sys/types.h>
>   #include <unistd.h>
>
> If HOST_EXTRACFLAGS is really unneeded, we can easily drop it in the
> next patchset version.

Yes, please do so.

Thanks.



-- 
Best Regards
Masahiro Yamada
