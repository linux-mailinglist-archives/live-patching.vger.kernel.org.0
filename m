Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC762FB58
	for <lists+live-patching@lfdr.de>; Fri, 18 Nov 2022 18:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiKRRPD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Nov 2022 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiKRRPC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Nov 2022 12:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BEBBED;
        Fri, 18 Nov 2022 09:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50797B824D4;
        Fri, 18 Nov 2022 17:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19318C4347C;
        Fri, 18 Nov 2022 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668791699;
        bh=aGeNjGPP8dZqmetYNEd9VnRo9dFM5dECRmcaKXKx9eY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aRZ9CdGoQcFqHGqM1EJ8/vLQtWJgf//zBNew9wpzdt1r4Grm7ONnH6wCnLT0Px1qr
         o69zcXpOLzA43jU9bl7mgZS8x+cn1vm+F5PTZGYDAqzHnPTH+yo3Dq7dIjA3ModHiM
         IPgz8DmBwvJ+cnveUFihaE/d9nqyNKWI5ECqCjD18hAmUC8rIisDARhZnd7kC3Ryh9
         pdqmwAsc4zp+TrKMUEFLjS/bYNbEUaZnAOjD79L/lNniEYBufdWhqh3EWIOaaY/X7k
         S/hrZsYvIQ0sRhlU+cGkkJGsR3D/4Y+OJA1gE1094VmFY6vcHZsM64lQH3BdGiqeEK
         GDwnUSKUEMVCw==
Received: by mail-ed1-f47.google.com with SMTP id v17so8015406edc.8;
        Fri, 18 Nov 2022 09:14:59 -0800 (PST)
X-Gm-Message-State: ANoB5pk76h61E9xqSUopAgoFYWmzO9hd//GGITA/dvJxAX8RPv6/0Hlc
        Gy7H14DP/8ydHbLn1X71smDfySceZdEEq/43YDo=
X-Google-Smtp-Source: AA0mqf5vmlW8qp/K/O9wIXdvysgv/PQikRZVOikEvoR7n1HGHbtgOsu76Fyk4A8Fs1YuHDx0tCwF5kll65JjGlipyYU=
X-Received: by 2002:a05:6402:538a:b0:458:fbd9:e3b1 with SMTP id
 ew10-20020a056402538a00b00458fbd9e3b1mr6950969edb.6.1668791697320; Fri, 18
 Nov 2022 09:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
In-Reply-To: <Y3expGRt4cPoZgHL@alley>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Nov 2022 09:14:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4MaiJBTNnwVhqkmxPxBn8e1cn9PPGm9PkgF6YaO0AWKQ@mail.gmail.com>
Message-ID: <CAPhsuW4MaiJBTNnwVhqkmxPxBn8e1cn9PPGm9PkgF6YaO0AWKQ@mail.gmail.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Thu 2022-09-01 10:12:52, Song Liu wrote:
[...]
> >
> >  arch/powerpc/kernel/module_32.c |  10 ++++
> >  arch/powerpc/kernel/module_64.c |  49 +++++++++++++++
> >  arch/s390/kernel/module.c       |   8 +++
> >  arch/x86/kernel/module.c        | 102 +++++++++++++++++++++++---------
> >  include/linux/moduleloader.h    |   7 +++
> >  kernel/livepatch/core.c         |  41 ++++++++++++-
>
> First, thanks a lot for working on this.
>
> I can't check or test the powerpc and s390 code easily.
>
> I am going to comment only x86 and generic code. It looks good
> but it needs some changes to improve maintainability.

Thanks for these comments and suggestions. I will work on them
and send v4.

Song
