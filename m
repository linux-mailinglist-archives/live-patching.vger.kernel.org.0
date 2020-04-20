Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1321B1548
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2020 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgDTTBv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Apr 2020 15:01:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60042 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726017AbgDTTBu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Apr 2020 15:01:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587409308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TSLwQrrbB4jA9+xtPLBleNLhnBPRnJn4gzcm+9Y3LWI=;
        b=L6nXO9t8duVWqGb8KKqzoo4cdnQdFH1wrggt+5ycabTebFPez9MkpZrSubXLluD9bjzyYb
        VBu7RHAzBwDhDz6cEf/rRvt6xIlI2Vf9JBB7K4LJFVUFV+DqiEDNi5GBCcgNygUu0FpNGY
        Bk0L6+jHMn3j7vw6Fj9CXUGWdNjQdfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-H7H8GzLnOluoZ1D01wS8GA-1; Mon, 20 Apr 2020 15:01:45 -0400
X-MC-Unique: H7H8GzLnOluoZ1D01wS8GA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3AD7801E5E;
        Mon, 20 Apr 2020 19:01:43 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25F255C1B2;
        Mon, 20 Apr 2020 19:01:43 +0000 (UTC)
Date:   Mon, 20 Apr 2020 15:01:41 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200420190141.GB13807@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
 <20200420175751.GA13807@redhat.com>
 <20200420182516.6awwwbvoen62gwbr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420182516.6awwwbvoen62gwbr@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 20, 2020 at 01:25:16PM -0500, Josh Poimboeuf wrote:
> On Mon, Apr 20, 2020 at 01:57:51PM -0400, Joe Lawrence wrote:
> > On Fri, Apr 17, 2020 at 09:04:27AM -0500, Josh Poimboeuf wrote:
> > > 
> > > [ ... snip ... ]
> > > 
> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 40cfac8156fd..5fda3afc0285 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > 
> > > [ ... snip ... ]
> > > 
> > > +int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> > > +			  const char *shstrtab, const char *strtab,
> > > +			  unsigned int symndx, struct module *pmod,
> > > +			  const char *objname)
> > >  {
> > >  	int i, cnt, ret = 0;
> > > -	const char *objname, *secname;
> > >  	char sec_objname[MODULE_NAME_LEN];
> > >  	Elf_Shdr *sec;
> > >  
> > > -	if (WARN_ON(!klp_is_object_loaded(obj)))
> > > -		return -EINVAL;
> > > -
> > > -	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > > -
> > >  	/* For each klp relocation section */
> > > -	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > > -		sec = pmod->klp_info->sechdrs + i;
> > > -		secname = pmod->klp_info->secstrings + sec->sh_name;
> > > +	for (i = 1; i < ehdr->e_shnum; i++) {
> > > +		sec = sechdrs + i;
> > 
> > Hi Josh, minor bug:
> > 
> > Note the for loop through the section headers in
> > klp_write_relocations(), but its calling function ...
> > 
> > > [ ... snip ... ]
> > > 
> > > diff --git a/kernel/module.c b/kernel/module.c
> > > index 646f1e2330d2..d36ea8a8c3ec 100644
> > > --- a/kernel/module.c
> > > +++ b/kernel/module.c
> > > @@ -2334,11 +2334,12 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
> > >  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
> > >  			continue;
> > >  
> > > -		/* Livepatch relocation sections are applied by livepatch */
> > >  		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> > > -			continue;
> > > -
> > > -		if (info->sechdrs[i].sh_type == SHT_REL)
> > > +			err = klp_write_relocations(info->hdr, info->sechdrs,
> > > +						    info->secstrings,
> > > +						    info->strtab,
> > > +						    info->index.sym, mod, NULL);
> > > +		else if (info->sechdrs[i].sh_type == SHT_REL)
> > >  			err = apply_relocate(info->sechdrs, info->strtab,
> > >  					     info->index.sym, i, mod);
> > >  		else if (info->sechdrs[i].sh_type == SHT_RELA)
> > 
> > ... apply_relocations() is also iterating over the section headers (the
> > diff context doesn't show it here, but i is an incrementing index over
> > sechdrs[]).
> > 
> > So if there is more than one KLP relocation section, we'll process them
> > multiple times.  At least the x86 relocation code will detect this and
> > fail the module load with an invalid relocation (existing value not
> > zero).
> 
> Ah, yes, good catch!
> 

The same test case passed with a small modification to push the foreach
KLP section part to a kernel/livepatch/core.c local function and
exposing the klp_resolve_symbols() + apply_relocate_add() for a given
section to kernel/module.c.  Something like following...

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 8b6886c2d5c7..516f285ccc82 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -232,9 +232,9 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
 struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
 struct klp_state *klp_get_prev_state(unsigned long id);
 
-int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			  const char *shstrtab, const char *strtab,
-			  unsigned int symindex, struct module *pmod,
+int klp_write_relocations(Elf_Shdr *sechdrs, const char *shstrtab,
+			  const char *strtab, unsigned int symndx,
+			  unsigned int relsec, struct module *pmod,
 			  const char *objname);
 
 /* Used to annotate symbol relocations in livepatches */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index d2610f63e70b..d74fd7d10f16 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -285,14 +285,48 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
  *    the to-be-patched module to be loaded and patched sometime *after* the
  *    klp module is loaded.
  */
-int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			  const char *shstrtab, const char *strtab,
-			  unsigned int symndx, struct module *pmod,
+
+int klp_write_relocations(Elf_Shdr *sechdrs, const char *shstrtab,
+			  const char *strtab, unsigned int symndx,
+			  unsigned int relsec, struct module *pmod,
 			  const char *objname)
 {
-	int i, cnt, ret = 0;
 	char sec_objname[MODULE_NAME_LEN];
 	Elf_Shdr *sec;
+	int cnt, ret;
+
+	sec = sechdrs + relsec;
+
+	/*
+	 * Format: .klp.rela.sec_objname.section_name
+	 * See comment in klp_resolve_symbols() for an explanation
+	 * of the selected field width value.
+	 */
+	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX "%55[^.]",
+		     sec_objname);
+	if (cnt != 1) {
+		pr_err("section %s has an incorrectly formatted name\n",
+		       shstrtab + sec->sh_name);
+		return -EINVAL;
+	}
+
+	if (strcmp(objname ? objname : "vmlinux", sec_objname))
+		return 0;
+
+	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
+	if (ret)
+		return ret;
+
+	return apply_relocate_add(sechdrs, strtab, symndx, relsec, pmod);
+}
+
+static int klp_write_all_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+				     const char *shstrtab, const char *strtab,
+				     unsigned int symndx, struct module *pmod,
+				     const char *objname)
+{
+	int i, ret;
+	Elf_Shdr *sec;
 
 	/* For each klp relocation section */
 	for (i = 1; i < ehdr->e_shnum; i++) {
@@ -300,34 +334,13 @@ int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
 			continue;
 
-		/*
-		 * Format: .klp.rela.sec_objname.section_name
-		 * See comment in klp_resolve_symbols() for an explanation
-		 * of the selected field width value.
-		 */
-		cnt = sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX "%55[^.]",
-			     sec_objname);
-		if (cnt != 1) {
-			pr_err("section %s has an incorrectly formatted name\n",
-			       shstrtab + sec->sh_name);
-			ret = -EINVAL;
-			break;
-		}
-
-		if (strcmp(objname ? objname : "vmlinux", sec_objname))
-			continue;
-
-		ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec,
-					  sec_objname);
+		ret = klp_write_relocations(sechdrs, shstrtab, strtab, symndx,
+					    i, pmod, objname);
 		if (ret)
-			break;
-
-		ret = apply_relocate_add(sechdrs, strtab, symndx, i, pmod);
-		if (ret)
-			break;
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -773,11 +786,11 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 		 * written earlier during the initialization of the klp module
 		 * itself.
 		 */
-		ret = klp_write_relocations(&info->hdr, info->sechdrs,
-					    info->secstrings,
-					    patch->mod->core_kallsyms.strtab,
-					    info->symndx, patch->mod,
-					    obj->name);
+		ret = klp_write_all_relocations(&info->hdr, info->sechdrs,
+						info->secstrings,
+						patch->mod->core_kallsyms.strtab,
+						info->symndx, patch->mod,
+						obj->name);
 		if (ret)
 			return ret;
 	}
diff --git a/kernel/module.c b/kernel/module.c
index 86736e2ff73d..04e5f5d55eb4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2322,10 +2322,11 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 			continue;
 
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
-			err = klp_write_relocations(info->hdr, info->sechdrs,
+			err = klp_write_relocations(info->sechdrs,
 						    info->secstrings,
 						    info->strtab,
-						    info->index.sym, mod, NULL);
+						    info->index.sym, i, mod,
+						    NULL);
 		else if (info->sechdrs[i].sh_type == SHT_REL)
 			err = apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);

