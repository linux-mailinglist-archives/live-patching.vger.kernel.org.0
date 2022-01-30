Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82C74A3A78
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356627AbiA3VdI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:33:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356637AbiA3Vcg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WWouBNY6XHsJho+NkhowbAagBN3wD6Bcpj36xe5bwk=;
        b=iNbKc9aDbpu/cDmHdtvNCtV4oWZG/nt128Qw9G9qSjnDUQ7GuuB4/Abb84z2Z7UBmbPa9g
        nXdH5FOzcAnA5t3ZtQZ5m+2C2QAlMQVCIeAMD4i1MB25BaQ3airH99WpEdtVhNWGScdZ+Q
        O9g4Oqj2o2kEK5gWnzp0r517S0NVhQ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-aCc_peGfOreBZ46fOCkfXQ-1; Sun, 30 Jan 2022 16:32:34 -0500
X-MC-Unique: aCc_peGfOreBZ46fOCkfXQ-1
Received: by mail-wm1-f69.google.com with SMTP id o194-20020a1ca5cb000000b00350b177fb22so8581591wme.3
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4WWouBNY6XHsJho+NkhowbAagBN3wD6Bcpj36xe5bwk=;
        b=OGedYGdQdA4yv9MiHyom6Xf+KkkP+x+45EOICz477Othhqj1dML/ex6r1DMVFNEzlv
         m6nzC7X+3SG8mUI+54WeCX3HyQ5LWmwIIAQCDt2gyakAZWRfQLyqFRCa696PEvrQkbOw
         B63mi9Y7qNJJeSrLTRMChsxeO/E8qXeaYNFIWDAWoTIeP3XPfxfEMcH73pIIeDn4eMZD
         YwYfmKgml1FpRzf6AYHl2yu29VBKg3JNW3pfXtLN7MiufGg5knsBsuIrLrKD63gkc6FN
         RKnob4FYyZ6ZfaqWH75h+v9/X9JWnOKG5NfxbbsVbKUw+B7kPdNRhkhTY6G5+uJbLFux
         PdVQ==
X-Gm-Message-State: AOAM531uEZIA5yoQjhmot4spaZVBTLHvp9/NxmkKxkeZxJzBUw0HYTNz
        GUfHnuT4PdE4Gi+Zzmy5OgWaIBgDPUFTekwWT+YI86JBdUz/To8kcOZw9mmrN4iJFi07xe+pnKC
        WYnR1yZDWJ7m6BRQotOs+xGtQ
X-Received: by 2002:a05:6000:1568:: with SMTP id 8mr15258941wrz.54.1643578353041;
        Sun, 30 Jan 2022 13:32:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxnioIPHbSlQTlSmnwMfQCG2ZAC/+LiIaUTTnbob+kakVGHe+nULEei/uHEJHjOGr8GoH4Vw==
X-Received: by 2002:a05:6000:1568:: with SMTP id 8mr15258935wrz.54.1643578352896;
        Sun, 30 Jan 2022 13:32:32 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id o3sm10006613wrq.70.2022.01.30.13.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:32 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 12/13] module: Move kdb_modules list out of core code
Date:   Sun, 30 Jan 2022 21:32:13 +0000
Message-Id: <20220130213214.1042497-13-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates kdb_modules list to core kdb code
since the list of added/or loaded modules is no longer
private.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/debug/kdb/kdb_main.c | 5 +++++
 kernel/module/main.c        | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0852a537dad4..f101f5f078f4 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -59,6 +59,11 @@ EXPORT_SYMBOL(kdb_grepping_flag);
 int kdb_grep_leading;
 int kdb_grep_trailing;
 
+#ifdef CONFIG_MODULES
+extern struct list_head modules;
+struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
+#endif /* CONFIG_MODULES */
+
 /*
  * Kernel debugger state flags
  */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 1d16faea82b3..59e1c271812c 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -104,10 +104,6 @@ static void mod_update_bounds(struct module *mod)
 		__mod_update_bounds(mod->init_layout.base, mod->init_layout.size);
 }
 
-#ifdef CONFIG_KGDB_KDB
-struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
-#endif /* CONFIG_KGDB_KDB */
-
 static void module_assert_mutex_or_preempt(void)
 {
 #ifdef CONFIG_LOCKDEP
-- 
2.34.1

