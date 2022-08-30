Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA15A61A2
	for <lists+live-patching@lfdr.de>; Tue, 30 Aug 2022 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiH3L3e (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Aug 2022 07:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiH3L3d (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Aug 2022 07:29:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A793F2D63;
        Tue, 30 Aug 2022 04:29:30 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH4kP2zWBzlWS5;
        Tue, 30 Aug 2022 19:26:05 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:29:28 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:29:28 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH] livepatch: Add a missing newline character in klp_module_coming()
Date:   Tue, 30 Aug 2022 19:28:55 +0800
Message-ID: <20220830112855.749-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

The error message is not printed immediately because it does not end with
a newline character.

Before:
root@localhost:~# insmod vmlinux.ko
insmod: ERROR: could not insert module vmlinux.ko: Invalid parameters

After:
root@localhost:~# insmod vmlinux.ko
[   43.982558] livepatch: vmlinux.ko: invalid module name
insmod: ERROR: could not insert module vmlinux.ko: Invalid parameters

Fixes: dcf550e52f56 ("livepatch: Disallow vmlinux.ko")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc475e62279d2a3..42f7e716d56bf72 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1171,7 +1171,7 @@ int klp_module_coming(struct module *mod)
 		return -EINVAL;
 
 	if (!strcmp(mod->name, "vmlinux")) {
-		pr_err("vmlinux.ko: invalid module name");
+		pr_err("vmlinux.ko: invalid module name\n");
 		return -EINVAL;
 	}
 
-- 
2.25.1

