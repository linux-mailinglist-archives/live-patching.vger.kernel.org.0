Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC453E57BD
	for <lists+live-patching@lfdr.de>; Sat, 26 Oct 2019 03:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfJZBR6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Oct 2019 21:17:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbfJZBR6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Oct 2019 21:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572052675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GoHvlqvPfjBondqffUEteTkYQZE4TBWkfN2KJe/rew=;
        b=NS93vu93i9ZrGIDDdl9wpQrVKKKLZy1Yup5Lb/52nVAGFblhO+a/z2iF9wg8qT+1JnGV6Q
        XFMqldx+kOGtup9KTYNjb28wxp8UeqyDDUymUeXdVXY+1KCx6rzzLV2wmpNJ9FHk3YUFC8
        dl1Uo6Klw5K7NjbDkyu8QmtRsmbBZkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-ActPXkh1OS-CpxBO0Ph6Gg-1; Fri, 25 Oct 2019 21:17:51 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F48C107AD25;
        Sat, 26 Oct 2019 01:17:49 +0000 (UTC)
Received: from treble (ovpn-121-225.rdu2.redhat.com [10.10.121.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C936E5DD61;
        Sat, 26 Oct 2019 01:17:43 +0000 (UTC)
Date:   Fri, 25 Oct 2019 20:17:41 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191026011741.xywerjv62vdmz6sp@treble>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
 <20191025084300.GG4131@hirez.programming.kicks-ass.net>
 <20191025100612.GB5671@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20191025100612.GB5671@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: ActPXkh1OS-CpxBO0Ph6Gg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 12:06:12PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 25, 2019 at 10:43:00AM +0200, Peter Zijlstra wrote:
>=20
> > But none of that explains why apply_alternatives() is also delayed.
> >=20
> > So I'm very tempted to just revert that patchset for doing it all
> > wrong.
>=20
> And I've done just that. This includes Josh's validation patch, the
> revert and my klp_appy_relocations_add() patches with the removal of
> module_disable_ro().
>=20
> Josh, can you test or give me clue on how to test? I need to run a few
> errands today, but I'll try and have a poke either tonight or tomorrow.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git x86/rwx

I looked at this today.  A few potential tweaks:

- The new klp_apply_relocate_add() interface isn't needed.  Instead
  apply_relocate_add() can use the module state to decide whether to
  text_poke().

- For robustness I think we need to apply vmlinux-specific klp
  relocations at the same time as normal relocations.

Rough untested changes below.  I still need to finish changing
kpatch-build and then I'll need to do a LOT of testing.

I can take over the livepatch-specific patches if you want.  Or however
you want to do it.

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 7fc519b9b4e0..6a70213854f0 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -451,14 +451,11 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char =
*strtab,
 =09=09       unsigned int symindex, unsigned int relsec,
 =09=09       struct module *me)
 {
-=09return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me, memw=
rite);
-}
+=09int ret;
+=09bool early =3D me->state !=3D MODULE_STATE_LIVE;
=20
-int klp_apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
-=09=09       unsigned int symindex, unsigned int relsec,
-=09=09       struct module *me)
-{
-=09return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me, s390=
_kernel_write);
+=09return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+=09=09=09=09    early ? memwrite : s390_kernel_write);
 }
=20
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 5eee618a98c5..30174798ff79 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -222,20 +222,14 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 =09=09   unsigned int symindex,
 =09=09   unsigned int relsec,
 =09=09   struct module *me)
-{
-=09return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me, memc=
py);
-}
-
-int klp_apply_relocate_add(Elf64_Shdr *sechdrs,
-=09=09   const char *strtab,
-=09=09   unsigned int symindex,
-=09=09   unsigned int relsec,
-=09=09   struct module *me)
 {
 =09int ret;
+=09bool early =3D me->state !=3D MODULE_STATE_LIVE;
+
+=09ret =3D __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+=09=09=09=09   early ? memcpy : text_poke);
=20
-=09ret =3D __apply_relocate_add(sechdrs, strtab, symindex, relsec, me, tex=
t_poke);
-=09if (!ret)
+=09if (!ret && !early)
 =09=09text_poke_sync();
=20
 =09return ret;
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index cc18f945bdb2..b00170696db2 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -214,12 +214,7 @@ void *klp_shadow_get_or_alloc(void *obj, unsigned long=
 id,
 void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
=20
-
-extern int klp_apply_relocate_add(Elf64_Shdr *sechdrs,
-=09=09=09      const char *strtab,
-=09=09=09      unsigned int symindex,
-=09=09=09      unsigned int relsec,
-=09=09=09      struct module *me);
+int klp_write_relocations(struct module *mod, struct klp_object *obj);
=20
 #else /* !CONFIG_LIVEPATCH */
=20
@@ -229,6 +224,12 @@ static inline bool klp_patch_pending(struct task_struc=
t *task) { return false; }
 static inline void klp_update_patch_state(struct task_struct *task) {}
 static inline void klp_copy_process(struct task_struct *child) {}
=20
+static inline int klp_write_relocations(struct module *mod,
+=09=09=09=09=09struct klp_object *obj)
+{
+=09return 0;
+}
+
 #endif /* CONFIG_LIVEPATCH */
=20
 #endif /* _LINUX_LIVEPATCH_H_ */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 30395302a273..52eb91d0ee8d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -256,27 +256,60 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, str=
uct module *pmod)
 =09return 0;
 }
=20
-int __weak klp_apply_relocate_add(Elf64_Shdr *sechdrs,
-=09=09=09      const char *strtab,
-=09=09=09      unsigned int symindex,
-=09=09=09      unsigned int relsec,
-=09=09=09      struct module *me)
-{
-=09return apply_relocate_add(sechdrs, strtab, symindex, relsec, me);
-}
-
-static int klp_write_object_relocations(struct module *pmod,
-=09=09=09=09=09struct klp_object *obj)
+/*
+ * This function is called for both vmlinux-specific and module-specific k=
lp
+ * relocation sections:
+ *
+ * 1) When the klp module itself loads, the module code calls this functio=
n
+ *    to write vmlinux-specific klp relocations.  These relocations allow =
the
+ *    patched code/data to reference unexported vmlinux symbols.  They're
+ *    written as early as possible to ensure that other module init code
+ *    (.e.g., jump_label_apply_nops) can access any non-exported vmlinux
+ *    symbols which might be referenced by the klp module's special sectio=
ns.
+ *
+ * 2) When a to-be-patched module loads (or is already loaded when the
+ *    klp module loads), klp code calls this function to write klp relocat=
ions
+ *    which are specific to the module.  These relocations allow the patch=
ed
+ *    code/data to reference module symbols, both unexported and exported.
+ *    They also enable late module patching, which means the to-be-patched
+ *    module may be loaded *after* the klp module.
+ *
+ *    The following restrictions apply to module-specific relocation secti=
ons:
+ *
+ *    a) References to vmlinux symbols are not allowed.  Otherwise there m=
ight
+ *       be module init ordering issues, and crashes might occur in some o=
f the
+ *       other kernel patching components like paravirt patching or jump
+ *       labels.  All references to vmlinux symbols should use either norm=
al
+ *       relas (for exported symbols) or vmlinux-specific klp relas (for
+ *       unexported symbols).  This restriction is enforced in
+ *       klp_resolve_symbols().
+ *
+ *    b) Relocations to special sections like __jump_table and .altinstruc=
tions
+ *       aren't allowed.  In other words, there should never be a
+ *       .klp.rela.{module}.__jump_table section.  This will definitely ca=
use
+ *       initialization ordering issues, as such special sections are proc=
essed
+ *       during the loading of the klp module itself, *not* the to-be-patc=
hed
+ *       module.  This means that e.g., it's not currently possible to pat=
ch a
+ *       module function which uses a static key jump label, if you want t=
o
+ *       have the replacement function also use the same static key.  In t=
his
+ *       case, a non-static interface like static_key_enabled() can be use=
d in
+ *       the new function instead.
+ *
+ *       On the other hand, a .klp.rela.vmlinux.__jump_table section is fi=
ne,
+ *       as it can be resolved early enough during the load of the klp mod=
ule,
+ *       as described above.
+ */
+int klp_write_relocations(struct module *pmod, struct klp_object *obj)
 {
 =09int i, cnt, ret =3D 0;
 =09const char *objname, *secname;
 =09char sec_objname[MODULE_NAME_LEN];
 =09Elf_Shdr *sec;
=20
-=09if (WARN_ON(!klp_is_object_loaded(obj)))
+=09if (WARN_ON(obj && !klp_is_object_loaded(obj)))
 =09=09return -EINVAL;
=20
-=09objname =3D klp_is_module(obj) ? obj->name : "vmlinux";
+=09objname =3D obj ? obj->name : "vmlinux";
=20
 =09/* For each klp relocation section */
 =09for (i =3D 1; i < pmod->klp_info->hdr.e_shnum; i++) {
@@ -305,7 +338,7 @@ static int klp_write_object_relocations(struct module *=
pmod,
 =09=09if (ret)
 =09=09=09break;
=20
-=09=09ret =3D klp_apply_relocate_add(pmod->klp_info->sechdrs,
+=09=09ret =3D apply_relocate_add(pmod->klp_info->sechdrs,
 =09=09=09=09=09 pmod->core_kallsyms.strtab,
 =09=09=09=09=09 pmod->klp_info->symndx, i, pmod);
 =09=09if (ret)
@@ -733,16 +766,25 @@ static int klp_init_object_loaded(struct klp_patch *p=
atch,
 =09struct klp_func *func;
 =09int ret;
=20
-=09mutex_lock(&text_mutex);
+=09if (klp_is_module(obj)) {
+
+=09=09/*
+=09=09 * Only write module-specific relocations here.
+=09=09 * vmlinux-specific relocations were already written during the
+=09=09 * loading of the klp module.
+=09=09 */
+
+=09=09mutex_lock(&text_mutex);
+
+=09=09ret =3D klp_write_relocations(patch->mod, obj);
+=09=09if (ret) {
+=09=09=09mutex_unlock(&text_mutex);
+=09=09=09return ret;
+=09=09}
=20
-=09ret =3D klp_write_object_relocations(patch->mod, obj);
-=09if (ret) {
 =09=09mutex_unlock(&text_mutex);
-=09=09return ret;
 =09}
=20
-=09mutex_unlock(&text_mutex);
-
 =09klp_for_each_func(obj, func) {
 =09=09ret =3D klp_find_object_symbol(obj->name, func->old_name,
 =09=09=09=09=09     func->old_sympos,
diff --git a/kernel/module.c b/kernel/module.c
index fe5bd382759c..ff4347385f05 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2327,11 +2327,9 @@ static int apply_relocations(struct module *mod, con=
st struct load_info *info)
 =09=09if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 =09=09=09continue;
=20
-=09=09/* Livepatch relocation sections are applied by livepatch */
 =09=09if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
-=09=09=09continue;
-
-=09=09if (info->sechdrs[i].sh_type =3D=3D SHT_REL)
+=09=09=09err =3D klp_write_relocations(mod, NULL);
+=09=09else if (info->sechdrs[i].sh_type =3D=3D SHT_REL)
 =09=09=09err =3D apply_relocate(info->sechdrs, info->strtab,
 =09=09=09=09=09     info->index.sym, i, mod);
 =09=09else if (info->sechdrs[i].sh_type =3D=3D SHT_RELA)
@@ -3812,18 +3810,24 @@ static int load_module(struct load_info *info, cons=
t char __user *uargs,
 =09/* Set up MODINFO_ATTR fields */
 =09setup_modinfo(mod, info);
=20
+=09if (is_livepatch_module(mod)) {
+=09=09err =3D copy_module_elf(mod, info);
+=09=09if (err < 0)
+=09=09=09goto free_modinfo;
+=09}
+
 =09/* Fix up syms, so that st_value is a pointer to location. */
 =09err =3D simplify_symbols(mod, info);
 =09if (err < 0)
-=09=09goto free_modinfo;
+=09=09goto free_elf_copy;
=20
 =09err =3D apply_relocations(mod, info);
 =09if (err < 0)
-=09=09goto free_modinfo;
+=09=09goto free_elf_copy;
=20
 =09err =3D post_relocation(mod, info);
 =09if (err < 0)
-=09=09goto free_modinfo;
+=09=09goto free_elf_copy;
=20
 =09flush_module_icache(mod);
=20
@@ -3866,12 +3870,6 @@ static int load_module(struct load_info *info, const=
 char __user *uargs,
 =09if (err < 0)
 =09=09goto coming_cleanup;
=20
-=09if (is_livepatch_module(mod)) {
-=09=09err =3D copy_module_elf(mod, info);
-=09=09if (err < 0)
-=09=09=09goto sysfs_cleanup;
-=09}
-
 =09/* Get rid of temporary copy. */
 =09free_copy(info);
=20
@@ -3880,8 +3878,6 @@ static int load_module(struct load_info *info, const =
char __user *uargs,
=20
 =09return do_init_module(mod);
=20
- sysfs_cleanup:
-=09mod_sysfs_teardown(mod);
  coming_cleanup:
 =09mod->state =3D MODULE_STATE_GOING;
 =09destroy_params(mod->kp, mod->num_kp);
@@ -3901,6 +3897,8 @@ static int load_module(struct load_info *info, const =
char __user *uargs,
 =09kfree(mod->args);
  free_arch_cleanup:
 =09module_arch_cleanup(mod);
+ free_elf_copy:
+=09free_module_elf(mod);
  free_modinfo:
 =09free_modinfo(mod);
  free_unload:

