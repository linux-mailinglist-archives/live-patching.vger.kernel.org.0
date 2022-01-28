Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C504A022B
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351230AbiA1UkO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:40:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351337AbiA1Uj6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cvfn0bVpP3Fi5CVaGokDyVZniSa+9b2/16mV0usiezg=;
        b=gwTyU3tNTPXp/RU72TSYjuxJt2yjFSZLQxjkUPCTIVclc/uyoBBt2dhtpTJe9nKAAjsfmD
        wjbaUyw+oumf8Wqc63TrIgT26a/pppmKUnvXsaIc+pjqJg3QI5p2F1bPb+Onf4677aOdDq
        Eduv5XcjZg7SRx50UHpq+W9IVSmaXtA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-RdbrA_0YN5WAswA9ef1fhA-1; Fri, 28 Jan 2022 15:39:55 -0500
X-MC-Unique: RdbrA_0YN5WAswA9ef1fhA-1
Received: by mail-wm1-f71.google.com with SMTP id s190-20020a1ca9c7000000b00347c6c39d9aso3459060wme.5
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cvfn0bVpP3Fi5CVaGokDyVZniSa+9b2/16mV0usiezg=;
        b=v3K8YWCo/Y5wRJAa1xl1/txk9c2NugaVPwSB6xweF+0IGww0rtjMEJ0PUZ3fGSLCMJ
         lDq2VZSrnbpq/sO0ai5t9Wx/w0/XUMqEF06h36JXpgyv4MpwqVHiTdiYKXfTCYgfWJ6d
         vK9f9CQUOsepsaOWMQbEOWvR4mlj8Sapkc7FI26UslSkNTjGew0F1+4so5cXBVtzqTgH
         EdOOSsmlq9ub3JMRTUlB/OVV4FzCl9ko6bF5/H6I9ZEFdWz0O68IZDJukHD3Qmh9Vz10
         y3vLSoUXkZAx211e9TwINIwa4gFAmxcfHWBQcEpUYNIJ3se2lrhtIQJTbKro5kultbve
         epFQ==
X-Gm-Message-State: AOAM530WJvvQDQnhjhnXmpq7Tjh9ARkcT2ZRLi7zf6TgYvooRv33Z4sJ
        2g8isIQijGqAkZF/ndCJbG26Um4uM8a1xOPz6X3JW65otJuOb/sgbgQkWshdsfSg+LH7n2MtQ7x
        B6mI8pBgNpesFRYlQI0WLkhwv
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr17147963wmk.100.1643402392128;
        Fri, 28 Jan 2022 12:39:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwb+wzu/hLRoeXjm/y3t8LcvyRcltKIrNu92Ny5zltolnetF6p7wW8V6BSuucGgTUuwWffimQ==
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr17147947wmk.100.1643402391944;
        Fri, 28 Jan 2022 12:39:51 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id t5sm5619441wrw.92.2022.01.28.12.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:49 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 12/13] module: Move kdb_modules list out of core code
Date:   Fri, 28 Jan 2022 20:39:33 +0000
Message-Id: <20220128203934.600247-13-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
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
index 574cba3e0418..1f16e67f687f 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -95,10 +95,6 @@ static void mod_update_bounds(struct module *mod)
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

