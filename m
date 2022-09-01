Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE3C5A8B6B
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 04:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiIAC1i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 31 Aug 2022 22:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIAC1h (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 31 Aug 2022 22:27:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AB2136B04;
        Wed, 31 Aug 2022 19:27:36 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJ4dH3lQnznTVF;
        Thu,  1 Sep 2022 10:25:07 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 10:27:34 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 10:27:34 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH] livepatch: Move error print out of lock protection in klp_enable_patch()
Date:   Thu, 1 Sep 2022 10:27:06 +0800
Message-ID: <20220901022706.813-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The patch->mod is not a protected object of mutex_lock(&klp_mutex). Since
it's in the error handling branch, it might not be helpful to reduce lock
conflicts, but it can reduce some code size.

Before:
   text    data     bss     dec     hex filename
  10330     464       8   10802    2a32 kernel/livepatch/core.o

After:
   text    data     bss     dec     hex filename
  10307     464       8   10779    2a1b kernel/livepatch/core.o

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 42f7e716d56bf72..cb7abc821a50584 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
 	mutex_lock(&klp_mutex);
 
 	if (!klp_is_patch_compatible(patch)) {
+		mutex_unlock(&klp_mutex);
 		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
 			patch->mod->name);
-		mutex_unlock(&klp_mutex);
 		return -EINVAL;
 	}
 
-- 
2.25.1

