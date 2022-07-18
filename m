Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C524E5778FA
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 02:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiGRAOg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Sun, 17 Jul 2022 20:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiGRAOe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 17 Jul 2022 20:14:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4345265FD
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 17:14:33 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26HMSfWu004954
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 17:14:32 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hbru7637y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 17:14:32 -0700
Received: from twshared0725.22.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 17 Jul 2022 17:14:30 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 4076DA495D14; Sun, 17 Jul 2022 17:14:24 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v3 bpf-next 4/4] bpf: support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)
Date:   Sun, 17 Jul 2022 17:14:05 -0700
Message-ID: <20220718001405.2236811-5-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718001405.2236811-1-song@kernel.org>
References: <20220718001405.2236811-1-song@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nJUs0vknhJaFmKwjm9Y3cenHJwPYuWn7
X-Proofpoint-ORIG-GUID: nJUs0vknhJaFmKwjm9Y3cenHJwPYuWn7
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_17,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When tracing a function with IPMODIFY ftrace_ops (livepatch), the bpf
trampoline must follow the instruction pointer saved on stack. This needs
extra handling for bpf trampolines with BPF_TRAMP_F_CALL_ORIG flag.

Implement bpf_tramp_ftrace_ops_func and use it for the ftrace_ops used
by BPF trampoline. This enables tracing functions with livepatch.

This also requires moving bpf trampoline to *_ftrace_direct_mult APIs.

Link: https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.org/
Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/bpf.h     |   8 ++
 kernel/bpf/trampoline.c | 158 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 149 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7496842a4671..f35c59e0b742 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -47,6 +47,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct ftrace_ops;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -756,6 +757,11 @@ struct btf_func_model {
  */
 #define BPF_TRAMP_F_ORIG_STACK		BIT(5)
 
+/* This trampoline is on a function with another ftrace_ops with IPMODIFY,
+ * e.g., a live patch. This flag is set and cleared by ftrace call backs,
+ */
+#define BPF_TRAMP_F_SHARE_IPMODIFY	BIT(6)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.
  */
@@ -838,9 +844,11 @@ struct bpf_tramp_image {
 struct bpf_trampoline {
 	/* hlist for trampoline_table */
 	struct hlist_node hlist;
+	struct ftrace_ops *fops;
 	/* serializes access to fields of this trampoline */
 	struct mutex mutex;
 	refcount_t refcnt;
+	u32 flags;
 	u64 key;
 	struct {
 		struct btf_func_model model;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index fd69812412ca..fa901aef7930 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -13,6 +13,7 @@
 #include <linux/static_call.h>
 #include <linux/bpf_verifier.h>
 #include <linux/bpf_lsm.h>
+#include <linux/delay.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -29,6 +30,81 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex);
+
+static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
+{
+	struct bpf_trampoline *tr = ops->private;
+	int ret = 0;
+
+	if (cmd == FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF) {
+		/* This is called inside register_ftrace_direct_multi(), so
+		 * tr->mutex is already locked.
+		 */
+		WARN_ON_ONCE(!mutex_is_locked(&tr->mutex));
+
+		/* Instead of updating the trampoline here, we propagate
+		 * -EAGAIN to register_ftrace_direct_multi(). Then we can
+		 * retry register_ftrace_direct_multi() after updating the
+		 * trampoline.
+		 */
+		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
+		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK)) {
+			if (WARN_ON_ONCE(tr->flags & BPF_TRAMP_F_SHARE_IPMODIFY))
+				return -EBUSY;
+
+			tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
+			return -EAGAIN;
+		}
+
+		return 0;
+	}
+
+	/* The normal locking order is
+	 *    tr->mutex => direct_mutex (ftrace.c) => ftrace_lock (ftrace.c)
+	 *
+	 * The following two commands are called from
+	 *
+	 *   prepare_direct_functions_for_ipmodify
+	 *   cleanup_direct_functions_after_ipmodify
+	 *
+	 * In both cases, direct_mutex is already locked. Use
+	 * mutex_trylock(&tr->mutex) to avoid deadlock in race condition
+	 * (something else is making changes to this same trampoline).
+	 */
+	if (!mutex_trylock(&tr->mutex)) {
+		/* sleep 1 ms to make sure whatever holding tr->mutex makes
+		 * some progress.
+		 */
+		msleep(1);
+		return -EAGAIN;
+	}
+
+	switch (cmd) {
+	case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER:
+		tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
+
+		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
+		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK))
+			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
+		break;
+	case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER:
+		tr->flags &= ~BPF_TRAMP_F_SHARE_IPMODIFY;
+
+		if (tr->flags & BPF_TRAMP_F_ORIG_STACK)
+			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	mutex_unlock(&tr->mutex);
+	return ret;
+}
+#endif
+
 bool bpf_prog_has_trampoline(const struct bpf_prog *prog)
 {
 	enum bpf_attach_type eatype = prog->expected_attach_type;
@@ -89,6 +165,16 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
 	if (!tr)
 		goto out;
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+	tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
+	if (!tr->fops) {
+		kfree(tr);
+		tr = NULL;
+		goto out;
+	}
+	tr->fops->private = tr;
+	tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
+#endif
 
 	tr->key = key;
 	INIT_HLIST_NODE(&tr->hlist);
@@ -128,7 +214,7 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 	int ret;
 
 	if (tr->func.ftrace_managed)
-		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
+		ret = unregister_ftrace_direct_multi(tr->fops, (long)old_addr);
 	else
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
 
@@ -137,15 +223,20 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 	return ret;
 }
 
-static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr)
+static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr,
+			 bool lock_direct_mutex)
 {
 	void *ip = tr->func.addr;
 	int ret;
 
-	if (tr->func.ftrace_managed)
-		ret = modify_ftrace_direct((long)ip, (long)old_addr, (long)new_addr);
-	else
+	if (tr->func.ftrace_managed) {
+		if (lock_direct_mutex)
+			ret = modify_ftrace_direct_multi(tr->fops, (long)new_addr);
+		else
+			ret = modify_ftrace_direct_multi_nolock(tr->fops, (long)new_addr);
+	} else {
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, new_addr);
+	}
 	return ret;
 }
 
@@ -163,10 +254,12 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 	if (bpf_trampoline_module_get(tr))
 		return -ENOENT;
 
-	if (tr->func.ftrace_managed)
-		ret = register_ftrace_direct((long)ip, (long)new_addr);
-	else
+	if (tr->func.ftrace_managed) {
+		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
+		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
+	} else {
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
+	}
 
 	if (ret)
 		bpf_trampoline_module_put(tr);
@@ -332,11 +425,11 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
 	return ERR_PTR(err);
 }
 
-static int bpf_trampoline_update(struct bpf_trampoline *tr)
+static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex)
 {
 	struct bpf_tramp_image *im;
 	struct bpf_tramp_links *tlinks;
-	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
+	u32 orig_flags = tr->flags;
 	bool ip_arg = false;
 	int err, total;
 
@@ -358,18 +451,31 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 		goto out;
 	}
 
+	/* clear all bits except SHARE_IPMODIFY */
+	tr->flags &= BPF_TRAMP_F_SHARE_IPMODIFY;
+
 	if (tlinks[BPF_TRAMP_FEXIT].nr_links ||
-	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links)
+	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links) {
 		/* NOTE: BPF_TRAMP_F_RESTORE_REGS and BPF_TRAMP_F_SKIP_FRAME
 		 * should not be set together.
 		 */
-		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+		tr->flags |= BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+	} else {
+		tr->flags |= BPF_TRAMP_F_RESTORE_REGS;
+	}
 
 	if (ip_arg)
-		flags |= BPF_TRAMP_F_IP_ARG;
+		tr->flags |= BPF_TRAMP_F_IP_ARG;
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+again:
+	if ((tr->flags & BPF_TRAMP_F_SHARE_IPMODIFY) &&
+	    (tr->flags & BPF_TRAMP_F_CALL_ORIG))
+		tr->flags |= BPF_TRAMP_F_ORIG_STACK;
+#endif
 
 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
-					  &tr->func.model, flags, tlinks,
+					  &tr->func.model, tr->flags, tlinks,
 					  tr->func.addr);
 	if (err < 0)
 		goto out;
@@ -378,17 +484,34 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	WARN_ON(!tr->cur_image && tr->selector);
 	if (tr->cur_image)
 		/* progs already running at this address */
-		err = modify_fentry(tr, tr->cur_image->image, im->image);
+		err = modify_fentry(tr, tr->cur_image->image, im->image, lock_direct_mutex);
 	else
 		/* first time registering */
 		err = register_fentry(tr, im->image);
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+	if (err == -EAGAIN) {
+		/* -EAGAIN from bpf_tramp_ftrace_ops_func. Now
+		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
+		 * trampoline again, and retry register.
+		 */
+		/* reset fops->func and fops->trampoline for re-register */
+		tr->fops->func = NULL;
+		tr->fops->trampoline = 0;
+		goto again;
+	}
+#endif
 	if (err)
 		goto out;
+
 	if (tr->cur_image)
 		bpf_tramp_image_put(tr->cur_image);
 	tr->cur_image = im;
 	tr->selector++;
 out:
+	/* If any error happens, restore previous flags */
+	if (err)
+		tr->flags = orig_flags;
 	kfree(tlinks);
 	return err;
 }
@@ -454,7 +577,7 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
 
 	hlist_add_head(&link->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
-	err = bpf_trampoline_update(tr);
+	err = bpf_trampoline_update(tr, true /* lock_direct_mutex */);
 	if (err) {
 		hlist_del_init(&link->tramp_hlist);
 		tr->progs_cnt[kind]--;
@@ -487,7 +610,7 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
 	}
 	hlist_del_init(&link->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	return bpf_trampoline_update(tr);
+	return bpf_trampoline_update(tr, true /* lock_direct_mutex */);
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
@@ -715,6 +838,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	 * multiple rcu callbacks.
 	 */
 	hlist_del(&tr->hlist);
+	kfree(tr->fops);
 	kfree(tr);
 out:
 	mutex_unlock(&trampoline_mutex);
-- 
2.30.2

