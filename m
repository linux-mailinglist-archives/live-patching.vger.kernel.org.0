Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97751CAA2B
	for <lists+live-patching@lfdr.de>; Fri,  8 May 2020 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHMAg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 May 2020 08:00:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726618AbgEHMAf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 May 2020 08:00:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8FC135C97C5EACF10202;
        Fri,  8 May 2020 20:00:32 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 20:00:25 +0800
From:   Samuel Zou <zou_wei@huawei.com>
To:     <jpoimboe@redhat.com>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>
CC:     <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Samuel Zou" <zou_wei@huawei.com>
Subject: [PATCH -next] livepatch: Make klp_apply_object_relocs static
Date:   Fri, 8 May 2020 20:06:34 +0800
Message-ID: <1588939594-58255-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Fix the following sparse warning:

kernel/livepatch/core.c:748:5: warning: symbol 'klp_apply_object_relocs'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
---
 kernel/livepatch/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 96d2da1..f76fdb9 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -745,7 +745,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 			   func->old_sympos ? func->old_sympos : 1);
 }
 
-int klp_apply_object_relocs(struct klp_patch *patch, struct klp_object *obj)
+static int klp_apply_object_relocs(struct klp_patch *patch,
+				   struct klp_object *obj)
 {
 	int i, ret;
 	struct klp_modinfo *info = patch->mod->klp_info;
-- 
2.6.2

