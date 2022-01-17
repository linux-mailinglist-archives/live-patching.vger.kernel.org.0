Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D518E490AE6
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiAQO4o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:44 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59542 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240228AbiAQO4f (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:35 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E01E020B9135;
        Mon, 17 Jan 2022 06:56:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E01E020B9135
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431394;
        bh=9WA4XIJPEMIkNXPJTh9pLlS/9AGYwYxQhbHnVCj+qRU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JkM2/+NpbTQG+du2kijrRPRMkIZMfpMXMTwwDq6efmyIjMR2f/GcoJt8ILlKe8uK/
         B8EeGSFFFqWJGRym4RB5KmjqrO4a/C6o/sUHL++7RQxz8+7F6wBVuHehjbgpvnazfo
         v48/w/AhOq85aFjGBpjR29V6p7rJ+wN6WoPbBwko=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 10/11] arm64: Introduce arch_stack_walk_reliable()
Date:   Mon, 17 Jan 2022 08:56:07 -0600
Message-Id: <20220117145608.6781-11-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117145608.6781-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 arch/arm64/kernel/stacktrace.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8bfe31cbee46..4902fac5745f 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -342,3 +342,25 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	unwind(&state, consume_entry, cookie);
 }
+
+/*
+ * arch_stack_walk_reliable() may not be used for livepatch until all of
+ * the reliability checks are in place in unwind_consume(). However,
+ * debug and test code can choose to use it even if all the checks are not
+ * in place.
+ */
+noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
+					      void *cookie,
+					      struct task_struct *task)
+{
+	struct unwind_state state;
+	bool reliable;
+
+	if (task == current)
+		unwind_init_from_current(&state, task);
+	else
+		unwind_init_from_task(&state, task);
+
+	reliable = unwind(&state, consume_fn, cookie);
+	return reliable ? 0 : -EINVAL;
+}
-- 
2.25.1

