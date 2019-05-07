Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB9816446
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 15:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEGNIR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 09:08:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:34044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbfEGNIR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 09:08:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58150AE72;
        Tue,  7 May 2019 13:08:16 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH] livepatch: Remove stale kobj_added entries from kernel-doc descriptions
Date:   Tue,  7 May 2019 15:08:14 +0200
Message-Id: <20190507130815.17685-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Commit 4d141ab3416d ("livepatch: Remove custom kobject state handling")
removed kobj_added members of klp_func, klp_object and klp_patch
structures. kernel-doc descriptions were omitted by accident. Remove
them.

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/livepatch.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index a14bab1a0a3e..955d46f37b72 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -47,7 +47,6 @@
  * @stack_node:	list node for klp_ops func_stack list
  * @old_size:	size of the old function
  * @new_size:	size of the new function
- * @kobj_added: @kobj has been added and needs freeing
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
@@ -125,7 +124,6 @@ struct klp_callbacks {
  * @node:	list node for klp_patch obj_list
  * @mod:	kernel module associated with the patched object
  *		(NULL for vmlinux)
- * @kobj_added: @kobj has been added and needs freeing
  * @dynamic:    temporary object for nop functions; dynamically allocated
  * @patched:	the object's funcs have been added to the klp_ops list
  */
@@ -152,7 +150,6 @@ struct klp_object {
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
- * @kobj_added: @kobj has been added and needs freeing
  * @enabled:	the patch is enabled (but operation may be incomplete)
  * @forced:	was involved in a forced transition
  * @free_work:	patch cleanup from workqueue-context
-- 
2.21.0

