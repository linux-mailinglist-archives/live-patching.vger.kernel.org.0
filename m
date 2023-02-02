Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734446876A0
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjBBHnX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjBBHnD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:03 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC5E78418F;
        Wed,  1 Feb 2023 23:42:41 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9DD1420B2EE2;
        Wed,  1 Feb 2023 23:42:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9DD1420B2EE2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323761;
        bh=TU6iA6jKusJnO70H+H53EmwcF0iJW0CBgTtKff3JI6k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QC4nujwZtIv/QBJ9ymn/CgxJwUDnI+3uphc5T+Gu1JhzZ8DsZDrdFS6ekuXTYImNI
         3hhJvzVlkgZtNG3y+q0Z+Er2prT0XsuyEtZPzyM7Y095qVEUMRdK9OZBd92AZdLUn7
         ozFI8y1kgFhsn1M6zu0K6KGUmH7ot/1xROXsuhlg=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 16/22] arm64: Add unwind hints to exception handlers
Date:   Thu,  2 Feb 2023 01:40:30 -0600
Message-Id: <20230202074036.507249-17-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Add unwind hints to Interrupt and Exception handlers.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/entry.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e28137d64b76..d73bed56f0e6 100644
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
@@ -887,6 +889,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	/* Move to the new stack and call the function there */
 	mov	sp, x16
 	blr	x1
+	UNWIND_HINT_IRQ 16
 
 	/*
 	 * Restore the SP from the FP, and restore the FP and LR from the frame
-- 
2.25.1

