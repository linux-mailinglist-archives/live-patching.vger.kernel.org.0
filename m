Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4A65CA4E
	for <lists+live-patching@lfdr.de>; Wed,  4 Jan 2023 00:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjACX3b (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Jan 2023 18:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjACX3a (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Jan 2023 18:29:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988342601
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 15:29:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E37756153A
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 23:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43080C433EF
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 23:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672788568;
        bh=nBpUZtpA0gjeZpAzdrgsjVMl+fMTe3nG/8csN9LTuYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tSjz/nI3qExej+eUmIO9RBtL6FaatDn9rdjUmEGEBTO9UhsJD4hQOD7ct5UtJZaWQ
         5WEz1vlON/CC+K0HPnvdlKLMVEp8bL3Q4rh8r0Z2vKBfWf1CdwXx4i9EvOv+hbLhcF
         mu9vJGumruBk95iMETD9f7RKRFYP29r3Lnm0VEWeBzfHQKGs7KMnBm9T5QsXKgR/QT
         4gPC7mBLLwOMpEk2LMRXaGHJoZdN6S9XSShDXWfwRHaAxax6hDRpr13SZb5K1HOytN
         j5ipXSV/NWA+2/8Rgrq4yNSpo8a157Xz+7DCZ1jcweWe5G1BHkTZJdk0KDoPU2ZcXw
         zdMFmUe4hIB7Q==
Received: by mail-lf1-f42.google.com with SMTP id bq39so40146053lfb.0
        for <live-patching@vger.kernel.org>; Tue, 03 Jan 2023 15:29:28 -0800 (PST)
X-Gm-Message-State: AFqh2krihILGuPCL8gN5iLdrSreHuGS+oAaNjrHtsVwJGFTot4Bw9VFO
        qJGWpZCdwnCm6XiTxV2tbMJX5cHwhRJOclHLkDY=
X-Google-Smtp-Source: AMrXdXv+TCwq39Lf9pqV5XHUN4HKKxsUz6JHjU2Mwpfvaq5sftoY09ygSjTQJve6kn3KoFsJER16mHA9qkNstwXfsQ4=
X-Received: by 2002:a19:640f:0:b0:4b6:e71d:94a6 with SMTP id
 y15-20020a19640f000000b004b6e71d94a6mr3259541lfb.476.1672788566189; Tue, 03
 Jan 2023 15:29:26 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <CAPhsuW6tFacM0z3K34eMNZzZmS7UYaa5x8NivrZnySt5sLappQ@mail.gmail.com>
 <23378a2c-aa95-9f6f-6033-f990243cbd7f@redhat.com>
In-Reply-To: <23378a2c-aa95-9f6f-6033-f990243cbd7f@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 3 Jan 2023 15:29:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ntUX8HZmh39YTU0G5ziTkeQ9YpAC_zAb7z1U4qn5=eQ@mail.gmail.com>
Message-ID: <CAPhsuW5ntUX8HZmh39YTU0G5ziTkeQ9YpAC_zAb7z1U4qn5=eQ@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com,
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

On Tue, Jan 3, 2023 at 2:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
[...]

> >>
> >> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> >> Signed-off-by: Song Liu <song@kernel.org>
> >> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> >> Tested-by: Joe Lawrence <joe.lawrence@redhat.com> # x86_64, s390x, ppc64le
>
> Since there is still some work required for ppc64le and possibly s390x,
> let's strip the tested-by tag.  Each version should be re-tested and
> then we can let the maintainer add it on the final version.

Sure. Will remove the tag in later version(s).

[...]

> >> +#ifdef CONFIG_LIVEPATCH
> >> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> >> +                      const char *strtab,
> >> +                      unsigned int symindex,
> >> +                      unsigned int relsec,
> >> +                      struct module *me)
> >> +{
> >> +       unsigned int i;
> >> +       Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> >> +       Elf64_Sym *sym;
> >> +       unsigned long *location;
> >> +       const char *symname;
> >> +       u32 *instruction;
> >> +
> >> +       pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> >> +                sechdrs[relsec].sh_info);
> >> +
> >> +       for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> >> +               location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> >> +                       + rela[i].r_offset;
> >> +               sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> >> +                       + ELF64_R_SYM(rela[i].r_info);
> >> +               symname = me->core_kallsyms.strtab
> >> +                       + sym->st_name;
> >> +
> >> +               if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> >> +                       continue;
>
> Ppc64le will need to handle additional relocation types.
>
> While debugging a related issue on ppc64le regarding
> CONFIG_STRICT_MODULE_RWX [3], these were the extent of the
> klp-relocation types generated by kpatch-build and klp-convert-tree:
>
> - R_PPC64_REL24 to symbols in other .text sections
> - R_PPC64_ADDR64 to symbols thru .TOC
> - R_PPC64_REL64 to static key symbols
>
> I believe R_PPC64_ADDR64 and R_PPC64_REL64 can be simply be reset to 0.
>
> [3] https://github.com/linuxppc/issues/issues/375#issuecomment-1233698835

Hmm.. I don't quite follow why the two are related.. What's the failure like if
we don't handle R_PPC64_ADDR64 and R_PPC64_REL64?

[...]

> >>  #else /*X86_64*/
> >> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> >> +static int __write_relocate_add(Elf64_Shdr *sechdrs,
> >>                    const char *strtab,
> >>                    unsigned int symindex,
> >>                    unsigned int relsec,
> >>                    struct module *me,
> >> -                  void *(*write)(void *dest, const void *src, size_t len))
> >> +                  void *(*write)(void *dest, const void *src, size_t len),
> >> +                  bool apply)
>
> Aside: I do prefer the style of one function to handle applying/clearing
> of relocations.  x86_64 isn't too bad, but other arches have a much
> richer set of relocations that do all sorts of relative/offset/TOC/etc
> gymnastics that keeping their code in one spot should be much more
> maintainable.

I think this pattern will be pretty hairy for ppc64le?

>
> >>  {
> >>         unsigned int i;
> >>         Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
> >>         Elf64_Sym *sym;
> >>         void *loc;
> >>         u64 val;
> >> +       u64 zero = 0ULL;
> >>
> >>         DEBUGP("Applying relocate section %u to %u\n",
> >>                relsec, sechdrs[relsec].sh_info);
>
> How about keying off the apply bool to display "Applying" vs "Clearing".

Great catch!

>
> >> @@ -163,40 +165,60 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> >>                 case R_X86_64_NONE:
> >>                         break;
> >>                 case R_X86_64_64:
> >> -                       if (*(u64 *)loc != 0)
> >> -                               goto invalid_relocation;
> >> -                       write(loc, &val, 8);
> >> +                       if (apply) {
> >> +                               if (*(u64 *)loc != 0)
> >> +                                       goto invalid_relocation;
> >> +                               write(loc, &val, 8);
> >> +                       } else {
> >> +                               write(loc, &zero, 8);
> >> +                       }
> >>                         break;
> >>                 case R_X86_64_32:
> >> -                       if (*(u32 *)loc != 0)
> >> -                               goto invalid_relocation;
> >> -                       write(loc, &val, 4);
> >> -                       if (val != *(u32 *)loc)
> >> -                               goto overflow;
> >> +                       if (apply) {
> >> +                               if (*(u32 *)loc != 0)
> >> +                                       goto invalid_relocation;
> >> +                               write(loc, &val, 4);
> >> +                               if (val != *(u32 *)loc)
> >> +                                       goto overflow;
> >> +                       } else {
> >> +                               write(loc, &zero, 4);
> >> +                       }
> >>                         break;
> >>                 case R_X86_64_32S:
> >> -                       if (*(s32 *)loc != 0)
> >> -                               goto invalid_relocation;
> >> -                       write(loc, &val, 4);
> >> -                       if ((s64)val != *(s32 *)loc)
> >> -                               goto overflow;
> >> +                       if (apply) {
> >> +                               if (*(s32 *)loc != 0)
> >> +                                       goto invalid_relocation;
> >> +                               write(loc, &val, 4);
> >> +                               if ((s64)val != *(s32 *)loc)
> >> +                                       goto overflow;
> >> +                       } else {
> >> +                               write(loc, &zero, 4);
> >> +                       }
> >>                         break;
> >>                 case R_X86_64_PC32:
> >>                 case R_X86_64_PLT32:
> >> -                       if (*(u32 *)loc != 0)
> >> -                               goto invalid_relocation;
> >> -                       val -= (u64)loc;
> >> -                       write(loc, &val, 4);
> >> +                       if (apply) {
> >> +                               if (*(u32 *)loc != 0)
> >> +                                       goto invalid_relocation;
> >> +                               val -= (u64)loc;
> >> +                               write(loc, &val, 4);
> >>  #if 0
> >> -                       if ((s64)val != *(s32 *)loc)
> >> -                               goto overflow;
> >> +                               if ((s64)val != *(s32 *)loc)
> >> +                                       goto overflow;
> >>  #endif
>
> Btw, This has been #if 0'd for so long I wonder if we should just remove it?
>
> >> +                       } else {
> >> +                               write(loc, &zero, 4);
> >> +                       }
> >>                         break;
> >>                 case R_X86_64_PC64:
> >> -                       if (*(u64 *)loc != 0)
> >> -                               goto invalid_relocation;
> >> -                       val -= (u64)loc;
> >> -                       write(loc, &val, 8);
> >> +                       if (apply) {
> >> +                               if (*(u64 *)loc != 0)
> >> +                                       goto invalid_relocation;
> >> +                               val -= (u64)loc;
> >> +                               write(loc, &val, 8);
> >> +                       } else {
> >> +                               write(loc, &zero, 8);
> >> +                       }
>
> In my branch [2] ("(song, x86_64 suggestions) livepatch: Clear
> relocation targets on a module removal"), I experimented with reducing
> these cases down into two steps: compute the new val and then set the
> location.
>
> Having back-to-back relocation case blocks wasn't ideal, but it does
> reduce code a bit:
>
>   For step 1:
>    - combine the relative relocation assignment
>    - consider !apply to be val of 0, drop the zero variable
>
>   For step 2:
>    - drop the if (apply) conditional, just write the new val
>
> For at least this arch, I think it came out OK.  Summarized here for
> reference:
>
> /* Calculate value (or zero if clearing) */
> if (apply) {
>         val = sym->st_value + rel[i].r_addend;
>
>         switch (ELF64_R_TYPE(rel[i].r_info)) {
>         case R_X86_64_PC32:
>         case R_X86_64_PLT32:
>         case R_X86_64_PC64:
>                 val -= (u64)loc;
>                 break;
>         }
> } else {
>         val = 0ULL;
> }
>
> /* Apply/clear relocation value */
> switch (ELF64_R_TYPE(rel[i].r_info)) {
> case R_X86_64_NONE:
>         break;
> case R_X86_64_64:
>         if (apply && *(u64 *)loc != 0)
>                 goto invalid_relocation;
>         write(loc, &val, 8);
>         break;
> case R_X86_64_32:
>         if (apply && *(u32 *)loc != 0)
>                 goto invalid_relocation;
>         write(loc, &val, 4);
>         if (val != *(u32 *)loc)
>                 goto overflow;
>         break;
> [ ... etc ... ]

This version looks good to me.

>
>
> That said, things got hairy really fast when I tried applying a similar
> pattern to ppc64le code, so maybe this model wouldn't help other arches
> so much.  (I haven't looked at s390x yet.)

ppc64le seems to have totally different pattern.

>
> I'm not married to this approach, but thought I'd mention it as it
> helped me tease apart these long apply_relocation() functions.

>
> >>                         break;
> >>                 default:
> >>                         pr_err("%s: Unknown rela relocation: %llu\n",
> >> @@ -219,11 +241,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> >>         return -ENOEXEC;
> >>  }
[...]
> >>
> >
>
> I will try to get around to testing s390x sometime soon and report back
> on how that works out.
>

Thanks!
Song
