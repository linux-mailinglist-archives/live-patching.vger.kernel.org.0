Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B71B255D
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2020 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDULy1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Apr 2020 07:54:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDULy1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Apr 2020 07:54:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57FD6AD88;
        Tue, 21 Apr 2020 11:54:24 +0000 (UTC)
Date:   Tue, 21 Apr 2020 13:54:24 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
In-Reply-To: <20200420175751.GA13807@redhat.com>
Message-ID: <alpine.LSU.2.21.2004211346180.9609@pobox.suse.cz>
References: <cover.1587131959.git.jpoimboe@redhat.com> <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com> <20200420175751.GA13807@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 20 Apr 2020, Joe Lawrence wrote:

> On Fri, Apr 17, 2020 at 09:04:27AM -0500, Josh Poimboeuf wrote:
> > 
> > [ ... snip ... ]
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 40cfac8156fd..5fda3afc0285 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > 
> > [ ... snip ... ]
> > 
> > +int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> > +			  const char *shstrtab, const char *strtab,
> > +			  unsigned int symndx, struct module *pmod,
> > +			  const char *objname)
> >  {
> >  	int i, cnt, ret = 0;
> > -	const char *objname, *secname;
> >  	char sec_objname[MODULE_NAME_LEN];
> >  	Elf_Shdr *sec;
> >  
> > -	if (WARN_ON(!klp_is_object_loaded(obj)))
> > -		return -EINVAL;
> > -
> > -	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > -
> >  	/* For each klp relocation section */
> > -	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > -		sec = pmod->klp_info->sechdrs + i;
> > -		secname = pmod->klp_info->secstrings + sec->sh_name;
> > +	for (i = 1; i < ehdr->e_shnum; i++) {
> > +		sec = sechdrs + i;
> 
> Hi Josh, minor bug:
> 
> Note the for loop through the section headers in
> klp_write_relocations(), but its calling function ...
> 
> > [ ... snip ... ]
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 646f1e2330d2..d36ea8a8c3ec 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2334,11 +2334,12 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
> >  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
> >  			continue;
> >  
> > -		/* Livepatch relocation sections are applied by livepatch */
> >  		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> > -			continue;
> > -
> > -		if (info->sechdrs[i].sh_type == SHT_REL)
> > +			err = klp_write_relocations(info->hdr, info->sechdrs,
> > +						    info->secstrings,
> > +						    info->strtab,
> > +						    info->index.sym, mod, NULL);
> > +		else if (info->sechdrs[i].sh_type == SHT_REL)
> >  			err = apply_relocate(info->sechdrs, info->strtab,
> >  					     info->index.sym, i, mod);
> >  		else if (info->sechdrs[i].sh_type == SHT_RELA)
> 
> ... apply_relocations() is also iterating over the section headers (the
> diff context doesn't show it here, but i is an incrementing index over
> sechdrs[]).
> 
> So if there is more than one KLP relocation section, we'll process them
> multiple times.  At least the x86 relocation code will detect this and
> fail the module load with an invalid relocation (existing value not
> zero).

The last paragraph confused me a little. I'm sending the following, so it 
is archived publicly.

If there is more than one KLP relocation section in a patch module, let's 
say for vmlinux and some arbitrary module, klp_write_relocations() will 
be called multiple times from apply_relocations(). Each time with NULL as 
the last parameter, so each time vmlinux relocation section will be 
processed and x86 relocation code will detect this the second time and 
fail.

If there was no relocation section for vmlinux, but for multiple arbitrary 
modules, all should be "fine", because klp_write_relocations() would just 
skip everything.

Anyway, good catch, I missed it completely.

Miroslav
