Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342D04BC1DF
	for <lists+live-patching@lfdr.de>; Fri, 18 Feb 2022 22:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiBRV0A (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Feb 2022 16:26:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiBRVZo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Feb 2022 16:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A169E23F0A3
        for <live-patching@vger.kernel.org>; Fri, 18 Feb 2022 13:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645219526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMJDJDbPZoWcP+nDdAgNVL7FhXeZbcGM7cb6CcLOEx0=;
        b=RZ7gMet2pOhylZfUU9X5sHA+MLwmY4rKHokmsWWMkxhSMV9HH2kN7cFyTPObZKn82V3XSQ
        +hVOL5y0hDnM8kLhXY3QtQWurxTDQ6ySUCiaMvL6gzPgGfYWYhHoU7SI3z+Rc81RFpyADF
        XkU0emZrbKNb614qd2CwhzAyLo/E7ok=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-e7sbR25rM7-bnosl8kaxHg-1; Fri, 18 Feb 2022 16:25:25 -0500
X-MC-Unique: e7sbR25rM7-bnosl8kaxHg-1
Received: by mail-wr1-f72.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so2053135wrg.20
        for <live-patching@vger.kernel.org>; Fri, 18 Feb 2022 13:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qMJDJDbPZoWcP+nDdAgNVL7FhXeZbcGM7cb6CcLOEx0=;
        b=4i+KkgRW6skv6353ykVec9iX4vrRNEjxIN8ccbYqYSwohQMlV7cS7zVQuz3apT0lyr
         sEUwLIYNlA4/sR6BKqJzIabCPDY+8NruNQd+6UsJCuenRPCEQXw5fcRv+XvmTUtzglyU
         zSaejx6HR0wkdGcIaxI1+ItOTUk0DhTbNrkiG9aYQMatW1PrFDm1L3u2pw/zsDOrbb6x
         t621+VKSrUnXTHecwiJx48OSs2gH5Ou4zZ68edptduOZQ77nDvfUYybFXRQUeIzmTCPo
         Q/x3CzzxTHfFt+DsyZ9D61g4dsmriyFSFulQJlzSFxvvlyBvDMhwh/nPBdofYpkr1yvG
         U+AA==
X-Gm-Message-State: AOAM530vf6390Dyz8Ks9g5IGFN/Pwmw8Jk/AJtVtNTskZFsjCy67v184
        ctViV846aP1S9hGp/xyIKeaAxlthf/R3i8DBT32eo9S20oJ0kgbMSWGhTfkssy+GVLvsTZjquNb
        q6oU6mJxkwxjVh0RdPl8KhPUV
X-Received: by 2002:a5d:518d:0:b0:1e5:8cc9:5aa4 with SMTP id k13-20020a5d518d000000b001e58cc95aa4mr7083317wrv.119.1645219524293;
        Fri, 18 Feb 2022 13:25:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytk7rliwaFZmS4M0Lmnrr4rsw5hxE0HoGbsbz2eWWA2lrj7q0a/S/r6F9p6yml0YV4jKPMqA==
X-Received: by 2002:a5d:518d:0:b0:1e5:8cc9:5aa4 with SMTP id k13-20020a5d518d000000b001e58cc95aa4mr7083306wrv.119.1645219524097;
        Fri, 18 Feb 2022 13:25:24 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id r11sm498151wmb.19.2022.02.18.13.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 13:25:23 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v6 08/13] module: Move kmemleak support to a separate file
Date:   Fri, 18 Feb 2022 21:25:06 +0000
Message-Id: <20220218212511.887059-9-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218212511.887059-1-atomlin@redhat.com>
References: <20220218212511.887059-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 kernel/module/internal.h       |  7 +++++++
 kernel/module/main.c           | 27 ---------------------------
 4 files changed, 38 insertions(+), 27 deletions(-)
 create mode 100644 kernel/module/debug_kmemleak.c

diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 3f48343636ff..e2a5ae0264f9 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -11,4 +11,5 @@ obj-$(CONFIG_LIVEPATCH) += livepatch.o
 ifdef CONFIG_MODULES
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
 endif
diff --git a/kernel/module/debug_kmemleak.c b/kernel/module/debug_kmemleak.c
new file mode 100644
index 000000000000..12a569d361e8
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
+			  const struct load_info *info)
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
index 0fdd9c0cd77d..1c9604443e2f 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -173,3 +173,10 @@ static inline int module_sig_check(struct load_info *info, int flags)
 	return 0;
 }
 #endif /* !CONFIG_MODULE_SIG */
+
+#ifdef CONFIG_DEBUG_KMEMLEAK
+void kmemleak_load_module(const struct module *mod, const struct load_info *info);
+#else /* !CONFIG_DEBUG_KMEMLEAK */
+static inline void kmemleak_load_module(const struct module *mod,
+					const struct load_info *info) { }
+#endif /* CONFIG_DEBUG_KMEMLEAK */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c63e10c61694..7dd283959c5c 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2519,33 +2519,6 @@ bool __weak module_exit_section(const char *name)
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

