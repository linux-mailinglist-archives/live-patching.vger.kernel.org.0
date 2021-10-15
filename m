Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B394442E6A0
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhJOChE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 22:37:04 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55432 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbhJOChB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 22:37:01 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4AAAC20B9D20;
        Thu, 14 Oct 2021 19:34:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4AAAC20B9D20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634265296;
        bh=FmJbGXiSP+JGonZTp90DkLqCm4FVOelAbFqDoqqHdv4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VwZFmiQp0tA/bogXQs+nNJUxiSpIgDFSq6xS5hehRanndLGGpQ7XPt7Pj64SKCwgd
         JVikcRCcstvrpHrc8OuQoaCqdWHR6OCevI3gdDEDFhaLoGjSxhGXRVjy+nlHCMsvwR
         Ton0mwr5oSnVE10tSnnK/4fzZkFYhLJUBurWWX+w=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v9 02/11] arm64: Make perf_callchain_kernel() use arch_stack_walk()
Date:   Thu, 14 Oct 2021 21:34:06 -0500
Message-Id: <20211015023413.16614-5-madvenka@linux.microsoft.com>
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

Currently, perf_callchain_kernel() in ARM64 code walks the stack using
start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
instead. This makes maintenance easier.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/perf_callchain.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 4a72c2727309..f173c448e852 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -140,22 +140,18 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 static bool callchain_trace(void *data, unsigned long pc)
 {
 	struct perf_callchain_entry_ctx *entry = data;
-	perf_callchain_store(entry, pc);
-	return true;
+	return perf_callchain_store(entry, pc) == 0;
 }
 
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
-	struct stackframe frame;
-
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
 
-	start_backtrace(&frame, regs->regs[29], regs->pc);
-	walk_stackframe(current, &frame, callchain_trace, entry);
+	arch_stack_walk(callchain_trace, entry, current, regs);
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
-- 
2.25.1

