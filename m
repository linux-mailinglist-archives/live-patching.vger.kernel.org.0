Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E14AF784
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiBIREC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiBIREB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 953C0C05CB86
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3C0jjhIuJA6A86S+Ca5VNBmbogr8Vlxem3yITYF03E=;
        b=XfjyqdxPyX3ZwK4zDBROk+RQArmiexxUzJc/ItLj2g4mGqfwUsoNpf9JsNpWf0yR7WrurV
        g6XUpg7gKY/7/kTmd9O6AuhOYZk54JCPC/f7rA8FH4be04C5PZ2A2Ey0mVBi3mlp0NtQCd
        4IYnvYNM2wMnq2mXiJ0FyqSm/IhUJos=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-RHIBTG7zMAq9bTp_rMXzeA-1; Wed, 09 Feb 2022 12:04:02 -0500
X-MC-Unique: RHIBTG7zMAq9bTp_rMXzeA-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so2939933wmb.7
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:04:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3C0jjhIuJA6A86S+Ca5VNBmbogr8Vlxem3yITYF03E=;
        b=2XNxv0VM8GjyEFHTakwm8PaXehp9caBq6iorDgFeKWMM6NMz8saVMbrf1xk5kIYb8A
         73KPFkitNDsZPWJNppxS1HZyt9hrmZU15jKI+NCX5geg7dArRFLyPw3o0zGUCr4Pl3iG
         CTuu2tQCB51UdILO3kt4Ub/I7Ml8ZiUYuBgXU8Ba5DxDKzfmLmghJhp2vzRZq2nFPR96
         f85ztQxNfrGScx7mjsQv6fxCFqijzDFekpe7O7sX1OdI3Vh4x42hXTDWSWv4uB0fiS4K
         /KHdY08l+SA3xKybWsW5KOhTAfuMUe8VPFegrP7Ku6kfeUbozJQYOYUjOlXWRsecLqHk
         FEZQ==
X-Gm-Message-State: AOAM530w0Cnpwy31TJfEnwhAL7E9NS4v5yqgSbqEIimSNY5ahVkcn/WY
        PuDVBqoi9HAS5I7M0u4R/Ne3PFFAhWpRc1dlrF055Ys732cS217TpernJUVHHZRBT8tt9bLXUlk
        FXWxZJhXwwjfk+vcUsRuycyFC
X-Received: by 2002:a05:600c:379a:: with SMTP id o26mr1955660wmr.137.1644426241133;
        Wed, 09 Feb 2022 09:04:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6Yl6qmx7EiBaGDMfxd8ACnhUWWTBo2ZK3mHY5AQCHcuGQuv/dP64JlNBxnlyMA/T2uJRX9g==
X-Received: by 2002:a05:600c:379a:: with SMTP id o26mr1955641wmr.137.1644426240956;
        Wed, 09 Feb 2022 09:04:00 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id p2sm10366028wrt.101.2022.02.09.09.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:04:00 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 01/13] module: Move all into module/
Date:   Wed,  9 Feb 2022 17:03:46 +0000
Message-Id: <20220209170358.3266629-2-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209170358.3266629-1-atomlin@redhat.com>
References: <20220209170358.3266629-1-atomlin@redhat.com>
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

No functional changes.

This patch moves all module related code into a separate directory,
modifies each file name and creates a new Makefile. Note: this effort
is in preparation to refactor core module code.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 MAINTAINERS                                         | 2 +-
 kernel/Makefile                                     | 5 +----
 kernel/module/Makefile                              | 9 +++++++++
 kernel/{module_decompress.c => module/decompress.c} | 2 +-
 kernel/{module-internal.h => module/internal.h}     | 1 +
 kernel/{module.c => module/main.c}                  | 2 +-
 kernel/{module_signature.c => module/signature.c}   | 0
 kernel/{module_signing.c => module/signing.c}       | 2 +-
 8 files changed, 15 insertions(+), 8 deletions(-)
 create mode 100644 kernel/module/Makefile
 rename kernel/{module_decompress.c => module/decompress.c} (99%)
 rename kernel/{module-internal.h => module/internal.h} (99%)
 rename kernel/{module.c => module/main.c} (99%)
 rename kernel/{module_signature.c => module/signature.c} (100%)
 rename kernel/{module_signing.c => module/signing.c} (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e461db9cd91..7e6232bd15f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13001,7 +13001,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
 F:	include/linux/module.h
-F:	kernel/module.c
+F:	kernel/module/main.c
 
 MONOLITHIC POWER SYSTEM PMIC DRIVER
 M:	Saravanan Sekar <sravanhome@gmail.com>
diff --git a/kernel/Makefile b/kernel/Makefile
index 56f4ee97f328..3a6380975c57 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,7 @@ obj-y += rcu/
 obj-y += livepatch/
 obj-y += dma/
 obj-y += entry/
+obj-y += module/
 
 obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -66,10 +67,6 @@ ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
 obj-$(CONFIG_UID16) += uid16.o
-obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_DECOMPRESS) += module_decompress.o
-obj-$(CONFIG_MODULE_SIG) += module_signing.o
-obj-$(CONFIG_MODULE_SIG_FORMAT) += module_signature.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_CRASH_CORE) += crash_core.o
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
new file mode 100644
index 000000000000..2902fc7d0ef1
--- /dev/null
+++ b/kernel/module/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for linux kernel module support
+#
+
+obj-$(CONFIG_MODULES) += main.o
+obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o
+obj-$(CONFIG_MODULE_SIG) += signing.o
+obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
diff --git a/kernel/module_decompress.c b/kernel/module/decompress.c
similarity index 99%
rename from kernel/module_decompress.c
rename to kernel/module/decompress.c
index b01c69c2ff99..c153fd8a4444 100644
--- a/kernel/module_decompress.c
+++ b/kernel/module/decompress.c
@@ -12,7 +12,7 @@
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
 
-#include "module-internal.h"
+#include "internal.h"
 
 static int module_extend_max_pages(struct load_info *info, unsigned int extent)
 {
diff --git a/kernel/module-internal.h b/kernel/module/internal.h
similarity index 99%
rename from kernel/module-internal.h
rename to kernel/module/internal.h
index 8c381c99062f..c49896368f7f 100644
--- a/kernel/module-internal.h
+++ b/kernel/module/internal.h
@@ -44,6 +44,7 @@ static inline int module_decompress(struct load_info *info,
 {
 	return -EOPNOTSUPP;
 }
+
 static inline void module_decompress_cleanup(struct load_info *info)
 {
 }
diff --git a/kernel/module.c b/kernel/module/main.c
similarity index 99%
rename from kernel/module.c
rename to kernel/module/main.c
index 46a5c2ed1928..34a2b0cf3c3e 100644
--- a/kernel/module.c
+++ b/kernel/module/main.c
@@ -58,7 +58,7 @@
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
 #include <uapi/linux/module.h>
-#include "module-internal.h"
+#include "internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
diff --git a/kernel/module_signature.c b/kernel/module/signature.c
similarity index 100%
rename from kernel/module_signature.c
rename to kernel/module/signature.c
diff --git a/kernel/module_signing.c b/kernel/module/signing.c
similarity index 97%
rename from kernel/module_signing.c
rename to kernel/module/signing.c
index 8723ae70ea1f..8aeb6d2ee94b 100644
--- a/kernel/module_signing.c
+++ b/kernel/module/signing.c
@@ -12,7 +12,7 @@
 #include <linux/string.h>
 #include <linux/verification.h>
 #include <crypto/public_key.h>
-#include "module-internal.h"
+#include "internal.h"
 
 /*
  * Verify the signature on a module.
-- 
2.34.1

