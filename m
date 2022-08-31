Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5955A83FA
	for <lists+live-patching@lfdr.de>; Wed, 31 Aug 2022 19:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiHaRGA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 31 Aug 2022 13:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHaRF7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 31 Aug 2022 13:05:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97CABD142;
        Wed, 31 Aug 2022 10:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A3C5CE21A7;
        Wed, 31 Aug 2022 17:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0B4C433D6;
        Wed, 31 Aug 2022 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661965555;
        bh=HuGW1hSSVAPjEisKjw59q6nkqtevfdLZpMwCppQtTd8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B7vY/F8xyXnKysxxG9PZ8WHr+F4fwQZ7BYS2YHnxZyUwzilk52CI6McWYhD8MYQQ/
         fSc4knwuaMgLSePw8f/P+BsS1G5BEj3UshoJ2ZFpYUaMNgQETv1VAbi76ZkLQoP2Ft
         ZQDlDlTpyuDEk86MWbfJYb7JaAPGqVgTTAbuWn1qRVw62hUckPcKhfqYdvNjUEl5UR
         WCivZP2p/zt+4sFzZMebOWpCM+aRp44MN0vPYT3kobAKvB540dwsMtW0UEmLcuNeBr
         aDW0nrhwDKhir3zAaudZz2LD1XNfNtNdVseRlK1lAx7jW5M96UZ72j6+0ZM4KWhT1m
         qvUyiaUy3vQDQ==
Received: by mail-yb1-f180.google.com with SMTP id e71so5091638ybh.9;
        Wed, 31 Aug 2022 10:05:55 -0700 (PDT)
X-Gm-Message-State: ACgBeo3kt2EUjujvLePfS2T0rG4KDHySu68AKy/FQYYebKjOFz+VFivi
        MZ0IbKyGPR7NskvZkTmLe3hpz9/XrRuPpQBTK7M=
X-Google-Smtp-Source: AA6agR4bobILNbJYZC0H+86bLGzUJiLjvZiUZhLgobPIgSRQ3gUSeJpmA60cFitX3rIuJtSQfNtS0Od9XKLRv4vptuo=
X-Received: by 2002:a25:2357:0:b0:696:56f4:356e with SMTP id
 j84-20020a252357000000b0069656f4356emr15007563ybj.449.1661965554181; Wed, 31
 Aug 2022 10:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220830185313.76402-1-song@kernel.org> <aee99fcf-9352-d2cd-5f67-fb9d4b9a15f4@csgroup.eu>
In-Reply-To: <aee99fcf-9352-d2cd-5f67-fb9d4b9a15f4@csgroup.eu>
From:   Song Liu <song@kernel.org>
Date:   Wed, 31 Aug 2022 10:05:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6CwQoU0GsXj0YhxngFfNMgD1mu6AjwqiZumTyWL84i1g@mail.gmail.com>
Message-ID: <CAPhsuW6CwQoU0GsXj0YhxngFfNMgD1mu6AjwqiZumTyWL84i1g@mail.gmail.com>
Subject: Re: [PATCH v5] livepatch: Clear relocation targets on a module removal
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>
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

On Wed, Aug 31, 2022 at 1:01 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 30/08/2022 =C3=A0 20:53, Song Liu a =C3=A9crit :
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Josh reported a bug:
> >
> >    When the object to be patched is a module, and that module is
> >    rmmod'ed and reloaded, it fails to load with:
> >
> >    module: x86/modules: Skipping invalid relocation target, existing va=
lue is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >    livepatch: failed to initialize patch 'livepatch_nfsd' for module 'n=
fsd' (-8)
> >    livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing=
 to load module 'nfsd'
> >
> >    The livepatch module has a relocation which references a symbol
> >    in the _previous_ loading of nfsd. When apply_relocate_add()
> >    tries to replace the old relocation with a new one, it sees that
> >    the previous one is nonzero and it errors out.
> >
> >    On ppc64le, we have a similar issue:
> >
> >    module_64: livepatch_nfsd: Expected nop after call, got e8410018 at =
e_show+0x60/0x548 [livepatch_nfsd]
> >    livepatch: failed to initialize patch 'livepatch_nfsd' for module 'n=
fsd' (-8)
> >    livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing=
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
> > Changes v4 =3D v5:
> > 1. Fix compile with powerpc.
>
> Not completely it seems.
>
>    CC      kernel/livepatch/core.o
> kernel/livepatch/core.c: In function 'klp_clear_object_relocations':
> kernel/livepatch/core.c:352:50: error: passing argument 1 of
> 'clear_relocate_add' from incompatible pointer type
> [-Werror=3Dincompatible-pointer-types]
>    352 |                 clear_relocate_add(pmod->klp_info->sechdrs,
>        |                                    ~~~~~~~~~~~~~~^~~~~~~~~
>        |                                                  |
>        |                                                  Elf32_Shdr *
> {aka struct elf32_shdr *}
> In file included from kernel/livepatch/core.c:19:
> ./include/linux/moduleloader.h:76:37: note: expected 'Elf64_Shdr *' {aka
> 'struct elf64_shdr *'} but argument is of type 'Elf32_Shdr *' {aka
> 'struct elf32_shdr *'}
>     76 | void clear_relocate_add(Elf64_Shdr *sechdrs,
>        |                         ~~~~~~~~~~~~^~~~~~~
> cc1: some warnings being treated as errors
>
>
> Fixup:
>
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index d22b36b84b4b..958e6da7f475 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -73,7 +73,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
>                        unsigned int relsec,
>                        struct module *mod);
>   #ifdef CONFIG_LIVEPATCH
> -void clear_relocate_add(Elf64_Shdr *sechdrs,
> +void clear_relocate_add(Elf_Shdr *sechdrs,
>                    const char *strtab,
>                    unsigned int symindex,
>                    unsigned int relsec,
>
>
> But then the link fails.
>
>    LD      .tmp_vmlinux.kallsyms1
> powerpc64-linux-ld: kernel/livepatch/core.o: in function
> `klp_cleanup_module_patches_limited':
> core.c:(.text+0xdb4): undefined reference to `clear_relocate_add'

Hmm.. I am not seeing either error. Could you please share your .config fil=
e?

Thanks,
Song
