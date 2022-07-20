Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC69D57AAE9
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 02:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbiGTAVy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 20:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbiGTAVx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 20:21:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0F055082
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:52 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI5E0U031394
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdyj6b7sc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:52 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 17:21:49 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id F26C3A6298F5; Tue, 19 Jul 2022 17:21:41 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 2/4] ftrace: Allow IPMODIFY and DIRECT ops on the same function
Date:   Tue, 19 Jul 2022 17:21:24 -0700
Message-ID: <20220720002126.803253-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720002126.803253-1-song@kernel.org>
References: <20220720002126.803253-1-song@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: H01dwu3suP0K8Id7q5uSsQKMEh7qPJHe
X-Proofpoint-ORIG-GUID: H01dwu3suP0K8Id7q5uSsQKMEh7qPJHe
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

IPMODIFY (livepatch) and DIRECT (bpf trampoline) ops are both important
users of ftrace. It is necessary to allow them work on the same function
at the same time.

First, DIRECT ops no longer specify IPMODIFY flag. Instead, DIRECT flag is
handled together with IPMODIFY flag in __ftrace_hash_update_ipmodify().

Then, a callback function, ops_func, is added to ftrace_ops. This is used
by ftrace core code to understand whether the DIRECT ops can share with an
IPMODIFY ops. To share with IPMODIFY ops, the DIRECT ops need to implement
the callback function and adjust the direct trampoline accordingly.

If DIRECT ops is attached before the IPMODIFY ops, ftrace core code calls
ENABLE_SHARE_IPMODIFY_PEER on the DIRECT ops before registering the
IPMODIFY ops.

If IPMODIFY ops is attached before the DIRECT ops, ftrace core code calls
ENABLE_SHARE_IPMODIFY_SELF in __ftrace_hash_update_ipmodify. Owner of the
DIRECT ops may return 0 if the DIRECT trampoline can share with IPMODIFY,
so error code otherwise. The error code is propagated to
register_ftrace_direct_multi so that onwer of the DIRECT trampoline can
handle it properly.

For more details, please refer to comment before enum ftrace_ops_cmd.

Link: https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.org/
Link: https://lore.kernel.org/all/20220718055449.3960512-1-song@kernel.org/
Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/ftrace.h |  38 +++++++
 kernel/trace/ftrace.c  | 242 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 254 insertions(+), 26 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index acb35243ce5d..0b61371e287b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -208,6 +208,43 @@ enum {
 	FTRACE_OPS_FL_DIRECT			= BIT(17),
 };
 
+/*
+ * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request changes
+ * to a ftrace_ops. Note, the requests may fail.
+ *
+ * ENABLE_SHARE_IPMODIFY_SELF - enable a DIRECT ops to work on the same
+ *                              function as an ops with IPMODIFY. Called
+ *                              when the DIRECT ops is being registered.
+ *                              This is called with both direct_mutex and
+ *                              ftrace_lock are locked.
+ *
+ * ENABLE_SHARE_IPMODIFY_PEER - enable a DIRECT ops to work on the same
+ *                              function as an ops with IPMODIFY. Called
+ *                              when the other ops (the one with IPMODIFY)
+ *                              is being registered.
+ *                              This is called with direct_mutex locked.
+ *
+ * DISABLE_SHARE_IPMODIFY_PEER - disable a DIRECT ops to work on the same
+ *                               function as an ops with IPMODIFY. Called
+ *                               when the other ops (the one with IPMODIFY)
+ *                               is being unregistered.
+ *                               This is called with direct_mutex locked.
+ */
+enum ftrace_ops_cmd {
+	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF,
+	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER,
+	FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER,
+};
+
+/*
+ * For most ftrace_ops_cmd,
+ * Returns:
+ *        0 - Success.
+ *        Negative on failure. The return value is dependent on the
+ *        callback.
+ */
+typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* The hash used to know what functions callbacks trace */
 struct ftrace_ops_hash {
@@ -250,6 +287,7 @@ struct ftrace_ops {
 	unsigned long			trampoline;
 	unsigned long			trampoline_size;
 	struct list_head		list;
+	ftrace_ops_func_t		ops_func;
 #endif
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5d67dc12231d..bc921a3f7ea8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1861,6 +1861,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
 	ftrace_hash_rec_update_modify(ops, filter_hash, 1);
 }
 
+static bool ops_references_ip(struct ftrace_ops *ops, unsigned long ip);
+
 /*
  * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
  * or no-needed to update, -EBUSY if it detects a conflict of the flag
@@ -1869,6 +1871,13 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
  *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
  *  - If the hash is EMPTY_HASH, it hits nothing
  *  - Anything else hits the recs which match the hash entries.
+ *
+ * DIRECT ops does not have IPMODIFY flag, but we still need to check it
+ * against functions with FTRACE_FL_IPMODIFY. If there is any overlap, call
+ * ops_func(SHARE_IPMODIFY_SELF) to make sure current ops can share with
+ * IPMODIFY. If ops_func(SHARE_IPMODIFY_SELF) returns non-zero, propagate
+ * the return value to the caller and eventually to the owner of the DIRECT
+ * ops.
  */
 static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 					 struct ftrace_hash *old_hash,
@@ -1877,17 +1886,26 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec, *end = NULL;
 	int in_old, in_new;
+	bool is_ipmodify, is_direct;
 
 	/* Only update if the ops has been registered */
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return 0;
 
-	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+	is_ipmodify = ops->flags & FTRACE_OPS_FL_IPMODIFY;
+	is_direct = ops->flags & FTRACE_OPS_FL_DIRECT;
+
+	/* neither IPMODIFY nor DIRECT, skip */
+	if (!is_ipmodify && !is_direct)
+		return 0;
+
+	if (WARN_ON_ONCE(is_ipmodify && is_direct))
 		return 0;
 
 	/*
-	 * Since the IPMODIFY is a very address sensitive action, we do not
-	 * allow ftrace_ops to set all functions to new hash.
+	 * Since the IPMODIFY and DIRECT are very address sensitive
+	 * actions, we do not allow ftrace_ops to set all functions to new
+	 * hash.
 	 */
 	if (!new_hash || !old_hash)
 		return -EINVAL;
@@ -1905,12 +1923,32 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 			continue;
 
 		if (in_new) {
-			/* New entries must ensure no others are using it */
-			if (rec->flags & FTRACE_FL_IPMODIFY)
-				goto rollback;
-			rec->flags |= FTRACE_FL_IPMODIFY;
-		} else /* Removed entry */
+			if (rec->flags & FTRACE_FL_IPMODIFY) {
+				int ret;
+
+				/* Cannot have two ipmodify on same rec */
+				if (is_ipmodify)
+					goto rollback;
+
+				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);
+
+				/*
+				 * Another ops with IPMODIFY is already
+				 * attached. We are now attaching a direct
+				 * ops. Run SHARE_IPMODIFY_SELF, to check
+				 * whether sharing is supported.
+				 */
+				if (!ops->ops_func)
+					return -EBUSY;
+				ret = ops->ops_func(ops, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF);
+				if (ret)
+					return ret;
+			} else if (is_ipmodify) {
+				rec->flags |= FTRACE_FL_IPMODIFY;
+			}
+		} else if (is_ipmodify) {
 			rec->flags &= ~FTRACE_FL_IPMODIFY;
+		}
 	} while_for_each_ftrace_rec();
 
 	return 0;
@@ -2454,8 +2492,7 @@ static void call_direct_funcs(unsigned long ip, unsigned long pip,
 
 struct ftrace_ops direct_ops = {
 	.func		= call_direct_funcs,
-	.flags		= FTRACE_OPS_FL_IPMODIFY
-			  | FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
+	.flags		= FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
 			  | FTRACE_OPS_FL_PERMANENT,
 	/*
 	 * By declaring the main trampoline as this trampoline
@@ -3072,14 +3109,14 @@ static inline int ops_traces_mod(struct ftrace_ops *ops)
 }
 
 /*
- * Check if the current ops references the record.
+ * Check if the current ops references the given ip.
  *
  * If the ops traces all functions, then it was already accounted for.
  * If the ops does not trace the current record function, skip it.
  * If the ops ignores the function via notrace filter, skip it.
  */
-static inline bool
-ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+static bool
+ops_references_ip(struct ftrace_ops *ops, unsigned long ip)
 {
 	/* If ops isn't enabled, ignore it */
 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
@@ -3091,16 +3128,29 @@ ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
 
 	/* The function must be in the filter */
 	if (!ftrace_hash_empty(ops->func_hash->filter_hash) &&
-	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, rec->ip))
+	    !__ftrace_lookup_ip(ops->func_hash->filter_hash, ip))
 		return false;
 
 	/* If in notrace hash, we ignore it too */
-	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, rec->ip))
+	if (ftrace_lookup_ip(ops->func_hash->notrace_hash, ip))
 		return false;
 
 	return true;
 }
 
+/*
+ * Check if the current ops references the record.
+ *
+ * If the ops traces all functions, then it was already accounted for.
+ * If the ops does not trace the current record function, skip it.
+ * If the ops ignores the function via notrace filter, skip it.
+ */
+static bool
+ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	return ops_references_ip(ops, rec->ip);
+}
+
 static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 {
 	bool init_nop = ftrace_need_init_nop();
@@ -5215,6 +5265,8 @@ static struct ftrace_direct_func *ftrace_alloc_direct_func(unsigned long addr)
 	return direct;
 }
 
+static int register_ftrace_function_nolock(struct ftrace_ops *ops);
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * @ip: The address of the nop at the beginning of a function
@@ -5286,7 +5338,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
 
 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
-		ret = register_ftrace_function(&direct_ops);
+		ret = register_ftrace_function_nolock(&direct_ops);
 		if (ret)
 			ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
 	}
@@ -5545,8 +5597,7 @@ int modify_ftrace_direct(unsigned long ip,
 }
 EXPORT_SYMBOL_GPL(modify_ftrace_direct);
 
-#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
-		     FTRACE_OPS_FL_SAVE_REGS)
+#define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)
 
 static int check_direct_multi(struct ftrace_ops *ops)
 {
@@ -5639,7 +5690,7 @@ int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 	ops->flags = MULTI_FLAGS;
 	ops->trampoline = FTRACE_REGS_ADDR;
 
-	err = register_ftrace_function(ops);
+	err = register_ftrace_function_nolock(ops);
 
  out_remove:
 	if (err)
@@ -5709,7 +5760,7 @@ __modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 	ftrace_ops_init(&tmp_ops);
 	tmp_ops.func_hash = ops->func_hash;
 
-	err = register_ftrace_function(&tmp_ops);
+	err = register_ftrace_function_nolock(&tmp_ops);
 	if (err)
 		return err;
 
@@ -8003,6 +8054,143 @@ int ftrace_is_dead(void)
 	return ftrace_disabled;
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+/*
+ * When registering ftrace_ops with IPMODIFY, it is necessary to make sure
+ * it doesn't conflict with any direct ftrace_ops. If there is existing
+ * direct ftrace_ops on a kernel function being patched, call
+ * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER on it to enable sharing.
+ *
+ * @ops:     ftrace_ops being registered.
+ *
+ * Returns:
+ *         0 on success;
+ *         Negative on failure.
+ */
+static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *hash;
+	struct ftrace_ops *op;
+	int size, i, ret;
+
+	lockdep_assert_held_once(&direct_mutex);
+
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return 0;
+
+	hash = ops->func_hash->filter_hash;
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			unsigned long ip = entry->ip;
+			bool found_op = false;
+
+			mutex_lock(&ftrace_lock);
+			do_for_each_ftrace_op(op, ftrace_ops_list) {
+				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
+					continue;
+				if (ops_references_ip(op, ip)) {
+					found_op = true;
+					break;
+				}
+			} while_for_each_ftrace_op(op);
+			mutex_unlock(&ftrace_lock);
+
+			if (found_op) {
+				if (!op->ops_func)
+					return -EBUSY;
+
+				ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Similar to prepare_direct_functions_for_ipmodify, clean up after ops
+ * with IPMODIFY is unregistered. The cleanup is optional for most DIRECT
+ * ops.
+ */
+static void cleanup_direct_functions_after_ipmodify(struct ftrace_ops *ops)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *hash;
+	struct ftrace_ops *op;
+	int size, i;
+
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return;
+
+	mutex_lock(&direct_mutex);
+
+	hash = ops->func_hash->filter_hash;
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			unsigned long ip = entry->ip;
+			bool found_op = false;
+
+			mutex_lock(&ftrace_lock);
+			do_for_each_ftrace_op(op, ftrace_ops_list) {
+				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
+					continue;
+				if (ops_references_ip(op, ip)) {
+					found_op = true;
+					break;
+				}
+			} while_for_each_ftrace_op(op);
+			mutex_unlock(&ftrace_lock);
+
+			/* The cleanup is optional, ignore any errors */
+			if (found_op && op->ops_func)
+				op->ops_func(op, FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER);
+		}
+	}
+	mutex_unlock(&direct_mutex);
+}
+
+#define lock_direct_mutex()	mutex_lock(&direct_mutex)
+#define unlock_direct_mutex()	mutex_unlock(&direct_mutex)
+
+#else  /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
+
+static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
+{
+	return 0;
+}
+
+static void cleanup_direct_functions_after_ipmodify(struct ftrace_ops *ops)
+{
+}
+
+#define lock_direct_mutex()	do { } while (0)
+#define unlock_direct_mutex()	do { } while (0)
+
+#endif  /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
+
+/*
+ * Similar to register_ftrace_function, except we don't lock direct_mutex.
+ */
+static int register_ftrace_function_nolock(struct ftrace_ops *ops)
+{
+	int ret;
+
+	ftrace_ops_init(ops);
+
+	mutex_lock(&ftrace_lock);
+
+	ret = ftrace_startup(ops, 0);
+
+	mutex_unlock(&ftrace_lock);
+
+	return ret;
+}
+
 /**
  * register_ftrace_function - register a function for profiling
  * @ops:	ops structure that holds the function for profiling.
@@ -8018,14 +8206,15 @@ int register_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
 
-	ftrace_ops_init(ops);
-
-	mutex_lock(&ftrace_lock);
-
-	ret = ftrace_startup(ops, 0);
+	lock_direct_mutex();
+	ret = prepare_direct_functions_for_ipmodify(ops);
+	if (ret < 0)
+		goto out_unlock;
 
-	mutex_unlock(&ftrace_lock);
+	ret = register_ftrace_function_nolock(ops);
 
+out_unlock:
+	unlock_direct_mutex();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_function);
@@ -8044,6 +8233,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 	ret = ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
+	cleanup_direct_functions_after_ipmodify(ops);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_ftrace_function);
-- 
2.30.2

