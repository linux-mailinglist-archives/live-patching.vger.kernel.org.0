Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DC054FF29
	for <lists+live-patching@lfdr.de>; Fri, 17 Jun 2022 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383644AbiFQVHp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jun 2022 17:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383569AbiFQVHa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jun 2022 17:07:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 449105E75D;
        Fri, 17 Jun 2022 14:07:30 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 54E0C20C3491;
        Fri, 17 Jun 2022 14:07:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 54E0C20C3491
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655500050;
        bh=f/N9Y3AhHP+6L0TxuoLGQXAr5xuXJnauRqGxyO1ZK4A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VNAIwf+ewXol7bbQBTpEOIUBY5ntVrWcjGgnn2B7NrAFkfKWLl3hJnJK/yAtle/Cz
         jihQyHIfGZo8JFrhojKgT80w5Ad9Btnjy9CfqQcnDmeYWrl0BDk/S/Kn8Hxo+7zq/b
         2PwXSPSvJjxwFOa6in6pergEGa5Q1tN1+qaxjz/w=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v15 6/6] arm64: Introduce arch_stack_walk_reliable()
Date:   Fri, 17 Jun 2022 16:07:17 -0500
Message-Id: <20220617210717.27126-7-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617210717.27126-1-madvenka@linux.microsoft.com>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
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

Introduce arch_stack_walk_reliable() for ARM64. This works like
arch_stack_walk() except that it returns -EINVAL if the stack trace is not
reliable.

Until all the reliability checks are in place, arch_stack_walk_reliable()
may not be used by livepatch. But it may be used by debug and test code.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index eda8581f7dbe..8016ba0e2c96 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -383,3 +383,26 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	unwind(&state, consume_entry, cookie);
 }
+
+/*
+ * arch_stack_walk_reliable() may not be used for livepatch until all of
+ * the reliability checks are in place in unwind_consume(). However,
+ * debug and test code can choose to use it even if all the checks are not
+ * in place.
+ */
+noinline int notrace arch_stack_walk_reliable(
+					stack_trace_consume_fn consume_entry,
+					void *cookie,
+					struct task_struct *task)
+{
+	struct unwind_state state;
+	bool reliable;
+
+	if (task == current)
+		unwind_init_from_caller(&state);
+	else
+		unwind_init_from_task(&state, task);
+
+	reliable = unwind(&state, consume_entry, cookie);
+	return reliable ? 0 : -EINVAL;
+}
-- 
2.25.1

