Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B35267628B
	for <lists+live-patching@lfdr.de>; Sat, 21 Jan 2023 01:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjAUAuG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 19:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjAUAuG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 19:50:06 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9661B55C
        for <live-patching@vger.kernel.org>; Fri, 20 Jan 2023 16:50:04 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KMugNd011701
        for <live-patching@vger.kernel.org>; Fri, 20 Jan 2023 16:50:03 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n7gdeexq0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 20 Jan 2023 16:50:03 -0800
Received: from twshared16996.15.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 20 Jan 2023 16:50:00 -0800
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 7114F1406D011; Fri, 20 Jan 2023 16:49:57 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <linux-modules@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <x86@kernel.org>, Song Liu <song@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v10 2/2] livepatch,x86: Clear relocation targets on a module removal
Date:   Fri, 20 Jan 2023 16:49:45 -0800
Message-ID: <20230121004945.697003-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230121004945.697003-1-song@kernel.org>
References: <20230121004945.697003-1-song@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: MGLrgfFXO_sVpKr0V3ry97MbF-TtmFq1
X-Proofpoint-ORIG-GUID: MGLrgfFXO_sVpKr0V3ry97MbF-TtmFq1
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_13,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh reported a bug:

  When the object to be patched is a module, and that module is
  rmmod'ed and reloaded, it fails to load with:

  module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
  livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
  livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

  The livepatch module has a relocation which references a symbol
  in the _previous_ loading of nfsd. When apply_relocate_add()
  tries to replace the old relocation with a new one, it sees that
  the previous one is nonzero and it errors out.

He also proposed three different solutions. We could remove the error
check in apply_relocate_add() introduced by commit eda9cec4c9a1
("x86/module: Detect and skip invalid relocations"). However the check
is useful for detecting corrupted modules.

We could also deny the patched modules to be removed. If it proved to be
a major drawback for users, we could still implement a different
approach. The solution would also complicate the existing code a lot.

We thus decided to reverse the relocation patching (clear all relocation
targets on x86_64). The solution is not
universal and is too much arch-specific, but it may prove to be simpler
in the end.

Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
Originally-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Miroslav Benes <mbenes@suse.cz>

---

NOTE: powerpc32 code is only compile tested.

Changes v9 => v10:
1. Revise commit log. (Josh Poimboeuf)
2. Various improvements in code style, comments, etc. (Josh Poimboeuf)

Changes v8 => v9:
1. Fix overflow check for R_X86_64_PC32 and R_X86_64_PLT32. (Petr Mladek)

Changes v7 = v8:
1. Remove the logic in powerpc/kernel/module_64.c, as there is ongoing
   discussions.
2. For x86_64, add check for expected value during clear_relocate_add().
   (Petr Mladek)
3. Optimize the logic in klp_write_section_relocs(). (Petr Mladek)
4. Optimize __write_relocate_add (x86_64). (Joe Lawrence)

Changes v6 = v7:
1. Reduce code duplication in livepatch/core.c and x86/kernel/module.c.
2. Add more comments to powerpc/kernel/module_64.c.
3. Added Joe's Tested-by (which I should have added in v6).

Changes v5 = v6:
1. Fix powerpc64.
2. Fix compile for powerpc32.

Changes v4 = v5:
1. Fix compile with powerpc.

Changes v3 = v4:
1. Reuse __apply_relocate_add to make it more reliable in long term.
   (Josh Poimboeuf)
2. Add back ppc64 logic from v2, with changes to match current code.
   (Josh Poimboeuf)

Changes v2 => v3:
1. Rewrite x86 changes to match current code style.
2. Remove powerpc changes as there is no test coverage in v3.
3. Only keep 1/3 of v2.

v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u

fix
---
 arch/powerpc/kernel/module_32.c | 10 ++++
 arch/powerpc/kernel/module_64.c | 10 ++++
 arch/s390/kernel/module.c       |  8 +++
 arch/x86/kernel/module.c        | 93 +++++++++++++++++++++------------
 include/linux/moduleloader.h    | 17 ++++++
 kernel/livepatch/core.c         | 54 ++++++++++++++-----
 6 files changed, 146 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
index ea6536171778..e3c312770453 100644
--- a/arch/powerpc/kernel/module_32.c
+++ b/arch/powerpc/kernel/module_32.c
@@ -285,6 +285,16 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	return 0;
 }
 
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+}
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 notrace int module_trampoline_target(struct module *mod, unsigned long addr,
 				     unsigned long *target)
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index ff045644f13f..1096d6b3a62c 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -749,6 +749,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 }
 
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+}
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 int module_trampoline_target(struct module *mod, unsigned long addr,
 			     unsigned long *target)
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 2d159b32885b..cc6784fbc1ac 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -500,6 +500,14 @@ static int module_alloc_ftrace_hotpatch_trampolines(struct module *me,
 }
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
+			unsigned int symindex, unsigned int relsec,
+			struct module *me)
+{
+}
+#endif
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 1dee3ad82da2..e4aab0395a33 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -129,22 +129,27 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 	return 0;
 }
 #else /*X86_64*/
-static int __apply_relocate_add(Elf64_Shdr *sechdrs,
+static int __write_relocate_add(Elf64_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
 		   unsigned int relsec,
 		   struct module *me,
-		   void *(*write)(void *dest, const void *src, size_t len))
+		   void *(*write)(void *dest, const void *src, size_t len),
+		   bool apply)
 {
 	unsigned int i;
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	void *loc;
 	u64 val;
+	u64 zero = 0ULL;
 
-	DEBUGP("Applying relocate section %u to %u\n",
+	DEBUGP("%s relocate section %u to %u\n",
+	       apply ? "Applying" : "Clearing",
 	       relsec, sechdrs[relsec].sh_info);
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		int size = 0;
+
 		/* This is where to make the change */
 		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
 			+ rel[i].r_offset;
@@ -162,52 +167,53 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
 
 		switch (ELF64_R_TYPE(rel[i].r_info)) {
 		case R_X86_64_NONE:
-			break;
+			continue;  /* nothing to write */
 		case R_X86_64_64:
-			if (*(u64 *)loc != 0)
-				goto invalid_relocation;
-			write(loc, &val, 8);
+			size = 8;
 			break;
 		case R_X86_64_32:
-			if (*(u32 *)loc != 0)
-				goto invalid_relocation;
-			write(loc, &val, 4);
-			if (val != *(u32 *)loc)
+			if (val != *(u32 *)&val)
 				goto overflow;
+			size = 4;
 			break;
 		case R_X86_64_32S:
-			if (*(s32 *)loc != 0)
-				goto invalid_relocation;
-			write(loc, &val, 4);
-			if ((s64)val != *(s32 *)loc)
+			if ((s64)val != *(s32 *)&val)
 				goto overflow;
+			size = 4;
 			break;
 		case R_X86_64_PC32:
 		case R_X86_64_PLT32:
-			if (*(u32 *)loc != 0)
-				goto invalid_relocation;
 			val -= (u64)loc;
-			write(loc, &val, 4);
+			size = 4;
 			break;
 		case R_X86_64_PC64:
-			if (*(u64 *)loc != 0)
-				goto invalid_relocation;
 			val -= (u64)loc;
-			write(loc, &val, 8);
+			size = 8;
 			break;
 		default:
 			pr_err("%s: Unknown rela relocation: %llu\n",
 			       me->name, ELF64_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
+
+		if (apply) {
+			if (memcmp(loc, &zero, size)) {
+				pr_err("x86/modules: Invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
+				       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				return -ENOEXEC;
+			}
+			write(loc, &val, size);
+		} else {
+			if (memcmp(loc, &val, size)) {
+				pr_warn("x86/modules: Invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
+					(int)ELF64_R_TYPE(rel[i].r_info), loc, val);
+				return -ENOEXEC;
+			}
+			write(loc, &zero, size);
+		}
 	}
 	return 0;
 
-invalid_relocation:
-	pr_err("x86/modules: Skipping invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
-	       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
-	return -ENOEXEC;
-
 overflow:
 	pr_err("overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
@@ -216,11 +222,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
 	return -ENOEXEC;
 }
 
-int apply_relocate_add(Elf64_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
+static int write_relocate_add(Elf64_Shdr *sechdrs,
+			      const char *strtab,
+			      unsigned int symindex,
+			      unsigned int relsec,
+			      struct module *me,
+			      bool apply)
 {
 	int ret;
 	bool early = me->state == MODULE_STATE_UNFORMED;
@@ -231,8 +238,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		mutex_lock(&text_mutex);
 	}
 
-	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
-				   write);
+	ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				   write, apply);
 
 	if (!early) {
 		text_poke_sync();
@@ -242,6 +249,26 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return ret;
 }
 
+int apply_relocate_add(Elf64_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	return write_relocate_add(sechdrs, strtab, symindex, relsec, me, true);
+}
+
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+			const char *strtab,
+			unsigned int symindex,
+			unsigned int relsec,
+			struct module *me)
+{
+	write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);
+}
+#endif
+
 #endif
 
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 7b4587a19189..03be088fb439 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -75,6 +75,23 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 		       unsigned int symindex,
 		       unsigned int relsec,
 		       struct module *mod);
+#ifdef CONFIG_LIVEPATCH
+/*
+ * Some architectures (namely x86_64 and ppc64) perform sanity checks when
+ * applying relocations.  If a patched module gets unloaded and then later
+ * reloaded (and re-patched), klp re-applies relocations to the replacement
+ * function(s).  Any leftover relocations from the previous loading of the
+ * patched module might trigger the sanity checks.
+ *
+ * To prevent that, when unloading a patched module, clear out any relocations
+ * that might trigger arch-specific sanity checks on a future module reload.
+ */
+void clear_relocate_add(Elf_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me);
+#endif
 #else
 static inline int apply_relocate_add(Elf_Shdr *sechdrs,
 				     const char *strtab,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 201f0c0482fb..c72f378181ce 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -291,10 +291,10 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
  *    the to-be-patched module to be loaded and patched sometime *after* the
  *    klp module is loaded.
  */
-int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
-			     const char *shstrtab, const char *strtab,
-			     unsigned int symndx, unsigned int secndx,
-			     const char *objname)
+static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+				    const char *shstrtab, const char *strtab,
+				    unsigned int symndx, unsigned int secndx,
+				    const char *objname, bool apply)
 {
 	int cnt, ret;
 	char sec_objname[MODULE_NAME_LEN];
@@ -316,11 +316,26 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	if (strcmp(objname ? objname : "vmlinux", sec_objname))
 		return 0;
 
-	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
-	if (ret)
-		return ret;
+	if (apply) {
+		ret = klp_resolve_symbols(sechdrs, strtab, symndx,
+					  sec, sec_objname);
+		if (ret)
+			return ret;
 
-	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
+		return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
+	}
+
+	clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
+	return 0;
+}
+
+int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
+			     const char *shstrtab, const char *strtab,
+			     unsigned int symndx, unsigned int secndx,
+			     const char *objname)
+{
+	return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
+					secndx, objname, true);
 }
 
 /*
@@ -769,8 +784,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 			   func->old_sympos ? func->old_sympos : 1);
 }
 
-static int klp_apply_object_relocs(struct klp_patch *patch,
-				   struct klp_object *obj)
+static int klp_write_object_relocs(struct klp_patch *patch,
+				   struct klp_object *obj,
+				   bool apply)
 {
 	int i, ret;
 	struct klp_modinfo *info = patch->mod->klp_info;
@@ -781,10 +797,10 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
 		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
 			continue;
 
-		ret = klp_apply_section_relocs(patch->mod, info->sechdrs,
+		ret = klp_write_section_relocs(patch->mod, info->sechdrs,
 					       info->secstrings,
 					       patch->mod->core_kallsyms.strtab,
-					       info->symndx, i, obj->name);
+					       info->symndx, i, obj->name, apply);
 		if (ret)
 			return ret;
 	}
@@ -792,6 +808,18 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
 	return 0;
 }
 
+static int klp_apply_object_relocs(struct klp_patch *patch,
+				   struct klp_object *obj)
+{
+	return klp_write_object_relocs(patch, obj, true);
+}
+
+static void klp_clear_object_relocs(struct klp_patch *patch,
+				    struct klp_object *obj)
+{
+	klp_write_object_relocs(patch, obj, false);
+}
+
 /* parts of the initialization that is done only when the object is loaded */
 static int klp_init_object_loaded(struct klp_patch *patch,
 				  struct klp_object *obj)
@@ -1179,7 +1207,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 			klp_unpatch_object(obj);
 
 			klp_post_unpatch_callback(obj);
-
+			klp_clear_object_relocs(patch, obj);
 			klp_free_object_loaded(obj);
 			break;
 		}
-- 
2.30.2

