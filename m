Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA70119DD4F
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2020 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDCSAo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Apr 2020 14:00:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404096AbgDCSAo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Apr 2020 14:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585936843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NiMkDJ11j6iIzUVzg7SnDb83MwqOSNwZhS3zwBcV2Y=;
        b=hN9VkTQM3tm9TXXC2p8vz+CUgs3atGQf8E3vT21f97fGs6QGp0dbujPYnkmUgUt3gXLdiH
        FxLut6MxOi0XHLK//rLExyd7ULs3oDxB1DrNRKperWaD3pYpQxRZiz8wtGDI8SSaL4uRim
        vo95/ojYQTVTwexeTZkscNKl2k6SXbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-YokxTUBLPHi7KLMQlFoTWQ-1; Fri, 03 Apr 2020 14:00:39 -0400
X-MC-Unique: YokxTUBLPHi7KLMQlFoTWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8665F801E66;
        Fri,  3 Apr 2020 18:00:37 +0000 (UTC)
Received: from redhat.com (ovpn-114-27.phx2.redhat.com [10.3.114.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F27F60BF3;
        Fri,  3 Apr 2020 18:00:36 +0000 (UTC)
Date:   Fri, 3 Apr 2020 14:00:34 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 20/23] module/livepatch: Relocate local variables in the
 module loaded when the livepatch is being loaded
Message-ID: <20200403180034.GB30284@redhat.com>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-21-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117150323.21801-21-pmladek@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 17, 2020 at 04:03:20PM +0100, Petr Mladek wrote:
> The special SHF_RELA_LIVEPATCH section is still needed to find static
> (non-exported) symbols. But it can be done together with the other
> relocations when the livepatch module is being loaded.
> 
> There is no longer needed to copy the info section. The related
> code in the module loaded will get removed in separate patch.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/livepatch.h |  4 +++
>  kernel/livepatch/core.c   | 62 +++--------------------------------------------
>  kernel/module.c           | 16 +++++++-----
>  3 files changed, 18 insertions(+), 64 deletions(-)
> 
> 
> [ ... snip ... ]
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index bd92854b42c2..c14b5135db27 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2410,16 +2410,20 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> -		/* Livepatch relocation sections are applied by livepatch */
> -		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> -			continue;
> -
> -		if (info->sechdrs[i].sh_type == SHT_REL)
> +		/* Livepatch need to resolve static symbols. */
> +		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH) {
> +			err = klp_resolve_symbols(info->sechdrs, i, mod);
> +			if (err < 0)
> +				break;
> +			err = apply_relocate_add(info->sechdrs, info->strtab,
> +						 info->index.sym, i, mod);
> +		} else if (info->sechdrs[i].sh_type == SHT_REL) {
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
> -		else if (info->sechdrs[i].sh_type == SHT_RELA)
> +		} else if (info->sechdrs[i].sh_type == SHT_RELA) {
>  			err = apply_relocate_add(info->sechdrs, info->strtab,
>  						 info->index.sym, i, mod);
> +		}
>  		if (err < 0)
>  			break;
>  	}


Hi Petr,

At first I thought there was a simple order of operations problem here
with respect to klp_resolve_symbols() accessing core_kallsyms before
they were setup by add_kallsyms():

load_module
  apply_relocations

 	/* Livepatch need to resolve static symbols. */
 	if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH) {
 		err = klp_resolve_symbols(info->sechdrs, i, mod);

    klp_resolve_symbols

	sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
                    ^^^^^^^^^^^^^^^^^^^^
                                  used before init (below)
  ...
  post_relocation
    add_kallsyms

        /*
         * Now populate the cut down core kallsyms for after init
         * and set types up while we still have access to sections.
         */
        mod->core_kallsyms.symtab = dst = mod->core_layout.base + info->symoffs;
        mod->core_kallsyms.strtab = s = mod->core_layout.base + info->stroffs;
        mod->core_kallsyms.typetab = mod->core_layout.base + info->core_typeoffs;
             ^^^^^^^^^^^^^^^^^^^^^
                           core_kallsyms initialized here

But after tinkering with the patchset, a larger problem is that
klp_resolve_symbols() writes st_values to the core_kallsyms copies, but
then apply_relocate_add() references the originals in the load_info
structure.

I assume that klp_resolve_symbols() originally looked at the
core_kallsyms copies for handling the late module patching case.  If we
no longer need to support that, then how about this slight modification
to klp_resolve_symbols() to make it look more the like
apply_relocate{_add,} calls?

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 3b27ef1a7291..54d5a4045e5a 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -210,6 +210,8 @@ int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
 int klp_resolve_symbols(Elf_Shdr *sechdrs,
+			const char *strtab,
+			unsigned int symindex,
 			unsigned int relsec,
 			struct module *pmod);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index cc0ac93fe8cd..02638e3b09b0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -197,13 +197,14 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 }
 
 int klp_resolve_symbols(Elf_Shdr *sechdrs,
+			const char *strtab,
+			unsigned int symindex,
 			unsigned int relsec,
 			struct module *pmod)
 {
 	int i, cnt, vmlinux, ret;
 	char objname[MODULE_NAME_LEN];
 	char symname[KSYM_NAME_LEN];
-	char *strtab = pmod->core_kallsyms.strtab;
 	Elf_Shdr *relasec = sechdrs + relsec;
 	Elf_Rela *relas;
 	Elf_Sym *sym;
@@ -224,7 +225,8 @@ int klp_resolve_symbols(Elf_Shdr *sechdrs,
 	relas = (Elf_Rela *) relasec->sh_addr;
 	/* For each rela in this klp relocation section */
 	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
-		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
+		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr +
+			ELF_R_SYM(relas[i].r_info);
 		if (sym->st_shndx != SHN_LIVEPATCH) {
 			pr_err("symbol %s is not marked as a livepatch symbol\n",
 			       strtab + sym->st_name);
diff --git a/kernel/module.c b/kernel/module.c
index d435bad80d7d..a65f089f19c9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2320,7 +2320,8 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 
 		/* Livepatch need to resolve static symbols. */
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH) {
-			err = klp_resolve_symbols(info->sechdrs, i, mod);
+			err = klp_resolve_symbols(info->sechdrs, info->strtab,
+						  info->index.sym, i, mod);
 			if (err < 0)
 				break;
 			err = apply_relocate_add(info->sechdrs, info->strtab,

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--


-- Joe

