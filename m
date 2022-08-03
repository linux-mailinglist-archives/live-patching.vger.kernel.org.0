Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0AE58870D
	for <lists+live-patching@lfdr.de>; Wed,  3 Aug 2022 07:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiHCFyD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Aug 2022 01:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiHCFyC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Aug 2022 01:54:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D94FE5
        for <live-patching@vger.kernel.org>; Tue,  2 Aug 2022 22:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1B3B82197
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 05:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6BBC433D6
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 05:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659506038;
        bh=11nen2Ay9i1acfPvKbdOBk3l2ZwYPrjo4Ed2EBc6ufE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LN73kyt2CWn78EHkQ1fOSj6AuuvP0XjL4NL3uu5vxqP1RavhoMnnP75uxOqJPseHa
         sNdyu8Y9k1J9zatEIY6G6dwzyS6RK9j/+seOgs1iPlccG8ocxZEglEL6fl9LwdG8jb
         8S18KcRjfUfuIE1EXQIQPF4mgb8do91TJ+nniM5cEQ4aVVl0IfdvgY/m6yRjvbWEjN
         isroPVcCaM6lh4lhOIaB2y7yc1ClC1s4f81fDq/QCWQkjw0wlnkH8+A9IAQhxV7zFg
         Nrm8S9oH3wswCTgq1sxIs4I6Bs1n4fR2THQRGho7vSIgw0y9toQlppqbxAINGU9yCM
         PhqM5DADVFLdA==
Received: by mail-yb1-f181.google.com with SMTP id 187so794420ybz.9
        for <live-patching@vger.kernel.org>; Tue, 02 Aug 2022 22:53:58 -0700 (PDT)
X-Gm-Message-State: ACgBeo1/L2vZiMZMhg8SEgcH3Mu1Wvh00nIEEeezaXsxdl6OTQ73yNrU
        RBPtCR4tHcTRTyMvVEwCUMGjVdZ0yFt11PfT1Js=
X-Google-Smtp-Source: AA6agR5YUqWm6xLgDy8gDHKVeTtJTPSd+WgNHSjVS6L1oOrHxdZcmNonXCwlpV9paeuy36fSw3oSW88a/AdAdmbSWAk=
X-Received: by 2002:a25:55c5:0:b0:670:96cb:a295 with SMTP id
 j188-20020a2555c5000000b0067096cba295mr17527142ybb.449.1659506037456; Tue, 02
 Aug 2022 22:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220725220231.3273447-1-song@kernel.org> <YuKS1Bg8hlvEUSY2@alley>
In-Reply-To: <YuKS1Bg8hlvEUSY2@alley>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 Aug 2022 22:53:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Fm7q3CFrSK7H3hpd-mSyC8NLoD5M7HQDuFerdSRfQ1w@mail.gmail.com>
Message-ID: <CAPhsuW7Fm7q3CFrSK7H3hpd-mSyC8NLoD5M7HQDuFerdSRfQ1w@mail.gmail.com>
Subject: Re: [PATCH RFC] livepatch: add sysfs entry "patched" for each klp_object
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 28, 2022 at 6:44 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2022-07-25 15:02:31, Song Liu wrote:
> > I was debugging an issue that a livepatch appears to be attached, but
> > actually not. It turns out that there is a mismatch in module name
> > (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
>
> This might be a quite common mistake. IMHO, the module name stored in
> the module metadata always uses underscore '_' instead of dash '-'.
>
> If I get it correctly, it is done by the following command in
> scripts/Makefile.lib:
>
> --- cut ---
> # These flags are needed for modversions and compiling, so we define them here
> # $(modname_flags) defines KBUILD_MODNAME as the name of the module it will
> # end up in (or would, if it gets compiled in)
> name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
> --- cut ---

Yeah, I can confirm the "name-fix" makes the change.

Hi Josh and Joe,

I hit this issue while building live patch for OOT module with kpatch-build.
Do you have some suggestions on how to fix it? My current workaround is
to manually edit the .ko file...

Thanks,
Song
