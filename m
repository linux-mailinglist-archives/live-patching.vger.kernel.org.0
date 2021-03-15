Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF8433C2DD
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhCOQ6r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:47 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51090 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbhCOQ6R (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:17 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5D3FD20B24C9;
        Mon, 15 Mar 2021 09:58:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D3FD20B24C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827497;
        bh=U+g0k+CbNn5bvnLnkW0oWUHs8xX5CpmhC3AM4YySraA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TTELecyPokPX3waxtRE8n2B5zh3IpIDfunnF9vcMo7BWdiR0m16rpdEVxyRQlm2dZ
         hDRqbTIGUQi+Vqa+j2lzZgmXt37RIVSxofNatCRvnfdBaUXPtihaj4L5Ro3QBv30SO
         qNLTLIpLbXSzPFynG2eQVOxPrVDjTpRf+Lrccos0=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 7/8] arm64: Detect kretprobed functions in stack trace
Date:   Mon, 15 Mar 2021 11:57:59 -0500
Message-Id: <20210315165800.5948-8-madvenka@linux.microsoft.com>
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

When a kretprobe is active for a function, the function's return address
in its stack frame is modified to point to the kretprobe trampoline. When
the function returns, the frame is popped and control is transferred
to the trampoline. The trampoline eventually returns to the original return
address.

If a stack walk is done within the function (or any functions that get
called from there), the stack trace will only show the trampoline and the
not the original caller. Detect this and mark the stack trace as unreliable.

Also, if the trampoline and the functions it calls do a stack trace,
that stack trace will also have the same problem. Detect this as well.

This is done by looking up the symbol table entry for the trampoline
and checking if the return PC in a frame falls anywhere in the
trampoline function.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 358aae3906d7..752b77f11c61 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,26 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+#ifdef CONFIG_KRETPROBES
+static bool kretprobe_detected(struct stackframe *frame)
+{
+	static char kretprobe_name[KSYM_NAME_LEN];
+	static unsigned long kretprobe_pc, kretprobe_end_pc;
+	unsigned long pc, offset, size;
+
+	if (!kretprobe_pc) {
+		pc = (unsigned long) kretprobe_trampoline;
+		if (!kallsyms_lookup(pc, &size, &offset, NULL, kretprobe_name))
+			return false;
+
+		kretprobe_pc = pc - offset;
+		kretprobe_end_pc = kretprobe_pc + size;
+	}
+
+	return frame->pc >= kretprobe_pc && frame->pc < kretprobe_end_pc;
+}
+#endif
+
 static void check_if_reliable(unsigned long fp, struct stackframe *frame,
 			      struct stack_info *info)
 {
@@ -111,6 +131,29 @@ static void check_if_reliable(unsigned long fp, struct stackframe *frame,
 		frame->reliable = false;
 		return;
 	}
+
+#ifdef CONFIG_KRETPROBES
+	/*
+	 * The return address of a function that has an active kretprobe
+	 * is modified in the stack frame to point to a trampoline. So,
+	 * the original return address is not available on the stack.
+	 *
+	 * A stack trace taken while executing the function (and its
+	 * descendants) will not show the original caller. So, mark the
+	 * stack trace as unreliable if the trampoline shows up in the
+	 * stack trace. (Obtaining the original return address from
+	 * task->kretprobe_instances seems problematic and not worth the
+	 * effort).
+	 *
+	 * The stack trace taken while inside the trampoline and functions
+	 * called by the trampoline have the same problem as above. This
+	 * is also covered by kretprobe_detected() using a range check.
+	 */
+	if (kretprobe_detected(frame)) {
+		frame->reliable = false;
+		return;
+	}
+#endif
 }
 
 /*
-- 
2.25.1

