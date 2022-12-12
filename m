Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0527064A59D
	for <lists+live-patching@lfdr.de>; Mon, 12 Dec 2022 18:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiLLRMR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Dec 2022 12:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiLLRMD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Dec 2022 12:12:03 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EF62723;
        Mon, 12 Dec 2022 09:11:58 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DE1C333B5B;
        Mon, 12 Dec 2022 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670865116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pLYj/5iGdEaNmhtULWfyoYEn+dFzseYwp+heXXcU6m0=;
        b=b1h4XM65SnmJan79cLr4+sH+ANplNLCSLihdoCCfGxHH7CsLz0aIYBJIX/dPRNZao9FWLi
        mFUF4SvnivOJJjnKtgnkoxT0oCstk+CCBJCEClDpnWQKUU5jYfr+Pzxx87cqWvEgiCwARM
        Fid8h5EyzZVUhW6ET3CcQ4aIpqdzBOk=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 19BC72C141;
        Mon, 12 Dec 2022 17:11:56 +0000 (UTC)
Date:   Mon, 12 Dec 2022 18:11:55 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: powerpc-part: was: Re: [PATCH v6] livepatch: Clear relocation
 targets on a module removal
Message-ID: <Y5dg25LV24mBRf4t@alley>
References: <20220901171252.2148348-1-song@kernel.org>
 <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
 <Y5Me5dTGv+GznvtO@alley>
 <CAPhsuW4pt7vfHTj8KorTRCx5zJaoUiyYUOLy8uXZDbTbur4RRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4pt7vfHTj8KorTRCx5zJaoUiyYUOLy8uXZDbTbur4RRA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-12-09 11:59:35, Song Liu wrote:
> On Fri, Dec 9, 2022 at 3:41 AM Petr Mladek <pmladek@suse.com> wrote:
> > On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > > >
> > > > > --- a/arch/powerpc/kernel/module_64.c
> > > > > +++ b/arch/powerpc/kernel/module_64.c
> > > > > +#ifdef CONFIG_LIVEPATCH
> > > > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > > > +                    const char *strtab,
> > > > > +                    unsigned int symindex,
> > > > > +                    unsigned int relsec,
> > > > > +                    struct module *me)
> > > > > +{

[...]

> > > > > +
> > > > > +             instruction = (u32 *)location;
> > > > > +             if (is_mprofile_ftrace_call(symname))
> > > > > +                     continue;
> >
> > Why do we ignore these symbols?
> >
> > I can't find any counter-part in apply_relocate_add(). It looks super
> > tricky. It would deserve a comment.
> >
> > And I have no idea how we could maintain these exceptions.
> >
> > > > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > > > +                     continue;
> >
> > Same here. It looks super tricky and there is no explanation.
> 
> The two checks are from restore_r2(). But I cannot really remember
> why we needed them. It is probably an updated version from an earlier
> version (3 year earlier..).

This is a good sign that it has to be explained in a comment.
Or even better, it should not by copy pasted.

> > > > > +             instruction += 1;
> > > > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));

I believe that this is not enough. apply_relocate_add() does this:

int apply_relocate_add(Elf64_Shdr *sechdrs,
[...]
		       struct module *me)
{
[...]
		case R_PPC_REL24:
			/* FIXME: Handle weak symbols here --RR */
			if (sym->st_shndx == SHN_UNDEF ||
			    sym->st_shndx == SHN_LIVEPATCH) {
[...]
			if (!restore_r2(strtab + sym->st_name,
							(u32 *)location + 1, me))
[...]					return -ENOEXEC;

--->			if (patch_instruction((u32 *)location, ppc_inst(value)))
				return -EFAULT;

, where restore_r2() does:

static int restore_r2(const char *name, u32 *instruction, struct module *me)
{
[...]
	/* ld r2,R2_STACK_OFFSET(r1) */
--->	if (patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC)))
		return 0;
[...]
}

By other words, apply_relocate_add() modifies two instructions:

   + patch_instruction() called in restore_r2() writes into "location + 1"
   + patch_instruction() called in apply_relocate_add() writes into "location"

IMHO, we have to clear both.

IMHO, we need to implement a function that reverts the changes done
in restore_r2(). Also we need to revert the changes done in
apply_relocate_add().

Please, avoid code duplication as much as possible. Especially,
the two checks is_mprofile_ftrace_call() and
instr_is_relative_link_branch() must be shared. IMHO, it is
the only way to keep the code maintainable. We must make sure that
we will clear the instructions only when they were patched. And
copy pasting various tricky exceptions is a way to hell.


> > int update_relocate_add(Elf64_Shdr *sechdrs,
> >                        const char *strtab,
> >                        unsigned int symindex,
> >                        unsigned int relsec,
> >                        struct module *me,
> >                        bool apply)
> > {
> >         unsigned int i;
> >         Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> >         Elf64_Sym *sym;
> >         Elf64_Xword r_type;
> >         unsigned long *location;
> >
> >         if (apply) {
> >                 pr_debug("Applying ADD relocate section %u to %u\n", relsec,
> >                        sechdrs[relsec].sh_info);
> >         } else {
> >                 pr_debug("Clearing ADD relocate section %u\n", relsec");
> >         }
> >
> >         for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> >                 /* This is where to make the change */
> >                 location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> >                         + rela[i].r_offset;
> >                 /* This is the symbol it is referring to */
> >                 sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> >                         + ELF64_R_SYM(rela[i].r_info);
> >
> >                 r_type = ELF64_R_TYPE(rela[i].r_info);
> >
> >                 if (apply) {
> >                         apply_relocate_location(sym, location, r_type, rela[i].r_addend);
> >                 } else {
> >                         clear_relocate_location(sym, location, r_type);
> >                 }
> 
> I personally don't like too many "if (apply) {...} else {...}" patterns in
> a function. And these new functions confuse me sometimes:
> 
>     update_relocate_add(..., apply);
>     apply_relocate_location();
>     clear_relocate_location();

Feel free to come up with another way how to avoid code duplication.

> And I did think there wasn't too much duplicated code.

I think that it looks very different when you are writing or reading
or mantainting the code. It might be easier to write code and modify
it. It is more complicated to find the differences later. Also it is
more complicated to do the same changes many times when the common
code is updated later.

Best Regards,
Petr
