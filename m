Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E668542E6F3
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhJODBT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:01:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58208 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbhJODBO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:01:14 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id B322F20B9D1C;
        Thu, 14 Oct 2021 19:59:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B322F20B9D1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634266748;
        bh=6B7i9QOJfwrh+wxsghOjM0WArHrFBqgVADtSVHWaIEc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=d7uyPZv+p8dYxXcYWpR32heWbtlRQTgc4hoffwxvEahiv1IcOtnKC4m30tHWEAGNA
         WWpCsqZNR8+gGKVnmsuP5mOR5IJf+VxRU/MsdAaLOm1dUWziBywOO8XEg/ZXYplFRY
         cRMWBMxxrC4U9jZ232TwkUuJANMi37mMXKka9D0k=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v10 05/11] arm64: Make dump_stacktrace() use arch_stack_walk()
Date:   Thu, 14 Oct 2021 21:58:41 -0500
Message-Id: <20211015025847.17694-6-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015025847.17694-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, dump_stacktrace() in ARM64 code walks the stack using
start_backtrace() and unwind_frame(). Make it use arch_stack_walk()
instead. This makes maintenance easier.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 44 +++++-----------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8982a2b78acf..776c4debb5a7 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -151,24 +151,20 @@ void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 }
 NOKPROBE_SYMBOL(walk_stackframe);
 
-static void dump_backtrace_entry(unsigned long where, const char *loglvl)
+static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
+	char *loglvl = arg;
 	printk("%s %pSb\n", loglvl, (void *)where);
+	return true;
 }
 
 void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 		    const char *loglvl)
 {
-	struct stackframe frame;
-	int skip = 0;
-
 	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
 
-	if (regs) {
-		if (user_mode(regs))
-			return;
-		skip = 1;
-	}
+	if (regs && user_mode(regs))
+		return;
 
 	if (!tsk)
 		tsk = current;
@@ -176,36 +172,8 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 	if (!try_get_task_stack(tsk))
 		return;
 
-	if (tsk == current) {
-		start_backtrace(&frame,
-				(unsigned long)__builtin_frame_address(0),
-				(unsigned long)dump_backtrace);
-	} else {
-		/*
-		 * task blocked in __switch_to
-		 */
-		start_backtrace(&frame,
-				thread_saved_fp(tsk),
-				thread_saved_pc(tsk));
-	}
-
 	printk("%sCall trace:\n", loglvl);
-	do {
-		/* skip until specified stack frame */
-		if (!skip) {
-			dump_backtrace_entry(frame.pc, loglvl);
-		} else if (frame.fp == regs->regs[29]) {
-			skip = 0;
-			/*
-			 * Mostly, this is the case where this function is
-			 * called in panic/abort. As exception handler's
-			 * stack frame does not contain the corresponding pc
-			 * at which an exception has taken place, use regs->pc
-			 * instead.
-			 */
-			dump_backtrace_entry(regs->pc, loglvl);
-		}
-	} while (!unwind_frame(tsk, &frame));
+	arch_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs);
 
 	put_task_stack(tsk);
 }
-- 
2.25.1

