Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84D5A5CC0
	for <lists+live-patching@lfdr.de>; Tue, 30 Aug 2022 09:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiH3HSw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Aug 2022 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiH3HSv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Aug 2022 03:18:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D55183079
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 00:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07FE2B8168D
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 07:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FB3C433C1
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 07:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661843927;
        bh=ZBFGQgaHYPR5E/LnxCan0rzWGR/tx31iB/oBDF37r5w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VKpj5KyomHvphXzQdyOkupqgXVZWv0mC1JtCITme06Ck6pfeB36Ay5AlInS0nzWno
         S2+NSdV+Z1H8TWHfonyHV9++k6wUyjPo/E7kUgxpEUZ6anOG39G5bAwfve13548XBW
         hrbo5dLLoBsPBUpl9o1kQYAk376r18/gTk0mtXEJQrEP4ZbsXH7QZsl24Zcc/9ec74
         HTZ43QHL1al8J6NlJ8zDKJUMZWPI7udIvaHGq2SJuxAUSApABPSB3izwrsB9uId42F
         bi2xS0Re/i8AVX3igSt9Pwt6ZD28/IngPoBrspioz4EEIV70IcZ9Y6qSszuAqoHiGV
         3xIDeWGwRoOoQ==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-33dc31f25f9so251458877b3.11
        for <live-patching@vger.kernel.org>; Tue, 30 Aug 2022 00:18:47 -0700 (PDT)
X-Gm-Message-State: ACgBeo2HCUZy6kXjXoqSmKCR7MOkkTowsLFRmMGWuKBC2Y6uKpypBX4+
        9u6oKFY7Wb/X59Sdveae1WIPWOx9JGxLI5eJnF0=
X-Google-Smtp-Source: AA6agR43Xj9cAQDKqkjkHqGY5/hGmEOGkJVBI9rJBWsJXDBR43tSwWP7xLVVlxnbsYdNYY9BlcLPugEPXtIqq+oUae4=
X-Received: by 2002:a25:2357:0:b0:696:56f4:356e with SMTP id
 j84-20020a252357000000b0069656f4356emr9945962ybj.449.1661843926765; Tue, 30
 Aug 2022 00:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220801212129.2008177-1-song@kernel.org> <Yu2EYG0YjPLjiPk0@redhat.com>
 <CAPhsuW4s2OiM6-toXqqfewnYmGDTQWjSa5R7vTQ2iq5WpYziOA@mail.gmail.com>
In-Reply-To: <CAPhsuW4s2OiM6-toXqqfewnYmGDTQWjSa5R7vTQ2iq5WpYziOA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 Aug 2022 00:18:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Qu0O7VKqwhq4L=T4h7uLC=_2tF-y9uvsVACFH2Q105Q@mail.gmail.com>
Message-ID: <CAPhsuW6Qu0O7VKqwhq4L=T4h7uLC=_2tF-y9uvsVACFH2Q105Q@mail.gmail.com>
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 5, 2022 at 2:33 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Aug 5, 2022 at 1:58 PM Joe Lawrence <joe.lawrence@redhat.com> wro=
te:
> >
> > On Mon, Aug 01, 2022 at 02:21:29PM -0700, Song Liu wrote:
> > > From: Miroslav Benes <mbenes@suse.cz>
> > >
> > > Josh reported a bug:
> > >
> > >   When the object to be patched is a module, and that module is
> > >   rmmod'ed and reloaded, it fails to load with:
> > >
> > >   module: x86/modules: Skipping invalid relocation target, existing v=
alue is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module '=
nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusin=
g to load module 'nfsd'
> > >
> > >   The livepatch module has a relocation which references a symbol
> > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > >   tries to replace the old relocation with a new one, it sees that
> > >   the previous one is nonzero and it errors out.
> > >
> > >   On ppc64le, we have a similar issue:
> > >
> > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at=
 e_show+0x60/0x548 [livepatch_nfsd]
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module '=
nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusin=
g to load module 'nfsd'
> > >
> > > He also proposed three different solutions. We could remove the error
> > > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > > ("x86/module: Detect and skip invalid relocations"). However the chec=
k
> > > is useful for detecting corrupted modules.
> > >
> > > We could also deny the patched modules to be removed. If it proved to=
 be
> > > a major drawback for users, we could still implement a different
> > > approach. The solution would also complicate the existing code a lot.
> > >
> > > We thus decided to reverse the relocation patching (clear all relocat=
ion
> > > targets on x86_64). The solution is not
> > > universal and is too much arch-specific, but it may prove to be simpl=
er
> > > in the end.
> > >
> > > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > > Signed-off-by: Song Liu <song@kernel.org>
> > >
> > > ---
> > >
> > > NOTE: powerpc code has not be tested.
> > >
> >
> > Hi Song,
> >
> > I just want to provide a quick check in on this patch...
> >
> > First -- what tree / commit should this be based on?  When I add this
> > patch on top of a v5.19 based tree, I see:
> >
> > arch/powerpc/kernel/module_64.c: In function =E2=80=98clear_relocate_ad=
d=E2=80=99:
> > arch/powerpc/kernel/module_64.c:781:52: error: incompatible type for ar=
gument 1 of =E2=80=98instr_is_relative_link_branch=E2=80=99
> >   781 |                 if (!instr_is_relative_link_branch(*instruction=
))
> >       |                                                    ^~~~~~~~~~~~
> >       |                                                    |
> >       |                                                    u32 {aka uns=
igned int}
> > In file included from arch/powerpc/kernel/module_64.c:20:
> > ./arch/powerpc/include/asm/code-patching.h:122:46: note: expected =E2=
=80=98ppc_inst_t=E2=80=99 but argument is of type =E2=80=98u32=E2=80=99 {ak=
a =E2=80=98unsigned int=E2=80=99}
> >   122 | int instr_is_relative_link_branch(ppc_inst_t instr);
> >       |                                   ~~~~~~~~~~~^~~~~
> > arch/powerpc/kernel/module_64.c:785:32: error: =E2=80=98PPC_INST_NOP=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98PPC_I=
NST_COPY=E2=80=99?
> >   785 |                 *instruction =3D PPC_INST_NOP;
> >       |                                ^~~~~~~~~~~~
> >       |                                PPC_INST_COPY
> > arch/powerpc/kernel/module_64.c:785:32: note: each undeclared identifie=
r is reported only once for each function it appears in
> > make[2]: *** [scripts/Makefile.build:249: arch/powerpc/kernel/module_64=
.o] Error 1
> > make[1]: *** [scripts/Makefile.build:466: arch/powerpc/kernel] Error 2
> > make: *** [Makefile:1849: arch/powerpc] Error 2
> >

The following should make it build on powerpc64

Shall I send it as v5? (I haven't tested powerpc64 other than cross compile=
).

Thanks,
Song

diff --git i/arch/powerpc/kernel/module_64.c w/arch/powerpc/kernel/module_6=
4.c
index 1834dffc6795..6aaf5720070d 100644
--- i/arch/powerpc/kernel/module_64.c
+++ w/arch/powerpc/kernel/module_64.c
@@ -778,11 +778,11 @@ void clear_relocate_add(Elf64_Shdr *sechdrs,
                if (is_mprofile_ftrace_call(symname))
                        continue;

-               if (!instr_is_relative_link_branch(*instruction))
+               if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
                        continue;

                instruction +=3D 1;
-               *instruction =3D PPC_INST_NOP;
+               *instruction =3D PPC_RAW_NOP();
        }

 }

>
> I am sorry that I didn't build the PPC code. (I did fix some code, but
> I guess that's
> not enough. ) I was hoping kernel test bot to run build tests on the
> patch, but I
> guess the bot is not following live-patching mail list?
>
> The code was based Linus' tree, probably 5.19-rc7.
>
> >
> > Second, I rebased the klp-convert-tree on top of v5.19 here:
> > https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v7-de=
vel
> >
> > and I can confirm that at least the x86_64 livepatching selftests
> > (including the klp-relocation tests added by this tree) do pass.  I
> > haven't had a chance to try writing new tests to verify this specific
> > patch, but I'll take a look next week.
>
> I also got the selftests pass for another patch. Checking dmesg is
> a little tricky, btw. I will take a look at klp-convert.
>
> Thanks,
> Song
