Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B604448352A
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiACQw5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:57 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53316 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiACQwx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:53 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD80820B718C;
        Mon,  3 Jan 2022 08:52:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD80820B718C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228773;
        bh=Xl9WNOn2tIO3ZNBmKyfL3l0gpuWXAeRGb/t+fi8lT7g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DLLIH/0vgG5cY3yu8dxaLG84DI5X1L8kuUyceZqgHJ8WBRCQynD9wt8f1nvnpmNuf
         AXGUshRAiIAx6uEP3IYinO7Elp2/gKAfFOMNm52uy618CDHh3HaJL3kA/LPIM+lKhH
         U9OuORKn2LgyTs9Z5cWrV0z8tQRAnjhsfhV/cmhE=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 09/10] arm64: Introduce arch_stack_walk_reliable()
Date:   Mon,  3 Jan 2022 10:52:11 -0600
Message-Id: <20220103165212.9303-10-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220103165212.9303-1-madvenka@linux.microsoft.com>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
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
 arch/arm64/kernel/stacktrace.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1db1ccb61241..717d30833252 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -339,3 +339,27 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	unwind(&state);
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
+	unwind_init_common(&state, task, NULL, consume_fn, cookie);
+
+	if (task == current)
+		unwind_init_current(&state);
+	else
+		unwind_init_task(&state);
+
+	reliable = unwind(&state);
+	return reliable ? 0 : -EINVAL;
+}
-- 
2.25.1

