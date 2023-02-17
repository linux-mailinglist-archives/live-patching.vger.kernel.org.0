Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6110569A432
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 04:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBQDOv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Feb 2023 22:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQDOu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Feb 2023 22:14:50 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D1D5455A;
        Thu, 16 Feb 2023 19:14:46 -0800 (PST)
From:   =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676603684;
        bh=JhufyqbgcfAtSqTzyqs7Nu1k8rx08yOQj4V6vTeRZRg=;
        h=From:Date:Subject:To:Cc:From;
        b=D34bvA+NxbQA4ghJTPvHf3r31uIS/doBa8YDg31r4vP680wftF/2Zf4V6gCirhKTz
         b9ehtwA7lR45jZJ/qptX84IixRd04TVTu563MsHqNzRhk+QsiFGqhCKA9sQBURpnGE
         9TrxUSNUTSENDRCVjeZQPCol4HasSFENXcDl5crM=
Date:   Fri, 17 Feb 2023 03:14:41 +0000
Subject: [PATCH] livepatch: Make kobj_type structures constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230217-kobj_type-livepatch-v1-1-06ded292e897@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIACDx7mMC/x2NWwqDMBAAryL73QWNWqFXKUXy2DTbhhgSKy3i3
 bv4OQPD7FCpMFW4NTsU2rjykgS6SwM26PQkZCcMqlV9q7oJ34t5zesvE0beKOvVBpwG57y/umH
 sPUhpdCU0RScbpE2fGEXmQp6/5+r+OI4/qugDu3oAAAA=
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676603682; l=1669;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=JhufyqbgcfAtSqTzyqs7Nu1k8rx08yOQj4V6vTeRZRg=;
 b=IHauOSf5wkVtx+kzX5lRhfCxnvQC/kMey7MbAd54Ve5ypF9z84f96TOr5rGIrgAg/zKyO48i1
 XYLr/jlxHwPAS17sbwQQ6u/xZJivb8zvjWrR28bp0nL3nHTjhHeSX3A
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
the driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definitions to prevent
modification at runtime.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 kernel/livepatch/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 201f0c0482fb..3da548755d8a 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -581,7 +581,7 @@ static void klp_kobj_release_patch(struct kobject *kobj)
 	complete(&patch->finish);
 }
 
-static struct kobj_type klp_ktype_patch = {
+static const struct kobj_type klp_ktype_patch = {
 	.release = klp_kobj_release_patch,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = klp_patch_groups,
@@ -597,7 +597,7 @@ static void klp_kobj_release_object(struct kobject *kobj)
 		klp_free_object_dynamic(obj);
 }
 
-static struct kobj_type klp_ktype_object = {
+static const struct kobj_type klp_ktype_object = {
 	.release = klp_kobj_release_object,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = klp_object_groups,
@@ -613,7 +613,7 @@ static void klp_kobj_release_func(struct kobject *kobj)
 		klp_free_func_nop(func);
 }
 
-static struct kobj_type klp_ktype_func = {
+static const struct kobj_type klp_ktype_func = {
 	.release = klp_kobj_release_func,
 	.sysfs_ops = &kobj_sysfs_ops,
 };

---
base-commit: 3ac88fa4605ec98e545fb3ad0154f575fda2de5f
change-id: 20230217-kobj_type-livepatch-74ddff6d453f

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

