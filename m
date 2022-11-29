Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D795663B77D
	for <lists+live-patching@lfdr.de>; Tue, 29 Nov 2022 02:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiK2B5W (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Nov 2022 20:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiK2B5V (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Nov 2022 20:57:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072573135D;
        Mon, 28 Nov 2022 17:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9279661532;
        Tue, 29 Nov 2022 01:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60C0C433D7;
        Tue, 29 Nov 2022 01:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669687039;
        bh=RR3l04y9mI6dUbLc2VgWj7KfTEgIhi84deXgt2t8g8I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bd+lP5H1ZonmaSTZAWSB4ReBy/DwkSVI6jWbHxgQNxSC0w50c7lnODTIzXYBDcQ7T
         T/leNw/QTL63YtLQZJH5c7X1so28BCgBWNFj/MQZumtFY3gyHxM4YetPzhsywvdRi7
         tUNZHknN83zWD+y6usiSTBnr+EnDPBwqk/Ma0ceVx9v0NZKHiy1aHROHSUylmyvXFu
         rO16hrXiYEchzTaTLbhGQi0lCNRuXMwRi02q0jWAZe5T8hvKeMhQhtLz9+2Kx2w1VQ
         nEvX3wGqHOhlgDslSPmGjDRBjjo2mh4lmP2aIOTQRpsfxxcMygRxhZA4sz8fDCwCc7
         BErs3piClv6iw==
Received: by mail-ej1-f49.google.com with SMTP id e27so30343924ejc.12;
        Mon, 28 Nov 2022 17:57:19 -0800 (PST)
X-Gm-Message-State: ANoB5pmIyiFRpnp/Gg08und5Sw7C0gGJnQXwpvLWQb2IS96ezQc05BjT
        DEwkGyMjW3Gafh8Ok2UgyYJNue3b3X+RFPgrJhM=
X-Google-Smtp-Source: AA0mqf7QPwy/gfx9+IQQdiRZ+nRvnL+Bi5qWVedX/jzBfS+m5qi3GdnOmGsm1gidpRnJ5G9t/0ENmzcMuZIq+IlBP8s=
X-Received: by 2002:a17:906:3954:b0:7bf:852b:e23c with SMTP id
 g20-20020a170906395400b007bf852be23cmr7332813eje.614.1669687038069; Mon, 28
 Nov 2022 17:57:18 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
In-Reply-To: <Y3expGRt4cPoZgHL@alley>
From:   Song Liu <song@kernel.org>
Date:   Mon, 28 Nov 2022 17:57:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
Message-ID: <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
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

On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
>
[...]

> >
> > +#ifdef CONFIG_LIVEPATCH
> > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > +                    const char *strtab,
> > +                    unsigned int symindex,
> > +                    unsigned int relsec,
> > +                    struct module *me)
> > +{
> > +     unsigned int i;
> > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > +     Elf64_Sym *sym;
> > +     unsigned long *location;
> > +     const char *symname;
> > +     u32 *instruction;
> > +
> > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > +              sechdrs[relsec].sh_info);
> > +
> > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > +                     + rela[i].r_offset;
> > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > +                     + ELF64_R_SYM(rela[i].r_info);
> > +             symname = me->core_kallsyms.strtab
> > +                     + sym->st_name;
> > +
> > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > +                     continue;
> > +             /*
> > +              * reverse the operations in apply_relocate_add() for case
> > +              * R_PPC_REL24.
> > +              */
> > +             if (sym->st_shndx != SHN_UNDEF &&
> > +                 sym->st_shndx != SHN_LIVEPATCH)
> > +                     continue;
> > +
> > +             instruction = (u32 *)location;
> > +             if (is_mprofile_ftrace_call(symname))
> > +                     continue;
> > +
> > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > +                     continue;
> > +
> > +             instruction += 1;
> > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > +     }
> > +
> > +}
>
> This looks like a lot of duplicated code. Isn't it?

TBH, I think the duplicated code is not really bad.

apply_relocate_add() is a much more complicated function, I would
rather not mess it up to make this function a little simpler.

[...]

>
> This duplicates a lot of code. Please, rename apply_relocate_add() the
> same way as __apply_clear_relocate_add() and add the "apply" parameter.
> Then add the wrappers for this:
>
> int write_relocate_add(Elf64_Shdr *sechdrs,
>                        const char *strtab,
>                        unsigned int symindex,
>                        unsigned int relsec,
>                        struct module *me,
>                        bool apply)
> {
>         int ret;
>         bool early = me->state == MODULE_STATE_UNFORMED;
>         void *(*write)(void *, const void *, size_t) = memcpy;
>
>         if (!early) {
>                 write = text_poke;
>                 mutex_lock(&text_mutex);
>         }

How about we move the "early" logic into __write_relocate_add()?

>
>         ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
>                                          write, apply);
>
>         if (!early) {
>                 text_poke_sync();
>                 mutex_unlock(&text_mutex);
>         }
>
>         return ret;
> }
>
> int apply_relocate_add(Elf64_Shdr *sechdrs,
>                        const char *strtab,
>                        unsigned int symindex,
>                        unsigned int relsec,
>                        struct module *me)
> {
>         return write_relocate_add(sechdrs, strtab, symindex, relsec, me, true);

Then we just call __write_relocate_add() from here...

> }
>
> #ifdef CONFIG_LIVEPATCH
> void apply_relocate_add(Elf64_Shdr *sechdrs,
>                         const char *strtab,
>                         unsigned int symindex,
>                         unsigned int relsec,
>                         struct module *me)
> {
>         write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);

and here.


> }
> #endif
>
>
> > +#endif
> > +
> >  #endif
> >
> >  int module_finalize(const Elf_Ehdr *hdr,
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> >       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> >  }
> >
> > +static void klp_clear_object_relocations(struct module *pmod,
> > +                                     struct klp_object *obj)
> > +{
> > +     int i, cnt;
> > +     const char *objname, *secname;
> > +     char sec_objname[MODULE_NAME_LEN];
> > +     Elf_Shdr *sec;
> > +
> > +     objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > +
> > +     /* For each klp relocation section */
> > +     for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > +             sec = pmod->klp_info->sechdrs + i;
> > +             secname = pmod->klp_info->secstrings + sec->sh_name;
> > +             if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> > +                     continue;
> > +
> > +             /*
> > +              * Format: .klp.rela.sec_objname.section_name
> > +              * See comment in klp_resolve_symbols() for an explanation
> > +              * of the selected field width value.
> > +              */
> > +             secname = pmod->klp_info->secstrings + sec->sh_name;
> > +             cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > +             if (cnt != 1) {
> > +                     pr_err("section %s has an incorrectly formatted name\n",
> > +                            secname);
> > +                     continue;
> > +             }

Actually, I think we don't need the cnt check here. Once it is removed,
there isn't much duplicated logic.

> > +
> > +             if (strcmp(objname, sec_objname))
> > +                     continue;
> > +
> > +             clear_relocate_add(pmod->klp_info->sechdrs,
> > +                                pmod->core_kallsyms.strtab,
> > +                                pmod->klp_info->symndx, i, pmod);
> > +     }
> > +}
>
> Huh, this duplicates a lot of tricky code.
>
> It is even worse because this squashed code from two functions
> klp_apply_section_relocs() and klp_apply_object_relocs()
> into a single function. As a result, the code duplication is not
> even obvious.
>
> Also the suffix "_reloacations() does not match the suffix of
> the related funciton:
>
>         + klp_apply_object_relocs()             (existing)
>         + klp_clear_object_relocations()        (new)
>
> This all would complicate maintenance of the code.
>
> Please, implement a common:
>
> int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>                              const char *shstrtab, const char *strtab,
>                              unsigned int symndx, unsigned int secndx,
>                              const char *objname, bool apply);
>
> and
>
> int klp_write_object_relocs(struct klp_patch *patch,
>                             struct klp_object *obj,
>                             bool apply);
>
> and add the respective wrappers:
>
> int klp_apply_section_relocs();   /* also needed in module/main.c */
> int klp_apply_object_relocs();
> void klp_clear_object_relocs();

With the above simplification (removing cnt check), do we still need
all these wrappers? Personally, I think they will make the code more
difficult to follow..

Thanks,
Song
