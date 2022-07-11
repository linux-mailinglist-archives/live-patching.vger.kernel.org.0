Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4C56D42D
	for <lists+live-patching@lfdr.de>; Mon, 11 Jul 2022 07:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiGKFB3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Jul 2022 01:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKFB3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Jul 2022 01:01:29 -0400
Received: from conssluserg-06.nifty.com (conssluserg-06.nifty.com [210.131.2.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209EF165B6;
        Sun, 10 Jul 2022 22:01:25 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 26B50xvq015869;
        Mon, 11 Jul 2022 14:01:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 26B50xvq015869
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1657515661;
        bh=EKEIw//MkWwSm110L6yM+HbaidJf4e6QR3s/gLkYuws=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FHwRR6o9QO1bWzz3LSkau7t1U4qN2hQ0pO+rip77ohq48keyE3fzXXfV/1ToBxp7U
         jRPbYSfn16gEftz9lxnLVFH5TK347+5mHjTiv3KYd9vsed6cuf+/FPSJSplxiQaIBf
         eK5LieBzSYIGk/xxBvlvkAnz01BUvhFMJ1OrDvYikLevQfsU93kR4tD+kAoRVl7oAY
         zWxSz5AoRlXpeFbPAdXs001ajInow1JbnqPYdI8jNDK2w2pqpTk/h3+6RNPFbCRfs+
         ARayLBI9b4nzihgcOn3vIyVAZ+WcOqLfRTKJIWO+1IMfH5htera9ueb52n/7aewcRW
         9e8rrOuTJYeEQ==
X-Nifty-SrcIP: [209.85.221.42]
Received: by mail-wr1-f42.google.com with SMTP id o4so5486045wrh.3;
        Sun, 10 Jul 2022 22:01:00 -0700 (PDT)
X-Gm-Message-State: AJIora8AEJCN4rw2iclhBQi4zyMBBIgm2D4f2I3Jh5/Q006K5+nCPDzG
        xrzFhK2/3MN0TMlFNZYgx46r6JkpOXfQ6WaSWgA=
X-Google-Smtp-Source: AGRyM1vPXBdb+hZcEey3HfGRmOvTyQVt5iLIC5uTbSh/h95CIHUEcAEPGA0DahYShqPOISDyYEgkYdL7XR8hxi0/y5I=
X-Received: by 2002:adf:e104:0:b0:21b:9938:b07a with SMTP id
 t4-20020adfe104000000b0021b9938b07amr15422715wrz.682.1657515659239; Sun, 10
 Jul 2022 22:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <1de95f0bf3abc9f6f9ebd96814fab2dae042f410.1657169009.git.baruch@tkos.co.il>
In-Reply-To: <1de95f0bf3abc9f6f9ebd96814fab2dae042f410.1657169009.git.baruch@tkos.co.il>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 11 Jul 2022 14:00:10 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQhLFAG31k5Dy+z8kvm62cZQYziJ8tEVAuVsX-D8PRXng@mail.gmail.com>
Message-ID: <CAK7LNAQhLFAG31k5Dy+z8kvm62cZQYziJ8tEVAuVsX-D8PRXng@mail.gmail.com>
Subject: Re: [PATCH] init/Kconfig: update KALLSYMS_ALL help text
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 7, 2022 at 1:45 PM Baruch Siach <baruch@tkos.co.il> wrote:
>
> CONFIG_KALLSYMS_ALL is required for kernel live patching which is a
> common use case that is enabled in some major distros. Update the
> Kconfig help text to reflect that.
>
> While at it, s/e.g./i.e./ to match the text intention.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---


Applied to linux-kbuild.
Thanks.


>  init/Kconfig | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index c7900e8975f1..20ef72dd6f44 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1722,16 +1722,17 @@ config KALLSYMS_ALL
>         help
>           Normally kallsyms only contains the symbols of functions for nicer
>           OOPS messages and backtraces (i.e., symbols from the text and inittext
> -         sections). This is sufficient for most cases. And only in very rare
> -         cases (e.g., when a debugger is used) all symbols are required (e.g.,
> -         names of variables from the data sections, etc).
> +         sections). This is sufficient for most cases. And only if you want to
> +         enable kernel live patching, or other less common use cases (e.g.,
> +         when a debugger is used) all symbols are required (i.e., names of
> +         variables from the data sections, etc).
>
>           This option makes sure that all symbols are loaded into the kernel
>           image (i.e., symbols from all sections) in cost of increased kernel
>           size (depending on the kernel configuration, it may be 300KiB or
>           something like this).
>
> -         Say N unless you really need all symbols.
> +         Say N unless you really need all symbols, or kernel live patching.
>
>  config KALLSYMS_ABSOLUTE_PERCPU
>         bool
> --
> 2.35.1
>


-- 
Best Regards
Masahiro Yamada
