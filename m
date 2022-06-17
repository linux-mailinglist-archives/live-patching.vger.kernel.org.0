Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88FB54FCA8
	for <lists+live-patching@lfdr.de>; Fri, 17 Jun 2022 20:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382752AbiFQSCu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jun 2022 14:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383466AbiFQSCo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jun 2022 14:02:44 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34549B51;
        Fri, 17 Jun 2022 11:02:34 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3668020C3491;
        Fri, 17 Jun 2022 11:02:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3668020C3491
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655488954;
        bh=7x/ixErefSqMKfios87LlUDWmbSdZZSR+nkVTJ31BrI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cXf7jdXdbKtZQy5451TdCrx2/Y8z/Nk6gC/QmM0lY6/gWvETR+dV6Ul+Bt1qM7nhu
         TcWGpkqSVl8+TybBzvvRj1pNngyNe2tRUWfnfnb20QGn8nvxYVISbeazmWeExd99oS
         gjJbVm/KABmmrjXx7PqlyOxf5Tj0yOZjPK3HetTA=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v15 4/6] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Fri, 17 Jun 2022 13:02:17 -0500
Message-Id: <20220617180219.20352-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617180219.20352-1-madvenka@linux.microsoft.com>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617180219.20352-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_check_reliability() that will
detect these cases and set a flag in the stack frame. Call
unwind_check_reliability() for every frame in unwind().

Introduce the first reliability check in unwind_check_reliability() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code. Other reliability checks
will be added in the future.

Let unwind() return a boolean to indicate if the stack trace is
reliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c749129aba5a..5ef2ce217324 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -44,6 +44,8 @@
  * @final_fp:	 Pointer to the final frame.
  *
  * @failed:      Unwind failed.
+ *
+ * @reliable:    Stack trace is reliable.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -57,6 +59,7 @@ struct unwind_state {
 	struct task_struct *task;
 	unsigned long final_fp;
 	bool failed;
+	bool reliable;
 };
 
 static void unwind_init_common(struct unwind_state *state,
@@ -80,6 +83,7 @@ static void unwind_init_common(struct unwind_state *state,
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
 	state->failed = false;
+	state->reliable = true;
 
 	/* Stack trace terminates here. */
 	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
@@ -242,11 +246,34 @@ static void notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct unwind_state *state,
+/*
+ * Check the stack frame for conditions that make further unwinding unreliable.
+ */
+static void unwind_check_reliability(struct unwind_state *state)
+{
+	if (state->fp == state->final_fp) {
+		/* Final frame; no more unwind, no need to check reliability */
+		return;
+	}
+
+	/*
+	 * If the PC is not a known kernel text address, then we cannot
+	 * be sure that a subsequent unwind will be reliable, as we
+	 * don't know that the code follows our unwind requirements.
+	 */
+	if (!__kernel_text_address(state->pc))
+		state->reliable = false;
+}
+
+static bool notrace unwind(struct unwind_state *state,
 			   stack_trace_consume_fn consume_entry, void *cookie)
 {
-	while (unwind_continue(state, consume_entry, cookie))
+	unwind_check_reliability(state);
+	while (unwind_continue(state, consume_entry, cookie)) {
 		unwind_next(state);
+		unwind_check_reliability(state);
+	}
+	return !state->failed && state->reliable;
 }
 NOKPROBE_SYMBOL(unwind);
 
-- 
2.25.1

