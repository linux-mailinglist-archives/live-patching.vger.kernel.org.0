Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2471CBC09
	for <lists+live-patching@lfdr.de>; Sat,  9 May 2020 03:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgEIBKq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 May 2020 21:10:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48620 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727828AbgEIBKq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 May 2020 21:10:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 05541825B28897CE8A93;
        Sat,  9 May 2020 09:10:44 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 09:10:35 +0800
From:   Samuel Zou <zou_wei@huawei.com>
To:     <jpoimboe@redhat.com>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>
CC:     <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Samuel Zou" <zou_wei@huawei.com>
Subject: [PATCH -next v2] livepatch: Make klp_apply_object_relocs static
Date:   Sat, 9 May 2020 09:16:41 +0800
Message-ID: <1588987001-27863-1-git-send-email-zou_wei@huawei.com>
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

kernel/livepatch/core.c:748:5: warning: symbol 'klp_apply_object_relocs' was not declared.

The klp_apply_object_relocs() has only one call site within core.c
It should be static

Fixes: 7c8e2bdd5f0d ("livepatch: Apply vmlinux-specific KLP relocations early")
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

