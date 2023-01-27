Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA17967E705
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 14:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjA0Nrs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 08:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjA0Nrs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 08:47:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D673FF24
        for <live-patching@vger.kernel.org>; Fri, 27 Jan 2023 05:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674827219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aSK25cEHb3gnxXUJdSUuNT8tA/JfjwB0tzogcFkaczc=;
        b=HOdBKlqYi/s60K/9GPT9MaTstKyQqsbw864Kosa6bBP++KbabHK+avAeuvTdM4HHJ3PYHE
        DbXpzzv3QtXc1zVx7APTGHLIieFz1MfGNLcgBW3Xjh4nzy3+OdnJtT/SIN77lwy3kieWVO
        eecMcDZzxllftbGHi3eN6+teH2blbkE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-Q9jqAfS3Nt-JJuOwDo6xnw-1; Fri, 27 Jan 2023 08:46:56 -0500
X-MC-Unique: Q9jqAfS3Nt-JJuOwDo6xnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A727C3C01DF6;
        Fri, 27 Jan 2023 13:46:55 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D4DE40C141B;
        Fri, 27 Jan 2023 13:46:55 +0000 (UTC)
Date:   Fri, 27 Jan 2023 08:46:53 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v11 2/2] livepatch,x86: Clear relocation targets on a
 module removal
Message-ID: <Y9PVzSoBORI2KKyR@redhat.com>
References: <20230125185401.279042-1-song@kernel.org>
 <20230125185401.279042-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125185401.279042-2-song@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 10:54:01AM -0800, Song Liu wrote:
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
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> ---
> 
> NOTE: powerpc32 code is only compile tested.
> 
> Changes v10 => v11:
> 1. Do not initialize "size" in __write_relocate_add(). (Petr Mladek)
> 2. Use __weak clear_relocate_add(). (Christophe Leroy)
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
>  arch/x86/kernel/module.c     | 93 +++++++++++++++++++++++-------------
>  include/linux/moduleloader.h | 17 +++++++
>  kernel/livepatch/core.c      | 62 +++++++++++++++++++-----
>  3 files changed, 126 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index 1dee3ad82da2..84ad0e61ba6e 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -129,22 +129,27 @@ int apply_relocate(Elf32_Shdr *sechdrs,
>  	return 0;
>  }
>  #else /*X86_64*/
> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> +static int __write_relocate_add(Elf64_Shdr *sechdrs,
>  		   const char *strtab,
>  		   unsigned int symindex,
>  		   unsigned int relsec,
>  		   struct module *me,
> -		   void *(*write)(void *dest, const void *src, size_t len))
> +		   void *(*write)(void *dest, const void *src, size_t len),
> +		   bool apply)
>  {
>  	unsigned int i;
>  	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
>  	Elf64_Sym *sym;
>  	void *loc;
>  	u64 val;
> +	u64 zero = 0ULL;
>  
> -	DEBUGP("Applying relocate section %u to %u\n",
> +	DEBUGP("%s relocate section %u to %u\n",
> +	       apply ? "Applying" : "Clearing",
>  	       relsec, sechdrs[relsec].sh_info);
>  	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
> +		size_t size;
> +
>  		/* This is where to make the change */
>  		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
>  			+ rel[i].r_offset;
> @@ -162,52 +167,53 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>  
>  		switch (ELF64_R_TYPE(rel[i].r_info)) {
>  		case R_X86_64_NONE:
> -			break;
> +			continue;  /* nothing to write */
>  		case R_X86_64_64:
> -			if (*(u64 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 8);
> +			size = 8;
>  			break;
>  		case R_X86_64_32:
> -			if (*(u32 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 4);
> -			if (val != *(u32 *)loc)
> +			if (val != *(u32 *)&val)
>  				goto overflow;
> +			size = 4;
>  			break;
>  		case R_X86_64_32S:
> -			if (*(s32 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 4);
> -			if ((s64)val != *(s32 *)loc)
> +			if ((s64)val != *(s32 *)&val)
>  				goto overflow;
> +			size = 4;
>  			break;
>  		case R_X86_64_PC32:
>  		case R_X86_64_PLT32:
> -			if (*(u32 *)loc != 0)
> -				goto invalid_relocation;
>  			val -= (u64)loc;
> -			write(loc, &val, 4);
> +			size = 4;
>  			break;
>  		case R_X86_64_PC64:
> -			if (*(u64 *)loc != 0)
> -				goto invalid_relocation;
>  			val -= (u64)loc;
> -			write(loc, &val, 8);
> +			size = 8;
>  			break;
>  		default:
>  			pr_err("%s: Unknown rela relocation: %llu\n",
>  			       me->name, ELF64_R_TYPE(rel[i].r_info));
>  			return -ENOEXEC;
>  		}
> +
> +		if (apply) {
> +			if (memcmp(loc, &zero, size)) {
> +				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
> +				       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> +				return -ENOEXEC;
> +			}
> +			write(loc, &val, size);
> +		} else {
> +			if (memcmp(loc, &val, size)) {
> +				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
> +					(int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> +				return -ENOEXEC;
> +			}
> +			write(loc, &zero, size);
> +		}
>  	}
>  	return 0;
>  
> -invalid_relocation:
> -	pr_err("x86/modules: Skipping invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
> -	       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> -	return -ENOEXEC;
> -
>  overflow:
>  	pr_err("overflow in relocation type %d val %Lx\n",
>  	       (int)ELF64_R_TYPE(rel[i].r_info), val);
> @@ -216,11 +222,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>  	return -ENOEXEC;
>  }
>  
> -int apply_relocate_add(Elf64_Shdr *sechdrs,
> -		   const char *strtab,
> -		   unsigned int symindex,
> -		   unsigned int relsec,
> -		   struct module *me)
> +static int write_relocate_add(Elf64_Shdr *sechdrs,
> +			      const char *strtab,
> +			      unsigned int symindex,
> +			      unsigned int relsec,
> +			      struct module *me,
> +			      bool apply)
>  {
>  	int ret;
>  	bool early = me->state == MODULE_STATE_UNFORMED;
> @@ -231,8 +238,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  		mutex_lock(&text_mutex);
>  	}
>  
> -	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> -				   write);
> +	ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +				   write, apply);
>  
>  	if (!early) {
>  		text_poke_sync();
> @@ -242,6 +249,26 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  	return ret;
>  }
>  
> +int apply_relocate_add(Elf64_Shdr *sechdrs,
> +		   const char *strtab,
> +		   unsigned int symindex,
> +		   unsigned int relsec,
> +		   struct module *me)
> +{
> +	return write_relocate_add(sechdrs, strtab, symindex, relsec, me, true);
> +}
> +
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> +			const char *strtab,
> +			unsigned int symindex,
> +			unsigned int relsec,
> +			struct module *me)
> +{
> +	write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);
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
>  		       unsigned int symindex,
>  		       unsigned int relsec,
>  		       struct module *mod);
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
> +		   const char *strtab,
> +		   unsigned int symindex,
> +		   unsigned int relsec,
> +		   struct module *me);
> +#endif
>  #else
>  static inline int apply_relocate_add(Elf_Shdr *sechdrs,
>  				     const char *strtab,
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 201f0c0482fb..140997b36025 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -268,6 +268,14 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  	return 0;
>  }
>  
> +void __weak clear_relocate_add(Elf_Shdr *sechdrs,
> +		   const char *strtab,
> +		   unsigned int symindex,
> +		   unsigned int relsec,
> +		   struct module *me)
> +{
> +}
> +
>  /*
>   * At a high-level, there are two types of klp relocation sections: those which
>   * reference symbols which live in vmlinux; and those which reference symbols
> @@ -291,10 +299,10 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>   *    the to-be-patched module to be loaded and patched sometime *after* the
>   *    klp module is loaded.
>   */
> -int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> -			     const char *shstrtab, const char *strtab,
> -			     unsigned int symndx, unsigned int secndx,
> -			     const char *objname)
> +static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +				    const char *shstrtab, const char *strtab,
> +				    unsigned int symndx, unsigned int secndx,
> +				    const char *objname, bool apply)
>  {
>  	int cnt, ret;
>  	char sec_objname[MODULE_NAME_LEN];
> @@ -316,11 +324,26 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>  	if (strcmp(objname ? objname : "vmlinux", sec_objname))
>  		return 0;
>  
> -	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> -	if (ret)
> -		return ret;
> +	if (apply) {
> +		ret = klp_resolve_symbols(sechdrs, strtab, symndx,
> +					  sec, sec_objname);
> +		if (ret)
> +			return ret;
> +
> +		return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +	}
> +
> +	clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +	return 0;
> +}
>  
> -	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +			     const char *shstrtab, const char *strtab,
> +			     unsigned int symndx, unsigned int secndx,
> +			     const char *objname)
> +{
> +	return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> +					secndx, objname, true);
>  }
>  
>  /*
> @@ -769,8 +792,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  			   func->old_sympos ? func->old_sympos : 1);
>  }
>  
> -static int klp_apply_object_relocs(struct klp_patch *patch,
> -				   struct klp_object *obj)
> +static int klp_write_object_relocs(struct klp_patch *patch,
> +				   struct klp_object *obj,
> +				   bool apply)
>  {
>  	int i, ret;
>  	struct klp_modinfo *info = patch->mod->klp_info;
> @@ -781,10 +805,10 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>  		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
>  			continue;
>  
> -		ret = klp_apply_section_relocs(patch->mod, info->sechdrs,
> +		ret = klp_write_section_relocs(patch->mod, info->sechdrs,
>  					       info->secstrings,
>  					       patch->mod->core_kallsyms.strtab,
> -					       info->symndx, i, obj->name);
> +					       info->symndx, i, obj->name, apply);
>  		if (ret)
>  			return ret;
>  	}
> @@ -792,6 +816,18 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>  	return 0;
>  }
>  
> +static int klp_apply_object_relocs(struct klp_patch *patch,
> +				   struct klp_object *obj)
> +{
> +	return klp_write_object_relocs(patch, obj, true);
> +}
> +
> +static void klp_clear_object_relocs(struct klp_patch *patch,
> +				    struct klp_object *obj)
> +{
> +	klp_write_object_relocs(patch, obj, false);
> +}
> +
>  /* parts of the initialization that is done only when the object is loaded */
>  static int klp_init_object_loaded(struct klp_patch *patch,
>  				  struct klp_object *obj)
> @@ -1179,7 +1215,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
>  			klp_unpatch_object(obj);
>  
>  			klp_post_unpatch_callback(obj);
> -
> +			klp_clear_object_relocs(patch, obj);
>  			klp_free_object_loaded(obj);
>  			break;
>  		}
> -- 
> 2.30.2
> 

Reviewed-and-tested-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe

