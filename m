Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEB04A020E
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbiA1Ujp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:39:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238399AbiA1Ujm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKFHu1mwRyMCd3tE6xfYJyy3RgbH1D0nAbWrHT5RWOU=;
        b=WMi+/MT5XJI9b5vDaBNciYr8ui7eX9co0PPNI2QhRnu9Qwvj+s6sGT4GI+nsy4HJpO2Vu/
        Ub+LrYyHQvRLKcApDO9IoBt5fQUkB9GxAEknfaV/AG+hjW5Piw5wmdRm5xAgapwndvq1sM
        dgn72d47/EeKrK+zwUO+PAijTwhBYGY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Y9t0gvL1Pq67vRKIMz3niw-1; Fri, 28 Jan 2022 15:39:40 -0500
X-MC-Unique: Y9t0gvL1Pq67vRKIMz3niw-1
Received: by mail-wr1-f72.google.com with SMTP id c9-20020adfa709000000b001dde29c3202so2607650wrd.22
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CKFHu1mwRyMCd3tE6xfYJyy3RgbH1D0nAbWrHT5RWOU=;
        b=IrdxdjpuLAj/RiEWecZUY1+PaB1U+z3l6MT1n8T/Bso9BpQhEEzkNAW7IPENFWdEHj
         N6zBVYzLqJuDes5YWfFEY2El4AwNCRSLVhzFSule7RC+ZnJ+cnti3P7gmQIwTcb8Vgch
         FfylNVcIHidWuhJADshROWQQgPgCIQR4pf4ezhn41qo+Ypp/5UwWUbFlWtKC+bgOFpXA
         HeljHQaMK6Ywd6lHMkxwNgUhVuOFjyXG5Ek/oL43s2NS31tOyHrL6Tu7Ltdy3ikv7y6a
         /87yDRpx6XyqqTbPXPcy0gGnh9JQ9NLBFR2OalBbvsrjOy3BfoZ0o6E9M53ezSzMqt12
         tHEA==
X-Gm-Message-State: AOAM532Chdw09c+cNHoCfKbJIKxukI4fKS+2lI2GfSFfxIx/6sSCOTs3
        LJYhJ2SAHP+8Lma92A7ga2PtrLaRSK4McfxDI1JbPZ92WcGLY8M8GwX/dx2dWPrBOqEakBoj7XT
        pRqzC3qo8OKPhUQqRwA5Ym0qH
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr7305024wms.62.1643402378588;
        Fri, 28 Jan 2022 12:39:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx071r+pfGCf25/UPxmKSKMz79BwnrKoE01zXclK8LWdr1k4TAP66d3QLFEJ4AAKM2Umk5oMg==
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr7305003wms.62.1643402378384;
        Fri, 28 Jan 2022 12:39:38 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id f13sm6960199wry.77.2022.01.28.12.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:37 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 02/13] module: Simple refactor in preparation for split
Date:   Fri, 28 Jan 2022 20:39:23 +0000
Message-Id: <20220128203934.600247-3-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch makes it possible to move non-essential code
out of core module code.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/module/internal.h | 22 ++++++++++++++++++++++
 kernel/module/main.c     | 23 ++---------------------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 8c381c99062f..e3c593f8767f 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -7,6 +7,28 @@
 
 #include <linux/elf.h>
 #include <asm/module.h>
+#include <linux/mutex.h>
+
+#ifndef ARCH_SHF_SMALL
+#define ARCH_SHF_SMALL 0
+#endif
+
+/* If this is set, the section belongs in the init part of the module */
+#define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
+/* Maximum number of characters written by module_flags() */
+#define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
+#define MODULE_SECT_READ_SIZE (3 /* "0x", "\n" */ + (BITS_PER_LONG / 4))
+
+extern struct mutex module_mutex;
+extern struct list_head modules;
+
+/* Provided by the linker */
+extern const struct kernel_symbol __start___ksymtab[];
+extern const struct kernel_symbol __stop___ksymtab[];
+extern const struct kernel_symbol __start___ksymtab_gpl[];
+extern const struct kernel_symbol __stop___ksymtab_gpl[];
+extern const s32 __start___kcrctab[];
+extern const s32 __start___kcrctab_gpl[];
 
 struct load_info {
 	const char *name;
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d8c6269af6cf..fee64c4957f3 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -63,10 +63,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-#ifndef ARCH_SHF_SMALL
-#define ARCH_SHF_SMALL 0
-#endif
-
 /*
  * Modules' sections will be aligned on page boundaries
  * to ensure complete separation of code and data, but
@@ -78,9 +74,6 @@
 # define debug_align(X) (X)
 #endif
 
-/* If this is set, the section belongs in the init part of the module */
-#define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
-
 /*
  * Mutex protects:
  * 1) List of modules (also safely readable with preempt_disable),
@@ -88,8 +81,8 @@
  * 3) module_addr_min/module_addr_max.
  * (delete and add uses RCU list operations).
  */
-static DEFINE_MUTEX(module_mutex);
-static LIST_HEAD(modules);
+DEFINE_MUTEX(module_mutex);
+LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
 static void do_free_init(struct work_struct *w);
@@ -408,14 +401,6 @@ static __maybe_unused void *any_section_objs(const struct load_info *info,
 	return (void *)info->sechdrs[sec].sh_addr;
 }
 
-/* Provided by the linker */
-extern const struct kernel_symbol __start___ksymtab[];
-extern const struct kernel_symbol __stop___ksymtab[];
-extern const struct kernel_symbol __start___ksymtab_gpl[];
-extern const struct kernel_symbol __stop___ksymtab_gpl[];
-extern const s32 __start___kcrctab[];
-extern const s32 __start___kcrctab_gpl[];
-
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
 #else
@@ -1490,7 +1475,6 @@ struct module_sect_attrs {
 	struct module_sect_attr attrs[];
 };
 
-#define MODULE_SECT_READ_SIZE (3 /* "0x", "\n" */ + (BITS_PER_LONG / 4))
 static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
 				struct bin_attribute *battr,
 				char *buf, loff_t pos, size_t count)
@@ -4555,9 +4539,6 @@ static void cfi_cleanup(struct module *mod)
 #endif
 }
 
-/* Maximum number of characters written by module_flags() */
-#define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
-
 /* Keep in sync with MODULE_FLAGS_BUF_SIZE !!! */
 static char *module_flags(struct module *mod, char *buf)
 {
-- 
2.34.1

