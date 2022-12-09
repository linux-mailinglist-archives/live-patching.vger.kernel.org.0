Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDF3648308
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiLINyO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 08:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLINyN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 08:54:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962B873F63;
        Fri,  9 Dec 2022 05:54:12 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0319B22B95;
        Fri,  9 Dec 2022 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670594051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0FFQYaabEfRDr7LqeZLH4qKryO6ltYLrRQvYtgv9m2k=;
        b=G93rCs6MRiMRau87yY0IGLli1eoqzwPsVg8tzsuIT8GLinhpeGj2oYzJ5FDA8BCu7P5Ka4
        rozEJ8Gsgl3mnas0RgPNik+MYxVBHjafxE/sB4OWIP3+eR2pCzOucRdPt43ua9xovaD/Vs
        O8vgwtVyGyK+UVghOOV46O0nDeTOArU=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 957102C141;
        Fri,  9 Dec 2022 13:54:10 +0000 (UTC)
Date:   Fri, 9 Dec 2022 14:54:10 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y5M+AoKHDK4rn6/i@alley>
References: <20220901171252.2148348-1-song@kernel.org>
 <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-11-28 17:57:06, Song Liu wrote:
> On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > >       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> > >  }
> > >
> > > +static void klp_clear_object_relocations(struct module *pmod,
> > > +                                     struct klp_object *obj)
> > > +{
> > > +     int i, cnt;
> > > +     const char *objname, *secname;
> > > +     char sec_objname[MODULE_NAME_LEN];
> > > +     Elf_Shdr *sec;
> > > +
> > > +     objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > > +
> > > +     /* For each klp relocation section */
> > > +     for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > > +             sec = pmod->klp_info->sechdrs + i;
> > > +             secname = pmod->klp_info->secstrings + sec->sh_name;

secname = ...

> > > +             if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> > > +                     continue;
> > > +
> > > +             /*
> > > +              * Format: .klp.rela.sec_objname.section_name
> > > +              * See comment in klp_resolve_symbols() for an explanation
> > > +              * of the selected field width value.
> > > +              */
> > > +             secname = pmod->klp_info->secstrings + sec->sh_name;

secname = ...    same a above.

> > > +             cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > > +             if (cnt != 1) {
> > > +                     pr_err("section %s has an incorrectly formatted name\n",
> > > +                            secname);
> > > +                     continue;
> > > +             }
> 
> Actually, I think we don't need the cnt check here. Once it is removed,
> there isn't much duplicated logic.

Seriously?

A section with this error was skipped in klp_apply_section_relocs().
I did not cause rejecting the module! Why is it suddenly safe to
process it, please?


I see that you removed also:

	if (strcmp(objname ? objname : "vmlinux", sec_objname))
		return 0;

This is another bug in your "simplification".


> > > +
> > > +             if (strcmp(objname, sec_objname))
> > > +                     continue;
> > > +
> > > +             clear_relocate_add(pmod->klp_info->sechdrs,
> > > +                                pmod->core_kallsyms.strtab,
> > > +                                pmod->klp_info->symndx, i, pmod);
> > > +     }
> > > +}
> >
> > Huh, this duplicates a lot of tricky code.
> >
> > It is even worse because this squashed code from two functions
> > klp_apply_section_relocs() and klp_apply_object_relocs()
> > into a single function. As a result, the code duplication is not
> > even obvious.
> >
> > Also the suffix "_reloacations() does not match the suffix of
> > the related funciton:
> >
> >         + klp_apply_object_relocs()             (existing)
> >         + klp_clear_object_relocations()        (new)
> >
> > This all would complicate maintenance of the code.
> >
> > Please, implement a common:
> >
> > int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> >                              const char *shstrtab, const char *strtab,
> >                              unsigned int symndx, unsigned int secndx,
> >                              const char *objname, bool apply);
> >
> > and
> >
> > int klp_write_object_relocs(struct klp_patch *patch,
> >                             struct klp_object *obj,
> >                             bool apply);
> >
> > and add the respective wrappers:
> >
> > int klp_apply_section_relocs();   /* also needed in module/main.c */
> > int klp_apply_object_relocs();
> > void klp_clear_object_relocs();
> 
> With the above simplification (removing cnt check), do we still need
> all these wrappers? Personally, I think they will make the code more
> difficult to follow..

Sigh.

klp_apply_section_relocs() has 25 lines of code.
klp_apply_object_relocs() has 18 lines of code.

The only difference should be that klp_clear_object_relocs():

   + does not need to call klp_resolve_symbols()
   + need to call clear_relocate_add() instead of apply_relocate_add()

It is 7 different lines from in the existing 25 + 18 = 43 lines.
The duplication does not look like a good deal even from this POV.

If we introduce update_relocate_add(..., bool apply) parameter
then we could call update_relocate_add() in both situations.

Let me repeat from the last mail. klp_clear_object_relocs() even
reshuffled the duplicated code. It was even harder to find differences.

Do I still need to explain how bad idea was the code duplication,
please?

Best Regards,
Petr
