Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E62D62E7BC
	for <lists+live-patching@lfdr.de>; Thu, 17 Nov 2022 23:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiKQWH2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Nov 2022 17:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbiKQWHM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Nov 2022 17:07:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F4274CFE;
        Thu, 17 Nov 2022 14:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC905CE1F67;
        Thu, 17 Nov 2022 22:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC34C433B5;
        Thu, 17 Nov 2022 22:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668722807;
        bh=xsaepc7zrHeiaxqJ99aKuvc3jgRcvS86nP1WzqMV8jw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MdsvT1wVx/V5LmEKxToxtewAEZMIayQD7XJ72/P88rlAN0JRlphUNueuyF5WdD54b
         MYTC44+zeU52n9KJxt02qDNYabHN0dpJivv4966Pt972spVc0G6WcN4+y5kFq+ujnN
         5a2ULPI/W1MFQyXZtonR5Z0L/jdBfq9XABeczticsItPXKW6RUgELrYjnbualsA0KK
         rtOKg8sPsGsZ6Hq0d4teJWNUrFk4g+q8oqOCqSwyw8Qr8coi/b1mH9WvDiOqZydzhE
         iba0PM+gH9D6OJdeoBkm4bJfhZeAmYlEhHlTgZOJwcrFpKHlkfRd6g9Fx5qFe/n0Ko
         0FTdsvUWfQeFw==
Received: by mail-ej1-f51.google.com with SMTP id f18so8604102ejz.5;
        Thu, 17 Nov 2022 14:06:47 -0800 (PST)
X-Gm-Message-State: ANoB5pkDBOBKrIkvauJ3CfdpRfApCYb5Xy6BAgmS9zllPfyNJQ/anIWf
        Sem58DlSnvkRQkAhdbWLgBPoet4/VEWuWA4CY0M=
X-Google-Smtp-Source: AA0mqf5BOFW1Wno15LQFILchmFZf33Kcq3irHyykuYmt1xPuWgPSCzg+NKiM61LVhFymFp1IGCke7SkHtPN9nXnBHUc=
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id
 i5-20020a170906264500b00781d0c14434mr3693058ejc.756.1668722804839; Thu, 17
 Nov 2022 14:06:44 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org>
In-Reply-To: <20220901171252.2148348-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Nov 2022 14:06:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5cnJwTN216tG_xNSA-DidW5nFB2EnU0QSBGmDckfUoCw@mail.gmail.com>
Message-ID: <CAPhsuW5cnJwTN216tG_xNSA-DidW5nFB2EnU0QSBGmDckfUoCw@mail.gmail.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module removal
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, x86@kernel.org, joe.lawrence@redhat.com,
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

Hi folks,

It seems we forgot about this work... What shall we do to move forward?

Thanks,
Song

On Thu, Sep 1, 2022 at 10:16 AM Song Liu <song@kernel.org> wrote:
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
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
>
> ---
>
> NOTE: powerpc32 code is only compile tested.
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
>  arch/powerpc/kernel/module_32.c |  10 ++++
>  arch/powerpc/kernel/module_64.c |  49 +++++++++++++++
>  arch/s390/kernel/module.c       |   8 +++
>  arch/x86/kernel/module.c        | 102 +++++++++++++++++++++++---------
>  include/linux/moduleloader.h    |   7 +++
>  kernel/livepatch/core.c         |  41 ++++++++++++-
>  6 files changed, 189 insertions(+), 28 deletions(-)
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
> index 7e45dc98df8a..514951f97391 100644
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -739,6 +739,55 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
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
> +               instruction = (u32 *)location;
> +               if (is_mprofile_ftrace_call(symname))
> +                       continue;
> +
> +               if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> +                       continue;
> +
> +               instruction += 1;
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
> index b1abf663417c..f9632afbb84c 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -128,18 +128,20 @@ int apply_relocate(Elf32_Shdr *sechdrs,
>         return 0;
>  }
>  #else /*X86_64*/
> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> +static int __apply_clear_relocate_add(Elf64_Shdr *sechdrs,
>                    const char *strtab,
>                    unsigned int symindex,
>                    unsigned int relsec,
>                    struct module *me,
> -                  void *(*write)(void *dest, const void *src, size_t len))
> +                  void *(*write)(void *dest, const void *src, size_t len),
> +                  bool clear)
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
> +                       if (!clear) {
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
> +                       if (!clear) {
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
> +                       if (!clear) {
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
> +                       if (!clear) {
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
> +                       if (!clear) {
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
> @@ -234,8 +256,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>                 mutex_lock(&text_mutex);
>         }
>
> -       ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> -                                  write);
> +       ret = __apply_clear_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +                                        write, false /* clear */);
>
>         if (!early) {
>                 text_poke_sync();
> @@ -245,6 +267,32 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>         return ret;
>  }
>
> +#ifdef CONFIG_LIVEPATCH
> +
> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> +                       const char *strtab,
> +                       unsigned int symindex,
> +                       unsigned int relsec,
> +                       struct module *me)
> +{
> +       bool early = me->state == MODULE_STATE_UNFORMED;
> +       void *(*write)(void *, const void *, size_t) = memcpy;
> +
> +       if (!early) {
> +               write = text_poke;
> +               mutex_lock(&text_mutex);
> +       }
> +
> +       __apply_clear_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +                                  write, true /* clear */);
> +
> +       if (!early) {
> +               text_poke_sync();
> +               mutex_unlock(&text_mutex);
> +       }
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
> index bc475e62279d..5c0d8a4eba13 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>         return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
>  }
>
> +static void klp_clear_object_relocations(struct module *pmod,
> +                                       struct klp_object *obj)
> +{
> +       int i, cnt;
> +       const char *objname, *secname;
> +       char sec_objname[MODULE_NAME_LEN];
> +       Elf_Shdr *sec;
> +
> +       objname = klp_is_module(obj) ? obj->name : "vmlinux";
> +
> +       /* For each klp relocation section */
> +       for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> +               sec = pmod->klp_info->sechdrs + i;
> +               secname = pmod->klp_info->secstrings + sec->sh_name;
> +               if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> +                       continue;
> +
> +               /*
> +                * Format: .klp.rela.sec_objname.section_name
> +                * See comment in klp_resolve_symbols() for an explanation
> +                * of the selected field width value.
> +                */
> +               secname = pmod->klp_info->secstrings + sec->sh_name;
> +               cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> +               if (cnt != 1) {
> +                       pr_err("section %s has an incorrectly formatted name\n",
> +                              secname);
> +                       continue;
> +               }
> +
> +               if (strcmp(objname, sec_objname))
> +                       continue;
> +
> +               clear_relocate_add(pmod->klp_info->sechdrs,
> +                                  pmod->core_kallsyms.strtab,
> +                                  pmod->klp_info->symndx, i, pmod);
> +       }
> +}
> +
>  /*
>   * Sysfs Interface
>   *
> @@ -1154,7 +1193,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
>                         klp_unpatch_object(obj);
>
>                         klp_post_unpatch_callback(obj);
> -
> +                       klp_clear_object_relocations(patch->mod, obj);
>                         klp_free_object_loaded(obj);
>                         break;
>                 }
> --
> 2.30.2
>
