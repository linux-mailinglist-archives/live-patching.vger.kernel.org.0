Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB03675E36
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 20:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjATTlU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 14:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjATTlU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 14:41:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5966EC2;
        Fri, 20 Jan 2023 11:41:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 530F361E40;
        Fri, 20 Jan 2023 19:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6213C4339B;
        Fri, 20 Jan 2023 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674243677;
        bh=fJ3xodor8ht7hrxk9K1iH/UUSi5WtK3h8lzAbdqO2II=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OjjC6eVbGsMFslTChoesD0erRzRt7ttwzHZ6jr1Q4hOdl+4G+1mETBqHArwxnM5mS
         7YHX3hJ7vcqgvoAnPodfo9EywGRkQSil/Mh9dh5sv/cgOtcRgSfO+pKYnl4n26q4PQ
         zuh6LnLWyiZA2hfUIG7xqOTe6w5Ks53VD4tduLub3qx3mIoNFVrrGeweCdTHs7l4iw
         suxhoba3FPl9L4B3boZhwMeuX7vzIZL7CVnWQ16+RRJPTBCBTIZUDiSA4bSUMxEQWu
         uDo4Dsor3TihAEzwbe+h3JMVRkHnuNVa6Mj/zRM96+Vi4wP3bCjPSGtrQ5LW4bqQOM
         RajlT8vdpePeg==
Received: by mail-lf1-f50.google.com with SMTP id y25so9552278lfa.9;
        Fri, 20 Jan 2023 11:41:17 -0800 (PST)
X-Gm-Message-State: AFqh2krUNXfyMUK60mIADV7Yf7KyWTQjiEdTrkRkvRltPI+3UDJiQglm
        6uLcbI0YZYT40MZ2Vpks83B0Ho9ysP9rGbsV5PY=
X-Google-Smtp-Source: AMrXdXveosmxRJsgaiWmemiMGlTSGpu/o5fTesc6yKKWOobi67+tkYERMDr9hpWaOLLJjmeZBnuKEWwKARYLY/YrH7c=
X-Received: by 2002:a05:6512:2115:b0:4cb:1d3e:685b with SMTP id
 q21-20020a056512211500b004cb1d3e685bmr907108lfr.126.1674243675671; Fri, 20
 Jan 2023 11:41:15 -0800 (PST)
MIME-Version: 1.0
References: <20230118204728.1876249-1-song@kernel.org> <20230120191642.7bmqt6t4qngisqep@treble>
In-Reply-To: <20230120191642.7bmqt6t4qngisqep@treble>
From:   Song Liu <song@kernel.org>
Date:   Fri, 20 Jan 2023 11:41:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW436=wRKLixWNtE9Rx=6A0gKrOCR8EUOdwTrPw5W6gddg@mail.gmail.com>
Message-ID: <CAPhsuW436=wRKLixWNtE9Rx=6A0gKrOCR8EUOdwTrPw5W6gddg@mail.gmail.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module removal
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
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

On Fri, Jan 20, 2023 at 11:16 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Wed, Jan 18, 2023 at 12:47:28PM -0800, Song Liu wrote:
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
>
> Should we add a selftest to make sure this problem doesn't come back?

IIRC, a selftest for this issue is not easy without Joe's klp-convert work.
At the moment I use kpatch-build for testing.

>
> >   On ppc64le, we have a similar issue:
> >
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>
> Just to clarify my previous comment, the reference to the powerpc issue
> should be removed because it'll be fixed in a separate patch.

Will remove.

>
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
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Song Liu <song@kernel.org>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > Co-developed-by: Song Liu <song@kernel.org>
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
>
> According to submitting-patches.rst the Co-developed-by is supposed to
> be immediately before your Signed-off-by.
>
> Also, other than the commit log, this patch is almost completely
> unrecognizable compared to Miroslav's original patch.  Does it still
> make sense for him to be listed as the author?
>
> In the -tip tree they sometimes use an Originally-by tag, which might be
> relevant here.

How about:

Signed-off-by: Song Liu <song@kernel.org>
Originally-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>

>
> > -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> > +static int __write_relocate_add(Elf64_Shdr *sechdrs,
> >                  const char *strtab,
> >                  unsigned int symindex,
> >                  unsigned int relsec,
> >                  struct module *me,
> > -                void *(*write)(void *dest, const void *src, size_t len))
> > +                void *(*write)(void *dest, const void *src, size_t len),
> > +                bool apply)
> >  {
> >       unsigned int i;
> >       Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
> >       Elf64_Sym *sym;
> >       void *loc;
> >       u64 val;
> > +     u64 zero = 0ULL;
> >
> > -     DEBUGP("Applying relocate section %u to %u\n",
> > +     DEBUGP("%s relocate section %u to %u\n",
> > +            (apply) ? "Applying" : "Clearing",
>
> "(apply)" has unnecessary parentheses.
>
> >              relsec, sechdrs[relsec].sh_info);
> >       for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
> > +             int write_size = 4;
>
> We already know we're writing, I suggest just calling it 'size' to be
> more consistent with kernel style.
>
> Also, it can be an unsigned value like size_t.
>
> Also, instead of initializing it here with a potentially bogus value
> which may need to be overwritten for a 64-bit reloc, it's better to
> explicitly set the size in each individual case below.  That's makes the
> logic clearer and helps prevent future bugs if new 64-bit relocation
> types are added later.

Will fix in v10.

>
> >               case R_X86_64_PC32:
> >               case R_X86_64_PLT32:
> > -                     if (*(u32 *)loc != 0)
> > -                             goto invalid_relocation;
> >                       val -= (u64)loc;
> > -                     write(loc, &val, 4);
> >  #if 0
> > -                     if ((s64)val != *(s32 *)loc)
> > +                     if ((s64)val != *(s32 *)&val)
> >                               goto overflow;
> >  #endif
>
> Why is the compiled-out code getting changed?  Is it actually fixing a
> hypothetical bug?

I just changed them the same way as other cases (assuming we remove
the #if 0, of course).

>
> This code really needs to be removed anyway, it's been dead for at least
> 15 years.

Shall we remove it now? Within the same patch? Or with a preparation
patch?

>
> >                       break;
> >               case R_X86_64_PC64:
> > -                     if (*(u64 *)loc != 0)
> > -                             goto invalid_relocation;
> >                       val -= (u64)loc;
> > -                     write(loc, &val, 8);
> > +                     write_size = 8;
> >                       break;
> >               default:
> >                       pr_err("%s: Unknown rela relocation: %llu\n",
> >                              me->name, ELF64_R_TYPE(rel[i].r_info));
> >                       return -ENOEXEC;
> >               }
> > +
> > +             if (apply) {
> > +                     if (memcmp(loc, &zero, write_size)) {
> > +                             pr_err("x86/modules: Skipping invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
>
> It's not just "skipping", it's erroring out completely.  Yes, it's is a
> pre-existing error message but we might as well improve it while
> touching it.
>
> Maybe just remove the "Skipping", i.e. change "Skipping invalid ..." to
> "Invalid ..." ?

Sounds good to me.

>
> > +                                    (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> > +                             return -ENOEXEC;
> > +                     }
> > +                     write(loc, &val, write_size);
> > +             } else {
> > +                     if (memcmp(loc, &val, write_size)) {
> > +                             pr_warn("x86/modules: Clearing invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
> > +                                     (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> > +                     }
> > +                     write(loc, &zero, write_size);
>
> If the value doesn't match then something has gone badly wrong.  Why go
> ahead with the clearing in that case?

We can pr_err() then return -ENOEXEC (?). But I guess we need to
handle the error case in:
  klp_cleanup_module_patches_limited()
  klp_module_coming()
  klp_module_going()
and all the functions that call klp_module_going().

This seems a big overkill to me...

Or do you mean we just skip the write()?

>
> > +#ifdef CONFIG_LIVEPATCH
> > +
> > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > +                     const char *strtab,
> > +                     unsigned int symindex,
> > +                     unsigned int relsec,
> > +                     struct module *me)
> > +{
> > +     write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);
> > +}
> > +#endif
>
> Superflous newline after the '#ifdef CONFIG_LIVEPATCH'.
>
> > +
> >  #endif
> >
> >  int module_finalize(const Elf_Ehdr *hdr,
> > diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> > index 7b4587a19189..0b54ec9856df 100644
> > --- a/include/linux/moduleloader.h
> > +++ b/include/linux/moduleloader.h
> > @@ -75,6 +75,13 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
> >                      unsigned int symindex,
> >                      unsigned int relsec,
> >                      struct module *mod);
> > +#ifdef CONFIG_LIVEPATCH
>
> This could use a comment explaining the purpose of this function:
>
> /*
>  * Some architectures (namely x86_64 and ppc64) perform sanity checks when
>  * applying relocations.  If a patched module gets unloaded and then later
>  * reloaded (and re-patched), klp re-applies relocations to the replacement
>  * function(s).  Any leftover relocations from the previous loading of the
>  * patched module might trigger the sanity checks.
>  *
>  * To prevent that, when unloading a patched module, clear out any relocations
>  * that might trigger arch-specific sanity checks on a future module reload.
>  */

Sounds great. Will add this to the next version.

>
> > +void clear_relocate_add(Elf_Shdr *sechdrs,
> > +                const char *strtab,
> > +                unsigned int symindex,
> > +                unsigned int relsec,
> > +                struct module *me);
> > +#endif
>
>
> --
> Josh
