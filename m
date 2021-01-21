Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F42FE4CE
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 09:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbhAUITM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 03:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbhAUH4n (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:56:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280F2C0613CF;
        Wed, 20 Jan 2021 23:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=E9V5Lb/Kl6K02hipZz+DgQYuGPxz6yTnlmvwlRbYVEk=; b=OZ9VxMXNGSPc+M9N3jWXDbdJSO
        WeIhuXqa5GGKLJObAx2wb5fKylQWz5vQp/piDud8Cj5t43KFg4TG/Y6GS7Q0Q1/0O8Z5noQ+IA8sT
        d7kP8mvu+PxVCfaWv066UtB57SX8xvRdpoHPN/0BZPECgpYA3FzUioji/sHwKl1GZUxKM54Q9Zp/h
        8uSggAm3CpJRKJdIclptoYiG2edrCapRIDH8O6lgzQXqpec5EPXxA6mWH/CyYzPZ7Pq8NEWj9PhMC
        PVGVwIJss/VjgzSxazXEzhZ+MMSFHF7KFVmxsAh8VmlWWUw8kgkliwIvRdw8WrjaFQgz3YJNaT2eS
        4XO/UG7g==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2Unn-00Gm9O-H7; Thu, 21 Jan 2021 07:54:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 07/13] module: mark module_mutex static
Date:   Thu, 21 Jan 2021 08:49:53 +0100
Message-Id: <20210121074959.313333-8-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074959.313333-1-hch@lst.de>
References: <20210121074959.313333-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Except for two lockdep asserts module_mutex is only used in module.c.
Remove the two asserts given that the functions they are in are not
exported and just called from the module code, and mark module_mutex
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/module.h | 2 --
 kernel/module.c        | 2 +-
 lib/bug.c              | 3 ---
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 695f127745af10..c92c30a285144f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -550,8 +550,6 @@ static inline unsigned long kallsyms_symbol_value(const Elf_Sym *sym)
 }
 #endif
 
-extern struct mutex module_mutex;
-
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
diff --git a/kernel/module.c b/kernel/module.c
index e141e5d1d7beaf..d163c78ca8ed69 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -87,7 +87,7 @@
  * 3) module_addr_min/module_addr_max.
  * (delete and add uses RCU list operations).
  */
-DEFINE_MUTEX(module_mutex);
+static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
diff --git a/lib/bug.c b/lib/bug.c
index 7103440c0ee1af..8f9d537bfb2a59 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -91,8 +91,6 @@ void module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 	char *secstrings;
 	unsigned int i;
 
-	lockdep_assert_held(&module_mutex);
-
 	mod->bug_table = NULL;
 	mod->num_bugs = 0;
 
@@ -118,7 +116,6 @@ void module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 
 void module_bug_cleanup(struct module *mod)
 {
-	lockdep_assert_held(&module_mutex);
 	list_del_rcu(&mod->bug_list);
 }
 
-- 
2.29.2

