Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9862660515
	for <lists+live-patching@lfdr.de>; Fri,  6 Jan 2023 17:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjAFQvj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Jan 2023 11:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjAFQvi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Jan 2023 11:51:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AB46267
        for <live-patching@vger.kernel.org>; Fri,  6 Jan 2023 08:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72B961E9E
        for <live-patching@vger.kernel.org>; Fri,  6 Jan 2023 16:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1D5C43392
        for <live-patching@vger.kernel.org>; Fri,  6 Jan 2023 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673023897;
        bh=43iJ2xoM4CeZBExZFm/W/8lNx3C544Od7RMfpauxsio=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ce+3Q+5woawAQJ71T1m8wE22QGrkN/ZI//4/d8bfU+1czErYJboBLnhXh3M9x66/j
         k3MBMt0jNc6juZxZ5R6xrhdh4orKm9QVMrBHdd2oL4tTk+EWrRGFSGE/xkzepqlxcI
         JoDW8XLS7oiNnuxLxonRJiAj/Z8BpMFsYXDaGhVgVHcXyjCSpn+zVV3cxEqblqa9Yf
         VWY428E6GP6xrC5sq5T9LjccCL9WMrInWR5nfWfemGp33xIBwt4LvO9dCJAF5iHRCo
         7icEKs0kZ08Td2UEGlF42MvPXxHSfqvTRJJ1es6E1I5iA3KOgKfI8Bhqa1B+ajgTGn
         /eJTrsMwig08Q==
Received: by mail-lf1-f43.google.com with SMTP id g13so2747108lfv.7
        for <live-patching@vger.kernel.org>; Fri, 06 Jan 2023 08:51:37 -0800 (PST)
X-Gm-Message-State: AFqh2koEA+e1Y127eXfYHIC8U9XaXNaD8bXy5/iNPKnf9hmo9FgFiVQw
        jJ3C5nZdHohsPahO2LrKcqYbAgDf8zXuFVZDDyk=
X-Google-Smtp-Source: AMrXdXuSfG1NI24ZfB7XRPzIEhhNLgkQpWndm2Qek4UMbhgWloiZ389OQTfheNE4oigPB/BDsH1xLSBFevxRPTEQRn4=
X-Received: by 2002:a05:6512:36c1:b0:4cb:1d3e:685b with SMTP id
 e1-20020a05651236c100b004cb1d3e685bmr1455843lfs.126.1673023895137; Fri, 06
 Jan 2023 08:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
 <Y7YH7SwveCyNPxWC@redhat.com> <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
 <bf670f87-e2a1-ff42-a88f-70eab78b4cd1@redhat.com> <alpine.LSU.2.21.2301061352050.6386@pobox.suse.cz>
 <Y7hLvpHqgY0oJ4GY@alley>
In-Reply-To: <Y7hLvpHqgY0oJ4GY@alley>
From:   Song Liu <song@kernel.org>
Date:   Fri, 6 Jan 2023 08:51:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4xjzcoKorKbOt_PgAF5YtJhJ0ipa=jeBuJGHHgFDQ6jA@mail.gmail.com>
Message-ID: <CAPhsuW4xjzcoKorKbOt_PgAF5YtJhJ0ipa=jeBuJGHHgFDQ6jA@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 6, 2023 at 8:26 AM Petr Mladek <pmladek@suse.com> wrote:
>
[...]
> > > >
> > > > PS: While we discuss a solution for ppc64, how about we ship the
> > > > fix for other archs first? I think there are only a few small things to
> > > > be addressed.
> > > >
> > >
> > > Yeah, the x86_64 version looks a lot simpler and closer to being done.
> > > Though I believe that Petr would prefer a complete solution, but I'll
> > > let him speak to that.
> >
> > I cannot speak for Petr, but I think it might be easier to split it given
> > the situation. Then we can involve arch maintainers for ppc64le because
> > they might have a preference with respect to a, b, c options above.
> >
> > Petr, what do you think?
>
> I am fine with solving each architecture in a separate patch or
> patchset. It would make it easier, especially, for arch maintainers.

I will send v8 w/o ppc changes after addressing feedback for generic
and x86 code.

Thanks,
Song
