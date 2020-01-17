Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833F2140D43
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgAQPEG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbgAQPEG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C0F9BBC0;
        Fri, 17 Jan 2020 15:04:04 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 23/23] module: Remove obsolete module_disable_ro()
Date:   Fri, 17 Jan 2020 16:03:23 +0100
Message-Id: <20200117150323.21801-24-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The split livepatch modules are relocated immediately during the module
load. There is no longer needed to disable the RO protection. The function
can be finally remove because livepatching was the only user (sinner).

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/module.h |  2 --
 kernel/module.c        | 13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 8545f3087274..5c9e661ac3bc 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -854,12 +854,10 @@ extern int module_sysfs_initialized;
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
 extern void module_enable_ro(const struct module *mod, bool after_init);
-extern void module_disable_ro(const struct module *mod);
 #else
 static inline void set_all_modules_text_rw(void) { }
 static inline void set_all_modules_text_ro(void) { }
 static inline void module_enable_ro(const struct module *mod, bool after_init) { }
-static inline void module_disable_ro(const struct module *mod) { }
 #endif
 
 #ifdef CONFIG_GENERIC_BUG
diff --git a/kernel/module.c b/kernel/module.c
index 442926fc5f34..d435bad80d7d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2030,19 +2030,6 @@ static void frob_writable_data(const struct module_layout *layout,
 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
 
-/* livepatching wants to disable read-only so it can frob module. */
-void module_disable_ro(const struct module *mod)
-{
-	if (!rodata_enabled)
-		return;
-
-	frob_text(&mod->core_layout, set_memory_rw);
-	frob_rodata(&mod->core_layout, set_memory_rw);
-	frob_ro_after_init(&mod->core_layout, set_memory_rw);
-	frob_text(&mod->init_layout, set_memory_rw);
-	frob_rodata(&mod->init_layout, set_memory_rw);
-}
-
 void module_enable_ro(const struct module *mod, bool after_init)
 {
 	if (!rodata_enabled)
-- 
2.16.4

