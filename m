Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6B33C2E5
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhCOQ6s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:48 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51106 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhCOQ6S (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:18 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 342EA20B24E6;
        Mon, 15 Mar 2021 09:58:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 342EA20B24E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827497;
        bh=NS3hnkt5UwYxkTgE05jIzpsdhEjTfgYuj02sn7S/gpA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tAnL8saAEHYVh93a0MZLgmdvKOze1VnSLCDAbic/wGmkeCijxnPAq5lTPrRz8Ym2d
         vNKgQxWEXET4xIPrffDDVSiyrv1y+QAUGA23mId8BWJX8hcAPSMFZsBdetjv8x/XZk
         SwRPm1jyxHk0hECp4kkPwzjDSMWfBy4P/6WwNoj0=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 8/8] arm64: Implement arch_stack_walk_reliable()
Date:   Mon, 15 Mar 2021 11:58:00 -0500
Message-Id: <20210315165800.5948-9-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315165800.5948-1-madvenka@linux.microsoft.com>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

unwind_frame() already sets the reliable flag in the stack frame during
a stack walk to indicate whether the stack trace is reliable or not.

Implement arch_stack_walk_reliable() like arch_stack_walk() but abort
the stack walk as soon as the reliable flag is set to false for any
reason.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig             |  1 +
 arch/arm64/kernel/stacktrace.c | 35 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1f212b47a48a..954f60c35b26 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -167,6 +167,7 @@ config ARM64
 		if $(cc-option,-fpatchable-function-entry=2)
 	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
 		if DYNAMIC_FTRACE_WITH_REGS
+	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 752b77f11c61..5d15c111f3aa 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -361,4 +361,39 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
 
+/*
+ * Walk the stack like arch_stack_walk() but stop the walk as soon as
+ * some unreliability is detected in the stack.
+ */
+int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			      void *cookie, struct task_struct *task)
+{
+	struct stackframe frame;
+	int ret = 0;
+
+	if (task == current) {
+		start_backtrace(&frame,
+				(unsigned long)__builtin_frame_address(0),
+				(unsigned long)arch_stack_walk_reliable);
+	} else {
+		/*
+		 * The task must not be running anywhere for the duration of
+		 * arch_stack_walk_reliable(). The caller must guarantee
+		 * this.
+		 */
+		start_backtrace(&frame, thread_saved_fp(task),
+				thread_saved_pc(task));
+	}
+
+	while (!ret) {
+		if (!frame.reliable)
+			return -EINVAL;
+		if (!consume_entry(cookie, frame.pc))
+			return -EINVAL;
+		ret = unwind_frame(task, &frame);
+	}
+
+	return ret == -ENOENT ? 0 : -EINVAL;
+}
+
 #endif
-- 
2.25.1

