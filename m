Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E86140D44
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgAQPEG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgAQPEF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B0AEBBB5;
        Fri, 17 Jan 2020 15:04:02 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 19/23] module/livepatch: Allow to use exported symbols from livepatch module for "vmlinux"
Date:   Fri, 17 Jan 2020 16:03:19 +0100
Message-Id: <20200117150323.21801-20-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

HINT: Get some coffee before reading this commit message.

      Stop reading when it gets too complicated. It is possible that we
      will need to resolve symbols from livepatch modules another way.
      Livepatches need to access also non-exported symbols anyway.

      Or just ask me to explain the problem a better way. I have
      ended in many cycles when thinking about it. And it might
      be much easier from another point of view.

The split per-object livepatches brings even more types of module
dependencies. Let's split them into few categories:

A. Livepatch module using an exported symbol from "vmlinux".

   It is quite common and works by definition. Livepatch module is just
   a module from this point of view.

B. Livepatch module using an exported symbol from the patched module.

   It should be avoided even with the non-split livepatch module. The module
   loader automatically takes reference to make sure the modules are
   unloaded in the right order. This would basically prevent the livepatched
   module from unloading.

   Note that it would be perfectly safe to remove this automatic
   dependency. The livepatch framework makes sure that the livepatch
   module is loaded only when the patched one is loaded. But it cannot
   be implemented easily, see below.

C. Livepatch module using an exported symbol from the main livepatch module
   for "vmlinux".

   It is the 2nd most realistic variant. It even exists in current
   selftests. Namely, test_klp_callback_demo* modules share
   the implementation of callbacks. It avoids code duplication.
   And it is actually needed to make module parameters working.

   Note that the current implementation allows to pass module parameters
   only to the main livepatch module for "vmlinux". It should not be a real
   life problem. The parameters are used in selftests. But they are
   not used in practice.

D. Livepatch modules might depend on each other. Note that dependency on
   the main livepatch module for "vmlinux" has got a separate category 'C'.

   The dependencies between modules are quite rare. But they exist.
   One can assume that this might be useful also on the livepatching
   level.

   To keep it sane, the livepatch modules should just follow
   the dependencies of the related patched modules. By other words,
   the livepatch modules might or should have the same dependencies
   as the patched counter parts but nothing more.

Do these dependencies need some special handling?

Yes, the livepatch module load might get blocked in the following
situations:

1. Recursion caused by dependency of type B:

   If a livepatch module uses a symbol from the patched module and
   the livepatch module is loaded by klp_module_coming().
   The module loader will then automatically try to load the patched module
   once again while it is blocked in the klp_module_coming() callback
   and STATE_COMING.

2. Recursion caused by dependency of type C:

   Livepatch for "vmlinux" loads other livepatch modules from
   klp_enabled_patch() in mod->init(). If any of these other
   modules use symbol from the main module for "vmlinux" the module
   loaded will automatically try to load the main module once
   again. The first instance is waiting in klp_enable_patch()
   and STATE_COMING.

3. Deadlock caused by dependency of type D:

   Random dependencies between livepatch and patched modules might
   create a cycle. It need not be obvious and detected by the existing
   code because some dependencies are created by livepatching code.
   It loads the livepatches automatically for patched modules.

What can be done?

First, put aside the problems with random dependencies of type D:

   They are not much realistic. Livepatches follow upstream changes.
   As a result livepatch modules should have the same of less
   dependencies than the related patched modules.

   Note that the existing code is able to handle non-cyclic dependencies
   between livepatch modules. The module loader is able to load more
   modules in parallel. Also klp_add_object() can be called more times
   in parallel.

Second, let's look more at the recursion problems. They might cause
deadlock on two locations in the module loader:

i. The recursive instance waits in add_unformed_module() until the first
   instance reaches STATE_LIVE. But this never happens because the first
   instance waits until the recursive instance finishes.

ii. resolve_symbol() wants to get reference of the module where
   the symbol comes from. But strong_try_module_get() refuses
   to get reference when the module is still in STATE_COMING.
   It does not want to block removing the module when the load
   eventually fails later.

Is it possible to avoid the recursion?

1. It might be possible to avoid calling exported symbols directly
   from the livepatch. For example, using kallsyms lookup. Or some
   special relocation. This would require some extra action when
   preparing the livepatchi.

2. Hide these dependencies to depmod and the module loader. This
   would require changes in the user space tools.

And what about breaking the cycle?

It seems acceptable to return immediately from the nested load
if we are able to guarantee:

  + The recursion is clearly caused by one the of above described
    livepatch dependency type.

  + The code from affected modules will be used only after the modules
    are successfully loaded in the end.

  + The modules will get unloaded when there are other errors
    on the way.

  + The original caller will get the right error code. By other
    words, only the automatically triggered loads will be finished
    prematurely.

OK, this patch provides the solution for the dependency of type C. It is when
other livepatch modules use symbols from the livepatch module for vmlinux.

The recursive load returns -EEXIST immediately when the recursive module
tries to load the same livepatch that is already being loaded. It is
safe because:

  + Only one livepatch can be enabled at a time. Any attempt to enable
    another livepatch would return -EBUSY.

  + The livepatch module for "vmlinux" is never loaded automatically
    because of any dependency. Other livepatch modules for other objects
    might depend on it but the module for "vmlinux" must always be loaded
    explicitly by the system administrator.

By other words, the recursion of the livepatch module for "vmlinux" that
is just being enabled is always caused by dependency of type C.
The recursive instance can and actually must return immediately. It will
allow to proceed. The entire operation will succeed only when the outer
load succeeds.

But there is still the problem that strong_try_module_get() could
not get reference. Isn't it?

Yes, it is solved by not taking references from livepatch modules.
The reference is needed to make sure that the module will not get
removed prematurely. But this is guaranteed by the livepatch code:

   + Livepatch module for "vmlinux" is always loaded first.

   + Livepatch modules for other objects can't be loaded before
     the module for "vmlinux" is loaded, see the checks
     in klp_add_object().

   + Livepatch module is always loaded and removed automatically
     together with the patched module. The dependencies between
     the patched modules are enough as long as the dependencies
     of livepatch modules are symmetric.

Finally. dependency of type B will still cause deadlock. It happens
when a livepatch module uses a symbols from the patched module.
It cannot be solved easily because:

  + The patched module is loaded recursively (not the livepatch one).
    There is no clear way how to make sure that the recursive
    module load is the one triggered by "modprobe" called from
    klp_module_coming().

    As a result, -EEXIST might be returned also to modprobe
    called by the user. It would force the user to double
    check that the patched module has really been loaded.

  + If the above problem is not fixed then the result from
    modprobe is not reliable. The livepatch code might need
    to double check that request_module() really added the
    klp_object into the related klp_patch structure.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 16 ++++++++++++++++
 kernel/module.c           | 16 ++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 4afb7f3a5a36..4776deb7418c 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -207,6 +207,7 @@ int klp_add_object(struct klp_object *);
 void arch_klp_init_object_loaded(struct klp_object *obj);
 
 /* Called from the module loader during module coming/going states */
+bool klp_break_recursion(struct module *mod);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
@@ -244,6 +245,7 @@ struct klp_state *klp_get_prev_state(unsigned long id);
 
 #else /* !CONFIG_LIVEPATCH */
 
+static inline bool klp_break_recursion(struct module *mod) { return false; }
 static inline int klp_module_coming(struct module *mod) { return 0; }
 static inline void klp_module_going(struct module *mod) {}
 static inline bool klp_patch_pending(struct task_struct *task) { return false; }
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6d4ec7642908..9e00871fbc06 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1416,6 +1416,22 @@ static bool klp_is_object_module_alive(const char *patch_name,
 	return alive;
 }
 
+bool klp_break_recursion(struct module *mod)
+{
+	bool ret = false;
+
+	if (!mod->klp)
+		return false;
+
+	mutex_lock(&klp_mutex);
+	if (klp_loading_patch &&
+	    !strcmp(klp_loading_patch->obj->mod->name, mod->name))
+		ret = true;
+	mutex_unlock(&klp_mutex);
+
+	return ret;
+}
+
 int klp_module_coming(struct module *mod)
 {
 	char patch_name[MODULE_NAME_LEN];
diff --git a/kernel/module.c b/kernel/module.c
index ac45d465ff23..bd92854b42c2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -867,6 +867,13 @@ int ref_module(struct module *a, struct module *b)
 {
 	int err;
 
+	/*
+	 * Livepatch modules have their own dependency handling.
+	 * Implicit dependencies might cause cycles.
+	 */
+	if (is_livepatch_module(a))
+		return 0;
+
 	if (b == NULL || already_uses(a, b))
 		return 0;
 
@@ -3730,6 +3737,15 @@ static int add_unformed_module(struct module *mod)
 
 		/* Wait in case it fails to load. */
 		mutex_unlock(&module_mutex);
+
+		/*
+		 * Livepatch modules might use exported symbols from vmlinux.
+		 * It creates automatic dependencies and recursive module load.
+		 * Livepatch core handles the consistency on its own.
+		 */
+		if (klp_break_recursion(mod))
+			return -EEXIST;
+
 		err = wait_event_interruptible(module_wq,
 					       finished_loading(mod->name));
 		if (err)
-- 
2.16.4

