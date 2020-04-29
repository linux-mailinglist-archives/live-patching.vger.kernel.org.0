Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351051BE2A7
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgD2PZy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726929AbgD2PZP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0NNCNu4KS0FprZjjrTlqmZ6uV18rv2509FzBkSKIeU=;
        b=h10xlLmWAzhx+2NHafoDkMtXVcjQom8gFLjvrLIT3CjIGoiotla5dh+jvlO5b07Cl1A7Bf
        yx6K02kRKlSCJvRP+/nu8grfx2TrxEBwsMmnY0NQUKDj+bg8njBSf5geH0RnppTjsBb78t
        /NHB9oSitwa8U6DSe/Dh7pmZp9OIOb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-epJPCi9mMEO5IGo0QiVR2w-1; Wed, 29 Apr 2020 11:25:11 -0400
X-MC-Unique: epJPCi9mMEO5IGo0QiVR2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F790100A8D2;
        Wed, 29 Apr 2020 15:25:03 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D2725114B;
        Wed, 29 Apr 2020 15:25:02 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 02/11] livepatch: Apply vmlinux-specific KLP relocations early
Date:   Wed, 29 Apr 2020 10:24:44 -0500
Message-Id: <852333417504813eddcce4a24524d8c440d89973.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

KLP relocations are livepatch-specific relocations which are applied to
a KLP module's text or data.  They exist for two reasons:

  1) Unexported symbols: replacement functions often need to access
     unexported symbols (e.g. static functions), which "normal"
     relocations don't allow.

  2) Late module patching: this is the ability for a KLP module to
     bypass normal module dependencies, such that the KLP module can be
     loaded *before* a to-be-patched module.  This means that
     relocations which need to access symbols in the to-be-patched
     module might need to be applied to the KLP module well after it has
     been loaded.

Non-late-patched KLP relocations are applied from the KLP module's init
function.  That usually works fine, unless the patched code wants to use
alternatives, paravirt patching, jump tables, or some other special
section which needs relocations.  Then we run into ordering issues and
crashes.

In order for those special sections to work properly, the KLP
relocations should be applied *before* the special section init code
runs, such as apply_paravirt(), apply_alternatives(), or
jump_label_apply_nops().

You might think the obvious solution would be to move the KLP relocation
initialization earlier, but it's not necessarily that simple.  The
problem is the above-mentioned late module patching, for which KLP
relocations can get applied well after the KLP module is loaded.

To "fix" this issue in the past, we created .klp.arch sections:

  .klp.arch.{module}..altinstructions
  .klp.arch.{module}..parainstructions

Those sections allow KLP late module patching code to call
apply_paravirt() and apply_alternatives() after the module-specific KLP
relocations (.klp.rela.{module}.{section}) have been applied.

But that has a lot of drawbacks, including code complexity, the need for
arch-specific code, and the (per-arch) danger that we missed some
special section -- for example the __jump_table section which is used
for jump labels.

It turns out there's a simpler and more functional approach.  There are
two kinds of KLP relocation sections:

  1) vmlinux-specific KLP relocation sections

     .klp.rela.vmlinux.{sec}

     These are relocations (applied to the KLP module) which reference
     unexported vmlinux symbols.

  2) module-specific KLP relocation sections

     .klp.rela.{module}.{sec}:

     These are relocations (applied to the KLP module) which reference
     unexported or exported module symbols.

Up until now, these have been treated the same.  However, they're
inherently different.

Because of late module patching, module-specific KLP relocations can be
applied very late, thus they can create the ordering headaches described
above.

But vmlinux-specific KLP relocations don't have that problem.  There's
nothing to prevent them from being applied earlier.  So apply them at
the same time as normal relocations, when the KLP module is being
loaded.

This means that for vmlinux-specific KLP relocations, we no longer have
any ordering issues.  vmlinux-referencing jump labels, alternatives, and
paravirt patching will work automatically, without the need for the
.klp.arch hacks.

All that said, for module-specific KLP relocations, the ordering
problems still exist and we *do* still need .klp.arch.  Or do we?  Stay
tuned.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/livepatch.h |  14 ++++
 kernel/livepatch/core.c   | 137 ++++++++++++++++++++++++--------------
 kernel/module.c           |  10 +--
 3 files changed, 106 insertions(+), 55 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index e894e74905f3..c4302e9a5905 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -234,6 +234,11 @@ void klp_shadow_free_all(unsigned long id, klp_shado=
w_dtor_t dtor);
 struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long i=
d);
 struct klp_state *klp_get_prev_state(unsigned long id);
=20
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symindex, unsigned int secindex,
+			     const char *objname);
+
 #else /* !CONFIG_LIVEPATCH */
=20
 static inline int klp_module_coming(struct module *mod) { return 0; }
@@ -242,6 +247,15 @@ static inline bool klp_patch_pending(struct task_str=
uct *task) { return false; }
 static inline void klp_update_patch_state(struct task_struct *task) {}
 static inline void klp_copy_process(struct task_struct *child) {}
=20
+static inline
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symindex, unsigned int secindex,
+			     const char *objname)
+{
+	return 0;
+}
+
 #endif /* CONFIG_LIVEPATCH */
=20
 #endif /* _LINUX_LIVEPATCH_H_ */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 40cfac8156fd..c02791e5c75b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -191,12 +191,12 @@ static int klp_find_object_symbol(const char *objna=
me, const char *name,
 	return -EINVAL;
 }
=20
-static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
+static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
+			       unsigned int symndx, Elf_Shdr *relasec)
 {
 	int i, cnt, vmlinux, ret;
 	char objname[MODULE_NAME_LEN];
 	char symname[KSYM_NAME_LEN];
-	char *strtab =3D pmod->core_kallsyms.strtab;
 	Elf_Rela *relas;
 	Elf_Sym *sym;
 	unsigned long sympos, addr;
@@ -216,7 +216,7 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, str=
uct module *pmod)
 	relas =3D (Elf_Rela *) relasec->sh_addr;
 	/* For each rela in this klp relocation section */
 	for (i =3D 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
-		sym =3D pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
+		sym =3D (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_in=
fo);
 		if (sym->st_shndx !=3D SHN_LIVEPATCH) {
 			pr_err("symbol %s is not marked as a livepatch symbol\n",
 			       strtab + sym->st_name);
@@ -246,54 +246,59 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, s=
truct module *pmod)
 	return 0;
 }
=20
-static int klp_write_object_relocations(struct module *pmod,
-					struct klp_object *obj)
+/*
+ * At a high-level, there are two types of klp relocation sections: thos=
e which
+ * reference symbols which live in vmlinux; and those which reference sy=
mbols
+ * which live in other modules.  This function is called for both types:
+ *
+ * 1) When a klp module itself loads, the module code calls this functio=
n to
+ *    write vmlinux-specific klp relocations (.klp.rela.vmlinux.* sectio=
ns).
+ *    These relocations are written to the klp module text to allow the =
patched
+ *    code/data to reference unexported vmlinux symbols.  They're writte=
n as
+ *    early as possible to ensure that other module init code (.e.g.,
+ *    jump_label_apply_nops) can access any unexported vmlinux symbols w=
hich
+ *    might be referenced by the klp module's special sections.
+ *
+ * 2) When a to-be-patched module loads -- or is already loaded when a
+ *    corresponding klp module loads -- klp code calls this function to =
write
+ *    module-specific klp relocations (.klp.rela.{module}.* sections).  =
These
+ *    are written to the klp module text to allow the patched code/data =
to
+ *    reference symbols which live in the to-be-patched module or one of=
 its
+ *    module dependencies.  Exported symbols are supported, in addition =
to
+ *    unexported symbols, in order to enable late module patching, which=
 allows
+ *    the to-be-patched module to be loaded and patched sometime *after*=
 the
+ *    klp module is loaded.
+ */
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symndx, unsigned int secndx,
+			     const char *objname)
 {
-	int i, cnt, ret =3D 0;
-	const char *objname, *secname;
+	int cnt, ret;
 	char sec_objname[MODULE_NAME_LEN];
-	Elf_Shdr *sec;
+	Elf_Shdr *sec =3D sechdrs + secndx;
=20
-	if (WARN_ON(!klp_is_object_loaded(obj)))
+	/*
+	 * Format: .klp.rela.sec_objname.section_name
+	 * See comment in klp_resolve_symbols() for an explanation
+	 * of the selected field width value.
+	 */
+	cnt =3D sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+		     sec_objname);
+	if (cnt !=3D 1) {
+		pr_err("section %s has an incorrectly formatted name\n",
+		       shstrtab + sec->sh_name);
 		return -EINVAL;
+	}
=20
-	objname =3D klp_is_module(obj) ? obj->name : "vmlinux";
-
-	/* For each klp relocation section */
-	for (i =3D 1; i < pmod->klp_info->hdr.e_shnum; i++) {
-		sec =3D pmod->klp_info->sechdrs + i;
-		secname =3D pmod->klp_info->secstrings + sec->sh_name;
-		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
-			continue;
-
-		/*
-		 * Format: .klp.rela.sec_objname.section_name
-		 * See comment in klp_resolve_symbols() for an explanation
-		 * of the selected field width value.
-		 */
-		cnt =3D sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
-		if (cnt !=3D 1) {
-			pr_err("section %s has an incorrectly formatted name\n",
-			       secname);
-			ret =3D -EINVAL;
-			break;
-		}
-
-		if (strcmp(objname, sec_objname))
-			continue;
-
-		ret =3D klp_resolve_symbols(sec, pmod);
-		if (ret)
-			break;
+	if (strcmp(objname ? objname : "vmlinux", sec_objname))
+		return 0;
=20
-		ret =3D apply_relocate_add(pmod->klp_info->sechdrs,
-					 pmod->core_kallsyms.strtab,
-					 pmod->klp_info->symndx, i, pmod);
-		if (ret)
-			break;
-	}
+	ret =3D klp_resolve_symbols(sechdrs, strtab, symndx, sec);
+	if (ret)
+		return ret;
=20
-	return ret;
+	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
 }
=20
 /*
@@ -730,6 +735,28 @@ void __weak arch_klp_init_object_loaded(struct klp_p=
atch *patch,
 {
 }
=20
+int klp_apply_object_relocs(struct klp_patch *patch, struct klp_object *=
obj)
+{
+	int i, ret;
+	struct klp_modinfo *info =3D patch->mod->klp_info;
+
+	for (i =3D 1; i < info->hdr.e_shnum; i++) {
+		Elf_Shdr *sec =3D info->sechdrs + i;
+
+		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		ret =3D klp_apply_section_relocs(patch->mod, info->sechdrs,
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
 /* parts of the initialization that is done only when the object is load=
ed */
 static int klp_init_object_loaded(struct klp_patch *patch,
 				  struct klp_object *obj)
@@ -738,18 +765,26 @@ static int klp_init_object_loaded(struct klp_patch =
*patch,
 	int ret;
=20
 	mutex_lock(&text_mutex);
-
 	module_disable_ro(patch->mod);
-	ret =3D klp_write_object_relocations(patch->mod, obj);
-	if (ret) {
-		module_enable_ro(patch->mod, true);
-		mutex_unlock(&text_mutex);
-		return ret;
+
+	if (klp_is_module(obj)) {
+		/*
+		 * Only write module-specific relocations here
+		 * (.klp.rela.{module}.*).  vmlinux-specific relocations were
+		 * written earlier during the initialization of the klp module
+		 * itself.
+		 */
+		ret =3D klp_apply_object_relocs(patch, obj);
+		if (ret) {
+			module_enable_ro(patch->mod, true);
+			mutex_unlock(&text_mutex);
+			return ret;
+		}
 	}
=20
 	arch_klp_init_object_loaded(patch, obj);
-	module_enable_ro(patch->mod, true);
=20
+	module_enable_ro(patch->mod, true);
 	mutex_unlock(&text_mutex);
=20
 	klp_for_each_func(obj, func) {
diff --git a/kernel/module.c b/kernel/module.c
index d626dc31b37f..96b2575329f4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2363,11 +2363,13 @@ static int apply_relocations(struct module *mod, =
const struct load_info *info)
 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
=20
-		/* Livepatch relocation sections are applied by livepatch */
 		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
-			continue;
-
-		if (info->sechdrs[i].sh_type =3D=3D SHT_REL)
+			err =3D klp_apply_section_relocs(mod, info->sechdrs,
+						       info->secstrings,
+						       info->strtab,
+						       info->index.sym, i,
+						       NULL);
+		else if (info->sechdrs[i].sh_type =3D=3D SHT_REL)
 			err =3D apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);
 		else if (info->sechdrs[i].sh_type =3D=3D SHT_RELA)
--=20
2.21.1

