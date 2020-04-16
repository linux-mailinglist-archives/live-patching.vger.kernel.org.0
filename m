Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0033C1ABBD3
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503051AbgDPI4V (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 04:56:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:40456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502931AbgDPI4H (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 04:56:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EB20AC4D;
        Thu, 16 Apr 2020 08:56:03 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:56:02 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH 4/7] s390/module: Use s390_kernel_write() for
 relocations
In-Reply-To: <e7f2ad87cf83dcdaa7b69b4e37c11fa355bdfe78.1586881704.git.jpoimboe@redhat.com>
Message-ID: <alpine.LSU.2.21.2004161047410.10475@pobox.suse.cz>
References: <cover.1586881704.git.jpoimboe@redhat.com> <e7f2ad87cf83dcdaa7b69b4e37c11fa355bdfe78.1586881704.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 14 Apr 2020, Josh Poimboeuf wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Instead of playing games with module_{dis,en}able_ro(), use existing
> text poking mechanisms to apply relocations after module loading.
> 
> So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
> two also have STRICT_MODULE_RWX.
> 
> This will allow removal of the last module_disable_ro() usage in
> livepatch.  The ultimate goal is to completely disallow making
> executable mappings writable.
> 
> [ jpoimboe: Split up patches. Use mod state to determine whether
> 	    memcpy() can be used. ]
> 
> Cc: linux-s390@vger.kernel.org
> Cc: heiko.carstens@de.ibm.com
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/s390/kernel/module.c | 106 ++++++++++++++++++++++----------------
>  1 file changed, 61 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> index ba8f19bb438b..e85e378f876e 100644
> --- a/arch/s390/kernel/module.c
> +++ b/arch/s390/kernel/module.c
> @@ -174,7 +174,8 @@ int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
>  }
>  
>  static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
> -			   int sign, int bits, int shift)
> +			   int sign, int bits, int shift,
> +			   void (*write)(void *dest, const void *src, size_t len))
>  {
>  	unsigned long umax;
>  	long min, max;
> @@ -194,26 +195,29 @@ static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
>  			return -ENOEXEC;
>  	}
>  
> -	if (bits == 8)
> -		*(unsigned char *) loc = val;
> -	else if (bits == 12)
> -		*(unsigned short *) loc = (val & 0xfff) |
> +	if (bits == 8) {
> +		write(loc, &val, 1);
> +	} else if (bits == 12) {
> +		unsigned short tmp = (val & 0xfff) |
>  			(*(unsigned short *) loc & 0xf000);
> -	else if (bits == 16)
> -		*(unsigned short *) loc = val;
> -	else if (bits == 20)
> -		*(unsigned int *) loc = (val & 0xfff) << 16 |
> -			(val & 0xff000) >> 4 |
> -			(*(unsigned int *) loc & 0xf00000ff);
> -	else if (bits == 32)
> -		*(unsigned int *) loc = val;
> -	else if (bits == 64)
> -		*(unsigned long *) loc = val;
> +		write(loc, &tmp, 2);
> +	} else if (bits == 16) {
> +		write(loc, &val, 2);
> +	} else if (bits == 20) {
> +		unsigned int tmp = (val & 0xfff) << 16 |
> +			(val & 0xff000) >> 4 | (*(unsigned int *) loc & 0xf00000ff);
> +		write(loc, &tmp, 4);
> +	} else if (bits == 32) {
> +		write(loc, &val, 4);
> +	} else if (bits == 64) {
> +		write(loc, &val, 8);
> +	}
>  	return 0;
>  }

The compiler complains about the above changes

arch/s390/kernel/module.c:199:9: warning: passing argument 1 of 'write' makes pointer from integer without a cast [-Wint-conversion]
   write(loc, &val, 1);
         ^~~
arch/s390/kernel/module.c:199:9: note: expected 'void *' but argument is of type 'Elf64_Addr' {aka 'long long unsigned int'}

[...]  

> -int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> +static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>  		       unsigned int symindex, unsigned int relsec,
> -		       struct module *me)
> +		       struct module *me,
> +		       void (*write)(void *dest, const void *src, size_t len))
>  {
>  	Elf_Addr base;
>  	Elf_Sym *symtab;

You also need to update apply_rela() call site in this function. It is 
missing write argument.

> @@ -437,6 +442,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>  	return 0;
>  }
>  
> +int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> +		       unsigned int symindex, unsigned int relsec,
> +		       struct module *me)
> +{
> +	int ret;

ret is unused;

> +	bool early = me->state == MODULE_STATE_UNFORMED;
> +
> +	return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +				    early ? memcpy : s390_kernel_write);

The compiler warns about

arch/s390/kernel/module.c: In function 'apply_relocate_add':
arch/s390/kernel/module.c:453:24: warning: pointer type mismatch in conditional expression
         early ? memcpy : s390_kernel_write);

Miroslav
