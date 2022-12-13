Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452C264BD55
	for <lists+live-patching@lfdr.de>; Tue, 13 Dec 2022 20:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbiLMTbs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Dec 2022 14:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiLMTbr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Dec 2022 14:31:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102BD24085;
        Tue, 13 Dec 2022 11:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B204AB815BA;
        Tue, 13 Dec 2022 19:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56862C43392;
        Tue, 13 Dec 2022 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670959903;
        bh=MIb0vB7MRAZr9GxU2bjkcrUiXnT7auWLqHlL2N0BTp4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ruIiTNcCq1XV+RLd13TjcNnOMOy7/PI2eauysDoZR9onsyoky3dKj+fgfezxcTmkb
         iDI/x9tAzqLSMzbyzDXEHRR/KW8IMXkjm2s2hGFUz/8Bbg/u51G83YfptfVVVBVd0K
         uidK7eur+qRwQpOE88L2suob2AeXlLTJFXKswIgexDCCm9OLi6WeFVYXYpTjij2N15
         tIsDV7xVIP5G2ZByUQlSySgwjgSwNSBsQ07D1eXqJUzyHQhTW3sB1VQ1Ef5gPJT4IB
         zaGhDE5RCTYnLKbJHj2NYGI3w7o/C7Vt2naWCDlVfbTcr3bQJxhSpOba0aMU0q/GiY
         abzGmXKCorxxA==
Received: by mail-lf1-f51.google.com with SMTP id 1so6666122lfz.4;
        Tue, 13 Dec 2022 11:31:43 -0800 (PST)
X-Gm-Message-State: ANoB5pn0r5H1eqWlGPWtNkFoOB1acVjL1kvYGhrwEw38hPauNA9NnP4j
        /HQiJaToCqM4DqRIUv29Yerj2uSWahcztdLsgsA=
X-Google-Smtp-Source: AA0mqf4CXogzuZ3skCV0VYovX4ADm0Z9qdamjOFIrkEGw9zfpHbMeoBbxOXTlZturUa7NoZ8KBPTCT67r6Pqw/nZnO0=
X-Received: by 2002:a05:6512:2c87:b0:4a2:4282:89c7 with SMTP id
 dw7-20020a0565122c8700b004a2428289c7mr27966486lfb.437.1670959901273; Tue, 13
 Dec 2022 11:31:41 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com> <Y5Me5dTGv+GznvtO@alley>
In-Reply-To: <Y5Me5dTGv+GznvtO@alley>
From:   Song Liu <song@kernel.org>
Date:   Tue, 13 Dec 2022 11:31:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5eVyb10VM6WsHS_Y4uwDK3pS_9uuL-cKdOdMo+1p-peA@mail.gmail.com>
Message-ID: <CAPhsuW5eVyb10VM6WsHS_Y4uwDK3pS_9uuL-cKdOdMo+1p-peA@mail.gmail.com>
Subject: Re: powerpc-part: was: Re: [PATCH v6] livepatch: Clear relocation
 targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 9, 2022 at 3:41 AM Petr Mladek <pmladek@suse.com> wrote:
>
> Hi,
>
> this reply is only about the powerpc-specific part.
>
> Also adding Kamalesh and Michael into Cc who worked on the related
> commit a443bf6e8a7674b86221f49 ("powerpc/modules: Add REL24 relocation
> support of livepatch symbols").
>
>
> On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > > --- a/arch/powerpc/kernel/module_64.c
> > > > +++ b/arch/powerpc/kernel/module_64.c
>
> I put back the name of the modified file so that it is easier
> to know what changes we are talking about.
>
> [...]
> > > > +#ifdef CONFIG_LIVEPATCH
> > > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > > +                    const char *strtab,
> > > > +                    unsigned int symindex,
> > > > +                    unsigned int relsec,
> > > > +                    struct module *me)
> > > > +{
> > > > +     unsigned int i;
> > > > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > > > +     Elf64_Sym *sym;
> > > > +     unsigned long *location;
> > > > +     const char *symname;
> > > > +     u32 *instruction;
> > > > +
> > > > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > > > +              sechdrs[relsec].sh_info);
> > > > +
> > > > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > > > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > > > +                     + rela[i].r_offset;
> > > > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > > > +                     + ELF64_R_SYM(rela[i].r_info);
> > > > +             symname = me->core_kallsyms.strtab
> > > > +                     + sym->st_name;
>
> The above calculation is quite complex. It seems to be copied from
> apply_relocate_add(). If I maintained this code I would want to avoid
> the duplication. definitely.
>

Back to this one...

If we go with option 2 that clear_relocate_add() only does things
needed to make the next apply_relocate_add() succeed, we are
not likely to have one write_relocate_add(), which is shared by
apply_relocate_add() and clear_relocate_add(). To avoid
duplication, shall we have two helpers to calculate location and
sym? Or maybe one more to calculate symname? I personally
don't like such one liner helper with multiple arguments, such as

static unsigned long *get_location(Elf64_Shdr *sechdrs,
           unsigned int relsec, unsigned int idx)
{
    Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;

    return (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
         + rela[idx].r_offset;
}

Then use it as
     location = get_location(sechdrs, relsec, i);

We also need get_sym(), which is similar to get_location.

We can probably pass in different arguments. But I don't find
any options that I like. I think duplicate some code is better in
this case. However, if you do think these helpers are better,
or have other suggestions, I won't insist further.

Thanks,
Song
