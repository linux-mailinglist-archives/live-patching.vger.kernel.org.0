Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A50D21DF7A
	for <lists+live-patching@lfdr.de>; Mon, 13 Jul 2020 20:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgGMSVf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Jul 2020 14:21:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:34586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgGMSVf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Jul 2020 14:21:35 -0400
IronPort-SDR: DDW5ykUjGJrxDzi+jQh27AB0pLKpcDBeQpkN+e8sfvL+Xf7ZvEvKvhB0PxD2Ka/1Zh0EEi2rBE
 OCPLbNTndL0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="213520086"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="213520086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 11:21:33 -0700
IronPort-SDR: gAeHmLmzdafsv77/MM1yhicrx3qvSADMhFRvI6YaIUkiJ277Bu+b4jzQv/KfPdrCtDL6Gpv5qO
 Dnqs+TVrmm/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="299283576"
Received: from bcope-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.223])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 11:21:26 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        live-patching@vger.kernel.org (open list:LIVE PATCHING)
Subject: [PATCH 2/3] module: Add lock_modules() and unlock_modules()
Date:   Mon, 13 Jul 2020 21:19:38 +0300
Message-Id: <20200713182030.1418041-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713182030.1418041-1-jarkko.sakkinen@linux.intel.com>
References: <20200713182030.1418041-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add wrappers to take the modules "big lock" in order to encapsulate
conditional compilation (CONFIG_MODULES) inside the wrapper.

Cc: Andi Kleen <ak@linux.intel.com>
Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/module.h      | 15 ++++++++++
 kernel/kprobes.c            |  4 +--
 kernel/livepatch/core.c     |  8 ++---
 kernel/module.c             | 60 ++++++++++++++++++-------------------
 kernel/trace/trace_kprobe.c |  4 +--
 5 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 2e6670860d27..857b84bf9e90 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -902,4 +902,19 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+#ifdef CONFIG_MODULES
+static inline void lock_modules(void)
+{
+	mutex_lock(&module_mutex);
+}
+
+static inline void unlock_modules(void)
+{
+	mutex_unlock(&module_mutex);
+}
+#else
+static inline void lock_modules(void) { }
+static inline void unlock_modules(void) { }
+#endif
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d1c354ec89de..bbe3423cb2b8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -564,7 +564,7 @@ static void kprobe_optimizer(struct work_struct *work)
 	cpus_read_lock();
 	mutex_lock(&text_mutex);
 	/* Lock modules while optimizing kprobes */
-	mutex_lock(&module_mutex);
+	lock_modules();
 
 	/*
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
@@ -589,7 +589,7 @@ static void kprobe_optimizer(struct work_struct *work)
 	/* Step 4: Free cleaned kprobes after quiesence period */
 	do_free_cleaned_kprobes();
 
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	mutex_unlock(&text_mutex);
 	cpus_read_unlock();
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f76fdb925532..d9d9d4973e6b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -57,7 +57,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	if (!klp_is_module(obj))
 		return;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	/*
 	 * We do not want to block removal of patched modules and therefore
 	 * we do not take a reference here. The patches are removed by
@@ -74,7 +74,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	if (mod && mod->klp_alive)
 		obj->mod = mod;
 
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 }
 
 static bool klp_initialized(void)
@@ -163,12 +163,12 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 		.pos = sympos,
 	};
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	if (objname)
 		module_kallsyms_on_each_symbol(klp_find_callback, &args);
 	else
 		kallsyms_on_each_symbol(klp_find_callback, &args);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
diff --git a/kernel/module.c b/kernel/module.c
index bdb3773f3668..3c7001cf754c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -895,7 +895,7 @@ static void module_unload_free(struct module *mod)
 {
 	struct module_use *use, *tmp;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
 		struct module *i = use->target;
 		pr_debug("%s unusing %s\n", mod->name, i->name);
@@ -904,7 +904,7 @@ static void module_unload_free(struct module *mod)
 		list_del(&use->target_list);
 		kfree(use);
 	}
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -1024,7 +1024,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	if (ret != 0)
 		goto out;
 
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	/* Final destruction now no one is using it. */
 	if (mod->exit != NULL)
 		mod->exit();
@@ -1043,7 +1043,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	wake_up_all(&module_wq);
 	return 0;
 out:
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	return ret;
 }
 
@@ -1448,7 +1448,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 	 * in the wait_event_interruptible(), which is harmless.
 	 */
 	sched_annotate_sleep();
-	mutex_lock(&module_mutex);
+	lock_modules();
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!sym)
@@ -1475,7 +1475,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 	/* We must make copy under the lock if we failed to get ref. */
 	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
 unlock:
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	return sym;
 }
 
@@ -1727,10 +1727,10 @@ static void del_usage_links(struct module *mod)
 #ifdef CONFIG_MODULE_UNLOAD
 	struct module_use *use;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	list_for_each_entry(use, &mod->target_list, target_list)
 		sysfs_remove_link(use->target->holders_dir, mod->name);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 #endif
 }
 
@@ -1740,14 +1740,14 @@ static int add_usage_links(struct module *mod)
 #ifdef CONFIG_MODULE_UNLOAD
 	struct module_use *use;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 	list_for_each_entry(use, &mod->target_list, target_list) {
 		ret = sysfs_create_link(use->target->holders_dir,
 					&mod->mkobj.kobj, mod->name);
 		if (ret)
 			break;
 	}
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	if (ret)
 		del_usage_links(mod);
 #endif
@@ -2158,9 +2158,9 @@ static void free_module(struct module *mod)
 
 	/* We leave it in list to prevent duplicate loads, but make sure
 	 * that noone uses it while it's being deconstructed. */
-	mutex_lock(&module_mutex);
+	lock_modules();
 	mod->state = MODULE_STATE_UNFORMED;
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
@@ -2178,7 +2178,7 @@ static void free_module(struct module *mod)
 		free_module_elf(mod);
 
 	/* Now we can delete it from the lists */
-	mutex_lock(&module_mutex);
+	lock_modules();
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	mod_tree_remove(mod);
@@ -2186,7 +2186,7 @@ static void free_module(struct module *mod)
 	module_bug_cleanup(mod);
 	/* Wait for RCU-sched synchronizing before releasing mod->list and buglist. */
 	synchronize_rcu();
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	/* This may be empty, but that's OK */
 	module_arch_freeing_init(mod);
@@ -3474,10 +3474,10 @@ static bool finished_loading(const char *name)
 	 * in the wait_event_interruptible(), which is harmless.
 	 */
 	sched_annotate_sleep();
-	mutex_lock(&module_mutex);
+	lock_modules();
 	mod = find_module_all(name, strlen(name), true);
 	ret = !mod || mod->state == MODULE_STATE_LIVE;
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	return ret;
 }
@@ -3589,7 +3589,7 @@ static noinline int do_init_module(struct module *mod)
 
 	ftrace_free_mem(mod, mod->init_layout.base, mod->init_layout.base +
 			mod->init_layout.size);
-	mutex_lock(&module_mutex);
+	lock_modules();
 	/* Drop initial reference. */
 	module_put(mod);
 	trim_init_extable(mod);
@@ -3621,7 +3621,7 @@ static noinline int do_init_module(struct module *mod)
 	if (llist_add(&freeinit->node, &init_free_list))
 		schedule_work(&init_free_wq);
 
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	wake_up_all(&module_wq);
 
 	return 0;
@@ -3663,12 +3663,12 @@ static int add_unformed_module(struct module *mod)
 	mod->state = MODULE_STATE_UNFORMED;
 
 again:
-	mutex_lock(&module_mutex);
+	lock_modules();
 	old = find_module_all(mod->name, strlen(mod->name), true);
 	if (old != NULL) {
 		if (old->state != MODULE_STATE_LIVE) {
 			/* Wait in case it fails to load. */
-			mutex_unlock(&module_mutex);
+			unlock_modules();
 			err = wait_event_interruptible(module_wq,
 					       finished_loading(mod->name));
 			if (err)
@@ -3684,7 +3684,7 @@ static int add_unformed_module(struct module *mod)
 	err = 0;
 
 out:
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 out_unlocked:
 	return err;
 }
@@ -3693,7 +3693,7 @@ static int complete_formation(struct module *mod, struct load_info *info)
 {
 	int err;
 
-	mutex_lock(&module_mutex);
+	lock_modules();
 
 	/* Find duplicate symbols (must be called under lock). */
 	err = verify_exported_symbols(mod);
@@ -3710,12 +3710,12 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
 	mod->state = MODULE_STATE_COMING;
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
 	return 0;
 
 out:
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	return err;
 }
 
@@ -3913,9 +3913,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	klp_module_going(mod);
  bug_cleanup:
 	/* module_bug_cleanup needs module_mutex protection */
-	mutex_lock(&module_mutex);
+	lock_modules();
 	module_bug_cleanup(mod);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 
  ddebug_cleanup:
 	ftrace_release_mod(mod);
@@ -3929,14 +3929,14 @@ static int load_module(struct load_info *info, const char __user *uargs,
  free_unload:
 	module_unload_free(mod);
  unlink_mod:
-	mutex_lock(&module_mutex);
+	lock_modules();
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	mod_tree_remove(mod);
 	wake_up_all(&module_wq);
 	/* Wait for RCU-sched synchronizing before releasing mod->list. */
 	synchronize_rcu();
-	mutex_unlock(&module_mutex);
+	unlock_modules();
  free_module:
 	/* Free lock-classes; relies on the preceding sync_rcu() */
 	lockdep_free_key_range(mod->core_layout.base, mod->core_layout.size);
@@ -4292,7 +4292,7 @@ static char *module_flags(struct module *mod, char *buf)
 /* Called by the /proc file system to return a list of modules. */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	mutex_lock(&module_mutex);
+	lock_modules();
 	return seq_list_start(&modules, *pos);
 }
 
@@ -4303,7 +4303,7 @@ static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 
 static void m_stop(struct seq_file *m, void *p)
 {
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 }
 
 static int m_show(struct seq_file *m, void *p)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aefb6065b508..710ec6a6aa8f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -122,9 +122,9 @@ static nokprobe_inline bool trace_kprobe_module_exist(struct trace_kprobe *tk)
 	if (!p)
 		return true;
 	*p = '\0';
-	mutex_lock(&module_mutex);
+	lock_modules();
 	ret = !!find_module(tk->symbol);
-	mutex_unlock(&module_mutex);
+	unlock_modules();
 	*p = ':';
 
 	return ret;
-- 
2.25.1

