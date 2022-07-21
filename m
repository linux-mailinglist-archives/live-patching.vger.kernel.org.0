Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5E57D2C7
	for <lists+live-patching@lfdr.de>; Thu, 21 Jul 2022 19:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiGURwL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 13:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGURwL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 13:52:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CFD82F89
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 10:52:09 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG8nPQ015561
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 10:52:08 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hes8vdy62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 10:52:08 -0700
Received: from twshared35153.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 10:52:07 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 0F18EA767613; Thu, 21 Jul 2022 10:52:03 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>, <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH v3] livepatch: Clear relocation targets on a module removal
Date:   Thu, 21 Jul 2022 10:51:47 -0700
Message-ID: <20220721175147.214642-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: hmRXoVkfcXkfbG3AqhiGSIBq7RFOdcum
X-Proofpoint-ORIG-GUID: hmRXoVkfcXkfbG3AqhiGSIBq7RFOdcum
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_24,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

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

  On ppc64le, we have a similar issue:

  module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
  livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
  livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

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
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Song Liu <song@kernel.org>

---

Changes from v2:
1. Rewrite x86 changes to match current code style.
2. Remove powerpc changes as there is no test coverage in v3.
3. Only keep 1/3 of v2.

v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u
---
 arch/powerpc/kernel/module_64.c | 10 ++++
 arch/s390/kernel/module.c       |  8 ++++
 arch/x86/kernel/module.c        | 85 +++++++++++++++++++++++++++++++++
 include/linux/moduleloader.h    |  7 +++
 kernel/livepatch/core.c         | 41 +++++++++++++++-
 5 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 7e45dc98df8a..9125f0aff5d4 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -739,6 +739,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
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
index 26125a9c436d..abbf45715354 100644
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
index 67828d973389..2e4f219ea98b 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -245,6 +245,91 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return ret;
 }
 
+#ifdef CONFIG_LIVEPATCH
+
+static void __clear_relocate_add(Elf64_Shdr *sechdrs,
+		 const char *strtab,
+		 unsigned int symindex,
+		 unsigned int relsec,
+		 struct module *me,
+		 void *(*write)(void *dest, const void *src, size_t len))
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf64_Sym *sym;
+	void *loc;
+	u64 zero_u64 = 0ULL;
+	u32 zero_u32 = 0;
+
+	DEBUGP("Clearing relocate section %u to %u\n",
+	       relsec, sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/*
+		 * This is the symbol it is referring to.  Note that all
+		 * undefined symbols have been resolved.
+		 */
+		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
+			+ ELF64_R_SYM(rel[i].r_info);
+
+		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
+		       (int)ELF64_R_TYPE(rel[i].r_info),
+		       sym->st_value, rel[i].r_addend, (u64)loc);
+
+		switch (ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			write(loc, &zero_u64, 8);
+			break;
+		case R_X86_64_32:
+			write(loc, &zero_u32, 4);
+			break;
+		case R_X86_64_32S:
+			write(loc, &zero_u32, 4);
+			break;
+		case R_X86_64_PC32:
+		case R_X86_64_PLT32:
+			write(loc, &zero_u32, 4);
+			break;
+		case R_X86_64_PC64:
+			write(loc, &zero_u64, 8);
+			break;
+		default:
+			pr_err("%s: Unknown rela relocation: %llu\n",
+			       me->name, ELF64_R_TYPE(rel[i].r_info));
+			break;
+		}
+	}
+}
+
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+			const char *strtab,
+			unsigned int symindex,
+			unsigned int relsec,
+			struct module *me)
+{
+	bool early = me->state == MODULE_STATE_UNFORMED;
+	void *(*write)(void *, const void *, size_t) = memcpy;
+
+	if (!early) {
+		write = text_poke;
+		mutex_lock(&text_mutex);
+	}
+
+	__clear_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				   write);
+
+	if (!early) {
+		text_poke_sync();
+		mutex_unlock(&text_mutex);
+	}
+}
+#endif
+
 #endif
 
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 9e09d11ffe5b..d22b36b84b4b 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -72,6 +72,13 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 		       unsigned int symindex,
 		       unsigned int relsec,
 		       struct module *mod);
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me);
+#endif
 #else
 static inline int apply_relocate_add(Elf_Shdr *sechdrs,
 				     const char *strtab,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc475e62279d..5c0d8a4eba13 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
 }
 
+static void klp_clear_object_relocations(struct module *pmod,
+					struct klp_object *obj)
+{
+	int i, cnt;
+	const char *objname, *secname;
+	char sec_objname[MODULE_NAME_LEN];
+	Elf_Shdr *sec;
+
+	objname = klp_is_module(obj) ? obj->name : "vmlinux";
+
+	/* For each klp relocation section */
+	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
+		sec = pmod->klp_info->sechdrs + i;
+		secname = pmod->klp_info->secstrings + sec->sh_name;
+		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		/*
+		 * Format: .klp.rela.sec_objname.section_name
+		 * See comment in klp_resolve_symbols() for an explanation
+		 * of the selected field width value.
+		 */
+		secname = pmod->klp_info->secstrings + sec->sh_name;
+		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
+		if (cnt != 1) {
+			pr_err("section %s has an incorrectly formatted name\n",
+			       secname);
+			continue;
+		}
+
+		if (strcmp(objname, sec_objname))
+			continue;
+
+		clear_relocate_add(pmod->klp_info->sechdrs,
+				   pmod->core_kallsyms.strtab,
+				   pmod->klp_info->symndx, i, pmod);
+	}
+}
+
 /*
  * Sysfs Interface
  *
@@ -1154,7 +1193,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 			klp_unpatch_object(obj);
 
 			klp_post_unpatch_callback(obj);
-
+			klp_clear_object_relocations(patch->mod, obj);
 			klp_free_object_loaded(obj);
 			break;
 		}
-- 
2.30.2

