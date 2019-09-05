Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9DAA36E
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfIEMpS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:45:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:40662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731438AbfIEMpS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:45:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3497B656;
        Thu,  5 Sep 2019 12:45:16 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, nstange@suse.de,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [RFC PATCH v2 1/3] livepatch: Clear relocation targets on a module removal
Date:   Thu,  5 Sep 2019 14:45:12 +0200
Message-Id: <20190905124514.8944-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190905124514.8944-1-mbenes@suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
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
targets on x86_64, or return back nops on powerpc). The solution is not
universal and is too much arch-specific, but it may prove to be simpler
in the end.

Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/powerpc/kernel/module_64.c | 45 +++++++++++++++++++++++++++++++++
 arch/s390/kernel/module.c       |  8 ++++++
 arch/x86/kernel/module.c        | 43 +++++++++++++++++++++++++++++++
 include/linux/moduleloader.h    |  7 +++++
 kernel/livepatch/core.c         | 45 +++++++++++++++++++++++++++++++++
 5 files changed, 148 insertions(+)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index a93b10c48000..e461d456e447 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -741,6 +741,51 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 }
 
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
+	Elf64_Sym *sym;
+	unsigned long *location;
+	const char *symname;
+	u32 *instruction;
+
+	pr_debug("Applying ADD relocate section %u to %u\n", relsec,
+	       sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rela[i].r_offset;
+		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
+			+ ELF64_R_SYM(rela[i].r_info);
+		symname = me->core_kallsyms.strtab
+			+ sym->st_name;
+
+		if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
+			continue;
+
+		if (sym->st_shndx != SHN_UNDEF &&
+		    sym->st_shndx != SHN_LIVEPATCH)
+			continue;
+
+		instruction = (u32 *)location;
+		if (is_mprofile_mcount_callsite(symname, instruction))
+			continue;
+
+		if (!instr_is_relative_link_branch(*instruction))
+			continue;
+
+		instruction += 1;
+		*instruction = PPC_INST_NOP;
+	}
+}
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifdef CONFIG_MPROFILE_KERNEL
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 31889db609e9..56867d052010 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -437,6 +437,14 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
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
index d5c72cb877b3..b07d71f125e6 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -215,6 +215,49 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	       me->name);
 	return -ENOEXEC;
 }
+
+#ifdef CONFIG_LIVEPATCH
+void clear_relocate_add(Elf64_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	void *loc;
+
+	DEBUGP("Clearing relocate section %u to %u\n",
+	       relsec, sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		switch (ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			*(u64 *)loc = 0;
+			break;
+		case R_X86_64_32:
+			*(u32 *)loc = 0;
+			break;
+		case R_X86_64_32S:
+			*(s32 *)loc = 0;
+			break;
+		case R_X86_64_PC32:
+		case R_X86_64_PLT32:
+			*(u32 *)loc = 0;
+			break;
+		case R_X86_64_PC64:
+			*(u64 *)loc = 0;
+			break;
+		default:
+			break;
+		}
+	}
+}
+#endif
 #endif
 
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 31013c2effd3..f1e52692db5f 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -62,6 +62,13 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
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
index ab4a4606d19b..f0b380d2a17a 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -295,6 +295,45 @@ static int klp_write_object_relocations(struct module *pmod,
 	return ret;
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
@@ -1100,6 +1139,12 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 
 			klp_post_unpatch_callback(obj);
 
+			mutex_lock(&text_mutex);
+			module_disable_ro(patch->mod);
+			klp_clear_object_relocations(patch->mod, obj);
+			module_enable_ro(patch->mod, true);
+			mutex_unlock(&text_mutex);
+
 			klp_free_object_loaded(obj);
 			break;
 		}
-- 
2.23.0

