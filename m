Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C658307DC4
	for <lists+live-patching@lfdr.de>; Thu, 28 Jan 2021 19:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhA1SU4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jan 2021 13:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhA1SSH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jan 2021 13:18:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8B7C061794;
        Thu, 28 Jan 2021 10:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yOKk2fnchUKV6dOiYsd/LFOPy1HkZGzrcOtdtIA5vO0=; b=nAJtiVFmSQNbH/fB1Kbd5zgUb8
        xXTEhPGqK+FjplkLgB7xtXa0eAVF82tbSHGC3soj/Y6zfdCQ5mFbZw4JZDJdix7n4R7rJfwF06ha1
        uEGUOHi/XXdQpBOP1LKQgWC3AbzZjIIeCXPDBigle/o+zgPq5VxFbvxgoKG8tCCajzHEF7cKvqhag
        W+FAgV3+ubvrJz8izfaANvAqk0lwfS8rLnySG6NDuaTKMmX8htcht2QnxxU5RxXrs89veBipIEp/J
        gJfzIHIwkutmBo6XH326+FAjuyPLuKaw3QZ35l7wPWd2HFswLj+N13H9aZCFy/3ybLAc4capWQS+H
        taCO+lvw==;
Received: from [2001:4bb8:198:6bf4:e052:196b:7e32:37d9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l5Bp3-008nzF-SO; Thu, 28 Jan 2021 18:15:15 +0000
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
Date:   Thu, 28 Jan 2021 19:14:15 +0100
Message-Id: <20210128181421.2279-8-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128181421.2279-1-hch@lst.de>
References: <20210128181421.2279-1-hch@lst.de>
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
index 3ea4ffae608f97..0f360c48fe92a6 100644
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
index 856df9e17ff3d0..5152fae1fc9406 100644
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

