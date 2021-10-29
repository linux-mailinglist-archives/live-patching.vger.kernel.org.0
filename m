Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F744006F
	for <lists+live-patching@lfdr.de>; Fri, 29 Oct 2021 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhJ2Qja (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Oct 2021 12:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhJ2Qj3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Oct 2021 12:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635525420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f0EKBqxFMa5cFoenII9BpUm91FFdFL/tse0ALEuoccU=;
        b=NZOj7X3IttocF5CkchfM0B2bhnja3GzZxG2mg98ekuVIgwwNAe9XfY9z5WcZXBPMn3uMxe
        i4JC3cDnrFjowPajFwAqCeE/rkPE3LrKXpqu9Gweg9EDU0iXL/uhljSq8QoLrOCXnwtbhu
        jtATZ+8yOIDgdeJvevV84r1yW562FRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-U94BKAc4NhK_iiKio3fBBw-1; Fri, 29 Oct 2021 12:36:59 -0400
X-MC-Unique: U94BKAc4NhK_iiKio3fBBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 393BB1006AA2;
        Fri, 29 Oct 2021 16:36:57 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 249835FC23;
        Fri, 29 Oct 2021 16:36:34 +0000 (UTC)
Date:   Sat, 30 Oct 2021 00:36:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCH 0/3] livepatch: cleanup kpl_patch kobject release
Message-ID: <YXwjDJx+ZZNmy7CN@T590>
References: <20211028125734.3134176-1-ming.lei@redhat.com>
 <YXv8eoPKXk5gpsa7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXv8eoPKXk5gpsa7@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 29, 2021 at 09:51:54AM -0400, Joe Lawrence wrote:
> On Thu, Oct 28, 2021 at 08:57:31PM +0800, Ming Lei wrote:
> > Hello,
> >
> > The 1st patch moves module_put() to release handler of klp_patch
> > kobject.
> >
> > The 2nd patch changes to free klp_patch and other kobjects without
> > klp_mutex.
> >
> > The 3rd patch switches to synchronous kobject release for klp_patch.
> >
> 
> Hi Ming,
> 
> I gave the patchset a spin on top of linus tree @ 1fc596a56b33 and ended
> up with a stuck task:
> 
> Test
> ----
> Enable the livepatch selftests:
>   $ grep CONFIG_TEST_LIVEPATCH .config
>   CONFIG_TEST_LIVEPATCH=m
> 
> Run a continuous kernel build in the background:
>   $ while (true); do make clean && make -j$(nproc); done
> 
> While continuously executing the selftests:
>   $ while (true); do make -C tools/testing/selftests/livepatch/ run_tests; done
> 
> Results
> -------

Hello Joe,

Thanks for the test!

Can you replace the 3rd patch with the following one then running the test again?

From 599e96f79aebc388ef3854134312c6039a7884bf Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 28 Oct 2021 20:11:23 +0800
Subject: [PATCH 3/3] livepatch: free klp_patch object synchronously

klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
fine to free klp_patch object synchronously.

One issue is that enabled store() method, in which the klp_patch kobject
itself is deleted & released. However, sysfs has provided APIs for dealing
with this corner case, so use sysfs_break_active_protection() and
sysfs_unbreak_active_protection() for releasing klp_patch kobject from
enabled_store().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/livepatch.h     |  1 -
 kernel/livepatch/core.c       | 32 +++++++++++++-------------------
 kernel/livepatch/core.h       |  2 +-
 kernel/livepatch/transition.c |  2 +-
 4 files changed, 15 insertions(+), 22 deletions(-)

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
index 9ede093d699a..6cfc54f6bdcc 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -337,6 +337,7 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	int ret;
 	bool enabled;
 	LIST_HEAD(to_free);
+	struct kernfs_node *kn = NULL;
 
 	ret = kstrtobool(buf, &enabled);
 	if (ret)
@@ -369,7 +370,14 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 out:
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patches_async(&to_free);
+	if (list_empty(&to_free)) {
+		kn = sysfs_break_active_protection(kobj, &attr->attr);
+		WARN_ON_ONCE(!kn);
+		sysfs_remove_file(kobj, &attr->attr);
+		klp_free_patches(&to_free);
+		if (kn)
+			sysfs_unbreak_active_protection(kn);
+	}
 
 	if (ret)
 		return ret;
@@ -684,32 +692,19 @@ static void klp_free_patch_finish(struct klp_patch *patch)
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
 
@@ -873,7 +868,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	kobject_init(&patch->kobj, &klp_ktype_patch);
 	patch->enabled = false;
 	patch->forced = false;
-	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 
 	klp_for_each_object_static(patch, obj) {
 		if (!obj->funcs)
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
index a9ebc9c5db02..3eff5fc0deee 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -41,7 +41,7 @@ static void klp_transition_work_fn(struct work_struct *work)
 
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patches_async(&to_free);
+	klp_free_patches(&to_free);
 }
 static DECLARE_DELAYED_WORK(klp_transition_work, klp_transition_work_fn);
 
-- 
2.31.1


Thanks,
Ming

