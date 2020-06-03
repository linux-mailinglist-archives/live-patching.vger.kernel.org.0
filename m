Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08BE1ED1C5
	for <lists+live-patching@lfdr.de>; Wed,  3 Jun 2020 16:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgFCOMU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 10:12:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38228 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbgFCOMU (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 10:12:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 47A855205DCCCBE6A13C;
        Wed,  3 Jun 2020 22:12:10 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 3 Jun 2020
 22:12:01 +0800
From:   Cheng Jian <cj.chengjian@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>
CC:     <cj.chengjian@huawei.com>, <chenwandun@huawei.com>,
        <xiexiuqi@huawei.com>, <bobo.shaobowang@huawei.com>,
        <huawei.libin@huawei.com>, <jeyu@kernel.org>, <jikos@kernel.org>
Subject: [PATCH] module: make module symbols visible after init
Date:   Wed, 3 Jun 2020 14:12:00 +0000
Message-ID: <20200603141200.17745-1-cj.chengjian@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When lookup the symbols of module by module_kallsyms_lookup_name(),
the symbols address is visible only if the module's status isn't
MODULE_STATE_UNFORMED, This is problematic.

When complete_formation is done, the state of the module is modified
to MODULE_STATE_COMING, and the symbol of module is visible to the
outside.

At this time, the init function of the module has not been called,
so if the address of the function symbol has been found and called,
it may cause some exceptions.

For livepatch module, the relocation information of the livepatch
module is completed in init by klp_write_object_relocations(), and
the symbol name of the old and new functions are the same. Therefore,
when we lookup the symbol, we may get the function address of the
livepatch module. a crash can occurs when we call this function.

	CPU 0				CPU 1
	==================================================
	load_module
	add_unformed_module # MODULE_STATE_UNFORMED;
	post_relocation
	complete_formation  # MODULE_STATE_COMING;
					------------------
					module_kallsymc_lookup_name("A")
					call A()	# CRASH
					------------------
	do_init_module
	klp_write_object_relocations
	mod->state = MODULE_STATE_LIVE;

In commit 0bd476e6c671 ("kallsyms: unexport kallsyms_lookup_name() and
kallsyms_on_each_symbol()") restricts the invocation for kernel unexported
symbols, but it is still incorrect to make the symbols of non-LIVE modules
visible to the outside.

Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 64a2b4daaaa5..96c9cb64de57 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4220,7 +4220,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 			ret = find_kallsyms_symbol_value(mod, colon+1);
 	} else {
 		list_for_each_entry_rcu(mod, &modules, list) {
-			if (mod->state == MODULE_STATE_UNFORMED)
+			if (mod->state != MODULE_STATE_LIVE)
 				continue;
 			if ((ret = find_kallsyms_symbol_value(mod, name)) != 0)
 				break;
-- 
2.17.1

