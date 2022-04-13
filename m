Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9864FF883
	for <lists+live-patching@lfdr.de>; Wed, 13 Apr 2022 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiDMOIN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Apr 2022 10:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiDMOIJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Apr 2022 10:08:09 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9F84606D2;
        Wed, 13 Apr 2022 07:05:48 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id B8FB220C34D4;
        Wed, 13 Apr 2022 07:05:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B8FB220C34D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649858748;
        bh=f/N9Y3AhHP+6L0TxuoLGQXAr5xuXJnauRqGxyO1ZK4A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yy4A1rcENqnynxGYVqOz9YprcPsMzJ/nG7o3/WWZQhe6MrXhKE0lZPK9CwLfBLoDh
         5Fo8NqKsS/71ebUW91iSA5V5R3jN0bT7GGpJT4cIk7bpcuRq9ewvLW/9L6x43fkuq+
         X0YN7Lak/1EcMQfQsIS+VtEPhUB8CUK/1JJXkhOA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v14 6/7] arm64: Introduce arch_stack_walk_reliable()
Date:   Wed, 13 Apr 2022 09:05:27 -0500
Message-Id: <20220413140528.3815-7-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413140528.3815-1-madvenka@linux.microsoft.com>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
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

