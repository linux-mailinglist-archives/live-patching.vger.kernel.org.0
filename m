Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2ED4AF7CD
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiBIRIT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbiBIRIR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:08:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3F24C05CB89
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426499;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QA83dhan4GHrbc3Y3AatV9qxaqVqba7enDqgKUIKf/o=;
        b=Ew23NeznqX5//1pfUOFLZycqK4ziZsAdVvGzPcDS4ZWwnuZzV7OvGPrfa9gHb5+JEAwVAX
        U3+b8YSMWOwY+vaYL/UutAk4DrGgoyFXp6RBBoEt+HTMGs/DT61jvu5E2GyGI7L9A1pmi0
        UrudF7r/9J8Yw78bLSmppOBmpp8YNU0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-BUIkeIC9NZKvRqnlLT6BAg-1; Wed, 09 Feb 2022 12:08:17 -0500
X-MC-Unique: BUIkeIC9NZKvRqnlLT6BAg-1
Received: by mail-wm1-f71.google.com with SMTP id v190-20020a1cacc7000000b0034657bb6a66so287944wme.6
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:08:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=QA83dhan4GHrbc3Y3AatV9qxaqVqba7enDqgKUIKf/o=;
        b=k0RNhu9bWBjkNQQXZP4kbLss+1/l8lO1ux9oIH9mP1C0nQ1hG43oI6Kj6YXRF7vRTp
         SgbieIzLbf3GNXjR2yLmR0XTrMudLyMygNvWu57JU9j+7q2M32mLLaadY5O5nE1bFNoE
         Cv+3HaQznBb5Z3ur9FdJ9zHSKhr7jFxRaSjEidlHBqQCj4vQFNQ0LjVadIm6STpJ5aEb
         NHlngzifz4KXQ03uAaM9nVqM7nTetsZEdQIRhTeDF59PvXQsoSjpBsIrQsJuW+0hI4nq
         iM85Jk0E74Afi1rNTQQKqEFOyEB3BfWaWaADJSTaSbtLevBQH931pPVX8i2n4BQf7Jet
         M2hQ==
X-Gm-Message-State: AOAM533ZaOop9HwJp0T6u/nBJc6Y6PaWP7oz39GuRJpdMzgKWFWQUYNd
        t+fhWtyj1/tIFMGrB19GFA67nLzY0N62fxWTsHp6h7DqqSc9lusGFY6W9wUHTNvwGFCSQkWpvAM
        lHNmBvxgRdBxLyRFa6xFPILwQ
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr2740932wrx.675.1644426496686;
        Wed, 09 Feb 2022 09:08:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyItpaIdgWgorCfIUjIaOHBC1Tr6J6lSvgV8J+5Knya63RBLIBS9WC8DmDE0DQa4EqNGe8/2g==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr2740907wrx.675.1644426496477;
        Wed, 09 Feb 2022 09:08:16 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id j35sm1155960wms.32.2022.02.09.09.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:08:15 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 08/13] module: Move kmemleak support to a separate file
Date:   Wed,  9 Feb 2022 17:08:09 +0000
Message-Id: <20220209170814.3268487-2-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209170814.3268487-1-atomlin@redhat.com>
References: <20220209170814.3268487-1-atomlin@redhat.com>
Reply-To: 20220209170358.3266629-1-atomlin@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index 8f2857d9ba1e..62c9fc91d411 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -11,4 +11,5 @@ ifdef CONFIG_MODULES
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
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
index 6d5891cc8421..33d7befd0602 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -171,3 +171,10 @@ static inline int module_sig_check(struct load_info *info, int flags)
 	return 0;
 }
 #endif /* !CONFIG_MODULE_SIG */
+
+#ifdef CONFIG_DEBUG_KMEMLEAK
+void kmemleak_load_module(const struct module *mod, const struct load_info *info);
+#else /* !CONFIG_DEBUG_KMEMLEAK */
+static inline void __maybe_unused kmemleak_load_module(const struct module *mod,
+						       const struct load_info *info) { }
+#endif /* CONFIG_DEBUG_KMEMLEAK */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 403f2aacb3f6..c9931479e2eb 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2515,33 +2515,6 @@ bool __weak module_exit_section(const char *name)
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

