Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E5358B12A
	for <lists+live-patching@lfdr.de>; Fri,  5 Aug 2022 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiHEVdf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Aug 2022 17:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbiHEVdd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Aug 2022 17:33:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3086379EE8
        for <live-patching@vger.kernel.org>; Fri,  5 Aug 2022 14:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0859AB8295C
        for <live-patching@vger.kernel.org>; Fri,  5 Aug 2022 21:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3363C433C1
        for <live-patching@vger.kernel.org>; Fri,  5 Aug 2022 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659735207;
        bh=xH0ondPVkwzLU4hNOr+F6LAWsax9M3HTTVitNV5ktwM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K0meNa0osLvH1+m7dhr8qcwCDPLP9KkoqAlP1ME3QKzGSxp4fbiGAyAEYv6gMPcb7
         6wcGzgpK3WRSVYmHb9WMfsurGYZQhcXEmP3gycpTH4S4yqzsioQRRyfm0EzZOozgwj
         agRMRSP9nqMtydT9zhGod+cNJfWkV75VNQ7tfqsBDXacQjWWV9EgKQUEowps05m2yV
         aAC9I6GSBZ1nVSN4B4ROoRbw1MS0jKiaWKYYjSz6LvIWAXau5vOMEIiFGqjvn5ulDJ
         63IAMt9Lg9FBxUN0IsI9ZZaNzBd8wOaOH9nZlWYW6cjuouqKTqo+jpXQ4d9g1Dvr2B
         ttbNgnYc2owZQ==
Received: by mail-yb1-f174.google.com with SMTP id e127so5604811yba.12
        for <live-patching@vger.kernel.org>; Fri, 05 Aug 2022 14:33:27 -0700 (PDT)
X-Gm-Message-State: ACgBeo3AYxZuwlzt4Be17FXJNWNK5KbVQLJn7LIqMsaxd74ARRepxw1T
        s3WiU7+ipwzJDzuag5pFXHIwStIEMUU293SaLJo=
X-Google-Smtp-Source: AA6agR6NbLk2dUuJyqFTEt80qn9M95hxygi0biygYhgg/5U+7OGfFUvgaTIDwx4Brk034zrNw70NhplpHNkmvoAjW1g=
X-Received: by 2002:a25:1406:0:b0:67a:703b:3374 with SMTP id
 6-20020a251406000000b0067a703b3374mr6479626ybu.561.1659735206626; Fri, 05 Aug
 2022 14:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220801212129.2008177-1-song@kernel.org> <Yu2EYG0YjPLjiPk0@redhat.com>
In-Reply-To: <Yu2EYG0YjPLjiPk0@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 5 Aug 2022 14:33:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4s2OiM6-toXqqfewnYmGDTQWjSa5R7vTQ2iq5WpYziOA@mail.gmail.com>
Message-ID: <CAPhsuW4s2OiM6-toXqqfewnYmGDTQWjSa5R7vTQ2iq5WpYziOA@mail.gmail.com>
Subject: Re: [PATCH v4] livepatch: Clear relocation targets on a module removal
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Kernel Team <kernel-team@fb.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 5, 2022 at 1:58 PM Joe Lawrence <joe.lawrence@redhat.com> wrote=
:
>
> On Mon, Aug 01, 2022 at 02:21:29PM -0700, Song Liu wrote:
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Josh reported a bug:
> >
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> >
> >   module: x86/modules: Skipping invalid relocation target, existing val=
ue is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nf=
sd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing =
to load module 'nfsd'
> >
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> >
> >   On ppc64le, we have a similar issue:
> >
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e=
_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nf=
sd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing =
to load module 'nfsd'
> >
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> >
> > We could also deny the patched modules to be removed. If it proved to b=
e
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> >
> > We thus decided to reverse the relocation patching (clear all relocatio=
n
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
> > NOTE: powerpc code has not be tested.
> >
>
> Hi Song,
>
> I just want to provide a quick check in on this patch...
>
> First -- what tree / commit should this be based on?  When I add this
> patch on top of a v5.19 based tree, I see:
>
> arch/powerpc/kernel/module_64.c: In function =E2=80=98clear_relocate_add=
=E2=80=99:
> arch/powerpc/kernel/module_64.c:781:52: error: incompatible type for argu=
ment 1 of =E2=80=98instr_is_relative_link_branch=E2=80=99
>   781 |                 if (!instr_is_relative_link_branch(*instruction))
>       |                                                    ^~~~~~~~~~~~
>       |                                                    |
>       |                                                    u32 {aka unsig=
ned int}
> In file included from arch/powerpc/kernel/module_64.c:20:
> ./arch/powerpc/include/asm/code-patching.h:122:46: note: expected =E2=80=
=98ppc_inst_t=E2=80=99 but argument is of type =E2=80=98u32=E2=80=99 {aka =
=E2=80=98unsigned int=E2=80=99}
>   122 | int instr_is_relative_link_branch(ppc_inst_t instr);
>       |                                   ~~~~~~~~~~~^~~~~
> arch/powerpc/kernel/module_64.c:785:32: error: =E2=80=98PPC_INST_NOP=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98PPC_I=
NST_COPY=E2=80=99?
>   785 |                 *instruction =3D PPC_INST_NOP;
>       |                                ^~~~~~~~~~~~
>       |                                PPC_INST_COPY
> arch/powerpc/kernel/module_64.c:785:32: note: each undeclared identifier =
is reported only once for each function it appears in
> make[2]: *** [scripts/Makefile.build:249: arch/powerpc/kernel/module_64.o=
] Error 1
> make[1]: *** [scripts/Makefile.build:466: arch/powerpc/kernel] Error 2
> make: *** [Makefile:1849: arch/powerpc] Error 2
>

I am sorry that I didn't build the PPC code. (I did fix some code, but
I guess that's
not enough. ) I was hoping kernel test bot to run build tests on the
patch, but I
guess the bot is not following live-patching mail list?

The code was based Linus' tree, probably 5.19-rc7.

>
> Second, I rebased the klp-convert-tree on top of v5.19 here:
> https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v7-deve=
l
>
> and I can confirm that at least the x86_64 livepatching selftests
> (including the klp-relocation tests added by this tree) do pass.  I
> haven't had a chance to try writing new tests to verify this specific
> patch, but I'll take a look next week.

I also got the selftests pass for another patch. Checking dmesg is
a little tricky, btw. I will take a look at klp-convert.

Thanks,
Song
