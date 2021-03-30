Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EBD34F174
	for <lists+live-patching@lfdr.de>; Tue, 30 Mar 2021 21:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhC3TK0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Mar 2021 15:10:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33666 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhC3TKH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Mar 2021 15:10:07 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0607C20B5683;
        Tue, 30 Mar 2021 12:10:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0607C20B5683
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617131406;
        bh=tG53wNZpf8HBZJKuIfmKDNwBoTuKOAvtDqAtxH3M2v0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Rb2oJC71omuekDN5ZjPznt6w7CJFxUAwPMV1nc5iwpLcnYy02Kn3eLR/PnzsROHS6
         CHvro9WlnChrnD4/L3Jf8hzFGWVMQcQr5OcD0aDZjhfw4SBAbYChL3Ti0h/kE/wVNj
         QruGMqLmy7dE7nEtXQWwfCZJIc9sMUxX7ijnSInc=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 4/4] arm64: Mark stack trace as unreliable if kretprobed functions are present
Date:   Tue, 30 Mar 2021 14:09:55 -0500
Message-Id: <20210330190955.13707-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330190955.13707-1-madvenka@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
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
not the original caller.

Also, if the trampoline itself and the functions it calls do a stack trace,
that stack trace will also have the same problem. Detect this as well.

If the trampoline is detected in the stack trace, mark the stack trace
as unreliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 37 ++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8b493a90c9f3..bf5abb0dd876 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -97,6 +97,36 @@ struct function_range {
  *     if return_to_handler is detected on the stack.
  *
  * NOTE: The unwinder must do (1) before (2).
+ *
+ * KPROBES
+ * =======
+ *
+ *	There are two types of kprobes:
+ *
+ *	(1) Regular kprobes that are placed anywhere in a probed function.
+ *	    This is implemented by replacing the probed instruction with a
+ *	    breakpoint. When the breakpoint is hit, the kprobe code emulates
+ *	    the original instruction in-situ and returns to the next
+ *	    instruction.
+ *
+ *	    Breakpoints are EL1 exceptions. When the unwinder detects them,
+ *	    the stack trace is marked as unreliable as it does not know where
+ *	    exactly the exception happened. Detection of EL1 exceptions in
+ *	    a stack trace will be done separately.
+ *
+ *	(2) Return kprobes that are placed on the return of a probed function.
+ *	    In this case, Kprobes sets up an initial breakpoint at the
+ *	    beginning of the probed function. When the breakpoint is hit,
+ *	    Kprobes replaces the return address in the stack frame with the
+ *	    kretprobe_trampoline and records the original return address.
+ *	    When the probed function returns, control goes to the trampoline
+ *	    which eventually returns to the original return address.
+ *
+ *	    Stack traces taken while in the probed function or while in the
+ *	    trampoline will show kretprobe_trampoline instead of the original
+ *	    return address. Detect this and mark the stack trace unreliable.
+ *	    The detection is done by checking if the return PC falls anywhere
+ *	    in kretprobe_trampoline.
  */
 static struct function_range	special_functions[] = {
 	/*
@@ -121,6 +151,13 @@ static struct function_range	special_functions[] = {
 #endif
 #endif
 
+	/*
+	 * Kprobe trampolines.
+	 */
+#ifdef CONFIG_KRETPROBES
+	{ (unsigned long) kretprobe_trampoline, 0 },
+ #endif
+
 	{ 0, 0 }
 };
 
-- 
2.25.1

