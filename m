Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C2633C2DB
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhCOQ6q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51072 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhCOQ6P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:15 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id AF36C20B26FC;
        Mon, 15 Mar 2021 09:58:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AF36C20B26FC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827495;
        bh=TPMn1YTK7zzFM7ywn8W1+RGydSCGcujwty9kEX/anVI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Nx301mR2PlY4Cw21cjxPBVPLKynmTKQ3bXAU1qjHdCodL6b9mqIIkgNKjbfH55NgH
         ICEPIZtTE9mGjfBxI85Gand/ox/arvN5X8A55FxaktvHkThxUlGy8u3VJvQcZAW8K0
         8Q4EJfVX1W29IbQUoKEuo5d0iBV7x8bLbf8v/818=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack trace unreliable
Date:   Mon, 15 Mar 2021 11:57:57 -0500
Message-Id: <20210315165800.5948-6-madvenka@linux.microsoft.com>
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

When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
for a function, the ftrace infrastructure is called for the function at
the very beginning. Ftrace creates two frames:

	- One for the traced function

	- One for the caller of the traced function

That gives a reliable stack trace while executing in the ftrace
infrastructure code. When ftrace returns to the traced function, the frames
are popped and everything is back to normal.

However, in cases like live patch, execution is redirected to a different
function when ftrace returns. A stack trace taken while still in the ftrace
infrastructure code will not show the target function. The target function
is the real function that we want to track.

So, if an FTRACE frame is detected on the stack, just mark the stack trace
as unreliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/entry-ftrace.S |  2 ++
 arch/arm64/kernel/stacktrace.c   | 33 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b3e4f9a088b1..1ec8c5180fc0 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -74,6 +74,8 @@
 	/* Create our frame record within pt_regs. */
 	stp	x29, x30, [sp, #S_STACKFRAME]
 	add	x29, sp, #S_STACKFRAME
+	ldr	w17, =FTRACE_FRAME
+	str	w17, [sp, #S_FRAME_TYPE]
 	.endm
 
 SYM_CODE_START(ftrace_regs_caller)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 6ae103326f7b..594806a0c225 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -23,6 +23,7 @@ static void check_if_reliable(unsigned long fp, struct stackframe *frame,
 {
 	struct pt_regs *regs;
 	unsigned long regs_start, regs_end;
+	unsigned long caller_fp;
 
 	/*
 	 * If the stack trace has already been marked unreliable, just
@@ -68,6 +69,38 @@ static void check_if_reliable(unsigned long fp, struct stackframe *frame,
 		frame->reliable = false;
 		return;
 	}
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	/*
+	 * When tracing is active for a function, the ftrace code is called
+	 * from the function even before the frame pointer prolog and
+	 * epilog. ftrace creates a pt_regs structure on the stack to save
+	 * register state.
+	 *
+	 * In addition, ftrace sets up two stack frames and chains them
+	 * with other frames on the stack. One frame is pt_regs->stackframe
+	 * that is for the traced function. The other frame is set up right
+	 * after the pt_regs structure and it is for the caller of the
+	 * traced function. This is done to ensure a proper stack trace.
+	 *
+	 * If the ftrace code returns to the traced function, then all is
+	 * fine. But if it transfers control to a different function (like
+	 * in livepatch), then a stack walk performed while still in the
+	 * ftrace code will not find the target function.
+	 *
+	 * So, mark the stack trace as unreliable if an ftrace frame is
+	 * detected.
+	 */
+	if (regs->frame_type == FTRACE_FRAME && frame->fp == regs_end &&
+	    frame->fp < info->high) {
+		/* Check the traced function's caller's frame. */
+		caller_fp = READ_ONCE_NOCHECK(*(unsigned long *)(frame->fp));
+		if (caller_fp == regs->regs[29]) {
+			frame->reliable = false;
+			return;
+		}
+	}
+#endif
 }
 
 /*
-- 
2.25.1

