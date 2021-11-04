Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30234452C4
	for <lists+live-patching@lfdr.de>; Thu,  4 Nov 2021 13:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhKDMRR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Nov 2021 08:17:17 -0400
Received: from foss.arm.com ([217.140.110.172]:46896 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhKDMRR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Nov 2021 08:17:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DEDA1063;
        Thu,  4 Nov 2021 05:14:39 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 287103F7D7;
        Thu,  4 Nov 2021 05:14:38 -0700 (PDT)
Date:   Thu, 4 Nov 2021 12:14:32 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH] arm64: module: Use aarch64_insn_write when updating
 relocations later on
Message-ID: <20211104121430.GA6534@lakrids.cambridge.arm.com>
References: <20211103210709.31790-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103210709.31790-1-surajjs@amazon.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 03, 2021 at 02:07:09PM -0700, Suraj Jitindar Singh wrote:
> Livepatch modules have relocation sections named
> .klp.rela.objname.section_name which are written on module load by calling
> klp_apply_section_relocs(). This is called in apply_relocations() to write
> relocations targeting objects in the vmlinux, before the module text is
> mapped read-only in complete_formation().

Currently arm64 doesn't define HAVE_LIVEPATCH, so LIVEPATCH cannot be
selected, so klp_apply_section_relocs() does nothing, and so there is no
problem with mainline.

I assume you have out-of-tree patches to enable that, but it's worth
noting that we haven't yet finished core cleanups necessary to make that
safe (e.g. implementing RELIABLE_STACKTRACE, ensuring that the
reloc/insn code itself isn't subject to instrumentation, etc).

If this is something you want to enable, it would be very helpful if you
could review/test patches in that area.

> However relocations which target other modules are not written until
> after the mapping is made read-only causing them to fault.

When you say "which target other modules", do you mean that the text of
the other modules is altered, or that the text of the module being
loaded is altered to refer to other modules?

> Avoid this fault by calling aarch64_insn_write() to update the instruction
> if the module text has already been marked read-only. Preserve the current
> behaviour if called before this has been done.
> 
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> ---
>  arch/arm64/kernel/module.c | 81 ++++++++++++++++++++++----------------
>  1 file changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
> index b5ec010c481f..35596ea870ab 100644
> --- a/arch/arm64/kernel/module.c
> +++ b/arch/arm64/kernel/module.c
> @@ -19,6 +19,7 @@
>  #include <asm/alternative.h>
>  #include <asm/insn.h>
>  #include <asm/sections.h>
> +#include <asm/patching.h>
>  
>  void *module_alloc(unsigned long size)
>  {
> @@ -155,7 +156,8 @@ enum aarch64_insn_movw_imm_type {
>  };
>  
>  static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
> -			   int lsb, enum aarch64_insn_movw_imm_type imm_type)
> +			   int lsb, enum aarch64_insn_movw_imm_type imm_type,
> +			   bool early)
>  {
>  	u64 imm;
>  	s64 sval;
> @@ -187,7 +189,10 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
>  
>  	/* Update the instruction with the new encoding. */
>  	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm);
> -	*place = cpu_to_le32(insn);
> +	if (early)
> +		*place = cpu_to_le32(insn);
> +	else
> +		aarch64_insn_write(place, insn);

If we really need this, I think it'd be better to refactor the
reloc_insn_*() helpers to generate the new encoding into a temporary
buffer, and make it the caller's responsibiltiy to then perform the
write to the real location in the module.

That way we only have to handle the "early" distinction in one place
rather than spreading it out.

I see you haven't altered the reloc_data() function -- does livepatch
never result in data relocations?

Thanks,
Mark.

>  
>  	if (imm > U16_MAX)
>  		return -ERANGE;
> @@ -196,7 +201,8 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
>  }
>  
>  static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
> -			  int lsb, int len, enum aarch64_insn_imm_type imm_type)
> +			  int lsb, int len, enum aarch64_insn_imm_type imm_type,
> +			  bool early)
>  {
>  	u64 imm, imm_mask;
>  	s64 sval;
> @@ -212,7 +218,10 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
>  
>  	/* Update the instruction's immediate field. */
>  	insn = aarch64_insn_encode_immediate(imm_type, insn, imm);
> -	*place = cpu_to_le32(insn);
> +	if (early)
> +		*place = cpu_to_le32(insn);
> +	else
> +		aarch64_insn_write(place, insn);
>  
>  	/*
>  	 * Extract the upper value bits (including the sign bit) and
> @@ -231,17 +240,17 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
>  }
>  
>  static int reloc_insn_adrp(struct module *mod, Elf64_Shdr *sechdrs,
> -			   __le32 *place, u64 val)
> +			   __le32 *place, u64 val, bool early)
>  {
>  	u32 insn;
>  
>  	if (!is_forbidden_offset_for_adrp(place))
>  		return reloc_insn_imm(RELOC_OP_PAGE, place, val, 12, 21,
> -				      AARCH64_INSN_IMM_ADR);
> +				      AARCH64_INSN_IMM_ADR, early);
>  
>  	/* patch ADRP to ADR if it is in range */
>  	if (!reloc_insn_imm(RELOC_OP_PREL, place, val & ~0xfff, 0, 21,
> -			    AARCH64_INSN_IMM_ADR)) {
> +			    AARCH64_INSN_IMM_ADR, early)) {
>  		insn = le32_to_cpu(*place);
>  		insn &= ~BIT(31);
>  	} else {
> @@ -253,7 +262,10 @@ static int reloc_insn_adrp(struct module *mod, Elf64_Shdr *sechdrs,
>  						   AARCH64_INSN_BRANCH_NOLINK);
>  	}
>  
> -	*place = cpu_to_le32(insn);
> +	if (early)
> +		*place = cpu_to_le32(insn);
> +	else
> +		aarch64_insn_write(place, insn);
>  	return 0;
>  }
>  
> @@ -270,6 +282,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  	void *loc;
>  	u64 val;
>  	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
> +	bool early = me->state == MODULE_STATE_UNFORMED;
>  
>  	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
>  		/* loc corresponds to P in the AArch64 ELF document. */
> @@ -322,88 +335,88 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  			fallthrough;
>  		case R_AARCH64_MOVW_UABS_G0:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_UABS_G1_NC:
>  			overflow_check = false;
>  			fallthrough;
>  		case R_AARCH64_MOVW_UABS_G1:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_UABS_G2_NC:
>  			overflow_check = false;
>  			fallthrough;
>  		case R_AARCH64_MOVW_UABS_G2:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_UABS_G3:
>  			/* We're using the top bits so we can't overflow. */
>  			overflow_check = false;
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 48,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_SABS_G0:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_SABS_G1:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_SABS_G2:
>  			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G0_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G0:
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G1_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G1:
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G2_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
> -					      AARCH64_INSN_IMM_MOVKZ);
> +					      AARCH64_INSN_IMM_MOVKZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G2:
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  		case R_AARCH64_MOVW_PREL_G3:
>  			/* We're using the top bits so we can't overflow. */
>  			overflow_check = false;
>  			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 48,
> -					      AARCH64_INSN_IMM_MOVNZ);
> +					      AARCH64_INSN_IMM_MOVNZ, early);
>  			break;
>  
>  		/* Immediate instruction relocations. */
>  		case R_AARCH64_LD_PREL_LO19:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
> -					     AARCH64_INSN_IMM_19);
> +					     AARCH64_INSN_IMM_19, early);
>  			break;
>  		case R_AARCH64_ADR_PREL_LO21:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 0, 21,
> -					     AARCH64_INSN_IMM_ADR);
> +					     AARCH64_INSN_IMM_ADR, early);
>  			break;
>  		case R_AARCH64_ADR_PREL_PG_HI21_NC:
>  			overflow_check = false;
>  			fallthrough;
>  		case R_AARCH64_ADR_PREL_PG_HI21:
> -			ovf = reloc_insn_adrp(me, sechdrs, loc, val);
> +			ovf = reloc_insn_adrp(me, sechdrs, loc, val, early);
>  			if (ovf && ovf != -ERANGE)
>  				return ovf;
>  			break;
> @@ -411,40 +424,40 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  		case R_AARCH64_LDST8_ABS_LO12_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 0, 12,
> -					     AARCH64_INSN_IMM_12);
> +					     AARCH64_INSN_IMM_12, early);
>  			break;
>  		case R_AARCH64_LDST16_ABS_LO12_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 1, 11,
> -					     AARCH64_INSN_IMM_12);
> +					     AARCH64_INSN_IMM_12, early);
>  			break;
>  		case R_AARCH64_LDST32_ABS_LO12_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 2, 10,
> -					     AARCH64_INSN_IMM_12);
> +					     AARCH64_INSN_IMM_12, early);
>  			break;
>  		case R_AARCH64_LDST64_ABS_LO12_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 3, 9,
> -					     AARCH64_INSN_IMM_12);
> +					     AARCH64_INSN_IMM_12, early);
>  			break;
>  		case R_AARCH64_LDST128_ABS_LO12_NC:
>  			overflow_check = false;
>  			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 4, 8,
> -					     AARCH64_INSN_IMM_12);
> +					     AARCH64_INSN_IMM_12, early);
>  			break;
>  		case R_AARCH64_TSTBR14:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 14,
> -					     AARCH64_INSN_IMM_14);
> +					     AARCH64_INSN_IMM_14, early);
>  			break;
>  		case R_AARCH64_CONDBR19:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
> -					     AARCH64_INSN_IMM_19);
> +					     AARCH64_INSN_IMM_19, early);
>  			break;
>  		case R_AARCH64_JUMP26:
>  		case R_AARCH64_CALL26:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,
> -					     AARCH64_INSN_IMM_26);
> +					     AARCH64_INSN_IMM_26, early);
>  
>  			if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
>  			    ovf == -ERANGE) {
> @@ -452,7 +465,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  				if (!val)
>  					return -ENOEXEC;
>  				ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2,
> -						     26, AARCH64_INSN_IMM_26);
> +						     26, AARCH64_INSN_IMM_26, early);
>  			}
>  			break;
>  
> -- 
> 2.17.1
> 
