Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1804A3A86
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356696AbiA3Vdi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:33:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356586AbiA3Vcb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQAfe4ObvGQJfJNxu8h5P3w1uhPwPWFzYEYylizISc0=;
        b=RGJRoZvhTurIR9K3UvOvVsVHxn3Dl5WkKpmJ6jXgu3aFS7yAH/0eVj/qeOxs0soiuaAbVK
        Uq4QBaEGxFQ3SUSTvzy/iHU5e7obsVixi/71gOyGPil/XDNo1uoxppcTUqBuXm2Bee/vxl
        bGcbRND3pDDh88AR+AHwyfPIWgUjoAE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-rYX-OkVgPV-dxCLTMOCv4Q-1; Sun, 30 Jan 2022 16:32:29 -0500
X-MC-Unique: rYX-OkVgPV-dxCLTMOCv4Q-1
Received: by mail-wm1-f69.google.com with SMTP id z2-20020a05600c220200b0034d2eb95f27so5154430wml.1
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQAfe4ObvGQJfJNxu8h5P3w1uhPwPWFzYEYylizISc0=;
        b=MaMv1VkgGE4fdptg2WMONHnkuT8j/4SlncAk/3WpRgowNZnoICl2nJytJ4VD/wVcnN
         0Z3FVA7xYbVlSaqrGy0D2suuL6/s0bRw3Tids9pUz0l/eBOd7nZWvGcsEOlToEPIsdmv
         Dr9HS2Odgnz8+PkLFKRMLS3iaJcKijm4kqTPUJ0eyrGm5D7zc2oIye7xUdTboGXtZAyG
         4bazuCHQvkV3N4yCDG5fOPH4uILEzpaCglXkewAi8XXvJ6fV5x7JITZvIKPdpXni4eko
         s9gRDJNH9bxG7F9ev2lCHKJA+ZRvuH4+7bsSowVKFkKTbGaGSwseFBd7uHjyOLqu6vG6
         GPmQ==
X-Gm-Message-State: AOAM532tVpriDMShu2HjVXvVFpfgkw5B/6HsnoFHI2vyFas6B6nb0I1X
        /kXT6IfI62Mr750llOo0SXtxVdaGadOj94+P5OIFFy58AkUPA+wUC7lTaWWW7k0AJrxSI6yBoBB
        CMIzcOsMWTpmizg2lWAcP/taI
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr24427161wmj.2.1643578347925;
        Sun, 30 Jan 2022 13:32:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjlW03yjRZL5UouuPmS7o2QoqJ7yqYAOCyQcMp512qs+v3prNf6O+tPTA7MOdVlgprpABsyw==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr24427146wmj.2.1643578347723;
        Sun, 30 Jan 2022 13:32:27 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id i17sm9896690wru.107.2022.01.30.13.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:27 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 08/13] module: Move kmemleak support to a separate file
Date:   Sun, 30 Jan 2022 21:32:09 +0000
Message-Id: <20220130213214.1042497-9-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates kmemleak code out of core module
code into kernel/module/debug_kmemleak.c

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/module/Makefile         |  1 +
 kernel/module/debug_kmemleak.c | 30 ++++++++++++++++++++++++++++++
 kernel/module/internal.h       |  8 ++++++++
 kernel/module/main.c           | 27 ---------------------------
 4 files changed, 39 insertions(+), 27 deletions(-)
 create mode 100644 kernel/module/debug_kmemleak.c

diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index d1dada641ad6..10efb144551b 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -12,4 +12,5 @@ obj-$(CONFIG_LIVEPATCH) += livepatch.o
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 obj-$(CONFIG_ARCH_HAS_STRICT_MODULE_RWX) += arch_strict_rwx.o
 obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
 endif
diff --git a/kernel/module/debug_kmemleak.c b/kernel/module/debug_kmemleak.c
new file mode 100644
index 000000000000..e896c2268011
--- /dev/null
+++ b/kernel/module/debug_kmemleak.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Module kmemleak support
+ *
+ * Copyright (C) 2009 Catalin Marinas
+ */
+
+#include <linux/module.h>
+#include <linux/kmemleak.h>
+#include "internal.h"
+
+void kmemleak_load_module(const struct module *mod,
+				 const struct load_info *info)
+{
+	unsigned int i;
+
+	/* only scan the sections containing data */
+	kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
+
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		/* Scan all writable sections that's not executable */
+		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC) ||
+		    !(info->sechdrs[i].sh_flags & SHF_WRITE) ||
+		    (info->sechdrs[i].sh_flags & SHF_EXECINSTR))
+			continue;
+
+		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
+				   info->sechdrs[i].sh_size, GFP_KERNEL);
+	}
+}
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 2ec2a1d9dd9f..4c2f64a75401 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -6,6 +6,7 @@
  */
 
 #include <linux/elf.h>
+#include <linux/compiler.h>
 #include <asm/module.h>
 #include <linux/mutex.h>
 
@@ -123,3 +124,10 @@ static int module_sig_check(struct load_info *info, int flags)
 	return 0;
 }
 #endif /* !CONFIG_MODULE_SIG */
+
+#ifdef CONFIG_DEBUG_KMEMLEAK
+extern void kmemleak_load_module(const struct module *mod, const struct load_info *info);
+#else /* !CONFIG_DEBUG_KMEMLEAK */
+static inline void __maybe_unused kmemleak_load_module(const struct module *mod,
+						       const struct load_info *info) { }
+#endif /* CONFIG_DEBUG_KMEMLEAK */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 90c7266087d7..80790d39a6b3 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2475,33 +2475,6 @@ bool __weak module_exit_section(const char *name)
 	return strstarts(name, ".exit");
 }
 
-#ifdef CONFIG_DEBUG_KMEMLEAK
-static void kmemleak_load_module(const struct module *mod,
-				 const struct load_info *info)
-{
-	unsigned int i;
-
-	/* only scan the sections containing data */
-	kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
-
-	for (i = 1; i < info->hdr->e_shnum; i++) {
-		/* Scan all writable sections that's not executable */
-		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC) ||
-		    !(info->sechdrs[i].sh_flags & SHF_WRITE) ||
-		    (info->sechdrs[i].sh_flags & SHF_EXECINSTR))
-			continue;
-
-		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
-				   info->sechdrs[i].sh_size, GFP_KERNEL);
-	}
-}
-#else
-static inline void kmemleak_load_module(const struct module *mod,
-					const struct load_info *info)
-{
-}
-#endif
-
 static int validate_section_offset(struct load_info *info, Elf_Shdr *shdr)
 {
 #if defined(CONFIG_64BIT)
-- 
2.34.1

