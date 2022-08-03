Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66347588FA4
	for <lists+live-patching@lfdr.de>; Wed,  3 Aug 2022 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiHCPqk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Aug 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHCPqj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Aug 2022 11:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A361FD28
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 08:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFDCFB822F4
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 15:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9785CC433D6
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659541595;
        bh=849jczJm7Ze+BoIAiL1pdhhS7+TRKvhdpq3JjQ/TU3s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QSC06Gd8N7CfsirHwtmpcGqOLLa62Iu2i4vmZXTLgcDxlJeSXtKtD/Ohmq9aW8/f8
         Mg3TxyXlJxG/VgNKKpOy3iNCabI3Cn+Rs/sc6InuNJ7WYYJ89p7OwjoA8V/uFZNXUK
         1KS8odncThv59uw7f+UuKzL2+jwKj1W3FwVq2plKIPmvxdQSPyaYfN9T9mX4+vPD4z
         KZ0JpH4fzVLoaEppXOU7GDG7QXIeirQa1kMO1UBKJCKpDTFgwtp3I+4bT9yL/3n/FP
         F6+HmOlmABMze5ZF9CHHWt6nH/3PbSDvowLTplF0JKtfv85m98Ix6NjFIIw8jwiKP9
         +GE5Rffdmt/rw==
Received: by mail-yb1-f181.google.com with SMTP id y127so28952106yby.8
        for <live-patching@vger.kernel.org>; Wed, 03 Aug 2022 08:46:35 -0700 (PDT)
X-Gm-Message-State: ACgBeo14jCn3hgMO3V25yktkACL3TLoybZcfn7mZ05Q1c5bC9QvxjeAU
        cCPrPSUzSa7cLZBQcqX5di/UDp44x5n0SAxmhyw=
X-Google-Smtp-Source: AA6agR6IKAd4dQ6MEV0em1tuOxMF50yU2Sv4v1RUTPdKu6lHncHY73r8jEez0yiDZ+AuZyYBTmeVZYQChkItOObhUxA=
X-Received: by 2002:a25:55c5:0:b0:670:96cb:a295 with SMTP id
 j188-20020a2555c5000000b0067096cba295mr19363246ybb.449.1659541594608; Wed, 03
 Aug 2022 08:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220725220231.3273447-1-song@kernel.org> <YuKS1Bg8hlvEUSY2@alley>
 <CAPhsuW7Fm7q3CFrSK7H3hpd-mSyC8NLoD5M7HQDuFerdSRfQ1w@mail.gmail.com> <5eb0aebd-21ea-1a88-67de-4257e77b62ef@redhat.com>
In-Reply-To: <5eb0aebd-21ea-1a88-67de-4257e77b62ef@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 3 Aug 2022 08:46:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4OUz-uqU_5_udf6zVGhmOnyA8d2rZve0RYPD_J+sJOwQ@mail.gmail.com>
Message-ID: <CAPhsuW4OUz-uqU_5_udf6zVGhmOnyA8d2rZve0RYPD_J+sJOwQ@mail.gmail.com>
Subject: Re: [PATCH RFC] livepatch: add sysfs entry "patched" for each klp_object
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Joe,

On Wed, Aug 3, 2022 at 5:36 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 8/3/22 1:53 AM, Song Liu wrote:
> > On Thu, Jul 28, 2022 at 6:44 AM Petr Mladek <pmladek@suse.com> wrote:
> >>
> >> On Mon 2022-07-25 15:02:31, Song Liu wrote:
> >>> I was debugging an issue that a livepatch appears to be attached, but
> >>> actually not. It turns out that there is a mismatch in module name
> >>> (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
> >>
> >> This might be a quite common mistake. IMHO, the module name stored in
> >> the module metadata always uses underscore '_' instead of dash '-'.
> >>
> >> If I get it correctly, it is done by the following command in
> >> scripts/Makefile.lib:
> >>
> >> --- cut ---
> >> # These flags are needed for modversions and compiling, so we define them here
> >> # $(modname_flags) defines KBUILD_MODNAME as the name of the module it will
> >> # end up in (or would, if it gets compiled in)
> >> name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
> >> --- cut ---
> >
> > Yeah, I can confirm the "name-fix" makes the change.
> >
> > Hi Josh and Joe,
> >
> > I hit this issue while building live patch for OOT module with kpatch-build.
> > Do you have some suggestions on how to fix it? My current workaround is
> > to manually edit the .ko file...
> >
>
> Hi Song,
>
> Was the original issue that the module's filename included '-' dash
> character(s) while the module name ends up replaced those with '_'
> underscores?

There are multiple mismatches: module name, rela section name(s), and
rela entry name(s).

>
> If that is the case, would you prefer that kpatch-build warn or refuse
> to create .ko filenames that include '-' characters?

I think the best is to have kpatch-build do the same subst for OOT
modules, just as when the module itself is built.

>
> If you have ideas, feel free to post a new issue over on the project's
> github.  No one should have to resort to manually (hex) editing .ko files :)

Yeah, I will create an issue on GitHub.

Thanks,
Song
