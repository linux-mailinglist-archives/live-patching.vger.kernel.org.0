Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53997443120
	for <lists+live-patching@lfdr.de>; Tue,  2 Nov 2021 16:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhKBPCt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Nov 2021 11:02:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233721AbhKBPCr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Nov 2021 11:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635865212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hldzXdTC4k0SUZw36wKMAEkT8W/BZfkm68u5aS6Q7fQ=;
        b=JjRTscejmk/aWFLngd/yG/pa1AmHH800vCpoRwi8w5tTrtKlVL3BffbzOQoczs+aTi0IId
        T4B4wMKSgAKPk90zGf63wrvUtvEZJ1ck5mUTnl5u67hy+46gIrlhNV1tCutK44S2wmBTRh
        /Ys5MqS3s2RWgzxNU+naBFWgq02HGmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-cVUy6fNrPRyTS_PuO_byTw-1; Tue, 02 Nov 2021 11:00:09 -0400
X-MC-Unique: cVUy6fNrPRyTS_PuO_byTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBF3A362F8;
        Tue,  2 Nov 2021 15:00:07 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB59A1E6;
        Tue,  2 Nov 2021 14:59:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 2/3] livepatch: free klp_patch object without holding klp_mutex
Date:   Tue,  2 Nov 2021 22:59:31 +0800
Message-Id: <20211102145932.3623108-3-ming.lei@redhat.com>
In-Reply-To: <20211102145932.3623108-1-ming.lei@redhat.com>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

kobject_del() is called from kobject_put(), and after the klp_patch
kobject is deleted, any show()/store() are done.

Once the klp_patch object is removed from list and prepared for
releasing, no need to hold the global mutex of klp_mutex, so
move the freeing outside of klp_mutex.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 kernel/livepatch/core.c       | 36 +++++++++++++++++++++--------------
 kernel/livepatch/core.h       |  3 +--
 kernel/livepatch/transition.c | 23 ++++++++++++++++------
 kernel/livepatch/transition.h |  2 +-
 4 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index b967b4b0071b..27768bb5a38c 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -327,7 +327,8 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
  */
-static int __klp_disable_patch(struct klp_patch *patch);
+static int __klp_disable_patch(struct klp_patch *patch,
+		struct list_head *to_free);
 
 static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -335,6 +336,7 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	struct klp_patch *patch;
 	int ret;
 	bool enabled;
+	LIST_HEAD(to_free);
 
 	ret = kstrtobool(buf, &enabled);
 	if (ret)
@@ -360,13 +362,15 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (patch == klp_transition_patch)
 		klp_reverse_transition();
 	else if (!enabled)
-		ret = __klp_disable_patch(patch);
+		ret = __klp_disable_patch(patch, &to_free);
 	else
 		ret = -EINVAL;
 
 out:
 	mutex_unlock(&klp_mutex);
 
+	klp_free_patches_async(&to_free);
+
 	if (ret)
 		return ret;
 	return count;
@@ -693,20 +697,19 @@ static void klp_free_patch_work_fn(struct work_struct *work)
 	klp_free_patch_finish(patch);
 }
 
-void klp_free_patch_async(struct klp_patch *patch)
+static void klp_free_patch_async(struct klp_patch *patch)
 {
 	klp_free_patch_start(patch);
 	schedule_work(&patch->free_work);
 }
 
-void klp_free_replaced_patches_async(struct klp_patch *new_patch)
+void klp_free_patches_async(struct list_head *to_free)
 {
-	struct klp_patch *old_patch, *tmp_patch;
+	struct klp_patch *patch, *tmp_patch;
 
-	klp_for_each_patch_safe(old_patch, tmp_patch) {
-		if (old_patch == new_patch)
-			return;
-		klp_free_patch_async(old_patch);
+	list_for_each_entry_safe(patch, tmp_patch, to_free, list) {
+		list_del_init(&patch->list);
+		klp_free_patch_async(patch);
 	}
 }
 
@@ -915,7 +918,8 @@ static int klp_init_patch(struct klp_patch *patch)
 	return 0;
 }
 
-static int __klp_disable_patch(struct klp_patch *patch)
+static int __klp_disable_patch(struct klp_patch *patch,
+		struct list_head *to_free)
 {
 	struct klp_object *obj;
 
@@ -942,12 +946,13 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_start_transition();
 	patch->enabled = false;
-	klp_try_complete_transition();
+	klp_try_complete_transition(to_free);
 
 	return 0;
 }
 
-static int __klp_enable_patch(struct klp_patch *patch)
+static int __klp_enable_patch(struct klp_patch *patch,
+		struct list_head *to_free)
 {
 	struct klp_object *obj;
 	int ret;
@@ -992,7 +997,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 
 	klp_start_transition();
 	patch->enabled = true;
-	klp_try_complete_transition();
+	klp_try_complete_transition(to_free);
 
 	return 0;
 err:
@@ -1018,6 +1023,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
+	LIST_HEAD(to_free);
 
 	if (!patch || !patch->mod)
 		return -EINVAL;
@@ -1055,12 +1061,14 @@ int klp_enable_patch(struct klp_patch *patch)
 	if (ret)
 		goto err;
 
-	ret = __klp_enable_patch(patch);
+	ret = __klp_enable_patch(patch, &to_free);
 	if (ret)
 		goto err;
 
 	mutex_unlock(&klp_mutex);
 
+	klp_free_patches_async(&to_free);
+
 	return 0;
 
 err:
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 38209c7361b6..8ff97745ba40 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -13,8 +13,7 @@ extern struct list_head klp_patches;
 #define klp_for_each_patch(patch)	\
 	list_for_each_entry(patch, &klp_patches, list)
 
-void klp_free_patch_async(struct klp_patch *patch);
-void klp_free_replaced_patches_async(struct klp_patch *new_patch);
+void klp_free_patches_async(struct list_head *to_free);
 void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
 void klp_discard_nops(struct klp_patch *new_patch);
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5683ac0d2566..0c1857405c17 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -31,12 +31,16 @@ static unsigned int klp_signals_cnt;
  */
 static void klp_transition_work_fn(struct work_struct *work)
 {
+	LIST_HEAD(to_free);
+
 	mutex_lock(&klp_mutex);
 
 	if (klp_transition_patch)
-		klp_try_complete_transition();
+		klp_try_complete_transition(&to_free);
 
 	mutex_unlock(&klp_mutex);
+
+	klp_free_patches_async(&to_free);
 }
 static DECLARE_DELAYED_WORK(klp_transition_work, klp_transition_work_fn);
 
@@ -382,7 +386,7 @@ static void klp_send_signals(void)
  *
  * If any tasks are still stuck in the initial patch state, schedule a retry.
  */
-void klp_try_complete_transition(void)
+void klp_try_complete_transition(struct list_head *to_free)
 {
 	unsigned int cpu;
 	struct task_struct *g, *task;
@@ -450,10 +454,17 @@ void klp_try_complete_transition(void)
 	 * klp_complete_transition() but it is called also
 	 * from klp_cancel_transition().
 	 */
-	if (!patch->enabled)
-		klp_free_patch_async(patch);
-	else if (patch->replace)
-		klp_free_replaced_patches_async(patch);
+	if (!patch->enabled) {
+		list_move(&patch->list, to_free);
+	} else if (patch->replace) {
+		struct klp_patch *old_patch, *tmp_patch;
+
+		klp_for_each_patch_safe(old_patch, tmp_patch) {
+			if (old_patch == patch)
+				break;
+			list_move(&old_patch->list, to_free);
+		}
+	}
 }
 
 /*
diff --git a/kernel/livepatch/transition.h b/kernel/livepatch/transition.h
index 322db16233de..20e3a5a0cbce 100644
--- a/kernel/livepatch/transition.h
+++ b/kernel/livepatch/transition.h
@@ -9,7 +9,7 @@ extern struct klp_patch *klp_transition_patch;
 void klp_init_transition(struct klp_patch *patch, int state);
 void klp_cancel_transition(void);
 void klp_start_transition(void);
-void klp_try_complete_transition(void);
+void klp_try_complete_transition(struct list_head *to_free);
 void klp_reverse_transition(void);
 void klp_force_transition(void);
 
-- 
2.31.1

