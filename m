Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1658D5F027D
	for <lists+live-patching@lfdr.de>; Fri, 30 Sep 2022 03:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiI3B7j (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Sep 2022 21:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiI3B7i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Sep 2022 21:59:38 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AB432B;
        Thu, 29 Sep 2022 18:59:32 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mdtcw6RT5zpSwb;
        Fri, 30 Sep 2022 09:56:32 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 09:59:30 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 09:59:30 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH] livepatch: Move the result-invariant calculation out of the loop
Date:   Fri, 30 Sep 2022 09:54:46 +0800
Message-ID: <20220930015446.1270-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The calculation results of the variables 'func_addr' and 'func_size' are
not affected by the for loop and do not change due to the changes of
entries[i]. The performance can be improved by moving it outside the loop.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/livepatch/transition.c | 54 +++++++++++++++++------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5d03a2ad1066195..da93aa77715a306 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -196,36 +196,36 @@ static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
 	struct klp_ops *ops;
 	int i;
 
-	for (i = 0; i < nr_entries; i++) {
-		address = entries[i];
+	if (klp_target_state == KLP_UNPATCHED) {
+		 /*
+		  * Check for the to-be-unpatched function
+		  * (the func itself).
+		  */
+		func_addr = (unsigned long)func->new_func;
+		func_size = func->new_size;
+	} else {
+		/*
+		 * Check for the to-be-patched function
+		 * (the previous func).
+		 */
+		ops = klp_find_ops(func->old_func);
 
-		if (klp_target_state == KLP_UNPATCHED) {
-			 /*
-			  * Check for the to-be-unpatched function
-			  * (the func itself).
-			  */
-			func_addr = (unsigned long)func->new_func;
-			func_size = func->new_size;
+		if (list_is_singular(&ops->func_stack)) {
+			/* original function */
+			func_addr = (unsigned long)func->old_func;
+			func_size = func->old_size;
 		} else {
-			/*
-			 * Check for the to-be-patched function
-			 * (the previous func).
-			 */
-			ops = klp_find_ops(func->old_func);
-
-			if (list_is_singular(&ops->func_stack)) {
-				/* original function */
-				func_addr = (unsigned long)func->old_func;
-				func_size = func->old_size;
-			} else {
-				/* previously patched function */
-				struct klp_func *prev;
-
-				prev = list_next_entry(func, stack_node);
-				func_addr = (unsigned long)prev->new_func;
-				func_size = prev->new_size;
-			}
+			/* previously patched function */
+			struct klp_func *prev;
+
+			prev = list_next_entry(func, stack_node);
+			func_addr = (unsigned long)prev->new_func;
+			func_size = prev->new_size;
 		}
+	}
+
+	for (i = 0; i < nr_entries; i++) {
+		address = entries[i];
 
 		if (address >= func_addr && address < func_addr + func_size)
 			return -EAGAIN;
-- 
2.25.1

