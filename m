Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29BB64887B
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLISal (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 13:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLISai (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 13:30:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B204E1146C;
        Fri,  9 Dec 2022 10:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F099AB828D6;
        Fri,  9 Dec 2022 18:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB9BC433EF;
        Fri,  9 Dec 2022 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670610633;
        bh=n59+rwrV14qaGREnWR8vy2GKFiqV3xaP5tikD4JMYjQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i0Nd3TZzxdRARCVlLiG959yi91ko/FNhKcl26WJMe3+j2st0m25mlZzdpDKISPKP1
         vKxOGos7w7zNI2csDnxj2RpP+yl8E0XKACRzg8/QSo+CUSWu1AnaCMbbzht/W6ho4Y
         VhPKeEKL6dMyBdVJR57Q8FhLjpemuyBdIptPB15x7km6IGbRzDmnov/JkXY9dFcNRE
         /nkJrGi2KBecdIrokIK/OO9ZGLanuIDiN3UF6SMk65cHKqFIuSMQsl/76qWgNdYrxo
         vo7FmAikFkUhiGCXSMMXmagXsl4zxo8mSY2ueAuR0VVYV3n65+fUxQoq3eWApvakDo
         mU5IeUZ3dfBgg==
Received: by mail-ej1-f52.google.com with SMTP id n21so13417696ejb.9;
        Fri, 09 Dec 2022 10:30:33 -0800 (PST)
X-Gm-Message-State: ANoB5pmGFBuqgbkIUygHXjcIOaqS6eQD7Ge5bpBYlbQ2RWYAkyA/B4fm
        bb8GgQsmtI/I6OIDhqrZnnj4SM9YKTSqhSH3oNI=
X-Google-Smtp-Source: AA0mqf5x6dmwVfbgNUqNmm0w5I4bAZI9bfIhhNjdGaYOlBXEX/9mKEVR9x3/9ewIL6ctvmIVx+QC9BoJASzz7I5JPWY=
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id
 i5-20020a170906264500b00781d0c14434mr78541258ejc.756.1670610631921; Fri, 09
 Dec 2022 10:30:31 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz>
From:   Song Liu <song@kernel.org>
Date:   Fri, 9 Dec 2022 10:30:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW53njtTrL=w33QBY5AiSftNxZ=UOQ1_qZ+qsp5VL1vU0g@mail.gmail.com>
Message-ID: <CAPhsuW53njtTrL=w33QBY5AiSftNxZ=UOQ1_qZ+qsp5VL1vU0g@mail.gmail.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module removal
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
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

On Fri, Dec 9, 2022 at 4:55 AM Miroslav Benes <mbenes@suse.cz> wrote:
>
> Hi,
>
> first thank you for taking over and I also appologize for not replying
> much sooner.
>
> On Thu, 1 Sep 2022, Song Liu wrote:
>
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
>
> Petr has commented on the code aspects. I will just add that s390x was not
> dealt with at the time because there was no live patching support for
> s390x back then if I remember correctly and my notes do not lie. The same
> applies to powerpc32. I think that both should be fixed as well with this
> patch. It might also help to clean up the ifdeffery in the patch a bit.

I don't have test environments for s390 and powerpc, so I really don't know
whether I am doing something sane for them.

Would you have time to finish these parts? (Or maybe the whole patch..)

Thanks,
Song
