Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2B1B1582
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2020 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDTTL3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Apr 2020 15:11:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbgDTTL2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Apr 2020 15:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587409886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eO9YXDr/mCidnJMfjRT+7Um9k0phawd3zi+O/FYIxvI=;
        b=HgD9/j2VjXweTnX/kcF7+9M6o7y1Ie0cPzzmHRtRE5OiLzp6ogb9hv0igbG9DVQAPR56nE
        A+fmkdy+GucGR6UeFXCbgPQLF20Bc0nN1ffkxKPQFzcLTwuDe1OVBJDWoUxNgBtkU8AyNe
        OAkbkdwXiZxZlvPjddUYiZoIV8B+bmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-tVKwHA9OOqKkWflS6Vzatw-1; Mon, 20 Apr 2020 15:11:24 -0400
X-MC-Unique: tVKwHA9OOqKkWflS6Vzatw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77425107ACC4;
        Mon, 20 Apr 2020 19:11:23 +0000 (UTC)
Received: from treble (ovpn-118-158.rdu2.redhat.com [10.10.118.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC4EE60C87;
        Mon, 20 Apr 2020 19:11:19 +0000 (UTC)
Date:   Mon, 20 Apr 2020 14:11:17 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200420191117.wrjauayeutkpvkwd@treble>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
 <20200420175751.GA13807@redhat.com>
 <20200420182516.6awwwbvoen62gwbr@treble>
 <20200420190141.GB13807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200420190141.GB13807@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 20, 2020 at 03:01:41PM -0400, Joe Lawrence wrote:
> > > ... apply_relocations() is also iterating over the section headers (the
> > > diff context doesn't show it here, but i is an incrementing index over
> > > sechdrs[]).
> > > 
> > > So if there is more than one KLP relocation section, we'll process them
> > > multiple times.  At least the x86 relocation code will detect this and
> > > fail the module load with an invalid relocation (existing value not
> > > zero).
> > 
> > Ah, yes, good catch!
> > 
> 
> The same test case passed with a small modification to push the foreach
> KLP section part to a kernel/livepatch/core.c local function and
> exposing the klp_resolve_symbols() + apply_relocate_add() for a given
> section to kernel/module.c.  Something like following...

I came up with something very similar, though I named them
klp_apply_object_relocs() and klp_apply_section_relocs() and changed the
argument order a bit (module first).  Since it sounds like you have a
test, could you try this one?

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 533359e48c39..fb1a3de39726 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -231,10 +231,10 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
 struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
 struct klp_state *klp_get_prev_state(unsigned long id);
 
-int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			  const char *shstrtab, const char *strtab,
-			  unsigned int symindex, struct module *pmod,
-			  const char *objname);
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symindex, unsigned int secindex,
+			     const char *objname);
 
 #else /* !CONFIG_LIVEPATCH */
 
@@ -245,10 +245,10 @@ static inline void klp_update_patch_state(struct task_struct *task) {}
 static inline void klp_copy_process(struct task_struct *child) {}
 
 static inline
-int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			  const char *shstrtab, const char *strtab,
-			  unsigned int symindex, struct module *pmod,
-			  const char *objname)
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symindex, unsigned int secindex,
+			     const char *objname);
 {
 	return 0;
 }
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3ff886b911ae..89c5cb962c54 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -285,49 +285,37 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
  *    the to-be-patched module to be loaded and patched sometime *after* the
  *    klp module is loaded.
  */
-int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			  const char *shstrtab, const char *strtab,
-			  unsigned int symndx, struct module *pmod,
-			  const char *objname)
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symndx, unsigned int secndx,
+			     const char *objname)
 {
-	int i, cnt, ret = 0;
+	int cnt, ret;
 	char sec_objname[MODULE_NAME_LEN];
-	Elf_Shdr *sec;
+	Elf_Shdr *sec = sechdrs + secndx;
 
-	/* For each klp relocation section */
-	for (i = 1; i < ehdr->e_shnum; i++) {
-		sec = sechdrs + i;
-		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
-			continue;
-
-		/*
-		 * Format: .klp.rela.sec_objname.section_name
-		 * See comment in klp_resolve_symbols() for an explanation
-		 * of the selected field width value.
-		 */
-		cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
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
+	/*
+	 * Format: .klp.rela.sec_objname.section_name
+	 * See comment in klp_resolve_symbols() for an explanation
+	 * of the selected field width value.
+	 */
+	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+		     sec_objname);
+	if (cnt != 1) {
+		pr_err("section %s has an incorrectly formatted name\n",
+		       shstrtab + sec->sh_name);
+		return -EINVAL;
+	}
 
-		ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec,
-					  sec_objname);
-		if (ret)
-			break;
+	if (strcmp(objname ? objname : "vmlinux", sec_objname))
+		return 0;
 
-		ret = apply_relocate_add(sechdrs, strtab, symndx, i, pmod);
-		if (ret)
-			break;
-	}
+	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec,
+				  sec_objname);
+	if (ret)
+		return ret;
 
-	return ret;
+	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
 }
 
 /*
@@ -758,13 +746,34 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 			   func->old_sympos ? func->old_sympos : 1);
 }
 
+int klp_apply_object_relocs(struct klp_patch *patch, struct klp_object *obj)
+{
+	int i, ret;
+	struct klp_modinfo *info = patch->mod->klp_info;
+
+	for (i = 1; i < info->hdr.e_shnum; i++) {
+		Elf_Shdr *sec = info->sechdrs + i;
+
+		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		ret = klp_apply_section_relocs(patch->mod, info->sechdrs,
+					       info->secstrings,
+					       patch->mod->core_kallsyms.strtab,
+					       info->symndx, i, obj->name);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* parts of the initialization that is done only when the object is loaded */
 static int klp_init_object_loaded(struct klp_patch *patch,
 				  struct klp_object *obj)
 {
 	struct klp_func *func;
 	int ret;
-	struct klp_modinfo *info = patch->mod->klp_info;
 
 	if (klp_is_module(obj)) {
 		/*
@@ -773,11 +782,7 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 		 * written earlier during the initialization of the klp module
 		 * itself.
 		 */
-		ret = klp_write_relocations(&info->hdr, info->sechdrs,
-					    info->secstrings,
-					    patch->mod->core_kallsyms.strtab,
-					    info->symndx, patch->mod,
-					    obj->name);
+		ret = klp_apply_object_relocs(patch, obj);
 		if (ret)
 			return ret;
 	}
diff --git a/kernel/module.c b/kernel/module.c
index b1d30ad67e82..3ba024afe379 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2322,10 +2322,11 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 			continue;
 
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
-			err = klp_write_relocations(info->hdr, info->sechdrs,
-						    info->secstrings,
-						    info->strtab,
-						    info->index.sym, mod, NULL);
+			err = klp_apply_section_relocs(mod, info->sechdrs,
+						       info->secstrings,
+						       info->strtab,
+						       info->index.sym, i,
+						       NULL);
 		else if (info->sechdrs[i].sh_type == SHT_REL)
 			err = apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);

