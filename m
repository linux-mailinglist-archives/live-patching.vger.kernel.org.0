Return-Path: <live-patching+bounces-2351-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SD9VDwg432nAQQAAu9opvQ
	(envelope-from <live-patching+bounces-2351-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 09:02:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDEC4012AC
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 09:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5390F309292A
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 07:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BF639B977;
	Wed, 15 Apr 2026 07:01:51 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C07C39A06D;
	Wed, 15 Apr 2026 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236510; cv=none; b=bmy/PY1sXYxe2D+CCV6zxmmvYnh7PULD6Sh6fKwarZfQPDer8xz5JfncB1cPtgkZFIGhCZv2JgqZLr9q3+9IoyThpHsL/RRhhbexwSSRAiJ9t0khljD7+HQThCRvCldD4YDcO69vBtTFQIR3M7yL+1AIG+2pjuKH7+/4VzD6E6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236510; c=relaxed/simple;
	bh=BdXFa86tEq+gELj7r9l68qLIBxrEun2ypMTFapr2S8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OqawEpVKANJjF6MKeLGw1QzzZLgA1CX9XfMHR/op1Iibn/qv6DiZXs8fRybFlguCBuPVicNr3dLJyoztgcJDh/GDb3DdAR9dxXDJRToXp1ny76PY4nSMy3ZNaxFPgOknOxhsOP2QfYiQAvmZPfD4qL1xUOoMEFKArA0wFUr8nRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.242.145:0.1634015706
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-60.27.227.144 (unknown [10.158.242.145])
	by mail.189.cn (HERMES) with SMTP id 169D940029D;
	Wed, 15 Apr 2026 15:01:40 +0800 (CST)
Received: from  ([60.27.227.144])
	by gateway-153622-dep-76cc7bc9cd-r45x9 with ESMTP id 8223a8ac66f64c7cbbfe1057b1437054 for rafael@kernel.org;
	Wed, 15 Apr 2026 15:01:43 CST
X-Transaction-ID: 8223a8ac66f64c7cbbfe1057b1437054
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 60.27.227.144
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From: chensong_2000@189.cn
To: rafael@kernel.org,
	lenb@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	viresh.kumar@linaro.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	jason.wessel@windriver.com,
	danielt@kernel.org,
	dianders@chromium.org,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	atomlin@atomlin.com,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org,
	Song Chen <chensong_2000@189.cn>
Subject: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with double-linked list for reverse traversal
Date: Wed, 15 Apr 2026 15:01:37 +0800
Message-ID: <20260415070137.17860-1-chensong_2000@189.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2351-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[189.cn];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[189.cn];
	RCPT_COUNT_TWELVE(0.00)[48];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,lists.sourceforge.net,189.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@189.cn,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.940];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fhfr.pm:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,189.cn:mid,189.cn:email]
X-Rspamd-Queue-Id: BDDEC4012AC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Song Chen <chensong_2000@189.cn>

The current notifier chain implementation uses a single-linked list
(struct notifier_block *next), which only supports forward traversal
in priority order. This makes it difficult to handle cleanup/teardown
scenarios that require notifiers to be called in reverse priority order.

A concrete example is the ordering dependency between ftrace and
livepatch during module load/unload. see the detail here [1].

This patch replaces the single-linked list in struct notifier_block
with a struct list_head, converting the notifier chain into a
doubly-linked list sorted in descending priority order. Based on
this, a new function notifier_call_chain_reverse() is introduced,
which traverses the chain in reverse (ascending priority order).
The corresponding blocking_notifier_call_chain_reverse() is also
added as the locking wrapper for blocking notifier chains.

The internal notifier_call_chain_robust() is updated to use
notifier_call_chain_reverse() for rollback: on error, it records
the failing notifier (last_nb) and the count of successfully called
notifiers (nr), then rolls back exactly those nr-1 notifiers in
reverse order starting from last_nb's predecessor, without needing
to know the total length of the chain.

With this change, subsystems with symmetric setup/teardown ordering
requirements can register a single notifier_block with one priority
value, and rely on blocking_notifier_call_chain() for forward
traversal and blocking_notifier_call_chain_reverse() for reverse
traversal, without needing hard-coded call sequences or separate
notifier registrations for each direction.

[1]:https://lore.kernel.org/all
	/alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/

Signed-off-by: Song Chen <chensong_2000@189.cn>
---
 drivers/acpi/sleep.c      |   1 -
 drivers/clk/clk.c         |   2 +-
 drivers/cpufreq/cpufreq.c |   2 +-
 drivers/md/dm-integrity.c |   1 -
 drivers/md/md.c           |   1 -
 include/linux/notifier.h  |  26 ++---
 kernel/debug/debug_core.c |   1 -
 kernel/notifier.c         | 219 ++++++++++++++++++++++++++++++++------
 net/ipv4/nexthop.c        |   2 +-
 9 files changed, 201 insertions(+), 54 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 132a9df98471..b776dbd5a382 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -56,7 +56,6 @@ static int tts_notify_reboot(struct notifier_block *this,
 
 static struct notifier_block tts_notifier = {
 	.notifier_call	= tts_notify_reboot,
-	.next		= NULL,
 	.priority	= 0,
 };
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 47093cda9df3..b6fe380d0468 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4862,7 +4862,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 			clk->core->notifier_count--;
 
 			/* XXX the notifier code should handle this better */
-			if (!cn->notifier_head.head) {
+			if (list_empty(&cn->notifier_head.head)) {
 				srcu_cleanup_notifier_head(&cn->notifier_head);
 				list_del(&cn->node);
 				kfree(cn);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 277884d91913..12637e742ffa 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -445,7 +445,7 @@ static void cpufreq_list_transition_notifiers(void)
 
 	mutex_lock(&cpufreq_transition_notifier_list.mutex);
 
-	for (nb = cpufreq_transition_notifier_list.head; nb; nb = nb->next)
+	list_for_each_entry(nb, &cpufreq_transition_notifier_list.head, entry)
 		pr_info("%pS\n", nb->notifier_call);
 
 	mutex_unlock(&cpufreq_transition_notifier_list.mutex);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 06e805902151..ccdf75c40b62 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3909,7 +3909,6 @@ static void dm_integrity_resume(struct dm_target *ti)
 	}
 
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
-	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
 	WARN_ON(register_reboot_notifier(&ic->reboot_notifier));
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..8249e78636ab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10480,7 +10480,6 @@ static int md_notify_reboot(struct notifier_block *this,
 
 static struct notifier_block md_notifier = {
 	.notifier_call	= md_notify_reboot,
-	.next		= NULL,
 	.priority	= INT_MAX, /* before any real devices */
 };
 
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 01b6c9d9956f..b2abbdfcaadd 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -53,41 +53,41 @@ typedef	int (*notifier_fn_t)(struct notifier_block *nb,
 
 struct notifier_block {
 	notifier_fn_t notifier_call;
-	struct notifier_block __rcu *next;
+	struct list_head __rcu entry;
 	int priority;
 };
 
 struct atomic_notifier_head {
 	spinlock_t lock;
-	struct notifier_block __rcu *head;
+	struct list_head __rcu head;
 };
 
 struct blocking_notifier_head {
 	struct rw_semaphore rwsem;
-	struct notifier_block __rcu *head;
+	struct list_head __rcu head;
 };
 
 struct raw_notifier_head {
-	struct notifier_block __rcu *head;
+	struct list_head __rcu head;
 };
 
 struct srcu_notifier_head {
 	struct mutex mutex;
 	struct srcu_usage srcuu;
 	struct srcu_struct srcu;
-	struct notifier_block __rcu *head;
+	struct list_head __rcu head;
 };
 
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
 		spin_lock_init(&(name)->lock);	\
-		(name)->head = NULL;		\
+		INIT_LIST_HEAD(&(name)->head);		\
 	} while (0)
 #define BLOCKING_INIT_NOTIFIER_HEAD(name) do {	\
 		init_rwsem(&(name)->rwsem);	\
-		(name)->head = NULL;		\
+		INIT_LIST_HEAD(&(name)->head);		\
 	} while (0)
 #define RAW_INIT_NOTIFIER_HEAD(name) do {	\
-		(name)->head = NULL;		\
+		INIT_LIST_HEAD(&(name)->head);		\
 	} while (0)
 
 /* srcu_notifier_heads must be cleaned up dynamically */
@@ -97,17 +97,17 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 
 #define ATOMIC_NOTIFIER_INIT(name) {				\
 		.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
-		.head = NULL }
+		.head = LIST_HEAD_INIT((name).head) }
 #define BLOCKING_NOTIFIER_INIT(name) {				\
 		.rwsem = __RWSEM_INITIALIZER((name).rwsem),	\
-		.head = NULL }
+		.head = LIST_HEAD_INIT((name).head) }
 #define RAW_NOTIFIER_INIT(name)	{				\
-		.head = NULL }
+		.head = LIST_HEAD_INIT((name).head) }
 
 #define SRCU_NOTIFIER_INIT(name, pcpu)				\
 	{							\
 		.mutex = __MUTEX_INITIALIZER(name.mutex),	\
-		.head = NULL,					\
+		.head = LIST_HEAD_INIT((name).head),					\
 		.srcuu = __SRCU_USAGE_INIT(name.srcuu),		\
 		.srcu = __SRCU_STRUCT_INIT(name.srcu, name.srcuu, pcpu, 0), \
 	}
@@ -170,6 +170,8 @@ extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 		unsigned long val, void *v);
 extern int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v);
+extern int blocking_notifier_call_chain_reverse(struct blocking_notifier_head *nh,
+		unsigned long val, void *v);
 extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0b9495187fba..a26a7683d142 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1054,7 +1054,6 @@ dbg_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
 
 static struct notifier_block dbg_reboot_notifier = {
 	.notifier_call		= dbg_notify_reboot,
-	.next			= NULL,
 	.priority		= INT_MAX,
 };
 
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2f9fe7c30287..6f4d887771c4 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -14,39 +14,47 @@
  *	are layered on top of these, with appropriate locking added.
  */
 
-static int notifier_chain_register(struct notifier_block **nl,
+static int notifier_chain_register(struct list_head *nl,
 				   struct notifier_block *n,
 				   bool unique_priority)
 {
-	while ((*nl) != NULL) {
-		if (unlikely((*nl) == n)) {
+	struct notifier_block *cur;
+
+	list_for_each_entry(cur, nl, entry) {
+		if (unlikely(cur == n)) {
 			WARN(1, "notifier callback %ps already registered",
 			     n->notifier_call);
 			return -EEXIST;
 		}
-		if (n->priority > (*nl)->priority)
-			break;
-		if (n->priority == (*nl)->priority && unique_priority)
+
+		if (n->priority == cur->priority && unique_priority)
 			return -EBUSY;
-		nl = &((*nl)->next);
+
+		if (n->priority > cur->priority) {
+			list_add_tail(&n->entry, &cur->entry);
+			goto out;
+		}
 	}
-	n->next = *nl;
-	rcu_assign_pointer(*nl, n);
+
+	list_add_tail(&n->entry, nl);
+out:
 	trace_notifier_register((void *)n->notifier_call);
 	return 0;
 }
 
-static int notifier_chain_unregister(struct notifier_block **nl,
+static int notifier_chain_unregister(struct list_head *nl,
 		struct notifier_block *n)
 {
-	while ((*nl) != NULL) {
-		if ((*nl) == n) {
-			rcu_assign_pointer(*nl, n->next);
+	struct notifier_block *cur;
+
+	list_for_each_entry(cur, nl, entry) {
+		if (cur == n) {
+			list_del(&n->entry);
 			trace_notifier_unregister((void *)n->notifier_call);
 			return 0;
 		}
-		nl = &((*nl)->next);
 	}
+
 	return -ENOENT;
 }
 
@@ -59,25 +67,25 @@ static int notifier_chain_unregister(struct notifier_block **nl,
  *			value of this parameter is -1.
  *	@nr_calls:	Records the number of notifications sent. Don't care
  *			value of this field is NULL.
+ *	@last_nb:  Records the last called notifier block for rolling back
  *	Return:		notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
-static int notifier_call_chain(struct notifier_block **nl,
+static int notifier_call_chain(struct list_head *nl,
 			       unsigned long val, void *v,
-			       int nr_to_call, int *nr_calls)
+			       int nr_to_call, int *nr_calls,
+				   struct notifier_block **last_nb)
 {
 	int ret = NOTIFY_DONE;
-	struct notifier_block *nb, *next_nb;
-
-	nb = rcu_dereference_raw(*nl);
+	struct notifier_block *nb;
 
-	while (nb && nr_to_call) {
-		next_nb = rcu_dereference_raw(nb->next);
+	if (!nr_to_call)
+		return ret;
 
+	list_for_each_entry(nb, nl, entry) {
 #ifdef CONFIG_DEBUG_NOTIFIERS
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
 			WARN(1, "Invalid notifier called!");
-			nb = next_nb;
 			continue;
 		}
 #endif
@@ -87,15 +95,118 @@ static int notifier_call_chain(struct notifier_block **nl,
 		if (nr_calls)
 			(*nr_calls)++;
 
+		if (last_nb)
+			*last_nb = nb;
+
 		if (ret & NOTIFY_STOP_MASK)
 			break;
-		nb = next_nb;
-		nr_to_call--;
+
+		if (nr_to_call-- == 0)
+			break;
 	}
 	return ret;
 }
 NOKPROBE_SYMBOL(notifier_call_chain);
 
+/**
+ * notifier_call_chain_reverse - Informs the registered notifiers
+ *			about an event reversely.
+ *	@nl:		Pointer to head of the blocking notifier chain
+ *	@val:		Value passed unmodified to notifier function
+ *	@v:		Pointer passed unmodified to notifier function
+ *	@nr_to_call:	Number of notifier functions to be called. Don't care
+ *			value of this parameter is -1.
+ *	@nr_calls:	Records the number of notifications sent. Don't care
+ *			value of this field is NULL.
+ *	Return:		notifier_call_chain returns the value returned by the
+ *			last notifier function called.
+ */
+static int notifier_call_chain_reverse(struct list_head *nl,
+					struct notifier_block *start,
+					unsigned long val, void *v,
+					int nr_to_call, int *nr_calls)
+{
+	int ret = NOTIFY_DONE;
+	struct notifier_block *nb;
+	bool do_call = (start == NULL);
+
+	if (!nr_to_call)
+		return ret;
+
+	list_for_each_entry_reverse(nb, nl, entry) {
+		if (!do_call) {
+			if (nb == start)
+				do_call = true;
+			continue;
+		}
+#ifdef CONFIG_DEBUG_NOTIFIERS
+		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
+			WARN(1, "Invalid notifier called!");
+			continue;
+		}
+#endif
+		trace_notifier_run((void *)nb->notifier_call);
+		ret = nb->notifier_call(nb, val, v);
+
+		if (nr_calls)
+			(*nr_calls)++;
+
+		if (ret & NOTIFY_STOP_MASK)
+			break;
+
+		if (nr_to_call-- == 0)
+			break;
+	}
+	return ret;
+}
+NOKPROBE_SYMBOL(notifier_call_chain_reverse);
+
+/**
+ * notifier_call_chain_rcu - Informs the registered notifiers
+ *			about an event for srcu notifier chain.
+ *	@nl:		Pointer to head of the blocking notifier chain
+ *	@val:		Value passed unmodified to notifier function
+ *	@v:		Pointer passed unmodified to notifier function
+ *	@nr_to_call:	Number of notifier functions to be called. Don't care
+ *			value of this parameter is -1.
+ *	@nr_calls:	Records the number of notifications sent. Don't care
+ *			value of this field is NULL.
+ *	Return:		notifier_call_chain returns the value returned by the
+ *			last notifier function called.
+ */
+static int notifier_call_chain_rcu(struct list_head *nl,
+			       unsigned long val, void *v,
+			       int nr_to_call, int *nr_calls)
+{
+	int ret = NOTIFY_DONE;
+	struct notifier_block *nb;
+
+	if (!nr_to_call)
+		return ret;
+
+	list_for_each_entry_rcu(nb, nl, entry) {
+#ifdef CONFIG_DEBUG_NOTIFIERS
+		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
+			WARN(1, "Invalid notifier called!");
+			continue;
+		}
+#endif
+		trace_notifier_run((void *)nb->notifier_call);
+		ret = nb->notifier_call(nb, val, v);
+
+		if (nr_calls)
+			(*nr_calls)++;
+
+		if (ret & NOTIFY_STOP_MASK)
+			break;
+
+		if (nr_to_call-- == 0)
+			break;
+	}
+	return ret;
+}
+NOKPROBE_SYMBOL(notifier_call_chain_rcu);
+
 /**
  * notifier_call_chain_robust - Inform the registered notifiers about an event
  *                              and rollback on error.
@@ -111,15 +222,16 @@ NOKPROBE_SYMBOL(notifier_call_chain);
  *
  * Return:	the return value of the @val_up call.
  */
-static int notifier_call_chain_robust(struct notifier_block **nl,
+static int notifier_call_chain_robust(struct list_head *nl,
 				     unsigned long val_up, unsigned long val_down,
 				     void *v)
 {
 	int ret, nr = 0;
+	struct notifier_block *last_nb = NULL;
 
-	ret = notifier_call_chain(nl, val_up, v, -1, &nr);
+	ret = notifier_call_chain(nl, val_up, v, -1, &nr, &last_nb);
 	if (ret & NOTIFY_STOP_MASK)
-		notifier_call_chain(nl, val_down, v, nr-1, NULL);
+		notifier_call_chain_reverse(nl, last_nb, val_down, v, nr-1, NULL);
 
 	return ret;
 }
@@ -220,7 +332,7 @@ int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 	int ret;
 
 	rcu_read_lock();
-	ret = notifier_call_chain(&nh->head, val, v, -1, NULL);
+	ret = notifier_call_chain(&nh->head, val, v, -1, NULL, NULL);
 	rcu_read_unlock();
 
 	return ret;
@@ -238,7 +350,7 @@ NOKPROBE_SYMBOL(atomic_notifier_call_chain);
  */
 bool atomic_notifier_call_chain_is_empty(struct atomic_notifier_head *nh)
 {
-	return !rcu_access_pointer(nh->head);
+	return list_empty(&nh->head);
 }
 
 /*
@@ -340,7 +452,7 @@ int blocking_notifier_call_chain_robust(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_access_pointer(nh->head)) {
+	if (!list_empty(&nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain_robust(&nh->head, val_up, val_down, v);
 		up_read(&nh->rwsem);
@@ -375,15 +487,52 @@ int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_access_pointer(nh->head)) {
+	if (!list_empty(&nh->head)) {
 		down_read(&nh->rwsem);
-		ret = notifier_call_chain(&nh->head, val, v, -1, NULL);
+		ret = notifier_call_chain(&nh->head, val, v, -1, NULL, NULL);
 		up_read(&nh->rwsem);
 	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);
 
+/**
+ *	blocking_notifier_call_chain_reverse - Call functions reversely in
+ *				a blocking notifier chain
+ *	@nh: Pointer to head of the blocking notifier chain
+ *	@val: Value passed unmodified to notifier function
+ *	@v: Pointer passed unmodified to notifier function
+ *
+ *	Calls each function in a notifier chain in turn.  The functions
+ *	run in a process context, so they are allowed to block.
+ *
+ *	If the return value of the notifier can be and'ed
+ *	with %NOTIFY_STOP_MASK then blocking_notifier_call_chain()
+ *	will return immediately, with the return value of
+ *	the notifier function which halted execution.
+ *	Otherwise the return value is the return value
+ *	of the last notifier function called.
+ */
+
+int blocking_notifier_call_chain_reverse(struct blocking_notifier_head *nh,
+		unsigned long val, void *v)
+{
+	int ret = NOTIFY_DONE;
+
+	/*
+	 * We check the head outside the lock, but if this access is
+	 * racy then it does not matter what the result of the test
+	 * is, we re-check the list after having taken the lock anyway:
+	 */
+	if (!list_empty(&nh->head)) {
+		down_read(&nh->rwsem);
+		ret = notifier_call_chain_reverse(&nh->head, NULL, val, v, -1, NULL);
+		up_read(&nh->rwsem);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blocking_notifier_call_chain_reverse);
+
 /*
  *	Raw notifier chain routines.  There is no protection;
  *	the caller must provide it.  Use at your own risk!
@@ -450,7 +599,7 @@ EXPORT_SYMBOL_GPL(raw_notifier_call_chain_robust);
 int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v)
 {
-	return notifier_call_chain(&nh->head, val, v, -1, NULL);
+	return notifier_call_chain(&nh->head, val, v, -1, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
 
@@ -543,7 +692,7 @@ int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 	int idx;
 
 	idx = srcu_read_lock(&nh->srcu);
-	ret = notifier_call_chain(&nh->head, val, v, -1, NULL);
+	ret = notifier_call_chain_rcu(&nh->head, val, v, -1, NULL);
 	srcu_read_unlock(&nh->srcu, idx);
 	return ret;
 }
@@ -566,7 +715,7 @@ void srcu_init_notifier_head(struct srcu_notifier_head *nh)
 	mutex_init(&nh->mutex);
 	if (init_srcu_struct(&nh->srcu) < 0)
 		BUG();
-	nh->head = NULL;
+	INIT_LIST_HEAD(&nh->head);
 }
 EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index c942f1282236..0afcba2967c7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -90,7 +90,7 @@ static const struct nla_policy rtm_nh_res_bucket_policy_get[] = {
 
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
-	return !net->nexthop.notifier_chain.head;
+	return list_empty(&net->nexthop.notifier_chain.head);
 }
 
 static void
-- 
2.43.0


