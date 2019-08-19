Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E270791DDB
	for <lists+live-patching@lfdr.de>; Mon, 19 Aug 2019 09:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSHbv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Aug 2019 03:31:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:55860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726390AbfHSHbv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Aug 2019 03:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 483C0AF7C;
        Mon, 19 Aug 2019 07:31:50 +0000 (UTC)
Date:   Mon, 19 Aug 2019 09:31:43 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch
 modules
In-Reply-To: <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.1908190928520.31051@pobox.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <20190509143859.9050-7-joe.lawrence@redhat.com> <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com> <20190812155626.GA19845@redhat.com> <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz> <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com> <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 19 Aug 2019, Masahiro Yamada wrote:

> On Fri, Aug 16, 2019 at 9:43 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> > On 8/16/19 4:19 AM, Miroslav Benes wrote:
> > > Hi,
> > >
> > >> I cleaned up the build system, and pushed it based on my
> > >> kbuild tree.
> > >>
> > >> Please see:
> > >>
> > >> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
> > >> klp-cleanup
> > >
> > > This indeed looks much simpler and cleaner (as far as I can judge with my
> > > limited kbuild knowledge). We just need to remove MODULE_INFO(livepatch,
> > > "Y") from lib/livepatch/test_klp_convert_mod_a.c to make it compile and
> > > work (test_klp_convert_mod_a is not a livepatch module, it is just a dummy
> > > module which is then livepatched by lib/livepatch/test_klp_convert1.c).
> > >
> >
> > Yeah, Masahiro this is great, thanks for reworking this!
> >
> > I did tweak one module like Miroslav mentioned and I think a few of the
> > newly generated files need to be cleaned up as part of "make clean", but
> > all said, this is a nice improvement.
> >
> > Are you targeting the next merge window for your kbuild branch?  (This
> > appears to be what the klp-cleanup branch was based on.)
> 
> 
> I can review this series from the build system point of view,
> but I am not familiar enough with live-patching itself.
> 
> Some possibilities:
> 
> [1] Merge this series thru the live-patch tree after the
>     kbuild base patches land.
>     This requires one extra development cycle (targeting for 5.5-rc1)
>     but I think this is the official way if you do not rush into it.

I'd prefer this option. There is no real rush and I think we can wait one 
extra development cycle.

Joe, could you submit one more revision with all the recent changes (once 
kbuild improvements settle down), please? We should take a look at the 
whole thing one more time? What do you think?
 
> [2] Create an immutable branch in kbuild tree, and the live-patch
>     tree will use it as the basis for queuing this series.
>     We will have to coordinate the pull request order, but
>     we can merge this feature for 5.4-rc1
> 
> [3] Apply this series to my kbuild tree, with proper Acked-by
>     from the livepatch maintainers.
>     I am a little bit uncomfortable with applying patches I
>     do not understand, though...

Thanks
Miroslav
