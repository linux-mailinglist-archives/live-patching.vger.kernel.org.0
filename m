Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D5267A09E
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 18:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjAXR4t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 12:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbjAXR4s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 12:56:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE1DBF9;
        Tue, 24 Jan 2023 09:56:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 984CE60ACD;
        Tue, 24 Jan 2023 17:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC986C433A0;
        Tue, 24 Jan 2023 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674583006;
        bh=yiFYzUpcDXwUcJ7dlXMynTIVvmaPqN0sYRnYNFnV5fE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HZyowgtVxUbGDIOCXCmIYezARyPiYm8RvnyXoPGm7NiTGMge4TayE85ZsxBH2jiNi
         Pub8bRVg02RIiFCt1AB42wknlFlCYE3Hitqsp2RCuNAq+Ah+yGI72O23h1BZrIPLS3
         92IvWnwvH+UqB+AolpwdJAjgqtrZuToChc2yAxsu2USQuPTSY1D6jIz8QHY+7/AdFL
         dokYkNc0/v/W+WxNJo22iZXzFOfgF/JJ5Q8It1OGFjEMJaZPcmix6+wjAMzlW6U9DJ
         BH5L0CFKf8x3Kf9f0zzIeeOK2Cx7+xleI/aSvX3KkYbrrmRZiAuHCHhxYDZ7oSvNUh
         4HhTtQ7QyAXxw==
Received: by mail-lf1-f52.google.com with SMTP id b3so24723954lfv.2;
        Tue, 24 Jan 2023 09:56:45 -0800 (PST)
X-Gm-Message-State: AFqh2krSjNjxuWNkmNyXlt0dNPnU0WI4z93Tcfl7eQBti16+CjrVsnS8
        z/Mi1j4GHKJuhFcvDHTSqnbF6kvTg5+i/4QbhDs=
X-Google-Smtp-Source: AMrXdXvDO+ULlZUnPQE6S+T/0t4RulvY2Rg5EJPfx2IfdlN2dRWwC2yLtWMpNVd7zzXP+HmCZS8RXm5xQEyRSeSUYuI=
X-Received: by 2002:a05:6512:3c8a:b0:4d5:8d49:569c with SMTP id
 h10-20020a0565123c8a00b004d58d49569cmr2893554lfv.643.1674583003148; Tue, 24
 Jan 2023 09:56:43 -0800 (PST)
MIME-Version: 1.0
References: <20230121004945.697003-1-song@kernel.org> <20230121004945.697003-2-song@kernel.org>
In-Reply-To: <20230121004945.697003-2-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 24 Jan 2023 09:56:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6i6iJAEc5YWvW4dqz24yYEGXp-AcrGbRTjdaTQ_x++XA@mail.gmail.com>
Message-ID: <CAPhsuW6i6iJAEc5YWvW4dqz24yYEGXp-AcrGbRTjdaTQ_x++XA@mail.gmail.com>
Subject: Re: [PATCH v10 2/2] livepatch,x86: Clear relocation targets on a
 module removal
To:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Thomas,

Could you please help review this change from x86 side?

Thanks,
Song

On Fri, Jan 20, 2023 at 4:50 PM Song Liu <song@kernel.org> wrote:
>
> Josh reported a bug:
>
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
>
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
>
> He also proposed three different solutions. We could remove the error
> check in apply_relocate_add() introduced by commit eda9cec4c9a1
> ("x86/module: Detect and skip invalid relocations"). However the check
> is useful for detecting corrupted modules.
>
> We could also deny the patched modules to be removed. If it proved to be
> a major drawback for users, we could still implement a different
> approach. The solution would also complicate the existing code a lot.
>
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
>
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Originally-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
>
> ---
>
> NOTE: powerpc32 code is only compile tested.
>
> Changes v9 => v10:
> 1. Revise commit log. (Josh Poimboeuf)
> 2. Various improvements in code style, comments, etc. (Josh Poimboeuf)
>
> Changes v8 => v9:
> 1. Fix overflow check for R_X86_64_PC32 and R_X86_64_PLT32. (Petr Mladek)
>
> Changes v7 = v8:
> 1. Remove the logic in powerpc/kernel/module_64.c, as there is ongoing
>    discussions.
> 2. For x86_64, add check for expected value during clear_relocate_add().
>    (Petr Mladek)
> 3. Optimize the logic in klp_write_section_relocs(). (Petr Mladek)
> 4. Optimize __write_relocate_add (x86_64). (Joe Lawrence)
>
> Changes v6 = v7:
> 1. Reduce code duplication in livepatch/core.c and x86/kernel/module.c.
> 2. Add more comments to powerpc/kernel/module_64.c.
> 3. Added Joe's Tested-by (which I should have added in v6).
>
> Changes v5 = v6:
> 1. Fix powerpc64.
> 2. Fix compile for powerpc32.
>
> Changes v4 = v5:
> 1. Fix compile with powerpc.
>
> Changes v3 = v4:
> 1. Reuse __apply_relocate_add to make it more reliable in long term.
>    (Josh Poimboeuf)
> 2. Add back ppc64 logic from v2, with changes to match current code.
>    (Josh Poimboeuf)
>
> Changes v2 => v3:
> 1. Rewrite x86 changes to match current code style.
> 2. Remove powerpc changes as there is no test coverage in v3.
> 3. Only keep 1/3 of v2.
>
> v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u
>
> fix
> ---
>  arch/powerpc/kernel/module_32.c | 10 ++++
>  arch/powerpc/kernel/module_64.c | 10 ++++
>  arch/s390/kernel/module.c       |  8 +++
>  arch/x86/kernel/module.c        | 93 +++++++++++++++++++++------------
>  include/linux/moduleloader.h    | 17 ++++++
>  kernel/livepatch/core.c         | 54 ++++++++++++++-----
>  6 files changed, 146 insertions(+), 46 deletions(-)
>
> diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
> index ea6536171778..e3c312770453 100644
> --- a/arch/powerpc/kernel/module_32.c
> +++ b/arch/powerpc/kernel/module_32.c
> @@ -285,6 +285,16 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
>         return 0;
>  }
>
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf32_Shdr *sechdrs,
> +                  const char *strtab,
> +                  unsigned int symindex,
> +                  unsigned int relsec,
> +                  struct module *me)
> +{
> +}
> +#endif
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  notrace int module_trampoline_target(struct module *mod, unsigned long addr,
>                                      unsigned long *target)
> diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
> index ff045644f13f..1096d6b3a62c 100644
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -749,6 +749,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>         return 0;
>  }
>
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> +                      const char *strtab,
> +                      unsigned int symindex,
> +                      unsigned int relsec,
> +                      struct module *me)
> +{
> +}
> +#endif
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  int module_trampoline_target(struct module *mod, unsigned long addr,
>                              unsigned long *target)
> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> index 2d159b32885b..cc6784fbc1ac 100644
> --- a/arch/s390/kernel/module.c
> +++ b/arch/s390/kernel/module.c
> @@ -500,6 +500,14 @@ static int module_alloc_ftrace_hotpatch_trampolines(struct module *me,
>  }
>  #endif /* CONFIG_FUNCTION_TRACER */
>
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
> +                       unsigned int symindex, unsigned int relsec,
> +                       struct module *me)
> +{
> +}
> +#endif
> +
>  int module_finalize(const Elf_Ehdr *hdr,
>                     const Elf_Shdr *sechdrs,
>                     struct module *me)
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index 1dee3ad82da2..e4aab0395a33 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -129,22 +129,27 @@ int apply_relocate(Elf32_Shdr *sechdrs,
>         return 0;
>  }
>  #else /*X86_64*/
> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> +static int __write_relocate_add(Elf64_Shdr *sechdrs,
>                    const char *strtab,
>                    unsigned int symindex,
>                    unsigned int relsec,
>                    struct module *me,
> -                  void *(*write)(void *dest, const void *src, size_t len))
> +                  void *(*write)(void *dest, const void *src, size_t len),
> +                  bool apply)
>  {
>         unsigned int i;
>         Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
>         Elf64_Sym *sym;
>         void *loc;
>         u64 val;
> +       u64 zero = 0ULL;
>
> -       DEBUGP("Applying relocate section %u to %u\n",
> +       DEBUGP("%s relocate section %u to %u\n",
> +              apply ? "Applying" : "Clearing",
>                relsec, sechdrs[relsec].sh_info);
>         for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
> +               int size = 0;
> +
>                 /* This is where to make the change */
>                 loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
>                         + rel[i].r_offset;
> @@ -162,52 +167,53 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>
>                 switch (ELF64_R_TYPE(rel[i].r_info)) {
>                 case R_X86_64_NONE:
> -                       break;
> +                       continue;  /* nothing to write */
>                 case R_X86_64_64:
> -                       if (*(u64 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 8);
> +                       size = 8;
>                         break;
>                 case R_X86_64_32:
> -                       if (*(u32 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 4);
> -                       if (val != *(u32 *)loc)
> +                       if (val != *(u32 *)&val)
>                                 goto overflow;
> +                       size = 4;
>                         break;
>                 case R_X86_64_32S:
> -                       if (*(s32 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 4);
> -                       if ((s64)val != *(s32 *)loc)
> +                       if ((s64)val != *(s32 *)&val)
>                                 goto overflow;
> +                       size = 4;
>                         break;
>                 case R_X86_64_PC32:
>                 case R_X86_64_PLT32:
> -                       if (*(u32 *)loc != 0)
> -                               goto invalid_relocation;
>                         val -= (u64)loc;
> -                       write(loc, &val, 4);
> +                       size = 4;
>                         break;
>                 case R_X86_64_PC64:
> -                       if (*(u64 *)loc != 0)
> -                               goto invalid_relocation;
>                         val -= (u64)loc;
> -                       write(loc, &val, 8);
> +                       size = 8;
>                         break;
>                 default:
>                         pr_err("%s: Unknown rela relocation: %llu\n",
>                                me->name, ELF64_R_TYPE(rel[i].r_info));
>                         return -ENOEXEC;
>                 }
> +
> +               if (apply) {
> +                       if (memcmp(loc, &zero, size)) {
> +                               pr_err("x86/modules: Invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
> +                                      (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> +                               return -ENOEXEC;
> +                       }
> +                       write(loc, &val, size);
> +               } else {
> +                       if (memcmp(loc, &val, size)) {
> +                               pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
> +                                       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> +                               return -ENOEXEC;
> +                       }
> +                       write(loc, &zero, size);
> +               }
>         }
>         return 0;
>
> -invalid_relocation:
> -       pr_err("x86/modules: Skipping invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
> -              (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> -       return -ENOEXEC;
> -
>  overflow:
>         pr_err("overflow in relocation type %d val %Lx\n",
>                (int)ELF64_R_TYPE(rel[i].r_info), val);
> @@ -216,11 +222,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>         return -ENOEXEC;
>  }
>
> -int apply_relocate_add(Elf64_Shdr *sechdrs,
> -                  const char *strtab,
> -                  unsigned int symindex,
> -                  unsigned int relsec,
> -                  struct module *me)
> +static int write_relocate_add(Elf64_Shdr *sechdrs,
> +                             const char *strtab,
> +                             unsigned int symindex,
> +                             unsigned int relsec,
> +                             struct module *me,
> +                             bool apply)
>  {
>         int ret;
>         bool early = me->state == MODULE_STATE_UNFORMED;
> @@ -231,8 +238,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>                 mutex_lock(&text_mutex);
>         }
>
> -       ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> -                                  write);
> +       ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +                                  write, apply);
>
>         if (!early) {
>                 text_poke_sync();
> @@ -242,6 +249,26 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>         return ret;
>  }
>
> +int apply_relocate_add(Elf64_Shdr *sechdrs,
> +                  const char *strtab,
> +                  unsigned int symindex,
> +                  unsigned int relsec,
> +                  struct module *me)
> +{
> +       return write_relocate_add(sechdrs, strtab, symindex, relsec, me, true);
> +}
> +
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> +                       const char *strtab,
> +                       unsigned int symindex,
> +                       unsigned int relsec,
> +                       struct module *me)
> +{
> +       write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);
> +}
> +#endif
> +
>  #endif
>
>  int module_finalize(const Elf_Ehdr *hdr,
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index 7b4587a19189..03be088fb439 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -75,6 +75,23 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
>                        unsigned int symindex,
>                        unsigned int relsec,
>                        struct module *mod);
> +#ifdef CONFIG_LIVEPATCH
> +/*
> + * Some architectures (namely x86_64 and ppc64) perform sanity checks when
> + * applying relocations.  If a patched module gets unloaded and then later
> + * reloaded (and re-patched), klp re-applies relocations to the replacement
> + * function(s).  Any leftover relocations from the previous loading of the
> + * patched module might trigger the sanity checks.
> + *
> + * To prevent that, when unloading a patched module, clear out any relocations
> + * that might trigger arch-specific sanity checks on a future module reload.
> + */
> +void clear_relocate_add(Elf_Shdr *sechdrs,
> +                  const char *strtab,
> +                  unsigned int symindex,
> +                  unsigned int relsec,
> +                  struct module *me);
> +#endif
>  #else
>  static inline int apply_relocate_add(Elf_Shdr *sechdrs,
>                                      const char *strtab,
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 201f0c0482fb..c72f378181ce 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -291,10 +291,10 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>   *    the to-be-patched module to be loaded and patched sometime *after* the
>   *    klp module is loaded.
>   */
> -int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> -                            const char *shstrtab, const char *strtab,
> -                            unsigned int symndx, unsigned int secndx,
> -                            const char *objname)
> +static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +                                   const char *shstrtab, const char *strtab,
> +                                   unsigned int symndx, unsigned int secndx,
> +                                   const char *objname, bool apply)
>  {
>         int cnt, ret;
>         char sec_objname[MODULE_NAME_LEN];
> @@ -316,11 +316,26 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>         if (strcmp(objname ? objname : "vmlinux", sec_objname))
>                 return 0;
>
> -       ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> -       if (ret)
> -               return ret;
> +       if (apply) {
> +               ret = klp_resolve_symbols(sechdrs, strtab, symndx,
> +                                         sec, sec_objname);
> +               if (ret)
> +                       return ret;
>
> -       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +               return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +       }
> +
> +       clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +       return 0;
> +}
> +
> +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +                            const char *shstrtab, const char *strtab,
> +                            unsigned int symndx, unsigned int secndx,
> +                            const char *objname)
> +{
> +       return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> +                                       secndx, objname, true);
>  }
>
>  /*
> @@ -769,8 +784,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>                            func->old_sympos ? func->old_sympos : 1);
>  }
>
> -static int klp_apply_object_relocs(struct klp_patch *patch,
> -                                  struct klp_object *obj)
> +static int klp_write_object_relocs(struct klp_patch *patch,
> +                                  struct klp_object *obj,
> +                                  bool apply)
>  {
>         int i, ret;
>         struct klp_modinfo *info = patch->mod->klp_info;
> @@ -781,10 +797,10 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>                 if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
>                         continue;
>
> -               ret = klp_apply_section_relocs(patch->mod, info->sechdrs,
> +               ret = klp_write_section_relocs(patch->mod, info->sechdrs,
>                                                info->secstrings,
>                                                patch->mod->core_kallsyms.strtab,
> -                                              info->symndx, i, obj->name);
> +                                              info->symndx, i, obj->name, apply);
>                 if (ret)
>                         return ret;
>         }
> @@ -792,6 +808,18 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>         return 0;
>  }
>
> +static int klp_apply_object_relocs(struct klp_patch *patch,
> +                                  struct klp_object *obj)
> +{
> +       return klp_write_object_relocs(patch, obj, true);
> +}
> +
> +static void klp_clear_object_relocs(struct klp_patch *patch,
> +                                   struct klp_object *obj)
> +{
> +       klp_write_object_relocs(patch, obj, false);
> +}
> +
>  /* parts of the initialization that is done only when the object is loaded */
>  static int klp_init_object_loaded(struct klp_patch *patch,
>                                   struct klp_object *obj)
> @@ -1179,7 +1207,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
>                         klp_unpatch_object(obj);
>
>                         klp_post_unpatch_callback(obj);
> -
> +                       klp_clear_object_relocs(patch, obj);
>                         klp_free_object_loaded(obj);
>                         break;
>                 }
> --
> 2.30.2
>
