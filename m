Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18B5731E90
	for <lists+live-patching@lfdr.de>; Thu, 15 Jun 2023 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjFOQ6o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Jun 2023 12:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjFOQ6l (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Jun 2023 12:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD68172A
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 09:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0944B60E9A
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 16:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE76C433CA
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686848319;
        bh=0SLC6TnhR5s8PKsOwQ5hJNrNX2IJGKkd8ceajvGVzcI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jV74LGSI/Cik2zyUlHh6EYI5g1+x1wourWCtrmdczC7livoewUxt3OIruAck1G0B1
         eRa43Jq5l5a/9ELuX5N//+ngTXCUDwRFYmojOeso+tuLji7NwUW0B37eKeeNLP1cS9
         B7kjxaxMSMzPV/vewbA0Ma2cZeQtHSVjG65R71XSoRiLzi6HeS7zeXxrTrpT+6Q+uM
         ynRCvS194CN2zV4opa/3a3pYcl8s7C/JJWJiU1Ff0wZZaAkwfcYVhMYw4P+KrHSmB1
         Uysyp454pg+YyKSTdfnbg9kI1IBhBD8zU86agXcqdKbLgkGkjGgR+SjkkSJKeV+8OC
         L/r2Pr4wxX4VA==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2b3500a1f2bso23568731fa.2
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 09:58:39 -0700 (PDT)
X-Gm-Message-State: AC+VfDyRbY3v5ChEszXl78NhQArCLBEZBa/Zj3ZjEbslyqaw4snC5lCZ
        EPMI4WRu3WlzhDcyIW1CrIuIzThmjRZHfb2Djnk=
X-Google-Smtp-Source: ACHHUZ4GT3G4+cCe5rQIAjjNIILS/fTcImonVYGd+Kce3nBqxZ/hM3VMpM+c7BLNgWNzdGEfoYX/B2OZ2exI8KLtebE=
X-Received: by 2002:a2e:99d9:0:b0:2ad:8929:e8f4 with SMTP id
 l25-20020a2e99d9000000b002ad8929e8f4mr7871ljj.43.1686848317348; Thu, 15 Jun
 2023 09:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230602232401.3938285-1-song@kernel.org> <ZILQERU8CJQvn9ix@alley>
 <A4BB490E-42EE-4435-AAE7-2309E384C934@fb.com> <ZIiITvTMOimZ-t1z@alley>
In-Reply-To: <ZIiITvTMOimZ-t1z@alley>
From:   Song Liu <song@kernel.org>
Date:   Thu, 15 Jun 2023 09:58:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5TZPzzFefZ=d1OjVY7yBqge0XBnS9UE2xCWnoLmwj_Og@mail.gmail.com>
Message-ID: <CAPhsuW5TZPzzFefZ=d1OjVY7yBqge0XBnS9UE2xCWnoLmwj_Og@mail.gmail.com>
Subject: Re: [PATCH] livepatch: match symbols exactly in klp_find_object_symbol()
To:     Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <songliubraving@meta.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 13, 2023 at 8:16=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>

[...]

>
> I agree that it is a slow path.
>
> Well, Zhen put a lot of effort into the optimization. I am not sure
> what was the primary motivation. But it would be harsh to remove it
> without asking.
>
> Zhen, what was the motivation for the speedup of kallsyms, please?
>

I took a closer look at the code. kallsyms_on_each_match_symbol()
is only used by livepatch. So indeed it doesn't make sense to drop
all the optimizations by Zhen.

I got another solution for this. Will send it shortly.

Thanks,
Song

>
> > OTOH, this version is simpler and should work just as
> > well.
>
> Sure. But we should double check Zhen's motivation.
>
> Anyway, iterating over all symbols costs a lot. See also
> the commit f5bdb34bf0c9314548f2d ("livepatch: Avoid CPU hogging
> with cond_resched").
