Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC744C948
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2019 10:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFTIS7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jun 2019 04:18:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbfFTIS7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jun 2019 04:18:59 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C798EE4546889C73D7EE;
        Thu, 20 Jun 2019 16:18:56 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Jun 2019
 16:18:49 +0800
From:   Cheng Jian <cj.chengjian@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>
CC:     <jpoimboe@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <cj.chengjian@huawei.com>, <huawei.libin@huawei.com>,
        <xiexiuqi@huawei.com>, <yangyingliang@huawei.com>,
        <bobo.shaobowang@huawei.com>
Subject: [PATCH] Revert "x86/module: Detect and skip invalid relocations"
Date:   Thu, 20 Jun 2019 16:24:28 +0800
Message-ID: <1561019068-132672-1-git-send-email-cj.chengjian@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This reverts commit eda9cec4c9a12208a6f69fbe68f72a6311d50032.

Since commit (eda9cec4c9a1 'x86/module: Detect and skip invalid
relocations') add some sanity check in apply_relocate_add, borke
re-insmod a kernel module which has been patched before,

The relocation informations of the livepatch module have been
overwritten since first patched, so if we rmmod and insmod the
kernel module, these values are not zero anymore, when
klp_module_coming doing, and that commit marks them as invalid
invalid_relocation.

Then the following error occurs:

	module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc (____ptrval____), val ffffffffc000236c
	livepatch: failed to initialize patch 'livepatch_0001_test' for module 'test' (-8)
	livepatch: patch 'livepatch_0001_test' failed for module 'test', refusing to load module 'test'

To fix this, just revert that commit.

Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
---
 arch/x86/kernel/module.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index d5c72cb..3eb23a8 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -160,28 +160,20 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		case R_X86_64_NONE:
 			break;
 		case R_X86_64_64:
-			if (*(u64 *)loc != 0)
-				goto invalid_relocation;
 			*(u64 *)loc = val;
 			break;
 		case R_X86_64_32:
-			if (*(u32 *)loc != 0)
-				goto invalid_relocation;
 			*(u32 *)loc = val;
 			if (val != *(u32 *)loc)
 				goto overflow;
 			break;
 		case R_X86_64_32S:
-			if (*(s32 *)loc != 0)
-				goto invalid_relocation;
 			*(s32 *)loc = val;
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
 		case R_X86_64_PC32:
 		case R_X86_64_PLT32:
-			if (*(u32 *)loc != 0)
-				goto invalid_relocation;
 			val -= (u64)loc;
 			*(u32 *)loc = val;
 #if 0
@@ -190,8 +182,6 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 #endif
 			break;
 		case R_X86_64_PC64:
-			if (*(u64 *)loc != 0)
-				goto invalid_relocation;
 			val -= (u64)loc;
 			*(u64 *)loc = val;
 			break;
@@ -203,11 +193,6 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	}
 	return 0;
 
-invalid_relocation:
-	pr_err("x86/modules: Skipping invalid relocation target, existing value is nonzero for type %d, loc %p, val %Lx\n",
-	       (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
-	return -ENOEXEC;
-
 overflow:
 	pr_err("overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
-- 
2.7.4

