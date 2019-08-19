Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9082791B9B
	for <lists+live-patching@lfdr.de>; Mon, 19 Aug 2019 05:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfHSDtr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 18 Aug 2019 23:49:47 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:20255 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHSDtq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 18 Aug 2019 23:49:46 -0400
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x7J3ncXR024718;
        Mon, 19 Aug 2019 12:49:39 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x7J3ncXR024718
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1566186579;
        bh=7yhX/6r1Sfr5gey1E0uYRtZ15/zptfZcpaZY5EZ+xEQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ew2sIUSVfUuXiqxOpx7MUK/gXSdkUsEZnUKjVbuuK95jNI3n58Z/sjO1CzaWIyloI
         3x9Li3X8rTlZZoP7lgPWBZ8abyvMXSxoIErmk5/Fh93UpA1yI1QCUx67aiaRrATUHB
         oTTCyMivWSb1Mo0Dt4f7/8RDqTIVTYHYzMXTvyA6Wlv2kLo9nhvha3DG1jWJekJIMa
         LAF5Rvbhd7jzDDhmFOingNTceHaOR4icI4rJHgNMH9z5pb+1+1lllYn3HboE7Hv5Y5
         CAqxe5KTkyZBLI9Vl0Qeyc2IbSJVvgvMzcHYdHjl3B0HkuRuq1A0hQysIbHNb/CEHK
         HE1TcslcM806g==
X-Nifty-SrcIP: [209.85.222.47]
Received: by mail-ua1-f47.google.com with SMTP id y7so161928uae.10;
        Sun, 18 Aug 2019 20:49:39 -0700 (PDT)
X-Gm-Message-State: APjAAAXZFFEbAUjxJGd6Ke8N9uYoNSJwQE9RjDjuoJMOvKUn+mDvq4zz
        W0kNPtDubRYpgDjXJA9yuw6FjBG4MQ/yBg6ylUA=
X-Google-Smtp-Source: APXvYqzFRy9QePNXY4Wm+23Bncf6RbOT879TVJiBthqzHVOAk0tzLxI/iQyC6HXjtvls3fxTCLPWU8l+BtC/63bsbvc=
X-Received: by 2002:ab0:32d8:: with SMTP id f24mr6026375uao.121.1566186578219;
 Sun, 18 Aug 2019 20:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com> <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
 <20190812155626.GA19845@redhat.com> <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz> <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
In-Reply-To: <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 19 Aug 2019 12:49:02 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
Message-ID: <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 16, 2019 at 9:43 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 8/16/19 4:19 AM, Miroslav Benes wrote:
> > Hi,
> >
> >> I cleaned up the build system, and pushed it based on my
> >> kbuild tree.
> >>
> >> Please see:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
> >> klp-cleanup
> >
> > This indeed looks much simpler and cleaner (as far as I can judge with my
> > limited kbuild knowledge). We just need to remove MODULE_INFO(livepatch,
> > "Y") from lib/livepatch/test_klp_convert_mod_a.c to make it compile and
> > work (test_klp_convert_mod_a is not a livepatch module, it is just a dummy
> > module which is then livepatched by lib/livepatch/test_klp_convert1.c).
> >
>
> Yeah, Masahiro this is great, thanks for reworking this!
>
> I did tweak one module like Miroslav mentioned and I think a few of the
> newly generated files need to be cleaned up as part of "make clean", but
> all said, this is a nice improvement.
>
> Are you targeting the next merge window for your kbuild branch?  (This
> appears to be what the klp-cleanup branch was based on.)


I can review this series from the build system point of view,
but I am not familiar enough with live-patching itself.

Some possibilities:

[1] Merge this series thru the live-patch tree after the
    kbuild base patches land.
    This requires one extra development cycle (targeting for 5.5-rc1)
    but I think this is the official way if you do not rush into it.

[2] Create an immutable branch in kbuild tree, and the live-patch
    tree will use it as the basis for queuing this series.
    We will have to coordinate the pull request order, but
    we can merge this feature for 5.4-rc1

[3] Apply this series to my kbuild tree, with proper Acked-by
    from the livepatch maintainers.
    I am a little bit uncomfortable with applying patches I
    do not understand, though...


-- 
Best Regards
Masahiro Yamada
