Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7C65C47C
	for <lists+live-patching@lfdr.de>; Tue,  3 Jan 2023 18:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbjACRCx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Jan 2023 12:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbjACRAX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Jan 2023 12:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DB12D19
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 09:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C05EFB8104A
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 17:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4610EC43392
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672765219;
        bh=MbnfeME8PLrwHK6BIfkIRhJqHrtjzu0mYD5l/yt/YYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DIiVtZ8QxS4bWL9G7/bt824tQETGuXtvRfBXeHQt8HBmeSdsEEVlbtk6W38in3jCz
         BZJ8fYf2lf9Qhz4LKwSUmW1vhlNmGenQBXCeYqZr9tVozP+/oJ4CyHHXIln57cEpsz
         bZ0wotBNhjfNhnMEISxp1/XdP2Aa/ILpSowqLZ7TU2bEeEkaNkgMzWGExnF5Imvtwl
         RXgJFmTR3ZVtRQeAfEI8PWWQqadDbaWCfajfnnfAxUmECk6A5bfcZIrrNWlHw7lyVp
         Ds6BAO9tkfMxqu6h8S8sfFCwxep7o4t6cChy3rDt6B4R4VqHX3QPjgwGEm4SnsTJzL
         sYJ9c6s0DOG2w==
Received: by mail-lf1-f53.google.com with SMTP id f34so46427320lfv.10
        for <live-patching@vger.kernel.org>; Tue, 03 Jan 2023 09:00:19 -0800 (PST)
X-Gm-Message-State: AFqh2koicvTsmQ7vyKSMe6ALeCzVCabPF47c+wKe9FodrhtiKytA2Oj/
        heAOijFO2ilg6Dz88m5UkZHKyPB9j7sgPkYcCa4=
X-Google-Smtp-Source: AMrXdXs6iOeE6L4VnTGA8l5AGtqmA0ZC4cH/jCKtWgt8D0Qjv/tAVCmyan49JyQY0TCfG5HPm3armWFvZFqYGL+HiBc=
X-Received: by 2002:a19:640f:0:b0:4b6:e71d:94a6 with SMTP id
 y15-20020a19640f000000b004b6e71d94a6mr3187605lfb.476.1672765216520; Tue, 03
 Jan 2023 09:00:16 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org>
In-Reply-To: <20221214174035.1012183-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 3 Jan 2023 09:00:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6tFacM0z3K34eMNZzZmS7UYaa5x8NivrZnySt5sLappQ@mail.gmail.com>
Message-ID: <CAPhsuW6tFacM0z3K34eMNZzZmS7UYaa5x8NivrZnySt5sLappQ@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     live-patching@vger.kernel.org
Cc:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, Miroslav Benes <mbenes@suse.cz>,
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

Hi folks,

Happy New Year!

Could you please share your comments/suggestions on this version?

Thanks,
Song

On Wed, Dec 14, 2022 at 9:41 AM Song Liu <song@kernel.org> wrote:
>
> From: Miroslav Benes <mbenes@suse.cz>
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
>   On ppc64le, we have a similar issue:
>
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
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
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Tested-by: Joe Lawrence <joe.lawrence@redhat.com> # x86_64, s390x, ppc64le
>
> ---
>
> NOTE: powerpc32 code is only compile tested.
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
> ---
>  arch/powerpc/kernel/module_32.c |  10 +++
>  arch/powerpc/kernel/module_64.c |  61 ++++++++++++++++++
>  arch/s390/kernel/module.c       |   8 +++
>  arch/x86/kernel/module.c        | 108 ++++++++++++++++++++++----------
>  include/linux/moduleloader.h    |   7 +++
>  kernel/livepatch/core.c         |  85 ++++++++++++++++---------
>  6 files changed, 217 insertions(+), 62 deletions(-)
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
> index 7e45dc98df8a..83e6c226009c 100644
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
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
> +       unsigned int i;
> +       Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> +       Elf64_Sym *sym;
> +       unsigned long *location;
> +       const char *symname;
> +       u32 *instruction;
> +
> +       pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> +                sechdrs[relsec].sh_info);
> +
> +       for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> +               location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> +                       + rela[i].r_offset;
> +               sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> +                       + ELF64_R_SYM(rela[i].r_info);
> +               symname = me->core_kallsyms.strtab
> +                       + sym->st_name;
> +
> +               if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> +                       continue;
> +               /*
> +                * reverse the operations in apply_relocate_add() for case
> +                * R_PPC_REL24.
> +                */
> +               if (sym->st_shndx != SHN_UNDEF &&
> +                   sym->st_shndx != SHN_LIVEPATCH)
> +                       continue;
> +
> +               /* skip mprofile and ftrace calls, same as restore_r2() */
> +               if (is_mprofile_ftrace_call(symname))
> +                       continue;
> +
> +               instruction = (u32 *)location;
> +               /* skip sibling call, same as restore_r2() */
> +               if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> +                       continue;
> +
> +               instruction += 1;
> +               /*
> +                * Patch location + 1 back to NOP so the next
> +                * apply_relocate_add() call (reload the module) will not
> +                * fail the sanity check in restore_r2():
> +                *
> +                *         if (*instruction != PPC_RAW_NOP()) {
> +                *             pr_err(...);
> +                *             return 0;
> +                *         }
> +                */
> +               patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> +       }
> +
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
> index c032edcd3d95..8f997959e526 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -128,18 +128,20 @@ int apply_relocate(Elf32_Shdr *sechdrs,
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
>         DEBUGP("Applying relocate section %u to %u\n",
>                relsec, sechdrs[relsec].sh_info);
> @@ -163,40 +165,60 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>                 case R_X86_64_NONE:
>                         break;
>                 case R_X86_64_64:
> -                       if (*(u64 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 8);
> +                       if (apply) {
> +                               if (*(u64 *)loc != 0)
> +                                       goto invalid_relocation;
> +                               write(loc, &val, 8);
> +                       } else {
> +                               write(loc, &zero, 8);
> +                       }
>                         break;
>                 case R_X86_64_32:
> -                       if (*(u32 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 4);
> -                       if (val != *(u32 *)loc)
> -                               goto overflow;
> +                       if (apply) {
> +                               if (*(u32 *)loc != 0)
> +                                       goto invalid_relocation;
> +                               write(loc, &val, 4);
> +                               if (val != *(u32 *)loc)
> +                                       goto overflow;
> +                       } else {
> +                               write(loc, &zero, 4);
> +                       }
>                         break;
>                 case R_X86_64_32S:
> -                       if (*(s32 *)loc != 0)
> -                               goto invalid_relocation;
> -                       write(loc, &val, 4);
> -                       if ((s64)val != *(s32 *)loc)
> -                               goto overflow;
> +                       if (apply) {
> +                               if (*(s32 *)loc != 0)
> +                                       goto invalid_relocation;
> +                               write(loc, &val, 4);
> +                               if ((s64)val != *(s32 *)loc)
> +                                       goto overflow;
> +                       } else {
> +                               write(loc, &zero, 4);
> +                       }
>                         break;
>                 case R_X86_64_PC32:
>                 case R_X86_64_PLT32:
> -                       if (*(u32 *)loc != 0)
> -                               goto invalid_relocation;
> -                       val -= (u64)loc;
> -                       write(loc, &val, 4);
> +                       if (apply) {
> +                               if (*(u32 *)loc != 0)
> +                                       goto invalid_relocation;
> +                               val -= (u64)loc;
> +                               write(loc, &val, 4);
>  #if 0
> -                       if ((s64)val != *(s32 *)loc)
> -                               goto overflow;
> +                               if ((s64)val != *(s32 *)loc)
> +                                       goto overflow;
>  #endif
> +                       } else {
> +                               write(loc, &zero, 4);
> +                       }
>                         break;
>                 case R_X86_64_PC64:
> -                       if (*(u64 *)loc != 0)
> -                               goto invalid_relocation;
> -                       val -= (u64)loc;
> -                       write(loc, &val, 8);
> +                       if (apply) {
> +                               if (*(u64 *)loc != 0)
> +                                       goto invalid_relocation;
> +                               val -= (u64)loc;
> +                               write(loc, &val, 8);
> +                       } else {
> +                               write(loc, &zero, 8);
> +                       }
>                         break;
>                 default:
>                         pr_err("%s: Unknown rela relocation: %llu\n",
> @@ -219,11 +241,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
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
> @@ -234,8 +257,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
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
> @@ -245,6 +268,27 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
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
> +
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
> index 9e09d11ffe5b..958e6da7f475 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -72,6 +72,13 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
>                        unsigned int symindex,
>                        unsigned int relsec,
>                        struct module *mod);
> +#ifdef CONFIG_LIVEPATCH
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
> index 9ada0bc5247b..8cd04643f988 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -261,6 +261,41 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>         return 0;
>  }
>
> +static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +                                   const char *shstrtab, const char *strtab,
> +                                   unsigned int symndx, unsigned int secndx,
> +                                   const char *objname, bool apply)
> +{
> +       int cnt, ret;
> +       char sec_objname[MODULE_NAME_LEN];
> +       Elf_Shdr *sec = sechdrs + secndx;
> +
> +       /*
> +        * Format: .klp.rela.sec_objname.section_name
> +        * See comment in klp_resolve_symbols() for an explanation
> +        * of the selected field width value.
> +        */
> +       cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> +                    sec_objname);
> +       if (cnt != 1) {
> +               pr_err("section %s has an incorrectly formatted name\n",
> +                      shstrtab + sec->sh_name);
> +               return -EINVAL;
> +       }
> +
> +       if (strcmp(objname ? objname : "vmlinux", sec_objname))
> +               return 0;
> +
> +       ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> +       if (ret)
> +               return ret;
> +
> +       if (apply)
> +               return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +       clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +       return 0;
> +}
> +
>  /*
>   * At a high-level, there are two types of klp relocation sections: those which
>   * reference symbols which live in vmlinux; and those which reference symbols
> @@ -289,31 +324,8 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>                              unsigned int symndx, unsigned int secndx,
>                              const char *objname)
>  {
> -       int cnt, ret;
> -       char sec_objname[MODULE_NAME_LEN];
> -       Elf_Shdr *sec = sechdrs + secndx;
> -
> -       /*
> -        * Format: .klp.rela.sec_objname.section_name
> -        * See comment in klp_resolve_symbols() for an explanation
> -        * of the selected field width value.
> -        */
> -       cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> -                    sec_objname);
> -       if (cnt != 1) {
> -               pr_err("section %s has an incorrectly formatted name\n",
> -                      shstrtab + sec->sh_name);
> -               return -EINVAL;
> -       }
> -
> -       if (strcmp(objname ? objname : "vmlinux", sec_objname))
> -               return 0;
> -
> -       ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> -       if (ret)
> -               return ret;
> -
> -       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +       return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> +                                       secndx, objname, true);
>  }
>
>  /*
> @@ -762,8 +774,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
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
> @@ -774,10 +787,10 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
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
> @@ -785,6 +798,18 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
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
> @@ -1172,7 +1197,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
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
