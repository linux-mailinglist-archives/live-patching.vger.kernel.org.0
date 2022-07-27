Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C49581E70
	for <lists+live-patching@lfdr.de>; Wed, 27 Jul 2022 05:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiG0Dzr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jul 2022 23:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiG0DzX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jul 2022 23:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BA83ED56;
        Tue, 26 Jul 2022 20:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D09C617D2;
        Wed, 27 Jul 2022 03:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B626AC433B5;
        Wed, 27 Jul 2022 03:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658894090;
        bh=QS+qP7KbhBDY5zMM/YWZqzh8w15YmbOtuiOmKuYNj8E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jyC4HUEHAByQ77gLS1yXYLUAV5aDxYiBUb9zIQmDDVkRO7UG5S69aH0CrYujOjLz6
         Ahgdc+L4cZ0ZeQwdXNt1KBxyZGiNK7iXJgU1HM6vYQbXxckAIwIrbcwMN4nXKQDbN/
         eC2ydEKSQIdC6oNYxJdBCa2qxJRZBcFy3Se9eybeiBzE7BcsUTETzOvhB4ZVgBMM44
         v7iYdtXeWBtB4poobFFq4Hali4YwFE9TbZ5q/D4j7CLYztvfywVBaXhT0D2+KsTjQH
         CXm/5FLJ/dKbIlwuagJ+7yYm2nAuukH9/rRx2KjB+Lr7Z4R1bcX2xScruB6iKXQ4t1
         F+2IrxhDCvD7A==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-31e47ac84daso162882527b3.0;
        Tue, 26 Jul 2022 20:54:50 -0700 (PDT)
X-Gm-Message-State: AJIora9bLYWUj6kSS74tkBSQyhjY6RlcvqHlW0xNufI5Z5fGwlOY/gmD
        Sg6OwMWdSOPqC+CxNpXee9hOs/1DtFS41YQwNQM=
X-Google-Smtp-Source: AGRyM1sVxrz8xGmq6xEy5Rmi6mEED7hPnN20JZHyh2Rd8bkQ1bhhAi3F5uV+vkmbRikYq+oP5uUF8YkhL9j9X7np0u0=
X-Received: by 2002:a0d:f985:0:b0:31f:5a01:eaf2 with SMTP id
 j127-20020a0df985000000b0031f5a01eaf2mr3257675ywf.447.1658894089690; Tue, 26
 Jul 2022 20:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
In-Reply-To: <20220726233302.zwloxsammnu7clu4@treble>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jul 2022 20:54:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
Message-ID: <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module removal
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Josh reported a bug:
> >
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> >
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> >
> >   On ppc64le, we have a similar issue:
> >
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> >
> > We could also deny the patched modules to be removed. If it proved to be
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> >
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> >
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Song Liu <song@kernel.org>
> >
> > ---
> >
> > Changes from v2:
> > 1. Rewrite x86 changes to match current code style.
> > 2. Remove powerpc changes as there is no test coverage in v3.
> > 3. Only keep 1/3 of v2.
>
> 1) All the copy/paste is ugly and IMO guaranteed to eventually introduce
>    bugs when somebody forgets to update the copy.  Wouldn't it be more
>    robust to reuse the existing apply_relocate_add() code by making it
>    more generic somehow, like with a new 'clear' bool arg which sets
>    'val' to zero?

Agreed. I can give it a try.

>
> 2) We can't only fix x86, powerpc also needs a fix.

I have very little experience with powerpc. Would someone be willing to
help with powerpc part of this?

> 3) A selftest would be a good idea.

I will try this.

Thanks,
Song
