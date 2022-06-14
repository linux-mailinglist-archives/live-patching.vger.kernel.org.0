Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40E54BCD9
	for <lists+live-patching@lfdr.de>; Tue, 14 Jun 2022 23:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiFNVeB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jun 2022 17:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiFNVeA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jun 2022 17:34:00 -0400
X-Greylist: delayed 134040 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 14:33:59 PDT
Received: from conssluserg-03.nifty.com (conssluserg-03.nifty.com [210.131.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31582656B;
        Tue, 14 Jun 2022 14:33:59 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 25ELXbSA002614;
        Wed, 15 Jun 2022 06:33:38 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 25ELXbSA002614
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1655242418;
        bh=jMu3IJf/gNsh1yOykgEfXmOTW4pfvsSKna8A1KEVPDk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H8Vj0TEWaZDAyCb57/jCPeJSrt7udqr5gEj9vpZGF0yiUPM5DWETorzCvL6z4TT6r
         dvPEbKwUr1Aqw5yycPgaJetlesEOn5iQscdrqVW3Hb+5Oxmwpfaqp/q5R0WxEeJpi2
         mkb2r1cLq/6dGTbrCXf+EYfUOlBKnTFG8EP9XutPStoqSTK1Hdqss5r9rl1LoypyJH
         Mt1vkvsmiMdgCwxTAIEJzmJMFomsZQxuIAvYpAGHVqfrl6njsQyy05rr746+JeIkgU
         IgIL5R9Bs2GeHQ9jfxLcSxjPjoRWYRVYeTriy/oeLb1zS1i8wO3NuK95GyKZ6/BOEZ
         8ZfbBDzevJtpA==
X-Nifty-SrcIP: [209.85.128.54]
Received: by mail-wm1-f54.google.com with SMTP id a10so5341470wmj.5;
        Tue, 14 Jun 2022 14:33:38 -0700 (PDT)
X-Gm-Message-State: AOAM5330k/mWGq75deKm8FkX/J9GFrIuCBGCA1PH/LaqY3Lot2dj2kDA
        VF0gSZ1VxNtGpQKda81RbItGzJK5A6ghij1XHyU=
X-Google-Smtp-Source: ABdhPJy382JsXm03MT6GFbPL63zd9b3gVqd3oo2ll0beKVq4fIQ7srKKI6FHgfmvJhPvDB9A162ob2fGjKC0YYGqwDs=
X-Received: by 2002:a7b:ce04:0:b0:394:1f46:213 with SMTP id
 m4-20020a7bce04000000b003941f460213mr6175903wmc.157.1655242416515; Tue, 14
 Jun 2022 14:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220613081741.1699713-1-masahiroy@kernel.org> <027dcfc9-be47-5fb5-7ea8-26eb19122095@loongson.cn>
In-Reply-To: <027dcfc9-be47-5fb5-7ea8-26eb19122095@loongson.cn>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 15 Jun 2022 06:32:59 +0900
X-Gmail-Original-Message-ID: <CAK7LNAROs84jWCHxKHuv+TOzUkCJDUgkaFU0nKopGPwNKV+VQg@mail.gmail.com>
Message-ID: <CAK7LNAROs84jWCHxKHuv+TOzUkCJDUgkaFU0nKopGPwNKV+VQg@mail.gmail.com>
Subject: Re: [PATCH] doc: module: update file references
To:     Yanteng Si <siyanteng@loongson.cn>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules <linux-modules@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Alex Shi <alexs@kernel.org>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Maennich <maennich@google.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 14, 2022 at 9:28 PM Yanteng Si <siyanteng@loongson.cn> wrote:
>
> On 2022/6/13 =E4=B8=8B=E5=8D=884:17, Masahiro Yamada wrote:
> > Adjust documents to the file moves made by commit cfc1d277891e ("module=
:
> > Move all into module/").
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Yanteng Si <siyanteng@loongson.cn>
> > ---
> >
> > I did not touch
> >
> >    Documentation/translations/zh_CN/core-api/kernel-api.rst
> diff --git a/Documentation/translations/zh_CN/core-api/kernel-api.rst
> b/Documentation/translations/zh_CN/core-api/kernel-api.rst
> index e45fe80d1cd8..962d31d019d7 100644
> --- a/Documentation/translations/zh_CN/core-api/kernel-api.rst
> +++ b/Documentation/translations/zh_CN/core-api/kernel-api.rst
> @@ -224,7 +224,7 @@ kernel/kmod.c
>   =E6=A8=A1=E5=9D=97=E6=8E=A5=E5=8F=A3=E6=94=AF=E6=8C=81
>   ------------
>
> -=E6=9B=B4=E5=A4=9A=E4=BF=A1=E6=81=AF=E8=AF=B7=E5=8F=82=E8=80=83=E6=96=87=
=E4=BB=B6kernel/module.c=E3=80=82
> +=E6=9B=B4=E5=A4=9A=E4=BF=A1=E6=81=AF=E8=AF=B7=E5=8F=82=E9=98=85kernel/mo=
dule/=E7=9B=AE=E5=BD=95=E4=B8=8B=E7=9A=84=E6=96=87=E4=BB=B6=E3=80=82
>
>   =E7=A1=AC=E4=BB=B6=E6=8E=A5=E5=8F=A3
>   =3D=3D=3D=3D=3D=3D=3D=3D
>
> >
> > because I cannot modify it.Let me help you, it's my pleasure.  :)


Thank you very much!

I will send v2 with the update.



--=20
Best Regards
Masahiro Yamada
