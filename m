Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1229065F278
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbjAERUS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 12:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbjAERTV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 12:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB693DBF0
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 09:12:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C10E61B7C
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 17:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22AEC433F1
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672938721;
        bh=aDJnF7T3c0uOTm7NZm8qSU61C1/jfCjOUKFHgfjUOOY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uzN3GPACih1unrwkLSFg4LfpcbEiiFVjT5gZVs3QZ++R4l+HA906O2THb6ptPwuOD
         fgFbN6sEPSGeBs8N6W1Hoj+r4sqwaTqobt74yPQhPjb/SwLO8LmxQnW/ckHrDsSpqA
         UpgSNarEnbieMFuEGKt7ptX+ORgxp4bRyUlWInTTndCQUlKBezFAZX2QRWrWcFzDQn
         kt58FcKmHx/4QRp/DW4mV9hL9k7VhouYrHGUs0FM1SgaXilaSLsdC9N92pZhfYVDe7
         +yc2fsknMjAFa1+ROiAIxPnCf/prLBuBroznFOjFDtQOoaRimbDcYMOd5eJf3TeQ4v
         Mp/GLEDSqwM1g==
Received: by mail-lj1-f174.google.com with SMTP id bn6so29385483ljb.13
        for <live-patching@vger.kernel.org>; Thu, 05 Jan 2023 09:12:01 -0800 (PST)
X-Gm-Message-State: AFqh2kpeemiEFqjtWTw/2hz3ValMXJBEkHTeynUthCStGmjBaIBXq354
        kkAqml8LBg8ZgTAxUSxgMmZRsLuNscMVPASXIAY=
X-Google-Smtp-Source: AMrXdXu2lPYWMEFPKMudCKjFs2Zo94MIOB62Y3iyKqcwWRNJgj+EGGrbYTeLmOSlQqNo20gwc87vzfcofNuaYklfY+o=
X-Received: by 2002:a2e:86cb:0:b0:27f:d510:1c19 with SMTP id
 n11-20020a2e86cb000000b0027fd5101c19mr1161714ljj.495.1672938719735; Thu, 05
 Jan 2023 09:11:59 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
 <Y7YH7SwveCyNPxWC@redhat.com> <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
 <bf670f87-e2a1-ff42-a88f-70eab78b4cd1@redhat.com>
In-Reply-To: <bf670f87-e2a1-ff42-a88f-70eab78b4cd1@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 5 Jan 2023 09:11:47 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5NH6y_ywr5LG6PUy4Pai-6_693qNJxXHk_wUfERUgReA@mail.gmail.com>
Message-ID: <CAPhsuW5NH6y_ywr5LG6PUy4Pai-6_693qNJxXHk_wUfERUgReA@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 5, 2023 at 7:05 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 1/5/23 00:59, Song Liu wrote:
> > On Wed, Jan 4, 2023 at 3:12 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >>
> >>
> >> Stepping back, this feature is definitely foot-gun capable.
> >> Kpatch-build would expect that klp-relocations would only ever be needed
> >> in code that will patch the very same module that provides the
> >> relocation destination -- that is, it was never intended to reference
> >> through one of these klp-relocations unless it resolved to a live
> >> module.
> >>
> >> On the other hand, when writing the selftests, verifying against NULL
> >> [1] provided 1) a quick sanity check that something was "cleared" and 2)
> >> protected the machine against said foot-gun.
> >>
> >> [1] https://github.com/joe-lawrence/klp-convert-tree/commit/643acbb8f4c0240030b45b64a542d126370d3e6c
> >
> > I don't quite follow the foot-gun here. What's the failure mode?
> >
>
> Kpatch-build, for better or worse, hides the potential problem.  A
> typical kpatch scenario would be:
>
> 1. A patch modifies module foo's function bar(), which references
> symbols local to module foo
>
> 2. Kpatch-build creates a livepatch .ko with klp-relocations in the
> modified bar() to foo's symbols
>
> 3. When loaded, modified bar() code that references through its
> klp-relocations to module foo will only ever be active when foo is
> loaded, i.e. when the original bar() redirects to the livepatch version.
>
> However, writing source-based livepatches (like the kselftests) offers a
> lot more freedom.  There is no implicit guarantee from (3) that the
> module is loaded.  One could reference klp-relocations from anywhere in
> the livepatch module.
>
> For example, in my test_klp_convert1.c test case, I have a livepatch
> module with a sysfs interface (print_debug_set()) that allows the test
> bash script to force the module to references through its
> klp-relocations (print_static_strings()):
>
> ...
> static void print_string(const char *label, const char *str)
> {
>         if (str)
>                 pr_info("%s: %s\n", label, str);
> }
> ...
> static noinline void print_static_strings(void)
> {
>         print_string("klp_string.12345", klp_string_a);
>         print_string("klp_string.67890", klp_string_b);
> }
>
> /* provide a sysfs handle to invoke debug functions */
> static int print_debug;
> static int print_debug_set(const char *val, const struct kernel_param *kp)
> {
>         print_static_strings();
>
>         return 0;
> }
> static const struct kernel_param_ops print_debug_ops = {
>         .set = print_debug_set,
>         .get = param_get_int,
> };
>
>
> When I first wrote test_klp_convert1.c, I did not have wrappers like
> print_string(), I simply referenced the symbols directly and send them
> to pr_info as "%s" string formatting options.
>
> You can probably see where this is going when I unloaded the module that
> provided klp_string_a, klp_string_b, etc. and invoked the sysfs handle.
> The stale relocation values point to ... somewhere we shouldn't try to
> reference any more.

Thanks for the explanation.

> Perhaps I'm too paranoid about that possibility, but by actually
> clearing the values in the relocations on module removal, one could
> check them and try to guard against dangling pointer (dangling
> relocation?) references.

I personally don't worry too much about this issue. But clearing the
relocations seems to be a good idea.

Thanks,
Song
