Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C94140D36
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAQPDp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:45434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgAQPDp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8C5BBB74;
        Fri, 17 Jan 2020 15:03:41 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 01/23] module: Allow to delete module also from inside kernel
Date:   Fri, 17 Jan 2020 16:03:01 +0100
Message-Id: <20200117150323.21801-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch subsystems will need to automatically load and delete
livepatch module when the livepatched one is being removed
or when the entire livepatch is being removed.

The code stopping the kernel module is moved to separate function
so that it can be reused.

The function always have rights to do the action. Also it does not
need to search for struct module because it is already passed as
a parameter.

On the other hand, it has to make sure that the given struct module
can't be released in parallel. It is achieved by combining module_put()
and module_delete() functionality in a single function.

This patch does not change the existing behavior of delete_module
syscall.

Signed-off-by: Petr Mladek <pmladek@suse.com>

module: Add module_put_and_delete()
---
 include/linux/module.h |   5 +++
 kernel/module.c        | 119 +++++++++++++++++++++++++++++++------------------
 2 files changed, 80 insertions(+), 44 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index bd165ba68617..f69f3fd72dd5 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -623,6 +623,7 @@ extern void __module_get(struct module *module);
 extern bool try_module_get(struct module *module);
 
 extern void module_put(struct module *module);
+extern int module_put_and_delete(struct module *mod);
 
 #else /*!CONFIG_MODULE_UNLOAD*/
 static inline bool try_module_get(struct module *module)
@@ -632,6 +633,10 @@ static inline bool try_module_get(struct module *module)
 static inline void module_put(struct module *module)
 {
 }
+static inline int module_put_and_delete(struct module *mod)
+{
+	return 0;
+}
 static inline void __module_get(struct module *module)
 {
 }
diff --git a/kernel/module.c b/kernel/module.c
index b56f3224b161..b3f11524f8f9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -964,62 +964,36 @@ EXPORT_SYMBOL(module_refcount);
 /* This exists whether we can unload or not */
 static void free_module(struct module *mod);
 
-SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
-		unsigned int, flags)
+int stop_module(struct module *mod, int flags)
 {
-	struct module *mod;
-	char name[MODULE_NAME_LEN];
-	int ret, forced = 0;
-
-	if (!capable(CAP_SYS_MODULE) || modules_disabled)
-		return -EPERM;
-
-	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
-		return -EFAULT;
-	name[MODULE_NAME_LEN-1] = '\0';
+	int forced = 0;
 
-	audit_log_kern_module(name);
-
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
-
-	mod = find_module(name);
-	if (!mod) {
-		ret = -ENOENT;
-		goto out;
-	}
-
-	if (!list_empty(&mod->source_list)) {
-		/* Other modules depend on us: get rid of them first. */
-		ret = -EWOULDBLOCK;
-		goto out;
-	}
+	/* Other modules depend on us: get rid of them first. */
+	if (!list_empty(&mod->source_list))
+		return -EWOULDBLOCK;
 
 	/* Doing init or already dying? */
 	if (mod->state != MODULE_STATE_LIVE) {
 		/* FIXME: if (force), slam module count damn the torpedoes */
 		pr_debug("%s already dying\n", mod->name);
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	/* If it has an init func, it must have an exit func to unload */
 	if (mod->init && !mod->exit) {
 		forced = try_force_unload(flags);
-		if (!forced) {
-			/* This module can't be removed */
-			ret = -EBUSY;
-			goto out;
-		}
+		/* This module can't be removed */
+		if (!forced)
+			return -EBUSY;
 	}
 
 	/* Stop the machine so refcounts can't move and disable module. */
-	ret = try_stop_module(mod, flags, &forced);
-	if (ret != 0)
-		goto out;
+	return try_stop_module(mod, flags, &forced);
+}
 
-	mutex_unlock(&module_mutex);
-	/* Final destruction now no one is using it. */
+/* Final destruction now no one is using it. */
+static void destruct_module(struct module *mod)
+{
 	if (mod->exit != NULL)
 		mod->exit();
 	blocking_notifier_call_chain(&module_notify_list,
@@ -1033,8 +1007,44 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 
 	free_module(mod);
+
 	/* someone could wait for the module in add_unformed_module() */
 	wake_up_all(&module_wq);
+}
+
+SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
+		unsigned int, flags)
+{
+	struct module *mod;
+	char name[MODULE_NAME_LEN];
+	int ret;
+
+	if (!capable(CAP_SYS_MODULE) || modules_disabled)
+		return -EPERM;
+
+	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
+		return -EFAULT;
+	name[MODULE_NAME_LEN-1] = '\0';
+
+	audit_log_kern_module(name);
+
+	if (mutex_lock_interruptible(&module_mutex) != 0)
+		return -EINTR;
+
+	mod = find_module(name);
+	if (!mod) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = stop_module(mod, flags);
+	if (ret)
+		goto out;
+
+	mutex_unlock(&module_mutex);
+
+/* Final destruction now no one is using it. */
+	destruct_module(mod);
 	return 0;
 out:
 	mutex_unlock(&module_mutex);
@@ -1138,20 +1148,41 @@ bool try_module_get(struct module *module)
 }
 EXPORT_SYMBOL(try_module_get);
 
-void module_put(struct module *module)
+/* Must be called under module_mutex or with preemtion disabled */
+static void __module_put(struct module* module)
 {
 	int ret;
 
+	ret = atomic_dec_if_positive(&module->refcnt);
+	WARN_ON(ret < 0);	/* Failed to put refcount */
+	trace_module_put(module, _RET_IP_);
+}
+
+void module_put(struct module *module)
+{
 	if (module) {
 		preempt_disable();
-		ret = atomic_dec_if_positive(&module->refcnt);
-		WARN_ON(ret < 0);	/* Failed to put refcount */
-		trace_module_put(module, _RET_IP_);
+		__module_put(module);
 		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(module_put);
 
+int module_put_and_delete(struct module *mod)
+{
+	int ret;
+	mutex_lock(&module_mutex);
+	__module_put(mod);
+	ret = stop_module(mod, 0);
+	mutex_unlock(&module_mutex);
+
+	if (ret)
+		return ret;
+
+	destruct_module(mod);
+	return 0;
+}
+
 #else /* !CONFIG_MODULE_UNLOAD */
 static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
-- 
2.16.4

