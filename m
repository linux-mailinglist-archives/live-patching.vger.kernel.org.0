Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29870577AB4
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 07:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiGRFzN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 01:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiGRFzL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 01:55:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA1913F3A
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:09 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26I2cCoF026860
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:09 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcm64asqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:08 -0700
Received: from twshared35153.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 17 Jul 2022 22:55:07 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 6EABEA4C01F7; Sun, 17 Jul 2022 22:54:55 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on the same function
Date:   Sun, 17 Jul 2022 22:54:47 -0700
Message-ID: <20220718055449.3960512-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718055449.3960512-1-song@kernel.org>
References: <20220718055449.3960512-1-song@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 8Vcj0MZkNTYX1_scZB7-gDS9plzSp9LI
X-Proofpoint-GUID: 8Vcj0MZkNTYX1_scZB7-gDS9plzSp9LI
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_04,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
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

The, a callback function, ops_func, is added to ftrace_ops. This is used
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
Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/ftrace.h |  38 +++++++
 kernel/trace/ftrace.c  | 221 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 243 insertions(+), 16 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index acb35243ce5d..306bf08acda6 100644
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
+ *        -EBUSY - The operation cannot process
+ *        -EAGAIN - The operation cannot process tempoorarily.
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
index 0c15ec997c13..f52efbd13e51 100644
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
@@ -1877,17 +1886,23 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
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
+	/* either IPMODIFY nor DIRECT, skip */
+	if (!is_ipmodify && !is_direct)
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
@@ -1905,12 +1920,30 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
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
@@ -2455,7 +2488,7 @@ static void call_direct_funcs(unsigned long ip, unsigned long pip,
 struct ftrace_ops direct_ops = {
 	.func		= call_direct_funcs,
 	.flags		= FTRACE_OPS_FL_IPMODIFY
-			  | FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS
+			  | FTRACE_OPS_FL_SAVE_REGS
 			  | FTRACE_OPS_FL_PERMANENT,
 	/*
 	 * By declaring the main trampoline as this trampoline
@@ -3072,14 +3105,14 @@ static inline int ops_traces_mod(struct ftrace_ops *ops)
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
@@ -3091,16 +3124,29 @@ ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
 
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
@@ -5545,8 +5591,7 @@ int modify_ftrace_direct(unsigned long ip,
 }
 EXPORT_SYMBOL_GPL(modify_ftrace_direct);
 
-#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
-		     FTRACE_OPS_FL_SAVE_REGS)
+#define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)
 
 static int check_direct_multi(struct ftrace_ops *ops)
 {
@@ -8004,6 +8049,137 @@ int ftrace_is_dead(void)
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
+ *         0 - @ops does not have IPMODIFY or @ops itself is DIRECT, no
+ *             change needed;
+ *         1 - @ops has IPMODIFY, hold direct_mutex;
+ *         -EBUSY - currently registered DIRECT ftrace_ops cannot share the
+ *                  same function with IPMODIFY, abort the register.
+ *         -EAGAIN - cannot make changes to currently registered DIRECT
+ *                   ftrace_ops due to rare race conditions. Should retry
+ *                   later. This is needed to avoid potential deadlocks
+ *                   on the DIRECT ftrace_ops side.
+ */
+static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
+	__acquires(&direct_mutex)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *hash;
+	struct ftrace_ops *op;
+	int size, i, ret;
+
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return 0;
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
+			if (found_op) {
+				if (!op->ops_func) {
+					ret = -EBUSY;
+					goto err_out;
+				}
+				ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
+				if (ret)
+					goto err_out;
+			}
+		}
+	}
+
+	/*
+	 * Didn't find any overlap with direct ftrace_ops, or the direct
+	 * function can share with ipmodify. Hold direct_mutex to make sure
+	 * this doesn't change until we are done.
+	 */
+	return 1;
+
+err_out:
+	mutex_unlock(&direct_mutex);
+	return ret;
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
+			/* The cleanup is optional, iggore any errors */
+			if (found_op && op->ops_func)
+				op->ops_func(op, FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER);
+		}
+	}
+	mutex_unlock(&direct_mutex);
+}
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
+#endif  /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
+
 /**
  * register_ftrace_function - register a function for profiling
  * @ops:	ops structure that holds the function for profiling.
@@ -8016,17 +8192,29 @@ int ftrace_is_dead(void)
  *       recursive loop.
  */
 int register_ftrace_function(struct ftrace_ops *ops)
+	__releases(&direct_mutex)
 {
+	bool direct_mutex_locked = false;
 	int ret;
 
 	ftrace_ops_init(ops);
 
+	ret = prepare_direct_functions_for_ipmodify(ops);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		direct_mutex_locked = true;
+
 	mutex_lock(&ftrace_lock);
 
 	ret = ftrace_startup(ops, 0);
 
 	mutex_unlock(&ftrace_lock);
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+	if (direct_mutex_locked)
+		mutex_unlock(&direct_mutex);
+#endif
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_function);
@@ -8045,6 +8233,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 	ret = ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
+	cleanup_direct_functions_after_ipmodify(ops);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_ftrace_function);
-- 
2.30.2

