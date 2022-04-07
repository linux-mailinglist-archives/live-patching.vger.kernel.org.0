Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB114F89A3
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiDGUkC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiDGUjr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:47 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CD32345472;
        Thu,  7 Apr 2022 13:26:04 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6BEC820BA5AC;
        Thu,  7 Apr 2022 13:26:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6BEC820BA5AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363164;
        bh=BSKbGYlk+dm3FX69ux9O3ehGfhjDAqvE7NkPhunNR+w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YTIymf1N9NBeKyBvzU6MdJLvXPltxW9AAuBmMxKb1Rm07zVgOrblLET1kxYHj8gUl
         DbsBO+fb2Gxzb/MODrfVhS0UBMXrb7wwdnJtvYP7IhKmFudPCi6k2LkTWDVf5vhQC8
         lSBhPw5k1X5QbhKWb3GW1NJYIpwciPdusiXbaZ1A=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 4/9] dwarf: Implement DWARF rule processing in the kernel
Date:   Thu,  7 Apr 2022 15:25:13 -0500
Message-Id: <20220407202518.19780-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Define a struct dwarf_info to store all of the DWARF information needed to
lookup the DWARF rules for an instruction address. There is one dwarf_info
for vmlinux and one for every module.

Implement a lookup function dwarf_lookup(). Given an instruction address,
the function looks up the corresponding DWARF rules. The unwinder will use
the lookup function in the future.

Sort the rules based on instruction address. This allows a binary search.

Divide the text range into fixed sized blocks and map the rules to their
respective blocks. Given an instruction address, first locate the block
for the address. Then, perform a binary search within the rules in the
block. This minimizes the number of rules to consider in the binary search.

dwarf_info contains an array of PCs to search. In order to save space, store
the PCs array as an array of offsets from the base PC of the text range.
This way, we only need 32 bits to store the PC.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/sections.h |   4 +
 include/linux/dwarf.h             |  21 +++
 kernel/Makefile                   |   1 +
 kernel/dwarf_fp.c                 | 244 ++++++++++++++++++++++++++++++
 tools/include/linux/dwarf.h       |  21 +++
 5 files changed, 291 insertions(+)
 create mode 100644 kernel/dwarf_fp.c

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 152cb35bf9df..d9095a9094b7 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -22,5 +22,9 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+#ifdef CONFIG_DWARF_FP
+extern char __dwarf_rules_start[], __dwarf_rules_end[];
+extern char __dwarf_pcs_start[], __dwarf_pcs_end[];
+#endif
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/include/linux/dwarf.h b/include/linux/dwarf.h
index 16e9dd8c60c8..3df15e79003c 100644
--- a/include/linux/dwarf.h
+++ b/include/linux/dwarf.h
@@ -40,4 +40,25 @@ struct dwarf_rule {
 	short		fp_offset;
 };
 
+/*
+ * The whole text area is divided into fixed sized blocks. Rules are mapped
+ * to their respective blocks. To find a block for an instruction address,
+ * the block of the address is located. Then, a binary search is performed
+ * on just the rules in the block. This minimizes the number of rules to
+ * be considered for the search.
+ */
+struct dwarf_block {
+	int		first_rule;
+	int		last_rule;
+};
+
+#ifdef CONFIG_DWARF_FP
+extern struct dwarf_rule	*dwarf_lookup(unsigned long pc);
+#else
+static inline struct dwarf_rule *dwarf_lookup(unsigned long pc)
+{
+	return NULL;
+}
+#endif
+
 #endif /* _LINUX_DWARF_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 186c49582f45..7582a6323446 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -130,6 +130,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
 
 obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
+obj-$(CONFIG_DWARF_FP) += dwarf_fp.o
 
 CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
diff --git a/kernel/dwarf_fp.c b/kernel/dwarf_fp.c
new file mode 100644
index 000000000000..bb14fbe3f3e1
--- /dev/null
+++ b/kernel/dwarf_fp.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * dwarf_fp.c - Allocate DWARF info. There will be one info for vmlinux
+ *		and one for every module. Implement a lookup function that
+ *		can locate the rule for a given instruction address.
+ *
+ * Copyright (C) 2021 Microsoft, Inc.
+ * Author: Madhavan T. Venkataraman <madvenka@microsoft.com>
+ */
+#include <linux/dwarf.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/types.h>
+#include <asm/sections.h>
+#include <asm/memory.h>
+
+#define OFFSET_BLOCK_SHIFT		12
+#define OFFSET_BLOCK(pc)		((pc) >> OFFSET_BLOCK_SHIFT)
+
+/*
+ * There is one struct dwarf_info for vmlinux and one for each module.
+ */
+struct dwarf_info {
+	struct dwarf_rule	*rules;
+	int			nrules;
+	unsigned int		*offsets;
+
+	struct dwarf_block	*blocks;
+	int			nblocks;
+
+	unsigned long		*pcs;
+	unsigned long		base_pc;
+	unsigned long		end_pc;
+};
+
+static DEFINE_MUTEX(dwarf_mutex);
+
+static struct dwarf_info	*vmlinux_dwarf_info;
+static struct dwarf_info	*cur_info;
+
+static int dwarf_compare(const void *arg1, const void *arg2)
+{
+	const unsigned long		*pc1 = arg1;
+	const unsigned long		*pc2 = arg2;
+
+	if (*pc1 > *pc2)
+		return 1;
+	if (*pc1 < *pc2)
+		return -1;
+	return 0;
+}
+
+static void dwarf_swap(void *arg1, void *arg2, int size)
+{
+	struct dwarf_rule	*rules = cur_info->rules;
+	unsigned long		*pc1 = arg1;
+	unsigned long		*pc2 = arg2;
+	int			i = (int) (pc1 - cur_info->pcs);
+	int			j = (int) (pc2 - cur_info->pcs);
+	unsigned long		tmp_pc;
+	struct dwarf_rule	tmp_rule;
+
+	tmp_pc = *pc1;
+	*pc1 = *pc2;
+	*pc2 = tmp_pc;
+
+	tmp_rule = rules[i];
+	rules[i] = rules[j];
+	rules[j] = tmp_rule;
+}
+
+/*
+ * Sort DWARF Records based on instruction addresses.
+ */
+static void dwarf_sort(struct dwarf_info *info)
+{
+	mutex_lock(&dwarf_mutex);
+
+	/*
+	 * cur_info is a global that allows us to sort both arrays in one go.
+	 */
+	cur_info = info;
+	sort(info->pcs, info->nrules, sizeof(*info->pcs),
+	     dwarf_compare, dwarf_swap);
+
+	mutex_unlock(&dwarf_mutex);
+}
+
+#define INVALID_RULE		-1
+
+static struct dwarf_info *dwarf_alloc(struct dwarf_rule *rules, int nrules,
+				      unsigned long *pcs)
+{
+	struct dwarf_info	*info;
+	unsigned int		*offsets, last_offset;
+	struct dwarf_block	*blocks;
+	int			r, b, nblocks;
+
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	info->rules = rules;
+	info->nrules = nrules;
+	info->pcs = pcs;
+
+	/* Sort pcs[] and rules[] in the increasing order of PC. */
+	dwarf_sort(info);
+
+	/* Compute the boundaries for the rules. */
+	info->base_pc = pcs[0];
+	info->end_pc = pcs[nrules - 1] + rules[nrules - 1].size;
+
+	offsets = kmalloc_array(nrules, sizeof(*offsets), GFP_KERNEL);
+	if (!offsets)
+		goto free_info;
+
+	/* Store the PCs as offsets from the base PC. This is to save memory. */
+	for (r = 0; r < nrules; r++)
+		offsets[r] = pcs[r] - info->base_pc;
+
+	/* Compute the number of blocks. */
+	last_offset = offsets[nrules - 1];
+	nblocks = OFFSET_BLOCK(last_offset) + 1;
+
+	blocks = kmalloc_array(nblocks, sizeof(*blocks), GFP_KERNEL);
+	if (!blocks)
+		goto free_offsets;
+
+	/* Initialize blocks. */
+	for (b = 0; b < nblocks; b++) {
+		blocks[b].first_rule = INVALID_RULE;
+		blocks[b].last_rule = INVALID_RULE;
+	}
+
+	/* Map rules to blocks. */
+	for (r = 0; r < nrules; r++) {
+		b = OFFSET_BLOCK(offsets[r]);
+		if (blocks[b].first_rule == INVALID_RULE)
+			blocks[b].first_rule = r;
+		blocks[b].last_rule = r;
+	}
+
+	/* Initialize empty blocks. */
+	for (b = 0; b < nblocks; b++) {
+		if (blocks[b].first_rule == INVALID_RULE) {
+			blocks[b].first_rule = blocks[b - 1].last_rule;
+			blocks[b].last_rule = blocks[b - 1].last_rule;
+		}
+	}
+
+	info->blocks = blocks;
+	info->nblocks = nblocks;
+	info->offsets = offsets;
+
+	/* PCs for vmlinux is in init data. It will discarded. */
+	info->pcs = NULL;
+
+	return info;
+free_offsets:
+	kfree(offsets);
+free_info:
+	kfree(info);
+	return NULL;
+}
+
+static struct dwarf_rule *dwarf_lookup_rule(struct dwarf_info *info,
+					    unsigned long pc)
+{
+	struct dwarf_block	*blocks = info->blocks;
+	unsigned int		*offsets = info->offsets, off;
+	struct dwarf_rule	*rule;
+	int			start, mid, end, n, b;
+
+	if (pc < info->base_pc || pc >= info->end_pc)
+		return NULL;
+
+	/* Make PC relative to the base for binary search. */
+	off = pc - info->base_pc;
+
+	/*
+	 * Locate the block for the offset. Do a binary search between the
+	 * start and end rules in the block.
+	 */
+	b = OFFSET_BLOCK(off);
+	start = blocks[b].first_rule;
+	end = blocks[b].last_rule + 1;
+
+	if (off < offsets[start])
+		start--;
+
+	/*
+	 * Binary search. For cache performance, we search in offsets[]
+	 * first and locate a candidate rule. Then, we perform a range check
+	 * for the candidate rule at the end. This is so that rules[]
+	 * is only accessed at the end of the search.
+	 */
+	for (n = end - start; n > 1; n = end - start) {
+		mid = start + (n >> 1);
+
+		if (off >= offsets[mid])
+			start = mid;
+		else
+			end = mid;
+	}
+
+	/* Do a final range check. */
+	rule = &info->rules[start];
+	if (off >= offsets[start] && off < (offsets[start] + rule->size))
+		return rule;
+
+	return NULL;
+}
+
+struct dwarf_rule *dwarf_lookup(unsigned long pc)
+{
+	/*
+	 * Currently, only looks up vmlinux. Support for modules will be
+	 * added later.
+	 */
+	return dwarf_lookup_rule(vmlinux_dwarf_info, pc);
+}
+
+static int __init dwarf_init_feature(void)
+{
+	struct dwarf_rule	*rules;
+	unsigned long		*pcs;
+	int			nrules, npcs;
+
+	rules = (struct dwarf_rule *) __dwarf_rules_start;
+	nrules = (__dwarf_rules_end - __dwarf_rules_start) / sizeof(*rules);
+	if (!nrules)
+		return -EINVAL;
+
+	pcs = (unsigned long *) __dwarf_pcs_start;
+	npcs = (__dwarf_pcs_end - __dwarf_pcs_start) / sizeof(*pcs);
+	if (npcs != nrules)
+		return -EINVAL;
+
+	vmlinux_dwarf_info = dwarf_alloc(rules, nrules, pcs);
+
+	return vmlinux_dwarf_info ? 0 : -EINVAL;
+}
+early_initcall(dwarf_init_feature);
diff --git a/tools/include/linux/dwarf.h b/tools/include/linux/dwarf.h
index 16e9dd8c60c8..3df15e79003c 100644
--- a/tools/include/linux/dwarf.h
+++ b/tools/include/linux/dwarf.h
@@ -40,4 +40,25 @@ struct dwarf_rule {
 	short		fp_offset;
 };
 
+/*
+ * The whole text area is divided into fixed sized blocks. Rules are mapped
+ * to their respective blocks. To find a block for an instruction address,
+ * the block of the address is located. Then, a binary search is performed
+ * on just the rules in the block. This minimizes the number of rules to
+ * be considered for the search.
+ */
+struct dwarf_block {
+	int		first_rule;
+	int		last_rule;
+};
+
+#ifdef CONFIG_DWARF_FP
+extern struct dwarf_rule	*dwarf_lookup(unsigned long pc);
+#else
+static inline struct dwarf_rule *dwarf_lookup(unsigned long pc)
+{
+	return NULL;
+}
+#endif
+
 #endif /* _LINUX_DWARF_H */
-- 
2.25.1

