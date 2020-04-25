Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733761B8616
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2020 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDYLPN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 25 Apr 2020 07:15:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38006 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgDYLPK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 25 Apr 2020 07:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587813307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CXUnrwtYNj3as8RrOscnEqejiquib4QQtI0Mdc4uyGk=;
        b=OeLROHGoCx8xaGthyqYqQhsGWxfy6F4EkdCQy6ycwRMjY3INwHSu4R1onRLv3r9PwoneFV
        IWujtlrBy4v7/nHTXweULT9DmPA9lpYyrn6Y7X4sXtlJe8NnigeSivjclpdK8NxL+F82ZK
        BG+RmvUv/5USfMmhCqm8aDSAQRPXqZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14--Sq1mSXRPMOtxSs_YnMVIg-1; Sat, 25 Apr 2020 07:15:03 -0400
X-MC-Unique: -Sq1mSXRPMOtxSs_YnMVIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53FAD45F;
        Sat, 25 Apr 2020 11:15:02 +0000 (UTC)
Received: from treble (ovpn-114-29.rdu2.redhat.com [10.10.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E987196AE;
        Sat, 25 Apr 2020 11:14:56 +0000 (UTC)
Date:   Sat, 25 Apr 2020 06:14:53 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v3 06/10] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200425111453.pxisvfz32ehsfbqr@treble>
References: <cover.1587812518.git.jpoimboe@redhat.com>
 <318ddaed3f4e861dc16d6726d7877e6509c94ad5.1587812518.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <318ddaed3f4e861dc16d6726d7877e6509c94ad5.1587812518.git.jpoimboe@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Apr 25, 2020 at 06:07:26AM -0500, Josh Poimboeuf wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Because of late module patching, a livepatch module needs to be able to
> apply some of its relocations well after it has been loaded.  Instead of
> playing games with module_{dis,en}able_ro(), use existing text poking
> mechanisms to apply relocations after module loading.
> 
> So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
> two also have STRICT_MODULE_RWX.
> 
> This will allow removal of the last module_disable_ro() usage in
> livepatch.  The ultimate goal is to completely disallow making
> executable mappings writable.
> 
> [ jpoimboe: Split up patches.  Use mod state to determine whether
> 	    memcpy() can be used.  Test and add fixes. ]
> 
> Cc: linux-s390@vger.kernel.org
> Cc: Heiko Carstens heiko.carstens@de.ibm.com

Gah, I somehow messed up the formatting on this Cc, should be

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/s390/kernel/module.c | 147 +++++++++++++++++++++++---------------
>  1 file changed, 88 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> index ba8f19bb438b..4055f1c49814 100644
> --- a/arch/s390/kernel/module.c
> +++ b/arch/s390/kernel/module.c
> @@ -19,6 +19,7 @@
>  #include <linux/kasan.h>
>  #include <linux/moduleloader.h>
>  #include <linux/bug.h>
> +#include <linux/memory.h>
>  #include <asm/alternative.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/facility.h>
> @@ -174,10 +175,12 @@ int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
>  }
>  
>  static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
> -			   int sign, int bits, int shift)
> +			   int sign, int bits, int shift,
> +			   void *(*write)(void *dest, const void *src, size_t len))
>  {
>  	unsigned long umax;
>  	long min, max;
> +	void *dest = (void *)loc;
>  
>  	if (val & ((1UL << shift) - 1))
>  		return -ENOEXEC;
> @@ -194,26 +197,33 @@ static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
>  			return -ENOEXEC;
>  	}
>  
> -	if (bits == 8)
> -		*(unsigned char *) loc = val;
> -	else if (bits == 12)
> -		*(unsigned short *) loc = (val & 0xfff) |
> +	if (bits == 8) {
> +		unsigned char tmp = val;
> +		write(dest, &tmp, 1);
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
> +		write(dest, &tmp, 2);
> +	} else if (bits == 16) {
> +		unsigned short tmp = val;
> +		write(dest, &tmp, 2);
> +	} else if (bits == 20) {
> +		unsigned int tmp = (val & 0xfff) << 16 |
> +			(val & 0xff000) >> 4 | (*(unsigned int *) loc & 0xf00000ff);
> +		write(dest, &tmp, 4);
> +	} else if (bits == 32) {
> +		unsigned int tmp = val;
> +		write(dest, &tmp, 4);
> +	} else if (bits == 64) {
> +		unsigned long tmp = val;
> +		write(dest, &tmp, 8);
> +	}
>  	return 0;
>  }
>  
>  static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
> -		      const char *strtab, struct module *me)
> +		      const char *strtab, struct module *me,
> +		      void *(*write)(void *dest, const void *src, size_t len))
>  {
>  	struct mod_arch_syminfo *info;
>  	Elf_Addr loc, val;
> @@ -241,17 +251,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_64:		/* Direct 64 bit.  */
>  		val += rela->r_addend;
>  		if (r_type == R_390_8)
> -			rc = apply_rela_bits(loc, val, 0, 8, 0);
> +			rc = apply_rela_bits(loc, val, 0, 8, 0, write);
>  		else if (r_type == R_390_12)
> -			rc = apply_rela_bits(loc, val, 0, 12, 0);
> +			rc = apply_rela_bits(loc, val, 0, 12, 0, write);
>  		else if (r_type == R_390_16)
> -			rc = apply_rela_bits(loc, val, 0, 16, 0);
> +			rc = apply_rela_bits(loc, val, 0, 16, 0, write);
>  		else if (r_type == R_390_20)
> -			rc = apply_rela_bits(loc, val, 1, 20, 0);
> +			rc = apply_rela_bits(loc, val, 1, 20, 0, write);
>  		else if (r_type == R_390_32)
> -			rc = apply_rela_bits(loc, val, 0, 32, 0);
> +			rc = apply_rela_bits(loc, val, 0, 32, 0, write);
>  		else if (r_type == R_390_64)
> -			rc = apply_rela_bits(loc, val, 0, 64, 0);
> +			rc = apply_rela_bits(loc, val, 0, 64, 0, write);
>  		break;
>  	case R_390_PC16:	/* PC relative 16 bit.  */
>  	case R_390_PC16DBL:	/* PC relative 16 bit shifted by 1.  */
> @@ -260,15 +270,15 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_PC64:	/* PC relative 64 bit.	*/
>  		val += rela->r_addend - loc;
>  		if (r_type == R_390_PC16)
> -			rc = apply_rela_bits(loc, val, 1, 16, 0);
> +			rc = apply_rela_bits(loc, val, 1, 16, 0, write);
>  		else if (r_type == R_390_PC16DBL)
> -			rc = apply_rela_bits(loc, val, 1, 16, 1);
> +			rc = apply_rela_bits(loc, val, 1, 16, 1, write);
>  		else if (r_type == R_390_PC32DBL)
> -			rc = apply_rela_bits(loc, val, 1, 32, 1);
> +			rc = apply_rela_bits(loc, val, 1, 32, 1, write);
>  		else if (r_type == R_390_PC32)
> -			rc = apply_rela_bits(loc, val, 1, 32, 0);
> +			rc = apply_rela_bits(loc, val, 1, 32, 0, write);
>  		else if (r_type == R_390_PC64)
> -			rc = apply_rela_bits(loc, val, 1, 64, 0);
> +			rc = apply_rela_bits(loc, val, 1, 64, 0, write);
>  		break;
>  	case R_390_GOT12:	/* 12 bit GOT offset.  */
>  	case R_390_GOT16:	/* 16 bit GOT offset.  */
> @@ -283,33 +293,33 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_GOTPLT64:	/* 64 bit offset to jump slot.	*/
>  	case R_390_GOTPLTENT:	/* 32 bit rel. offset to jump slot >> 1. */
>  		if (info->got_initialized == 0) {
> -			Elf_Addr *gotent;
> +			Elf_Addr *gotent = me->core_layout.base +
> +					   me->arch.got_offset +
> +					   info->got_offset;
>  
> -			gotent = me->core_layout.base + me->arch.got_offset +
> -				info->got_offset;
> -			*gotent = val;
> +			write(gotent, &val, sizeof(*gotent));
>  			info->got_initialized = 1;
>  		}
>  		val = info->got_offset + rela->r_addend;
>  		if (r_type == R_390_GOT12 ||
>  		    r_type == R_390_GOTPLT12)
> -			rc = apply_rela_bits(loc, val, 0, 12, 0);
> +			rc = apply_rela_bits(loc, val, 0, 12, 0, write);
>  		else if (r_type == R_390_GOT16 ||
>  			 r_type == R_390_GOTPLT16)
> -			rc = apply_rela_bits(loc, val, 0, 16, 0);
> +			rc = apply_rela_bits(loc, val, 0, 16, 0, write);
>  		else if (r_type == R_390_GOT20 ||
>  			 r_type == R_390_GOTPLT20)
> -			rc = apply_rela_bits(loc, val, 1, 20, 0);
> +			rc = apply_rela_bits(loc, val, 1, 20, 0, write);
>  		else if (r_type == R_390_GOT32 ||
>  			 r_type == R_390_GOTPLT32)
> -			rc = apply_rela_bits(loc, val, 0, 32, 0);
> +			rc = apply_rela_bits(loc, val, 0, 32, 0, write);
>  		else if (r_type == R_390_GOT64 ||
>  			 r_type == R_390_GOTPLT64)
> -			rc = apply_rela_bits(loc, val, 0, 64, 0);
> +			rc = apply_rela_bits(loc, val, 0, 64, 0, write);
>  		else if (r_type == R_390_GOTENT ||
>  			 r_type == R_390_GOTPLTENT) {
>  			val += (Elf_Addr) me->core_layout.base - loc;
> -			rc = apply_rela_bits(loc, val, 1, 32, 1);
> +			rc = apply_rela_bits(loc, val, 1, 32, 1, write);
>  		}
>  		break;
>  	case R_390_PLT16DBL:	/* 16 bit PC rel. PLT shifted by 1.  */
> @@ -320,25 +330,29 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
>  	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
>  		if (info->plt_initialized == 0) {
> -			unsigned int *ip;
> -			ip = me->core_layout.base + me->arch.plt_offset +
> -				info->plt_offset;
> -			ip[0] = 0x0d10e310;	/* basr 1,0  */
> -			ip[1] = 0x100a0004;	/* lg	1,10(1) */
> +			unsigned int insn[5];
> +			unsigned int *ip = me->core_layout.base +
> +					   me->arch.plt_offset +
> +					   info->plt_offset;
> +
> +			insn[0] = 0x0d10e310;	/* basr 1,0  */
> +			insn[1] = 0x100a0004;	/* lg	1,10(1) */
>  			if (IS_ENABLED(CONFIG_EXPOLINE) && !nospec_disable) {
>  				unsigned int *ij;
>  				ij = me->core_layout.base +
>  					me->arch.plt_offset +
>  					me->arch.plt_size - PLT_ENTRY_SIZE;
> -				ip[2] = 0xa7f40000 +	/* j __jump_r1 */
> +				insn[2] = 0xa7f40000 +	/* j __jump_r1 */
>  					(unsigned int)(u16)
>  					(((unsigned long) ij - 8 -
>  					  (unsigned long) ip) / 2);
>  			} else {
> -				ip[2] = 0x07f10000;	/* br %r1 */
> +				insn[2] = 0x07f10000;	/* br %r1 */
>  			}
> -			ip[3] = (unsigned int) (val >> 32);
> -			ip[4] = (unsigned int) val;
> +			insn[3] = (unsigned int) (val >> 32);
> +			insn[4] = (unsigned int) val;
> +
> +			write(ip, insn, sizeof(insn));
>  			info->plt_initialized = 1;
>  		}
>  		if (r_type == R_390_PLTOFF16 ||
> @@ -357,17 +371,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  			val += rela->r_addend - loc;
>  		}
>  		if (r_type == R_390_PLT16DBL)
> -			rc = apply_rela_bits(loc, val, 1, 16, 1);
> +			rc = apply_rela_bits(loc, val, 1, 16, 1, write);
>  		else if (r_type == R_390_PLTOFF16)
> -			rc = apply_rela_bits(loc, val, 0, 16, 0);
> +			rc = apply_rela_bits(loc, val, 0, 16, 0, write);
>  		else if (r_type == R_390_PLT32DBL)
> -			rc = apply_rela_bits(loc, val, 1, 32, 1);
> +			rc = apply_rela_bits(loc, val, 1, 32, 1, write);
>  		else if (r_type == R_390_PLT32 ||
>  			 r_type == R_390_PLTOFF32)
> -			rc = apply_rela_bits(loc, val, 0, 32, 0);
> +			rc = apply_rela_bits(loc, val, 0, 32, 0, write);
>  		else if (r_type == R_390_PLT64 ||
>  			 r_type == R_390_PLTOFF64)
> -			rc = apply_rela_bits(loc, val, 0, 64, 0);
> +			rc = apply_rela_bits(loc, val, 0, 64, 0, write);
>  		break;
>  	case R_390_GOTOFF16:	/* 16 bit offset to GOT.  */
>  	case R_390_GOTOFF32:	/* 32 bit offset to GOT.  */
> @@ -375,20 +389,20 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  		val = val + rela->r_addend -
>  			((Elf_Addr) me->core_layout.base + me->arch.got_offset);
>  		if (r_type == R_390_GOTOFF16)
> -			rc = apply_rela_bits(loc, val, 0, 16, 0);
> +			rc = apply_rela_bits(loc, val, 0, 16, 0, write);
>  		else if (r_type == R_390_GOTOFF32)
> -			rc = apply_rela_bits(loc, val, 0, 32, 0);
> +			rc = apply_rela_bits(loc, val, 0, 32, 0, write);
>  		else if (r_type == R_390_GOTOFF64)
> -			rc = apply_rela_bits(loc, val, 0, 64, 0);
> +			rc = apply_rela_bits(loc, val, 0, 64, 0, write);
>  		break;
>  	case R_390_GOTPC:	/* 32 bit PC relative offset to GOT. */
>  	case R_390_GOTPCDBL:	/* 32 bit PC rel. off. to GOT shifted by 1. */
>  		val = (Elf_Addr) me->core_layout.base + me->arch.got_offset +
>  			rela->r_addend - loc;
>  		if (r_type == R_390_GOTPC)
> -			rc = apply_rela_bits(loc, val, 1, 32, 0);
> +			rc = apply_rela_bits(loc, val, 1, 32, 0, write);
>  		else if (r_type == R_390_GOTPCDBL)
> -			rc = apply_rela_bits(loc, val, 1, 32, 1);
> +			rc = apply_rela_bits(loc, val, 1, 32, 1, write);
>  		break;
>  	case R_390_COPY:
>  	case R_390_GLOB_DAT:	/* Create GOT entry.  */
> @@ -412,9 +426,10 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	return 0;
>  }
>  
> -int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> +static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>  		       unsigned int symindex, unsigned int relsec,
> -		       struct module *me)
> +		       struct module *me,
> +		       void *(*write)(void *dest, const void *src, size_t len))
>  {
>  	Elf_Addr base;
>  	Elf_Sym *symtab;
> @@ -430,13 +445,27 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
>  	n = sechdrs[relsec].sh_size / sizeof(Elf_Rela);
>  
>  	for (i = 0; i < n; i++, rela++) {
> -		rc = apply_rela(rela, base, symtab, strtab, me);
> +		rc = apply_rela(rela, base, symtab, strtab, me, write);
>  		if (rc)
>  			return rc;
>  	}
>  	return 0;
>  }
>  
> +int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> +		       unsigned int symindex, unsigned int relsec,
> +		       struct module *me)
> +{
> +	bool early = me->state == MODULE_STATE_UNFORMED;
> +	void *(*write)(void *, const void *, size_t) = memcpy;
> +
> +	if (!early)
> +		write = s390_kernel_write;
> +
> +	return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +				    write);
> +}
> +
>  int module_finalize(const Elf_Ehdr *hdr,
>  		    const Elf_Shdr *sechdrs,
>  		    struct module *me)
> -- 
> 2.21.1
> 

-- 
Josh

