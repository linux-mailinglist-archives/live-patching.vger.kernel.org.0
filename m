Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178FA4411AE
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 01:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhKAAe0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 31 Oct 2021 20:34:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhKAAeZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 31 Oct 2021 20:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635726712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PirYheqr6FLOoxWAxVnOPTHVHjvSWygKUIkBvNKqlsc=;
        b=THC0PpwkIPaYM6dQceCT+G/Y1l8CnbeXK2ka9gnAt0Ko4IInsZJxCuGkvdkOqgDuW2owy0
        mCn9SbiIXekOzBXhBw8qo32mMth3jIHtRc0uoz5hll9KE8ReR6JS1/23SujPFrXT1vxWfn
        riRQIyJQ6swasEJ6DQZNLK7y7d85f3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-dilzG_6ePh24OQDwu4khUA-1; Sun, 31 Oct 2021 20:31:49 -0400
X-MC-Unique: dilzG_6ePh24OQDwu4khUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE021808310;
        Mon,  1 Nov 2021 00:31:47 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AB432B0B2;
        Mon,  1 Nov 2021 00:31:43 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/3] livepatch: remove 'struct completion finish' from klp_patch
Date:   Mon,  1 Nov 2021 08:31:30 +0800
Message-Id: <20211101003132.3336497-2-ming.lei@redhat.com>
In-Reply-To: <20211101003132.3336497-1-ming.lei@redhat.com>
References: <20211101003132.3336497-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The completion finish is just for waiting release of the klp_patch
object, then releases module refcnt. We can simply drop the module
refcnt in the kobject release handler of klp_patch.

This way also helps to support allocating klp_patch from heap.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/livepatch.h |  1 -
 kernel/livepatch/core.c   | 12 +++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 2614247a9781..9712818997c5 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -170,7 +170,6 @@ struct klp_patch {
 	bool enabled;
 	bool forced;
 	struct work_struct free_work;
-	struct completion finish;
 };
 
 #define klp_for_each_object_static(patch, obj) \
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 335d988bd811..b967b4b0071b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -551,10 +551,10 @@ static int klp_add_nops(struct klp_patch *patch)
 
 static void klp_kobj_release_patch(struct kobject *kobj)
 {
-	struct klp_patch *patch;
+	struct klp_patch *patch = container_of(kobj, struct klp_patch, kobj);
 
-	patch = container_of(kobj, struct klp_patch, kobj);
-	complete(&patch->finish);
+	if (!patch->forced)
+		module_put(patch->mod);
 }
 
 static struct kobj_type klp_ktype_patch = {
@@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	 * cannot get enabled again.
 	 */
 	kobject_put(&patch->kobj);
-	wait_for_completion(&patch->finish);
-
-	/* Put the module after the last access to struct klp_patch. */
-	if (!patch->forced)
-		module_put(patch->mod);
 }
 
 /*
@@ -876,7 +871,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	patch->enabled = false;
 	patch->forced = false;
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
-	init_completion(&patch->finish);
 
 	klp_for_each_object_static(patch, obj) {
 		if (!obj->funcs)
-- 
2.31.1

