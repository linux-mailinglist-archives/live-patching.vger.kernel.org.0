Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF234A3A68
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356593AbiA3Vca (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:32:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356465AbiA3VcV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV4WzeMBxzAOtiGbJsE6/WwOSD8dA4tNDcXqNuD6cVU=;
        b=cFc87/dDyMg2vgK/RTbWaZE1IsX9RO/dXn9EuOCwA52sK445kZNSUdtpaCmun0/tehZCKz
        bkfwl10TpLxbPuhF4657nmgTcJG4cnBQYtZ2oyogXjNMQM4Q6dbYbRLLNkVOCPrKS2GNCn
        Chhef3Ls2rCjbJ5Wk0QrJYLP97D1BJY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-g_ptpouXP5uNWqGXacmlbw-1; Sun, 30 Jan 2022 16:32:19 -0500
X-MC-Unique: g_ptpouXP5uNWqGXacmlbw-1
Received: by mail-wm1-f71.google.com with SMTP id n22-20020a05600c3b9600b00352d3f6a850so442094wms.3
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JV4WzeMBxzAOtiGbJsE6/WwOSD8dA4tNDcXqNuD6cVU=;
        b=dnLDRtsYUxCMC7V2/SaPE9oVEGV3I6HvEb6b3jMKFREe4ZEf/OTxkUaHCzV5scyEnX
         noswMM/OSl2VhRXUYPgaL6OQjHToOEHzZ1shMBhEECf3mTfNAcaoSktSyQnriB7seY3y
         U+8tfChRtSDi5XEckluUmCPaft6ESmuk4hzAKd/o3gt4G5E75TAOzMDTj0vbd0b5I6C/
         Sa7ckM1B34wKfOoTHCUe3+PwdMo3UjvGAy79Ubv0I/Vdl2Plq+MANApF6aQu+RYdDTnG
         uuOJTFompzlg7TI6NmJN0TOpqMcaxfiCgSkx8EQFXfYf2O7QBhl+QHi0OkUbjkgMx+2B
         MePw==
X-Gm-Message-State: AOAM530OiA5R0VLAY7wtbU8FN/YCnZBedlcGCeWJ8WWmpX+jXXt1FbVE
        rxVpasauqJFUOIK02HX2klffGkpBMPW1pE973pMbF0uoZ0n6FJHnsqIlaSwBwKKUs8aZpKhfPOn
        EkJKLl19fnJ0/cIM8SMYgF4Ir
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr16034121wme.100.1643578338239;
        Sun, 30 Jan 2022 13:32:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7jvFvppo9puF0OsfaRfA3N+nCHc74wub5pjdUY1rNAuJO9Wd7ayQBEQZUn7+/vp/YyotidQ==
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr16034110wme.100.1643578338088;
        Sun, 30 Jan 2022 13:32:18 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id v8sm7063946wmd.44.2022.01.30.13.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:17 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 01/13] module: Move all into module/
Date:   Sun, 30 Jan 2022 21:32:02 +0000
Message-Id: <20220130213214.1042497-2-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 kernel/{module-internal.h => module/internal.h}     | 0
 kernel/{module.c => module/main.c}                  | 2 +-
 kernel/{module_signature.c => module/signature.c}   | 0
 kernel/{module_signing.c => module/signing.c}       | 2 +-
 8 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 kernel/module/Makefile
 rename kernel/{module_decompress.c => module/decompress.c} (99%)
 rename kernel/{module-internal.h => module/internal.h} (100%)
 rename kernel/{module.c => module/main.c} (99%)
 rename kernel/{module_signature.c => module/signature.c} (100%)
 rename kernel/{module_signing.c => module/signing.c} (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index acd112c42255..a98f4700acb7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12976,7 +12976,7 @@ L:	linux-kernel@vger.kernel.org
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
similarity index 100%
rename from kernel/module-internal.h
rename to kernel/module/internal.h
diff --git a/kernel/module.c b/kernel/module/main.c
similarity index 99%
rename from kernel/module.c
rename to kernel/module/main.c
index 387ee77bdbd6..d8c6269af6cf 100644
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

