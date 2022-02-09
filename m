Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61594AF786
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiBIRED (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237684AbiBIREC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAD4FC05CB82
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0QYZ+16D5dm+XWg7QULMgCvAEAxCydy3KF5g5Fiobo=;
        b=JGUXM+gKdcOqpgBAX3x029ufOsX527a6NmXjDFtVkwszr5h+GPXZHFIs0dtfc9NI48SM3w
        VbXOcuU9+lwmoqvE5p+EQPyzXmlF+ZjzyzDxhMdASXJXEnvQkmKzGgbnqlH5VJrHUwDkXy
        +k8jXuto1uDC5O1mLc1c5SMCiyCVi+I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-D8LneKcMNBGjQQzrYyKLSw-1; Wed, 09 Feb 2022 12:04:03 -0500
X-MC-Unique: D8LneKcMNBGjQQzrYyKLSw-1
Received: by mail-wr1-f72.google.com with SMTP id n18-20020adfc612000000b001e3310ca453so1345210wrg.2
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:04:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f0QYZ+16D5dm+XWg7QULMgCvAEAxCydy3KF5g5Fiobo=;
        b=V0sZhY4rGhxXeG9NVuV+x7uNCIneB2RrRQR8bcB4kZN8+UxrnZpY93BfmOKOvffQJm
         sXcRWVkCEMSCbpIh4cVRq2+ZqvyNA90aXR3MfYptdoE+iGRpHu+D7xcLWkw0fqoxwLzf
         /l5Z8yx4cXFB4tHgpERgG0LIIgP8igrcm0AjHdpcmFAKHcAZT57msygQP3dc1vLoPdfd
         fm0Tqpx/M5uKbrXVzs0CgTSvuBvr2yfIZCK4+5HzOM068IcfbTHiA0n2HPuJMy0ApuiA
         65h9ffb2xTjqBdPN38P5mnoh3XFwDXcscWbDJYDzVUckr6K3Q9EHqLXiHUpBADcRHdyi
         v+sg==
X-Gm-Message-State: AOAM532ABpJgsnJHLhzkuQ+pEjbW4gjT/oV1J1r7RWaogEvpNMUVUVy/
        H7SPlJa1kPxkzaP7wAq19aAcptBj2Q29hdjGQU5cvsHc8kwDZuXlh63RtUKhcGnwjMtt0fC/hvZ
        m8y6mipYSvCu64zCqw7USyY13
X-Received: by 2002:a1c:f312:: with SMTP id q18mr2973003wmq.13.1644426242460;
        Wed, 09 Feb 2022 09:04:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwx7VTMYy1E4nMEgr68WsgOVT2PIMXC1R7UrhFZxIK6zH574ae+AZpMXMmqhIYg7uFiCdVdbA==
X-Received: by 2002:a1c:f312:: with SMTP id q18mr2972970wmq.13.1644426242280;
        Wed, 09 Feb 2022 09:04:02 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id a9sm730604wrg.53.2022.02.09.09.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:04:01 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 02/13] module: Simple refactor in preparation for split
Date:   Wed,  9 Feb 2022 17:03:47 +0000
Message-Id: <20220209170358.3266629-3-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209170358.3266629-1-atomlin@redhat.com>
References: <20220209170358.3266629-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index c49896368f7f..1a4b33ce9f5f 100644
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
index 34a2b0cf3c3e..750e3ad28679 100644
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
@@ -4542,9 +4526,6 @@ static void cfi_cleanup(struct module *mod)
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

