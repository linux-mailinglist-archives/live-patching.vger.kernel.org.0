Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63BF42E6A6
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhJOChI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 22:37:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55492 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbhJOChG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 22:37:06 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 94E2720B9D20;
        Thu, 14 Oct 2021 19:34:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94E2720B9D20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634265300;
        bh=AbsOg32zRR78sDGzy2GosMMSEjrzSM+M26cFHMLFAG8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AxuPDl0EUp2jhKj8zy5MtH4Otfmi0NjlrRhtyg44gpP6SeHWkhDCIaxi+1/WG6qMb
         5Jan6CTcJFzchLGAEGHOBlKXpoiHfa7xbAONA5ow7bOrmvUNduGEdNbhdZQw6pSZk7
         vjQVKoRPHlfprnS3+Rq45Yi+guBCYNfPIL4mNUXs=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v9 06/11] arm64: Make profile_pc() use arch_stack_walk()
Date:   Thu, 14 Oct 2021 21:34:10 -0500
Message-Id: <20211015023413.16614-9-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015023413.16614-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015023413.16614-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, profile_pc() in ARM64 code walks the stack using
start_backtrace() and unwind_frame(). Make it use arch_stack_walk()
instead. This makes maintenance easier.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/time.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index eebbc8d7123e..671b3038a772 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -32,22 +32,26 @@
 #include <asm/stacktrace.h>
 #include <asm/paravirt.h>
 
+static bool profile_pc_cb(void *arg, unsigned long pc)
+{
+	unsigned long *prof_pc = arg;
+
+	if (in_lock_functions(pc))
+		return true;
+	*prof_pc = pc;
+	return false;
+}
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
-	struct stackframe frame;
+	unsigned long prof_pc = 0;
 
 	if (!in_lock_functions(regs->pc))
 		return regs->pc;
 
-	start_backtrace(&frame, regs->regs[29], regs->pc);
-
-	do {
-		int ret = unwind_frame(NULL, &frame);
-		if (ret < 0)
-			return 0;
-	} while (in_lock_functions(frame.pc));
+	arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
 
-	return frame.pc;
+	return prof_pc;
 }
 EXPORT_SYMBOL(profile_pc);
 
-- 
2.25.1

