Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CEF45109
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 03:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfFNBIp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Jun 2019 21:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfFNBIk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Jun 2019 21:08:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8486C2F8BFA;
        Fri, 14 Jun 2019 01:08:35 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E72E54368;
        Fri, 14 Jun 2019 01:08:34 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/3] module: Improve module __ro_after_init handling
Date:   Thu, 13 Jun 2019 20:07:24 -0500
Message-Id: <1b72f40d863a1444f687b3e1b958bdc6925882ed.1560474114.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560474114.git.jpoimboe@redhat.com>
References: <cover.1560474114.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 01:08:39 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

module_enable_ro() can be called in the following scenario:

  [load livepatch module]
    initcall
      klp_enable_patch()
        klp_init_patch()
          klp_init_object()
            klp_init_object_loaded()
              module_enable_ro(pmod, true)

In this case, module_enable_ro()'s 'after_init' argument is true, which
prematurely changes the module's __ro_after_init area to read-only.

If, theoretically, a registrant of the MODULE_STATE_LIVE module notifier
tried to write to the livepatch module's __ro_after_init section, an
oops would occur.

Remove the 'after_init' argument and instead make __module_enable_ro()
smart enough to only frob the __ro_after_init section after the module
has gone live.

Reported-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/arm64/kernel/ftrace.c |  2 +-
 include/linux/module.h     |  4 ++--
 kernel/livepatch/core.c    |  4 ++--
 kernel/module.c            | 14 +++++++-------
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 65a51331088e..c17d98aafc93 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -120,7 +120,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 			/* point the trampoline to our ftrace entry point */
 			module_disable_ro(mod);
 			*mod->arch.ftrace_trampoline = trampoline;
-			module_enable_ro(mod, true);
+			module_enable_ro(mod);
 
 			/* update trampoline before patching in the branch */
 			smp_wmb();
diff --git a/include/linux/module.h b/include/linux/module.h
index 188998d3dca9..4d6922f3760e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -844,12 +844,12 @@ extern int module_sysfs_initialized;
 #ifdef CONFIG_STRICT_MODULE_RWX
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
-extern void module_enable_ro(const struct module *mod, bool after_init);
+extern void module_enable_ro(const struct module *mod);
 extern void module_disable_ro(const struct module *mod);
 #else
 static inline void set_all_modules_text_rw(void) { }
 static inline void set_all_modules_text_ro(void) { }
-static inline void module_enable_ro(const struct module *mod, bool after_init) { }
+static inline void module_enable_ro(const struct module *mod) { }
 static inline void module_disable_ro(const struct module *mod) { }
 #endif
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c4ce08f43bd6..f9882ffa2f44 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -724,13 +724,13 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	module_disable_ro(patch->mod);
 	ret = klp_write_object_relocations(patch->mod, obj);
 	if (ret) {
-		module_enable_ro(patch->mod, true);
+		module_enable_ro(patch->mod);
 		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
 	arch_klp_init_object_loaded(patch, obj);
-	module_enable_ro(patch->mod, true);
+	module_enable_ro(patch->mod);
 
 	mutex_unlock(&text_mutex);
 
diff --git a/kernel/module.c b/kernel/module.c
index e43a90ee2d23..fb3561e0c5b0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1956,7 +1956,7 @@ void module_disable_ro(const struct module *mod)
 	frob_rodata(&mod->init_layout, set_memory_rw);
 }
 
-void __module_enable_ro(const struct module *mod, bool after_init)
+static void __module_enable_ro(const struct module *mod)
 {
 	if (!rodata_enabled)
 		return;
@@ -1973,15 +1973,15 @@ void __module_enable_ro(const struct module *mod, bool after_init)
 
 	frob_rodata(&mod->init_layout, set_memory_ro);
 
-	if (after_init)
+	if (mod->state == MODULE_STATE_LIVE)
 		frob_ro_after_init(&mod->core_layout, set_memory_ro);
 }
 
-void module_enable_ro(const struct module *mod, bool after_init)
+void module_enable_ro(const struct module *mod)
 {
 	lockdep_assert_held(&text_mutex);
 
-	__module_enable_ro(mod, after_init);
+	__module_enable_ro(mod);
 }
 
 static void __module_enable_nx(const struct module *mod)
@@ -2041,7 +2041,7 @@ void set_all_modules_text_ro(void)
 	mutex_unlock(&module_mutex);
 }
 #else
-static void __module_enable_ro(const struct module *mod, bool after_init) { }
+static void __module_enable_ro(const struct module *mod) { }
 static void __module_enable_nx(const struct module *mod) { }
 #endif
 
@@ -3534,7 +3534,7 @@ static noinline int do_init_module(struct module *mod)
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
-	__module_enable_ro(mod, true);
+	__module_enable_ro(mod);
 	mod_tree_remove_init(mod);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
@@ -3641,7 +3641,7 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
-	__module_enable_ro(mod, false);
+	__module_enable_ro(mod);
 	__module_enable_nx(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
-- 
2.20.1

