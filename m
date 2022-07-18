Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFF1577AA8
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 07:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiGRFzB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 01:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiGRFzA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 01:55:00 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968BB10FD3
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:54:59 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26HNNNEX014698
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:54:58 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcs5khrk6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:54:58 -0700
Received: from twshared35153.14.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 17 Jul 2022 22:54:56 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id A7967A4C01E4; Sun, 17 Jul 2022 22:54:53 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v4 bpf-next 1/4] ftrace: add modify_ftrace_direct_multi_nolock
Date:   Sun, 17 Jul 2022 22:54:46 -0700
Message-ID: <20220718055449.3960512-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718055449.3960512-1-song@kernel.org>
References: <20220718055449.3960512-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VKacGcx6KPgjDLaUfAayBJeAxe7bJucV
X-Proofpoint-ORIG-GUID: VKacGcx6KPgjDLaUfAayBJeAxe7bJucV
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

This is similar to modify_ftrace_direct_multi, but does not acquire
direct_mutex. This is useful when direct_mutex is already locked by the
user.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/ftrace.h |  5 +++
 kernel/trace/ftrace.c  | 85 ++++++++++++++++++++++++++++++------------
 2 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 979f6bfa2c25..acb35243ce5d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -340,6 +340,7 @@ unsigned long ftrace_find_rec_direct(unsigned long ip);
 int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
 int unregister_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
 int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
+int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr);
 
 #else
 struct ftrace_ops;
@@ -384,6 +385,10 @@ static inline int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned lo
 {
 	return -ENODEV;
 }
+static inline int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 601ccf1b2f09..0c15ec997c13 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5691,22 +5691,8 @@ int unregister_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(unregister_ftrace_direct_multi);
 
-/**
- * modify_ftrace_direct_multi - Modify an existing direct 'multi' call
- * to call something else
- * @ops: The address of the struct ftrace_ops object
- * @addr: The address of the new trampoline to call at @ops functions
- *
- * This is used to unregister currently registered direct caller and
- * register new one @addr on functions registered in @ops object.
- *
- * Note there's window between ftrace_shutdown and ftrace_startup calls
- * where there will be no callbacks called.
- *
- * Returns: zero on success. Non zero on error, which includes:
- *  -EINVAL - The @ops object was not properly registered.
- */
-int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+static int
+__modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 {
 	struct ftrace_hash *hash;
 	struct ftrace_func_entry *entry, *iter;
@@ -5717,12 +5703,8 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 	int i, size;
 	int err;
 
-	if (check_direct_multi(ops))
+	if (WARN_ON_ONCE(!mutex_is_locked(&direct_mutex)))
 		return -EINVAL;
-	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
-		return -EINVAL;
-
-	mutex_lock(&direct_mutex);
 
 	/* Enable the tmp_ops to have the same functions as the direct ops */
 	ftrace_ops_init(&tmp_ops);
@@ -5730,7 +5712,7 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 
 	err = register_ftrace_function(&tmp_ops);
 	if (err)
-		goto out_direct;
+		return err;
 
 	/*
 	 * Now the ftrace_ops_list_func() is called to do the direct callers.
@@ -5754,7 +5736,64 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
- out_direct:
+	return err;
+}
+
+/**
+ * modify_ftrace_direct_multi_nolock - Modify an existing direct 'multi' call
+ * to call something else
+ * @ops: The address of the struct ftrace_ops object
+ * @addr: The address of the new trampoline to call at @ops functions
+ *
+ * This is used to unregister currently registered direct caller and
+ * register new one @addr on functions registered in @ops object.
+ *
+ * Note there's window between ftrace_shutdown and ftrace_startup calls
+ * where there will be no callbacks called.
+ *
+ * Caller should already have direct_mutex locked, so we don't lock
+ * direct_mutex here.
+ *
+ * Returns: zero on success. Non zero on error, which includes:
+ *  -EINVAL - The @ops object was not properly registered.
+ */
+int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
+{
+	if (check_direct_multi(ops))
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EINVAL;
+
+	return __modify_ftrace_direct_multi(ops, addr);
+}
+EXPORT_SYMBOL_GPL(modify_ftrace_direct_multi_nolock);
+
+/**
+ * modify_ftrace_direct_multi - Modify an existing direct 'multi' call
+ * to call something else
+ * @ops: The address of the struct ftrace_ops object
+ * @addr: The address of the new trampoline to call at @ops functions
+ *
+ * This is used to unregister currently registered direct caller and
+ * register new one @addr on functions registered in @ops object.
+ *
+ * Note there's window between ftrace_shutdown and ftrace_startup calls
+ * where there will be no callbacks called.
+ *
+ * Returns: zero on success. Non zero on error, which includes:
+ *  -EINVAL - The @ops object was not properly registered.
+ */
+int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	int err;
+
+	if (check_direct_multi(ops))
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+	err = __modify_ftrace_direct_multi(ops, addr);
 	mutex_unlock(&direct_mutex);
 	return err;
 }
-- 
2.30.2

