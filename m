Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F170765E9AC
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 12:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjAELUA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 06:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjAELTz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 06:19:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A4B479F5
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 03:19:53 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4603C2689B;
        Thu,  5 Jan 2023 11:19:45 +0000 (UTC)
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1DFEB2C141;
        Thu,  5 Jan 2023 11:19:45 +0000 (UTC)
Date:   Thu, 5 Jan 2023 12:19:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y7ayTvpxnDvX9Nfi@alley>
References: <20221214174035.1012183-1-song@kernel.org>
 <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
X-Spamd-Bar: +++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=fail (smtp-out2.suse.de: domain of pmladek@suse.com does not designate 149.44.160.134 as permitted sender) smtp.mailfrom=pmladek@suse.com
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.39 / 50.00];
         ARC_NA(0.00)[];
         R_SPF_FAIL(1.00)[-all];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.com];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_NOT_FQDN(0.50)[]
X-Spam-Score: 5.39
X-Rspamd-Queue-Id: 4603C2689B
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-01-04 09:34:25, Song Liu wrote:
> On Wed, Jan 4, 2023 at 2:26 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Wed 2022-12-14 09:40:35, Song Liu wrote:
> > > From: Miroslav Benes <mbenes@suse.cz>
> > >
> > > Josh reported a bug:
> > >
> > >   When the object to be patched is a module, and that module is
> > >   rmmod'ed and reloaded, it fails to load with:
> > >
> > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > >   The livepatch module has a relocation which references a symbol
> > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > >   tries to replace the old relocation with a new one, it sees that
> > >   the previous one is nonzero and it errors out.
> > >
> > > We thus decided to reverse the relocation patching (clear all relocation
> > > targets on x86_64). The solution is not
> > > universal and is too much arch-specific, but it may prove to be simpler
> > > in the end.
> > >
> > > --- a/arch/powerpc/kernel/module_64.c
> > > +++ b/arch/powerpc/kernel/module_64.c
> > > @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
> > >       return 0;
> > >  }
> > >
> > > +#ifdef CONFIG_LIVEPATCH
> > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > +                    const char *strtab,
> > > +                    unsigned int symindex,
> > > +                    unsigned int relsec,
> > > +                    struct module *me)
> > > +{
> > > +     unsigned int i;
> > > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > > +     Elf64_Sym *sym;
> > > +     unsigned long *location;
> > > +     const char *symname;
> > > +     u32 *instruction;
> > > +
> > > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > > +              sechdrs[relsec].sh_info);
> > > +
> > > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > > +                     + rela[i].r_offset;
> > > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > > +                     + ELF64_R_SYM(rela[i].r_info);
> > > +             symname = me->core_kallsyms.strtab
> > > +                     + sym->st_name;
> > > +
> > > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > > +                     continue;
> >
> > Is it OK to continue?
> >
> > IMHO, we should at least warn here. It means that the special elf
> > section contains a relocation that we are not able to clear. It will
> > most likely blow up when we try to load the livepatched module
> > again.
> >
> > > +             /*
> > > +              * reverse the operations in apply_relocate_add() for case
> > > +              * R_PPC_REL24.
> > > +              */
> > > +             if (sym->st_shndx != SHN_UNDEF &&
> > > +                 sym->st_shndx != SHN_LIVEPATCH)
> > > +                     continue;
> >
> > Same here. IMHO, we should warn when the section contains something
> > that we are not able to clear.
> >
> > > +             /* skip mprofile and ftrace calls, same as restore_r2() */
> > > +             if (is_mprofile_ftrace_call(symname))
> > > +                     continue;
> >
> > Is this correct? restore_r2() returns "1" in this case. As a result
> > apply_relocate_add() returns immediately with -ENOEXEC. IMHO, we
> > should print a warning and return as well.
> >
> > > +             instruction = (u32 *)location;
> > > +             /* skip sibling call, same as restore_r2() */
> > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > +                     continue;
> >
> > Same here. restore_r2() returns '1' in this case...
> >
> > > +
> > > +             instruction += 1;
> > > +             /*
> > > +              * Patch location + 1 back to NOP so the next
> > > +              * apply_relocate_add() call (reload the module) will not
> > > +              * fail the sanity check in restore_r2():
> > > +              *
> > > +              *         if (*instruction != PPC_RAW_NOP()) {
> > > +              *             pr_err(...);
> > > +              *             return 0;
> > > +              *         }
> > > +              */
> > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > > +     }
> >
> > This seems incomplete. The above code reverts patch_instruction() called
> > from restore_r2(). But there is another patch_instruction() called in
> > apply_relocate_add() for case R_PPC_REL24. IMHO, we should revert this
> > as well.
> >
> > > +}
> > > +#endif
> >
> > IMHO, this approach is really bad. The function is not maintainable.
> > It will be very hard to keep it in sync with apply_relocate_add().
> > And all the mistakes are just a proof.
> 
> I don't really think the above are mistakes. This should be the same
> as the version that passed Joe's tests. (I didn't test it myself).

I am not sure if Joe tested these situations.

Anyway, we should make it as robust as possible. If we manipulate
the addresses a wrong way then it might shoot-down the system.

If the code reaches an non-expected situation, it should at
least warn about it.

The entire livepatching code tries to be as robust as possible.
The main motivation for livepatching is to avoid reboot.

> >
> > IMHO, the only sane way is to avoid the code duplication.
> 
> I think this falls back to the question that do we want
> clear_relocate_add() to
>    1) undo everything by apply_relocate_add();
> or
>    2) make sure the next apply_relocate_add() succeeds.

The ideal solution would be to add checks into apply_relocated_add().
It would make it more robust. In that case, clear_relocated_add()
would need to clear everything.

But this is not the case on powerpc and s390 at the moment.
In this case, I suggest to clear only relocations that
are checked in apply_relocated_add().

But it should be done without duplicating the code.

It would actually make sense to compute the value that was
used in apply_relocated_add() and check that we are clearing
the value. If we try to clear some other value than we
probably do something wrong.

This might actually be a solution. We could compute
the value in both situations. Then we could have
a common function for writing.

This write function would check that it replaces zero
with the value in apply_relocate_add() and that it replaces
the value with zero in clear_relocate_add().

Best Regards,
Petr
