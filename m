Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952A64848A9
	for <lists+live-patching@lfdr.de>; Tue,  4 Jan 2022 20:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiADTf1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 Jan 2022 14:35:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230041AbiADTfZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 Jan 2022 14:35:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641324925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M31283hPor/SMg1Hu2xm9ZT/xhUO7KMLt4Ra3PtJ46g=;
        b=a0fdr4g5fmZGIvdmI9LAfwHDa2+tPVp37rw+4vwJyAo9KaUfhzbU/LniyTBMpuQzmdSV8/
        CAQbIQyUG1x2V4lqIpXgAkd08KtC9iRBBv1e5L32QeRsiBMCaK37bI8Oe/3I4aIj5UzIeE
        Z6pl+PtFGoJwJK7wuDmBEFifTpavbfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-cGMCxWdAPTeBu14WgwCJ3g-1; Tue, 04 Jan 2022 14:35:22 -0500
X-MC-Unique: cGMCxWdAPTeBu14WgwCJ3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40F8181CCB4;
        Tue,  4 Jan 2022 19:35:20 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 911E95BE04;
        Tue,  4 Jan 2022 19:35:15 +0000 (UTC)
Date:   Tue, 4 Jan 2022 14:35:13 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] livepatch: Fix build failure on 32 bits
 processors
Message-ID: <YdShcXQwOaQnylo6@redhat.com>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu>
 <5288e11b018a762ea3351cc8fb2d4f15093a4457.1640017960.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5288e11b018a762ea3351cc8fb2d4f15093a4457.1640017960.git.christophe.leroy@csgroup.eu>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Dec 20, 2021 at 04:38:02PM +0000, Christophe Leroy wrote:
> Trying to build livepatch on powerpc/32 results in:
> 
> 	kernel/livepatch/core.c: In function 'klp_resolve_symbols':
> 	kernel/livepatch/core.c:221:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 	  221 |                 sym = (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
> 	      |                       ^
> 	kernel/livepatch/core.c:221:21: error: assignment to 'Elf32_Sym *' {aka 'struct elf32_sym *'} from incompatible pointer type 'Elf64_Sym *' {aka 'struct elf64_sym *'} [-Werror=incompatible-pointer-types]
> 	  221 |                 sym = (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
> 	      |                     ^
> 	kernel/livepatch/core.c: In function 'klp_apply_section_relocs':
> 	kernel/livepatch/core.c:312:35: error: passing argument 1 of 'klp_resolve_symbols' from incompatible pointer type [-Werror=incompatible-pointer-types]
> 	  312 |         ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> 	      |                                   ^~~~~~~
> 	      |                                   |
> 	      |                                   Elf32_Shdr * {aka struct elf32_shdr *}
> 	kernel/livepatch/core.c:193:44: note: expected 'Elf64_Shdr *' {aka 'struct elf64_shdr *'} but argument is of type 'Elf32_Shdr *' {aka 'struct elf32_shdr *'}
> 	  193 | static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
> 	      |                                ~~~~~~~~~~~~^~~~~~~
> 
> Fix it by using the right types instead of forcing 64 bits types.
> 
> Fixes: 7c8e2bdd5f0d ("livepatch: Apply vmlinux-specific KLP relocations early")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Acked-by: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 335d988bd811..c0789383807b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -190,7 +190,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  	return -EINVAL;
>  }
>  
> -static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
> +static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  			       unsigned int symndx, Elf_Shdr *relasec,
>  			       const char *sec_objname)
>  {
> @@ -218,7 +218,7 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
>  	relas = (Elf_Rela *) relasec->sh_addr;
>  	/* For each rela in this klp relocation section */
>  	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
> -		sym = (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
> +		sym = (Elf_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
>  		if (sym->st_shndx != SHN_LIVEPATCH) {
>  			pr_err("symbol %s is not marked as a livepatch symbol\n",
>  			       strtab + sym->st_name);
> -- 
> 2.33.1
> 

Thanks for finding and fixing, lgtm.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe

