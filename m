Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80048989E4
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2019 05:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfHVDgg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Aug 2019 23:36:36 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:16891 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHVDgg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Aug 2019 23:36:36 -0400
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x7M3aUer010801;
        Thu, 22 Aug 2019 12:36:31 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x7M3aUer010801
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1566444991;
        bh=R9DdSYdCLpkt/LbQI9zbQtcp6/zLnu2cPiFV1+CyfHo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eUEkk9eWXjdoHatpVYwRKckiQipct8CNYZ1yNMX6zz/9a0vjuv5L2H/HYs7E93wIQ
         Ye0JffRsJlJ03ayqyRx26a+RPd/Eb2Rg3D3R+tq7ICO2sF9RzuzRNC/+S4V4N6RhbN
         o5gzZ4Q5WkP6o2fBnZ6rTTVnM2jSFLXMIoOVG3fdIKKBvRN8KjDRsVYJyIuV6FRW6f
         UjPEtmBF0lRLM2klZ0M8yBpEplIwhCeJ1jACbKuw1GCgHrLcKdTBGDbJeDE2IVpD7F
         y11AcLO+99qrOJj8oKWFrSU7Aj7mdhMnE/7G142WmmPiGNmr6C2qqj11DdnVQjzviE
         KYEDrvQqW/BUg==
X-Nifty-SrcIP: [209.85.222.52]
Received: by mail-ua1-f52.google.com with SMTP id g11so1541686uak.0;
        Wed, 21 Aug 2019 20:36:31 -0700 (PDT)
X-Gm-Message-State: APjAAAWT43xTfUBYVGww77u79OvQjWbqR1WvjfMv8btve7dg3hX7c3uO
        tAJHIDr0VM13hYDqD06H5ckq2rVLbxIO9RhE2AU=
X-Google-Smtp-Source: APXvYqyP82w0LcNr90K+YIvYDLaC1gE8BN3JtOVy4zweoBYyINB1DSz23Tf3bwhMHYIOMB6f4JWmuGj3PmaxlGb6mu0=
X-Received: by 2002:ab0:70d9:: with SMTP id r25mr3941384ual.109.1566444990083;
 Wed, 21 Aug 2019 20:36:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com> <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
 <20190812155626.GA19845@redhat.com> <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz> <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
 <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
 <alpine.LSU.2.21.1908190928520.31051@pobox.suse.cz> <42254ffc-6422-19e1-62a2-6abc23fd089a@redhat.com>
In-Reply-To: <42254ffc-6422-19e1-62a2-6abc23fd089a@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 22 Aug 2019 12:35:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS=yCP=me5_qc_yxjeQPvRtbHwp3CAe8-w6KE6P0+VS_w@mail.gmail.com>
Message-ID: <CAK7LNAS=yCP=me5_qc_yxjeQPvRtbHwp3CAe8-w6KE6P0+VS_w@mail.gmail.com>
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

Hi Joe,

On Tue, Aug 20, 2019 at 1:02 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 8/19/19 3:31 AM, Miroslav Benes wrote:
> > On Mon, 19 Aug 2019, Masahiro Yamada wrote:
> >
> >>
> >> I can review this series from the build system point of view,
> >> but I am not familiar enough with live-patching itself.
> >>
> >> Some possibilities:
> >>
> >> [1] Merge this series thru the live-patch tree after the
> >>      kbuild base patches land.
> >>      This requires one extra development cycle (targeting for 5.5-rc1)
> >>      but I think this is the official way if you do not rush into it.
> >
> > I'd prefer this option. There is no real rush and I think we can wait one
> > extra development cycle.
>
> Agreed.  I'm in no hurry and was only curious about the kbuild changes
> that this patchset is now dependent on -- how to note them for other
> reviewers or anyone wishing to test.
>
> > Joe, could you submit one more revision with all the recent changes (once
> > kbuild improvements settle down), please? We should take a look at the
> > whole thing one more time? What do you think?
> >
>
> Definitely, yes.  I occasionally force a push to:
> https://github.com/joe-lawrence/linux/tree/klp-convert-v5-expanded
>
> as I've been updating and collecting feedback from v4.  Once updates
> settle, I'll send out a new v5 set.
>
> -- Joe

When you send v5, please squash the following clean-up too:



diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 89eaef0d3efc..9e77246d84e3 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -47,7 +47,7 @@ targets += $(modules) $(modules:.ko=.mod.o)
 # Live Patch
 # ---------------------------------------------------------------------------

-$(modules-klp:.ko=.tmp.ko): %.tmp.ko: %.o %.mod.o Symbols.list FORCE
+%.tmp.ko: %.o %.mod.o Symbols.list FORCE
        +$(call if_changed,ld_ko_o)

 quiet_cmd_klp_convert = KLP     $@




Thanks.


-- 
Best Regards
Masahiro Yamada
