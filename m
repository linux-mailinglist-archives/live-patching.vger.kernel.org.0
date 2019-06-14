Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8622745106
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 03:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfFNBIk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Jun 2019 21:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfFNBIj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Jun 2019 21:08:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38B293086262;
        Fri, 14 Jun 2019 01:08:34 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 131925B68A;
        Fri, 14 Jun 2019 01:08:32 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/3] module: Add text_mutex lockdep assertions for page attribute changes
Date:   Thu, 13 Jun 2019 20:07:23 -0500
Message-Id: <bb2b2c63c60e0b415ea1f78e6a0e3ed89ab82008.1560474114.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560474114.git.jpoimboe@redhat.com>
References: <cover.1560474114.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 14 Jun 2019 01:08:39 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

External callers of the module page attribute change functions now need
to have the text_mutex.  Enforce that with lockdep assertions.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/module.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6e6712b3aaf5..e43a90ee2d23 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -64,6 +64,7 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/memory.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -1943,6 +1944,8 @@ static void frob_writable_data(const struct module_layout *layout,
 /* livepatching wants to disable read-only so it can frob module. */
 void module_disable_ro(const struct module *mod)
 {
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -1953,7 +1956,7 @@ void module_disable_ro(const struct module *mod)
 	frob_rodata(&mod->init_layout, set_memory_rw);
 }
 
-void module_enable_ro(const struct module *mod, bool after_init)
+void __module_enable_ro(const struct module *mod, bool after_init)
 {
 	if (!rodata_enabled)
 		return;
@@ -1974,7 +1977,14 @@ void module_enable_ro(const struct module *mod, bool after_init)
 		frob_ro_after_init(&mod->core_layout, set_memory_ro);
 }
 
-static void module_enable_nx(const struct module *mod)
+void module_enable_ro(const struct module *mod, bool after_init)
+{
+	lockdep_assert_held(&text_mutex);
+
+	__module_enable_ro(mod, after_init);
+}
+
+static void __module_enable_nx(const struct module *mod)
 {
 	frob_rodata(&mod->core_layout, set_memory_nx);
 	frob_ro_after_init(&mod->core_layout, set_memory_nx);
@@ -1988,6 +1998,8 @@ void set_all_modules_text_rw(void)
 {
 	struct module *mod;
 
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -2007,6 +2019,8 @@ void set_all_modules_text_ro(void)
 {
 	struct module *mod;
 
+	lockdep_assert_held(&text_mutex);
+
 	if (!rodata_enabled)
 		return;
 
@@ -2027,7 +2041,8 @@ void set_all_modules_text_ro(void)
 	mutex_unlock(&module_mutex);
 }
 #else
-static void module_enable_nx(const struct module *mod) { }
+static void __module_enable_ro(const struct module *mod, bool after_init) { }
+static void __module_enable_nx(const struct module *mod) { }
 #endif
 
 #ifdef CONFIG_LIVEPATCH
@@ -3519,7 +3534,7 @@ static noinline int do_init_module(struct module *mod)
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
-	module_enable_ro(mod, true);
+	__module_enable_ro(mod, true);
 	mod_tree_remove_init(mod);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
@@ -3626,8 +3641,8 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
-	module_enable_ro(mod, false);
-	module_enable_nx(mod);
+	__module_enable_ro(mod, false);
+	__module_enable_nx(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
-- 
2.20.1

