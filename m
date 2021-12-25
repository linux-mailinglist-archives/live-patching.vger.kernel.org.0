Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A206547F1B8
	for <lists+live-patching@lfdr.de>; Sat, 25 Dec 2021 03:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhLYCpZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Dec 2021 21:45:25 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16858 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhLYCpY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Dec 2021 21:45:24 -0500
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JLSv21l0vz91pS;
        Sat, 25 Dec 2021 10:44:30 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 25 Dec 2021 10:45:22 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Sat, 25 Dec
 2021 10:45:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>
CC:     <jpoimboe@redhat.com>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <void@manifault.com>
Subject: [PATCH -next] livepatch: Fix missing unlock on error in klp_enable_patch()
Date:   Sat, 25 Dec 2021 10:51:15 +0800
Message-ID: <20211225025115.475348-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add missing unlock when try_module_get() fails in klp_enable_patch().

Fixes: bf01c2975925 ("livepatch: Fix kobject refcount bug on klp_init_patch_early failure path")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 kernel/livepatch/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 23cf444091a8..01bfab7fe7c0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1047,8 +1047,10 @@ int klp_enable_patch(struct klp_patch *patch)
 		return -EINVAL;
 	}
 
-	if (!try_module_get(patch->mod))
+	if (!try_module_get(patch->mod)) {
+		mutex_unlock(&klp_mutex);
 		return -ENODEV;
+	}
 
 	klp_init_patch_early(patch);
 
-- 
2.25.1

