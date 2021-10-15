Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F9842E6A3
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhJOChF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 22:37:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55442 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhJOChC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 22:37:02 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5D32620B9D21;
        Thu, 14 Oct 2021 19:34:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D32620B9D21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634265297;
        bh=g5fdmzSduoUMkjQHmQa/fhtE8jC0SUmUZcxIW9qvvbk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EOQ4p0HojTauGxaXASPK4GU4vDOJa3UVPC24jbgsqCyZpmxKDiWWo88cajPvWByXK
         9drraQdhEYYqc/Dv13E31bHo8IcLxqcMGbDUIwksDgMw9TsJh6HJbQVU38QMBkhmGF
         /jB/cgQWCOsXURyG6hu7O17Md0lH37cTxD6wpqY4=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v9 03/11] arm64: Make get_wchan() use arch_stack_walk()
Date:   Thu, 14 Oct 2021 21:34:07 -0500
Message-Id: <20211015023413.16614-6-madvenka@linux.microsoft.com>
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

Currently, get_wchan() in ARM64 code walks the stack using start_backtrace()
and unwind_frame(). Make it use arch_stack_walk() instead. This makes
maintenance easier.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/process.c | 38 ++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index c8989b999250..48ed89acce0d 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -544,11 +544,27 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	return last;
 }
 
+struct wchan_info {
+	unsigned long	pc;
+	int		count;
+};
+
+static bool get_wchan_cb(void *arg, unsigned long pc)
+{
+	struct wchan_info *wchan_info = arg;
+
+	if (!in_sched_functions(pc)) {
+		wchan_info->pc = pc;
+		return false;
+	}
+	return wchan_info->count++ < 16;
+}
+
 unsigned long get_wchan(struct task_struct *p)
 {
-	struct stackframe frame;
-	unsigned long stack_page, ret = 0;
-	int count = 0;
+	unsigned long stack_page;
+	struct wchan_info wchan_info;
+
 	if (!p || p == current || task_is_running(p))
 		return 0;
 
@@ -556,20 +572,12 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!stack_page)
 		return 0;
 
-	start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
+	wchan_info.pc = 0;
+	wchan_info.count = 0;
+	arch_stack_walk(get_wchan_cb, &wchan_info, p, NULL);
 
-	do {
-		if (unwind_frame(p, &frame))
-			goto out;
-		if (!in_sched_functions(frame.pc)) {
-			ret = frame.pc;
-			goto out;
-		}
-	} while (count++ < 16);
-
-out:
 	put_task_stack(p);
-	return ret;
+	return wchan_info.pc;
 }
 
 unsigned long arch_align_stack(unsigned long sp)
-- 
2.25.1

