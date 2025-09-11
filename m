Return-Path: <live-patching+bounces-1639-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C176B528B1
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 08:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 601F81B248CC
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 06:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504F325B2F4;
	Thu, 11 Sep 2025 06:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9+wD8hB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A75A11CBA
	for <live-patching@vger.kernel.org>; Thu, 11 Sep 2025 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757572051; cv=none; b=ML8ubILR1vfINEhMt4kKD3xIIXvGEGFUplrvrOZu//wt+/ts133XTRCMH3CyCCHk51dAFEzK43uf4onfD9mRqBeNUUoJB/LlhaD2btZ41qFEgZoQwn8SGzHI5Q00Mqp9AEvM5NLm/XKyaABmD9880582DoqNnCHSafZksfm7LlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757572051; c=relaxed/simple;
	bh=GiD6aNzUkQxQxu4wU6ZzPj9lKhjZ7HN3YavWKw80EuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNH2z0JjcBj1so2rXD/lUGWKCMTyiu8xOrSLLpOycBRxtUl5RH/rmEMdDyFv4RxLxc+wZTfzFcRN2ZQfyUJHYEvQvuidrF7xvtEAUmmYiQ9aPfkc4HPBiwRSX+jRxYCshBurSLxEH64SB8N+kjQSaw2zLHYi/nar1TaJVVm9g5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9+wD8hB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041ADC4CEF1;
	Thu, 11 Sep 2025 06:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757572050;
	bh=GiD6aNzUkQxQxu4wU6ZzPj9lKhjZ7HN3YavWKw80EuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N9+wD8hB1W1lBxRfTrTR6UnYCpKi5Z5GLUfrVbtLzs3JZ/QRtM3Q4bF0fktooQVkd
	 CRIf5I5ZAXdY/SuRsMNVH4WxgTHn8rd0FgcV54O3bOi5SoW9QuwK0wui73E4p0xwXB
	 rdA7Ale4ur3fRDJXNgxSvz9TyGeOPyfKkNfyc65nTlPbg4AW3uz7hsI7SYGJ0kyoGR
	 cDsyJbTSxboAMtQPhWVruj2a1wR8kxnzCyndCMO1bv79l7k/xXZWXFXsSDF2FfwEcK
	 2VeDqiGKtyJ4Si7/B2CxRMBGEqbgz9jEOf4P8ooOG61WmP4VP8ky+qxFCve9llQ0Dv
	 zCDEPYIXTd20Q==
Date: Thu, 11 Sep 2025 11:55:56 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc64/modules: fix ool-ftrace-stub vs. livepatch
 relocation corruption
Message-ID: <df7taxdxpbo4qfn7lniggj5o4ili6kweg4nytyb2fwwwgmnyo4@halp5gf244nn>
References: <20250904022950.3004112-1-joe.lawrence@redhat.com>
 <aLj7c13wVPvkdNxc@redhat.com>
 <2tscft2yyndfbkl2a7ltndqfwx7phajkfma3m6o5phpm3xkme2@dcy6ohdbfhsk>
 <aMHKD_X97uu0tUyK@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMHKD_X97uu0tUyK@redhat.com>

On Wed, Sep 10, 2025 at 02:57:19PM -0400, Joe Lawrence wrote:
> On Mon, Sep 08, 2025 at 04:33:24PM +0530, Naveen N Rao wrote:
> > On Wed, Sep 03, 2025 at 10:37:39PM -0400, Joe Lawrence wrote:
> > > On Wed, Sep 03, 2025 at 10:29:50PM -0400, Joe Lawrence wrote:
> > > > The powerpc64 module .stubs section holds ppc64_stub_entry[] code
> > > > trampolines that are generated at module load time. These stubs are
> > > > necessary for function calls to external symbols that are too far away
> > > > for a simple relative branch.
> > > >
> > > > Logic for finding an available ppc64_stub_entry has relied on a sentinel
> > > > value in the funcdata member to indicate a used slot. Code iterates
> > > > through the array, inspecting .funcdata to find the first unused (zeroed)
> > > > entry:
> > > >
> > > >   for (i = 0; stub_func_addr(stubs[i].funcdata); i++)
> > > >
> > > > To support CONFIG_PPC_FTRACE_OUT_OF_LINE, a new setup_ftrace_ool_stubs()
> > > > function extended the .stubs section by adding an array of
> > > > ftrace_ool_stub structures for each patchable function. A side effect
> > > > of writing these smaller structures is that the funcdata sentinel
> > > > convention is not maintained.
> >
> > There is clearly a bug in how we are reserving the stubs as you point
> > out further below, but once that is properly initialized, I don't think
> > the smaller structure size for ftrace_ool_stub matters (in so far as
> > stub->funcdata being non-NULL). We end up writing four valid powerpc
> > instructions, along with a ftrace_ops pointer before those instructions
> > which should also be non-zero (there is a bug here too, more on that
> > below).  The whole function descriptor dance does complicate matters a
> > bit though.
> >
> 
> Hi Naveen,
> 
> Ah hah, I see now, given the other bug that you mention, we should have
> had seen non-NULL entries in either ftrace_ool_stub.insn[] or .ftrace_op
> fields such that when read as ppc64_stub_entry, .funcdata would indicate
> that it's in use:
> 
>         ppc64_stub_entry[]  ftrace_ool_stub[]
>   0x00  [0].jump[0]         [0].ftrace_op
>   0x04  [0].jump[1]         [0].ftrace_op
>   0x08  [0].jump[2]         [0].insn[0]
>   0x0C  [0].jump[3]         [0].insn[1]
>   0x10  [0].jump[4]         [0].insn[2]
>   0x14  [0].jump[5]         [0].insn[3]
>   0x18  [0].jump[6]         [1].ftrace_op
>   0x1C  [0].magic           [1].ftrace_op
>   0x20  [0].funcdata        [1].insn[0]    <<
>   0x24  [0].funcdata        [1].insn[1]    <<
>   0x28  [1].jump[0]         [1].insn[2]
>   0x2C  [1].jump[1]         [1].insn[3]
>   0x30  [1].jump[2]         [2].ftrace_op
>   0x34  [1].jump[3]         [2].ftrace_op
>   0x38  [1].jump[4]         [2].insn[0]
>   0x3C  [1].jump[5]         [2].insn[1]
>   0x40  [1].jump[6]         [2].insn[2]
>   0x44  [1].magic           [2].insn[3]
>   0x48  [1].funcdata        [3].ftrace_op  <<
>   0x4C  [1].funcdata        [3].ftrace_op  <<
> 
> If the commit msg for this patch would be clearer by rewording anything,
> I'm happy to update.  (My understanding at the time of writing was that
> the NULL funcdata vs. insn[]/ftrace_op was a valid sequence.)
> 

Yes, please. But only just to point out the bug in how we are reserving 
the stubs. 

> > > > @@ -1118,29 +1118,19 @@ int module_trampoline_target(struct 
> > > > module *mod, unsigned long addr,
> > > >  static int setup_ftrace_ool_stubs(const Elf64_Shdr *sechdrs, unsigned long addr, struct module *me)
> > > >  {
> > > >  #ifdef CONFIG_PPC_FTRACE_OUT_OF_LINE
> > > > -	unsigned int i, total_stubs, num_stubs;
> > > > +	unsigned int total_stubs, num_stubs;
> > > >  	struct ppc64_stub_entry *stub;
> > > >
> > > >  	total_stubs = sechdrs[me->arch.stubs_section].sh_size / sizeof(*stub);
> > > >  	num_stubs = roundup(me->arch.ool_stub_count * sizeof(struct ftrace_ool_stub),
> > > >  			    sizeof(struct ppc64_stub_entry)) / sizeof(struct ppc64_stub_entry);
> > > >
> > > > -	/* Find the next available entry */
> > > > -	stub = (void *)sechdrs[me->arch.stubs_section].sh_addr;
> > > > -	for (i = 0; stub_func_addr(stub[i].funcdata); i++)
> > > > -		if (WARN_ON(i >= total_stubs))
> > > > -			return -1;
> > > > -
> > > > -	if (WARN_ON(i + num_stubs > total_stubs))
> > > > +	if (WARN_ON(me->arch.stub_count + num_stubs > total_stubs))
> > > >  		return -1;
> > > >
> > > > -	stub += i;
> > > > -	me->arch.ool_stubs = (struct ftrace_ool_stub *)stub;
> > > > -
> > > > -	/* reserve stubs */
> > > > -	for (i = 0; i < num_stubs; i++)
> > > > -		if (patch_u32((void *)&stub->funcdata, PPC_RAW_NOP()))
> > > > -			return -1;
> > >
> > > At first I thought the bug was that this loop was re-writting the same
> > > PPC_RAW_NOP() to the same funcdata (i.e, should have been something
> > > like: patch_u32((void *)stub[i]->funcdata, PPC_RAW_NOP())), but that
> > > didn't work and seemed fragile anyway.
> >
> > D'uh - this path was clearly never tested. I suppose this should have
> > been something like this:
> > 	patch_ulong((void *)&stub[i]->funcdata, func_desc(local_paca))
> >
> > Still convoluted, but I think that should hopefully fix the problem you
> > are seeing.
> >
> 
> I can still try something like this if you prefer that solution (though
> I think there may be some type massaging required in the second argument
> to patch_ulong().)  LMK ...

That's alright -- it is better to rip this out and replace with the 
changes in your patch.

> 
> > >
> > > > +	stub = (void *)sechdrs[me->arch.stubs_section].sh_addr;
> > > > +	me->arch.ool_stubs = (struct ftrace_ool_stub *)(stub + me->arch.stub_count);
> > > > +	me->arch.stub_count += num_stubs;
> > > >  #endif
> >
> > Regardless of the above, your proposed change looks good to me and
> > simplifies the logic. So:
> > Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
> >
> 
> 
> 
> > >   crash> dis 0xc008000007d70dd0 42
> > >   ppc64[ ]   ftrace[0]    <xfs_stats_format+0x558>:    .long 0x0
> > >                           <xfs_stats_format+0x55c>:    .long 0x0
> > >                           <xfs_stats_format+0x560>:    mflr    r0
> > >                           <xfs_stats_format+0x564>:    bl      0xc008000007d70d80 <xfs_stats_format+0x508>
> > >                           <xfs_stats_format+0x568>:    mtlr    r0
> > >                           <xfs_stats_format+0x56c>:    b       0xc008000007d70014 <patch_free_livepatch+0xc>
> > >              ftrace[1]    <xfs_stats_format+0x570>:    .long 0x0
> > >                           <xfs_stats_format+0x574>:    .long 0x0
> > >                           <xfs_stats_format+0x578>:    mflr    r0
> > >                           <xfs_stats_format+0x57c>:    bl      0xc008000007d70d80 <xfs_stats_format+0x508>
> > >   ppc64[ ]                <xfs_stats_format+0x580>:    addis   r11,r2,4                                         << This looks like a full
> > >                           <xfs_stats_format+0x584>:    addi    r11,r11,-29448                                   << ppc64_stub_entry
> > >              ftrace[2]    <xfs_stats_format+0x588>:    std     r2,24(r1)                                        << dropped in the middle
> > >                           <xfs_stats_format+0x58c>:    ld      r12,32(r11)                                      << of the ool_stubs array
> > >                           <xfs_stats_format+0x590>:    mtctr   r12                                              << of ftrace_ool_stub[]
> > >                           <xfs_stats_format+0x594>:    bctr                                                     <<
> > >                           <xfs_stats_format+0x598>:    mtlr    r0                                               <<
> > >                           <xfs_stats_format+0x59c>:    andi.   r20,r27,30050                                    <<
> > >              ftrace[3]    <xfs_stats_format+0x5a0>:    .long 0x54e92b8                                          <<
> > >                           <xfs_stats_format+0x5a4>:    lfs     f0,0(r8)                                         <<
> > >   ppc64[ ]                <xfs_stats_format+0x5a8>:    mflr    r0
> > >                           <xfs_stats_format+0x5ac>:    bl      0xc008000007d70d80 <xfs_stats_format+0x508>
> > >                           <xfs_stats_format+0x5b0>:    mtlr    r0
> > >                           <xfs_stats_format+0x5b4>:    b       0xc008000007d7037c <add_callbacks_to_patch_objects+0xc>
> > >              ftrace[4]    <xfs_stats_format+0x5b8>:    .long 0x0
> > >                           <xfs_stats_format+0x5bc>:    .long 0x0
> >
> > These NULL values are also problematic. I think those are NULL since we
> > are not "reserving" the stubs properly, but those should point to some
> > ftrace_op. I think we are missing a call to ftrace_rec_set_nop_ops() in
> > ftrace_init_nop(), which would be good to do separately.
> >
> 
> Very lightly tested, but were you thinking of something like:
> 
> diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
> index 6dca92d5a..687371c64 100644
> --- a/arch/powerpc/kernel/trace/ftrace.c
> +++ b/arch/powerpc/kernel/trace/ftrace.c
> @@ -488,8 +488,12 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
>  		return ret;
> 
>  	/* Set up out-of-line stub */
> -	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE))
> -		return ftrace_init_ool_stub(mod, rec);
> +	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE)) {
> +		ret = ftrace_init_ool_stub(mod, rec);
> +		if (ret)
> +			return ret;
> +		return ftrace_rec_set_nop_ops(rec);
> +	}

Minor nit: since ftrace_rec_set_nop_ops() has to be called regardless, I 
would prefer to add a goto here. See below.

> 
>  	/* Nop-out the ftrace location */
>  	new = ppc_inst(PPC_RAW_NOP());
> @@ -520,7 +524,7 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
>  		return -EINVAL;
>  	}
> 
> -	return ret;
> +	return ftrace_rec_set_nop_ops(rec);
>  }

We will need to still check for ret here, so something like this?

diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 6dca92d5a6e8..841d077e2825 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -488,8 +488,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
                return ret;
 
        /* Set up out-of-line stub */
-       if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE))
-               return ftrace_init_ool_stub(mod, rec);
+       if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE)) {
+               ret = ftrace_init_ool_stub(mod, rec);
+               goto out;
+       }
 
        /* Nop-out the ftrace location */
        new = ppc_inst(PPC_RAW_NOP());
@@ -520,6 +522,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
                return -EINVAL;
        }
 
+out:
+       if (!ret)
+               ret = ftrace_rec_set_nop_ops(rec);
+
        return ret;
 }
 
> 
>  int ftrace_update_ftrace_func(ftrace_func_t func)
> 
> 
> In which case the ftrace-ool area looks like:
> 
>   crash> mod | grep livepatch_module
>   c008000006350500  livepatch_module                   c008000009b90000   262144  (not loaded)  [CONFIG_KALLSYMS]
>   crash> struct module.arch.ool_stubs c008000006350500
>     arch.ool_stubs = 0xc008000009b90dd0 <xfs_stats_format+1368>,
>   crash> struct module.arch.ool_stub_count c008000006350500
>     arch.ool_stub_count = 7,
> 
>   crash> struct ftrace_ool_stub 0xc008000009b90dd0 7
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffffa5, 0x7c0803a6, 0x4bfff230}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff8d, 0x7c0803a6, 0x4bfff304}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff75, 0x7c0803a6, 0x4bfff430}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff5d, 0x7c0803a6, 0x4bfff550}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff45, 0x7c0803a6, 0x4bfff768}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff2d, 0x7c0803a6, 0x4bfffa08}
>   }
> 
>   struct ftrace_ool_stub {
>     ftrace_op = 0xc00000000131d140 <ftrace_nop_ops>,
>     insn = {0x7c0802a6, 0x4bffff15, 0x7c0803a6, 0x4bfffa10}
>   }

LGTM.


Thanks,
- Naveen


