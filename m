Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1E6A58E1
	for <lists+live-patching@lfdr.de>; Tue, 28 Feb 2023 13:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjB1MLN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Feb 2023 07:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjB1MLM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Feb 2023 07:11:12 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21B23102
        for <live-patching@vger.kernel.org>; Tue, 28 Feb 2023 04:11:10 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id h16so38919866edz.10
        for <live-patching@vger.kernel.org>; Tue, 28 Feb 2023 04:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aenf20tDiifM1/TeimKI9oEIMwgDrTMmdbDCyj2GhT8=;
        b=MLa4ZiS2IUhUl/u6z29ZAAIfsU686ekYAiBqHmWW381Z+T6LsFs8jU/EQ0Io1Y2e35
         vdj1umt8hEy0/21qP5wSYBvLbE1ewZNCWtslp6+ZwleWo+V28vgzSmtl8kF5OMea52uR
         jFPxfSdL5fyTGDDB08FOO2mUT/c7m2ovmpXRxkwl5ZrN7ZJ0VY+m7BYqUQ0JU1bUZh3J
         /TFpvqOWAEDqvmnQfmKeQexuUzqBXdSugGI08Ij4wTAo7BVml/gkts40wv2dE0KCJtyP
         zI7KEi4mT4xWEqAIS95YOu9DF5rFe84iCqI7Yl7kLJcSpU2lcbPhozwFKcCoEVmhxHBD
         Nmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aenf20tDiifM1/TeimKI9oEIMwgDrTMmdbDCyj2GhT8=;
        b=WcBpsoI4W0VKwWvuqpyEHC3Kcz56Dlm6uriiaMEcfOdkaO2LT1P9tCbR4GTVxJcynF
         wL2lOuoM274/oa6SxrYCkJ2glqyfRjHn9J+smQITi/OicvwP5kYeIKBcNicjcG/UmNDD
         sUPYq02RnVfnBPk49xFanhuj4h1DLS5AYCO8AOoxVbC6GHan6o5E1a2IvpaiORTdIuqL
         ggPCDl/8Bl9gxNnkmeckxVc3L88HqvH+YMbNojaBtB9HeSq6/zoK0HwN9PYZQ7eJGWDh
         GbimUEhJDv6YCpIkCifaDDVEkkcFY/PQf3zF2HNq/66H4FB8eIDYUPmgPIEQ3mbCIMGO
         xK1w==
X-Gm-Message-State: AO0yUKUNfUpUW8rRhvAjsqEssNIyt6Mf032/xS5q64ZsV3Mh9GBkWil2
        ComMPSV8Feqcq7Z9uhrPXA==
X-Google-Smtp-Source: AK7set9LICbEL2WLIJXf42KTgpQGrtbyvDKcTLMPi9jySKtJpdwShETm1fbGmmXkhmn2/Q7UKqOM/w==
X-Received: by 2002:a17:906:6d58:b0:8ed:e8d6:42c4 with SMTP id a24-20020a1709066d5800b008ede8d642c4mr2296287ejt.12.1677586269092;
        Tue, 28 Feb 2023 04:11:09 -0800 (PST)
Received: from p183 ([46.53.249.64])
        by smtp.gmail.com with ESMTPSA id t17-20020a17090605d100b008ca52f7fbcbsm4419121ejt.1.2023.02.28.04.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 04:11:08 -0800 (PST)
Date:   Tue, 28 Feb 2023 15:11:06 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org
Subject: [PATCH] livepatch: fix ELF typos
Message-ID: <Y/3vWjQ/SBA5a0i5@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

ELF is acronym.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Documentation/livepatch/module-elf-format.rst |   20 ++++++++++----------
 include/linux/module.h                        |    6 +++---
 kernel/module/livepatch.c                     |   10 +++++-----
 3 files changed, 18 insertions(+), 18 deletions(-)

--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -1,8 +1,8 @@
 ===========================
-Livepatch module Elf format
+Livepatch module ELF format
 ===========================
 
-This document outlines the Elf format requirements that livepatch modules must follow.
+This document outlines the ELF format requirements that livepatch modules must follow.
 
 
 .. Table of Contents
@@ -20,17 +20,17 @@ code. So, instead of duplicating code and re-implementing what the module
 loader can already do, livepatch leverages existing code in the module
 loader to perform the all the arch-specific relocation work. Specifically,
 livepatch reuses the apply_relocate_add() function in the module loader to
-write relocations. The patch module Elf format described in this document
+write relocations. The patch module ELF format described in this document
 enables livepatch to be able to do this. The hope is that this will make
 livepatch more easily portable to other architectures and reduce the amount
 of arch-specific code required to port livepatch to a particular
 architecture.
 
 Since apply_relocate_add() requires access to a module's section header
-table, symbol table, and relocation section indices, Elf information is
+table, symbol table, and relocation section indices, ELF information is
 preserved for livepatch modules (see section 5). Livepatch manages its own
 relocation sections and symbols, which are described in this document. The
-Elf constants used to mark livepatch symbols and relocation sections were
+ELF constants used to mark livepatch symbols and relocation sections were
 selected from OS-specific ranges according to the definitions from glibc.
 
 Why does livepatch need to write its own relocations?
@@ -43,7 +43,7 @@ reject the livepatch module. Furthermore, we cannot apply relocations that
 affect modules not yet loaded at patch module load time (e.g. a patch to a
 driver that is not loaded). Formerly, livepatch solved this problem by
 embedding special "dynrela" (dynamic rela) sections in the resulting patch
-module Elf output. Using these dynrela sections, livepatch could resolve
+module ELF output. Using these dynrela sections, livepatch could resolve
 symbols while taking into account its scope and what module the symbol
 belongs to, and then manually apply the dynamic relocations. However this
 approach required livepatch to supply arch-specific code in order to write
@@ -80,7 +80,7 @@ Example:
 3. Livepatch relocation sections
 ================================
 
-A livepatch module manages its own Elf relocation sections to apply
+A livepatch module manages its own ELF relocation sections to apply
 relocations to modules as well as to the kernel (vmlinux) at the
 appropriate time. For example, if a patch module patches a driver that is
 not currently loaded, livepatch will apply the corresponding livepatch
@@ -95,7 +95,7 @@ also possible for a livepatch module to have no livepatch relocation
 sections, as in the case of the sample livepatch module (see
 samples/livepatch).
 
-Since Elf information is preserved for livepatch modules (see Section 5), a
+Since ELF information is preserved for livepatch modules (see Section 5), a
 livepatch relocation section can be applied simply by passing in the
 appropriate section index to apply_relocate_add(), which then uses it to
 access the relocation section and apply the relocations.
@@ -291,12 +291,12 @@ Examples:
   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
   "OS" means OS-specific.
 
-5. Symbol table and Elf section access
+5. Symbol table and ELF section access
 ======================================
 A livepatch module's symbol table is accessible through module->symtab.
 
 Since apply_relocate_add() requires access to a module's section headers,
-symbol table, and relocation section indices, Elf information is preserved for
+symbol table, and relocation section indices, ELF information is preserved for
 livepatch modules and is made accessible by the module loader through
 module->klp_info, which is a :c:type:`klp_modinfo` struct. When a livepatch module
 loads, this struct is filled in by the module loader.
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -353,9 +353,9 @@ struct mod_kallsyms {
 
 #ifdef CONFIG_LIVEPATCH
 /**
- * struct klp_modinfo - Elf information preserved from the livepatch module
+ * struct klp_modinfo - ELF information preserved from the livepatch module
  *
- * @hdr: Elf header
+ * @hdr: ELF header
  * @sechdrs: Section header table
  * @secstrings: String table for the section headers
  * @symndx: The symbol table section index
@@ -523,7 +523,7 @@ struct module {
 	bool klp; /* Is this a livepatch module? */
 	bool klp_alive;
 
-	/* Elf information */
+	/* ELF information */
 	struct klp_modinfo *klp_info;
 #endif
 
--- a/kernel/module/livepatch.c
+++ b/kernel/module/livepatch.c
@@ -11,7 +11,7 @@
 #include "internal.h"
 
 /*
- * Persist Elf information about a module. Copy the Elf header,
+ * Persist ELF information about a module. Copy the ELF header,
  * section header table, section string table, and symtab section
  * index from info to mod->klp_info.
  */
@@ -25,11 +25,11 @@ int copy_module_elf(struct module *mod, struct load_info *info)
 	if (!mod->klp_info)
 		return -ENOMEM;
 
-	/* Elf header */
+	/* ELF header */
 	size = sizeof(mod->klp_info->hdr);
 	memcpy(&mod->klp_info->hdr, info->hdr, size);
 
-	/* Elf section header table */
+	/* ELF section header table */
 	size = sizeof(*info->sechdrs) * info->hdr->e_shnum;
 	mod->klp_info->sechdrs = kmemdup(info->sechdrs, size, GFP_KERNEL);
 	if (!mod->klp_info->sechdrs) {
@@ -37,7 +37,7 @@ int copy_module_elf(struct module *mod, struct load_info *info)
 		goto free_info;
 	}
 
-	/* Elf section name string table */
+	/* ELF section name string table */
 	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
 	mod->klp_info->secstrings = kmemdup(info->secstrings, size, GFP_KERNEL);
 	if (!mod->klp_info->secstrings) {
@@ -45,7 +45,7 @@ int copy_module_elf(struct module *mod, struct load_info *info)
 		goto free_sechdrs;
 	}
 
-	/* Elf symbol section index */
+	/* ELF symbol section index */
 	symndx = info->index.sym;
 	mod->klp_info->symndx = symndx;
 
