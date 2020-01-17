Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5720C140D38
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAQPDw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:45482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgAQPDw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 261B2BB75;
        Fri, 17 Jan 2020 15:03:43 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 02/23] livepatch: Split livepatch modules per livepatched object
Date:   Fri, 17 Jan 2020 16:03:02 +0100
Message-Id: <20200117150323.21801-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

One livepatch module allows to fix vmlinux and any number of modules
while providing some guarantees defined by the consistency model.

The patched modules can be loaded at any time: before, during,
or after the livepatch module gets loaded. They can even get
removed and loaded again. This variety of scenarios bring some
troubles. For example, some livepatch symbols could be relocated
only after the related module gets loaded. These changes need
to get cleared when the module gets unloaded so that it can
get eventually loaded again.

As a result some functionality needs to be duplicated by
the livepatching code. Some elf sections need to be preserved
even when they normally can be removed during the module load.
Architecture specific code is involved which makes harder
adding support for new architectures and the maintainace.

The solution is to split the livepatch module per livepatched
object (vmlinux or module). Then both livepatch module and
the livepatched modules could get loaded and removed at the
same time.

This require many changes in the livepatch subsystem, module
loader, sample livepatches and livepatches needed for selftests.

The bad news is that bisection will not work by definition.
The good news is that it allows to do the changes in smaller
steps.

The first step allows to split the existing sample and testing
modules so that they can be later user. It is done by
the following changes:

1. struct klp_patch:

  + Add "patch_name" and "obj_names" to match all the related
    livepatch modules.

  + Replace "objs" array with a pointer to a single struct object.

  + move "mod" to struct object.

2. struct klp_object:

  + Add "patch_name" to match all the related livepatch modules.

  + "mod" points to the livepatch module instead of the livepatched
    one. The pointer to the livepatched module was used only to
    detect whether it was loaded. It will be always loaded
    with related livepatch module now.

3. klp_find_object_module() and klp_is_object_loaded() are no longer
   needed. Livepatch module is loaded only when the related livepatched
   module is loaded.

4. Add klp_add_object() function that will need to initialize
   struct object, link it into the related struct klp_patch,
   and patch the functions. It will get implemented later.

The livepatches for modules are put into separate source files
that define only struct klp_object() and call the new klp_add_object()
in the init() callback. The name of the module follows the pattern:

  <patch_name>__<object_name>

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 arch/x86/kernel/livepatch.c                        |   5 +-
 include/linux/livepatch.h                          |  20 +--
 kernel/livepatch/core.c                            | 139 +++++++-----------
 kernel/livepatch/core.h                            |   5 -
 kernel/livepatch/transition.c                      |  14 +-
 lib/livepatch/Makefile                             |   2 +
 lib/livepatch/test_klp_atomic_replace.c            |  18 ++-
 lib/livepatch/test_klp_callbacks_demo.c            |  90 ++++++------
 lib/livepatch/test_klp_callbacks_demo.h            |  11 ++
 lib/livepatch/test_klp_callbacks_demo2.c           |  62 ++++++---
 lib/livepatch/test_klp_callbacks_demo2.h           |  11 ++
 ...t_klp_callbacks_demo__test_klp_callbacks_busy.c |  50 +++++++
 ...st_klp_callbacks_demo__test_klp_callbacks_mod.c |  42 ++++++
 lib/livepatch/test_klp_livepatch.c                 |  18 ++-
 lib/livepatch/test_klp_state.c                     |  53 ++++---
 lib/livepatch/test_klp_state2.c                    |  53 ++++---
 samples/livepatch/Makefile                         |   4 +
 samples/livepatch/livepatch-callbacks-demo.c       |  90 ++++++------
 samples/livepatch/livepatch-callbacks-demo.h       |  11 ++
 ...h-callbacks-demo__livepatch-callbacks-busymod.c |  54 +++++++
 ...patch-callbacks-demo__livepatch-callbacks-mod.c |  46 ++++++
 samples/livepatch/livepatch-sample.c               |  18 ++-
 samples/livepatch/livepatch-shadow-fix1.c          | 120 ++--------------
 .../livepatch-shadow-fix1__livepatch-shadow-mod.c  | 155 +++++++++++++++++++++
 samples/livepatch/livepatch-shadow-fix2.c          |  92 ++----------
 .../livepatch-shadow-fix2__livepatch-shadow-mod.c  | 127 +++++++++++++++++
 .../testing/selftests/livepatch/test-callbacks.sh  |  16 +--
 27 files changed, 841 insertions(+), 485 deletions(-)
 create mode 100644 lib/livepatch/test_klp_callbacks_demo.h
 create mode 100644 lib/livepatch/test_klp_callbacks_demo2.h
 create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c
 create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c
 create mode 100644 samples/livepatch/livepatch-callbacks-demo.h
 create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c
 create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c
 create mode 100644 samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c
 create mode 100644 samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c

diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
index 6a68e41206e7..728b44eaa168 100644
--- a/arch/x86/kernel/livepatch.c
+++ b/arch/x86/kernel/livepatch.c
@@ -9,8 +9,7 @@
 #include <asm/text-patching.h>
 
 /* Apply per-object alternatives. Based on x86 module_finalize() */
-void arch_klp_init_object_loaded(struct klp_patch *patch,
-				 struct klp_object *obj)
+void arch_klp_init_object_loaded(struct klp_object *obj)
 {
 	int cnt;
 	struct klp_modinfo *info;
@@ -20,7 +19,7 @@ void arch_klp_init_object_loaded(struct klp_patch *patch,
 	char sec_objname[MODULE_NAME_LEN];
 	char secname[KSYM_NAME_LEN];
 
-	info = patch->mod->klp_info;
+	info = obj->mod->klp_info;
 	objname = obj->name ? obj->name : "vmlinux";
 
 	/* See livepatch core code for BUILD_BUG_ON() explanation */
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index e894e74905f3..a4567c17a9f2 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -105,19 +105,21 @@ struct klp_callbacks {
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
+ * @patch_name:	module name for  vmlinux
+ * @mod:	reference to the live patch module for this object
  * @funcs:	function entries for functions to be patched in the object
  * @callbacks:	functions to be executed pre/post (un)patching
  * @kobj:	kobject for sysfs resources
  * @func_list:	dynamic list of the function entries
  * @node:	list node for klp_patch obj_list
- * @mod:	kernel module associated with the patched object
- *		(NULL for vmlinux)
  * @dynamic:    temporary object for nop functions; dynamically allocated
  * @patched:	the object's funcs have been added to the klp_ops list
  */
 struct klp_object {
 	/* external */
 	const char *name;
+	const char *patch_name;
+	struct module *mod;
 	struct klp_func *funcs;
 	struct klp_callbacks callbacks;
 
@@ -125,7 +127,6 @@ struct klp_object {
 	struct kobject kobj;
 	struct list_head func_list;
 	struct list_head node;
-	struct module *mod;
 	bool dynamic;
 	bool patched;
 };
@@ -144,8 +145,9 @@ struct klp_state {
 
 /**
  * struct klp_patch - patch structure for live patching
- * @mod:	reference to the live patch module
- * @objs:	object entries for kernel objects to be patched
+ * @patch_name: livepatch name; same for related livepatch against other objects
+ * @objs:	object entry for vmlinux object
+ * @obj_names:	names of modules synchronously livepatched with this patch
  * @states:	system states that can get modified
  * @replace:	replace all actively used patches
  * @list:	list node for global list of actively used patches
@@ -158,9 +160,9 @@ struct klp_state {
  */
 struct klp_patch {
 	/* external */
-	struct module *mod;
-	struct klp_object *objs;
 	struct klp_state *states;
+	struct klp_object *obj;
+	char **obj_names;
 	bool replace;
 
 	/* internal */
@@ -194,9 +196,9 @@ struct klp_patch {
 	list_for_each_entry(func, &obj->func_list, node)
 
 int klp_enable_patch(struct klp_patch *);
+int klp_add_object(struct klp_object *);
 
-void arch_klp_init_object_loaded(struct klp_patch *patch,
-				 struct klp_object *obj);
+void arch_klp_init_object_loaded(struct klp_object *obj);
 
 /* Called from the module loader during module coming/going states */
 int klp_module_coming(struct module *mod);
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c3512e7e0801..bb62c5407b75 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -49,34 +49,6 @@ static bool klp_is_module(struct klp_object *obj)
 	return obj->name;
 }
 
-/* sets obj->mod if object is not vmlinux and module is found */
-static void klp_find_object_module(struct klp_object *obj)
-{
-	struct module *mod;
-
-	if (!klp_is_module(obj))
-		return;
-
-	mutex_lock(&module_mutex);
-	/*
-	 * We do not want to block removal of patched modules and therefore
-	 * we do not take a reference here. The patches are removed by
-	 * klp_module_going() instead.
-	 */
-	mod = find_module(obj->name);
-	/*
-	 * Do not mess work of klp_module_coming() and klp_module_going().
-	 * Note that the patch might still be needed before klp_module_going()
-	 * is called. Module functions can be called even in the GOING state
-	 * until mod->exit() finishes. This is especially important for
-	 * patches that modify semantic of the functions.
-	 */
-	if (mod && mod->klp_alive)
-		obj->mod = mod;
-
-	mutex_unlock(&module_mutex);
-}
-
 static bool klp_initialized(void)
 {
 	return !!klp_root_kobj;
@@ -246,18 +218,16 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
 	return 0;
 }
 
-static int klp_write_object_relocations(struct module *pmod,
-					struct klp_object *obj)
+static int klp_write_object_relocations(struct klp_object *obj)
 {
 	int i, cnt, ret = 0;
 	const char *objname, *secname;
 	char sec_objname[MODULE_NAME_LEN];
+	struct module *pmod;
 	Elf_Shdr *sec;
 
-	if (WARN_ON(!klp_is_object_loaded(obj)))
-		return -EINVAL;
-
 	objname = klp_is_module(obj) ? obj->name : "vmlinux";
+	pmod = obj->mod;
 
 	/* For each klp relocation section */
 	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
@@ -419,8 +389,8 @@ static void klp_free_object_dynamic(struct klp_object *obj)
 
 static void klp_init_func_early(struct klp_object *obj,
 				struct klp_func *func);
-static void klp_init_object_early(struct klp_patch *patch,
-				  struct klp_object *obj);
+static int klp_init_object_early(struct klp_patch *patch,
+				 struct klp_object *obj);
 
 static struct klp_object *klp_alloc_object_dynamic(const char *name,
 						   struct klp_patch *patch)
@@ -662,7 +632,7 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 
 	/* Put the module after the last access to struct klp_patch. */
 	if (!patch->forced)
-		module_put(patch->mod);
+		module_put(patch->obj->mod);
 }
 
 /*
@@ -725,30 +695,28 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 }
 
 /* Arches may override this to finish any remaining arch-specific tasks */
-void __weak arch_klp_init_object_loaded(struct klp_patch *patch,
-					struct klp_object *obj)
+void __weak arch_klp_init_object_loaded(struct klp_object *obj)
 {
 }
 
 /* parts of the initialization that is done only when the object is loaded */
-static int klp_init_object_loaded(struct klp_patch *patch,
-				  struct klp_object *obj)
+static int klp_init_object_loaded(struct klp_object *obj)
 {
 	struct klp_func *func;
 	int ret;
 
 	mutex_lock(&text_mutex);
 
-	module_disable_ro(patch->mod);
-	ret = klp_write_object_relocations(patch->mod, obj);
+	module_disable_ro(obj->mod);
+	ret = klp_write_object_relocations(obj);
 	if (ret) {
-		module_enable_ro(patch->mod, true);
+		module_enable_ro(obj->mod, true);
 		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
-	arch_klp_init_object_loaded(patch, obj);
-	module_enable_ro(patch->mod, true);
+	arch_klp_init_object_loaded(obj);
+	module_enable_ro(obj->mod, true);
 
 	mutex_unlock(&text_mutex);
 
@@ -792,11 +760,8 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 		return -EINVAL;
 
 	obj->patched = false;
-	obj->mod = NULL;
 
-	klp_find_object_module(obj);
-
-	name = klp_is_module(obj) ? obj->name : "vmlinux";
+	name = obj->name ? obj->name : "vmlinux";
 	ret = kobject_add(&obj->kobj, &patch->kobj, "%s", name);
 	if (ret)
 		return ret;
@@ -807,8 +772,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 			return ret;
 	}
 
-	if (klp_is_object_loaded(obj))
-		ret = klp_init_object_loaded(patch, obj);
+	ret = klp_init_object_loaded(obj);
 
 	return ret;
 }
@@ -820,20 +784,34 @@ static void klp_init_func_early(struct klp_object *obj,
 	list_add_tail(&func->node, &obj->func_list);
 }
 
-static void klp_init_object_early(struct klp_patch *patch,
+static int klp_init_object_early(struct klp_patch *patch,
 				  struct klp_object *obj)
 {
+	struct klp_func *func;
+
+	if (!obj->funcs)
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&obj->func_list);
 	kobject_init(&obj->kobj, &klp_ktype_object);
 	list_add_tail(&obj->node, &patch->obj_list);
+
+	klp_for_each_func_static(obj, func) {
+		klp_init_func_early(obj, func);
+	}
+
+	if (obj->dynamic || try_module_get(obj->mod))
+		return 0;
+
+	return -ENODEV;
 }
 
 static int klp_init_patch_early(struct klp_patch *patch)
 {
-	struct klp_object *obj;
-	struct klp_func *func;
+	struct klp_object *obj = patch->obj;
 
-	if (!patch->objs)
+	/* Main patch module is always for vmlinux */
+	if (obj->name)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&patch->list);
@@ -844,21 +822,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 	init_completion(&patch->finish);
 
-	klp_for_each_object_static(patch, obj) {
-		if (!obj->funcs)
-			return -EINVAL;
-
-		klp_init_object_early(patch, obj);
-
-		klp_for_each_func_static(obj, func) {
-			klp_init_func_early(obj, func);
-		}
-	}
-
-	if (!try_module_get(patch->mod))
-		return -ENODEV;
-
-	return 0;
+	return klp_init_object_early(patch, obj);
 }
 
 static int klp_init_patch(struct klp_patch *patch)
@@ -866,7 +830,7 @@ static int klp_init_patch(struct klp_patch *patch)
 	struct klp_object *obj;
 	int ret;
 
-	ret = kobject_add(&patch->kobj, klp_root_kobj, "%s", patch->mod->name);
+	ret = kobject_add(&patch->kobj, klp_root_kobj, "%s", patch->obj->mod->name);
 	if (ret)
 		return ret;
 
@@ -887,6 +851,12 @@ static int klp_init_patch(struct klp_patch *patch)
 	return 0;
 }
 
+int klp_add_object(struct klp_object *obj)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(klp_add_object);
+
 static int __klp_disable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
@@ -930,7 +900,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	if (WARN_ON(patch->enabled))
 		return -EINVAL;
 
-	pr_notice("enabling patch '%s'\n", patch->mod->name);
+	pr_notice("enabling patch '%s'\n", patch->obj->patch_name);
 
 	klp_init_transition(patch, KLP_PATCHED);
 
@@ -944,9 +914,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	smp_wmb();
 
 	klp_for_each_object(patch, obj) {
-		if (!klp_is_object_loaded(obj))
-			continue;
-
 		ret = klp_pre_patch_callback(obj);
 		if (ret) {
 			pr_warn("pre-patch callback failed for object '%s'\n",
@@ -968,7 +935,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	return 0;
 err:
-	pr_warn("failed to enable patch '%s'\n", patch->mod->name);
+	pr_warn("failed to enable patch '%s'\n", patch->obj->patch_name);
 
 	klp_cancel_transition();
 	return ret;
@@ -991,12 +958,12 @@ int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!patch || !patch->mod)
+	if (!patch || !patch->obj || !patch->obj->mod)
 		return -EINVAL;
 
-	if (!is_livepatch_module(patch->mod)) {
+	if (!is_livepatch_module(patch->obj->mod)) {
 		pr_err("module %s is not marked as a livepatch module\n",
-		       patch->mod->name);
+		       patch->obj->patch_name);
 		return -EINVAL;
 	}
 
@@ -1012,7 +979,7 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	if (!klp_is_patch_compatible(patch)) {
 		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
-			patch->mod->name);
+			patch->obj->mod->name);
 		mutex_unlock(&klp_mutex);
 		return -EINVAL;
 	}
@@ -1119,7 +1086,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 				klp_pre_unpatch_callback(obj);
 
 			pr_notice("reverting patch '%s' on unloading module '%s'\n",
-				  patch->mod->name, obj->mod->name);
+				  patch->obj->patch_name, obj->name);
 			klp_unpatch_object(obj);
 
 			klp_post_unpatch_callback(obj);
@@ -1154,15 +1121,15 @@ int klp_module_coming(struct module *mod)
 
 			obj->mod = mod;
 
-			ret = klp_init_object_loaded(patch, obj);
+			ret = klp_init_object_loaded(obj);
 			if (ret) {
 				pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
-					patch->mod->name, obj->mod->name, ret);
+					patch->obj->patch_name, obj->name, ret);
 				goto err;
 			}
 
 			pr_notice("applying patch '%s' to loading module '%s'\n",
-				  patch->mod->name, obj->mod->name);
+				  patch->obj->patch_name, obj->name);
 
 			ret = klp_pre_patch_callback(obj);
 			if (ret) {
@@ -1174,7 +1141,7 @@ int klp_module_coming(struct module *mod)
 			ret = klp_patch_object(obj);
 			if (ret) {
 				pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
-					patch->mod->name, obj->mod->name, ret);
+					patch->obj->patch_name, obj->name, ret);
 
 				klp_post_unpatch_callback(obj);
 				goto err;
@@ -1197,7 +1164,7 @@ int klp_module_coming(struct module *mod)
 	 * error to the module loader.
 	 */
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
-		patch->mod->name, obj->mod->name, obj->mod->name);
+		patch->obj->patch_name, obj->name, obj->name);
 	mod->klp_alive = false;
 	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 38209c7361b6..01980cc0509b 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -18,11 +18,6 @@ void klp_free_replaced_patches_async(struct klp_patch *new_patch);
 void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
 void klp_discard_nops(struct klp_patch *new_patch);
 
-static inline bool klp_is_object_loaded(struct klp_object *obj)
-{
-	return !obj->name || obj->mod;
-}
-
 static inline int klp_pre_patch_callback(struct klp_object *obj)
 {
 	int ret = 0;
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f6310f848f34..78e3280560cd 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -74,7 +74,7 @@ static void klp_complete_transition(void)
 	unsigned int cpu;
 
 	pr_debug("'%s': completing %s transition\n",
-		 klp_transition_patch->mod->name,
+		 klp_transition_patch->obj->patch_name,
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
@@ -120,15 +120,13 @@ static void klp_complete_transition(void)
 	}
 
 	klp_for_each_object(klp_transition_patch, obj) {
-		if (!klp_is_object_loaded(obj))
-			continue;
 		if (klp_target_state == KLP_PATCHED)
 			klp_post_patch_callback(obj);
 		else if (klp_target_state == KLP_UNPATCHED)
 			klp_post_unpatch_callback(obj);
 	}
 
-	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
+	pr_notice("'%s': %s complete\n", klp_transition_patch->obj->patch_name,
 		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
 	klp_target_state = KLP_UNDEFINED;
@@ -147,7 +145,7 @@ void klp_cancel_transition(void)
 		return;
 
 	pr_debug("'%s': canceling patching transition, going to unpatch\n",
-		 klp_transition_patch->mod->name);
+		 klp_transition_patch->obj->patch_name);
 
 	klp_target_state = KLP_UNPATCHED;
 	klp_complete_transition();
@@ -468,7 +466,7 @@ void klp_start_transition(void)
 	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
 
 	pr_notice("'%s': starting %s transition\n",
-		  klp_transition_patch->mod->name,
+		  klp_transition_patch->obj->patch_name,
 		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
 	/*
@@ -519,7 +517,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 */
 	klp_target_state = state;
 
-	pr_debug("'%s': initializing %s transition\n", patch->mod->name,
+	pr_debug("'%s': initializing %s transition\n", patch->obj->patch_name,
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
 	/*
@@ -581,7 +579,7 @@ void klp_reverse_transition(void)
 	struct task_struct *g, *task;
 
 	pr_debug("'%s': reversing transition from %s\n",
-		 klp_transition_patch->mod->name,
+		 klp_transition_patch->obj->patch_name,
 		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
 						   "unpatching to patching");
 
diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index 295b94bff370..812da987da42 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -4,6 +4,8 @@
 
 obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_demo.o \
+				test_klp_callbacks_demo__test_klp_callbacks_busy.o \
+				test_klp_callbacks_demo__test_klp_callbacks_mod.o \
 				test_klp_callbacks_demo2.o \
 				test_klp_callbacks_busy.o \
 				test_klp_callbacks_mod.o \
diff --git a/lib/livepatch/test_klp_atomic_replace.c b/lib/livepatch/test_klp_atomic_replace.c
index 5af7093ca00c..bd42f9af9843 100644
--- a/lib/livepatch/test_klp_atomic_replace.c
+++ b/lib/livepatch/test_klp_atomic_replace.c
@@ -26,16 +26,20 @@ static struct klp_func funcs[] = {
 	}, {}
 };
 
-static struct klp_object objs[] = {
-	{
-		/* name being NULL means vmlinux */
-		.funcs = funcs,
-	}, {}
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = funcs,
+};
+
+static char *obj_names[] = {
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 	/* set .replace in the init function below for demo purposes */
 };
 
diff --git a/lib/livepatch/test_klp_callbacks_demo.c b/lib/livepatch/test_klp_callbacks_demo.c
index 3fd8fe1cd1cc..0e51cbd4b61c 100644
--- a/lib/livepatch/test_klp_callbacks_demo.c
+++ b/lib/livepatch/test_klp_callbacks_demo.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
+#include "test_klp_callbacks_demo.h"
 
 static int pre_patch_ret;
 module_param(pre_patch_ret, int, 0644);
@@ -20,88 +21,79 @@ static const char *const module_state[] = {
 
 static void callback_info(const char *callback, struct klp_object *obj)
 {
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
+	struct module *mod;
+
+	if (!obj->name) {
 		pr_info("%s: vmlinux\n", callback);
+		return;
+	}
+
+	mutex_lock(&module_mutex);
+	mod = find_module(obj->name);
+	if (mod) {
+		pr_info("%s: %s -> %s\n", callback, obj->name,
+			module_state[mod->state]);
+	} else {
+		pr_err("%s: Unable to find module: %s", callback, obj->name);
+	}
+	mutex_unlock(&module_mutex);
 }
 
 /* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
+int pre_patch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 	return pre_patch_ret;
 }
+EXPORT_SYMBOL(pre_patch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
+void post_patch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(post_patch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
+void pre_unpatch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(pre_unpatch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
+void post_unpatch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
-
-static void patched_work_func(struct work_struct *work)
-{
-	pr_info("%s\n", __func__);
-}
+EXPORT_SYMBOL(post_unpatch_callback);
 
 static struct klp_func no_funcs[] = {
 	{}
 };
 
-static struct klp_func busymod_funcs[] = {
-	{
-		.old_name = "busymod_work_func",
-		.new_func = patched_work_func,
-	}, {}
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback,
+		.post_patch = post_patch_callback,
+		.pre_unpatch = pre_unpatch_callback,
+		.post_unpatch = post_unpatch_callback,
+	},
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "test_klp_callbacks_mod",
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "test_klp_callbacks_busy",
-		.funcs = busymod_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
+static char *obj_names[] = {
+	"test_klp_callbacks_mod",
+	"test_klp_callbacks_busy",
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int test_klp_callbacks_demo_init(void)
diff --git a/lib/livepatch/test_klp_callbacks_demo.h b/lib/livepatch/test_klp_callbacks_demo.h
new file mode 100644
index 000000000000..d34a6c4b6c91
--- /dev/null
+++ b/lib/livepatch/test_klp_callbacks_demo.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+#include <linux/livepatch.h>
+
+#define LIVEPATCH_NAME "test_klp_callbacks_demo"
+
+int pre_patch_callback(struct klp_object *obj);
+void post_patch_callback(struct klp_object *obj);
+void pre_unpatch_callback(struct klp_object *obj);
+void post_unpatch_callback(struct klp_object *obj);
diff --git a/lib/livepatch/test_klp_callbacks_demo2.c b/lib/livepatch/test_klp_callbacks_demo2.c
index 5417573e80af..d83711ce52e3 100644
--- a/lib/livepatch/test_klp_callbacks_demo2.c
+++ b/lib/livepatch/test_klp_callbacks_demo2.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
+#include "test_klp_callbacks_demo2.h"
 
 static int replace;
 module_param(replace, int, 0644);
@@ -20,58 +21,77 @@ static const char *const module_state[] = {
 
 static void callback_info(const char *callback, struct klp_object *obj)
 {
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
+	struct module *mod;
+
+	if (!obj->name) {
 		pr_info("%s: vmlinux\n", callback);
+		return;
+	}
+
+	mutex_lock(&module_mutex);
+	mod = find_module(obj->name);
+	if (mod) {
+		pr_info("%s: %s -> %s\n", callback, obj->name,
+			module_state[mod->state]);
+	} else {
+		pr_err("%s: Unable to find module: %s", callback, obj->name);
+	}
+	mutex_unlock(&module_mutex);
 }
 
 /* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
+int pre_patch_callback2(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 	return 0;
 }
+EXPORT_SYMBOL(pre_patch_callback2);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
+void post_patch_callback2(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(post_patch_callback2);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
+void pre_unpatch_callback2(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(pre_unpatch_callback2);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
+void post_unpatch_callback2(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(post_unpatch_callback2);
 
 static struct klp_func no_funcs[] = {
 	{ }
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback2,
+		.post_patch = post_patch_callback2,
+		.pre_unpatch = pre_unpatch_callback2,
+		.post_unpatch = post_unpatch_callback2,
+	},
+};
+
+static char *obj_names[] = {
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 	/* set .replace in the init function below for demo purposes */
 };
 
diff --git a/lib/livepatch/test_klp_callbacks_demo2.h b/lib/livepatch/test_klp_callbacks_demo2.h
new file mode 100644
index 000000000000..595da3395628
--- /dev/null
+++ b/lib/livepatch/test_klp_callbacks_demo2.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+#include <linux/livepatch.h>
+
+#define LIVEPATCH_NAME "test_klp_callbacks_demo2"
+
+int pre_patch_callback2(struct klp_object *obj);
+void post_patch_callback2(struct klp_object *obj);
+void pre_unpatch_callback2(struct klp_object *obj);
+void post_unpatch_callback2(struct klp_object *obj);
diff --git a/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c b/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c
new file mode 100644
index 000000000000..5255cfb22d23
--- /dev/null
+++ b/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include "test_klp_callbacks_demo.h"
+
+static void patched_work_func(struct work_struct *work)
+{
+	pr_info("%s\n", __func__);
+}
+
+static struct klp_func busymod_funcs[] = {
+	{
+		.old_name = "busymod_work_func",
+		.new_func = patched_work_func,
+	}, {}
+};
+
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = "test_klp_callbacks_busy",
+	.mod = THIS_MODULE,
+	.funcs = busymod_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback,
+		.post_patch = post_patch_callback,
+		.pre_unpatch = pre_unpatch_callback,
+		.post_unpatch = post_unpatch_callback,
+	},
+};
+
+static int test_klp_callbacks_demo_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void test_klp_callbacks_demo_exit(void)
+{
+}
+
+module_init(test_klp_callbacks_demo_init);
+module_exit(test_klp_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: livepatch demo");
diff --git a/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c b/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c
new file mode 100644
index 000000000000..f2208deecde1
--- /dev/null
+++ b/lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include "test_klp_callbacks_demo.h"
+
+static struct klp_func no_funcs[] = {
+	{}
+};
+
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = "test_klp_callbacks_mod",
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback,
+		.post_patch = post_patch_callback,
+		.pre_unpatch = pre_unpatch_callback,
+		.post_unpatch = post_unpatch_callback,
+	},
+};
+
+static int test_klp_callbacks_demo_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void test_klp_callbacks_demo_exit(void)
+{
+}
+
+module_init(test_klp_callbacks_demo_init);
+module_exit(test_klp_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: livepatch demo");
diff --git a/lib/livepatch/test_klp_livepatch.c b/lib/livepatch/test_klp_livepatch.c
index aff08199de71..d7606d7b8367 100644
--- a/lib/livepatch/test_klp_livepatch.c
+++ b/lib/livepatch/test_klp_livepatch.c
@@ -22,16 +22,20 @@ static struct klp_func funcs[] = {
 	}, { }
 };
 
-static struct klp_object objs[] = {
-	{
-		/* name being NULL means vmlinux */
-		.funcs = funcs,
-	}, { }
+struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = funcs,
+};
+
+static char *obj_names[] = {
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int test_klp_livepatch_init(void)
diff --git a/lib/livepatch/test_klp_state.c b/lib/livepatch/test_klp_state.c
index 57a4253acb01..26e8cb86d59d 100644
--- a/lib/livepatch/test_klp_state.c
+++ b/lib/livepatch/test_klp_state.c
@@ -22,11 +22,22 @@ static const char *const module_state[] = {
 
 static void callback_info(const char *callback, struct klp_object *obj)
 {
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
+	struct module *mod;
+
+	if (!obj->name) {
 		pr_info("%s: vmlinux\n", callback);
+		return;
+	}
+
+	mutex_lock(&module_mutex);
+	mod = find_module(obj->name);
+	if (mod) {
+		pr_info("%s: %s -> %s\n", callback, obj->name,
+			module_state[mod->state]);
+	} else {
+		pr_err("%s: Unable to find module: %s", callback, obj->name);
+	}
+	mutex_unlock(&module_mutex);
 }
 
 static struct klp_patch patch;
@@ -118,19 +129,6 @@ static struct klp_func no_funcs[] = {
 	{}
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
-};
-
 static struct klp_state states[] = {
 	{
 		.id = CONSOLE_LOGLEVEL_STATE,
@@ -138,9 +136,26 @@ static struct klp_state states[] = {
 	}, { }
 };
 
-static struct klp_patch patch = {
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
 	.mod = THIS_MODULE,
-	.objs = objs,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback,
+		.post_patch = post_patch_callback,
+		.pre_unpatch = pre_unpatch_callback,
+		.post_unpatch = post_unpatch_callback,
+	},
+};
+
+static char *obj_names[] = {
+	NULL
+};
+
+static struct klp_patch patch = {
+	.obj = &obj,
+	.obj_names = obj_names,
 	.states = states,
 	.replace = true,
 };
diff --git a/lib/livepatch/test_klp_state2.c b/lib/livepatch/test_klp_state2.c
index c978ea4d5e67..4942924d5cb2 100644
--- a/lib/livepatch/test_klp_state2.c
+++ b/lib/livepatch/test_klp_state2.c
@@ -22,11 +22,22 @@ static const char *const module_state[] = {
 
 static void callback_info(const char *callback, struct klp_object *obj)
 {
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
+	struct module *mod;
+
+	if (!obj->name) {
 		pr_info("%s: vmlinux\n", callback);
+		return;
+	}
+
+	mutex_lock(&module_mutex);
+	mod = find_module(obj->name);
+	if (mod) {
+		pr_info("%s: %s -> %s\n", callback, obj->name,
+			module_state[mod->state]);
+	} else {
+		pr_err("%s: Unable to find module: %s", callback, obj->name);
+	}
+	mutex_unlock(&module_mutex);
 }
 
 static struct klp_patch patch;
@@ -147,19 +158,6 @@ static struct klp_func no_funcs[] = {
 	{}
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
-};
-
 static struct klp_state states[] = {
 	{
 		.id = CONSOLE_LOGLEVEL_STATE,
@@ -167,9 +165,26 @@ static struct klp_state states[] = {
 	}, { }
 };
 
-static struct klp_patch patch = {
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
 	.mod = THIS_MODULE,
-	.objs = objs,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = pre_patch_callback,
+		.post_patch = post_patch_callback,
+		.pre_unpatch = pre_unpatch_callback,
+		.post_unpatch = post_unpatch_callback,
+	},
+};
+
+static char *obj_names[] = {
+	NULL
+};
+
+static struct klp_patch patch = {
+	.obj = &obj,
+	.obj_names = obj_names,
 	.states = states,
 	.replace = true,
 };
diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..922bf3fa335c 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -2,7 +2,11 @@
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-sample.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix1.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix1__livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2__livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo__livepatch-callbacks-mod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo__livepatch-callbacks-busymod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
diff --git a/samples/livepatch/livepatch-callbacks-demo.c b/samples/livepatch/livepatch-callbacks-demo.c
index 11c3f4357812..d119f8ba4f3d 100644
--- a/samples/livepatch/livepatch-callbacks-demo.c
+++ b/samples/livepatch/livepatch-callbacks-demo.c
@@ -83,6 +83,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
+#include "livepatch-callbacks-demo.h"
 
 static int pre_patch_ret;
 module_param(pre_patch_ret, int, 0644);
@@ -97,88 +98,79 @@ static const char *const module_state[] = {
 
 static void callback_info(const char *callback, struct klp_object *obj)
 {
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
+	struct module *mod;
+
+	if (!obj->name) {
 		pr_info("%s: vmlinux\n", callback);
+		return;
+	}
+
+	mutex_lock(&module_mutex);
+	mod = find_module(obj->name);
+	if (mod) {
+		pr_info("%s: %s -> %s\n", callback, obj->name,
+			module_state[mod->state]);
+	} else {
+		pr_err("%s: Unable to find module: %s", callback, obj->name);
+	}
+	mutex_unlock(&module_mutex);
 }
 
 /* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
+int sample_pre_patch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 	return pre_patch_ret;
 }
+EXPORT_SYMBOL(sample_pre_patch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
+void sample_post_patch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(sample_post_patch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
+void sample_pre_unpatch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
+EXPORT_SYMBOL(sample_pre_unpatch_callback);
 
 /* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
+void sample_post_unpatch_callback(struct klp_object *obj)
 {
 	callback_info(__func__, obj);
 }
-
-static void patched_work_func(struct work_struct *work)
-{
-	pr_info("%s\n", __func__);
-}
+EXPORT_SYMBOL(sample_post_unpatch_callback);
 
 static struct klp_func no_funcs[] = {
 	{ }
 };
 
-static struct klp_func busymod_funcs[] = {
-	{
-		.old_name = "busymod_work_func",
-		.new_func = patched_work_func,
-	}, { }
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = sample_pre_patch_callback,
+		.post_patch = sample_post_patch_callback,
+		.pre_unpatch = sample_pre_unpatch_callback,
+		.post_unpatch = sample_post_unpatch_callback,
+	},
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "livepatch_callbacks_mod",
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "livepatch_callbacks_busymod",
-		.funcs = busymod_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
+static char *obj_names[] = {
+	"livepatch_callbacks_mod",
+	"livepatch_callbacks_busymod",
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int livepatch_callbacks_demo_init(void)
diff --git a/samples/livepatch/livepatch-callbacks-demo.h b/samples/livepatch/livepatch-callbacks-demo.h
new file mode 100644
index 000000000000..42b0e92f2dda
--- /dev/null
+++ b/samples/livepatch/livepatch-callbacks-demo.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+#include <linux/livepatch.h>
+
+#define LIVEPATCH_NAME "livepatch_callbacks_demo"
+
+int sample_pre_patch_callback(struct klp_object *obj);
+void sample_post_patch_callback(struct klp_object *obj);
+void sample_pre_unpatch_callback(struct klp_object *obj);
+void sample_post_unpatch_callback(struct klp_object *obj);
diff --git a/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c
new file mode 100644
index 000000000000..8eb714ba59d1
--- /dev/null
+++ b/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
+ */
+
+/*
+ * livepatch-callbacks-demo.c - (un)patching callbacks livepatch demo
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include "livepatch-callbacks-demo.h"
+
+static void patched_work_func(struct work_struct *work)
+{
+	pr_info("%s\n", __func__);
+}
+
+static struct klp_func busymod_funcs[] = {
+	{
+		.old_name = "busymod_work_func",
+		.new_func = patched_work_func,
+	}, { }
+};
+
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = "livepatch_callbacks_busymod",
+	.mod = THIS_MODULE,
+	.funcs = busymod_funcs,
+	.callbacks = {
+		.pre_patch = sample_pre_patch_callback,
+		.post_patch = sample_post_patch_callback,
+		.pre_unpatch = sample_pre_unpatch_callback,
+		.post_unpatch = sample_post_unpatch_callback,
+	},
+};
+
+static int livepatch_callbacks_demo_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void livepatch_callbacks_demo_exit(void)
+{
+}
+
+module_init(livepatch_callbacks_demo_init);
+module_exit(livepatch_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c b/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c
new file mode 100644
index 000000000000..134fcf4bf69d
--- /dev/null
+++ b/samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
+ */
+
+/*
+ * livepatch-callbacks-demo.c - (un)patching callbacks livepatch demo
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include "livepatch-callbacks-demo.h"
+
+static struct klp_func no_funcs[] = {
+	{ }
+};
+
+static struct klp_object obj = {
+	.patch_name = LIVEPATCH_NAME,
+	.name = "livepatch_callbacks_mod",
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
+	.callbacks = {
+		.pre_patch = sample_pre_patch_callback,
+		.post_patch = sample_post_patch_callback,
+		.pre_unpatch = sample_pre_unpatch_callback,
+		.post_unpatch = sample_post_unpatch_callback,
+	},
+};
+
+static int livepatch_callbacks_demo_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void livepatch_callbacks_demo_exit(void)
+{
+}
+
+module_init(livepatch_callbacks_demo_init);
+module_exit(livepatch_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index cd76d7ebe598..94b74c05c4be 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -43,16 +43,20 @@ static struct klp_func funcs[] = {
 	}, { }
 };
 
-static struct klp_object objs[] = {
-	{
-		/* name being NULL means vmlinux */
-		.funcs = funcs,
-	}, { }
+static char *obj_names[] = {
+	NULL
 };
 
-static struct klp_patch patch = {
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
 	.mod = THIS_MODULE,
-	.objs = objs,
+	.funcs = funcs,
+};
+
+static struct klp_patch patch = {
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int livepatch_init(void)
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index e89ca4546114..62c3f89f26d1 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -27,120 +27,26 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
-#include <linux/slab.h>
 
-/* Shadow variable enums */
-#define SV_LEAK		1
-
-/* Allocate new dummies every second */
-#define ALLOC_PERIOD	1
-/* Check for expired dummies after a few new ones have been allocated */
-#define CLEANUP_PERIOD	(3 * ALLOC_PERIOD)
-/* Dummies expire after a few cleanup instances */
-#define EXPIRE_PERIOD	(4 * CLEANUP_PERIOD)
-
-struct dummy {
-	struct list_head list;
-	unsigned long jiffies_expire;
+static struct klp_func no_funcs[] = {
+	{}
 };
 
-/*
- * The constructor makes more sense together with klp_shadow_get_or_alloc().
- * In this example, it would be safe to assign the pointer also to the shadow
- * variable returned by klp_shadow_alloc().  But we wanted to show the more
- * complicated use of the API.
- */
-static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
-{
-	void **shadow_leak = shadow_data;
-	void *leak = ctor_data;
-
-	*shadow_leak = leak;
-	return 0;
-}
-
-static struct dummy *livepatch_fix1_dummy_alloc(void)
-{
-	struct dummy *d;
-	void *leak;
-
-	d = kzalloc(sizeof(*d), GFP_KERNEL);
-	if (!d)
-		return NULL;
-
-	d->jiffies_expire = jiffies +
-		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
-
-	/*
-	 * Patch: save the extra memory location into a SV_LEAK shadow
-	 * variable.  A patched dummy_free routine can later fetch this
-	 * pointer to handle resource release.
-	 */
-	leak = kzalloc(sizeof(int), GFP_KERNEL);
-	if (!leak) {
-		kfree(d);
-		return NULL;
-	}
-
-	klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
-			 shadow_leak_ctor, leak);
-
-	pr_info("%s: dummy @ %p, expires @ %lx\n",
-		__func__, d, d->jiffies_expire);
-
-	return d;
-}
-
-static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
-{
-	void *d = obj;
-	void **shadow_leak = shadow_data;
-
-	kfree(*shadow_leak);
-	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
-			 __func__, d, *shadow_leak);
-}
-
-static void livepatch_fix1_dummy_free(struct dummy *d)
-{
-	void **shadow_leak;
-
-	/*
-	 * Patch: fetch the saved SV_LEAK shadow variable, detach and
-	 * free it.  Note: handle cases where this shadow variable does
-	 * not exist (ie, dummy structures allocated before this livepatch
-	 * was loaded.)
-	 */
-	shadow_leak = klp_shadow_get(d, SV_LEAK);
-	if (shadow_leak)
-		klp_shadow_free(d, SV_LEAK, livepatch_fix1_dummy_leak_dtor);
-	else
-		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
-
-	kfree(d);
-}
-
-static struct klp_func funcs[] = {
-	{
-		.old_name = "dummy_alloc",
-		.new_func = livepatch_fix1_dummy_alloc,
-	},
-	{
-		.old_name = "dummy_free",
-		.new_func = livepatch_fix1_dummy_free,
-	}, { }
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = "livepatch_shadow_mod",
-		.funcs = funcs,
-	}, { }
+static char *obj_names[] = {
+	"livepatch_shadow_mod",
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int livepatch_shadow_fix1_init(void)
@@ -150,8 +56,6 @@ static int livepatch_shadow_fix1_init(void)
 
 static void livepatch_shadow_fix1_exit(void)
 {
-	/* Cleanup any existing SV_LEAK shadow variables */
-	klp_shadow_free_all(SV_LEAK, livepatch_fix1_dummy_leak_dtor);
 }
 
 module_init(livepatch_shadow_fix1_init);
diff --git a/samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c
new file mode 100644
index 000000000000..904bbc9ccfda
--- /dev/null
+++ b/samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
+ */
+
+/*
+ * livepatch-shadow-fix1.c - Shadow variables, livepatch demo
+ *
+ * Purpose
+ * -------
+ *
+ * Fixes the memory leak introduced in livepatch-shadow-mod through the
+ * use of a shadow variable.  This fix demonstrates the "extending" of
+ * short-lived data structures by patching its allocation and release
+ * functions.
+ *
+ *
+ * Usage
+ * -----
+ *
+ * This module is not intended to be standalone.  See the "Usage"
+ * section of livepatch-shadow-mod.c.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/slab.h>
+
+/* Shadow variable enums */
+#define SV_LEAK		1
+
+/* Allocate new dummies every second */
+#define ALLOC_PERIOD	1
+/* Check for expired dummies after a few new ones have been allocated */
+#define CLEANUP_PERIOD	(3 * ALLOC_PERIOD)
+/* Dummies expire after a few cleanup instances */
+#define EXPIRE_PERIOD	(4 * CLEANUP_PERIOD)
+
+struct dummy {
+	struct list_head list;
+	unsigned long jiffies_expire;
+};
+
+/*
+ * The constructor makes more sense together with klp_shadow_get_or_alloc().
+ * In this example, it would be safe to assign the pointer also to the shadow
+ * variable returned by klp_shadow_alloc().  But we wanted to show the more
+ * complicated use of the API.
+ */
+static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
+{
+	void **shadow_leak = shadow_data;
+	void *leak = ctor_data;
+
+	*shadow_leak = leak;
+	return 0;
+}
+
+static struct dummy *livepatch_fix1_dummy_alloc(void)
+{
+	struct dummy *d;
+	void *leak;
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return NULL;
+
+	d->jiffies_expire = jiffies +
+		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
+
+	/*
+	 * Patch: save the extra memory location into a SV_LEAK shadow
+	 * variable.  A patched dummy_free routine can later fetch this
+	 * pointer to handle resource release.
+	 */
+	leak = kzalloc(sizeof(int), GFP_KERNEL);
+	if (!leak) {
+		kfree(d);
+		return NULL;
+	}
+
+	klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
+			 shadow_leak_ctor, leak);
+
+	pr_info("%s: dummy @ %p, expires @ %lx\n",
+		__func__, d, d->jiffies_expire);
+
+	return d;
+}
+
+static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
+{
+	void *d = obj;
+	void **shadow_leak = shadow_data;
+
+	kfree(*shadow_leak);
+	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
+			 __func__, d, *shadow_leak);
+}
+
+static void livepatch_fix1_dummy_free(struct dummy *d)
+{
+	void **shadow_leak;
+
+	/*
+	 * Patch: fetch the saved SV_LEAK shadow variable, detach and
+	 * free it.  Note: handle cases where this shadow variable does
+	 * not exist (ie, dummy structures allocated before this livepatch
+	 * was loaded.)
+	 */
+	shadow_leak = klp_shadow_get(d, SV_LEAK);
+	if (shadow_leak)
+		klp_shadow_free(d, SV_LEAK, livepatch_fix1_dummy_leak_dtor);
+	else
+		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
+
+	kfree(d);
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "dummy_alloc",
+		.new_func = livepatch_fix1_dummy_alloc,
+	},
+	{
+		.old_name = "dummy_free",
+		.new_func = livepatch_fix1_dummy_free,
+	}, { }
+};
+
+static struct klp_object obj = {
+	.patch_name = "livepatch_shadow_fix1",
+	.name = "livepatch_shadow_mod",
+	.mod = THIS_MODULE,
+	.funcs = funcs,
+};
+
+static int livepatch_shadow_fix1_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void livepatch_shadow_fix1_exit(void)
+{
+	/* Cleanup any existing SV_LEAK shadow variables */
+	klp_shadow_free_all(SV_LEAK, livepatch_fix1_dummy_leak_dtor);
+}
+
+module_init(livepatch_shadow_fix1_init);
+module_exit(livepatch_shadow_fix1_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 50d223b82e8b..6f1359c002d5 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -27,92 +27,26 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
-#include <linux/slab.h>
 
-/* Shadow variable enums */
-#define SV_LEAK		1
-#define SV_COUNTER	2
-
-struct dummy {
-	struct list_head list;
-	unsigned long jiffies_expire;
+static struct klp_func no_funcs[] = {
+	{}
 };
 
-static bool livepatch_fix2_dummy_check(struct dummy *d, unsigned long jiffies)
-{
-	int *shadow_count;
-
-	/*
-	 * Patch: handle in-flight dummy structures, if they do not
-	 * already have a SV_COUNTER shadow variable, then attach a
-	 * new one.
-	 */
-	shadow_count = klp_shadow_get_or_alloc(d, SV_COUNTER,
-				sizeof(*shadow_count), GFP_NOWAIT,
-				NULL, NULL);
-	if (shadow_count)
-		*shadow_count += 1;
-
-	return time_after(jiffies, d->jiffies_expire);
-}
-
-static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
-{
-	void *d = obj;
-	void **shadow_leak = shadow_data;
-
-	kfree(*shadow_leak);
-	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
-			 __func__, d, *shadow_leak);
-}
-
-static void livepatch_fix2_dummy_free(struct dummy *d)
-{
-	void **shadow_leak;
-	int *shadow_count;
-
-	/* Patch: copy the memory leak patch from the fix1 module. */
-	shadow_leak = klp_shadow_get(d, SV_LEAK);
-	if (shadow_leak)
-		klp_shadow_free(d, SV_LEAK, livepatch_fix2_dummy_leak_dtor);
-	else
-		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
-
-	/*
-	 * Patch: fetch the SV_COUNTER shadow variable and display
-	 * the final count.  Detach the shadow variable.
-	 */
-	shadow_count = klp_shadow_get(d, SV_COUNTER);
-	if (shadow_count) {
-		pr_info("%s: dummy @ %p, check counter = %d\n",
-			__func__, d, *shadow_count);
-		klp_shadow_free(d, SV_COUNTER, NULL);
-	}
-
-	kfree(d);
-}
-
-static struct klp_func funcs[] = {
-	{
-		.old_name = "dummy_check",
-		.new_func = livepatch_fix2_dummy_check,
-	},
-	{
-		.old_name = "dummy_free",
-		.new_func = livepatch_fix2_dummy_free,
-	}, { }
+static struct klp_object obj = {
+	.patch_name = THIS_MODULE->name,
+	.name = NULL,	/* vmlinux */
+	.mod = THIS_MODULE,
+	.funcs = no_funcs,
 };
 
-static struct klp_object objs[] = {
-	{
-		.name = "livepatch_shadow_mod",
-		.funcs = funcs,
-	}, { }
+static char *obj_names[] = {
+	"livepatch_shadow_mod",
+	NULL
 };
 
 static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
+	.obj = &obj,
+	.obj_names = obj_names,
 };
 
 static int livepatch_shadow_fix2_init(void)
@@ -122,8 +56,6 @@ static int livepatch_shadow_fix2_init(void)
 
 static void livepatch_shadow_fix2_exit(void)
 {
-	/* Cleanup any existing SV_COUNTER shadow variables */
-	klp_shadow_free_all(SV_COUNTER, NULL);
 }
 
 module_init(livepatch_shadow_fix2_init);
diff --git a/samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c
new file mode 100644
index 000000000000..f4592b78d667
--- /dev/null
+++ b/samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
+ */
+
+/*
+ * livepatch-shadow-fix2.c - Shadow variables, livepatch demo
+ *
+ * Purpose
+ * -------
+ *
+ * Adds functionality to livepatch-shadow-mod's in-flight data
+ * structures through a shadow variable.  The livepatch patches a
+ * routine that periodically inspects data structures, incrementing a
+ * per-data-structure counter, creating the counter if needed.
+ *
+ *
+ * Usage
+ * -----
+ *
+ * This module is not intended to be standalone.  See the "Usage"
+ * section of livepatch-shadow-mod.c.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/slab.h>
+
+/* Shadow variable enums */
+#define SV_LEAK		1
+#define SV_COUNTER	2
+
+struct dummy {
+	struct list_head list;
+	unsigned long jiffies_expire;
+};
+
+static bool livepatch_fix2_dummy_check(struct dummy *d, unsigned long jiffies)
+{
+	int *shadow_count;
+
+	/*
+	 * Patch: handle in-flight dummy structures, if they do not
+	 * already have a SV_COUNTER shadow variable, then attach a
+	 * new one.
+	 */
+	shadow_count = klp_shadow_get_or_alloc(d, SV_COUNTER,
+				sizeof(*shadow_count), GFP_NOWAIT,
+				NULL, NULL);
+	if (shadow_count)
+		*shadow_count += 1;
+
+	return time_after(jiffies, d->jiffies_expire);
+}
+
+static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
+{
+	void *d = obj;
+	void **shadow_leak = shadow_data;
+
+	kfree(*shadow_leak);
+	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
+			 __func__, d, *shadow_leak);
+}
+
+static void livepatch_fix2_dummy_free(struct dummy *d)
+{
+	void **shadow_leak;
+	int *shadow_count;
+
+	/* Patch: copy the memory leak patch from the fix1 module. */
+	shadow_leak = klp_shadow_get(d, SV_LEAK);
+	if (shadow_leak)
+		klp_shadow_free(d, SV_LEAK, livepatch_fix2_dummy_leak_dtor);
+	else
+		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
+
+	/*
+	 * Patch: fetch the SV_COUNTER shadow variable and display
+	 * the final count.  Detach the shadow variable.
+	 */
+	shadow_count = klp_shadow_get(d, SV_COUNTER);
+	if (shadow_count) {
+		pr_info("%s: dummy @ %p, check counter = %d\n",
+			__func__, d, *shadow_count);
+		klp_shadow_free(d, SV_COUNTER, NULL);
+	}
+
+	kfree(d);
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "dummy_check",
+		.new_func = livepatch_fix2_dummy_check,
+	},
+	{
+		.old_name = "dummy_free",
+		.new_func = livepatch_fix2_dummy_free,
+	}, { }
+};
+
+static struct klp_object obj = {
+	.patch_name = "livepatch_shadow_fix2",
+	.name = "livepatch_shadow_mod",
+	.mod = THIS_MODULE,
+	.funcs = funcs,
+};
+
+static int livepatch_shadow_fix2_init(void)
+{
+	return klp_add_object(&obj);
+}
+
+static void livepatch_shadow_fix2_exit(void)
+{
+	/* Cleanup any existing SV_COUNTER shadow variables */
+	klp_shadow_free_all(SV_COUNTER, NULL);
+}
+
+module_init(livepatch_shadow_fix2_init);
+module_exit(livepatch_shadow_fix2_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index a35289b13c9c..ccaed35d0901 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -509,17 +509,17 @@ livepatch: '$MOD_LIVEPATCH': patching complete
 % modprobe $MOD_LIVEPATCH2
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_patch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: post_patch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_unpatch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: post_unpatch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
@@ -568,17 +568,17 @@ livepatch: '$MOD_LIVEPATCH': patching complete
 % modprobe $MOD_LIVEPATCH2 replace=1
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_patch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: post_patch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_unpatch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: post_unpatch_callback2: vmlinux
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2
 % rmmod $MOD_LIVEPATCH"
-- 
2.16.4

