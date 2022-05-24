Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84033531FB5
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbiEXARf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiEXARM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:12 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15FA98AE41;
        Mon, 23 May 2022 17:17:02 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8504120B6C7C;
        Mon, 23 May 2022 17:17:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8504120B6C7C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351422;
        bh=i38XBmt03Yj6P5EVI/Y5EXfzyY4okm3GZVL0Cbb4zHY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sfxAzXRMl11Qrr1SKOR9ea5oIJHGiWhdgsHqPPqFKf4ahKkqKBeISs0qQ+OmR29h8
         AZvThfbgfBLg44ZxabgwLCB02mOch/EQ906C5w3Hx97du/aAmRSz0kLoAXT96QHk/Z
         EanZbUxltHcUVXXSzqnCJ7aQSRevWF4q56vT0qJ4=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 15/20] arm64: Add unwind hints to specific points in code
Date:   Mon, 23 May 2022 19:16:32 -0500
Message-Id: <20220524001637.1707472-16-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
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

Add unwind hints to the following:

	- Ftrace entry code

	- Interrupt and Exception handlers

	- Kretprobe trampoline

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/entry-ftrace.S              | 23 +++++++++++++++++++
 arch/arm64/kernel/entry.S                     |  3 +++
 arch/arm64/kernel/probes/kprobes_trampoline.S |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index e535480a4069..6d68833e8cec 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -11,6 +11,7 @@
 #include <asm/assembler.h>
 #include <asm/ftrace.h>
 #include <asm/insn.h>
+#include <asm/unwind_hints.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 /*
@@ -95,7 +96,14 @@ SYM_CODE_START(ftrace_common)
 	mov	x3, sp				// regs
 
 SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
+	/*
+	 * Tracer functions are patched at ftrace_stub. Stack traces
+	 * taken from tracer functions will end up here. Place an
+	 * unwind hint based on the stackframe setup in ftrace_regs_entry.
+	 */
 	bl	ftrace_stub
+SYM_INNER_LABEL(ftrace_call_entry, SYM_L_GLOBAL)
+	UNWIND_HINT_REGS PT_REGS_SIZE
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
@@ -134,10 +142,25 @@ SYM_CODE_START(ftrace_graph_caller)
 	add	x1, sp, #S_LR			// parent_ip (callsite's LR)
 	ldr	x2, [sp, #PT_REGS_SIZE]	   	// parent fp (callsite's FP)
 	bl	prepare_ftrace_return
+SYM_INNER_LABEL(ftrace_graph_caller_entry, SYM_L_GLOBAL)
+	UNWIND_HINT_REGS PT_REGS_SIZE
 	b	ftrace_common_return
 SYM_CODE_END(ftrace_graph_caller)
 #endif
 
+/*
+ * ftrace_regs_entry() sets up two stackframes - one for the callsite and
+ * one for the ftrace entry code. Unwind hints have been placed for the
+ * ftrace entry code above. We need an unwind hint for the callsite. Callsites
+ * are numerous. But the unwind hint required for all the callsites is the
+ * same. Define a dummy function here with the callsite unwind hint for the
+ * benefit of the unwinder.
+ */
+SYM_CODE_START(ftrace_callsite)
+	UNWIND_HINT_FTRACE 16		// for the callsite
+	ret
+SYM_CODE_END(ftrace_callsite)
+
 #else /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
 /*
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ede028dee81b..95d5f3c08aa1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -28,6 +28,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
+#include <asm/unwind_hints.h>
 
 	.macro	clear_gp_regs
 	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
@@ -560,6 +561,7 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
 	.if \el == 0
 	b	ret_to_user
 	.else
+	UNWIND_HINT_REGS PT_REGS_SIZE
 	b	ret_to_kernel
 	.endif
 SYM_CODE_END(el\el\ht\()_\regsize\()_\label)
@@ -894,6 +896,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	/* Move to the new stack and call the function there */
 	mov	sp, x16
 	blr	x1
+	UNWIND_HINT_IRQ 16
 
 	/*
 	 * Restore the SP from the FP, and restore the FP and LR from the frame
diff --git a/arch/arm64/kernel/probes/kprobes_trampoline.S b/arch/arm64/kernel/probes/kprobes_trampoline.S
index 9a6499bed58b..847cbb81ca33 100644
--- a/arch/arm64/kernel/probes/kprobes_trampoline.S
+++ b/arch/arm64/kernel/probes/kprobes_trampoline.S
@@ -6,6 +6,7 @@
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
+#include <asm/unwind_hints.h>
 
 	.text
 
@@ -71,6 +72,8 @@ SYM_CODE_START(__kretprobe_trampoline)
 
 	mov x0, sp
 	bl trampoline_probe_handler
+	UNWIND_HINT_REGS PT_REGS_SIZE
+
 	/*
 	 * Replace trampoline address in lr with actual orig_ret_addr return
 	 * address.
-- 
2.25.1

