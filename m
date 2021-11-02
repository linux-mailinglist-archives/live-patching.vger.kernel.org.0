Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D999A44312D
	for <lists+live-patching@lfdr.de>; Tue,  2 Nov 2021 16:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhKBPFM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Nov 2021 11:05:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234511AbhKBPDY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Nov 2021 11:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635865249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUoDemn3fiU3t7t/MK0N7FeFtxryWtM1+TO2p+D5wGw=;
        b=XgHXdlVSr9bi+FeoJOjZdpQSp7twAwx8YMDj1Y9poE9cY/mYX6M9nCRFpI5Vf4A0Jt2alV
        3/fj4vksvQfAsdeA7wsqvvBktv3zPaWIehpa70pcAE1QmppgKhEAEviM/+ZrJqnJEB8opl
        AiGj6Ca/k79q4IRWvv6kE6DROIVxL7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-lsNYWc8xPviX6VP4RP2oPw-1; Tue, 02 Nov 2021 11:00:47 -0400
X-MC-Unique: lsNYWc8xPviX6VP4RP2oPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 758F7362F8;
        Tue,  2 Nov 2021 15:00:46 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95AE76784E;
        Tue,  2 Nov 2021 15:00:10 +0000 (UTC)
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
Subject: [PATCH V4 3/3] livepatch: free klp_patch object synchronously
Date:   Tue,  2 Nov 2021 22:59:32 +0800
Message-Id: <20211102145932.3623108-4-ming.lei@redhat.com>
In-Reply-To: <20211102145932.3623108-1-ming.lei@redhat.com>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
fine to free klp_patch object synchronously.

One issue is that enabled store() method, in which the klp_patch kobject
itself is deleted & released. However, sysfs has provided APIs for dealing
with this corner case, so use sysfs_break_active_protection() and
sysfs_unbreak_active_protection() for releasing klp_patch kobject from
enabled_store(), meantime the enabled attribute has to be removed
before deleting the klp_patch kobject.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/livepatch.h     |  1 -
 kernel/livepatch/core.c       | 37 +++++++++++++++--------------------
 kernel/livepatch/core.h       |  2 +-
 kernel/livepatch/transition.c |  2 +-
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 9712818997c5..4dcebf52fac5 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -169,7 +169,6 @@ struct klp_patch {
 	struct list_head obj_list;
 	bool enabled;
 	bool forced;
-	struct work_struct free_work;
 };
 
 #define klp_for_each_object_static(patch, obj) \
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 27768bb5a38c..36999cddc011 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -337,6 +337,7 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	int ret;
 	bool enabled;
 	LIST_HEAD(to_free);
+	struct kernfs_node *kn = NULL;
 
 	ret = kstrtobool(buf, &enabled);
 	if (ret)
@@ -369,10 +370,18 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 out:
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patches_async(&to_free);
-
 	if (ret)
 		return ret;
+
+	if (!list_empty(&to_free)) {
+		kn = sysfs_break_active_protection(kobj, &attr->attr);
+		WARN_ON_ONCE(!kn);
+		sysfs_remove_file(kobj, &attr->attr);
+		klp_free_patches(&to_free);
+		if (kn)
+			sysfs_unbreak_active_protection(kn);
+	}
+
 	return count;
 }
 
@@ -684,32 +693,19 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	kobject_put(&patch->kobj);
 }
 
-/*
- * The livepatch might be freed from sysfs interface created by the patch.
- * This work allows to wait until the interface is destroyed in a separate
- * context.
- */
-static void klp_free_patch_work_fn(struct work_struct *work)
-{
-	struct klp_patch *patch =
-		container_of(work, struct klp_patch, free_work);
-
-	klp_free_patch_finish(patch);
-}
-
-static void klp_free_patch_async(struct klp_patch *patch)
+static void klp_free_patch(struct klp_patch *patch)
 {
 	klp_free_patch_start(patch);
-	schedule_work(&patch->free_work);
+	klp_free_patch_finish(patch);
 }
 
-void klp_free_patches_async(struct list_head *to_free)
+void klp_free_patches(struct list_head *to_free)
 {
 	struct klp_patch *patch, *tmp_patch;
 
 	list_for_each_entry_safe(patch, tmp_patch, to_free, list) {
 		list_del_init(&patch->list);
-		klp_free_patch_async(patch);
+		klp_free_patch(patch);
 	}
 }
 
@@ -873,7 +869,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	kobject_init(&patch->kobj, &klp_ktype_patch);
 	patch->enabled = false;
 	patch->forced = false;
-	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 
 	klp_for_each_object_static(patch, obj) {
 		if (!obj->funcs)
@@ -1067,7 +1062,7 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patches_async(&to_free);
+	klp_free_patches(&to_free);
 
 	return 0;
 
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 8ff97745ba40..ea593f370049 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -13,7 +13,7 @@ extern struct list_head klp_patches;
 #define klp_for_each_patch(patch)	\
 	list_for_each_entry(patch, &klp_patches, list)
 
-void klp_free_patches_async(struct list_head *to_free);
+void klp_free_patches(struct list_head *to_free);
 void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
 void klp_discard_nops(struct klp_patch *new_patch);
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 0c1857405c17..1a339a076dd4 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -40,7 +40,7 @@ static void klp_transition_work_fn(struct work_struct *work)
 
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patches_async(&to_free);
+	klp_free_patches(&to_free);
 }
 static DECLARE_DELAYED_WORK(klp_transition_work, klp_transition_work_fn);
 
-- 
2.31.1

